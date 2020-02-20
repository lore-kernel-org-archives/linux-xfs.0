Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35915C5ACC4
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 01:42:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 02BB821D56
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 01:42:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UmxcMzpj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727291AbgBTBmQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 20:42:16 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:60454 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727280AbgBTBmQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Feb 2020 20:42:16 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01K1dLir113007;
        Thu, 20 Feb 2020 01:42:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=2SxI9FoQKh89rHnh61+M5hGx1Qv4ydtTOPumcMwvE98=;
 b=UmxcMzpjr9xqhJewQqMTiJwNauDtHtxt4pAPdfIAkeUjHVbC5sQ2ngc1LqvcFKaYPqzQ
 6XSk+Kc4NTz2fKK1snQNOf7Lr7qKk2+Yb0Kslch2/LHDNi8bZzSseUaE3WJErQ1+v8gS
 is4OCxMCs7KPtdbeMvygerjX47orPFHcuXwtGbQ6qt8JUEfBUsoTJvrPyNo/u1sxhOHG
 g0RpQcGjNycIv9gFjCFoOsu7W7el6FGmnsmhXKKDJprxIpWG0BpMocvRU1LI4dlAfXCD
 vnv17eleXGdL5VqqaBr54I6DIXgGXTrypIvhNMCck/yIC8hpuF/W48GqVfRUdTFX8KF1 mg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2y8udkesw0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 01:42:14 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01K1gEro094272;
        Thu, 20 Feb 2020 01:42:14 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2y8udbmepe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 01:42:14 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01K1g8mK001616;
        Thu, 20 Feb 2020 01:42:08 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 19 Feb 2020 17:42:08 -0800
Subject: [PATCH 4/8] libxfs: enable tools to check that metadata updates
 have been committed
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 19 Feb 2020 17:42:06 -0800
Message-ID: <158216292664.601264.186457838279269618.stgit@magnolia>
In-Reply-To: <158216290180.601264.5491208016048898068.stgit@magnolia>
References: <158216290180.601264.5491208016048898068.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 suspectscore=2 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002200011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=2
 spamscore=0 priorityscore=1501 adultscore=0 mlxscore=0 clxscore=1015
 malwarescore=0 mlxlogscore=999 phishscore=0 impostorscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002200010
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add a new function that will ensure that everything we changed has
landed on stable media, and report the results.  Subsequent commits will
teach the individual programs to report when things go wrong.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/xfs_mount.h |    3 +++
 libxfs/init.c       |   43 +++++++++++++++++++++++++++++++++++++++++++
 libxfs/libxfs_io.h  |    2 ++
 libxfs/rdwr.c       |   27 +++++++++++++++++++++++++--
 4 files changed, 73 insertions(+), 2 deletions(-)


diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index 29b3cc1b..c80aaf69 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -187,4 +187,7 @@ extern xfs_mount_t	*libxfs_mount (xfs_mount_t *, xfs_sb_t *,
 extern void	libxfs_umount (xfs_mount_t *);
 extern void	libxfs_rtmount_destroy (xfs_mount_t *);
 
+void libxfs_flush_devices(struct xfs_mount *mp, int *datadev, int *logdev,
+		int *rtdev);
+
 #endif	/* __XFS_MOUNT_H__ */
diff --git a/libxfs/init.c b/libxfs/init.c
index a0d4b7f4..d1d3f4df 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -569,6 +569,8 @@ libxfs_buftarg_alloc(
 	}
 	btp->bt_mount = mp;
 	btp->dev = dev;
+	btp->lost_writes = false;
+
 	return btp;
 }
 
@@ -791,6 +793,47 @@ libxfs_rtmount_destroy(xfs_mount_t *mp)
 	mp->m_rsumip = mp->m_rbmip = NULL;
 }
 
+static inline int
+libxfs_flush_buftarg(
+	struct xfs_buftarg	*btp)
+{
+	if (btp->lost_writes)
+		return -ENOTRECOVERABLE;
+
+	return libxfs_blkdev_issue_flush(btp);
+}
+
+/*
+ * Purge the buffer cache to write all dirty buffers to disk and free all
+ * incore buffers.  Buffers that cannot be written will cause the lost_writes
+ * flag to be set in the buftarg.  If there were no lost writes, flush the
+ * device to make sure the writes made it to stable storage.
+ *
+ * For each device, the return code will be set to -ENOTRECOVERABLE if we
+ * couldn't write something to disk; or the results of the block device flush
+ * operation.
+ */
+void
+libxfs_flush_devices(
+	struct xfs_mount	*mp,
+	int			*datadev,
+	int			*logdev,
+	int			*rtdev)
+{
+	*datadev = *logdev = *rtdev = 0;
+
+	libxfs_bcache_purge();
+
+	if (mp->m_ddev_targp)
+		*datadev = libxfs_flush_buftarg(mp->m_ddev_targp);
+
+	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp)
+		*logdev = libxfs_flush_buftarg(mp->m_logdev_targp);
+
+	if (mp->m_rtdev_targp)
+		*rtdev = libxfs_flush_buftarg(mp->m_rtdev_targp);
+}
+
 /*
  * Release any resource obtained during a mount.
  */
diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index 579df52b..fc0fd060 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -23,10 +23,12 @@ struct xfs_perag;
 struct xfs_buftarg {
 	struct xfs_mount	*bt_mount;
 	dev_t			dev;
+	bool			lost_writes;
 };
 
 extern void	libxfs_buftarg_init(struct xfs_mount *mp, dev_t ddev,
 				    dev_t logdev, dev_t rtdev);
+int libxfs_blkdev_issue_flush(struct xfs_buftarg *btp);
 
 #define LIBXFS_BBTOOFF64(bbs)	(((xfs_off_t)(bbs)) << BBSHIFT)
 
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 8b47d438..92e497f9 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -17,6 +17,7 @@
 #include "xfs_inode_fork.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
+#include "libfrog/platform.h"
 
 #include "libxfs.h"		/* for LIBXFS_EXIT_ON_FAILURE */
 
@@ -1227,9 +1228,11 @@ libxfs_brelse(
 
 	if (!bp)
 		return;
-	if (bp->b_flags & LIBXFS_B_DIRTY)
+	if (bp->b_flags & LIBXFS_B_DIRTY) {
 		fprintf(stderr,
 			"releasing dirty buffer to free list!\n");
+		bp->b_target->lost_writes = true;
+	}
 
 	pthread_mutex_lock(&xfs_buf_freelist.cm_mutex);
 	list_add(&bp->b_node.cn_mru, &xfs_buf_freelist.cm_list);
@@ -1248,9 +1251,11 @@ libxfs_bulkrelse(
 		return 0 ;
 
 	list_for_each_entry(bp, list, b_node.cn_mru) {
-		if (bp->b_flags & LIBXFS_B_DIRTY)
+		if (bp->b_flags & LIBXFS_B_DIRTY) {
 			fprintf(stderr,
 				"releasing dirty buffer (bulk) to free list!\n");
+			bp->b_target->lost_writes = true;
+		}
 		count++;
 	}
 
@@ -1479,6 +1484,24 @@ libxfs_irele(
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

