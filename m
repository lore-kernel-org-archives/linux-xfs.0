Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78D62FBF3
	for <linux-xfs@vger.kernel.org>; Wed, 12 Jun 2024 17:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718214440; cv=none; b=WPwcldLVei80Cmz3JIf6B+Is0TyUfpugBqrMp6I/CNlg4z5ddOm33bwvt9I10BWr5JTG7RmAWpACA/jncGTkP6r2xvkt4W7gvUKrBhVXL1AnisfF1MosTGv9ceRzxW5cXc8dvdPNSSalSr3CzsVykYmYMD8I8FyKuHGXtG9TQyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718214440; c=relaxed/simple;
	bh=6HFk7DFdnfn1t1g8zNl+iH3Qws4l7Ed9qKzV9nkLcqE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=imRIRVRM4ireFtYz0f6emvFrk+7lxQ7EBFRIccuix3Izfr1vVD1OTiHRzQ/Hdu0MJnsVLvox1me69JdycnmpRjNfQapJGGArT/dlzsnP8fWtq0g00PHdI365JbvEPyqldncyvKQEdWQ0cWmRHYsOs0N8FMQY+JDpzyoZN6Zinyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XxQJRPIP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XxQJRPIP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED1B4C116B1;
	Wed, 12 Jun 2024 17:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718214440;
	bh=6HFk7DFdnfn1t1g8zNl+iH3Qws4l7Ed9qKzV9nkLcqE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=XxQJRPIPPCDRdZUkgb9l7wwNbPj1q3wXsiDFuVAwg10DoAPlSkI97KIbGNWbnZMT4
	 pukfpJObcLcoqYktbspeYV2l0wtRhqSOhAZOkw1jsqP2/wfY7uk3Z/gTJ/Cvjqcw9J
	 wvP6abWngcxCsP8MInKthgdKzF+0MSKy7Shs99hNgeF4dOl90noYDeJ928UUSpU+P2
	 XYCE6ve6PKzGc7BB8YKpEBYT1PdNx5HwAyLyPOP0iGTK0iI8zWKx4vZCmr5/ty5gK3
	 a8JphWT4zeF1ak9ulHWgYNUWuzqmUcLgM+7aidM9+V2DPPYC0N4iIkPjGaBk0De08u
	 TLXNj5+dtGBUA==
Date: Wed, 12 Jun 2024 10:47:19 -0700
Subject: [PATCH 3/5] xfs: restrict when we try to align cow fork delalloc to
 cowextsz hints
From: "Darrick J. Wong" <djwong@kernel.org>
To: hch@lst.de, djwong@kernel.org, chandanbabu@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <171821431812.3202459.13352462937816171357.stgit@frogsfrogsfrogs>
In-Reply-To: <171821431745.3202459.12391135011047294097.stgit@frogsfrogsfrogs>
References: <171821431745.3202459.12391135011047294097.stgit@frogsfrogsfrogs>
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

xfs/205 produces the following failure when always_cow is enabled:

  --- a/tests/xfs/205.out	2024-02-28 16:20:24.437887970 -0800
  +++ b/tests/xfs/205.out.bad	2024-06-03 21:13:40.584000000 -0700
  @@ -1,4 +1,5 @@
   QA output created by 205
   *** one file
  +   !!! disk full (expected)
   *** one file, a few bytes at a time
   *** done

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
non-extending write, and only if we're not doing an ENOSPC retry.

I probably should have caught this six years ago when 6ca30729c206d was
being reviewed, but oh well.  Update the comments to reflect what the
code does now.

Fixes: 6ca30729c206d ("xfs: bmap code cleanup")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c |   14 +++++++++++---
 fs/xfs/libxfs/xfs_bmap.h |    2 +-
 fs/xfs/xfs_iomap.c       |   14 ++++++++++++--
 3 files changed, 24 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index c101cf266bc4..0dc4ff2fe751 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4050,7 +4050,8 @@ xfs_bmapi_reserve_delalloc(
 	xfs_filblks_t		prealloc,
 	struct xfs_bmbt_irec	*got,
 	struct xfs_iext_cursor	*icur,
-	int			eof)
+	int			eof,
+	bool			use_cowextszhint)
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
@@ -4070,8 +4071,15 @@ xfs_bmapi_reserve_delalloc(
 	if (prealloc && alen >= len)
 		prealloc = alen - len;
 
-	/* Figure out the extent size, adjust alen */
-	if (whichfork == XFS_COW_FORK) {
+	/*
+	 * If the caller wants us to do so, try to expand the range of the
+	 * delalloc reservation up and down so that it's aligned with the CoW
+	 * extent size hint.  Unlike the data fork, the CoW cancellation
+	 * functions will free all the reservations at inactivation, so we
+	 * don't require that every delalloc reservation have a dirty
+	 * pagecache.
+	 */
+	if (whichfork == XFS_COW_FORK && use_cowextszhint) {
 		struct xfs_bmbt_irec	prev;
 		xfs_extlen_t		extsz = xfs_get_cowextsz_hint(ip);
 
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 667b0c2b33d1..aa9814649c5b 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -222,7 +222,7 @@ int	xfs_bmap_split_extent(struct xfs_trans *tp, struct xfs_inode *ip,
 int	xfs_bmapi_reserve_delalloc(struct xfs_inode *ip, int whichfork,
 		xfs_fileoff_t off, xfs_filblks_t len, xfs_filblks_t prealloc,
 		struct xfs_bmbt_irec *got, struct xfs_iext_cursor *cur,
-		int eof);
+		int eof, bool use_cowextszhint);
 int	xfs_bmapi_convert_delalloc(struct xfs_inode *ip, int whichfork,
 		xfs_off_t offset, struct iomap *iomap, unsigned int *seq);
 int	xfs_bmap_add_extent_unwritten_real(struct xfs_trans *tp,
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 378342673925..a7d74f871773 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -979,6 +979,7 @@ xfs_buffered_write_iomap_begin(
 	int			error = 0;
 	unsigned int		lockmode = XFS_ILOCK_EXCL;
 	u64			seq;
+	bool			use_cowextszhint = false;
 
 	if (xfs_is_shutdown(mp))
 		return -EIO;
@@ -1148,12 +1149,20 @@ xfs_buffered_write_iomap_begin(
 		}
 	}
 
+	/*
+	 * If we're targetting the COW fork but aren't creating a speculative
+	 * posteof preallocation, try to expand the reservation to align with
+	 * the cow extent size hint if there's sufficient free space.
+	 */
+	if (allocfork == XFS_COW_FORK && !prealloc_blocks)
+		use_cowextszhint = true;
 retry:
 	error = xfs_bmapi_reserve_delalloc(ip, allocfork, offset_fsb,
 			end_fsb - offset_fsb, prealloc_blocks,
 			allocfork == XFS_DATA_FORK ? &imap : &cmap,
 			allocfork == XFS_DATA_FORK ? &icur : &ccur,
-			allocfork == XFS_DATA_FORK ? eof : cow_eof);
+			allocfork == XFS_DATA_FORK ? eof : cow_eof,
+			use_cowextszhint);
 	switch (error) {
 	case 0:
 		break;
@@ -1161,7 +1170,8 @@ xfs_buffered_write_iomap_begin(
 	case -EDQUOT:
 		/* retry without any preallocation */
 		trace_xfs_delalloc_enospc(ip, offset, count);
-		if (prealloc_blocks) {
+		if (prealloc_blocks || use_cowextszhint) {
+			use_cowextszhint = false;
 			prealloc_blocks = 0;
 			goto retry;
 		}

