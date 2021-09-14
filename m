Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 038F4C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Sep 2021 02:43:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFF1C61108
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Sep 2021 02:43:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237802AbhINCof (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Sep 2021 22:44:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:53994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236205AbhINCod (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 13 Sep 2021 22:44:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A347606A5;
        Tue, 14 Sep 2021 02:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631587397;
        bh=EAKxHy20icKh9uuHjpnhsG+OYHU9vNXRB/kiPNOQ9/g=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=XQDATCMslzd8zj5xQlPJ8Jt7NNmRShMLZmwoXJ8hFByFvBAE55nsvYAa8UFsBEoUV
         EMWCiNIrPRbvYLoh4boo5IUPSKukbshu29VRYJtezrIFMferGXmErybYe5auVDmoY9
         AzxSGkqkqMqtbpNFv8OEqpV7nULFY/q++TYLz+d9J8BOgAv1aojlUESreZ7ODugzh8
         +r/x8/4VRzlsuZ9KQ/CekbtRU/AbIbHhhlBRO9d9liwRB+ybEpRPwMwH+JeDjmv3Vq
         QiYEXw8XiE3koil+7nxeSCmG+QWx6xqEhfeklOnQNbF+DWIwrrpT8ZmGPRXysHC/7a
         neNWtPNE/5V4w==
Subject: [PATCH 36/43] xfs: kill xfs_sb_version_has_v3inode()
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Mon, 13 Sep 2021 19:43:16 -0700
Message-ID: <163158739690.1604118.2602850202124735343.stgit@magnolia>
In-Reply-To: <163158719952.1604118.14415288328687941574.stgit@magnolia>
References: <163158719952.1604118.14415288328687941574.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit: cf28e17c9186c83e7e8702f844bc40b6e782ce6c

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
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/check.c             |    2 +-
 libxfs/xfs_format.h    |   18 +++---------------
 libxfs/xfs_ialloc.c    |    3 +--
 libxfs/xfs_inode_buf.c |    2 +-
 libxfs/xfs_inode_buf.h |   11 ++++++++++-
 repair/dinode.c        |    2 +-
 repair/prefetch.c      |    2 +-
 7 files changed, 18 insertions(+), 22 deletions(-)


diff --git a/db/check.c b/db/check.c
index a078e948..368f80c0 100644
--- a/db/check.c
+++ b/db/check.c
@@ -2796,7 +2796,7 @@ process_inode(
 		error++;
 		return;
 	}
-	if (!libxfs_dinode_good_version(&mp->m_sb, dip->di_version)) {
+	if (!libxfs_dinode_good_version(mp, dip->di_version)) {
 		if (isfree || v)
 			dbprintf(_("bad version number %#x for inode %lld\n"),
 				dip->di_version, ino);
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index ee479feb..2d7057b7 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
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
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index cbccc072..3b96e828 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -332,7 +332,6 @@ xfs_ialloc_inode_init(
 		xfs_buf_zero(fbuf, 0, BBTOB(fbuf->b_length));
 		for (i = 0; i < M_IGEO(mp)->inodes_per_cluster; i++) {
 			int	ioffset = i << mp->m_sb.sb_inodelog;
-			uint	isize = XFS_DINODE_SIZE(&mp->m_sb);
 
 			free = xfs_make_iptr(mp, fbuf, i);
 			free->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
@@ -349,7 +348,7 @@ xfs_ialloc_inode_init(
 			} else if (tp) {
 				/* just log the inode core */
 				xfs_trans_log_buf(tp, fbuf, ioffset,
-						  ioffset + isize - 1);
+					  ioffset + XFS_DINODE_SIZE(mp) - 1);
 			}
 		}
 
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 2638e515..dfff5979 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -55,7 +55,7 @@ xfs_inode_buf_verify(
 		dip = xfs_buf_offset(bp, (i << mp->m_sb.sb_inodelog));
 		unlinked_ino = be32_to_cpu(dip->di_next_unlinked);
 		di_ok = xfs_verify_magic16(bp, dip->di_magic) &&
-			xfs_dinode_good_version(&mp->m_sb, dip->di_version) &&
+			xfs_dinode_good_version(mp, dip->di_version) &&
 			xfs_verify_agino_or_null(mp, agno, unlinked_ino);
 		if (unlikely(XFS_TEST_ERROR(!di_ok, mp,
 						XFS_ERRTAG_ITOBP_INOTOBP))) {
diff --git a/libxfs/xfs_inode_buf.h b/libxfs/xfs_inode_buf.h
index 7f865bb4..585ed5a1 100644
--- a/libxfs/xfs_inode_buf.h
+++ b/libxfs/xfs_inode_buf.h
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
diff --git a/repair/dinode.c b/repair/dinode.c
index 3a79e18e..4da39dcc 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -2329,7 +2329,7 @@ process_dinode_int(xfs_mount_t *mp,
 		}
 	}
 
-	if (!libxfs_dinode_good_version(&mp->m_sb, dino->di_version)) {
+	if (!libxfs_dinode_good_version(mp, dino->di_version)) {
 		retval = 1;
 		if (!uncertain)
 			do_warn(_("bad version number 0x%x on inode %" PRIu64 "%c"),
diff --git a/repair/prefetch.c b/repair/prefetch.c
index 48affa18..ef5d40da 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -441,7 +441,7 @@ pf_read_inode_dirs(
 		if (be16_to_cpu(dino->di_magic) != XFS_DINODE_MAGIC)
 			continue;
 
-		if (!libxfs_dinode_good_version(&mp->m_sb, dino->di_version))
+		if (!libxfs_dinode_good_version(mp, dino->di_version))
 			continue;
 
 		if (be64_to_cpu(dino->di_size) <= XFS_DFORK_DSIZE(dino, mp))

