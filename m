Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CB19C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:20:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232026AbiATAUu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:20:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231831AbiATAUu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:20:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB8CDC061574
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jan 2022 16:20:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9CEDFB81A85
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:20:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 623A4C004E1;
        Thu, 20 Jan 2022 00:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638047;
        bh=UfwaX1wawSS4MvI4eLc7y/Ctu3bYSlGOpHJuTQ3utX4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=hsX9ASWlh49WnL6v3+U3tUeZesmbCxPlzrjagoB8hYQzihRdS8wM4RVHGlUMMexSy
         KVxrjl9O+8At8/DKIqOdUIwxAC/Js126YRTEAljxZVhU1nZC0iDSCci+2oOlDDikdT
         WYSmQFSGgAOWk4JBqBCFOhA6s0Twv8NE5RjVDOEoOvgHeLjp0NtJnHOvRnrtoLpN4G
         A8LDD4mnJ4LJiwLZxMBgq9BZEIoTaMBIOZybF8b8kY9rJyVYynZDiCm42jB0gVbIMO
         IVAy5ODMdx9MqX7YbTFQn55I0DN1nMLLUeV33vJ8pavPoVWvY4pF+E2PFdA4fLHKAE
         px8JXossUqkkw==
Subject: [PATCH 37/45] xfs: kill xfs_sb_version_has_v3inode()
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:20:47 -0800
Message-ID: <164263804705.860211.9491933488012909884.stgit@magnolia>
In-Reply-To: <164263784199.860211.7509808171577819673.stgit@magnolia>
References: <164263784199.860211.7509808171577819673.stgit@magnolia>
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
index 22a0c0c9..b5266b8f 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -441,7 +441,7 @@ pf_read_inode_dirs(
 		if (be16_to_cpu(dino->di_magic) != XFS_DINODE_MAGIC)
 			continue;
 
-		if (!libxfs_dinode_good_version(&mp->m_sb, dino->di_version))
+		if (!libxfs_dinode_good_version(mp, dino->di_version))
 			continue;
 
 		if (be64_to_cpu(dino->di_size) <= XFS_DFORK_DSIZE(dino, mp))

