Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03757C83F1B
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Aug 2023 23:10:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239173AbjH2XJ6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Aug 2023 19:09:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236359AbjH2XJd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2023 19:09:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC063DB
        for <linux-xfs@vger.kernel.org>; Tue, 29 Aug 2023 16:09:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A11F61E8C
        for <linux-xfs@vger.kernel.org>; Tue, 29 Aug 2023 23:09:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0D9EC433C7;
        Tue, 29 Aug 2023 23:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693350569;
        bh=hx6zrA3cnrEMgEuzTlQ3T9Iw7OHbae7BwzgcR6SCASU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=oWYHXttgCZwf0liFCxv3JEfmOwMrjY2iJ43rvIDQBpnIhqB8H//FbJQMR+gUXn5Z3
         nWL+AhCQX97qsrznnyAuecfYWREgZz9Nq8P9OAqlbhtdnYATIskE5NhXwrE7Ut1rI2
         dojMev4awVeYOJFGsP2L59V4s83FYtcdfKG/H1VqixYFIBXpkH9/ywioiKzXfl5TE9
         Xz+v7sA/9UFdrfPg2t6ZkZZl15GKyFpenIpWmKw0xS6wL5huR9QtO0QIxTlJsOAKUS
         REs+4DoKQ/zZvO3JRsB0V64xoa5kO6cF31ikJ24xYhGSMDV7vWJU5fOR1i3x1raBNQ
         OCvmuPCPdB26A==
Subject: [PATCH 1/2] xfs: allow inode inactivation during a ro mount log
 recovery
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, chandan.babu@gmail.com
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, sandeen@sandeen.net
Date:   Tue, 29 Aug 2023 16:09:29 -0700
Message-ID: <169335056933.3525521.6054773682023937525.stgit@frogsfrogsfrogs>
In-Reply-To: <169335056369.3525521.1326787329447266634.stgit@frogsfrogsfrogs>
References: <169335056369.3525521.1326787329447266634.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

In the next patch, we're going to prohibit log recovery if the primary
superblock contains an unrecognized rocompat feature bit even on
readonly mounts.  This requires removing all the code in the log
mounting process that temporarily disables the readonly state.

Unfortunately, inode inactivation disables itself on readonly mounts.
Clearing the iunlinked lists after log recovery needs inactivation to
run to free the unreferenced inodes, which (AFAICT) is the only reason
why log mounting plays games with the readonly state in the first place.

Therefore, change the inactivation predicates to allow inactivation
during log recovery of a readonly mount.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_inode.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 9e62cc500140..6ee266be45d4 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1643,8 +1643,11 @@ xfs_inode_needs_inactive(
 	if (VFS_I(ip)->i_mode == 0)
 		return false;
 
-	/* If this is a read-only mount, don't do this (would generate I/O) */
-	if (xfs_is_readonly(mp))
+	/*
+	 * If this is a read-only mount, don't do this (would generate I/O)
+	 * unless we're in log recovery and cleaning the iunlinked list.
+	 */
+	if (xfs_is_readonly(mp) && !xlog_recovery_needed(mp->m_log))
 		return false;
 
 	/* If the log isn't running, push inodes straight to reclaim. */
@@ -1704,8 +1707,11 @@ xfs_inactive(
 	mp = ip->i_mount;
 	ASSERT(!xfs_iflags_test(ip, XFS_IRECOVERY));
 
-	/* If this is a read-only mount, don't do this (would generate I/O) */
-	if (xfs_is_readonly(mp))
+	/*
+	 * If this is a read-only mount, don't do this (would generate I/O)
+	 * unless we're in log recovery and cleaning the iunlinked list.
+	 */
+	if (xfs_is_readonly(mp) && !xlog_recovery_needed(mp->m_log))
 		goto out;
 
 	/* Metadata inodes require explicit resource cleanup. */

