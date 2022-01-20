Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 038DDC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:25:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345343AbiATAZm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:25:42 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:33124 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345332AbiATAZm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:25:42 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D70A96150C
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:25:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B0DAC004E1;
        Thu, 20 Jan 2022 00:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638341;
        bh=XNYa3h3hs71SbYye+mKMfw7fVo1iNU559wHNDtwt0fM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=AbqkFpnfbw+nWRgl6vDKWoBlJT5V9t+YRN++wIYJHONG5KPm4Oiyzrfo92ks8C9mf
         oMM/ayw0Zzvwufo2koeM1Ooe3uJPXpX5doKmApKxQ53haHWW8DjB0N1kra1ur+WIor
         dPMNwVS/Fu+tinbokv2OEDvLTk9YEnUJ5pe0KleEMECw3jbkJJxg1DFQZzA/e3Vk5y
         3T/JikabX1mqn8wBiSeml7XSjLhNMlQ8OPWrd9xZSO+uh8MYGoJD/0ZmRw18HYS7aJ
         D1K2gxnXYehyrIlW+cZi7WziwZKFdRR2bXDfyHwhZ+qnYnPr9apME9DtVC0cIaxpSD
         M7lR2yE24kGnQ==
Subject: [PATCH 27/48] xfs_repair: fix AG header btree level comparisons
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:25:41 -0800
Message-ID: <164263834099.865554.12607282164360768854.stgit@magnolia>
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

It's not an error if repair encounters a btree with the maximal
height, so don't print warnings.  Also, we don't allow zero-height
btrees.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/scan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/repair/scan.c b/repair/scan.c
index 909c4494..e2d281a2 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -2297,7 +2297,7 @@ validate_agf(
 		priv.nr_blocks = 0;
 
 		levels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]);
-		if (levels >= XFS_BTREE_MAXLEVELS) {
+		if (levels == 0 || levels > XFS_BTREE_MAXLEVELS) {
 			do_warn(_("bad levels %u for rmapbt root, agno %d\n"),
 				levels, agno);
 			rmap_avoid_check();
@@ -2323,7 +2323,7 @@ validate_agf(
 		unsigned int	levels;
 
 		levels = be32_to_cpu(agf->agf_refcount_level);
-		if (levels >= XFS_BTREE_MAXLEVELS) {
+		if (levels == 0 || levels > XFS_BTREE_MAXLEVELS) {
 			do_warn(_("bad levels %u for refcountbt root, agno %d\n"),
 				levels, agno);
 			refcount_avoid_check();

