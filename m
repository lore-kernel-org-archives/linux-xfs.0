Return-Path: <SRS0=1m5L=5B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D39FC0044D
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 19:35:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CEDDE206E2
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 19:35:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CUzfD3Zw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732418AbgCPTfs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Mar 2020 15:35:48 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:55618 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732413AbgCPTfs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Mar 2020 15:35:48 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02GJXYY5012001;
        Mon, 16 Mar 2020 19:35:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=i1DsnWhkU4f+4iN+CHQT6Obnh6oNGDQVpQOGxFl7lM8=;
 b=CUzfD3ZwEmrAKTZKQS9LyjK1t7ib+6CzmvveVqe7oJEuG6O9TIaZG2wYW1Bi2AlBR12u
 QQHmEtchGkzJA3WMrcSdJUGQQQv7EtDw7Wjt+BXNgaCp4gVNsNCM2QGcWesyi/HJZ7je
 whu9uTQsKWt30bEfX0B7fF1HaYEPA3barwiO2Dj7oJHQQsUBTGUwL8u7J3lMSicNsRBf
 2mLdj8+r7G2fEMN6KVVUYYmSxIGzecGAsAprgwVB2yk/d0Ugn9JyxOi8Ysjj+loSuXEQ
 uCpyHpzT/D2znaH+R/7/Cwjz3GF0mDeOjrum3edZ2pXWIhDVgud4XzoOPdkg6ra62oMW Kw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2yrqwn0tgs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Mar 2020 19:35:44 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02GJWUa3081780;
        Mon, 16 Mar 2020 19:35:44 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2ys8rd3mkb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Mar 2020 19:35:43 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02GJZh2l026519;
        Mon, 16 Mar 2020 19:35:43 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 16 Mar 2020 12:35:42 -0700
Date:   Mon, 16 Mar 2020 12:35:41 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Subject: [PATCH v2 4/7] xfs: add support for free space btree staging cursors
Message-ID: <20200316193541.GF256767@magnolia>
References: <158431623997.357791.9599758740528407024.stgit@magnolia>
 <158431626637.357791.7694218797816175496.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158431626637.357791.7694218797816175496.stgit@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9562 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 phishscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0 suspectscore=2
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003160083
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9562 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 mlxlogscore=999
 mlxscore=0 bulkscore=0 phishscore=0 spamscore=0 suspectscore=2
 malwarescore=0 priorityscore=1501 clxscore=1015 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003160083
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
v2: leave the LASTREC_UPDATE flag setting alone
---
 fs/xfs/libxfs/xfs_alloc_btree.c |   93 ++++++++++++++++++++++++++++++++-------
 fs/xfs/libxfs/xfs_alloc_btree.h |    7 +++
 2 files changed, 84 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index a28041fdf4c0..60c453cb3ee3 100644
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
@@ -471,18 +472,14 @@ static const struct xfs_btree_ops xfs_cntbt_ops = {
 	.recs_inorder		= xfs_cntbt_recs_inorder,
 };
 
-/*
- * Allocate a new allocation btree cursor.
- */
-struct xfs_btree_cur *			/* new alloc btree cursor */
-xfs_allocbt_init_cursor(
-	struct xfs_mount	*mp,		/* file system mount point */
-	struct xfs_trans	*tp,		/* transaction pointer */
-	struct xfs_buf		*agbp,		/* buffer for agf structure */
-	xfs_agnumber_t		agno,		/* allocation group number */
-	xfs_btnum_t		btnum)		/* btree identifier */
+/* Allocate most of a new allocation btree cursor. */
+STATIC struct xfs_btree_cur *
+xfs_allocbt_init_common(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	xfs_agnumber_t		agno,
+	xfs_btnum_t		btnum)
 {
-	struct xfs_agf		*agf = agbp->b_addr;
 	struct xfs_btree_cur	*cur;
 
 	ASSERT(btnum == XFS_BTNUM_BNO || btnum == XFS_BTNUM_CNT);
@@ -495,17 +492,14 @@ xfs_allocbt_init_cursor(
 	cur->bc_blocklog = mp->m_sb.sb_blocklog;
 
 	if (btnum == XFS_BTNUM_CNT) {
-		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_abtc_2);
 		cur->bc_ops = &xfs_cntbt_ops;
-		cur->bc_nlevels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]);
+		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_abtc_2);
 		cur->bc_flags = XFS_BTREE_LASTREC_UPDATE;
 	} else {
-		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_abtb_2);
 		cur->bc_ops = &xfs_bnobt_ops;
-		cur->bc_nlevels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]);
+		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_abtb_2);
 	}
 
-	cur->bc_ag.agbp = agbp;
 	cur->bc_ag.agno = agno;
 	cur->bc_ag.abt.active = false;
 
@@ -515,6 +509,73 @@ xfs_allocbt_init_cursor(
 	return cur;
 }
 
+/*
+ * Allocate a new allocation btree cursor.
+ */
+struct xfs_btree_cur *			/* new alloc btree cursor */
+xfs_allocbt_init_cursor(
+	struct xfs_mount	*mp,		/* file system mount point */
+	struct xfs_trans	*tp,		/* transaction pointer */
+	struct xfs_buf		*agbp,		/* buffer for agf structure */
+	xfs_agnumber_t		agno,		/* allocation group number */
+	xfs_btnum_t		btnum)		/* btree identifier */
+{
+	struct xfs_agf		*agf = agbp->b_addr;
+	struct xfs_btree_cur	*cur;
+
+	cur = xfs_allocbt_init_common(mp, tp, agno, btnum);
+	if (btnum == XFS_BTNUM_CNT)
+		cur->bc_nlevels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]);
+	else
+		cur->bc_nlevels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]);
+
+	cur->bc_ag.agbp = agbp;
+
+	return cur;
+}
+
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
+	return cur;
+}
+
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
