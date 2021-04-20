Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9999C433ED
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Apr 2021 16:26:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78E1861003
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Apr 2021 16:26:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233090AbhDTQ0k (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Apr 2021 12:26:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233127AbhDTQ0k (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Apr 2021 12:26:40 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E622BC06174A
        for <linux-xfs@vger.kernel.org>; Tue, 20 Apr 2021 09:26:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=qAHT1jz8zBB4Q/Om6uJZUllnbQLrN4+S5rFx/iTU2vE=; b=zlwsVZT8X4U9hrWlzMZxyYrXwN
        nrFCuvyxKFj5fH0ZHMbfHa5x/wT8rIsP6p9S5ruG8WLV+uLrI2Uifxxhe2MJOOZVrOWnU6IOsYFRS
        +7/KBmXa+OWfJayLFMLhS7/z/rUOrL8w8bUhUnDkHMaVtXXNLsdWfoDml8fG7Ys40VB2V8ISgCZrc
        BPWLRskbCoT1laW0o2UoDZcVPVPZEC01xAn+d3i4chXvxhYEBr9Re/hDd7yRlQh8mCXv3uR/coymT
        ZrYOT7qPclQE8KStG5TqVRnkZQemrTht/wmZO1zpT3gMi72FyBuHG+SaIcitRkha32StAo2oaVtkq
        UYuDAnFg==;
Received: from [2001:4bb8:19b:f845:7e4b:8a2:58e2:9b7b] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lYtCR-00CH0N-8o
        for linux-xfs@vger.kernel.org; Tue, 20 Apr 2021 16:26:07 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: rename xfs_ictimestamp_t
Date:   Tue, 20 Apr 2021 18:26:03 +0200
Message-Id: <20210420162603.4057289-1-hch@lst.de>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Rename xfs_ictimestamp_t to xfs_log_timestamp_t as it is a type used
for logging timestamps with no relationship to the in-core inode.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_log_format.h  | 10 +++++-----
 fs/xfs/xfs_inode_item.c         |  4 ++--
 fs/xfs/xfs_inode_item_recover.c |  2 +-
 fs/xfs/xfs_ondisk.h             |  2 +-
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 8bd00da6d2a40f..5900772d678a90 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -368,7 +368,7 @@ static inline int xfs_ilog_fdata(int w)
  * directly mirrors the xfs_dinode structure as it must contain all the same
  * information.
  */
-typedef uint64_t xfs_ictimestamp_t;
+typedef uint64_t xfs_log_timestamp_t;
 
 /* Legacy timestamp encoding format. */
 struct xfs_legacy_ictimestamp {
@@ -393,9 +393,9 @@ struct xfs_log_dinode {
 	uint16_t	di_projid_hi;	/* higher part of owner's project id */
 	uint8_t		di_pad[6];	/* unused, zeroed space */
 	uint16_t	di_flushiter;	/* incremented on flush */
-	xfs_ictimestamp_t di_atime;	/* time last accessed */
-	xfs_ictimestamp_t di_mtime;	/* time last modified */
-	xfs_ictimestamp_t di_ctime;	/* time created/inode modified */
+	xfs_log_timestamp_t di_atime;	/* time last accessed */
+	xfs_log_timestamp_t di_mtime;	/* time last modified */
+	xfs_log_timestamp_t di_ctime;	/* time created/inode modified */
 	xfs_fsize_t	di_size;	/* number of bytes in file */
 	xfs_rfsblock_t	di_nblocks;	/* # of direct & btree blocks used */
 	xfs_extlen_t	di_extsize;	/* basic/minimum extent size for file */
@@ -420,7 +420,7 @@ struct xfs_log_dinode {
 	uint8_t		di_pad2[12];	/* more padding for future expansion */
 
 	/* fields only written to during inode creation */
-	xfs_ictimestamp_t di_crtime;	/* time created */
+	xfs_log_timestamp_t di_crtime;	/* time created */
 	xfs_ino_t	di_ino;		/* inode number */
 	uuid_t		di_uuid;	/* UUID of the filesystem */
 
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index c1b32680f71c73..6cc4ca15209ce5 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -299,13 +299,13 @@ xfs_inode_item_format_attr_fork(
  * Convert an incore timestamp to a log timestamp.  Note that the log format
  * specifies host endian format!
  */
-static inline xfs_ictimestamp_t
+static inline xfs_log_timestamp_t
 xfs_inode_to_log_dinode_ts(
 	struct xfs_inode		*ip,
 	const struct timespec64		tv)
 {
 	struct xfs_legacy_ictimestamp	*lits;
-	xfs_ictimestamp_t		its;
+	xfs_log_timestamp_t		its;
 
 	if (xfs_inode_has_bigtime(ip))
 		return xfs_inode_encode_bigtime(tv);
diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
index cb44f7653f03bb..9b877de2ce5e3d 100644
--- a/fs/xfs/xfs_inode_item_recover.c
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -125,7 +125,7 @@ static inline bool xfs_log_dinode_has_bigtime(const struct xfs_log_dinode *ld)
 static inline xfs_timestamp_t
 xfs_log_dinode_to_disk_ts(
 	struct xfs_log_dinode		*from,
-	const xfs_ictimestamp_t		its)
+	const xfs_log_timestamp_t	its)
 {
 	struct xfs_legacy_timestamp	*lts;
 	struct xfs_legacy_ictimestamp	*lits;
diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index 0aa87c2101049c..66b541b7bb643d 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -126,7 +126,7 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(struct xfs_extent_64,		16);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_log_dinode,		176);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_icreate_log,		28);
-	XFS_CHECK_STRUCT_SIZE(xfs_ictimestamp_t,		8);
+	XFS_CHECK_STRUCT_SIZE(xfs_log_timestamp_t,		8);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_legacy_ictimestamp,	8);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_inode_log_format_32,	52);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_inode_log_format,	56);
-- 
2.30.1

