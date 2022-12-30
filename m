Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9898BC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:05:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbiLaDFq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:05:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236267AbiLaDFj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:05:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA3A815F27
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 19:05:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1ACACB81EA2
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 03:05:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C624BC433EF;
        Sat, 31 Dec 2022 03:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672455934;
        bh=sjSBYA/knL1WWk0Oudvpjp0psOsDs7f+DmVXuSiNjI0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=tSGut9Nfa0kWh7FITamIxy1nHEAsqA/F1VY68h3ah6eco34QZhY8Aw1I0O/i+y+iF
         h2EKjk3kC6juQiJAdA5KyjZS+tfGKRpqADqWEjTLnk13oEgqmckZhfFzgZ1v+3BQEi
         kau5mgRWtMX5kabuQmdrYT9s+fywyLS1fqG+1GMTsDDhST9Cdt+YxgjVbq2VNvmqVv
         lh1rxUBWmZzBPJfupvcyLysZ35g8nIcVcWaKV8HQfCU4RUK177oegjNJiJmRZgWsHn
         qkAtJnKQOgQGozCb4MpEsU/lAxl/6n1ah6E2HORSuBO5fSTIy0mNOIhyFiNZdu7sqe
         JcM/NutQRKYvg==
Subject: [PATCH 3/3] mkfs: enable reflink with realtime extent sizes > 1
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:20:16 -0800
Message-ID: <167243881638.735065.16589572258129197530.stgit@magnolia>
In-Reply-To: <167243881598.735065.1487919004054265294.stgit@magnolia>
References: <167243881598.735065.1487919004054265294.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Allow creation of filesystems with reflink enabled and realtime extent
size larger than 1 block.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/init.c   |    7 -------
 mkfs/xfs_mkfs.c |   37 -------------------------------------
 2 files changed, 44 deletions(-)


diff --git a/libxfs/init.c b/libxfs/init.c
index a4023f78655..c04a30bb829 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -448,13 +448,6 @@ rtmount_init(
 	if (mp->m_sb.sb_rblocks == 0)
 		return 0;
 
-	if (xfs_has_reflink(mp) && mp->m_sb.sb_rextsize > 1) {
-		fprintf(stderr,
-	_("%s: Reflink not compatible with realtime extent size > 1. Please try a newer xfsprogs.\n"),
-				progname);
-		return -1;
-	}
-
 	if (mp->m_rtdev_targp->bt_bdev == 0 && !xfs_is_debugger(mp)) {
 		fprintf(stderr, _("%s: filesystem has a realtime subvolume\n"),
 			progname);
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index e406fa6a5ea..db828deadfb 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2385,24 +2385,6 @@ _("inode btree counters not supported without finobt support\n"));
 	}
 
 	if (cli->xi->rtname) {
-		if (cli->rtextsize && cli->sb_feat.reflink) {
-			if (cli_opt_set(&mopts, M_REFLINK)) {
-				fprintf(stderr,
-_("reflink not supported on realtime devices with rt extent size specified\n"));
-				usage();
-			}
-			cli->sb_feat.reflink = false;
-		}
-		if (cli->blocksize < XFS_MIN_RTEXTSIZE && cli->sb_feat.reflink) {
-			if (cli_opt_set(&mopts, M_REFLINK)) {
-				fprintf(stderr,
-_("reflink not supported on realtime devices with blocksize %d < %d\n"),
-						cli->blocksize,
-						XFS_MIN_RTEXTSIZE);
-				usage();
-			}
-			cli->sb_feat.reflink = false;
-		}
 		if (!cli->sb_feat.rtgroups && cli->sb_feat.reflink) {
 			if (cli_opt_set(&mopts, M_REFLINK) &&
 			    cli_opt_set(&ropts, R_RTGROUPS)) {
@@ -2582,19 +2564,6 @@ validate_rtextsize(
 			usage();
 		}
 		cfg->rtextblocks = (xfs_extlen_t)(rtextbytes >> cfg->blocklog);
-	} else if (cli->sb_feat.reflink && cli->xi->rtname) {
-		/*
-		 * reflink doesn't support rt extent size > 1FSB yet, so set
-		 * an extent size of 1FSB.  Make sure we still satisfy the
-		 * minimum rt extent size.
-		 */
-		if (cfg->blocksize < XFS_MIN_RTEXTSIZE) {
-			fprintf(stderr,
-		_("reflink not supported on rt volume with blocksize %d\n"),
-				cfg->blocksize);
-			usage();
-		}
-		cfg->rtextblocks = 1;
 	} else {
 		/*
 		 * If realtime extsize has not been specified by the user,
@@ -2626,12 +2595,6 @@ validate_rtextsize(
 		}
 	}
 	ASSERT(cfg->rtextblocks);
-
-	if (cli->sb_feat.reflink && cfg->rtblocks > 0 && cfg->rtextblocks > 1) {
-		fprintf(stderr,
-_("reflink not supported on realtime with extent sizes > 1\n"));
-		usage();
-	}
 }
 
 /* Validate the incoming extsize hint. */

