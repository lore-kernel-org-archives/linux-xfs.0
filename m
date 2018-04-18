Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:49338 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753031AbeDRCkk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 22:40:40 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w3I2bGER168070
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:40:40 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2130.oracle.com with ESMTP id 2hdrxn8jku-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:40:40 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w3I2ed5G006478
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:40:39 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w3I2edUn024135
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:40:39 GMT
Subject: [PATCH 10/11] xfs: refactor scrub transaction allocation function
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 17 Apr 2018 19:40:38 -0700
Message-ID: <152401923843.11465.18287637455833017534.stgit@magnolia>
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

Since the transaction allocation helper is about to become more complex,
move it to common.c and remove the redundant parameters.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/bmap.c   |    3 +--
 fs/xfs/scrub/common.c |   16 +++++++++++++---
 fs/xfs/scrub/common.h |   14 +-------------
 fs/xfs/scrub/inode.c  |    5 ++---
 4 files changed, 17 insertions(+), 21 deletions(-)


diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 639d14b..3f8fd10 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -51,7 +51,6 @@ xfs_scrub_setup_inode_bmap(
 	struct xfs_scrub_context	*sc,
 	struct xfs_inode		*ip)
 {
-	struct xfs_mount		*mp = sc->mp;
 	int				error;
 
 	error = xfs_scrub_get_inode(sc, ip);
@@ -75,7 +74,7 @@ xfs_scrub_setup_inode_bmap(
 	}
 
 	/* Got the inode, lock it and we're ready to go. */
-	error = xfs_scrub_trans_alloc(sc->sm, mp, &sc->tp);
+	error = xfs_scrub_trans_alloc(sc);
 	if (error)
 		goto out;
 	sc->ilock_flags |= XFS_ILOCK_EXCL;
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 3f72176..f5e281a 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -568,13 +568,24 @@ xfs_scrub_ag_init(
 
 /* Per-scrubber setup functions */
 
+/*
+ * Grab an empty transaction so that we can re-grab locked buffers if
+ * one of our btrees turns out to be cyclic.
+ */
+int
+xfs_scrub_trans_alloc(
+	struct xfs_scrub_context	*sc)
+{
+	return xfs_trans_alloc_empty(sc->mp, &sc->tp);
+}
+
 /* Set us up with a transaction and an empty context. */
 int
 xfs_scrub_setup_fs(
 	struct xfs_scrub_context	*sc,
 	struct xfs_inode		*ip)
 {
-	return xfs_scrub_trans_alloc(sc->sm, sc->mp, &sc->tp);
+	return xfs_scrub_trans_alloc(sc);
 }
 
 /* Set us up with AG headers and btree cursors. */
@@ -695,7 +706,6 @@ xfs_scrub_setup_inode_contents(
 	struct xfs_inode		*ip,
 	unsigned int			resblks)
 {
-	struct xfs_mount		*mp = sc->mp;
 	int				error;
 
 	error = xfs_scrub_get_inode(sc, ip);
@@ -705,7 +715,7 @@ xfs_scrub_setup_inode_contents(
 	/* Got the inode, lock it and we're ready to go. */
 	sc->ilock_flags = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
 	xfs_ilock(sc->ip, sc->ilock_flags);
-	error = xfs_scrub_trans_alloc(sc->sm, mp, &sc->tp);
+	error = xfs_scrub_trans_alloc(sc);
 	if (error)
 		goto out;
 	sc->ilock_flags |= XFS_ILOCK_EXCL;
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 30e9039..8296873 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -38,19 +38,7 @@ xfs_scrub_should_terminate(
 	return false;
 }
 
-/*
- * Grab an empty transaction so that we can re-grab locked buffers if
- * one of our btrees turns out to be cyclic.
- */
-static inline int
-xfs_scrub_trans_alloc(
-	struct xfs_scrub_metadata	*sm,
-	struct xfs_mount		*mp,
-	struct xfs_trans		**tpp)
-{
-	return xfs_trans_alloc_empty(mp, tpp);
-}
-
+int xfs_scrub_trans_alloc(struct xfs_scrub_context *sc);
 bool xfs_scrub_process_error(struct xfs_scrub_context *sc, xfs_agnumber_t agno,
 		xfs_agblock_t bno, int *error);
 bool xfs_scrub_fblock_process_error(struct xfs_scrub_context *sc, int whichfork,
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index df14930..e15b1bc 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -55,7 +55,6 @@ xfs_scrub_setup_inode(
 	struct xfs_scrub_context	*sc,
 	struct xfs_inode		*ip)
 {
-	struct xfs_mount		*mp = sc->mp;
 	int				error;
 
 	/*
@@ -68,7 +67,7 @@ xfs_scrub_setup_inode(
 		break;
 	case -EFSCORRUPTED:
 	case -EFSBADCRC:
-		return xfs_scrub_trans_alloc(sc->sm, mp, &sc->tp);
+		return xfs_scrub_trans_alloc(sc);
 	default:
 		return error;
 	}
@@ -76,7 +75,7 @@ xfs_scrub_setup_inode(
 	/* Got the inode, lock it and we're ready to go. */
 	sc->ilock_flags = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
 	xfs_ilock(sc->ip, sc->ilock_flags);
-	error = xfs_scrub_trans_alloc(sc->sm, mp, &sc->tp);
+	error = xfs_scrub_trans_alloc(sc);
 	if (error)
 		goto out;
 	sc->ilock_flags |= XFS_ILOCK_EXCL;

