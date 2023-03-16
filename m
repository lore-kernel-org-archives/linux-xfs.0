Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 965FDC6FD1F
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Mar 2023 19:21:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbjCPTVx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Mar 2023 15:21:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230236AbjCPTVu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2023 15:21:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86A83B8542
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 12:21:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B2D38620EA
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 19:21:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19ACEC433D2;
        Thu, 16 Mar 2023 19:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678994490;
        bh=fwUeCcHM7OWq2avE8NlWhTsGQ/a04yZKa6M2Ar/34H4=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=KsTXX4dPklOl9yWaP1COkBLJeqW/3kv+dc8MKbBPlS4S7Gm1sDnLK6Knl9XXGe9Uo
         8GZ53r97KqoqL6rohZqXT+yl+iaH90iI44VQKjr0u6isX+RMr+KHVZKmFq6RcqYoHa
         5AIzIvGZWRvlcV779kOr0b3pkM2MnZQtyTjFdRtPoHjrK4PcIC24yvsf9zBU2zejkl
         snfbPOPlhXq6SmWGLmXLO84wWYS+2Smwi9bos00eNXXhtCAvIapzg8DCAoo8Yv8+4S
         aS8ok1Q0vMf3caD+bbY99tL0Uaa31Lckw8c4j0qIAPTKLRRB7+h/z3Tr9RhWMTlOT4
         aqdsV5qTSxqUg==
Date:   Thu, 16 Mar 2023 12:21:29 -0700
Subject: [PATCH 7/7] xfs: rearrange bits of the parent pointer apis for fsck
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167899414026.15157.11164386088917104592.stgit@frogsfrogsfrogs>
In-Reply-To: <167899413920.15157.15106630627506949304.stgit@frogsfrogsfrogs>
References: <167899413920.15157.15106630627506949304.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Rearrange parts of this thing in preparation for fsck code.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_da_format.h |   11 +++++++++++
 fs/xfs/libxfs/xfs_parent.c    |   29 ++++++++++++++++++++++++++++-
 fs/xfs/libxfs/xfs_parent.h    |    6 ++----
 3 files changed, 41 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index 2db1cf97b2c8..c07b8166e8ff 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -159,6 +159,17 @@ struct xfs_da3_intnode {
 
 #define XFS_DIR3_FT_MAX			9
 
+#define XFS_DIR3_FTYPE_STR \
+	{ XFS_DIR3_FT_UNKNOWN,	"unknown" }, \
+	{ XFS_DIR3_FT_REG_FILE,	"file" }, \
+	{ XFS_DIR3_FT_DIR,	"directory" }, \
+	{ XFS_DIR3_FT_CHRDEV,	"char" }, \
+	{ XFS_DIR3_FT_BLKDEV,	"block" }, \
+	{ XFS_DIR3_FT_FIFO,	"fifo" }, \
+	{ XFS_DIR3_FT_SOCK,	"sock" }, \
+	{ XFS_DIR3_FT_SYMLINK,	"symlink" }, \
+	{ XFS_DIR3_FT_WHT,	"whiteout" }
+
 /*
  * Byte offset in data block and shortform entry.
  */
diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
index ec2bff195773..fe6d4d1a7d57 100644
--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -91,7 +91,7 @@ xfs_parent_valuecheck(
 }
 
 /* Initializes a xfs_parent_name_rec to be stored as an attribute name */
-void
+static inline void
 xfs_init_parent_name_rec(
 	struct xfs_parent_name_rec	*rec,
 	struct xfs_inode		*ip,
@@ -135,6 +135,33 @@ xfs_parent_irec_from_disk(
 	memset(&irec->p_name[valuelen], 0, sizeof(irec->p_name) - valuelen);
 }
 
+/*
+ * Convert an incore parent_name record to its ondisk format.  If @value or
+ * @valuelen are NULL, they will not be written to.
+ */
+void
+xfs_parent_irec_to_disk(
+	struct xfs_parent_name_rec	*rec,
+	void				*value,
+	int				*valuelen,
+	const struct xfs_parent_name_irec *irec)
+{
+	rec->p_ino = cpu_to_be64(irec->p_ino);
+	rec->p_gen = cpu_to_be32(irec->p_gen);
+	rec->p_diroffset = cpu_to_be32(irec->p_diroffset);
+
+	if (valuelen) {
+		ASSERT(*valuelen > 0);
+		ASSERT(*valuelen >= irec->p_namelen);
+		ASSERT(*valuelen < MAXNAMELEN);
+
+		*valuelen = irec->p_namelen;
+	}
+
+	if (value)
+		memcpy(value, irec->p_name, irec->p_namelen);
+}
+
 /*
  * Allocate memory to control a logged parent pointer update as part of a
  * dirent operation.
diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
index 35854e968f1d..4eb92fb4b11b 100644
--- a/fs/xfs/libxfs/xfs_parent.h
+++ b/fs/xfs/libxfs/xfs_parent.h
@@ -33,6 +33,8 @@ struct xfs_parent_name_irec {
 void xfs_parent_irec_from_disk(struct xfs_parent_name_irec *irec,
 		const struct xfs_parent_name_rec *rec,
 		const void *value, int valuelen);
+void xfs_parent_irec_to_disk(struct xfs_parent_name_rec *rec, void *value,
+		int *valuelen, const struct xfs_parent_name_irec *irec);
 
 /*
  * Dynamically allocd structure used to wrap the needed data to pass around
@@ -48,10 +50,6 @@ struct xfs_parent_defer {
 /*
  * Parent pointer attribute prototypes
  */
-void xfs_init_parent_name_rec(struct xfs_parent_name_rec *rec,
-		struct xfs_inode *ip, uint32_t p_diroffset);
-void xfs_init_parent_name_irec(struct xfs_parent_name_irec *irec,
-			       struct xfs_parent_name_rec *rec);
 int __xfs_parent_init(struct xfs_mount *mp, bool grab_log,
 		struct xfs_parent_defer **parentp);
 

