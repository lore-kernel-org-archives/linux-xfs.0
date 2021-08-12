Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 157FFC4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 08:46:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E25596103A
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 08:46:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235359AbhHLIqj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Aug 2021 04:46:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbhHLIqj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Aug 2021 04:46:39 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA26CC0613D5
        for <linux-xfs@vger.kernel.org>; Thu, 12 Aug 2021 01:46:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:
        Content-Type:Content-ID:Content-Description;
        bh=67VqQMgYOvqf/kbt3XSEuWISADUWRmBnSnI2KUSyszU=; b=Kcc9e0ZA6la+vv6mwtdI7Ce1Hd
        JN9Umfhq0RWTkHvuXNVsGZslnGBsDJ9sSpL18giJqE2liASqoyGHBsZwtxED+lifHT10pMgxy01TD
        6iaNAszzVqMdWhAJtGeAFSD4CKVeX5yen6CA9rpNFmL2c0WuuvC+ZgVKMxKFDP+2kOui/GZqIB+tv
        Fod7awF/7givU3o3TCuj2gN7pTv4fTEoVJnWESaTmCnxXJMBnnNO5xgDx/YvAXndY5zQ5BuxKV+o6
        0bofoskRoyhibeYCSFerXfdgySyphIzRnAysWpPHFKS0j7C8e2WT/yaSUSy+LBlQm3o8fU7nXYAzI
        feAnKhQw==;
Received: from [2001:4bb8:184:6215:d7d:1904:40de:694d] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mE6KK-00EM5f-BM
        for linux-xfs@vger.kernel.org; Thu, 12 Aug 2021 08:44:55 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/3] xfs: remove the xfs_dinode_t typedef
Date:   Thu, 12 Aug 2021 10:43:41 +0200
Message-Id: <20210812084343.27934-2-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210812084343.27934-1-hch@lst.de>
References: <20210812084343.27934-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Remove the few leftover instances of the xfs_dinode_t typedef.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_format.h     |  4 ++--
 fs/xfs/libxfs/xfs_inode_buf.c  |  6 +++---
 fs/xfs/libxfs/xfs_inode_fork.c | 16 ++++++++--------
 fs/xfs/xfs_buf_item_recover.c  |  2 +-
 4 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 5d8a129150d547..f601049b65f465 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -977,7 +977,7 @@ static inline time64_t xfs_bigtime_to_unix(uint64_t ondisk_seconds)
  * padding field for v3 inodes.
  */
 #define	XFS_DINODE_MAGIC		0x494e	/* 'IN' */
-typedef struct xfs_dinode {
+struct xfs_dinode {
 	__be16		di_magic;	/* inode magic # = XFS_DINODE_MAGIC */
 	__be16		di_mode;	/* mode and type of file */
 	__u8		di_version;	/* inode version */
@@ -1022,7 +1022,7 @@ typedef struct xfs_dinode {
 	uuid_t		di_uuid;	/* UUID of the filesystem */
 
 	/* structure must be padded to 64 bit alignment */
-} xfs_dinode_t;
+};
 
 #define XFS_DINODE_CRC_OFF	offsetof(struct xfs_dinode, di_crc)
 
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 84ea2e0af9f026..891940cc16f905 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -51,9 +51,9 @@ xfs_inode_buf_verify(
 	agno = xfs_daddr_to_agno(mp, XFS_BUF_ADDR(bp));
 	ni = XFS_BB_TO_FSB(mp, bp->b_length) * mp->m_sb.sb_inopblock;
 	for (i = 0; i < ni; i++) {
-		int		di_ok;
-		xfs_dinode_t	*dip;
-		xfs_agino_t	unlinked_ino;
+		struct xfs_dinode	*dip;
+		xfs_agino_t		unlinked_ino;
+		int			di_ok;
 
 		dip = xfs_buf_offset(bp, (i << mp->m_sb.sb_inodelog));
 		unlinked_ino = be32_to_cpu(dip->di_next_unlinked);
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 1d174909f9bdf5..08a390a259491c 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -67,10 +67,10 @@ xfs_init_local_fork(
  */
 STATIC int
 xfs_iformat_local(
-	xfs_inode_t	*ip,
-	xfs_dinode_t	*dip,
-	int		whichfork,
-	int		size)
+	struct xfs_inode	*ip,
+	struct xfs_dinode	*dip,
+	int			whichfork,
+	int			size)
 {
 	/*
 	 * If the size is unreasonable, then something
@@ -162,8 +162,8 @@ xfs_iformat_extents(
  */
 STATIC int
 xfs_iformat_btree(
-	xfs_inode_t		*ip,
-	xfs_dinode_t		*dip,
+	struct xfs_inode	*ip,
+	struct xfs_dinode	*dip,
 	int			whichfork)
 {
 	struct xfs_mount	*mp = ip->i_mount;
@@ -580,8 +580,8 @@ xfs_iextents_copy(
  */
 void
 xfs_iflush_fork(
-	xfs_inode_t		*ip,
-	xfs_dinode_t		*dip,
+	struct xfs_inode	*ip,
+	struct xfs_dinode	*dip,
 	struct xfs_inode_log_item *iip,
 	int			whichfork)
 {
diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index 4775485b406233..55ee89a88f5549 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -603,7 +603,7 @@ xlog_recover_do_inode_buffer(
 	inodes_per_buf = BBTOB(bp->b_length) >> mp->m_sb.sb_inodelog;
 	for (i = 0; i < inodes_per_buf; i++) {
 		next_unlinked_offset = (i * mp->m_sb.sb_inodesize) +
-			offsetof(xfs_dinode_t, di_next_unlinked);
+			offsetof(struct xfs_dinode, di_next_unlinked);
 
 		while (next_unlinked_offset >=
 		       (reg_buf_offset + reg_buf_bytes)) {
-- 
2.30.2

