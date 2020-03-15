Return-Path: <SRS0=0KAm=5A=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	UNWANTED_LANGUAGE_BODY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D864C10F29
	for <linux-xfs@archiver.kernel.org>; Sun, 15 Mar 2020 23:51:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66F10206BE
	for <linux-xfs@archiver.kernel.org>; Sun, 15 Mar 2020 23:51:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ih2tyBB4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729193AbgCOXvc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 15 Mar 2020 19:51:32 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:37960 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729191AbgCOXvc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 15 Mar 2020 19:51:32 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02FNd5HB015558;
        Sun, 15 Mar 2020 23:51:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=y9CNJE7+C+QnnXyVaKvz7mqPvc6XLY4cIN0O8sieVyw=;
 b=Ih2tyBB4uWFQxDM8IHUeyX8Lpxjhk8IiWAHmK2XJPR262fc+BzD5E9ju9IkHrqd49YP9
 jyRGpI0gTYD0UrFdDD1QA3nCBgaoarjq9Sh25f/KXjDDIBdGL03BtCiEPmjtT1TKq+Ia
 j+T5qqsP93mVPTZ9NGnjbaRRLNwWa7f8Vy7rBQ8kUMor/WoVQwKYFac5/Fg0566ao9yC
 sBL6y7zuRT/dORHBDHEsrgq/MK1IxdJi2Lh4kLJ30FySiMZmXOUGauXxWZvJ/qZjloUZ
 RRgUq3nhUW5TLuNLeP3ISSZwTbD3QR8VTmLA4LqnlTnTEaKV5tCaXleJFXw0Bjr5PISR sw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2yrppqv539-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 15 Mar 2020 23:51:29 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02FNoRo0121866;
        Sun, 15 Mar 2020 23:51:28 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2ys8yugbh9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 15 Mar 2020 23:51:28 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02FNpR9M001635;
        Sun, 15 Mar 2020 23:51:27 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 15 Mar 2020 16:51:27 -0700
Subject: [PATCH 7/7] xfs: add support for rmap btree staging cursors
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Sun, 15 Mar 2020 16:51:26 -0700
Message-ID: <158431628657.357791.17569681185422084457.stgit@magnolia>
In-Reply-To: <158431623997.357791.9599758740528407024.stgit@magnolia>
References: <158431623997.357791.9599758740528407024.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9561 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003150129
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9561 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 suspectscore=1 lowpriorityscore=0 phishscore=0 adultscore=0 clxscore=1015
 impostorscore=0 priorityscore=1501 spamscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003150129
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add support for btree staging cursors for the rmap btrees.  This is
needed both for online repair and also to convert xfs_repair to use
btree bulk loading.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_rmap_btree.c |   67 ++++++++++++++++++++++++++++++++++------
 fs/xfs/libxfs/xfs_rmap_btree.h |    5 +++
 2 files changed, 62 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index af7e4966416f..b7c05314d07c 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -14,6 +14,7 @@
 #include "xfs_trans.h"
 #include "xfs_alloc.h"
 #include "xfs_btree.h"
+#include "xfs_btree_staging.h"
 #include "xfs_rmap.h"
 #include "xfs_rmap_btree.h"
 #include "xfs_trace.h"
@@ -448,17 +449,12 @@ static const struct xfs_btree_ops xfs_rmapbt_ops = {
 	.recs_inorder		= xfs_rmapbt_recs_inorder,
 };
 
-/*
- * Allocate a new allocation btree cursor.
- */
-struct xfs_btree_cur *
-xfs_rmapbt_init_cursor(
+static struct xfs_btree_cur *
+xfs_rmapbt_init_common(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
-	struct xfs_buf		*agbp,
 	xfs_agnumber_t		agno)
 {
-	struct xfs_agf		*agf = agbp->b_addr;
 	struct xfs_btree_cur	*cur;
 
 	cur = kmem_zone_zalloc(xfs_btree_cur_zone, KM_NOFS);
@@ -468,16 +464,67 @@ xfs_rmapbt_init_cursor(
 	cur->bc_btnum = XFS_BTNUM_RMAP;
 	cur->bc_flags = XFS_BTREE_CRC_BLOCKS | XFS_BTREE_OVERLAPPING;
 	cur->bc_blocklog = mp->m_sb.sb_blocklog;
-	cur->bc_ops = &xfs_rmapbt_ops;
-	cur->bc_nlevels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]);
 	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_rmap_2);
+	cur->bc_ag.agno = agno;
+	cur->bc_ops = &xfs_rmapbt_ops;
 
+	return cur;
+}
+
+/* Create a new reverse mapping btree cursor. */
+struct xfs_btree_cur *
+xfs_rmapbt_init_cursor(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	struct xfs_buf		*agbp,
+	xfs_agnumber_t		agno)
+{
+	struct xfs_agf		*agf = agbp->b_addr;
+	struct xfs_btree_cur	*cur;
+
+	cur = xfs_rmapbt_init_common(mp, tp, agno);
+	cur->bc_nlevels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]);
 	cur->bc_ag.agbp = agbp;
-	cur->bc_ag.agno = agno;
+	return cur;
+}
+
+/* Create a new reverse mapping btree cursor with a fake root for staging. */
+struct xfs_btree_cur *
+xfs_rmapbt_stage_cursor(
+	struct xfs_mount	*mp,
+	struct xbtree_afakeroot	*afake,
+	xfs_agnumber_t		agno)
+{
+	struct xfs_btree_cur	*cur;
 
+	cur = xfs_rmapbt_init_common(mp, NULL, agno);
+	xfs_btree_stage_afakeroot(cur, afake);
 	return cur;
 }
 
+/*
+ * Install a new reverse mapping btree root.  Caller is responsible for
+ * invalidating and freeing the old btree blocks.
+ */
+void
+xfs_rmapbt_commit_staged_btree(
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
+	agf->agf_rmap_blocks = cpu_to_be32(afake->af_blocks);
+	xfs_alloc_log_agf(tp, agbp, XFS_AGF_ROOTS | XFS_AGF_LEVELS |
+				    XFS_AGF_RMAP_BLOCKS);
+	xfs_btree_commit_afakeroot(cur, tp, agbp, &xfs_rmapbt_ops);
+}
+
 /*
  * Calculate number of records in an rmap btree block.
  */
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.h b/fs/xfs/libxfs/xfs_rmap_btree.h
index 820d668b063d..115c3455a734 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.h
+++ b/fs/xfs/libxfs/xfs_rmap_btree.h
@@ -9,6 +9,7 @@
 struct xfs_buf;
 struct xfs_btree_cur;
 struct xfs_mount;
+struct xbtree_afakeroot;
 
 /* rmaps only exist on crc enabled filesystems */
 #define XFS_RMAP_BLOCK_LEN	XFS_BTREE_SBLOCK_CRC_LEN
@@ -43,6 +44,10 @@ struct xfs_mount;
 struct xfs_btree_cur *xfs_rmapbt_init_cursor(struct xfs_mount *mp,
 				struct xfs_trans *tp, struct xfs_buf *bp,
 				xfs_agnumber_t agno);
+struct xfs_btree_cur *xfs_rmapbt_stage_cursor(struct xfs_mount *mp,
+		struct xbtree_afakeroot *afake, xfs_agnumber_t agno);
+void xfs_rmapbt_commit_staged_btree(struct xfs_btree_cur *cur,
+		struct xfs_trans *tp, struct xfs_buf *agbp);
 int xfs_rmapbt_maxrecs(int blocklen, int leaf);
 extern void xfs_rmapbt_compute_maxlevels(struct xfs_mount *mp);
 

