Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F613C43334
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jun 2022 20:50:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbiF1Uur (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jun 2022 16:50:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbiF1Uuo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jun 2022 16:50:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2281E31912
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 13:50:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D6700B8204E
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 20:50:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 796DDC341C8;
        Tue, 28 Jun 2022 20:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656449440;
        bh=lMZ1tFSvqNrORICVwOGGKtKdklbZnq7QroBEte/Cuds=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=UW5EgrRINmiZJKeRa2QFxVH1K150fgsM/xbM70LwmQ9fxY03DfuJITwJk+RRbRy/E
         l7HYcwS4MsR5fa+tsWqnrqo81DFZnfSZVFdnrIzbi382D9SXpgOx7ckKjxRxlBz2LC
         PU8rC5aChun85xw6PfiVuxzKwxmb4F0rFMq5IrBBtCy3qHtqXKQn1FIGBR5YRFimLz
         O5yLSpNbwpxhYZizUjM0r2zGHfuL2AHrtqcgT7t9ML4Gq3pnDBgzXKS54dvezvI9dH
         cd92knRxll+N/RFZH6DS7EitsMRPfTopS8b3tcKxr8C6gRWeZEbY/3+mZlWmO9HDso
         BBLIPBoqK2zgQ==
Subject: [PATCH 1/3] xfs_repair: always rewrite secondary supers when
 needsrepair is set
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Date:   Tue, 28 Jun 2022 13:50:40 -0700
Message-ID: <165644944011.1091715.17634098731085183377.stgit@magnolia>
In-Reply-To: <165644943454.1091715.4250245702579572029.stgit@magnolia>
References: <165644943454.1091715.4250245702579572029.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Dave Chinner complained about xfs_scrub failures coming from xfs/158.
That test induces xfs_repair to fail while upgrading a filesystem to
have the inobtcount feature, and then restarts xfs_repair to finish the
upgrade.  When the second xfs_repair run starts, it will find that the
primary super has NEEDSREPAIR set, along with whatever new feature that
we were trying to add to the filesystem.

From there, repair completes the upgrade in much the same manner as the
first repair run would have, with one big exception -- it forgets to set
features_changed to trigger rewriting of the secondary supers at the end
of repair.  This results in discrepancies between the supers:

# XFS_REPAIR_FAIL_AFTER_PHASE=2 xfs_repair -c inobtcount=1 /dev/sdf
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Adding inode btree counts to filesystem.
Killed
# xfs_repair /dev/sdf
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
clearing needsrepair flag and regenerating metadata
bad inobt block count 0, saw 1
bad finobt block count 0, saw 1
bad inobt block count 0, saw 1
bad finobt block count 0, saw 1
bad inobt block count 0, saw 1
bad finobt block count 0, saw 1
bad inobt block count 0, saw 1
bad finobt block count 0, saw 1
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 1
        - agno = 2
        - agno = 0
        - agno = 3
Phase 5 - rebuild AG headers and trees...
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify and correct link counts...
done
# xfs_db -c 'sb 0' -c 'print' -c 'sb 1' -c 'print' /dev/sdf | \
	egrep '(features_ro_compat|features_incompat)'
features_ro_compat = 0xd
features_incompat = 0xb
features_ro_compat = 0x5
features_incompat = 0xb

Curiously, re-running xfs_repair will not trigger any warnings about the
featureset mismatch between the primary and secondary supers.  xfs_scrub
immediately notices, which is what causes xfs/158 to fail.

This discrepancy doesn't happen when the upgrade completes successfully
in a single repair run, so we need to teach repair to rewrite the
secondaries at the end of repair any time needsrepair was set.

Reported-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/agheader.c |    8 ++++++++
 1 file changed, 8 insertions(+)


diff --git a/repair/agheader.c b/repair/agheader.c
index 36da1395..e91509d0 100644
--- a/repair/agheader.c
+++ b/repair/agheader.c
@@ -552,6 +552,14 @@ secondary_sb_whack(
 			else
 				do_warn(
 	_("would clear needsrepair flag and regenerate metadata\n"));
+			/*
+			 * If needsrepair is set on the primary super, there's
+			 * a possibility that repair crashed during an upgrade.
+			 * Set features_changed to ensure that the secondary
+			 * supers are rewritten with the new feature bits once
+			 * we've finished the upgrade.
+			 */
+			features_changed = true;
 		} else {
 			/*
 			 * Quietly clear needsrepair on the secondary supers as

