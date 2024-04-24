Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF9EB129A9C
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713929311; cv=none; b=KO34AN0cMV65NR2Fc7DXthmxu4EgEBDVrPab1HOpgqmGsl0vMfN2usyHCj/jb8rdlX1KqJH8YTFz4pCypj5U3kcdshpom9u5+BppOg6gXLm998Xh4hzO7DKnJdurwrhl8vdcPTeoWBiMC45vl4z4UDKSzgLGdVYzXCQVDmaRhyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713929311; c=relaxed/simple;
	bh=Ptdikgx+p5cbC78Jj+wjzIwYo+inNhZtWeopTgJfDYw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=io8l6GS5LmsQF+F+xGN4v4RMUJJ/V0AmWXoEwGSQQkhhb0fjs++75CzNwRhrGTh0Q9hB4FUV7wa9RlRdxxM+PngV8NYOiA3hL0KvlFAQ9emMlsUlngSm3acLZ5BKTuiil63AypOCaukNolBTdfl2jB6u0YVhx2GbmYZ9gkSMh9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yf77ADYu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yf77ADYu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA172C116B1;
	Wed, 24 Apr 2024 03:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713929310;
	bh=Ptdikgx+p5cbC78Jj+wjzIwYo+inNhZtWeopTgJfDYw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Yf77ADYu7MYsI0DuOcdVa98n9nVuhmfMsSpfmGT8Nj+Riv+EkK2WTjNe2uzH+pP2j
	 Zp78EVOFwvV3HsS+RlQGdd7yLma37vb0Af0RT3p60w9OMtiMfUYN1AKuEz9n4jCglV
	 +3mGSNMjjC1JB2DFJSOuJhBuFQm5cmYrsCfVdYTGxJKGPJOE5PkC3mEHrvNfMiYAyu
	 0ZK+FR3fsdPxbdbIRw8U6W2NlV8hJi62eD/doINgARcOdeUfhixklS6kd7jvuIe/YS
	 JQq7bjKtMz6lOvneh2CXD6MUQ9cDBq4oXgxMD7mqG5qYAASTQRiky0JFtvyQi+vD7h
	 d2BESVxFPCRFQ==
Date: Tue, 23 Apr 2024 20:28:30 -0700
Subject: [PATCH 1/2] xfs: use dontcache for grabbing inodes during scrub
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171392786048.1907355.7613339211894472671.stgit@frogsfrogsfrogs>
In-Reply-To: <171392786026.1907355.15363148011407104351.stgit@frogsfrogsfrogs>
References: <171392786026.1907355.15363148011407104351.stgit@frogsfrogsfrogs>
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

Back when I wrote commit a03297a0ca9f2, I had thought that we'd be doing
users a favor by only marking inodes dontcache at the end of a scrub
operation, and only if there's only one reference to that inode.  This
was more or less true back when I_DONTCACHE was an XFS iflag and the
only thing it did was change the outcome of xfs_fs_drop_inode to 1.

Note: If there are dentries pointing to the inode when scrub finishes,
the inode will have positive i_count and stay around in cache until
dentry reclaim.

But now we have d_mark_dontcache, which cause the inode *and* the
dentries attached to it all to be marked I_DONTCACHE, which means that
we drop the dentries ASAP, which drops the inode ASAP.

This is bad if scrub found problems with the inode, because now they can
be scheduled for inactivation, which can cause inodegc to trip on it and
shut down the filesystem.

Even if the inode isn't bad, this is still suboptimal because phases 3-7
each initiate inode scans.  Dropping the inode immediately during phase
3 is silly because phase 5 will reload it and drop it immediately, etc.
It's fine to mark the inodes dontcache, but if there have been accesses
to the file that set up dentries, we should keep them.

I validated this by setting up ftrace to capture xfs_iget_recycle*
tracepoints and ran xfs/285 for 30 seconds.  With current djwong-wtf I
saw ~30,000 recycle events.  I then dropped the d_mark_dontcache calls
and set XFS_IGET_DONTCACHE, and the recycle events dropped to ~5,000 per
30 seconds.

Therefore, grab the inode with XFS_IGET_DONTCACHE, which only has the
effect of setting I_DONTCACHE for cache misses.  Remove the
d_mark_dontcache call that can happen in xchk_irele.

Fixes: a03297a0ca9f2 ("xfs: manage inode DONTCACHE status at irele time")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/common.c |   12 +++---------
 fs/xfs/scrub/iscan.c  |   13 +++++++++++--
 fs/xfs/scrub/scrub.h  |    7 +++++++
 3 files changed, 21 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index a7d3a2279662..1ad8ec63a7f4 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -783,7 +783,7 @@ xchk_iget(
 {
 	ASSERT(sc->tp != NULL);
 
-	return xfs_iget(sc->mp, sc->tp, inum, XFS_IGET_UNTRUSTED, 0, ipp);
+	return xfs_iget(sc->mp, sc->tp, inum, XCHK_IGET_FLAGS, 0, ipp);
 }
 
 /*
@@ -834,8 +834,8 @@ xchk_iget_agi(
 	if (error)
 		return error;
 
-	error = xfs_iget(mp, tp, inum,
-			XFS_IGET_NORETRY | XFS_IGET_UNTRUSTED, 0, ipp);
+	error = xfs_iget(mp, tp, inum, XFS_IGET_NORETRY | XCHK_IGET_FLAGS, 0,
+			ipp);
 	if (error == -EAGAIN) {
 		/*
 		 * The inode may be in core but temporarily unavailable and may
@@ -1062,12 +1062,6 @@ xchk_irele(
 		spin_lock(&VFS_I(ip)->i_lock);
 		VFS_I(ip)->i_state &= ~I_DONTCACHE;
 		spin_unlock(&VFS_I(ip)->i_lock);
-	} else if (atomic_read(&VFS_I(ip)->i_count) == 1) {
-		/*
-		 * If this is the last reference to the inode and the caller
-		 * permits it, set DONTCACHE to avoid thrashing.
-		 */
-		d_mark_dontcache(VFS_I(ip));
 	}
 
 	xfs_irele(ip);
diff --git a/fs/xfs/scrub/iscan.c b/fs/xfs/scrub/iscan.c
index c380207702e2..cf9d983667ce 100644
--- a/fs/xfs/scrub/iscan.c
+++ b/fs/xfs/scrub/iscan.c
@@ -407,6 +407,15 @@ xchk_iscan_iget_retry(
 	return -EAGAIN;
 }
 
+/*
+ * For an inode scan, we hold the AGI and want to try to grab a batch of
+ * inodes.  Holding the AGI prevents inodegc from clearing freed inodes,
+ * so we must use noretry here.  For every inode after the first one in the
+ * batch, we don't want to wait, so we use retry there too.  Finally, use
+ * dontcache to avoid polluting the cache.
+ */
+#define ISCAN_IGET_FLAGS	(XFS_IGET_NORETRY | XFS_IGET_DONTCACHE)
+
 /*
  * Grab an inode as part of an inode scan.  While scanning this inode, the
  * caller must ensure that no other threads can modify the inode until a call
@@ -434,7 +443,7 @@ xchk_iscan_iget(
 	ASSERT(iscan->__inodes[0] == NULL);
 
 	/* Fill the first slot in the inode array. */
-	error = xfs_iget(sc->mp, sc->tp, ino, XFS_IGET_NORETRY, 0,
+	error = xfs_iget(sc->mp, sc->tp, ino, ISCAN_IGET_FLAGS, 0,
 			&iscan->__inodes[idx]);
 
 	trace_xchk_iscan_iget(iscan, error);
@@ -507,7 +516,7 @@ xchk_iscan_iget(
 
 		ASSERT(iscan->__inodes[idx] == NULL);
 
-		error = xfs_iget(sc->mp, sc->tp, ino, XFS_IGET_NORETRY, 0,
+		error = xfs_iget(sc->mp, sc->tp, ino, ISCAN_IGET_FLAGS, 0,
 				&iscan->__inodes[idx]);
 		if (error)
 			break;
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 4e7e3edb6350..1da10182f7f4 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -60,6 +60,13 @@ static inline int xchk_maybe_relax(struct xchk_relax *widget)
 #define XCHK_GFP_FLAGS	((__force gfp_t)(GFP_KERNEL | __GFP_NOWARN | \
 					 __GFP_RETRY_MAYFAIL))
 
+/*
+ * For opening files by handle for fsck operations, we don't trust the inumber
+ * or the allocation state; therefore, perform an untrusted lookup.  We don't
+ * want these inodes to pollute the cache, so mark them for immediate removal.
+ */
+#define XCHK_IGET_FLAGS	(XFS_IGET_UNTRUSTED | XFS_IGET_DONTCACHE)
+
 /* Type info and names for the scrub types. */
 enum xchk_type {
 	ST_NONE = 1,	/* disabled */

