Return-Path: <SRS0=K4IM=45=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63DF9C4CECE
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 14:22:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3CFD320650
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 14:22:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="aS8WZrBN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727530AbgCLOWk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Mar 2020 10:22:40 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:45258 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727320AbgCLOWk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Mar 2020 10:22:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=6s3VLCncrFdIgzESVbxqtfoiNNeUrFKVTT2bjLN/fpo=; b=aS8WZrBNpVeEI3Z1cmKnXqNrSM
        1o2oxhSn0V0A1ZrXBUXnYDNDWsYt4Ym1cVshCJxulXYuuIIvgC2gBZWEFlXaWF6KodctZE34CnRa/
        arKid7FUhT806rNSPzYhQEoXMeIseoyAx9YeU/Sc/lMWJyHnlCQe2oSBWcYG6VYezB0FwuC5mEdY7
        HKXTYpYXGQMe9O7t+yE8E3s8neZY59qg7c0/OKXO41oH13QYZkddm56h2v5ec6LQIaiLGjaoEepiM
        IAmO7+2VHdKSUIhUgWXL5KFplBv+sAlShSr5dR906zy1ZPMWTz/Mycwjbd1MTDnoY1AqoBH118Up2
        n/j0N67Q==;
Received: from [2001:4bb8:184:5cad:8026:d98c:a056:3e33] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jCOjP-0003hv-PS
        for linux-xfs@vger.kernel.org; Thu, 12 Mar 2020 14:22:40 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/5] xfs: add a new xfs_sb_version_has_large_dinode helper
Date:   Thu, 12 Mar 2020 15:22:31 +0100
Message-Id: <20200312142235.550766-2-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200312142235.550766-1-hch@lst.de>
References: <20200312142235.550766-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Add a new wrapper to check if a file system supports the newer large
dinode format.  Previously we uses xfs_sb_version_hascrc for that,
which is technically correct but a little confusing to read.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_format.h     |  5 +++++
 fs/xfs/libxfs/xfs_ialloc.c     |  4 ++--
 fs/xfs/libxfs/xfs_inode_buf.c  | 12 ++++++++----
 fs/xfs/libxfs/xfs_trans_resv.c |  2 +-
 fs/xfs/xfs_buf_item.c          |  2 +-
 fs/xfs/xfs_log_recover.c       |  2 +-
 6 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index cd814f99da28..a28bf6a978ad 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -497,6 +497,11 @@ static inline bool xfs_sb_version_hascrc(struct xfs_sb *sbp)
 	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5;
 }
 
+static inline bool xfs_sb_version_has_large_dinode(struct xfs_sb *sbp)
+{
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5;
+}
+
 static inline bool xfs_sb_version_has_pquotino(struct xfs_sb *sbp)
 {
 	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5;
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index b4a404278935..6adffaa68fb8 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -304,7 +304,7 @@ xfs_ialloc_inode_init(
 	 * That means for v3 inode we log the entire buffer rather than just the
 	 * inode cores.
 	 */
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_sb_version_has_large_dinode(&mp->m_sb)) {
 		version = 3;
 		ino = XFS_AGINO_TO_INO(mp, agno, XFS_AGB_TO_AGINO(mp, agbno));
 
@@ -2872,7 +2872,7 @@ xfs_ialloc_setup_geometry(
 	 * cannot change the behavior.
 	 */
 	igeo->inode_cluster_size_raw = XFS_INODE_BIG_CLUSTER_SIZE;
-	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+	if (xfs_sb_version_has_large_dinode(&mp->m_sb)) {
 		int	new_size = igeo->inode_cluster_size_raw;
 
 		new_size *= mp->m_sb.sb_inodesize / XFS_DINODE_MIN_SIZE;
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 17e88a8c8353..a5aa2f220c28 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -44,14 +44,18 @@ xfs_inobp_check(
 }
 #endif
 
+/*
+ * v4 and earlier file systems only support the small dinode, and must use the
+ * v1 or v2 inode formats.  v5 file systems support a larger dinode, and must
+ * use the v3 inode format.
+ */
 bool
 xfs_dinode_good_version(
 	struct xfs_mount *mp,
 	__u8		version)
 {
-	if (xfs_sb_version_hascrc(&mp->m_sb))
+	if (xfs_sb_version_has_large_dinode(&mp->m_sb))
 		return version == 3;
-
 	return version == 1 || version == 2;
 }
 
@@ -454,7 +458,7 @@ xfs_dinode_verify(
 
 	/* Verify v3 integrity information first */
 	if (dip->di_version >= 3) {
-		if (!xfs_sb_version_hascrc(&mp->m_sb))
+		if (!xfs_sb_version_has_large_dinode(&mp->m_sb))
 			return __this_address;
 		if (!xfs_verify_cksum((char *)dip, mp->m_sb.sb_inodesize,
 				      XFS_DINODE_CRC_OFF))
@@ -629,7 +633,7 @@ xfs_iread(
 
 	/* shortcut IO on inode allocation if possible */
 	if ((iget_flags & XFS_IGET_CREATE) &&
-	    xfs_sb_version_hascrc(&mp->m_sb) &&
+	    xfs_sb_version_has_large_dinode(&mp->m_sb) &&
 	    !(mp->m_flags & XFS_MOUNT_IKEEP)) {
 		VFS_I(ip)->i_generation = prandom_u32();
 		ip->i_d.di_version = 3;
diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index 7a9c04920505..294e23d47912 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -187,7 +187,7 @@ xfs_calc_inode_chunk_res(
 			       XFS_FSB_TO_B(mp, 1));
 	if (alloc) {
 		/* icreate tx uses ordered buffers */
-		if (xfs_sb_version_hascrc(&mp->m_sb))
+		if (xfs_sb_version_has_large_dinode(&mp->m_sb))
 			return res;
 		size = XFS_FSB_TO_B(mp, 1);
 	}
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 663810e6cd59..d004ae3455d7 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -345,7 +345,7 @@ xfs_buf_item_format(
 	 * occurs during recovery.
 	 */
 	if (bip->bli_flags & XFS_BLI_INODE_BUF) {
-		if (xfs_sb_version_hascrc(&lip->li_mountp->m_sb) ||
+		if (xfs_sb_version_has_large_dinode(&lip->li_mountp->m_sb) ||
 		    !((bip->bli_flags & XFS_BLI_INODE_ALLOC_BUF) &&
 		      xfs_log_item_in_current_chkpt(lip)))
 			bip->__bli_format.blf_flags |= XFS_BLF_INODE_BUF;
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 6abc0863c9c3..e5e976b5cc11 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2997,7 +2997,7 @@ xlog_recover_inode_pass2(
 	 * superblock flag to determine whether we need to look at di_flushiter
 	 * to skip replay when the on disk inode is newer than the log one
 	 */
-	if (!xfs_sb_version_hascrc(&mp->m_sb) &&
+	if (!xfs_sb_version_has_large_dinode(&mp->m_sb) &&
 	    ldip->di_flushiter < be16_to_cpu(dip->di_flushiter)) {
 		/*
 		 * Deal with the wrap case, DI_MAX_FLUSH is less
-- 
2.24.1

