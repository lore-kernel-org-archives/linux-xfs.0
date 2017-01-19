Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42304 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754236AbdASTAN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 19 Jan 2017 14:00:13 -0500
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7947661BB6
        for <linux-xfs@vger.kernel.org>; Thu, 19 Jan 2017 19:00:14 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id v0JJ0ELC016403
        for <linux-xfs@vger.kernel.org>; Thu, 19 Jan 2017 14:00:14 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 1/3] xfs: pull up iolock from xfs_free_eofblocks()
Date: Thu, 19 Jan 2017 14:00:09 -0500
Message-Id: <1484852411-1137-2-git-send-email-bfoster@redhat.com>
In-Reply-To: <1484852411-1137-1-git-send-email-bfoster@redhat.com>
References: <1484852411-1137-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

xfs_free_eofblocks() requires the IOLOCK_EXCL lock, but is called from
different contexts where the lock may or may not be held. The
need_iolock parameter exists for this reason, to indicate whether
xfs_free_eofblocks() must acquire the iolock itself before it can
proceed.

This is ugly and confusing. Simplify the semantics of
xfs_free_eofblocks() to require the caller to acquire the iolock
appropriately and kill the need_iolock parameter. While here, the mp
param can be removed as well as the xfs_mount is accessible from the
xfs_inode structure. This patch does not change behavior.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_bmap_util.c | 41 ++++++++++++++++------------------------
 fs/xfs/xfs_bmap_util.h |  3 +--
 fs/xfs/xfs_icache.c    | 24 +++++++++++++++---------
 fs/xfs/xfs_inode.c     | 51 +++++++++++++++++++++++++++-----------------------
 4 files changed, 60 insertions(+), 59 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index b9abce5..81fac29 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -909,17 +909,18 @@ xfs_can_free_eofblocks(struct xfs_inode *ip, bool force)
  */
 int
 xfs_free_eofblocks(
-	xfs_mount_t	*mp,
-	xfs_inode_t	*ip,
-	bool		need_iolock)
+	struct xfs_inode	*ip)
 {
-	xfs_trans_t	*tp;
-	int		error;
-	xfs_fileoff_t	end_fsb;
-	xfs_fileoff_t	last_fsb;
-	xfs_filblks_t	map_len;
-	int		nimaps;
-	xfs_bmbt_irec_t	imap;
+	struct xfs_trans	*tp;
+	int			error;
+	xfs_fileoff_t		end_fsb;
+	xfs_fileoff_t		last_fsb;
+	xfs_filblks_t		map_len;
+	int			nimaps;
+	struct xfs_bmbt_irec	imap;
+	struct xfs_mount	*mp = ip->i_mount;
+
+	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
 
 	/*
 	 * Figure out if there are any blocks beyond the end
@@ -936,6 +937,10 @@ xfs_free_eofblocks(
 	error = xfs_bmapi_read(ip, end_fsb, map_len, &imap, &nimaps, 0);
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
 
+	/*
+	 * If there are blocks after the end of file, truncate the file to its
+	 * current size to free them up.
+	 */
 	if (!error && (nimaps != 0) &&
 	    (imap.br_startblock != HOLESTARTBLOCK ||
 	     ip->i_delayed_blks)) {
@@ -946,22 +951,10 @@ xfs_free_eofblocks(
 		if (error)
 			return error;
 
-		/*
-		 * There are blocks after the end of file.
-		 * Free them up now by truncating the file to
-		 * its current size.
-		 */
-		if (need_iolock) {
-			if (!xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL))
-				return -EAGAIN;
-		}
-
 		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0,
 				&tp);
 		if (error) {
 			ASSERT(XFS_FORCED_SHUTDOWN(mp));
-			if (need_iolock)
-				xfs_iunlock(ip, XFS_IOLOCK_EXCL);
 			return error;
 		}
 
@@ -989,8 +982,6 @@ xfs_free_eofblocks(
 		}
 
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
-		if (need_iolock)
-			xfs_iunlock(ip, XFS_IOLOCK_EXCL);
 	}
 	return error;
 }
@@ -1407,7 +1398,7 @@ xfs_shift_file_space(
 	 * into the accessible region of the file.
 	 */
 	if (xfs_can_free_eofblocks(ip, true)) {
-		error = xfs_free_eofblocks(mp, ip, false);
+		error = xfs_free_eofblocks(ip);
 		if (error)
 			return error;
 	}
diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
index 68a621a..f100539 100644
--- a/fs/xfs/xfs_bmap_util.h
+++ b/fs/xfs/xfs_bmap_util.h
@@ -63,8 +63,7 @@ int	xfs_insert_file_space(struct xfs_inode *, xfs_off_t offset,
 
 /* EOF block manipulation functions */
 bool	xfs_can_free_eofblocks(struct xfs_inode *ip, bool force);
-int	xfs_free_eofblocks(struct xfs_mount *mp, struct xfs_inode *ip,
-			   bool need_iolock);
+int	xfs_free_eofblocks(struct xfs_inode *ip);
 
 int	xfs_swap_extents(struct xfs_inode *ip, struct xfs_inode *tip,
 			 struct xfs_swapext *sx);
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 70ca4f6..c6b698f 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1322,7 +1322,7 @@ xfs_inode_free_eofblocks(
 	int			flags,
 	void			*args)
 {
-	int ret;
+	int ret = 0;
 	struct xfs_eofblocks *eofb = args;
 	bool need_iolock = true;
 	int match;
@@ -1358,19 +1358,25 @@ xfs_inode_free_eofblocks(
 			return 0;
 
 		/*
-		 * A scan owner implies we already hold the iolock. Skip it in
-		 * xfs_free_eofblocks() to avoid deadlock. This also eliminates
-		 * the possibility of EAGAIN being returned.
+		 * A scan owner implies we already hold the iolock. Skip it here
+		 * to avoid deadlock.
 		 */
 		if (eofb->eof_scan_owner == ip->i_ino)
 			need_iolock = false;
 	}
 
-	ret = xfs_free_eofblocks(ip->i_mount, ip, need_iolock);
-
-	/* don't revisit the inode if we're not waiting */
-	if (ret == -EAGAIN && !(flags & SYNC_WAIT))
-		ret = 0;
+	/*
+	 * If the caller is waiting, return -EAGAIN to keep the background
+	 * scanner moving and revisit the inode in a subsequent pass.
+	 */
+	if (need_iolock && !xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL)) {
+		if (flags & SYNC_WAIT)
+			ret = -EAGAIN;
+		return ret;
+	}
+	ret = xfs_free_eofblocks(ip);
+	if (need_iolock)
+		xfs_iunlock(ip, XFS_IOLOCK_EXCL);
 
 	return ret;
 }
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index b955779..b9cab64 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1692,32 +1692,34 @@ xfs_release(
 	if (xfs_can_free_eofblocks(ip, false)) {
 
 		/*
+		 * Check if the inode is being opened, written and closed
+		 * frequently and we have delayed allocation blocks outstanding
+		 * (e.g. streaming writes from the NFS server), truncating the
+		 * blocks past EOF will cause fragmentation to occur.
+		 *
+		 * In this case don't do the truncation, but we have to be
+		 * careful how we detect this case. Blocks beyond EOF show up as
+		 * i_delayed_blks even when the inode is clean, so we need to
+		 * truncate them away first before checking for a dirty release.
+		 * Hence on the first dirty close we will still remove the
+		 * speculative allocation, but after that we will leave it in
+		 * place.
+		 */
+		if (xfs_iflags_test(ip, XFS_IDIRTY_RELEASE))
+			return 0;
+		/*
 		 * If we can't get the iolock just skip truncating the blocks
 		 * past EOF because we could deadlock with the mmap_sem
-		 * otherwise.  We'll get another chance to drop them once the
+		 * otherwise. We'll get another chance to drop them once the
 		 * last reference to the inode is dropped, so we'll never leak
 		 * blocks permanently.
-		 *
-		 * Further, check if the inode is being opened, written and
-		 * closed frequently and we have delayed allocation blocks
-		 * outstanding (e.g. streaming writes from the NFS server),
-		 * truncating the blocks past EOF will cause fragmentation to
-		 * occur.
-		 *
-		 * In this case don't do the truncation, either, but we have to
-		 * be careful how we detect this case. Blocks beyond EOF show
-		 * up as i_delayed_blks even when the inode is clean, so we
-		 * need to truncate them away first before checking for a dirty
-		 * release. Hence on the first dirty close we will still remove
-		 * the speculative allocation, but after that we will leave it
-		 * in place.
 		 */
-		if (xfs_iflags_test(ip, XFS_IDIRTY_RELEASE))
-			return 0;
-
-		error = xfs_free_eofblocks(mp, ip, true);
-		if (error && error != -EAGAIN)
-			return error;
+		if (xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL)) {
+			error = xfs_free_eofblocks(ip);
+			xfs_iunlock(ip, XFS_IOLOCK_EXCL);
+			if (error)
+				return error;
+		}
 
 		/* delalloc blocks after truncation means it really is dirty */
 		if (ip->i_delayed_blks)
@@ -1903,8 +1905,11 @@ xfs_inactive(
 		 * cache. Post-eof blocks must be freed, lest we end up with
 		 * broken free space accounting.
 		 */
-		if (xfs_can_free_eofblocks(ip, true))
-			xfs_free_eofblocks(mp, ip, false);
+		if (xfs_can_free_eofblocks(ip, true)) {
+			xfs_ilock(ip, XFS_IOLOCK_EXCL);
+			xfs_free_eofblocks(ip);
+			xfs_iunlock(ip, XFS_IOLOCK_EXCL);
+		}
 
 		return;
 	}
-- 
2.7.4

