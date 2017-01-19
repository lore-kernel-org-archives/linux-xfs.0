Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48864 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754212AbdASTAN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 19 Jan 2017 14:00:13 -0500
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 59449C0567B1
        for <linux-xfs@vger.kernel.org>; Thu, 19 Jan 2017 19:00:14 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id v0JJ0DEQ016395
        for <linux-xfs@vger.kernel.org>; Thu, 19 Jan 2017 14:00:14 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 2/3] xfs: sync eofblocks scans under iolock are livelock prone
Date: Thu, 19 Jan 2017 14:00:10 -0500
Message-Id: <1484852411-1137-3-git-send-email-bfoster@redhat.com>
In-Reply-To: <1484852411-1137-1-git-send-email-bfoster@redhat.com>
References: <1484852411-1137-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The xfs_eofblocks.eof_scan_owner field is an internal field to
facilitate invoking eofb scans from the kernel while under the iolock.
This is necessary because the eofb scan acquires the iolock of each
inode. Synchronous scans are invoked on certain buffered write failures
while under iolock. In such cases, the scan owner indicates that the
context for the scan already owns the particular iolock and prevents a
double lock deadlock.

eofblocks scans while under iolock are still livelock prone in the event
of multiple parallel scans, however. If multiple buffered writes to
different inodes fail and invoke eofblocks scans at the same time, each
scan avoids a deadlock with its own inode by virtue of the
eof_scan_owner field, but will never be able to acquire the iolock of
the inode from the parallel scan. Because the low free space scans are
invoked with SYNC_WAIT, the scan will not return until it has processed
every tagged inode and thus both scans will spin indefinitely on the
iolock being held across the opposite scan. This problem can be
reproduced reliably by generic/224 on systems with higher cpu counts
(x16).

To avoid this problem, simplify the semantics of eofblocks scans to
never invoke a scan while under iolock. This means that the buffered
write context must drop the iolock before the scan. It must reacquire
the lock before the write retry and also repeat the initial write
checks, as the original state might no longer be valid once the iolock
was dropped.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_file.c   | 13 +++++++++----
 fs/xfs/xfs_icache.c | 45 +++++++--------------------------------------
 fs/xfs/xfs_icache.h |  2 --
 3 files changed, 16 insertions(+), 44 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index bbb9eb6..0a29739 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -614,8 +614,10 @@ xfs_file_buffered_aio_write(
 	struct xfs_inode	*ip = XFS_I(inode);
 	ssize_t			ret;
 	int			enospc = 0;
-	int			iolock = XFS_IOLOCK_EXCL;
+	int			iolock;
 
+write_retry:
+	iolock = XFS_IOLOCK_EXCL;
 	xfs_ilock(ip, iolock);
 
 	ret = xfs_file_aio_write_checks(iocb, from, &iolock);
@@ -625,7 +627,6 @@ xfs_file_buffered_aio_write(
 	/* We can write back this queue in page reclaim */
 	current->backing_dev_info = inode_to_bdi(inode);
 
-write_retry:
 	trace_xfs_file_buffered_write(ip, iov_iter_count(from), iocb->ki_pos);
 	ret = iomap_file_buffered_write(iocb, from, &xfs_iomap_ops);
 	if (likely(ret >= 0))
@@ -641,18 +642,21 @@ xfs_file_buffered_aio_write(
 	 * running at the same time.
 	 */
 	if (ret == -EDQUOT && !enospc) {
+		xfs_iunlock(ip, iolock);
 		enospc = xfs_inode_free_quota_eofblocks(ip);
 		if (enospc)
 			goto write_retry;
 		enospc = xfs_inode_free_quota_cowblocks(ip);
 		if (enospc)
 			goto write_retry;
+		iolock = 0;
 	} else if (ret == -ENOSPC && !enospc) {
 		struct xfs_eofblocks eofb = {0};
 
 		enospc = 1;
 		xfs_flush_inodes(ip->i_mount);
-		eofb.eof_scan_owner = ip->i_ino; /* for locking */
+
+		xfs_iunlock(ip, iolock);
 		eofb.eof_flags = XFS_EOF_FLAGS_SYNC;
 		xfs_icache_free_eofblocks(ip->i_mount, &eofb);
 		goto write_retry;
@@ -660,7 +664,8 @@ xfs_file_buffered_aio_write(
 
 	current->backing_dev_info = NULL;
 out:
-	xfs_iunlock(ip, iolock);
+	if (iolock)
+		xfs_iunlock(ip, iolock);
 	return ret;
 }
 
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index c6b698f..7234b97 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1324,11 +1324,8 @@ xfs_inode_free_eofblocks(
 {
 	int ret = 0;
 	struct xfs_eofblocks *eofb = args;
-	bool need_iolock = true;
 	int match;
 
-	ASSERT(!eofb || (eofb && eofb->eof_scan_owner != 0));
-
 	if (!xfs_can_free_eofblocks(ip, false)) {
 		/* inode could be preallocated or append-only */
 		trace_xfs_inode_free_eofblocks_invalid(ip);
@@ -1356,27 +1353,19 @@ xfs_inode_free_eofblocks(
 		if (eofb->eof_flags & XFS_EOF_FLAGS_MINFILESIZE &&
 		    XFS_ISIZE(ip) < eofb->eof_min_file_size)
 			return 0;
-
-		/*
-		 * A scan owner implies we already hold the iolock. Skip it here
-		 * to avoid deadlock.
-		 */
-		if (eofb->eof_scan_owner == ip->i_ino)
-			need_iolock = false;
 	}
 
 	/*
 	 * If the caller is waiting, return -EAGAIN to keep the background
 	 * scanner moving and revisit the inode in a subsequent pass.
 	 */
-	if (need_iolock && !xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL)) {
+	if (!xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL)) {
 		if (flags & SYNC_WAIT)
 			ret = -EAGAIN;
 		return ret;
 	}
 	ret = xfs_free_eofblocks(ip);
-	if (need_iolock)
-		xfs_iunlock(ip, XFS_IOLOCK_EXCL);
+	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
 
 	return ret;
 }
@@ -1423,15 +1412,10 @@ __xfs_inode_free_quota_eofblocks(
 	struct xfs_eofblocks eofb = {0};
 	struct xfs_dquot *dq;
 
-	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
-
 	/*
-	 * Set the scan owner to avoid a potential livelock. Otherwise, the scan
-	 * can repeatedly trylock on the inode we're currently processing. We
-	 * run a sync scan to increase effectiveness and use the union filter to
+	 * Run a sync scan to increase effectiveness and use the union filter to
 	 * cover all applicable quotas in a single scan.
 	 */
-	eofb.eof_scan_owner = ip->i_ino;
 	eofb.eof_flags = XFS_EOF_FLAGS_UNION|XFS_EOF_FLAGS_SYNC;
 
 	if (XFS_IS_UQUOTA_ENFORCED(ip->i_mount)) {
@@ -1583,12 +1567,9 @@ xfs_inode_free_cowblocks(
 {
 	int ret;
 	struct xfs_eofblocks *eofb = args;
-	bool need_iolock = true;
 	int match;
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
 
-	ASSERT(!eofb || (eofb && eofb->eof_scan_owner != 0));
-
 	/*
 	 * Just clear the tag if we have an empty cow fork or none at all. It's
 	 * possible the inode was fully unshared since it was originally tagged.
@@ -1621,28 +1602,16 @@ xfs_inode_free_cowblocks(
 		if (eofb->eof_flags & XFS_EOF_FLAGS_MINFILESIZE &&
 		    XFS_ISIZE(ip) < eofb->eof_min_file_size)
 			return 0;
-
-		/*
-		 * A scan owner implies we already hold the iolock. Skip it in
-		 * xfs_free_eofblocks() to avoid deadlock. This also eliminates
-		 * the possibility of EAGAIN being returned.
-		 */
-		if (eofb->eof_scan_owner == ip->i_ino)
-			need_iolock = false;
 	}
 
 	/* Free the CoW blocks */
-	if (need_iolock) {
-		xfs_ilock(ip, XFS_IOLOCK_EXCL);
-		xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
-	}
+	xfs_ilock(ip, XFS_IOLOCK_EXCL);
+	xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
 
 	ret = xfs_reflink_cancel_cow_range(ip, 0, NULLFILEOFF);
 
-	if (need_iolock) {
-		xfs_iunlock(ip, XFS_MMAPLOCK_EXCL);
-		xfs_iunlock(ip, XFS_IOLOCK_EXCL);
-	}
+	xfs_iunlock(ip, XFS_MMAPLOCK_EXCL);
+	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
 
 	return ret;
 }
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index a1e02f4..8a7c849 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -27,7 +27,6 @@ struct xfs_eofblocks {
 	kgid_t		eof_gid;
 	prid_t		eof_prid;
 	__u64		eof_min_file_size;
-	xfs_ino_t	eof_scan_owner;
 };
 
 #define SYNC_WAIT		0x0001	/* wait for i/o to complete */
@@ -102,7 +101,6 @@ xfs_fs_eofblocks_from_user(
 	dst->eof_flags = src->eof_flags;
 	dst->eof_prid = src->eof_prid;
 	dst->eof_min_file_size = src->eof_min_file_size;
-	dst->eof_scan_owner = NULLFSINO;
 
 	dst->eof_uid = INVALID_UID;
 	if (src->eof_flags & XFS_EOF_FLAGS_UID) {
-- 
2.7.4

