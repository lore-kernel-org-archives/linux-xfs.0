Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36936C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:25:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345332AbiATAZz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:25:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344725AbiATAZz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:25:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7505C061574
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jan 2022 16:25:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8C475B81AD5
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:25:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30D69C004E1;
        Thu, 20 Jan 2022 00:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638352;
        bh=Tf/Dg444TfMG7lkqWBwqDT67pBgwYLDX5OyMsGKgazg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=KMF+e//1LhM3BDHQyGjdOulU/2Dcr2zd8Kks0ngwEWRJwCSKJc+add77jrQmUbYTi
         YQu1r1m15Xq3J2WsfAD12d31CRvEiVgWG2ZxPsLldXgh9xm2r8lOhZ6r25vE3FNwSA
         oM+ygdMTzlF0Ug2Sw2IOC2AkjlkeI4NSXECafpg3ZMs3FICeBpByDIswmfvjpSKd2u
         /OjQea/imzMwuS9qi39TRrS/gg9EfHctfHkqD4lmujjkfFskkTCIhnh6b/M+tNrr8R
         8kcIOXJ3okQ+NdCxYFg6Vx37VwBZ8+F8K85y+H64qY7xtO+QvwtpsK9UdOzPqx1UZJ
         K8nsKfcaaj5Zg==
Subject: [PATCH 29/48] xfs_repair: stop using XFS_BTREE_MAXLEVELS
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:25:51 -0800
Message-ID: <164263835190.865554.2981692152783837289.stgit@magnolia>
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
 repair/scan.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)


diff --git a/repair/scan.c b/repair/scan.c
index e7bf1fde..5a4b8dbd 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -2264,7 +2264,7 @@ validate_agf(
 	unsigned int		levels;
 
 	levels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]);
-	if (levels == 0 || levels > XFS_BTREE_MAXLEVELS) {
+	if (levels == 0 || levels > mp->m_alloc_maxlevels) {
 		do_warn(_("bad levels %u for btbno root, agno %d\n"),
 			levels, agno);
 	}
@@ -2282,7 +2282,7 @@ validate_agf(
 	}
 
 	levels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]);
-	if (levels == 0 || levels > XFS_BTREE_MAXLEVELS) {
+	if (levels == 0 || levels > mp->m_alloc_maxlevels) {
 		do_warn(_("bad levels %u for btbcnt root, agno %d\n"),
 			levels, agno);
 	}
@@ -2309,7 +2309,7 @@ validate_agf(
 		priv.nr_blocks = 0;
 
 		levels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]);
-		if (levels == 0 || levels > XFS_BTREE_MAXLEVELS) {
+		if (levels == 0 || levels > mp->m_rmap_maxlevels) {
 			do_warn(_("bad levels %u for rmapbt root, agno %d\n"),
 				levels, agno);
 			rmap_avoid_check();
@@ -2333,7 +2333,7 @@ validate_agf(
 
 	if (xfs_has_reflink(mp)) {
 		levels = be32_to_cpu(agf->agf_refcount_level);
-		if (levels == 0 || levels > XFS_BTREE_MAXLEVELS) {
+		if (levels == 0 || levels > mp->m_refc_maxlevels) {
 			do_warn(_("bad levels %u for refcountbt root, agno %d\n"),
 				levels, agno);
 			refcount_avoid_check();
@@ -2391,7 +2391,7 @@ validate_agi(
 	unsigned int		levels;
 
 	levels = be32_to_cpu(agi->agi_level);
-	if (levels == 0 || levels > XFS_BTREE_MAXLEVELS) {
+	if (levels == 0 || levels > M_IGEO(mp)->inobt_maxlevels) {
 		do_warn(_("bad levels %u for inobt root, agno %d\n"),
 			levels, agno);
 	}
@@ -2410,7 +2410,7 @@ validate_agi(
 
 	if (xfs_has_finobt(mp)) {
 		levels = be32_to_cpu(agi->agi_free_level);
-		if (levels == 0 || levels > XFS_BTREE_MAXLEVELS) {
+		if (levels == 0 || levels > M_IGEO(mp)->inobt_maxlevels) {
 			do_warn(_("bad levels %u for finobt root, agno %d\n"),
 				levels, agno);
 		}

