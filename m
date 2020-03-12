Return-Path: <SRS0=K4IM=45=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B348CC1975A
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 03:46:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A048B206E2
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 03:46:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WaC5WCwn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387712AbgCLDqZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Mar 2020 23:46:25 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:44196 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387657AbgCLDqZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Mar 2020 23:46:25 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02C3epSk124508;
        Thu, 12 Mar 2020 03:46:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=YYmsBSVnRtR+Z2+otFORFDPZhD9Ts34kHXGv+yCa20Y=;
 b=WaC5WCwn/siNXARX/JiEBosQp3oU2qVSa8CoJQR6HD53a6Nle5x3KxtVmFtiKYfnClAE
 hiTtF/vI2NtwvEVtHOR+M6fKJ0IKbFEbe1U0zqzZma6rjHaP5cwofpXoNPCfTqp9NZ/N
 Ohptk7VxDm/UyhJ7fqNmbIdIwDr7DnuQ4PtDAA89pkMh7Ybq/UnOKCNEOb76jh7ON0Vl
 NAXV0WJXmBPFMGiApjSyGAWEtBpFm7u/vMOKo+yQUg9ByVjkldb1ClFg5FA5cRBZh1+n
 qCoW0yAmwSQ1u1FUxjCjKtibnpdKT0SlCvXTPb58gH8dADlkjYUEqdJGAv3jGi250jF1 EQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2yp7hmbj7x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 03:46:21 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02C3c3r0076360;
        Thu, 12 Mar 2020 03:46:21 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2ypv9wvqn7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 03:46:21 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02C3kKLa022667;
        Thu, 12 Mar 2020 03:46:20 GMT
Received: from localhost (/10.159.134.61)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 11 Mar 2020 20:46:20 -0700
Subject: [PATCH 7/7] xfs: add support for rmap btree staging cursors
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Wed, 11 Mar 2020 20:46:19 -0700
Message-ID: <158398477931.1308059.10155612350523939926.stgit@magnolia>
In-Reply-To: <158398473036.1308059.18353233923283406961.stgit@magnolia>
References: <158398473036.1308059.18353233923283406961.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9557 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxlogscore=999
 spamscore=0 malwarescore=0 mlxscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003120016
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9557 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0
 priorityscore=1501 clxscore=1015 mlxscore=0 impostorscore=0
 mlxlogscore=999 suspectscore=1 phishscore=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003120016
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add support for btree staging cursors for the rmap btrees.  This
is needed both for online repair and also to convert xfs_repair to use
btree bulk loading.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_rmap_btree.c |   66 ++++++++++++++++++++++++++++++++++------
 fs/xfs/libxfs/xfs_rmap_btree.h |    5 +++
 2 files changed, 61 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index af7e4966416f..a33543e1d434 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -448,17 +448,12 @@ static const struct xfs_btree_ops xfs_rmapbt_ops = {
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
@@ -468,16 +463,67 @@ xfs_rmapbt_init_cursor(
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
+	xfs_btree_stage_afakeroot(cur, afake, NULL);
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
 

