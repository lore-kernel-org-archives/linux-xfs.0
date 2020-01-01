Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7F56C2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:10:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0A31206E4
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:10:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="owYEn9pm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727186AbgAABK5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:10:57 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:53968 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727132AbgAABK5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:10:57 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118xYj109458
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:10:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=epuWbMqbLuu/bf3BVCpd1lJf1PG45QVhqrbQ60btrtM=;
 b=owYEn9pmWu9hJhr+b2ZU3Ou6LQw/5Y6ftvdvU+2zH6dfPCN/aX+mw0LxN0PzxfIao2wn
 KoFATatlE5zhebKdr8S88mrTAKD6wHxJiWRpk7fWDmpz8PIftMxIt4UUjeY6ntSzHfa2
 vFy44kBxRuYfIv54b3ZVA0rIq7dR1QOYvIh0yY/82ScMfXl6uqf0exoLUfmDt7Dk+8GO
 QHSU6FNq2+/sKXVEmYnrVQr7SW+qb9iZtmrZoLJ2uORiXL7j2LfLUoB0sv77Q0t7fHsC
 us4mWgaEIEW/A04ikezhszF40EfPYwO/WVRbbsvkv1Qu15BhFUJSfM2FZ8DUCtGSKb7j 0Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2x5xftk2ex-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:10:54 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118uaT045290
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:10:53 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2x7medfc72-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:10:53 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0011Arg0006412
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:10:53 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:10:52 -0800
Subject: [PATCH 1/2] xfs: store inode btree block counts in AGI header
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:10:50 -0800
Message-ID: <157784105063.1364145.7272098446005713854.stgit@magnolia>
In-Reply-To: <157784104452.1364145.1438137657472587585.stgit@magnolia>
References: <157784104452.1364145.1438137657472587585.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=4 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=4 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010009
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add a btree block usage counters for both inode btrees to the AGI header
so that we don't have to walk the entire finobt at mount time to create
the per-AG reservations.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_ag.c           |    4 ++
 fs/xfs/libxfs/xfs_format.h       |   19 +++++++++
 fs/xfs/libxfs/xfs_ialloc.c       |    1 
 fs/xfs/libxfs/xfs_ialloc_btree.c |   79 ++++++++++++++++++++++++++++++++++----
 fs/xfs/scrub/agheader.c          |   30 ++++++++++++++
 fs/xfs/scrub/agheader_repair.c   |   17 ++++++++
 fs/xfs/xfs_ondisk.h              |    2 -
 fs/xfs/xfs_super.c               |    4 ++
 8 files changed, 146 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 14fbdf22b7e7..e2372e362e80 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -330,6 +330,10 @@ xfs_agiblock_init(
 	}
 	for (bucket = 0; bucket < XFS_AGI_UNLINKED_BUCKETS; bucket++)
 		agi->agi_unlinked[bucket] = cpu_to_be32(NULLAGINO);
+	if (xfs_sb_version_hasinobtcounts(&mp->m_sb)) {
+		agi->agi_iblocks = cpu_to_be32(1);
+		agi->agi_fblocks = cpu_to_be32(1);
+	}
 }
 
 typedef void (*aghdr_init_work_f)(struct xfs_mount *mp, struct xfs_buf *bp,
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 7f1616199d79..b778bf095a83 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -449,6 +449,7 @@ xfs_sb_has_compat_feature(
 #define XFS_SB_FEAT_RO_COMPAT_FINOBT   (1 << 0)		/* free inode btree */
 #define XFS_SB_FEAT_RO_COMPAT_RMAPBT   (1 << 1)		/* reverse map btree */
 #define XFS_SB_FEAT_RO_COMPAT_REFLINK  (1 << 2)		/* reflinked files */
+#define XFS_SB_FEAT_RO_COMPAT_INOBTCNT (1 << 3)		/* inobt block counts */
 #define XFS_SB_FEAT_RO_COMPAT_ALL \
 		(XFS_SB_FEAT_RO_COMPAT_FINOBT | \
 		 XFS_SB_FEAT_RO_COMPAT_RMAPBT | \
@@ -546,6 +547,18 @@ static inline bool xfs_sb_version_hasreflink(struct xfs_sb *sbp)
 		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_REFLINK);
 }
 
+/*
+ * Inode btree block counter.  We record the number of inobt and finobt blocks
+ * in the AGI header so that we can skip the finobt walk at mount time when
+ * setting up per-AG reservations.  Since this is mostly an optimization of an
+ * existing feature, we only enable it when that feature is also enabled.
+ */
+static inline bool xfs_sb_version_hasinobtcounts(struct xfs_sb *sbp)
+{
+	return xfs_sb_version_hasfinobt(sbp) &&
+		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_INOBTCNT);
+}
+
 /*
  * end of superblock version macros
  */
@@ -750,6 +763,9 @@ typedef struct xfs_agi {
 	__be32		agi_free_root; /* root of the free inode btree */
 	__be32		agi_free_level;/* levels in free inode btree */
 
+	__be32		agi_iblocks;	/* inobt blocks used */
+	__be32		agi_fblocks;	/* finobt blocks used */
+
 	/* structure must be padded to 64 bit alignment */
 } xfs_agi_t;
 
@@ -770,7 +786,8 @@ typedef struct xfs_agi {
 #define	XFS_AGI_ALL_BITS_R1	((1 << XFS_AGI_NUM_BITS_R1) - 1)
 #define	XFS_AGI_FREE_ROOT	(1 << 11)
 #define	XFS_AGI_FREE_LEVEL	(1 << 12)
-#define	XFS_AGI_NUM_BITS_R2	13
+#define	XFS_AGI_IBLOCKS		(1 << 13) /* both inobt/finobt block counters */
+#define	XFS_AGI_NUM_BITS_R2	14
 
 /* disk block (xfs_daddr_t) in the AG */
 #define XFS_AGI_DADDR(mp)	((xfs_daddr_t)(2 << (mp)->m_sectbb_log))
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 4a8b995c91f9..85762f4cd8ae 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2530,6 +2530,7 @@ xfs_ialloc_log_agi(
 		offsetof(xfs_agi_t, agi_unlinked),
 		offsetof(xfs_agi_t, agi_free_root),
 		offsetof(xfs_agi_t, agi_free_level),
+		offsetof(xfs_agi_t, agi_iblocks),
 		sizeof(xfs_agi_t)
 	};
 #ifdef DEBUG
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 67df4c9f809c..e20d7c076824 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -67,6 +67,25 @@ xfs_finobt_set_root(
 			   XFS_AGI_FREE_ROOT | XFS_AGI_FREE_LEVEL);
 }
 
+/* Update the inode btree block counter for this btree. */
+static inline void
+xfs_inobt_change_blocks(
+	struct xfs_btree_cur	*cur,
+	int			howmuch)
+{
+	struct xfs_buf		*agbp = cur->bc_private.a.agbp;
+	struct xfs_agi		*agi = XFS_BUF_TO_AGI(agbp);
+
+	if (!xfs_sb_version_hasinobtcounts(&cur->bc_mp->m_sb))
+		return;
+
+	if (cur->bc_btnum == XFS_BTNUM_FINO)
+		be32_add_cpu(&agi->agi_fblocks, howmuch);
+	else
+		be32_add_cpu(&agi->agi_iblocks, howmuch);
+	xfs_ialloc_log_agi(cur->bc_tp, agbp, XFS_AGI_IBLOCKS);
+}
+
 STATIC int
 __xfs_inobt_alloc_block(
 	struct xfs_btree_cur	*cur,
@@ -102,6 +121,7 @@ __xfs_inobt_alloc_block(
 
 	new->s = cpu_to_be32(XFS_FSB_TO_AGBNO(args.mp, args.fsbno));
 	*stat = 1;
+	xfs_inobt_change_blocks(cur, 1);
 	return 0;
 }
 
@@ -122,10 +142,17 @@ xfs_finobt_alloc_block(
 	union xfs_btree_ptr	*new,
 	int			*stat)
 {
+	int			error;
+
 	if (cur->bc_mp->m_finobt_nores)
-		return xfs_inobt_alloc_block(cur, start, new, stat);
-	return __xfs_inobt_alloc_block(cur, start, new, stat,
-			XFS_AG_RESV_METADATA);
+		error = xfs_inobt_alloc_block(cur, start, new, stat);
+	else
+		error = __xfs_inobt_alloc_block(cur, start, new, stat,
+				XFS_AG_RESV_METADATA);
+	if (error)
+		return error;
+
+	return 0;
 }
 
 STATIC int
@@ -134,6 +161,7 @@ __xfs_inobt_free_block(
 	struct xfs_buf		*bp,
 	enum xfs_ag_resv_type	resv)
 {
+	xfs_inobt_change_blocks(cur, -1);
 	return xfs_free_extent(cur->bc_tp,
 			XFS_DADDR_TO_FSB(cur->bc_mp, XFS_BUF_ADDR(bp)), 1,
 			&XFS_RMAP_OINFO_INOBT, resv);
@@ -483,20 +511,29 @@ xfs_inobt_commit_staged_btree(
 {
 	struct xfs_agi		*agi = XFS_BUF_TO_AGI(agbp);
 	struct xbtree_afakeroot	*afake = cur->bc_private.a.afake;
+	int			fields;
 
 	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
 
 	if (cur->bc_btnum == XFS_BTNUM_INO) {
+		fields = XFS_AGI_ROOT | XFS_AGI_LEVEL;
 		agi->agi_root = cpu_to_be32(afake->af_root);
 		agi->agi_level = cpu_to_be32(afake->af_levels);
-		xfs_ialloc_log_agi(cur->bc_tp, agbp, XFS_AGI_ROOT |
-						     XFS_AGI_LEVEL);
+		if (xfs_sb_version_hasinobtcounts(&cur->bc_mp->m_sb)) {
+			agi->agi_iblocks = cpu_to_be32(afake->af_blocks);
+			fields |= XFS_AGI_IBLOCKS;
+		}
+		xfs_ialloc_log_agi(cur->bc_tp, agbp, fields);
 		xfs_btree_commit_afakeroot(cur, agbp, &xfs_inobt_ops);
 	} else {
+		fields = XFS_AGI_FREE_ROOT | XFS_AGI_FREE_LEVEL;
 		agi->agi_free_root = cpu_to_be32(afake->af_root);
 		agi->agi_free_level = cpu_to_be32(afake->af_levels);
-		xfs_ialloc_log_agi(cur->bc_tp, agbp, XFS_AGI_FREE_ROOT |
-						     XFS_AGI_FREE_LEVEL);
+		if (xfs_sb_version_hasinobtcounts(&cur->bc_mp->m_sb)) {
+			agi->agi_fblocks = cpu_to_be32(afake->af_blocks);
+			fields |= XFS_AGI_IBLOCKS;
+		}
+		xfs_ialloc_log_agi(cur->bc_tp, agbp, fields);
 		xfs_btree_commit_afakeroot(cur, agbp, &xfs_finobt_ops);
 	}
 }
@@ -677,6 +714,28 @@ xfs_inobt_count_blocks(
 	return error;
 }
 
+/* Read finobt block count from AGI header. */
+static int
+xfs_finobt_read_blocks(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	xfs_agnumber_t		agno,
+	xfs_extlen_t		*tree_blocks)
+{
+	struct xfs_buf		*agbp;
+	struct xfs_agi		*agi;
+	int			error;
+
+	error = xfs_ialloc_read_agi(mp, tp, agno, &agbp);
+	if (error)
+		return error;
+
+	agi = XFS_BUF_TO_AGI(agbp);
+	*tree_blocks = be32_to_cpu(agi->agi_fblocks);
+	xfs_trans_brelse(tp, agbp);
+	return 0;
+}
+
 /*
  * Figure out how many blocks to reserve and how many are used by this btree.
  */
@@ -694,7 +753,11 @@ xfs_finobt_calc_reserves(
 	if (!xfs_sb_version_hasfinobt(&mp->m_sb))
 		return 0;
 
-	error = xfs_inobt_count_blocks(mp, tp, agno, XFS_BTNUM_FINO, &tree_len);
+	if (xfs_sb_version_hasinobtcounts(&mp->m_sb))
+		error = xfs_finobt_read_blocks(mp, tp, agno, &tree_len);
+	else
+		error = xfs_inobt_count_blocks(mp, tp, agno, XFS_BTNUM_FINO,
+				&tree_len);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index ba0f747c82e8..473482c962f3 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -781,6 +781,35 @@ xchk_agi_xref_icounts(
 		xchk_block_xref_set_corrupt(sc, sc->sa.agi_bp);
 }
 
+/* Check agi_[fi]blocks against tree size */
+static inline void
+xchk_agi_xref_fiblocks(
+	struct xfs_scrub	*sc)
+{
+	struct xfs_agi		*agi = XFS_BUF_TO_AGI(sc->sa.agi_bp);
+	xfs_agblock_t		blocks;
+	int			error = 0;
+
+	if (!xfs_sb_version_hasinobtcounts(&sc->mp->m_sb))
+		return;
+
+	if (sc->sa.ino_cur) {
+		error = xfs_btree_count_blocks(sc->sa.ino_cur, &blocks);
+		if (!xchk_should_check_xref(sc, &error, &sc->sa.ino_cur))
+			return;
+		if (blocks != be32_to_cpu(agi->agi_iblocks))
+			xchk_block_xref_set_corrupt(sc, sc->sa.agi_bp);
+	}
+
+	if (sc->sa.fino_cur) {
+		error = xfs_btree_count_blocks(sc->sa.fino_cur, &blocks);
+		if (!xchk_should_check_xref(sc, &error, &sc->sa.fino_cur))
+			return;
+		if (blocks != be32_to_cpu(agi->agi_fblocks))
+			xchk_block_xref_set_corrupt(sc, sc->sa.agi_bp);
+	}
+}
+
 /* Cross-reference with the other btrees. */
 STATIC void
 xchk_agi_xref(
@@ -804,6 +833,7 @@ xchk_agi_xref(
 	xchk_agi_xref_icounts(sc);
 	xchk_xref_is_owned_by(sc, agbno, 1, &XFS_RMAP_OINFO_FS);
 	xchk_xref_is_not_shared(sc, agbno, 1);
+	xchk_agi_xref_fiblocks(sc);
 
 	/* scrub teardown will take care of sc->sa for us */
 }
diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index 4ddae4ecece6..7883c292d8d3 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -818,17 +818,34 @@ xrep_agi_calc_from_btrees(
 	struct xfs_mount	*mp = sc->mp;
 	xfs_agino_t		count;
 	xfs_agino_t		freecount;
+	xfs_agblock_t		blocks;
 	int			error;
 
 	cur = xfs_inobt_init_cursor(mp, sc->tp, agi_bp, sc->sa.agno,
 			XFS_BTNUM_INO);
 	error = xfs_ialloc_count_inodes(cur, &count, &freecount);
+	if (error)
+		goto err;
+	error = xfs_btree_count_blocks(cur, &blocks);
 	if (error)
 		goto err;
 	xfs_btree_del_cursor(cur, error);
 
 	agi->agi_count = cpu_to_be32(count);
 	agi->agi_freecount = cpu_to_be32(freecount);
+
+	/* Update the AGI btree counters. */
+	if (xfs_sb_version_hasinobtcounts(&mp->m_sb)) {
+		agi->agi_iblocks = cpu_to_be32(blocks);
+
+		cur = xfs_inobt_init_cursor(mp, sc->tp, agi_bp, sc->sa.agno,
+				XFS_BTNUM_FINO);
+		if (error)
+			goto err;
+		xfs_btree_del_cursor(cur, error);
+		agi->agi_fblocks = cpu_to_be32(blocks);
+	}
+
 	return 0;
 err:
 	xfs_btree_del_cursor(cur, error);
diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index b6701b4f59a9..fa0ec2fae14a 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -23,7 +23,7 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(struct xfs_acl_entry,		12);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_agf,			224);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_agfl,			36);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_agi,			336);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_agi,			344);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_bmbt_key,		8);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_bmbt_rec,		16);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_bmdr_block,		4);
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index e3dbe7344982..f687181a2720 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1647,6 +1647,10 @@ xfs_fc_fill_super(
 		goto out_filestream_unmount;
 	}
 
+	if (xfs_sb_version_hasinobtcounts(&mp->m_sb))
+		xfs_warn(mp,
+ "EXPERIMENTAL inode btree counters feature in use. Use at your own risk!");
+
 	error = xfs_mountfs(mp);
 	if (error)
 		goto out_filestream_unmount;

