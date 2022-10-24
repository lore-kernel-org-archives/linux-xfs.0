Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2D3EC67871
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Oct 2022 23:13:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231174AbiJXXNk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Oct 2022 19:13:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231234AbiJXXNT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Oct 2022 19:13:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13614170DFC
        for <linux-xfs@vger.kernel.org>; Mon, 24 Oct 2022 14:34:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81488B81203
        for <linux-xfs@vger.kernel.org>; Mon, 24 Oct 2022 21:33:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27993C433C1;
        Mon, 24 Oct 2022 21:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666647195;
        bh=JpwbvIxg0oiifyhPqjLnf8xo3PUMnYzUmCNpbN9uYV4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=nwsKosWeZkPxx8eZ0N5qi3qkPPn+5lnXr3vwRUgPS3dPQpm3chRJYDba7uI9OuxHF
         acrqgA1wbF7tAkXDA8Ty+WJNCXam4Sy3uUfd00UJmU37AwJHOOQ9ZelRCRHXWKZd/V
         esUn1Zd3ChbadP/qrOiXYNWHlS8yuLBoEW82bihX04p//lFeDChB6GsBeugqXscc0V
         Pu+Wd9DyF2qxraBlaqbSpUzcVJpvyLD+rWepYIcosrB6mp2JgedoCHAZLsAKZwpNTn
         e1Jkd9bVbYtUgbcB5NH07fTSZUQ5r/kmPD9NycsvKA8s4UrcQqVeNv3rnPZYRa/qD0
         hKe2pW8baVDig==
Subject: [PATCH 1/5] xfs: move _irec structs to xfs_types.h
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 24 Oct 2022 14:33:14 -0700
Message-ID: <166664719469.2690245.17398561365687268746.stgit@magnolia>
In-Reply-To: <166664718897.2690245.5721183007309479393.stgit@magnolia>
References: <166664718897.2690245.5721183007309479393.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Structure definitions for incore objects do not belong in the ondisk
format header.  Move them to the incore types header where they belong.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_format.h |   20 --------------------
 fs/xfs/libxfs/xfs_types.h  |   20 ++++++++++++++++++++
 2 files changed, 20 insertions(+), 20 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index b55bdfa9c8a8..005dd65b71cd 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1564,20 +1564,6 @@ struct xfs_rmap_rec {
 #define RMAPBT_UNUSED_OFFSET_BITLEN	7
 #define RMAPBT_OFFSET_BITLEN		54
 
-#define XFS_RMAP_ATTR_FORK		(1 << 0)
-#define XFS_RMAP_BMBT_BLOCK		(1 << 1)
-#define XFS_RMAP_UNWRITTEN		(1 << 2)
-#define XFS_RMAP_KEY_FLAGS		(XFS_RMAP_ATTR_FORK | \
-					 XFS_RMAP_BMBT_BLOCK)
-#define XFS_RMAP_REC_FLAGS		(XFS_RMAP_UNWRITTEN)
-struct xfs_rmap_irec {
-	xfs_agblock_t	rm_startblock;	/* extent start block */
-	xfs_extlen_t	rm_blockcount;	/* extent length */
-	uint64_t	rm_owner;	/* extent owner */
-	uint64_t	rm_offset;	/* offset within the owner */
-	unsigned int	rm_flags;	/* state flags */
-};
-
 /*
  * Key structure
  *
@@ -1640,12 +1626,6 @@ struct xfs_refcount_key {
 	__be32		rc_startblock;	/* starting block number */
 };
 
-struct xfs_refcount_irec {
-	xfs_agblock_t	rc_startblock;	/* starting block number */
-	xfs_extlen_t	rc_blockcount;	/* count of free blocks */
-	xfs_nlink_t	rc_refcount;	/* number of inodes linked here */
-};
-
 #define MAXREFCOUNT	((xfs_nlink_t)~0U)
 #define MAXREFCEXTLEN	((xfs_extlen_t)~0U)
 
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index a6b7d98cf68f..2d9ebc7338b1 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -166,6 +166,26 @@ typedef struct xfs_bmbt_irec
 	xfs_exntst_t	br_state;	/* extent state */
 } xfs_bmbt_irec_t;
 
+struct xfs_refcount_irec {
+	xfs_agblock_t	rc_startblock;	/* starting block number */
+	xfs_extlen_t	rc_blockcount;	/* count of free blocks */
+	xfs_nlink_t	rc_refcount;	/* number of inodes linked here */
+};
+
+#define XFS_RMAP_ATTR_FORK		(1 << 0)
+#define XFS_RMAP_BMBT_BLOCK		(1 << 1)
+#define XFS_RMAP_UNWRITTEN		(1 << 2)
+#define XFS_RMAP_KEY_FLAGS		(XFS_RMAP_ATTR_FORK | \
+					 XFS_RMAP_BMBT_BLOCK)
+#define XFS_RMAP_REC_FLAGS		(XFS_RMAP_UNWRITTEN)
+struct xfs_rmap_irec {
+	xfs_agblock_t	rm_startblock;	/* extent start block */
+	xfs_extlen_t	rm_blockcount;	/* extent length */
+	uint64_t	rm_owner;	/* extent owner */
+	uint64_t	rm_offset;	/* offset within the owner */
+	unsigned int	rm_flags;	/* state flags */
+};
+
 /* per-AG block reservation types */
 enum xfs_ag_resv_type {
 	XFS_AG_RESV_NONE = 0,

