Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D54BC38A02
	for <linux-xfs@archiver.kernel.org>; Sun, 30 Oct 2022 23:41:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbiJ3Xlr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 30 Oct 2022 19:41:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiJ3Xlq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 30 Oct 2022 19:41:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3B009FED
        for <linux-xfs@vger.kernel.org>; Sun, 30 Oct 2022 16:41:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D31060F95
        for <linux-xfs@vger.kernel.org>; Sun, 30 Oct 2022 23:41:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED1B8C433D6;
        Sun, 30 Oct 2022 23:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667173305;
        bh=nEto/0E9M6JLPqtnSZpmEQ2iUESkuq1VIamceIKiJIk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=kEGTW+FdyMyYk7ky8l6y9uxqaHKkyypGwYAqP8KeUNCW80C16940ItNDTPdKBZj9f
         mqj1sy+a5uhrRekaAXAPAykebO5XzpozcbEAVWQJ/jDiKCRWTLsp0tews8QwsuDzw0
         wLZGoT6OfvLlEjUav7WbbT59xzeqBKR209vvjiBkoch9a2SQnIAMWkPXmAuVqoEjH+
         xyAIuYBoLTWZ0Do5CMfC+abf+/KnkqTgKleuR7N6ojKQruTfe+hzs8ls1aDBrAoDFO
         i70PpV3Xmf8XTj0HJpuf8jMejFkRYeTAVFgbLJrmAIe8lcV+P9enzn8sLPV3j6Qqa/
         ojbHmJlul9icg==
Subject: [PATCH 04/13] xfs: move _irec structs to xfs_types.h
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Sun, 30 Oct 2022 16:41:44 -0700
Message-ID: <166717330443.417886.14607651387648064655.stgit@magnolia>
In-Reply-To: <166717328145.417886.10627661186183843873.stgit@magnolia>
References: <166717328145.417886.10627661186183843873.stgit@magnolia>
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
Reviewed-by: Dave Chinner <dchinner@redhat.com>
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

