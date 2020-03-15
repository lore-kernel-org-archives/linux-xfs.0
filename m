Return-Path: <SRS0=0KAm=5A=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	UNWANTED_LANGUAGE_BODY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10C91C10DCE
	for <linux-xfs@archiver.kernel.org>; Sun, 15 Mar 2020 23:51:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF571206B1
	for <linux-xfs@archiver.kernel.org>; Sun, 15 Mar 2020 23:51:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="regMO67q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729060AbgCOXvL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 15 Mar 2020 19:51:11 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:35026 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729042AbgCOXvL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 15 Mar 2020 19:51:11 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02FNctBJ100063;
        Sun, 15 Mar 2020 23:51:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=RJ9W5xMTVdthyPutZ4fLtob8IF8Pf7JvSmAscWNMkvs=;
 b=regMO67qLkef2zW86dEHi8dZbgCproogOQpKdwSh8q4CLQRnJy6t2c7SDUBE3uSW8Gyk
 iSDBkT148/30sI4bWbLqR2VqG75LZ2iLBSCM+FqZcwMK6vL2PYlA84kIFldxHzmX2XGA
 NFR4DQv2pFX2IXVrvT+aqk+KD08F6F4vcRPHrww35eVWwtKZh7LzSIMaPG2QKbILfghi
 fKtjmmf1fzvtMvdLJA/q70V16zI0Uhzq3BnqcPtOVqhuV/6pJNUYKCyTOjh5fG9Z+PKY
 uaBQb/QZtK6yFGCJi31tK3WGaCh4OBFgZCSpsrPEt5XTb27kpj/FToFFAiBp7lcH2DlJ 4g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2yrq7km33p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 15 Mar 2020 23:51:08 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02FNoxSr041213;
        Sun, 15 Mar 2020 23:51:08 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2ys8tnq79b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 15 Mar 2020 23:51:08 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02FNp7QE024385;
        Sun, 15 Mar 2020 23:51:07 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 15 Mar 2020 16:51:07 -0700
Subject: [PATCH 4/7] xfs: add support for free space btree staging cursors
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Sun, 15 Mar 2020 16:51:06 -0700
Message-ID: <158431626637.357791.7694218797816175496.stgit@magnolia>
In-Reply-To: <158431623997.357791.9599758740528407024.stgit@magnolia>
References: <158431623997.357791.9599758740528407024.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9561 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 mlxscore=0
 malwarescore=0 suspectscore=4 mlxlogscore=999 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003150129
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9561 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=4
 adultscore=0 bulkscore=0 mlxlogscore=999 priorityscore=1501 clxscore=1015
 malwarescore=0 mlxscore=0 phishscore=0 impostorscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003150129
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add support for btree staging cursors for the free space btrees.  This
is needed both for online repair and also to convert xfs_repair to use
btree bulk loading.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc_btree.c |   98 +++++++++++++++++++++++++++++++--------
 fs/xfs/libxfs/xfs_alloc_btree.h |    7 +++
 2 files changed, 86 insertions(+), 19 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index a28041fdf4c0..93792ee7924e 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -12,6 +12,7 @@
 #include "xfs_sb.h"
 #include "xfs_mount.h"
 #include "xfs_btree.h"
+#include "xfs_btree_staging.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_alloc.h"
 #include "xfs_extent_busy.h"
@@ -19,7 +20,6 @@
 #include "xfs_trace.h"
 #include "xfs_trans.h"
 
-
 STATIC struct xfs_btree_cur *
 xfs_allocbt_dup_cursor(
 	struct xfs_btree_cur	*cur)
@@ -471,6 +471,41 @@ static const struct xfs_btree_ops xfs_cntbt_ops = {
 	.recs_inorder		= xfs_cntbt_recs_inorder,
 };
 
+/* Allocate most of a new allocation btree cursor. */
+STATIC struct xfs_btree_cur *
+xfs_allocbt_init_common(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	xfs_agnumber_t		agno,
+	xfs_btnum_t		btnum)
+{
+	struct xfs_btree_cur	*cur;
+
+	ASSERT(btnum == XFS_BTNUM_BNO || btnum == XFS_BTNUM_CNT);
+
+	cur = kmem_zone_zalloc(xfs_btree_cur_zone, KM_NOFS);
+
+	cur->bc_tp = tp;
+	cur->bc_mp = mp;
+	cur->bc_btnum = btnum;
+	cur->bc_blocklog = mp->m_sb.sb_blocklog;
+	cur->bc_ag.agno = agno;
+	cur->bc_ag.abt.active = false;
+
+	if (btnum == XFS_BTNUM_CNT) {
+		cur->bc_ops = &xfs_cntbt_ops;
+		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_abtc_2);
+	} else {
+		cur->bc_ops = &xfs_bnobt_ops;
+		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_abtb_2);
+	}
+
+	if (xfs_sb_version_hascrc(&mp->m_sb))
+		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
+
+	return cur;
+}
+
 /*
  * Allocate a new allocation btree cursor.
  */
@@ -485,36 +520,61 @@ xfs_allocbt_init_cursor(
 	struct xfs_agf		*agf = agbp->b_addr;
 	struct xfs_btree_cur	*cur;
 
-	ASSERT(btnum == XFS_BTNUM_BNO || btnum == XFS_BTNUM_CNT);
-
-	cur = kmem_zone_zalloc(xfs_btree_cur_zone, KM_NOFS);
-
-	cur->bc_tp = tp;
-	cur->bc_mp = mp;
-	cur->bc_btnum = btnum;
-	cur->bc_blocklog = mp->m_sb.sb_blocklog;
-
+	cur = xfs_allocbt_init_common(mp, tp, agno, btnum);
 	if (btnum == XFS_BTNUM_CNT) {
-		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_abtc_2);
-		cur->bc_ops = &xfs_cntbt_ops;
 		cur->bc_nlevels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]);
-		cur->bc_flags = XFS_BTREE_LASTREC_UPDATE;
+		cur->bc_flags |= XFS_BTREE_LASTREC_UPDATE;
 	} else {
-		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_abtb_2);
-		cur->bc_ops = &xfs_bnobt_ops;
 		cur->bc_nlevels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]);
 	}
 
 	cur->bc_ag.agbp = agbp;
-	cur->bc_ag.agno = agno;
-	cur->bc_ag.abt.active = false;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb))
-		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
+	return cur;
+}
 
+/* Create a free space btree cursor with a fake root for staging. */
+struct xfs_btree_cur *
+xfs_allocbt_stage_cursor(
+	struct xfs_mount	*mp,
+	struct xbtree_afakeroot	*afake,
+	xfs_agnumber_t		agno,
+	xfs_btnum_t		btnum)
+{
+	struct xfs_btree_cur	*cur;
+
+	cur = xfs_allocbt_init_common(mp, NULL, agno, btnum);
+	xfs_btree_stage_afakeroot(cur, afake);
 	return cur;
 }
 
+/*
+ * Install a new free space btree root.  Caller is responsible for invalidating
+ * and freeing the old btree blocks.
+ */
+void
+xfs_allocbt_commit_staged_btree(
+	struct xfs_btree_cur	*cur,
+	struct xfs_trans	*tp,
+	struct xfs_buf		*agbp)
+{
+	struct xfs_agf		*agf = agbp->b_addr;
+	struct xbtree_afakeroot	*afake = cur->bc_ag.afake;
+
+	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
+
+	agf->agf_roots[cur->bc_btnum] = cpu_to_be32(afake->af_root);
+	agf->agf_levels[cur->bc_btnum] = cpu_to_be32(afake->af_levels);
+	xfs_alloc_log_agf(tp, agbp, XFS_AGF_ROOTS | XFS_AGF_LEVELS);
+
+	if (cur->bc_btnum == XFS_BTNUM_BNO) {
+		xfs_btree_commit_afakeroot(cur, tp, agbp, &xfs_bnobt_ops);
+	} else {
+		cur->bc_flags |= XFS_BTREE_LASTREC_UPDATE;
+		xfs_btree_commit_afakeroot(cur, tp, agbp, &xfs_cntbt_ops);
+	}
+}
+
 /*
  * Calculate number of records in an alloc btree block.
  */
diff --git a/fs/xfs/libxfs/xfs_alloc_btree.h b/fs/xfs/libxfs/xfs_alloc_btree.h
index c9305ebb69f6..047f09f0be3c 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.h
+++ b/fs/xfs/libxfs/xfs_alloc_btree.h
@@ -13,6 +13,7 @@
 struct xfs_buf;
 struct xfs_btree_cur;
 struct xfs_mount;
+struct xbtree_afakeroot;
 
 /*
  * Btree block header size depends on a superblock flag.
@@ -48,8 +49,14 @@ struct xfs_mount;
 extern struct xfs_btree_cur *xfs_allocbt_init_cursor(struct xfs_mount *,
 		struct xfs_trans *, struct xfs_buf *,
 		xfs_agnumber_t, xfs_btnum_t);
+struct xfs_btree_cur *xfs_allocbt_stage_cursor(struct xfs_mount *mp,
+		struct xbtree_afakeroot *afake, xfs_agnumber_t agno,
+		xfs_btnum_t btnum);
 extern int xfs_allocbt_maxrecs(struct xfs_mount *, int, int);
 extern xfs_extlen_t xfs_allocbt_calc_size(struct xfs_mount *mp,
 		unsigned long long len);
 
+void xfs_allocbt_commit_staged_btree(struct xfs_btree_cur *cur,
+		struct xfs_trans *tp, struct xfs_buf *agbp);
+
 #endif	/* __XFS_ALLOC_BTREE_H__ */

