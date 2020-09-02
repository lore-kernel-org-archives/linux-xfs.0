Return-Path: <SRS0=53rf=CL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86BA2C433E2
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Sep 2020 02:56:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E9B120707
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Sep 2020 02:56:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CQTWY6Iu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbgIBC4G (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Sep 2020 22:56:06 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50466 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbgIBC4F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Sep 2020 22:56:05 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0822stgn003367;
        Wed, 2 Sep 2020 02:56:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=hz8m16XFE0DvIgVrMTAxRZD5W4R8KFTKSb7+5GapJ4Q=;
 b=CQTWY6IuctSQDpHFeuygUkeeSV19+Ot8pK5gWbp86Lj6SZB3tYC8hDIzeeaAH90Rsmrg
 D3K6wnzh91d72Mi7lDNhMOjPwZjDFBf3XAOkYoPfaK17E07S0eNHfFhR0qCVWz3jJuws
 sS41dQ4TwDuC+56A8j2AspujKHaIPPWWZyg7hWV4TYyO0/osoGzKtkmwzNYlmdaDvjmb
 a1Ot6eQUB/hVX3c7bGYlsQpN+Y9SPbXZvR1CI/9RVc97/qOTP+7CHZ1LC8O6UZKf3dHM
 9UjyyUwrv/xaAhO7FzQ4FeJ4nNqrpeIXHbrgBRxS6aAlVPwv8qbsRUwlUE2RlDpx5BsI XQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 337eeqyvhe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 02 Sep 2020 02:56:02 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0822tCtN037683;
        Wed, 2 Sep 2020 02:56:02 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 3380kp8hgf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Sep 2020 02:56:01 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0822u0BI031556;
        Wed, 2 Sep 2020 02:56:00 GMT
Received: from localhost (/10.159.133.7)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Sep 2020 19:56:00 -0700
Subject: [PATCH 1/5] xfs: store inode btree block counts in AGI header
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, bfoster@redhat.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 01 Sep 2020 19:55:58 -0700
Message-ID: <159901535858.547164.11928856896363415325.stgit@magnolia>
In-Reply-To: <159901535219.547164.1381621861988558776.stgit@magnolia>
References: <159901535219.547164.1381621861988558776.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9731 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 mlxscore=0 suspectscore=2 malwarescore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009020026
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9731 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxscore=0
 phishscore=0 impostorscore=0 mlxlogscore=999 bulkscore=0 suspectscore=2
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009020026
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
 fs/xfs/libxfs/xfs_ag.c           |    5 +++++
 fs/xfs/libxfs/xfs_format.h       |   18 +++++++++++++++++-
 fs/xfs/libxfs/xfs_ialloc.c       |    1 +
 fs/xfs/libxfs/xfs_ialloc_btree.c |   24 ++++++++++++++++++++++++
 fs/xfs/xfs_ondisk.h              |    2 +-
 fs/xfs/xfs_super.c               |    4 ++++
 6 files changed, 52 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 8cf73fe4338e..9331f3516afa 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
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
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 31b7ece985bb..03cbedb7eafc 100644
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
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index f742a96a2fe1..fef1d94c60a4 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2473,6 +2473,7 @@ xfs_ialloc_log_agi(
 		offsetof(xfs_agi_t, agi_unlinked),
 		offsetof(xfs_agi_t, agi_free_root),
 		offsetof(xfs_agi_t, agi_free_level),
+		offsetof(xfs_agi_t, agi_iblocks),
 		sizeof(xfs_agi_t)
 	};
 #ifdef DEBUG
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 3c8aebc36e64..cf51b342b6ef 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -67,6 +67,28 @@ xfs_finobt_set_root(
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
+	if (cur->bc_btnum == XFS_BTNUM_FINO &&
+	    xfs_sb_version_hasfinobt(&cur->bc_mp->m_sb)) {
+		be32_add_cpu(&agi->agi_fblocks, howmuch);
+		xfs_ialloc_log_agi(cur->bc_tp, agbp, XFS_AGI_IBLOCKS);
+	} else if (cur->bc_btnum == XFS_BTNUM_INO) {
+		be32_add_cpu(&agi->agi_iblocks, howmuch);
+		xfs_ialloc_log_agi(cur->bc_tp, agbp, XFS_AGI_IBLOCKS);
+	}
+}
+
 STATIC int
 __xfs_inobt_alloc_block(
 	struct xfs_btree_cur	*cur,
@@ -102,6 +124,7 @@ __xfs_inobt_alloc_block(
 
 	new->s = cpu_to_be32(XFS_FSB_TO_AGBNO(args.mp, args.fsbno));
 	*stat = 1;
+	xfs_inobt_mod_blockcount(cur, 1);
 	return 0;
 }
 
@@ -134,6 +157,7 @@ __xfs_inobt_free_block(
 	struct xfs_buf		*bp,
 	enum xfs_ag_resv_type	resv)
 {
+	xfs_inobt_mod_blockcount(cur, -1);
 	return xfs_free_extent(cur->bc_tp,
 			XFS_DADDR_TO_FSB(cur->bc_mp, XFS_BUF_ADDR(bp)), 1,
 			&XFS_RMAP_OINFO_INOBT, resv);
diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index 5f04d8a5ab2a..acb9b737fe6b 100644
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
index 71ac6c1cdc36..c7ffcb57b586 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1549,6 +1549,10 @@ xfs_fc_fill_super(
 		goto out_filestream_unmount;
 	}
 
+	if (xfs_sb_version_hasinobtcounts(&mp->m_sb))
+		xfs_warn(mp,
+ "EXPERIMENTAL inode btree counters feature in use. Use at your own risk!");
+
 	error = xfs_mountfs(mp);
 	if (error)
 		goto out_filestream_unmount;

