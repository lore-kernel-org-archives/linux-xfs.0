Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:45292 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753031AbeDRCkr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 22:40:47 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w3I2aEIB097420
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:40:47 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2120.oracle.com with ESMTP id 2hdrxn8jsj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:40:46 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w3I2ej7p015039
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:40:46 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w3I2ejS8024155
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:40:45 GMT
Subject: [PATCH 11/11] xfs: avoid ABBA deadlock when scrubbing parent
 pointers
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 17 Apr 2018 19:40:44 -0700
Message-ID: <152401924456.11465.4870308714829350533.stgit@magnolia>
In-Reply-To: <152401916729.11465.4212188839231900136.stgit@magnolia>
References: <152401916729.11465.4212188839231900136.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

In normal operation, the XFS convention is to take an inode's iolock
and then allocate a transaction.  However, when scrubbing parent inodes
this is inverted -- we allocated the transaction to do the scrub, and
now we're trying to grab the parent's iolock.  This can lead to ABBA
deadlocks: some thread grabbed the parent's iolock and is waiting for
space for a transaction while our parent scrubber is sitting on a
transaction trying to get the parent's iolock.

Therefore, convert all iolock attempts to use trylock; if that fails,
they can use the existing mechanisms to back off and try again.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/common.c |   22 ++++++++++++++++++++++
 fs/xfs/scrub/common.h |    2 ++
 fs/xfs/scrub/parent.c |   16 ++++++++++++++--
 3 files changed, 38 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index f5e281a..93f9e7d 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -787,3 +787,25 @@ xfs_scrub_buffer_recheck(
 	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
 	trace_xfs_scrub_block_error(sc, bp->b_bn, fa);
 }
+
+/*
+ * Try to lock an inode in violation of the usual locking order rules.  For
+ * example, trying to get the IOLOCK while in transaction context, or just
+ * plain breaking AG-order or inode-order inode locking rules.  Either way,
+ * the only way to avoid an ABBA deadlock is to use trylock and back off if
+ * we can't.
+ */
+int
+xfs_scrub_ilock_inverted(
+	struct xfs_inode	*ip,
+	uint			lock_mode)
+{
+	int			i;
+
+	for (i = 0; i < 20; i++) {
+		if (xfs_ilock_nowait(ip, lock_mode))
+			return 0;
+		delay(1);
+	}
+	return -EDEADLOCK;
+}
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 8296873..191c369 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -151,4 +151,6 @@ static inline bool xfs_scrub_found_corruption(struct xfs_scrub_metadata *sm)
 			       XFS_SCRUB_OFLAG_XCORRUPT);
 }
 
+int xfs_scrub_ilock_inverted(struct xfs_inode *ip, uint lock_mode);
+
 #endif	/* __XFS_SCRUB_COMMON_H__ */
diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
index 1fb88c1..19cd54d 100644
--- a/fs/xfs/scrub/parent.c
+++ b/fs/xfs/scrub/parent.c
@@ -211,7 +211,9 @@ xfs_scrub_parent_validate(
 	 */
 	xfs_iunlock(sc->ip, sc->ilock_flags);
 	sc->ilock_flags = 0;
-	xfs_ilock(dp, XFS_IOLOCK_SHARED);
+	error = xfs_scrub_ilock_inverted(dp, XFS_IOLOCK_SHARED);
+	if (error)
+		goto out_rele;
 
 	/* Go looking for our dentry. */
 	error = xfs_scrub_parent_count_parent_dentries(sc, dp, &nlink);
@@ -220,8 +222,10 @@ xfs_scrub_parent_validate(
 
 	/* Drop the parent lock, relock this inode. */
 	xfs_iunlock(dp, XFS_IOLOCK_SHARED);
+	error = xfs_scrub_ilock_inverted(sc->ip, XFS_IOLOCK_EXCL);
+	if (error)
+		goto out_rele;
 	sc->ilock_flags = XFS_IOLOCK_EXCL;
-	xfs_ilock(sc->ip, sc->ilock_flags);
 
 	/*
 	 * If we're an unlinked directory, the parent /won't/ have a link
@@ -323,5 +327,13 @@ xfs_scrub_parent(
 	if (try_again && tries == 20)
 		xfs_scrub_set_incomplete(sc);
 out:
+	/*
+	 * If we failed to lock the parent inode even after a retry, just mark
+	 * this scrub incomplete and return.
+	 */
+	if (sc->try_harder && error == -EDEADLOCK) {
+		error = 0;
+		xfs_scrub_set_incomplete(sc);
+	}
 	return error;
 }

