Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFC00C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:25:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345328AbiATAZ0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:25:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345332AbiATAZZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:25:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B916C061574
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jan 2022 16:25:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D8A261511
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:25:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97F32C004E1;
        Thu, 20 Jan 2022 00:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638324;
        bh=w+EM3aWinkG4dLkKI+DyTagUgoVS8LIuqj1PXNi9WsQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=mQJuOosiiU+1PPahKWdrx6swlA/Y/yeGrjO794qNBZKKhGkM1F968qX+QnZefaD27
         jVoJIDfBuEFfaIpbshCppX1kUZNFkgJ9bmnMHW+RiJrk5weyj0fkaONyhIZOVW3YUr
         BTPtvrPho1MEOSD/36SMG8yzSF8+DInRRwVvZnq+QMa0SQ7UH8IL2gB/9VIrqoDv9g
         UxgBhe8AA94ALRK4WVl+RahE2GOI7jE5Ze5p/CkPwRIe7fcyu95y/o8SujghiiwJFS
         20CzWQAgvgaX7j7G5HTkOrP1Elrd6jHiMwTiXslYlwMRSHHKjjb53/O+HhrN/jOux7
         Hc4unuMzTqG3A==
Subject: [PATCH 24/48] xfs_db: fix metadump level comparisons
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:25:24 -0800
Message-ID: <164263832432.865554.12949672536622727220.stgit@magnolia>
In-Reply-To: <164263819185.865554.6000499997543946756.stgit@magnolia>
References: <164263819185.865554.6000499997543946756.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

It's not an error if metadump encounters a btree with the maximal
height, so don't print warnings.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/metadump.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)


diff --git a/db/metadump.c b/db/metadump.c
index 057a3729..cc7a4a55 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -487,7 +487,7 @@ copy_free_bno_btree(
 					"root in agf %u", root, agno);
 		return 1;
 	}
-	if (levels >= XFS_BTREE_MAXLEVELS) {
+	if (levels > XFS_BTREE_MAXLEVELS) {
 		if (show_warnings)
 			print_warning("invalid level (%u) in bnobt root "
 					"in agf %u", levels, agno);
@@ -515,7 +515,7 @@ copy_free_cnt_btree(
 					"root in agf %u", root, agno);
 		return 1;
 	}
-	if (levels >= XFS_BTREE_MAXLEVELS) {
+	if (levels > XFS_BTREE_MAXLEVELS) {
 		if (show_warnings)
 			print_warning("invalid level (%u) in cntbt root "
 					"in agf %u", levels, agno);
@@ -587,7 +587,7 @@ copy_rmap_btree(
 					"root in agf %u", root, agno);
 		return 1;
 	}
-	if (levels >= XFS_BTREE_MAXLEVELS) {
+	if (levels > XFS_BTREE_MAXLEVELS) {
 		if (show_warnings)
 			print_warning("invalid level (%u) in rmapbt root "
 					"in agf %u", levels, agno);
@@ -659,7 +659,7 @@ copy_refcount_btree(
 					"root in agf %u", root, agno);
 		return 1;
 	}
-	if (levels >= XFS_BTREE_MAXLEVELS) {
+	if (levels > XFS_BTREE_MAXLEVELS) {
 		if (show_warnings)
 			print_warning("invalid level (%u) in refcntbt root "
 					"in agf %u", levels, agno);
@@ -2650,7 +2650,7 @@ copy_inodes(
 					"root in agi %u", root, agno);
 		return 1;
 	}
-	if (levels >= XFS_BTREE_MAXLEVELS) {
+	if (levels > XFS_BTREE_MAXLEVELS) {
 		if (show_warnings)
 			print_warning("invalid level (%u) in inobt root "
 					"in agi %u", levels, agno);

