Return-Path: <SRS0=aYBA=4Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FF53C3F2D2
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 23:36:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 589802084E
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 23:36:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Hb79oQCa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbgB1XgC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Feb 2020 18:36:02 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:43334 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbgB1XgB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Feb 2020 18:36:01 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01SNXrpT158368;
        Fri, 28 Feb 2020 23:35:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=KAD8r4hWg4aIxHHVZ1bmseM4oNTRxxmE63+EENpPugk=;
 b=Hb79oQCaWLLbOun7IkK/buYlE+ytU4moZA6Yvgbm4K3Pz39FiExp36Tsy2IJY1vsKtJR
 Jd0W13Oxo/NDMGgJzLdqZ4tRG9uRt7lhe6q7UbjYVi5KLR9MjIlGnWuduFV6uC620AId
 z5zlxbUqQ7DnR8LwVp1IBGcLsJOHIJSxzSZNCf7QMXRQ+PXCF+8TfgXSDx5MdN7YqxaI
 7ypBwG6wDE3C13MaPUOU+RoIwOcKu3qNn176BZg5WDiL/5wYx/MsPB2TY1uC4xycKw4A
 bXouREEOgI+mpgwbSiaIdYq5Mx2/8oGusx7dvgyZM8coD6eqa6yakFiVQId5sCcMiLAQ Mw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2yf0dmc5q0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Feb 2020 23:35:55 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01SNWN2n042302;
        Fri, 28 Feb 2020 23:35:55 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2ydcs9ve2r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Feb 2020 23:35:54 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01SNZrkx019930;
        Fri, 28 Feb 2020 23:35:53 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 28 Feb 2020 15:35:53 -0800
Subject: [PATCH 4/7] libxfs: flush all dirty buffers and report errors when
 unmounting filesystem
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
        Christoph Hellwig <hch@lst.de>
Date:   Fri, 28 Feb 2020 15:35:52 -0800
Message-ID: <158293295261.1548526.10834451621242039067.stgit@magnolia>
In-Reply-To: <158293292760.1548526.16432706349096704475.stgit@magnolia>
References: <158293292760.1548526.16432706349096704475.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 suspectscore=2 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002280170
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 clxscore=1015
 bulkscore=0 impostorscore=0 mlxscore=0 priorityscore=1501 phishscore=0
 spamscore=0 malwarescore=0 mlxlogscore=999 adultscore=0 suspectscore=2
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002280170
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Teach libxfs_umount to flush all dirty buffers when unmounting the
filesystem, to log write verifier errors and IO errors, and to return an
error code when things go wrong.  Subsequent patches will teach critical
utilities to exit with EXIT_FAILURE when this happens.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/xfs_mount.h |    2 +
 libxfs/init.c       |   96 +++++++++++++++++++++++++++++++++++++++++++++++++--
 libxfs/libxfs_io.h  |    7 ++++
 libxfs/rdwr.c       |   38 ++++++++++++++++++--
 4 files changed, 135 insertions(+), 8 deletions(-)


diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index 29b3cc1b..7bd23fbb 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -184,7 +184,7 @@ xfs_perag_resv(
 
 extern xfs_mount_t	*libxfs_mount (xfs_mount_t *, xfs_sb_t *,
 				dev_t, dev_t, dev_t, int);
-extern void	libxfs_umount (xfs_mount_t *);
+int		libxfs_umount(struct xfs_mount *mp);
 extern void	libxfs_rtmount_destroy (xfs_mount_t *);
 
 #endif	/* __XFS_MOUNT_H__ */
diff --git a/libxfs/init.c b/libxfs/init.c
index 3c3063fc..42d4c8e4 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -581,6 +581,8 @@ libxfs_buftarg_alloc(
 	}
 	btp->bt_mount = mp;
 	btp->dev = dev;
+	btp->flags = 0;
+
 	return btp;
 }
 
@@ -803,17 +805,104 @@ libxfs_rtmount_destroy(xfs_mount_t *mp)
 	mp->m_rsumip = mp->m_rbmip = NULL;
 }
 
+/* Flush a device and report on writes that didn't make it to stable storage. */
+static inline int
+libxfs_flush_buftarg(
+	struct xfs_buftarg	*btp,
+	const char		*buftarg_descr)
+{
+	int			error = 0;
+	int			err2;
+
+	/*
+	 * Write verifier failures are evidence of a buggy program.  Make sure
+	 * that this state is always reported to the caller.
+	 */
+	if (btp->flags & XFS_BUFTARG_CORRUPT_WRITE) {
+		fprintf(stderr,
+_("%s: Refusing to write a corrupt buffer to the %s!\n"),
+				progname, buftarg_descr);
+		error = -EFSCORRUPTED;
+	}
+
+	if (btp->flags & XFS_BUFTARG_LOST_WRITE) {
+		fprintf(stderr,
+_("%s: Lost a write to the %s!\n"),
+				progname, buftarg_descr);
+		if (!error)
+			error = -EIO;
+	}
+
+	err2 = libxfs_blkdev_issue_flush(btp);
+	if (err2) {
+		fprintf(stderr,
+_("%s: Flushing the %s failed, err=%d!\n"),
+				progname, buftarg_descr, -err2);
+	}
+	if (!error)
+		error = err2;
+
+	return error;
+}
+
+/*
+ * Flush all dirty buffers to stable storage and report on writes that didn't
+ * make it to stable storage.
+ */
+static int
+libxfs_flush_mount(
+	struct xfs_mount	*mp)
+{
+	int			error = 0;
+	int			err2;
+
+	/*
+	 * Purge the buffer cache to write all dirty buffers to disk and free
+	 * all incore buffers.  Buffers that fail write verification will cause
+	 * the CORRUPT_WRITE flag to be set in the buftarg.  Buffers that
+	 * cannot be written will cause the LOST_WRITE flag to be set in the
+	 * buftarg.
+	 */
+	libxfs_bcache_purge();
+
+	/* Flush all kernel and disk write caches, and report failures. */
+	if (mp->m_ddev_targp) {
+		err2 = libxfs_flush_buftarg(mp->m_ddev_targp, _("data device"));
+		if (!error)
+			error = err2;
+	}
+
+	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp) {
+		err2 = libxfs_flush_buftarg(mp->m_logdev_targp,
+				_("log device"));
+		if (!error)
+			error = err2;
+	}
+
+	if (mp->m_rtdev_targp) {
+		err2 = libxfs_flush_buftarg(mp->m_rtdev_targp,
+				_("realtime device"));
+		if (!error)
+			error = err2;
+	}
+
+	return error;
+}
+
 /*
  * Release any resource obtained during a mount.
  */
-void
-libxfs_umount(xfs_mount_t *mp)
+int
+libxfs_umount(
+	struct xfs_mount	*mp)
 {
 	struct xfs_perag	*pag;
 	int			agno;
+	int			error;
 
 	libxfs_rtmount_destroy(mp);
-	libxfs_bcache_purge();
+
+	error = libxfs_flush_mount(mp);
 
 	for (agno = 0; agno < mp->m_maxagi; agno++) {
 		pag = radix_tree_delete(&mp->m_perag_tree, agno);
@@ -828,6 +917,7 @@ libxfs_umount(xfs_mount_t *mp)
 		kmem_free(mp->m_logdev_targp);
 	kmem_free(mp->m_ddev_targp);
 
+	return error;
 }
 
 /*
diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index 579df52b..6bb75a67 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -23,10 +23,17 @@ struct xfs_perag;
 struct xfs_buftarg {
 	struct xfs_mount	*bt_mount;
 	dev_t			dev;
+	unsigned int		flags;
 };
 
+/* We purged a dirty buffer and lost a write. */
+#define XFS_BUFTARG_LOST_WRITE		(1 << 0)
+/* A dirty buffer failed the write verifier. */
+#define XFS_BUFTARG_CORRUPT_WRITE	(1 << 1)
+
 extern void	libxfs_buftarg_init(struct xfs_mount *mp, dev_t ddev,
 				    dev_t logdev, dev_t rtdev);
+int libxfs_blkdev_issue_flush(struct xfs_buftarg *btp);
 
 #define LIBXFS_BBTOOFF64(bbs)	(((xfs_off_t)(bbs)) << BBSHIFT)
 
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 4c021316..737e51d1 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -17,6 +17,7 @@
 #include "xfs_inode_fork.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
+#include "libfrog/platform.h"
 
 #include "libxfs.h"		/* for LIBXFS_EXIT_ON_FAILURE */
 
@@ -1226,6 +1227,19 @@ libxfs_iomove(xfs_buf_t *bp, uint boff, int len, void *data, int flags)
 	}
 }
 
+/* Complain about (and remember) dropping dirty buffers. */
+static void
+libxfs_whine_dirty_buf(
+	struct xfs_buf		*bp)
+{
+	fprintf(stderr, _("%s: Releasing dirty buffer to free list!\n"),
+			progname);
+
+	if (bp->b_error == -EFSCORRUPTED)
+		bp->b_target->flags |= XFS_BUFTARG_CORRUPT_WRITE;
+	bp->b_target->flags |= XFS_BUFTARG_LOST_WRITE;
+}
+
 static void
 libxfs_brelse(
 	struct cache_node	*node)
@@ -1235,8 +1249,7 @@ libxfs_brelse(
 	if (!bp)
 		return;
 	if (bp->b_flags & LIBXFS_B_DIRTY)
-		fprintf(stderr,
-			"releasing dirty buffer to free list!\n");
+		libxfs_whine_dirty_buf(bp);
 
 	pthread_mutex_lock(&xfs_buf_freelist.cm_mutex);
 	list_add(&bp->b_node.cn_mru, &xfs_buf_freelist.cm_list);
@@ -1256,8 +1269,7 @@ libxfs_bulkrelse(
 
 	list_for_each_entry(bp, list, b_node.cn_mru) {
 		if (bp->b_flags & LIBXFS_B_DIRTY)
-			fprintf(stderr,
-				"releasing dirty buffer (bulk) to free list!\n");
+			libxfs_whine_dirty_buf(bp);
 		count++;
 	}
 
@@ -1486,6 +1498,24 @@ libxfs_irele(
 	kmem_cache_free(xfs_inode_zone, ip);
 }
 
+/*
+ * Flush everything dirty in the kernel and disk write caches to stable media.
+ * Returns 0 for success or a negative error code.
+ */
+int
+libxfs_blkdev_issue_flush(
+	struct xfs_buftarg	*btp)
+{
+	int			fd, ret;
+
+	if (btp->dev == 0)
+		return 0;
+
+	fd = libxfs_device_to_fd(btp->dev);
+	ret = platform_flush_device(fd, btp->dev);
+	return ret ? -errno : 0;
+}
+
 /*
  * Write out a buffer list synchronously.
  *

