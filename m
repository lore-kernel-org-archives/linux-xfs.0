Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 611ECC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:25:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345336AbiATAZd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:25:33 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48252 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345332AbiATAZc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:25:32 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 87E84B81AD5
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:25:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28E80C004E1;
        Thu, 20 Jan 2022 00:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638330;
        bh=7YLxH49vkk7lKYRIqezWy8+taCqDrL0RUWpf1BguRzg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=IqoegnwbTG1VhJ3rXFZu44i6NOYYNr4iUgJ6IHgW1bbbaa6P+NKxFKEdNN+IKFZB9
         82BFo8Lj3NrSGIBgd1IzaMUJmy9xh/LPcUCuRPwPmDDs+XP6VCJhn0f9k2aQfjtk61
         fC1wlVyJGTltx2GneNIqWvD6lTg+B0VmcfJjrC/Q9HW1CEEgT3+dRU4b3huKVQk4ex
         F2JonTtk7IJWLa0DK66/7MlNOGsvB9uKahCveRykYgGVEOtLlytds+cgML7hWC6SUI
         xhO3Q+5sncJRqCYVWeC2BhsvjGh3EZO6lB0YdDyqcyb0uJt9jem64LtTdJx8FwBWEs
         mDTpDFEH2lJRA==
Subject: [PATCH 25/48] xfs_db: warn about suspicious finobt trees when
 metadumping
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:25:29 -0800
Message-ID: <164263832979.865554.11791034100178491501.stgit@magnolia>
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

We warn about suspicious roots and btree heights before metadumping the
inode btree, so do the same for the free inode btree.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/metadump.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)


diff --git a/db/metadump.c b/db/metadump.c
index cc7a4a55..af8b67d5 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -2664,6 +2664,21 @@ copy_inodes(
 		root = be32_to_cpu(agi->agi_free_root);
 		levels = be32_to_cpu(agi->agi_free_level);
 
+		if (root == 0 || root > mp->m_sb.sb_agblocks) {
+			if (show_warnings)
+				print_warning("invalid block number (%u) in "
+						"finobt root in agi %u", root,
+						agno);
+			return 1;
+		}
+
+		if (levels > XFS_BTREE_MAXLEVELS) {
+			if (show_warnings)
+				print_warning("invalid level (%u) in finobt "
+						"root in agi %u", levels, agno);
+			return 1;
+		}
+
 		finobt = 1;
 		if (!scan_btree(agno, root, levels, TYP_FINOBT, &finobt,
 				scanfunc_ino))

