Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C66D9C433FE
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Nov 2022 02:07:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbiKICHD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Nov 2022 21:07:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbiKICHC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Nov 2022 21:07:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A261682B9
        for <linux-xfs@vger.kernel.org>; Tue,  8 Nov 2022 18:07:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B9F90617EF
        for <linux-xfs@vger.kernel.org>; Wed,  9 Nov 2022 02:07:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2768DC433C1;
        Wed,  9 Nov 2022 02:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667959621;
        bh=7NuPoWIjVsv8VNqlenre8l/ESDvUXptBR783ikn3+4c=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=OaUUjrHbHEB045uxwKm4CxGwUt+wvd+O2NIYn3IOraSsHgBxG0rP+IS2hpNvw36rU
         dmGwVTLtkK8A7Lk98yLVshAfX1et4NifA77lccAEg3PAn497lRQLKAFi3BPXG7SLSl
         ltWFJK4awg4A7PMABcAM8wXXvD8znXn2RsenTz2p72pHTO+S8Hbrirbp1QJlNFD032
         WTuvcjDFaZsTs7a0R7dtI89HmEHlH27kQUjVkoVy1IXFWGT3QiK8HT7T1/crOgPJQy
         hIMqizjiswaYboGdpwc/Qhr18kv0+cR5zBxEcqH+txl+vzOyAomHzp2GZBOW/B1NhW
         zyJau9do7Rn3w==
Subject: [PATCH 14/24] xfs: move _irec structs to xfs_types.h
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Tue, 08 Nov 2022 18:07:00 -0800
Message-ID: <166795962070.3761583.2162344429822338243.stgit@magnolia>
In-Reply-To: <166795954256.3761583.3551179546135782562.stgit@magnolia>
References: <166795954256.3761583.3551179546135782562.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 61373167ce829d5805c07a86416cb9b4d5c4a3bb

Structure definitions for incore objects do not belong in the ondisk
format header.  Move them to the incore types header where they belong.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 libxfs/xfs_format.h |   20 --------------------
 libxfs/xfs_types.h  |   20 ++++++++++++++++++++
 2 files changed, 20 insertions(+), 20 deletions(-)


diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index b55bdfa9c8..005dd65b71 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
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
 
diff --git a/libxfs/xfs_types.h b/libxfs/xfs_types.h
index a6b7d98cf6..2d9ebc7338 100644
--- a/libxfs/xfs_types.h
+++ b/libxfs/xfs_types.h
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

