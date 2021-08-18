Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F2A8C43214
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Aug 2021 23:59:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CAD6610A3
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Aug 2021 23:59:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235348AbhHSAAR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Aug 2021 20:00:17 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:37200 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234931AbhHSAAQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Aug 2021 20:00:16 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 50E0186953F
        for <linux-xfs@vger.kernel.org>; Thu, 19 Aug 2021 09:59:39 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mGVT8-002JQ8-SF
        for linux-xfs@vger.kernel.org; Thu, 19 Aug 2021 09:59:38 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1mGVT8-000cwl-KV
        for linux-xfs@vger.kernel.org; Thu, 19 Aug 2021 09:59:38 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 16/16] xfs: kill xfs_sb_version_has_v3inode()
Date:   Thu, 19 Aug 2021 09:59:35 +1000
Message-Id: <20210818235935.149431-17-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210818235935.149431-1-david@fromorbit.com>
References: <20210818235935.149431-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=MhDmnRu9jo8A:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=9cW39zbgiq67NevJaTUA:9 a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

All callers to xfs_dinode_good_version() and XFS_DINODE_SIZE() in
both the kernel and userspace have a xfs_mount structure available
which means they can use mount features checks instead looking
directly are the superblock.

Convert these functions to take a mount and use a xfs_has_v3inodes()
check and move it out of the libxfs/xfs_format.h file as it really
doesn't have anything to do with the definition of the on-disk
format.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_format.h    | 18 +++---------------
 fs/xfs/libxfs/xfs_ialloc.c    |  3 +--
 fs/xfs/libxfs/xfs_inode_buf.c |  2 +-
 fs/xfs/libxfs/xfs_inode_buf.h | 11 ++++++++++-
 4 files changed, 15 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index ee479feb32b5..2d7057b7984b 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -414,18 +414,6 @@ xfs_sb_add_incompat_log_features(
 }
 
 
-/*
- * v5 file systems support V3 inodes only, earlier file systems support
- * v2 and v1 inodes.
- */
-static inline bool xfs_dinode_good_version(struct xfs_sb *sbp,
-		uint8_t version)
-{
-	if (xfs_sb_is_v5(sbp))
-		return version == 3;
-	return version == 1 || version == 2;
-}
-
 static inline bool
 xfs_is_quota_inode(struct xfs_sb *sbp, xfs_ino_t ino)
 {
@@ -892,12 +880,12 @@ enum xfs_dinode_fmt {
 /*
  * Inode size for given fs.
  */
-#define XFS_DINODE_SIZE(sbp) \
-	(xfs_sb_is_v5(sbp) ? \
+#define XFS_DINODE_SIZE(mp) \
+	(xfs_has_v3inodes(mp) ? \
 		sizeof(struct xfs_dinode) : \
 		offsetof(struct xfs_dinode, di_crc))
 #define XFS_LITINO(mp) \
-	((mp)->m_sb.sb_inodesize - XFS_DINODE_SIZE(&(mp)->m_sb))
+	((mp)->m_sb.sb_inodesize - XFS_DINODE_SIZE(mp))
 
 /*
  * Inode data & attribute fork sizes, per inode.
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index d2f436c1bf40..d943847c40c5 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -337,7 +337,6 @@ xfs_ialloc_inode_init(
 		xfs_buf_zero(fbuf, 0, BBTOB(fbuf->b_length));
 		for (i = 0; i < M_IGEO(mp)->inodes_per_cluster; i++) {
 			int	ioffset = i << mp->m_sb.sb_inodelog;
-			uint	isize = XFS_DINODE_SIZE(&mp->m_sb);
 
 			free = xfs_make_iptr(mp, fbuf, i);
 			free->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
@@ -354,7 +353,7 @@ xfs_ialloc_inode_init(
 			} else if (tp) {
 				/* just log the inode core */
 				xfs_trans_log_buf(tp, fbuf, ioffset,
-						  ioffset + isize - 1);
+					  ioffset + XFS_DINODE_SIZE(mp) - 1);
 			}
 		}
 
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index fefecdf3f632..036f909ff7a6 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -58,7 +58,7 @@ xfs_inode_buf_verify(
 		dip = xfs_buf_offset(bp, (i << mp->m_sb.sb_inodelog));
 		unlinked_ino = be32_to_cpu(dip->di_next_unlinked);
 		di_ok = xfs_verify_magic16(bp, dip->di_magic) &&
-			xfs_dinode_good_version(&mp->m_sb, dip->di_version) &&
+			xfs_dinode_good_version(mp, dip->di_version) &&
 			xfs_verify_agino_or_null(mp, agno, unlinked_ino);
 		if (unlikely(XFS_TEST_ERROR(!di_ok, mp,
 						XFS_ERRTAG_ITOBP_INOTOBP))) {
diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index 7f865bb4df84..585ed5a110af 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -21,7 +21,7 @@ struct xfs_imap {
 
 int	xfs_imap_to_bp(struct xfs_mount *mp, struct xfs_trans *tp,
 		       struct xfs_imap *imap, struct xfs_buf **bpp);
-void	xfs_dinode_calc_crc(struct xfs_mount *, struct xfs_dinode *);
+void	xfs_dinode_calc_crc(struct xfs_mount *mp, struct xfs_dinode *dip);
 void	xfs_inode_to_disk(struct xfs_inode *ip, struct xfs_dinode *to,
 			  xfs_lsn_t lsn);
 int	xfs_inode_from_disk(struct xfs_inode *ip, struct xfs_dinode *from);
@@ -42,4 +42,13 @@ static inline uint64_t xfs_inode_encode_bigtime(struct timespec64 tv)
 struct timespec64 xfs_inode_from_disk_ts(struct xfs_dinode *dip,
 		const xfs_timestamp_t ts);
 
+static inline bool
+xfs_dinode_good_version(struct xfs_mount *mp, uint8_t version)
+{
+	if (xfs_has_v3inodes(mp))
+		return version == 3;
+	return version == 1 || version == 2;
+}
+
+
 #endif	/* __XFS_INODE_BUF_H__ */
-- 
2.31.1

