Return-Path: <SRS0=4ojB=6G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08DA4C2BA19
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Apr 2020 02:10:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD12E206D5
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Apr 2020 02:10:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="i20r328s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbgDVCKb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Apr 2020 22:10:31 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:40788 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726173AbgDVCKb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Apr 2020 22:10:31 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03M29FcZ090749
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:10:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=vu4zhzK0SQRyMf04gfaN0ABWYY4mGWxZOezgBm8c7UQ=;
 b=i20r328sbN4c9HsOvqVBU9Vg2g2kz/sILPBmHX2FU6kL5IBydggmHouD545880DQHo/1
 OtBQ36dbKW9qTIlfVqTOzqhxuYf2Fr4Bont3lIhRxH3OuLLyBgAIpskjEQs63qMtNZm6
 DOkggImjDIY6GENysnBc7vO1Yorhaa0eHvSFhws/S+xpuaBc7J0OrtRChKgEu9oQidfU
 FaVC5+YKq+e+FSyT3vW7AysSbFTuTx0NC2ELacNop0Vwklz8pMZ5nf9EsFtHyqQYUUAX
 kHdBYy4vYJ/TAUV1ddm3FoGpI7DPKF8D+DHks0wTo5Xti1iR7QkGPiKFkZSknvQFTm7C Ug== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 30ft6n81t8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:10:28 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03M27aol187132
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:08:28 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 30gb91fqvr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:08:28 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03M28RHm014740
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:08:27 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Apr 2020 19:08:27 -0700
Subject: [PATCH 3/3] xfs: teach deferred op freezer to freeze and thaw inodes
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 21 Apr 2020 19:08:26 -0700
Message-ID: <158752130655.2142108.9338576917893374360.stgit@magnolia>
In-Reply-To: <158752128766.2142108.8793264653760565688.stgit@magnolia>
References: <158752128766.2142108.8793264653760565688.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9598 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 bulkscore=0 suspectscore=3 malwarescore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004220015
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9598 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 bulkscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 phishscore=0
 lowpriorityscore=0 malwarescore=0 clxscore=1015 mlxlogscore=999 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004220015
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Make it so that the deferred operations freezer can save inode numbers
when we freeze the dfops chain, and turn them into pointers to incore
inodes when we thaw the dfops chain to finish them.  Next, add dfops
item freeze and thaw functions to the BUI/BUD items so that they can
take advantage of this new feature.  This fixes a UAF bug in the
deferred bunmapi code because xfs_bui_recover can schedule another BUI
to continue unmapping but drops the inode pointer immediately
afterwards.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.h  |    5 +++-
 fs/xfs/libxfs/xfs_defer.c |   56 ++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/libxfs/xfs_defer.h |   18 ++++++++++++++
 fs/xfs/xfs_bmap_item.c    |   41 +++++++++++++++++++++++++++++++++
 fs/xfs/xfs_icache.c       |   49 +++++++++++++++++++++++++++++++++++++++
 5 files changed, 167 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index f3259ad5c22c..58f6c14f9100 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -253,7 +253,10 @@ enum xfs_bmap_intent_type {
 struct xfs_bmap_intent {
 	struct list_head			bi_list;
 	enum xfs_bmap_intent_type		bi_type;
-	struct xfs_inode			*bi_owner;
+	union {
+		struct xfs_inode		*bi_owner;
+		xfs_ino_t			bi_owner_ino;
+	};
 	int					bi_whichfork;
 	struct xfs_bmbt_irec			bi_bmap;
 };
diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 33e0f246e181..1cab95cef399 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -16,6 +16,7 @@
 #include "xfs_inode.h"
 #include "xfs_inode_item.h"
 #include "xfs_trace.h"
+#include "xfs_icache.h"
 
 /*
  * Deferred Operations in XFS
@@ -565,6 +566,7 @@ xfs_defer_freeze(
 {
 	struct xfs_defer_freezer	*dff;
 	struct xfs_defer_pending	*dfp;
+	unsigned int			i;
 	int				error;
 
 	*dffp = NULL;
@@ -577,6 +579,8 @@ xfs_defer_freeze(
 
 	INIT_LIST_HEAD(&dff->dff_list);
 	INIT_LIST_HEAD(&dff->dff_dfops);
+	for (i = 0; i < XFS_DEFER_FREEZER_INODES; i++)
+		dff->dff_ino[i] = NULLFSINO;
 
 	/* Freeze all of the dfops items attached to the transaction. */
 	list_for_each_entry(dfp, &tp->t_dfops, dfp_list) {
@@ -620,6 +624,11 @@ xfs_defer_thaw(
 
 	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
 
+	/* Grab all the inodes we wanted. */
+	error = xfs_defer_freezer_iget(dff, tp);
+	if (error)
+		return error;
+
 	/* Thaw each of the items. */
 	list_for_each_entry(dfp, &dff->dff_dfops, dfp_list) {
 		const struct xfs_defer_op_type *ops;
@@ -632,7 +641,7 @@ xfs_defer_thaw(
 		list_for_each(li, &dfp->dfp_work) {
 			error = ops->thaw_item(dff, li);
 			if (error)
-				return error;
+				goto out_irele;
 		}
 	}
 
@@ -641,6 +650,9 @@ xfs_defer_thaw(
 	tp->t_flags |= dff->dff_tpflags;
 
 	return 0;
+out_irele:
+	xfs_defer_freezer_irele(dff);
+	return error;
 }
 
 /* Release a deferred op freezer and all resources associated with it. */
@@ -650,5 +662,47 @@ xfs_defer_freeezer_finish(
 	struct xfs_defer_freezer	*dff)
 {
 	xfs_defer_cancel_list(mp, &dff->dff_dfops);
+	xfs_defer_freezer_irele(dff);
 	kmem_free(dff);
 }
+
+/* Attach an inode to this deferred ops freezer. */
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
+		if (dff->dff_ino[i] == NULLFSINO)
+			break;
+		if (dff->dff_ino[i] == ip->i_ino)
+			return 0;
+	}
+
+	if (i == XFS_DEFER_FREEZER_INODES) {
+		ASSERT(0);
+		return -EFSCORRUPTED;
+	}
+
+	dff->dff_ino[i] = ip->i_ino;
+	return 0;
+}
+
+/* Find an incore inode that has been attached to the freezer. */
+struct xfs_inode *
+xfs_defer_freezer_igrab(
+	struct xfs_defer_freezer	*dff,
+	xfs_ino_t			ino)
+{
+	unsigned int			i;
+
+	for (i = 0; i < XFS_DEFER_FREEZER_INODES; i++)
+		if (dff->dff_ino[i] == ino)
+			return dff->dff_inodes[i];
+
+	return NULL;
+}
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index 90e05f6af53c..e64b577a9b95 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -78,6 +78,16 @@ struct xfs_defer_freezer {
 	/* Deferred ops state saved from the transaction. */
 	struct list_head	dff_dfops;
 	unsigned int		dff_tpflags;
+
+	/*
+	 * Inodes to hold when we want to finish the deferred work items.
+	 * dfops freezer functions should set dff_ino.  xfs_defer_thaw will
+	 * fill out the dff_inodes array, from which the dfops thaw functions
+	 * can pick up the new inode pointers.
+	 */
+#define XFS_DEFER_FREEZER_INODES	2
+	xfs_ino_t		dff_ino[XFS_DEFER_FREEZER_INODES];
+	struct xfs_inode	*dff_inodes[XFS_DEFER_FREEZER_INODES];
 };
 
 /* Functions to freeze a chain of deferred operations for later. */
@@ -85,5 +95,13 @@ int xfs_defer_freeze(struct xfs_trans *tp, struct xfs_defer_freezer **dffp);
 int xfs_defer_thaw(struct xfs_defer_freezer *dff, struct xfs_trans *tp);
 void xfs_defer_freeezer_finish(struct xfs_mount *mp,
 		struct xfs_defer_freezer *dff);
+int xfs_defer_freezer_ijoin(struct xfs_defer_freezer *dff,
+		struct xfs_inode *ip);
+struct xfs_inode *xfs_defer_freezer_igrab(struct xfs_defer_freezer *dff,
+		xfs_ino_t ino);
+
+/* These functions must be provided by the xfs implementation. */
+void xfs_defer_freezer_irele(struct xfs_defer_freezer *dff);
+int xfs_defer_freezer_iget(struct xfs_defer_freezer *dff, struct xfs_trans *tp);
 
 #endif /* __XFS_DEFER_H__ */
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 5c22a902d8ca..267351fbea67 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -416,6 +416,45 @@ xfs_bmap_update_cancel_item(
 	kmem_free(bmap);
 }
 
+/* Prepare a deferred bmap item for freezing by detaching the inode. */
+STATIC int
+xfs_bmap_freeze_item(
+	struct xfs_defer_freezer	*freezer,
+	struct list_head		*item)
+{
+	struct xfs_bmap_intent		*bmap;
+	struct xfs_inode		*ip;
+	int				error;
+
+	bmap = container_of(item, struct xfs_bmap_intent, bi_list);
+
+	ip = bmap->bi_owner;
+	error = xfs_defer_freezer_ijoin(freezer, ip);
+	if (error)
+		return error;
+	bmap->bi_owner_ino = ip->i_ino;
+
+	return 0;
+}
+
+/* Thaw a deferred bmap item by reattaching the inode. */
+STATIC int
+xfs_bmap_thaw_item(
+	struct xfs_defer_freezer	*freezer,
+	struct list_head		*item)
+{
+	struct xfs_bmap_intent		*bmap;
+	struct xfs_inode		*ip;
+
+	bmap = container_of(item, struct xfs_bmap_intent, bi_list);
+	ip = xfs_defer_freezer_igrab(freezer, bmap->bi_owner_ino);
+	if (!ip)
+		return -EFSCORRUPTED;
+
+	bmap->bi_owner = ip;
+	return 0;
+}
+
 const struct xfs_defer_op_type xfs_bmap_update_defer_type = {
 	.max_items	= XFS_BUI_MAX_FAST_EXTENTS,
 	.diff_items	= xfs_bmap_update_diff_items,
@@ -425,6 +464,8 @@ const struct xfs_defer_op_type xfs_bmap_update_defer_type = {
 	.create_done	= xfs_bmap_update_create_done,
 	.finish_item	= xfs_bmap_update_finish_item,
 	.cancel_item	= xfs_bmap_update_cancel_item,
+	.freeze_item	= xfs_bmap_freeze_item,
+	.thaw_item	= xfs_bmap_thaw_item,
 };
 
 /*
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 8bf1d15be3f6..895dffc80acc 100644
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
@@ -1849,3 +1850,51 @@ xfs_start_block_reaping(
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
+		if (dff->dff_inodes[i]) {
+			xfs_iunlock(dff->dff_inodes[i], XFS_ILOCK_EXCL);
+			xfs_irele(dff->dff_inodes[i]);
+			dff->dff_inodes[i] = NULL;
+		}
+	}
+}
+
+/* Attach inodes to this freezer. */
+int
+xfs_defer_freezer_iget(
+	struct xfs_defer_freezer	*dff,
+	struct xfs_trans		*tp)
+{
+	unsigned int			i;
+	int				error;
+
+	for (i = 0; i < XFS_DEFER_FREEZER_INODES; i++) {
+		if (dff->dff_ino[i] == NULLFSINO)
+			continue;
+		error = xfs_iget(tp->t_mountp, tp, dff->dff_ino[i], 0, 0,
+				&dff->dff_inodes[i]);
+		if (error) {
+			xfs_defer_freezer_irele(dff);
+			return error;
+		}
+	}
+	if (dff->dff_inodes[1]) {
+		xfs_lock_two_inodes(dff->dff_inodes[0], XFS_ILOCK_EXCL,
+				    dff->dff_inodes[1], XFS_ILOCK_EXCL);
+		xfs_trans_ijoin(tp, dff->dff_inodes[0], 0);
+		xfs_trans_ijoin(tp, dff->dff_inodes[1], 0);
+	} else if (dff->dff_inodes[0]) {
+		xfs_ilock(dff->dff_inodes[0], XFS_ILOCK_EXCL);
+		xfs_trans_ijoin(tp, dff->dff_inodes[0], 0);
+	}
+
+	return 0;
+}

