Return-Path: <SRS0=K4IM=45=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	UNWANTED_LANGUAGE_BODY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A6D7C10DCE
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 03:46:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 54DA2206E2
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 03:46:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HbDWIHml"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387677AbgCLDqS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Mar 2020 23:46:18 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:36730 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387657AbgCLDqS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Mar 2020 23:46:18 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02C3hBRs181387;
        Thu, 12 Mar 2020 03:46:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Y9bpYe3kBK2777VJCDLBsmkPllHbqFhBS4IM64S9vdg=;
 b=HbDWIHmlgl5hrO/rKIfqdoUG+3H0WZOVX8zGhARz5cy7jjPqzt5oEGwPD1x9eQq/a3o5
 SEV8GFfnNUsgMqc4aqr5vj9PNuliirNd7rh4yNznnfYwAS3xHogDSe532Z+y9D0Rw1C3
 O6RKfl+DGCmqJ7/ocndhnE85n4r+4PhlDqyG2WVjvaiSqAEOnNCbhC1rBXN77arlhu9L
 o9DK6TnLLAn5tlKA+UF8JxcMzH2kLq2IsF+1HL9GI5c0Cei/tFNjMKeBdrwY4K3kcdJ4
 ramoGdoTR3Dh4dsxz0EQEejoYoBdNhtJGo9ZINDg74s/sfTAD+JoPqujJu52vNSiS5A7 Uw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2ym31uq7ac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 03:46:15 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02C3c89v054885;
        Thu, 12 Mar 2020 03:46:14 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2yp8p5r20p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 03:46:14 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02C3kErv022550;
        Thu, 12 Mar 2020 03:46:14 GMT
Received: from localhost (/10.159.134.61)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 11 Mar 2020 20:46:14 -0700
Subject: [PATCH 6/7] xfs: add support for refcount btree staging cursors
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Wed, 11 Mar 2020 20:46:13 -0700
Message-ID: <158398477303.1308059.14416573528483217275.stgit@magnolia>
In-Reply-To: <158398473036.1308059.18353233923283406961.stgit@magnolia>
References: <158398473036.1308059.18353233923283406961.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9557 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 spamscore=0 malwarescore=0 adultscore=0 suspectscore=1 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003120016
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9557 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 lowpriorityscore=0
 spamscore=0 priorityscore=1501 impostorscore=0 bulkscore=0 suspectscore=1
 phishscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003120016
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add support for btree staging cursors for the refcount btrees.  This
is needed both for online repair and also to convert xfs_repair to use
btree bulk loading.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_refcount_btree.c |   69 +++++++++++++++++++++++++++++++-----
 fs/xfs/libxfs/xfs_refcount_btree.h |    6 +++
 2 files changed, 65 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index e07a2c45f8ec..0224b13733c8 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -311,41 +311,90 @@ static const struct xfs_btree_ops xfs_refcountbt_ops = {
 };
 
 /*
- * Allocate a new refcount btree cursor.
+ * Initialize a new refcount btree cursor.
  */
-struct xfs_btree_cur *
-xfs_refcountbt_init_cursor(
+static struct xfs_btree_cur *
+xfs_refcountbt_init_common(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
-	struct xfs_buf		*agbp,
 	xfs_agnumber_t		agno)
 {
-	struct xfs_agf		*agf = agbp->b_addr;
 	struct xfs_btree_cur	*cur;
 
 	ASSERT(agno != NULLAGNUMBER);
 	ASSERT(agno < mp->m_sb.sb_agcount);
-	cur = kmem_zone_zalloc(xfs_btree_cur_zone, KM_NOFS);
 
+	cur = kmem_zone_zalloc(xfs_btree_cur_zone, KM_NOFS);
 	cur->bc_tp = tp;
 	cur->bc_mp = mp;
 	cur->bc_btnum = XFS_BTNUM_REFC;
 	cur->bc_blocklog = mp->m_sb.sb_blocklog;
-	cur->bc_ops = &xfs_refcountbt_ops;
 	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_refcbt_2);
 
-	cur->bc_nlevels = be32_to_cpu(agf->agf_refcount_level);
-
-	cur->bc_ag.agbp = agbp;
 	cur->bc_ag.agno = agno;
 	cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
 
 	cur->bc_ag.refc.nr_ops = 0;
 	cur->bc_ag.refc.shape_changes = 0;
+	cur->bc_ops = &xfs_refcountbt_ops;
+	return cur;
+}
+
+/* Create a btree cursor. */
+struct xfs_btree_cur *
+xfs_refcountbt_init_cursor(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	struct xfs_buf		*agbp,
+	xfs_agnumber_t		agno)
+{
+	struct xfs_agf		*agf = agbp->b_addr;
+	struct xfs_btree_cur	*cur;
+
+	cur = xfs_refcountbt_init_common(mp, tp, agno);
+	cur->bc_nlevels = be32_to_cpu(agf->agf_refcount_level);
+	cur->bc_ag.agbp = agbp;
+	return cur;
+}
+
+/* Create a btree cursor with a fake root for staging. */
+struct xfs_btree_cur *
+xfs_refcountbt_stage_cursor(
+	struct xfs_mount	*mp,
+	struct xbtree_afakeroot	*afake,
+	xfs_agnumber_t		agno)
+{
+	struct xfs_btree_cur	*cur;
 
+	cur = xfs_refcountbt_init_common(mp, NULL, agno);
+	xfs_btree_stage_afakeroot(cur, afake, NULL);
 	return cur;
 }
 
+/*
+ * Swap in the new btree root.  Once we pass this point the newly rebuilt btree
+ * is in place and we have to kill off all the old btree blocks.
+ */
+void
+xfs_refcountbt_commit_staged_btree(
+	struct xfs_btree_cur	*cur,
+	struct xfs_trans	*tp,
+	struct xfs_buf		*agbp)
+{
+	struct xfs_agf		*agf = agbp->b_addr;
+	struct xbtree_afakeroot	*afake = cur->bc_ag.afake;
+
+	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
+
+	agf->agf_refcount_root = cpu_to_be32(afake->af_root);
+	agf->agf_refcount_level = cpu_to_be32(afake->af_levels);
+	agf->agf_refcount_blocks = cpu_to_be32(afake->af_blocks);
+	xfs_alloc_log_agf(tp, agbp, XFS_AGF_REFCOUNT_BLOCKS |
+				    XFS_AGF_REFCOUNT_ROOT |
+				    XFS_AGF_REFCOUNT_LEVEL);
+	xfs_btree_commit_afakeroot(cur, tp, agbp, &xfs_refcountbt_ops);
+}
+
 /*
  * Calculate the number of records in a refcount btree block.
  */
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.h b/fs/xfs/libxfs/xfs_refcount_btree.h
index ba416f71c824..69dc515db671 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.h
+++ b/fs/xfs/libxfs/xfs_refcount_btree.h
@@ -13,6 +13,7 @@
 struct xfs_buf;
 struct xfs_btree_cur;
 struct xfs_mount;
+struct xbtree_afakeroot;
 
 /*
  * Btree block header size
@@ -46,6 +47,8 @@ struct xfs_mount;
 extern struct xfs_btree_cur *xfs_refcountbt_init_cursor(struct xfs_mount *mp,
 		struct xfs_trans *tp, struct xfs_buf *agbp,
 		xfs_agnumber_t agno);
+struct xfs_btree_cur *xfs_refcountbt_stage_cursor(struct xfs_mount *mp,
+		struct xbtree_afakeroot *afake, xfs_agnumber_t agno);
 extern int xfs_refcountbt_maxrecs(int blocklen, bool leaf);
 extern void xfs_refcountbt_compute_maxlevels(struct xfs_mount *mp);
 
@@ -58,4 +61,7 @@ extern int xfs_refcountbt_calc_reserves(struct xfs_mount *mp,
 		struct xfs_trans *tp, xfs_agnumber_t agno, xfs_extlen_t *ask,
 		xfs_extlen_t *used);
 
+void xfs_refcountbt_commit_staged_btree(struct xfs_btree_cur *cur,
+		struct xfs_trans *tp, struct xfs_buf *agbp);
+
 #endif	/* __XFS_REFCOUNT_BTREE_H__ */

