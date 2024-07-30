Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D797F646
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722300795; cv=none; b=Y+5dpFGlTO67u5zDgg1nP7kMe7u/gryQtPrTt+4OEWmCxdapdgBqcqV7xRbeDmCCrmqLfve0QpMYGb+ktB2sSVee1/xgyFLmNHQ1YhjNylmm9/Vt+VyjOSssWGxeXJaMvqUndOhThrKP97xMerx8QXR2OuhabqWxn9CUnthdlQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722300795; c=relaxed/simple;
	bh=P8t9oW+470k2RMY1bYf/1w4HnT17gFkiTGuLONp3M4A=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uLixYSzTt4nP8/eCFv6KpEC7JPxfd9Mehy079H1suhRjf4Ken7ATBv+6wu4fpl62VeWSIetMaZP4Xwlaw5I97jwuoxfmHsvGjFXIHIfwS/A7hJdfeqDRiQPrGToDw5RTjYITTmBp2Y+nWxvu85o/ybh4LHKRf26qys1P0YW2tcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MxL6U9lO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MxL6U9lO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE0B6C32786;
	Tue, 30 Jul 2024 00:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722300795;
	bh=P8t9oW+470k2RMY1bYf/1w4HnT17gFkiTGuLONp3M4A=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=MxL6U9lOZGGBbKm41YpuFomQnHTZ9wXWbgOfm2orCqqAcrEl+//4iQQqJ9F5A3u9d
	 kcFzbrR6xnpvFbYmrB4W+Z+/zvMHE5u75KXQYYfvvSDsrtWlWm/tcpe7jTKGJw0Eii
	 faQk7avhRx/LP/+FMX7b9HaDioDoG435mID85VERg/57iclYnQuFkrNNCGLXJvoht4
	 RVJx+osCHzFlpC1wx+7gPZU6rxEPYCgskTZoW4QgZJ8hu09Hs9gcqqXyLnq0+kOXTq
	 21Hq+fmCnnbFOL7FSdSIlw9mumGThBYjp+kEl3MhCkEUxK/ELyi0vH6IN/LIDl15+V
	 EjLCeiTRJjkng==
Date: Mon, 29 Jul 2024 17:53:15 -0700
Subject: [PATCH 113/115] xfs: restrict when we try to align cow fork delalloc
 to cowextsz hints
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Chandan Babu R <chandanbabu@kernel.org>,
 linux-xfs@vger.kernel.org
Message-ID: <172229844030.1338752.4439274179388747119.stgit@frogsfrogsfrogs>
In-Reply-To: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
References: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 288e1f693f04e66be99f27e7cbe4a45936a66745

xfs/205 produces the following failure when always_cow is enabled:

This is the result of overly aggressive attempts to align cow fork
delalloc reservations to the CoW extent size hint.  Looking at the trace
data, we're trying to append a single fsblock to the "fred" file.
Trying to create a speculative post-eof reservation fails because
there's not enough space.

We then set @prealloc_blocks to zero and try again, but the cowextsz
alignment code triggers, which expands our request for a 1-fsblock
reservation into a 39-block reservation.  There's not enough space for
that, so the whole write fails with ENOSPC even though there's
sufficient space in the filesystem to allocate the single block that we
need to land the write.

There are two things wrong here -- first, we shouldn't be attempting
speculative preallocations beyond what was requested when we're low on
space.  Second, if we've already computed a posteof preallocation, we
shouldn't bother trying to align that to the cowextsize hint.

Fix both of these problems by adding a flag that only enables the
expansion of the delalloc reservation to the cowextsize if we're doing a
non-extending write, and only if we're not doing an ENOSPC retry.  This
requires us to move the ENOSPC retry logic to xfs_bmapi_reserve_delalloc.

I probably should have caught this six years ago when 6ca30729c206d was
being reviewed, but oh well.  Update the comments to reflect what the
code does now.

Fixes: 6ca30729c206d ("xfs: bmap code cleanup")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 include/xfs_trace.h |    1 +
 libxfs/xfs_bmap.c   |   31 +++++++++++++++++++++++++++----
 2 files changed, 28 insertions(+), 4 deletions(-)


diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index 2e5e89d65..fe0854b20 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -68,6 +68,7 @@
 #define trace_xfs_log_recover_item_add(a,b,c,d)	((void) 0)
 
 #define trace_xfs_da_btree_corrupt(a,b)		((void) 0)
+#define trace_xfs_delalloc_enospc(...)		((void) 0)
 #define trace_xfs_btree_corrupt(a,b)		((void) 0)
 #define trace_xfs_btree_updkeys(a,b,c)		((void) 0)
 #define trace_xfs_btree_overlapped_query_range(a,b,c)	((void) 0)
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index a0dda4640..e60d11470 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -4052,20 +4052,32 @@ xfs_bmapi_reserve_delalloc(
 	xfs_extlen_t		indlen;
 	uint64_t		fdblocks;
 	int			error;
-	xfs_fileoff_t		aoff = off;
+	xfs_fileoff_t		aoff;
+	bool			use_cowextszhint =
+					whichfork == XFS_COW_FORK && !prealloc;
 
+retry:
 	/*
 	 * Cap the alloc length. Keep track of prealloc so we know whether to
 	 * tag the inode before we return.
 	 */
+	aoff = off;
 	alen = XFS_FILBLKS_MIN(len + prealloc, XFS_MAX_BMBT_EXTLEN);
 	if (!eof)
 		alen = XFS_FILBLKS_MIN(alen, got->br_startoff - aoff);
 	if (prealloc && alen >= len)
 		prealloc = alen - len;
 
-	/* Figure out the extent size, adjust alen */
-	if (whichfork == XFS_COW_FORK) {
+	/*
+	 * If we're targetting the COW fork but aren't creating a speculative
+	 * posteof preallocation, try to expand the reservation to align with
+	 * the COW extent size hint if there's sufficient free space.
+	 *
+	 * Unlike the data fork, the CoW cancellation functions will free all
+	 * the reservations at inactivation, so we don't require that every
+	 * delalloc reservation have a dirty pagecache.
+	 */
+	if (use_cowextszhint) {
 		struct xfs_bmbt_irec	prev;
 		xfs_extlen_t		extsz = xfs_get_cowextsz_hint(ip);
 
@@ -4084,7 +4096,7 @@ xfs_bmapi_reserve_delalloc(
 	 */
 	error = xfs_quota_reserve_blkres(ip, alen);
 	if (error)
-		return error;
+		goto out;
 
 	/*
 	 * Split changing sb for alen and indlen since they could be coming
@@ -4134,6 +4146,17 @@ xfs_bmapi_reserve_delalloc(
 out_unreserve_quota:
 	if (XFS_IS_QUOTA_ON(mp))
 		xfs_quota_unreserve_blkres(ip, alen);
+out:
+	if (error == -ENOSPC || error == -EDQUOT) {
+		trace_xfs_delalloc_enospc(ip, off, len);
+
+		if (prealloc || use_cowextszhint) {
+			/* retry without any preallocation */
+			use_cowextszhint = false;
+			prealloc = 0;
+			goto retry;
+		}
+	}
 	return error;
 }
 

