Return-Path: <SRS0=h+lF=5C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B252C1975A
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Mar 2020 19:02:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 686CF20674
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Mar 2020 19:02:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="IEE11/zK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbgCQTCX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Mar 2020 15:02:23 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:57232 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726294AbgCQTCW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Mar 2020 15:02:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=wRpTI237gvRmHk6IlZw01T7yx4Z/hStfKCe7awTywKE=; b=IEE11/zK9RFuoWUXkaxrfwibIc
        TucAcU0TUOTx2LVzzt72xQTIgbUMGv8fPgtMJhpe6m3a8joDN4zSoY0/zg9GkjmO9ZsI3o79d9tz2
        6N3eZ+oo46lEGuDVH5brIeNmatweFgyvuenoCJvRKZjzZcVJy8ZrU7AIo8ITqSF9e4dOpXdmo6o3X
        wU8IobPUnRYROynipZXPAz62MIgXVjRJYzPkWDs4iLZOZFVUCYJh/UA3PsQja2jCCFph4S1APrpHV
        egIEB+bCSkp/vLsNz08nwcB7p6UBE0HScLL8ptgA/2yrye1JGUIPRXtKIdrFjwKKwWZYRg1kBZ8CK
        dcBNprTw==;
Received: from 089144202225.atnat0011.highway.a1.net ([89.144.202.225] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jEHTq-00036U-8a
        for linux-xfs@vger.kernel.org; Tue, 17 Mar 2020 19:02:22 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/5] xfs: add a new xfs_sb_version_has_v3inode helper
Date:   Tue, 17 Mar 2020 19:57:52 +0100
Message-Id: <20200317185756.1063268-2-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200317185756.1063268-1-hch@lst.de>
References: <20200317185756.1063268-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Add a new wrapper to check if a file system supports the v3 inode format
with a larger dinode core.  Previously we used xfs_sb_version_hascrc for
that, which is technically correct but a little confusing to read.

Also move xfs_dinode_good_version next to xfs_sb_version_has_v3inode
so that we have one place that documents the superblock version to
inode version relationship.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_format.h     | 17 +++++++++++++++++
 fs/xfs/libxfs/xfs_ialloc.c     |  4 ++--
 fs/xfs/libxfs/xfs_inode_buf.c  | 17 +++--------------
 fs/xfs/libxfs/xfs_inode_buf.h  |  2 --
 fs/xfs/libxfs/xfs_trans_resv.c |  2 +-
 fs/xfs/xfs_buf_item.c          |  2 +-
 fs/xfs/xfs_log_recover.c       |  2 +-
 7 files changed, 25 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index cd814f99da28..19899d48517c 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -497,6 +497,23 @@ static inline bool xfs_sb_version_hascrc(struct xfs_sb *sbp)
 	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5;
 }
 
+/*
+ * v5 file systems support V3 inodes only, earlier file systems support
+ * v2 and v1 inodes.
+ */
+static inline bool xfs_sb_version_has_v3inode(struct xfs_sb *sbp)
+{
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5;
+}
+
+static inline bool xfs_dinode_good_version(struct xfs_sb *sbp,
+		uint8_t version)
+{
+	if (xfs_sb_version_has_v3inode(sbp))
+		return version == 3;
+	return version == 1 || version == 2;
+}
+
 static inline bool xfs_sb_version_has_pquotino(struct xfs_sb *sbp)
 {
 	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5;
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 21ac3fb52f4e..4de61af3b840 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -304,7 +304,7 @@ xfs_ialloc_inode_init(
 	 * That means for v3 inode we log the entire buffer rather than just the
 	 * inode cores.
 	 */
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
 		version = 3;
 		ino = XFS_AGINO_TO_INO(mp, agno, XFS_AGB_TO_AGINO(mp, agbno));
 
@@ -2872,7 +2872,7 @@ xfs_ialloc_setup_geometry(
 	 * cannot change the behavior.
 	 */
 	igeo->inode_cluster_size_raw = XFS_INODE_BIG_CLUSTER_SIZE;
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
 		int	new_size = igeo->inode_cluster_size_raw;
 
 		new_size *= mp->m_sb.sb_inodesize / XFS_DINODE_MIN_SIZE;
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 17e88a8c8353..c862c8f1aaa9 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -44,17 +44,6 @@ xfs_inobp_check(
 }
 #endif
 
-bool
-xfs_dinode_good_version(
-	struct xfs_mount *mp,
-	__u8		version)
-{
-	if (xfs_sb_version_hascrc(&mp->m_sb))
-		return version == 3;
-
-	return version == 1 || version == 2;
-}
-
 /*
  * If we are doing readahead on an inode buffer, we might be in log recovery
  * reading an inode allocation buffer that hasn't yet been replayed, and hence
@@ -93,7 +82,7 @@ xfs_inode_buf_verify(
 		dip = xfs_buf_offset(bp, (i << mp->m_sb.sb_inodelog));
 		unlinked_ino = be32_to_cpu(dip->di_next_unlinked);
 		di_ok = xfs_verify_magic16(bp, dip->di_magic) &&
-			xfs_dinode_good_version(mp, dip->di_version) &&
+			xfs_dinode_good_version(&mp->m_sb, dip->di_version) &&
 			xfs_verify_agino_or_null(mp, agno, unlinked_ino);
 		if (unlikely(XFS_TEST_ERROR(!di_ok, mp,
 						XFS_ERRTAG_ITOBP_INOTOBP))) {
@@ -454,7 +443,7 @@ xfs_dinode_verify(
 
 	/* Verify v3 integrity information first */
 	if (dip->di_version >= 3) {
-		if (!xfs_sb_version_hascrc(&mp->m_sb))
+		if (!xfs_sb_version_has_v3inode(&mp->m_sb))
 			return __this_address;
 		if (!xfs_verify_cksum((char *)dip, mp->m_sb.sb_inodesize,
 				      XFS_DINODE_CRC_OFF))
@@ -629,7 +618,7 @@ xfs_iread(
 
 	/* shortcut IO on inode allocation if possible */
 	if ((iget_flags & XFS_IGET_CREATE) &&
-	    xfs_sb_version_hascrc(&mp->m_sb) &&
+	    xfs_sb_version_has_v3inode(&mp->m_sb) &&
 	    !(mp->m_flags & XFS_MOUNT_IKEEP)) {
 		VFS_I(ip)->i_generation = prandom_u32();
 		ip->i_d.di_version = 3;
diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index 2683e1e2c4a6..66de5964045c 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -59,8 +59,6 @@ void	xfs_inode_from_disk(struct xfs_inode *ip, struct xfs_dinode *from);
 void	xfs_log_dinode_to_disk(struct xfs_log_dinode *from,
 			       struct xfs_dinode *to);
 
-bool	xfs_dinode_good_version(struct xfs_mount *mp, __u8 version);
-
 #if defined(DEBUG)
 void	xfs_inobp_check(struct xfs_mount *, struct xfs_buf *);
 #else
diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index 7a9c04920505..d1a0848cb52e 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -187,7 +187,7 @@ xfs_calc_inode_chunk_res(
 			       XFS_FSB_TO_B(mp, 1));
 	if (alloc) {
 		/* icreate tx uses ordered buffers */
-		if (xfs_sb_version_hascrc(&mp->m_sb))
+		if (xfs_sb_version_has_v3inode(&mp->m_sb))
 			return res;
 		size = XFS_FSB_TO_B(mp, 1);
 	}
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 663810e6cd59..1545657c3ca0 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -345,7 +345,7 @@ xfs_buf_item_format(
 	 * occurs during recovery.
 	 */
 	if (bip->bli_flags & XFS_BLI_INODE_BUF) {
-		if (xfs_sb_version_hascrc(&lip->li_mountp->m_sb) ||
+		if (xfs_sb_version_has_v3inode(&lip->li_mountp->m_sb) ||
 		    !((bip->bli_flags & XFS_BLI_INODE_ALLOC_BUF) &&
 		      xfs_log_item_in_current_chkpt(lip)))
 			bip->__bli_format.blf_flags |= XFS_BLF_INODE_BUF;
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 6abc0863c9c3..c467488212c2 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2997,7 +2997,7 @@ xlog_recover_inode_pass2(
 	 * superblock flag to determine whether we need to look at di_flushiter
 	 * to skip replay when the on disk inode is newer than the log one
 	 */
-	if (!xfs_sb_version_hascrc(&mp->m_sb) &&
+	if (!xfs_sb_version_has_v3inode(&mp->m_sb) &&
 	    ldip->di_flushiter < be16_to_cpu(dip->di_flushiter)) {
 		/*
 		 * Deal with the wrap case, DI_MAX_FLUSH is less
-- 
2.24.1

