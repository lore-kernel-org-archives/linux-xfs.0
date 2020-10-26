Return-Path: <SRS0=rYOu=EB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 700E3C4363A
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:35:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3286A20809
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:35:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UoospNJc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406899AbgJZXfZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Oct 2020 19:35:25 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:55278 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406870AbgJZXfY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Oct 2020 19:35:24 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNOqgc164732;
        Mon, 26 Oct 2020 23:35:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=CirmuzRLP4XMykVGAKcESQs0ysv0rONPduAnIOIEBzQ=;
 b=UoospNJceENSqJi1yKIJ22Nl4yfQpCjwGuQubtb+qKhb0LBAUDp1t6iVFvaF9+V/ZZ38
 u1D8xCRpvqhiluRFvEl89VCx5qXJ5HMG4W2ceGJaB5R7YZaxpYkEQCiA/u0gwmR41OWN
 DeMe42z/IY/OXC1uzuz8doZklI7IZvq+5ZkOcpkfiKYvFxMIYtLHiIKVEGVhQc0efiVA
 8lG+FgbXq/8Y2hRTPVvF8UHgjZBH/CEUiAeD8lvtO1VwcCvarRhm5w7vPvoxj1wlmZVi
 yyVapqSy1NBlSOpjSFuys3TXAcABBP7A5N9fJo6eoegPkIxiDAG/88QjljJIj7mCnfFE KQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 34dgm3vus4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 23:35:20 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNQN7i058358;
        Mon, 26 Oct 2020 23:33:20 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 34cwukr7xb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 23:33:20 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09QNXJWd007042;
        Mon, 26 Oct 2020 23:33:19 GMT
Received: from localhost (/10.159.145.170)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 16:33:14 -0700
Subject: [PATCH 1/9] xfs: store inode btree block counts in AGI header
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com, bfoster@redhat.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Oct 2020 16:33:12 -0700
Message-ID: <160375519217.880355.11973101156874824577.stgit@magnolia>
In-Reply-To: <160375518573.880355.12052697509237086329.stgit@magnolia>
References: <160375518573.880355.12052697509237086329.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 suspectscore=2
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 suspectscore=2 clxscore=1015 mlxscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260153
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Source kernel commit: 2a39946c984464e4aac82c556ba9915589be7323

Add a btree block usage counters for both inode btrees to the AGI header
so that we don't have to walk the entire finobt at mount time to create
the per-AG reservations.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_ag.c           |    5 +++++
 libxfs/xfs_format.h       |   18 +++++++++++++++++-
 libxfs/xfs_ialloc.c       |    1 +
 libxfs/xfs_ialloc_btree.c |   21 +++++++++++++++++++++
 4 files changed, 44 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index ceaa7e5e4640..af8a0afdda93 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -333,6 +333,11 @@ xfs_agiblock_init(
 	}
 	for (bucket = 0; bucket < XFS_AGI_UNLINKED_BUCKETS; bucket++)
 		agi->agi_unlinked[bucket] = cpu_to_be32(NULLAGINO);
+	if (xfs_sb_version_hasinobtcounts(&mp->m_sb)) {
+		agi->agi_iblocks = cpu_to_be32(1);
+		if (xfs_sb_version_hasfinobt(&mp->m_sb))
+			agi->agi_fblocks = cpu_to_be32(1);
+	}
 }
 
 typedef void (*aghdr_init_work_f)(struct xfs_mount *mp, struct xfs_buf *bp,
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index f0ecd064ff14..01544f9d5a57 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -449,6 +449,7 @@ xfs_sb_has_compat_feature(
 #define XFS_SB_FEAT_RO_COMPAT_FINOBT   (1 << 0)		/* free inode btree */
 #define XFS_SB_FEAT_RO_COMPAT_RMAPBT   (1 << 1)		/* reverse map btree */
 #define XFS_SB_FEAT_RO_COMPAT_REFLINK  (1 << 2)		/* reflinked files */
+#define XFS_SB_FEAT_RO_COMPAT_INOBTCNT (1 << 3)		/* inobt block counts */
 #define XFS_SB_FEAT_RO_COMPAT_ALL \
 		(XFS_SB_FEAT_RO_COMPAT_FINOBT | \
 		 XFS_SB_FEAT_RO_COMPAT_RMAPBT | \
@@ -563,6 +564,17 @@ static inline bool xfs_sb_version_hasreflink(struct xfs_sb *sbp)
 		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_REFLINK);
 }
 
+/*
+ * Inode btree block counter.  We record the number of inobt and finobt blocks
+ * in the AGI header so that we can skip the finobt walk at mount time when
+ * setting up per-AG reservations.
+ */
+static inline bool xfs_sb_version_hasinobtcounts(struct xfs_sb *sbp)
+{
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
+		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_INOBTCNT);
+}
+
 /*
  * end of superblock version macros
  */
@@ -765,6 +777,9 @@ typedef struct xfs_agi {
 	__be32		agi_free_root; /* root of the free inode btree */
 	__be32		agi_free_level;/* levels in free inode btree */
 
+	__be32		agi_iblocks;	/* inobt blocks used */
+	__be32		agi_fblocks;	/* finobt blocks used */
+
 	/* structure must be padded to 64 bit alignment */
 } xfs_agi_t;
 
@@ -785,7 +800,8 @@ typedef struct xfs_agi {
 #define	XFS_AGI_ALL_BITS_R1	((1 << XFS_AGI_NUM_BITS_R1) - 1)
 #define	XFS_AGI_FREE_ROOT	(1 << 11)
 #define	XFS_AGI_FREE_LEVEL	(1 << 12)
-#define	XFS_AGI_NUM_BITS_R2	13
+#define	XFS_AGI_IBLOCKS		(1 << 13) /* both inobt/finobt block counters */
+#define	XFS_AGI_NUM_BITS_R2	14
 
 /* disk block (xfs_daddr_t) in the AG */
 #define XFS_AGI_DADDR(mp)	((xfs_daddr_t)(2 << (mp)->m_sectbb_log))
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index ce73feed981c..8adeb10e5d2e 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -2468,6 +2468,7 @@ xfs_ialloc_log_agi(
 		offsetof(xfs_agi_t, agi_unlinked),
 		offsetof(xfs_agi_t, agi_free_root),
 		offsetof(xfs_agi_t, agi_free_level),
+		offsetof(xfs_agi_t, agi_iblocks),
 		sizeof(xfs_agi_t)
 	};
 #ifdef DEBUG
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index 41c308c2e54c..3ed87d1c7251 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -66,6 +66,25 @@ xfs_finobt_set_root(
 			   XFS_AGI_FREE_ROOT | XFS_AGI_FREE_LEVEL);
 }
 
+/* Update the inode btree block counter for this btree. */
+static inline void
+xfs_inobt_mod_blockcount(
+	struct xfs_btree_cur	*cur,
+	int			howmuch)
+{
+	struct xfs_buf		*agbp = cur->bc_ag.agbp;
+	struct xfs_agi		*agi = agbp->b_addr;
+
+	if (!xfs_sb_version_hasinobtcounts(&cur->bc_mp->m_sb))
+		return;
+
+	if (cur->bc_btnum == XFS_BTNUM_FINO)
+		be32_add_cpu(&agi->agi_fblocks, howmuch);
+	else if (cur->bc_btnum == XFS_BTNUM_INO)
+		be32_add_cpu(&agi->agi_iblocks, howmuch);
+	xfs_ialloc_log_agi(cur->bc_tp, agbp, XFS_AGI_IBLOCKS);
+}
+
 STATIC int
 __xfs_inobt_alloc_block(
 	struct xfs_btree_cur	*cur,
@@ -101,6 +120,7 @@ __xfs_inobt_alloc_block(
 
 	new->s = cpu_to_be32(XFS_FSB_TO_AGBNO(args.mp, args.fsbno));
 	*stat = 1;
+	xfs_inobt_mod_blockcount(cur, 1);
 	return 0;
 }
 
@@ -133,6 +153,7 @@ __xfs_inobt_free_block(
 	struct xfs_buf		*bp,
 	enum xfs_ag_resv_type	resv)
 {
+	xfs_inobt_mod_blockcount(cur, -1);
 	return xfs_free_extent(cur->bc_tp,
 			XFS_DADDR_TO_FSB(cur->bc_mp, XFS_BUF_ADDR(bp)), 1,
 			&XFS_RMAP_OINFO_INOBT, resv);

