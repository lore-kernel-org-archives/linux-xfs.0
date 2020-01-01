Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6231C2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:14:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE599206E4
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:14:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YnE9yMKu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727152AbgAABO1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:14:27 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:51668 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727134AbgAABO1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:14:27 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011EPOO094431
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:14:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=4EEFK1lBmcluSryS6Cms5pxTDA3ddYGqACR5DjYfuC0=;
 b=YnE9yMKuRWUrPSJqaX/UzsavVNmIrJMLmJwl83ePjeBm978p5wrjOtBKqxK2b38u/+IT
 O2ssKCtM5YUr+mUW4BHdeYHnhB2b7lEirgh2494iUMSrucpreJvG0NhFlcYY0UQSnyVE
 igJaNVXL/NFcC3OhqM48G4wBkVFUWHajmEdM4rvqzZXJLz8Mx7Ho96NGeW64vDQn//z8
 zMkRNx2zkzkWlf5JSE0Ko0fsumjpZS1859UCuNNmeAwX8cM/Iu/NQvBh40+TevVx9j0S
 la6rVXZKhOH7XXg4NbynIr3mNVjPK2cXrJ15GvFSVnkE8NRF+TQ3V5IJwYmJ4gJJZ50a pg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2x5ypqjwjd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:14:25 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118uA3190240
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:14:25 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2x8bsrg32d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:14:24 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0011EODk029581
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:14:24 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:14:23 -0800
Subject: [PATCH 17/21] xfs: hoist inode free function to libxfs
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:14:21 -0800
Message-ID: <157784126141.1365473.390303554877722995.stgit@magnolia>
In-Reply-To: <157784115560.1365473.15056496428451670757.stgit@magnolia>
References: <157784115560.1365473.15056496428451670757.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010010
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create a libxfs helper function that marks an inode free on disk.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_inode_util.c |   65 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_inode_util.h |    4 ++
 fs/xfs/xfs_inode.c             |   50 +------------------------------
 3 files changed, 70 insertions(+), 49 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_util.c b/fs/xfs/libxfs/xfs_inode_util.c
index 12f3ad09795f..52a12a665ca2 100644
--- a/fs/xfs/libxfs/xfs_inode_util.c
+++ b/fs/xfs/libxfs/xfs_inode_util.c
@@ -19,6 +19,7 @@
 #include "xfs_health.h"
 #include "xfs_error.h"
 #include "xfs_trace.h"
+#include "xfs_inode_item.h"
 
 uint16_t
 xfs_flags2diflags(
@@ -950,3 +951,67 @@ xfs_bumplink(
 	inc_nlink(VFS_I(ip));
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 }
+
+/*
+ * Free any local-format buffers sitting around before we reset to
+ * extents format.
+ */
+static inline void
+xfs_ifree_local_data(
+	struct xfs_inode	*ip,
+	int			whichfork)
+{
+	struct xfs_ifork	*ifp;
+
+	if (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_LOCAL)
+		return;
+
+	ifp = XFS_IFORK_PTR(ip, whichfork);
+	xfs_idata_realloc(ip, -ifp->if_bytes, whichfork);
+}
+
+/* Mark an inode free on disk. */
+int
+xfs_dir_ifree(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	struct xfs_icluster	*xic)
+{
+	int			error;
+
+	/*
+	 * Pull the on-disk inode from the AGI unlinked list.
+	 */
+	error = xfs_iunlink_remove(tp, ip);
+	if (error)
+		return error;
+
+	error = xfs_difree(tp, ip->i_ino, xic);
+	if (error)
+		return error;
+
+	xfs_ifree_local_data(ip, XFS_DATA_FORK);
+	xfs_ifree_local_data(ip, XFS_ATTR_FORK);
+
+	VFS_I(ip)->i_mode = 0;		/* mark incore inode as free */
+	ip->i_d.di_flags = 0;
+	ip->i_d.di_flags2 = 0;
+	if (xfs_sb_version_hasbigtime(&ip->i_mount->m_sb))
+		ip->i_d.di_flags2 |= XFS_DIFLAG2_BIGTIME;
+	ip->i_d.di_dmevmask = 0;
+	ip->i_d.di_forkoff = 0;		/* mark the attr fork not in use */
+	ip->i_d.di_format = XFS_DINODE_FMT_EXTENTS;
+	ip->i_d.di_aformat = XFS_DINODE_FMT_EXTENTS;
+
+	/* Don't attempt to replay owner changes for a deleted inode */
+	ip->i_itemp->ili_fields &= ~(XFS_ILOG_AOWNER | XFS_ILOG_DOWNER);
+
+	/*
+	 * Bump the generation count so no one will be confused
+	 * by reincarnations of this inode.
+	 */
+	VFS_I(ip)->i_generation++;
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+
+	return 0;
+}
diff --git a/fs/xfs/libxfs/xfs_inode_util.h b/fs/xfs/libxfs/xfs_inode_util.h
index d716bffb06ed..45e6a0edd3f1 100644
--- a/fs/xfs/libxfs/xfs_inode_util.h
+++ b/fs/xfs/libxfs/xfs_inode_util.h
@@ -6,6 +6,8 @@
 #ifndef	__XFS_INODE_UTIL_H__
 #define	__XFS_INODE_UTIL_H__
 
+struct xfs_icluster;
+
 uint16_t	xfs_flags2diflags(struct xfs_inode *ip, unsigned int xflags);
 uint64_t	xfs_flags2diflags2(struct xfs_inode *ip, unsigned int xflags);
 uint32_t	xfs_dic2xflags(uint16_t di_flags, uint64_t di_flags2,
@@ -50,6 +52,8 @@ int xfs_iunlink(struct xfs_trans *tp, struct xfs_inode *ip);
 int xfs_iunlink_remove(struct xfs_trans *tp, struct xfs_inode *ip);
 int xfs_droplink(struct xfs_trans *tp, struct xfs_inode *ip);
 void xfs_bumplink(struct xfs_trans *tp, struct xfs_inode *ip);
+int xfs_dir_ifree(struct xfs_trans *tp, struct xfs_inode *ip,
+		  struct xfs_icluster *xic);
 
 /* The libxfs client must provide these iunlink helper functions. */
 int xfs_iunlink_init(struct xfs_perag *pag);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 80aa21149bd9..99795618974b 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2020,24 +2020,6 @@ xfs_ifree_cluster(
 	return 0;
 }
 
-/*
- * Free any local-format buffers sitting around before we reset to
- * extents format.
- */
-static inline void
-xfs_ifree_local_data(
-	struct xfs_inode	*ip,
-	int			whichfork)
-{
-	struct xfs_ifork	*ifp;
-
-	if (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_LOCAL)
-		return;
-
-	ifp = XFS_IFORK_PTR(ip, whichfork);
-	xfs_idata_realloc(ip, -ifp->if_bytes, whichfork);
-}
-
 /*
  * This is called to return an inode to the inode free list.
  * The inode should already be truncated to 0 length and have
@@ -2063,40 +2045,10 @@ xfs_ifree(
 	ASSERT(ip->i_d.di_size == 0 || !S_ISREG(VFS_I(ip)->i_mode));
 	ASSERT(ip->i_d.di_nblocks == 0);
 
-	/*
-	 * Pull the on-disk inode from the AGI unlinked list.
-	 */
-	error = xfs_iunlink_remove(tp, ip);
-	if (error)
-		return error;
-
-	error = xfs_difree(tp, ip->i_ino, &xic);
+	error = xfs_dir_ifree(tp, ip, &xic);
 	if (error)
 		return error;
 
-	xfs_ifree_local_data(ip, XFS_DATA_FORK);
-	xfs_ifree_local_data(ip, XFS_ATTR_FORK);
-
-	VFS_I(ip)->i_mode = 0;		/* mark incore inode as free */
-	ip->i_d.di_flags = 0;
-	ip->i_d.di_flags2 = 0;
-	if (xfs_sb_version_hasbigtime(&ip->i_mount->m_sb))
-		ip->i_d.di_flags2 |= XFS_DIFLAG2_BIGTIME;
-	ip->i_d.di_dmevmask = 0;
-	ip->i_d.di_forkoff = 0;		/* mark the attr fork not in use */
-	ip->i_d.di_format = XFS_DINODE_FMT_EXTENTS;
-	ip->i_d.di_aformat = XFS_DINODE_FMT_EXTENTS;
-
-	/* Don't attempt to replay owner changes for a deleted inode */
-	ip->i_itemp->ili_fields &= ~(XFS_ILOG_AOWNER|XFS_ILOG_DOWNER);
-
-	/*
-	 * Bump the generation count so no one will be confused
-	 * by reincarnations of this inode.
-	 */
-	VFS_I(ip)->i_generation++;
-	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-
 	if (xic.deleted)
 		error = xfs_ifree_cluster(ip, tp, &xic);
 

