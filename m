Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA8D6C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:25:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345349AbiATAZj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:25:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345343AbiATAZi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:25:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45971C061574
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jan 2022 16:25:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 07687B81A7D
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:25:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2B8DC004E1;
        Thu, 20 Jan 2022 00:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638335;
        bh=2jJOdwaqK0GvwctrvBMiBH0v8JWs5VfA0lgarRhAnY4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=WBoC6FoH1oPXqEE6cR6Hup2H5WzLGs6dnhz6v9eG0/ka7WnCTQgWeughTVeA7PP8f
         /KEUv5a5uDRLV6+z3eiTw48uKz3QiJu/9oytqxb9VL/x3M0AU3cOStkAGItSATkvwD
         H4VQucPB64iJ43jqyR3mYeTksXv4uxlNyG3FtMrtADUgMzr4KjRm2oaYcH8Jl0iry/
         SHb5UGMEaeytVU1QhXVcjduEuIEMTKtM69g5/23rOn4CThxa6ZpYv6gaXzVGegCTMs
         lS3zUZ3g8jDCJs1I1SC0aaK7lF6oej2Fck42VzlKurBe89wIC7a3iS/8WoD1e91CnQ
         DUzRvnptef+Pg==
Subject: [PATCH 26/48] xfs_db: stop using XFS_BTREE_MAXLEVELS
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:25:35 -0800
Message-ID: <164263833535.865554.8546327352012728681.stgit@magnolia>
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

Use the precomputed per-btree-type max height values.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/metadump.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)


diff --git a/db/metadump.c b/db/metadump.c
index af8b67d5..2993f06e 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -487,7 +487,7 @@ copy_free_bno_btree(
 					"root in agf %u", root, agno);
 		return 1;
 	}
-	if (levels > XFS_BTREE_MAXLEVELS) {
+	if (levels > mp->m_alloc_maxlevels) {
 		if (show_warnings)
 			print_warning("invalid level (%u) in bnobt root "
 					"in agf %u", levels, agno);
@@ -515,7 +515,7 @@ copy_free_cnt_btree(
 					"root in agf %u", root, agno);
 		return 1;
 	}
-	if (levels > XFS_BTREE_MAXLEVELS) {
+	if (levels > mp->m_alloc_maxlevels) {
 		if (show_warnings)
 			print_warning("invalid level (%u) in cntbt root "
 					"in agf %u", levels, agno);
@@ -587,7 +587,7 @@ copy_rmap_btree(
 					"root in agf %u", root, agno);
 		return 1;
 	}
-	if (levels > XFS_BTREE_MAXLEVELS) {
+	if (levels > mp->m_rmap_maxlevels) {
 		if (show_warnings)
 			print_warning("invalid level (%u) in rmapbt root "
 					"in agf %u", levels, agno);
@@ -659,7 +659,7 @@ copy_refcount_btree(
 					"root in agf %u", root, agno);
 		return 1;
 	}
-	if (levels > XFS_BTREE_MAXLEVELS) {
+	if (levels > mp->m_refc_maxlevels) {
 		if (show_warnings)
 			print_warning("invalid level (%u) in refcntbt root "
 					"in agf %u", levels, agno);
@@ -2650,7 +2650,7 @@ copy_inodes(
 					"root in agi %u", root, agno);
 		return 1;
 	}
-	if (levels > XFS_BTREE_MAXLEVELS) {
+	if (levels > M_IGEO(mp)->inobt_maxlevels) {
 		if (show_warnings)
 			print_warning("invalid level (%u) in inobt root "
 					"in agi %u", levels, agno);
@@ -2672,7 +2672,7 @@ copy_inodes(
 			return 1;
 		}
 
-		if (levels > XFS_BTREE_MAXLEVELS) {
+		if (levels > M_IGEO(mp)->inobt_maxlevels) {
 			if (show_warnings)
 				print_warning("invalid level (%u) in finobt "
 						"root in agi %u", levels, agno);

