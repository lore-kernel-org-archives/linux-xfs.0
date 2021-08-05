Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72BD8C4338F
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Aug 2021 07:00:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 506AF60F41
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Aug 2021 07:00:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238143AbhHEHBL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Aug 2021 03:01:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:42926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237246AbhHEHBC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 5 Aug 2021 03:01:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B15860EC0;
        Thu,  5 Aug 2021 07:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628146849;
        bh=H4bXqXpa7l48YxP1p6y0PqSCJbVd7i2xCjY7qEXI5eQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=YoGB8rbh2K0KxIlPIq6Qde0FxAOrsRk0WqycXCxBNzQOWatNcCe+98Sx32oxve0We
         oXmVLdtNCDFU1mOhmBqxG5I2B8CxMEHZFfK5P0y/mhqBVs4g6YyhhUxvXx3MUmxx7C
         sji5VbbGqbSccmFnyLDUrSkJmY2fix2ueN4+FcDAQb5d2tdmGtGvuOJthfoCX5gzKW
         HoUDMc0QMTLIVayizgWPqFlSub42ZA/4yUH29Xz2VaoTnfS3eJ4omjrYx3dNXmpIFO
         anxtPLD3bX+wls1D9P9ukxHMYNTdnYRb8rENsTKiME/P0gfbpqUS/4Sbg4xHBPawfJ
         fpXE/5kGZDn/g==
Subject: [PATCH 1/5] xfs: fix silly whitespace problems with kernel libxfs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 05 Aug 2021 00:00:48 -0700
Message-ID: <162814684894.2777088.8991564362005574305.stgit@magnolia>
In-Reply-To: <162814684332.2777088.14593133806068529811.stgit@magnolia>
References: <162814684332.2777088.14593133806068529811.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Fix a few whitespace errors such as spaces at the end of the line, etc.
This gets us back to something more closely resembling parity.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr_leaf.c  |    2 +-
 fs/xfs/libxfs/xfs_format.h     |    2 +-
 fs/xfs/libxfs/xfs_ialloc.c     |    2 +-
 fs/xfs/libxfs/xfs_rmap_btree.h |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index b910bd209949..b277e0511cdd 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -576,7 +576,7 @@ xfs_attr_shortform_bytesfit(
 	switch (dp->i_df.if_format) {
 	case XFS_DINODE_FMT_EXTENTS:
 		/*
-		 * If there is no attr fork and the data fork is extents, 
+		 * If there is no attr fork and the data fork is extents,
 		 * determine if creating the default attr fork will result
 		 * in the extents form migrating to btree. If so, the
 		 * minimum offset only needs to be the space required for
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 76e2461b9e66..37570cf0537e 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -9,7 +9,7 @@
 /*
  * XFS On Disk Format Definitions
  *
- * This header file defines all the on-disk format definitions for 
+ * This header file defines all the on-disk format definitions for
  * general XFS objects. Directory and attribute related objects are defined in
  * xfs_da_format.h, which log and log item formats are defined in
  * xfs_log_format.h. Everything else goes here.
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index aaf8805a82df..19eb7ec0103f 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1994,7 +1994,7 @@ xfs_difree_inobt(
 			goto error0;
 		}
 
-		/* 
+		/*
 		 * Change the inode free counts and log the ag/sb changes.
 		 */
 		be32_add_cpu(&agi->agi_freecount, 1);
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.h b/fs/xfs/libxfs/xfs_rmap_btree.h
index 88d8d18788a2..f2eee6572af4 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.h
+++ b/fs/xfs/libxfs/xfs_rmap_btree.h
@@ -59,4 +59,4 @@ extern xfs_extlen_t xfs_rmapbt_max_size(struct xfs_mount *mp,
 extern int xfs_rmapbt_calc_reserves(struct xfs_mount *mp, struct xfs_trans *tp,
 		struct xfs_perag *pag, xfs_extlen_t *ask, xfs_extlen_t *used);
 
-#endif	/* __XFS_RMAP_BTREE_H__ */
+#endif /* __XFS_RMAP_BTREE_H__ */

