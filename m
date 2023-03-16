Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58CA6C6FD19
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Mar 2023 19:31:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbjCPTb6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Mar 2023 15:31:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbjCPTb5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2023 15:31:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DA655D77C
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 12:31:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1BD80B822F3
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 19:31:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF999C433D2;
        Thu, 16 Mar 2023 19:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678995113;
        bh=EPux0H1REB36M/tkp0XI6ko8kbosp0RaCYl2daBd53M=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=Gqs7EJKTwH1CZfOAotfzVEsRfbdmZgWbWJaiAAU483mcENUDFFEnubUj/bGaAGxNZ
         6Oc+9x0dFHDzmlULMX+qb8C/rPf5e0fG13yMZdZo0iPP3o/UozEevSHY5gaeExq/OL
         Acy63xLd99SLq2tyPuj/NTV/lmgrvQTkLNf9H7v0EwCvhMWUrkHYWsmxbyvVVnkClU
         YdhrbCNEp0j5K1dw8BZKT06LN+GRZ9zUWLjBJJPTpfj/03pQAo4Tw0enJv3enI4UPF
         EFBC28HEjyCr++NtZgHzHK2npqsXmLaNH1tPPJn7sw7Vq02GFwFBEPF4LkR1jdnH4c
         8NUBO7Qu95LTA==
Date:   Thu, 16 Mar 2023 12:31:53 -0700
Subject: [PATCH 5/5] xfs: rearrange bits of the parent pointer apis for fsck
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167899416523.16836.4773727965068932987.stgit@frogsfrogsfrogs>
In-Reply-To: <167899416457.16836.2981078472584318439.stgit@frogsfrogsfrogs>
References: <167899416457.16836.2981078472584318439.stgit@frogsfrogsfrogs>
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
 libxfs/libxfs_api_defs.h |    1 -
 libxfs/xfs_da_format.h   |   11 +++++++++++
 libxfs/xfs_parent.c      |   29 ++++++++++++++++++++++++++++-
 libxfs/xfs_parent.h      |    6 ++----
 4 files changed, 41 insertions(+), 6 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 132e2aca0..60d3339a7 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -124,7 +124,6 @@
 #define xfs_initialize_perag		libxfs_initialize_perag
 #define xfs_initialize_perag_data	libxfs_initialize_perag_data
 #define xfs_init_local_fork		libxfs_init_local_fork
-#define xfs_init_parent_name_rec	libxfs_init_parent_name_rec
 
 #define xfs_inobt_maxrecs		libxfs_inobt_maxrecs
 #define xfs_inobt_stage_cursor		libxfs_inobt_stage_cursor
diff --git a/libxfs/xfs_da_format.h b/libxfs/xfs_da_format.h
index 2db1cf97b..c07b8166e 100644
--- a/libxfs/xfs_da_format.h
+++ b/libxfs/xfs_da_format.h
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
diff --git a/libxfs/xfs_parent.c b/libxfs/xfs_parent.c
index 89eb531ff..980f0b829 100644
--- a/libxfs/xfs_parent.c
+++ b/libxfs/xfs_parent.c
@@ -92,7 +92,7 @@ xfs_parent_valuecheck(
 }
 
 /* Initializes a xfs_parent_name_rec to be stored as an attribute name */
-void
+static inline void
 xfs_init_parent_name_rec(
 	struct xfs_parent_name_rec	*rec,
 	struct xfs_inode		*ip,
@@ -136,6 +136,33 @@ xfs_parent_irec_from_disk(
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
diff --git a/libxfs/xfs_parent.h b/libxfs/xfs_parent.h
index 35854e968..4eb92fb4b 100644
--- a/libxfs/xfs_parent.h
+++ b/libxfs/xfs_parent.h
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
 

