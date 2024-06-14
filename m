Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2993B374FE
	for <linux-xfs@vger.kernel.org>; Fri, 14 Jun 2024 04:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718340123; cv=none; b=BkpNLmG+/xzkJEf2D64HeYZQspyjsieaPzEsd/NsDBNkfZ0rqwlwEUO9l/e+nvsc+b5cx+4HzA11duNSo9jFYEaUtqmn6wUo3r56Pq9ytfWX5fLqB8sUNka1vScw7f0SajUdE/JMcGApEZbZs7mPxMcYTCaMKndGRqdlQFuhr8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718340123; c=relaxed/simple;
	bh=+p6ydes+2pARVYdzCFGFtmQQfSTQSptajFxzQwcNYBk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pk7/DFIr88RYvvp5ui+ztDBsuT69AzS9kb6GJvqqHKwXLacPUE7dHYod8IMbLQZT4ez9xFBLfYlwQzRel1FzWGH2OJxjeseu5pxMJLGN74TiwvnLuatEic/tidTy/IiUMKBSBa41F0G7SgP7Knqr4XNwh8YvxsfK/zaUiUEBI5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4BC3D68C4E; Fri, 14 Jun 2024 06:41:56 +0200 (CEST)
Date: Fri, 14 Jun 2024 06:41:55 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, chandanbabu@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs: restrict when we try to align cow fork
 delalloc to cowextsz hints
Message-ID: <20240614044155.GA9084@lst.de>
References: <171821431745.3202459.12391135011047294097.stgit@frogsfrogsfrogs> <171821431812.3202459.13352462937816171357.stgit@frogsfrogsfrogs> <20240613050613.GC17048@lst.de> <20240614041310.GG6125@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240614041310.GG6125@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jun 13, 2024 at 09:13:10PM -0700, Darrick J. Wong wrote:
> > Looking at the caller below I don't think we need the use_cowextszhint
> > flag here, we can just locally check for prealloc beeing non-0 in
> > the branch below:
> 
> That won't work, because xfs_buffered_write_iomap_begin only sets
> @prealloc to nonzero if it thinks is an extending write.  For the cow
> fork, we create delalloc reservations that are aligned to the cowextsize
> value for overwrites below eof.

Yeah.  For that we'd need to move the retry loop into
xfs_bmapi_reserve_delalloc - which honestly feels like the more logical
place for it anyway.  As in the untested version below, also note
my XXX comment about a comment being added:

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index c101cf266bc4db..58ff21cb84e0f5 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4059,19 +4059,33 @@ xfs_bmapi_reserve_delalloc(
 	uint64_t		fdblocks;
 	int			error;
 	xfs_fileoff_t		aoff = off;
+	bool			use_cowextszhint =
+		whichfork == XFS_COW_FORK && !prealloc;
 
 	/*
 	 * Cap the alloc length. Keep track of prealloc so we know whether to
 	 * tag the inode before we return.
 	 */
+retry:
 	alen = XFS_FILBLKS_MIN(len + prealloc, XFS_MAX_BMBT_EXTLEN);
 	if (!eof)
 		alen = XFS_FILBLKS_MIN(alen, got->br_startoff - aoff);
 	if (prealloc && alen >= len)
 		prealloc = alen - len;
 
-	/* Figure out the extent size, adjust alen */
-	if (whichfork == XFS_COW_FORK) {
+	/*
+	 * If we're targeting the COW fork but aren't creating a speculative
+	 * posteof preallocation, try to expand the reservation to align with
+	 * the cow extent size hint if there's sufficient free space.
+	 *
+	 * Unlike the data fork, the CoW cancellation functions will free all
+	 * the reservations at inactivation, so we don't require that every
+	 * delalloc reservation have a dirty pagecache.
+	 *
+	 * XXX(hch): I can't see where we actually require dirty pagecache
+	 * for speculative data fork preallocations.  What am I missing?
+	 */
+	if (use_cowextszhint) {
 		struct xfs_bmbt_irec	prev;
 		xfs_extlen_t		extsz = xfs_get_cowextsz_hint(ip);
 
@@ -4090,7 +4104,7 @@ xfs_bmapi_reserve_delalloc(
 	 */
 	error = xfs_quota_reserve_blkres(ip, alen);
 	if (error)
-		return error;
+		goto out;
 
 	/*
 	 * Split changing sb for alen and indlen since they could be coming
@@ -4140,6 +4154,16 @@ xfs_bmapi_reserve_delalloc(
 out_unreserve_quota:
 	if (XFS_IS_QUOTA_ON(mp))
 		xfs_quota_unreserve_blkres(ip, alen);
+out:
+	if (error == -ENOSPC || error == -EDQUOT) {
+		trace_xfs_delalloc_enospc(ip, off, len);
+		if (prealloc || use_cowextszhint) {
+			/* retry without any preallocation */
+			prealloc = 0;
+			use_cowextszhint = false;
+			goto retry;
+		}
+	}
 	return error;
 }
 
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 3783426739258c..34cce017fe7ce1 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1148,27 +1148,13 @@ xfs_buffered_write_iomap_begin(
 		}
 	}
 
-retry:
 	error = xfs_bmapi_reserve_delalloc(ip, allocfork, offset_fsb,
 			end_fsb - offset_fsb, prealloc_blocks,
 			allocfork == XFS_DATA_FORK ? &imap : &cmap,
 			allocfork == XFS_DATA_FORK ? &icur : &ccur,
 			allocfork == XFS_DATA_FORK ? eof : cow_eof);
-	switch (error) {
-	case 0:
-		break;
-	case -ENOSPC:
-	case -EDQUOT:
-		/* retry without any preallocation */
-		trace_xfs_delalloc_enospc(ip, offset, count);
-		if (prealloc_blocks) {
-			prealloc_blocks = 0;
-			goto retry;
-		}
-		fallthrough;
-	default:
+	if (error)
 		goto out_unlock;
-	}
 
 	if (allocfork == XFS_COW_FORK) {
 		trace_xfs_iomap_alloc(ip, offset, count, allocfork, &cmap);
