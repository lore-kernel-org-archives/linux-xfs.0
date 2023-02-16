Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E12ECC636CC
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:48:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbjBPUsw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:48:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbjBPUsw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:48:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77AD74BEA8
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:48:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1260360AB9
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:48:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E9F1C433EF;
        Thu, 16 Feb 2023 20:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676580530;
        bh=fwUeCcHM7OWq2avE8NlWhTsGQ/a04yZKa6M2Ar/34H4=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=BxUPFNEw2usiFfGsFIQQCTxaAwZHHNSYbe3/7Qb/M9uC1Sjjw9+yNakCWuJePYr0t
         tf88TB8aNGXcPNsflkzMXMPmPWeDPnc1wNBD1bLU55YCC8KyjtQyVL3kpJ2LQ5kfn9
         su8JOpKBO3a8JE+eKujB1x/5jVPZbR5Y+iWHFDz0FJoElZI/u+Fdwyqyck4pVMIF7E
         P5rDcWM8BWD5m0EXKQ3+2E7E5wFoABD103cdafx0+z47otj1htmyYrS74kj5faqi9p
         WKSKZqoc62Vrn0VtSppkrTjoT0prq4/yAclyAoN/iF3sRRPDMMQEcCZzwaR4ITVrkN
         19gnEUswZOKcw==
Date:   Thu, 16 Feb 2023 12:48:50 -0800
Subject: [PATCH 4/7] xfs: rearrange bits of the parent pointer apis for fsck
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657874525.3474898.4454796413862072546.stgit@magnolia>
In-Reply-To: <167657874461.3474898.12919390014293805981.stgit@magnolia>
References: <167657874461.3474898.12919390014293805981.stgit@magnolia>
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
 

