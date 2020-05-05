Return-Path: <SRS0=NnDK=6T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3157C47247
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 01:13:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB27D20658
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 01:13:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PXn5nxY5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728055AbgEEBN5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 May 2020 21:13:57 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48246 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727995AbgEEBN5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 May 2020 21:13:57 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04513xBF055604
        for <linux-xfs@vger.kernel.org>; Tue, 5 May 2020 01:13:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=3TC7UmAQKU99p+A3jG/83vNZXCR2MYV9ZyLXFPnfhvA=;
 b=PXn5nxY5ZP+MpxB0eml5XL8nRxRZjVsA6PEc3OFqZ1C6rJkfF24VEimIxUG+pD0Po/Ig
 qW58xl4C8Gc3RXVQrMsx/6RSMS5FBidqnlmtGoMKh+MhIHoWAIupbXFKkcFsMnPGKapr
 UggKqfcNZ3uG1Vl2Qa4FtaTasVcQUwQqD3hUp4M0P5SqWetrwjQ1aUI4A8SWKhTvkX8M
 e9dVBbWJcarKZ0Y3APc/SzKL/Ypp/ZKdLwYurzelY4WsYktJGUi7WnhxeVC+UCJRB6cH
 AV18jGQORfjlcusu28oxRbg9EwhGMd9+TSZkf8h/vIst3vOjfvgk35yPTNdpBXMPjZIX hQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 30s1gn1vpm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 05 May 2020 01:13:55 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04516fwD149315
        for <linux-xfs@vger.kernel.org>; Tue, 5 May 2020 01:13:55 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 30sjjxauf5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 05 May 2020 01:13:55 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0451DsPM015580
        for <linux-xfs@vger.kernel.org>; Tue, 5 May 2020 01:13:54 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 May 2020 18:13:54 -0700
Subject: [PATCH 3/3] xfs: fix an incore inode UAF in xfs_bui_recover
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 04 May 2020 18:13:53 -0700
Message-ID: <158864123329.184729.14504239314355330619.stgit@magnolia>
In-Reply-To: <158864121286.184729.5959003885146573075.stgit@magnolia>
References: <158864121286.184729.5959003885146573075.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 mlxscore=0 phishscore=0
 bulkscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005050005
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=3 mlxscore=0
 spamscore=0 clxscore=1015 priorityscore=1501 bulkscore=0 phishscore=0
 impostorscore=0 malwarescore=0 lowpriorityscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005050005
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

In xfs_bui_item_recover, there exists a use-after-free bug with regards
to the inode that is involved in the bmap replay operation.  If the
mapping operation does not complete, we call xfs_bmap_unmap_extent to
create a deferred op to finish the unmapping work, and we retain a
pointer to the incore inode.

Unfortunately, the very next thing we do is commit the transaction and
drop the inode.  If reclaim tears down the inode before we try to finish
the defer ops, we dereference garbage and blow up.  Therefore, create a
way to join inodes to the defer ops freezer so that we can maintain the
xfs_inode reference until we're done with the inode.

Note: This imposes the requirement that there be enough memory to keep
every incore inode in memory throughout recovery.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_defer.c |   50 +++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_defer.h |   10 +++++++++
 fs/xfs/xfs_bmap_item.c    |    7 ++++--
 fs/xfs/xfs_icache.c       |   19 +++++++++++++++++
 4 files changed, 83 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index ea4d28851bbd..72933fdafcb2 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -16,6 +16,7 @@
 #include "xfs_inode.h"
 #include "xfs_inode_item.h"
 #include "xfs_trace.h"
+#include "xfs_icache.h"
 
 /*
  * Deferred Operations in XFS
@@ -583,8 +584,19 @@ xfs_defer_thaw(
 	struct xfs_defer_freezer	*dff,
 	struct xfs_trans		*tp)
 {
+	int				i;
+
 	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
 
+	/* Re-acquire the inode locks. */
+	for (i = 0; i < XFS_DEFER_FREEZER_INODES; i++) {
+		if (!dff->dff_inodes[i])
+			break;
+
+		dff->dff_ilocks[i] = XFS_ILOCK_EXCL;
+		xfs_ilock(dff->dff_inodes[i], dff->dff_ilocks[i]);
+	}
+
 	/* Add the dfops items to the transaction. */
 	list_splice_init(&dff->dff_dfops, &tp->t_dfops);
 	tp->t_flags |= dff->dff_tpflags;
@@ -597,5 +609,43 @@ xfs_defer_freeezer_finish(
 	struct xfs_defer_freezer	*dff)
 {
 	xfs_defer_cancel_list(mp, &dff->dff_dfops);
+	xfs_defer_freezer_irele(dff);
 	kmem_free(dff);
 }
+
+/*
+ * Attach an inode to this deferred ops freezer.  Callers must hold ILOCK_EXCL,
+ * which will be dropped and reacquired when we're ready to thaw the frozen
+ * deferred ops.
+ */
+int
+xfs_defer_freezer_ijoin(
+	struct xfs_defer_freezer	*dff,
+	struct xfs_inode		*ip)
+{
+	unsigned int			i;
+
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+
+	for (i = 0; i < XFS_DEFER_FREEZER_INODES; i++) {
+		if (dff->dff_inodes[i] == ip)
+			goto out;
+		if (dff->dff_inodes[i] == NULL)
+			break;
+	}
+
+	if (i == XFS_DEFER_FREEZER_INODES) {
+		ASSERT(0);
+		return -EFSCORRUPTED;
+	}
+
+	/*
+	 * Attach this inode to the freezer and drop its ILOCK because we
+	 * assume the caller will need to allocate a transaction.
+	 */
+	dff->dff_inodes[i] = ip;
+	dff->dff_ilocks[i] = 0;
+out:
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	return 0;
+}
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index 7ae05e10d750..0052a0313283 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -76,6 +76,11 @@ struct xfs_defer_freezer {
 	/* Deferred ops state saved from the transaction. */
 	struct list_head	dff_dfops;
 	unsigned int		dff_tpflags;
+
+	/* Inodes to hold when we want to finish the deferred work items. */
+#define XFS_DEFER_FREEZER_INODES	2
+	unsigned int		dff_ilocks[XFS_DEFER_FREEZER_INODES];
+	struct xfs_inode	*dff_inodes[XFS_DEFER_FREEZER_INODES];
 };
 
 /* Functions to freeze a chain of deferred operations for later. */
@@ -83,5 +88,10 @@ int xfs_defer_freeze(struct xfs_trans *tp, struct xfs_defer_freezer **dffp);
 void xfs_defer_thaw(struct xfs_defer_freezer *dff, struct xfs_trans *tp);
 void xfs_defer_freeezer_finish(struct xfs_mount *mp,
 		struct xfs_defer_freezer *dff);
+int xfs_defer_freezer_ijoin(struct xfs_defer_freezer *dff,
+		struct xfs_inode *ip);
+
+/* These functions must be provided by the xfs implementation. */
+void xfs_defer_freezer_irele(struct xfs_defer_freezer *dff);
 
 #endif /* __XFS_DEFER_H__ */
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index c733bdeeeb9b..bbce191d8fcd 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -530,12 +530,13 @@ xfs_bui_item_recover(
 	}
 
 	error = xlog_recover_trans_commit(tp, dffp);
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-	xfs_irele(ip);
-	return error;
+	if (error)
+		goto err_rele;
+	return xfs_defer_freezer_ijoin(*dffp, ip);
 
 err_inode:
 	xfs_trans_cancel(tp);
+err_rele:
 	if (ip) {
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 		xfs_irele(ip);
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 17a0b86fe701..b96ddf5ff334 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -12,6 +12,7 @@
 #include "xfs_sb.h"
 #include "xfs_mount.h"
 #include "xfs_inode.h"
+#include "xfs_defer.h"
 #include "xfs_trans.h"
 #include "xfs_trans_priv.h"
 #include "xfs_inode_item.h"
@@ -1847,3 +1848,21 @@ xfs_start_block_reaping(
 	xfs_queue_eofblocks(mp);
 	xfs_queue_cowblocks(mp);
 }
+
+/* Release all the inode resources attached to this freezer. */
+void
+xfs_defer_freezer_irele(
+	struct xfs_defer_freezer	*dff)
+{
+	unsigned int			i;
+
+	for (i = 0; i < XFS_DEFER_FREEZER_INODES; i++) {
+		if (!dff->dff_inodes[i])
+			break;
+
+		if (dff->dff_ilocks[i])
+			xfs_iunlock(dff->dff_inodes[i], dff->dff_ilocks[i]);
+		xfs_irele(dff->dff_inodes[i]);
+		dff->dff_inodes[i] = NULL;
+	}
+}

