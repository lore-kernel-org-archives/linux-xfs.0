Return-Path: <SRS0=XxdV=7D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC18DC433E1
	for <linux-xfs@archiver.kernel.org>; Thu, 21 May 2020 02:35:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4C6C20709
	for <linux-xfs@archiver.kernel.org>; Thu, 21 May 2020 02:35:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbgEUCft (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 May 2020 22:35:49 -0400
Received: from sandeen.net ([63.231.237.45]:41446 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726944AbgEUCfs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 20 May 2020 22:35:48 -0400
Received: by sandeen.net (Postfix, from userid 500)
        id DB7AA323C1B; Wed, 20 May 2020 21:35:19 -0500 (CDT)
From:   Eric Sandeen <sandeen@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 3/7] xfs: fix up some whitespace in quota code
Date:   Wed, 20 May 2020 21:35:14 -0500
Message-Id: <1590028518-6043-4-git-send-email-sandeen@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1590028518-6043-1-git-send-email-sandeen@redhat.com>
References: <1590028518-6043-1-git-send-email-sandeen@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

There is a fair bit of whitespace damage in the quota code, so
fix up enough of it that subsequent patches are restricted to
functional change to aid review.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_qm.h       | 44 ++++++++++++++++++++++----------------------
 fs/xfs/xfs_quotaops.c |  8 ++++----
 2 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
index 4e57edc..3a85040 100644
--- a/fs/xfs/xfs_qm.h
+++ b/fs/xfs/xfs_qm.h
@@ -42,12 +42,12 @@
 #define XFS_DQUOT_CLUSTER_SIZE_FSB	(xfs_filblks_t)1
 
 struct xfs_def_quota {
-	xfs_qcnt_t       bhardlimit;     /* default data blk hard limit */
-	xfs_qcnt_t       bsoftlimit;	 /* default data blk soft limit */
-	xfs_qcnt_t       ihardlimit;	 /* default inode count hard limit */
-	xfs_qcnt_t       isoftlimit;	 /* default inode count soft limit */
-	xfs_qcnt_t	 rtbhardlimit;   /* default realtime blk hard limit */
-	xfs_qcnt_t	 rtbsoftlimit;   /* default realtime blk soft limit */
+	xfs_qcnt_t	bhardlimit;	/* default data blk hard limit */
+	xfs_qcnt_t	bsoftlimit;	/* default data blk soft limit */
+	xfs_qcnt_t	ihardlimit;	/* default inode count hard limit */
+	xfs_qcnt_t	isoftlimit;	/* default inode count soft limit */
+	xfs_qcnt_t	rtbhardlimit;	/* default realtime blk hard limit */
+	xfs_qcnt_t	rtbsoftlimit;	/* default realtime blk soft limit */
 };
 
 /*
@@ -55,28 +55,28 @@ struct xfs_def_quota {
  * The mount structure keeps a pointer to this.
  */
 struct xfs_quotainfo {
-	struct radix_tree_root qi_uquota_tree;
-	struct radix_tree_root qi_gquota_tree;
-	struct radix_tree_root qi_pquota_tree;
-	struct mutex qi_tree_lock;
+	struct radix_tree_root	qi_uquota_tree;
+	struct radix_tree_root	qi_gquota_tree;
+	struct radix_tree_root	qi_pquota_tree;
+	struct mutex		qi_tree_lock;
 	struct xfs_inode	*qi_uquotaip;	/* user quota inode */
 	struct xfs_inode	*qi_gquotaip;	/* group quota inode */
 	struct xfs_inode	*qi_pquotaip;	/* project quota inode */
-	struct list_lru	 qi_lru;
-	int		 qi_dquots;
-	time64_t	 qi_btimelimit;	 /* limit for blks timer */
-	time64_t	 qi_itimelimit;	 /* limit for inodes timer */
-	time64_t	 qi_rtbtimelimit;/* limit for rt blks timer */
-	xfs_qwarncnt_t	 qi_bwarnlimit;	 /* limit for blks warnings */
-	xfs_qwarncnt_t	 qi_iwarnlimit;	 /* limit for inodes warnings */
-	xfs_qwarncnt_t	 qi_rtbwarnlimit;/* limit for rt blks warnings */
-	struct mutex	 qi_quotaofflock;/* to serialize quotaoff */
-	xfs_filblks_t	 qi_dqchunklen;	 /* # BBs in a chunk of dqs */
-	uint		 qi_dqperchunk;	 /* # ondisk dqs in above chunk */
+	struct list_lru		qi_lru;
+	int			qi_dquots;
+	time64_t		qi_btimelimit;	/* limit for blks timer */
+	time64_t		qi_itimelimit;	/* limit for inodes timer */
+	time64_t		qi_rtbtimelimit;/* limit for rt blks timer */
+	xfs_qwarncnt_t		qi_bwarnlimit;	/* limit for blks warnings */
+	xfs_qwarncnt_t		qi_iwarnlimit;	/* limit for inodes warnings */
+	xfs_qwarncnt_t		qi_rtbwarnlimit;/* limit for rt blks warnings */
+	struct mutex		qi_quotaofflock;/* to serialize quotaoff */
+	xfs_filblks_t		qi_dqchunklen;	/* # BBs in a chunk of dqs */
+	uint			qi_dqperchunk;	/* # ondisk dq in above chunk */
 	struct xfs_def_quota	qi_usr_default;
 	struct xfs_def_quota	qi_grp_default;
 	struct xfs_def_quota	qi_prj_default;
-	struct shrinker	qi_shrinker;
+	struct shrinker		qi_shrinker;
 };
 
 static inline struct radix_tree_root *
diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
index b5d10ec..411eeef 100644
--- a/fs/xfs/xfs_quotaops.c
+++ b/fs/xfs/xfs_quotaops.c
@@ -23,8 +23,8 @@
 	struct xfs_inode	*ip,
 	xfs_ino_t		ino)
 {
-	struct xfs_quotainfo *q = mp->m_quotainfo;
-	bool tempqip = false;
+	struct xfs_quotainfo	*q = mp->m_quotainfo;
+	bool			tempqip = false;
 
 	tstate->ino = ino;
 	if (!ip && ino == NULLFSINO)
@@ -109,8 +109,8 @@
 	int			type,
 	struct qc_info		*info)
 {
-	struct xfs_mount *mp = XFS_M(sb);
-	struct qc_dqblk newlim;
+	struct xfs_mount	*mp = XFS_M(sb);
+	struct qc_dqblk		newlim;
 
 	if (sb_rdonly(sb))
 		return -EROFS;
-- 
1.8.3.1

