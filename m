Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E47BCC6FA8F
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Aug 2023 23:10:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236359AbjH2XJ7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Aug 2023 19:09:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239246AbjH2XJi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2023 19:09:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8003FDB
        for <linux-xfs@vger.kernel.org>; Tue, 29 Aug 2023 16:09:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E77E6314C
        for <linux-xfs@vger.kernel.org>; Tue, 29 Aug 2023 23:09:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82B6AC433C7;
        Tue, 29 Aug 2023 23:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693350575;
        bh=D7NduEXpRQyrFMcdjngEEXGXvMANacZp0exXjMjiwtY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=pd84RFC0u/tgyQP/W2gunzUzA6nMiSEqNRvX6ZUybvlzcY0RHurH/gZtlOgvXqy9r
         WA2CE+EGY+dTtt9vZPSAeOP2uAHssnY975X/sln3qZEPncskuILQ2ZUw1D980eFK48
         vv8bUCinvRMSfwuT1+Q9P8t7Gd3btaZd7y2cijbaJXABhZ5E4862UXVW3zyjmH9RoK
         vSZe4omyAS06JhTsTII5epOABteHX/hkvJDr9WTzk09RoyjVRDrsmfky7mmieyhOkv
         vCRQTlRmBTIiCyc1MaaZNdtr+KGmczq7qqz5MMimybWGV9/nh/VvQQBEwWrhXwSQSL
         dS3B2oiz1LLBA==
Subject: [PATCH 2/2] xfs: fix log recovery when unknown rocompat bits are set
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, chandan.babu@gmail.com
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, sandeen@sandeen.net
Date:   Tue, 29 Aug 2023 16:09:35 -0700
Message-ID: <169335057499.3525521.13864967150156919137.stgit@frogsfrogsfrogs>
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

Fix log recovery to proceed on a readonly mount if the primary sb
advertises unknown rocompat bits.  We used to allow this, but due to a
misunderstanding between Eric and Darrick back in 2018, we accidentally
changed the superblock write verifier to shutdown the fs over that exact
scenario.  As a result, the log cleaning that occurs at the end of the
mounting process fails.

We now allow writing of the superblock if there are unknown rocompat
bits set, but only if the filesystem is read only.  Hence we still have
to remove all ro state toggling that occurs around the log mount calls.

Fixes: 9e037cb7972f ("xfs: check for unknown v5 feature bits in superblock write verifier"
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_sb.c |    3 ++-
 fs/xfs/xfs_log.c       |   17 -----------------
 2 files changed, 2 insertions(+), 18 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 5e174685a77c..6264daaab37b 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -266,7 +266,8 @@ xfs_validate_sb_write(
 		return -EFSCORRUPTED;
 	}
 
-	if (xfs_sb_has_ro_compat_feature(sbp, XFS_SB_FEAT_RO_COMPAT_UNKNOWN)) {
+	if (!xfs_is_readonly(mp) &&
+	    xfs_sb_has_ro_compat_feature(sbp, XFS_SB_FEAT_RO_COMPAT_UNKNOWN)) {
 		xfs_alert(mp,
 "Corruption detected in superblock read-only compatible features (0x%x)!",
 			(sbp->sb_features_ro_compat &
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 79004d193e54..51c100c86177 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -715,15 +715,7 @@ xfs_log_mount(
 	 * just worked.
 	 */
 	if (!xfs_has_norecovery(mp)) {
-		/*
-		 * log recovery ignores readonly state and so we need to clear
-		 * mount-based read only state so it can write to disk.
-		 */
-		bool	readonly = test_and_clear_bit(XFS_OPSTATE_READONLY,
-						&mp->m_opstate);
 		error = xlog_recover(log);
-		if (readonly)
-			set_bit(XFS_OPSTATE_READONLY, &mp->m_opstate);
 		if (error) {
 			xfs_warn(mp, "log mount/recovery failed: error %d",
 				error);
@@ -772,7 +764,6 @@ xfs_log_mount_finish(
 	struct xfs_mount	*mp)
 {
 	struct xlog		*log = mp->m_log;
-	bool			readonly;
 	int			error = 0;
 
 	if (xfs_has_norecovery(mp)) {
@@ -780,12 +771,6 @@ xfs_log_mount_finish(
 		return 0;
 	}
 
-	/*
-	 * log recovery ignores readonly state and so we need to clear
-	 * mount-based read only state so it can write to disk.
-	 */
-	readonly = test_and_clear_bit(XFS_OPSTATE_READONLY, &mp->m_opstate);
-
 	/*
 	 * During the second phase of log recovery, we need iget and
 	 * iput to behave like they do for an active filesystem.
@@ -835,8 +820,6 @@ xfs_log_mount_finish(
 	xfs_buftarg_drain(mp->m_ddev_targp);
 
 	clear_bit(XLOG_RECOVERY_NEEDED, &log->l_opstate);
-	if (readonly)
-		set_bit(XFS_OPSTATE_READONLY, &mp->m_opstate);
 
 	/* Make sure the log is dead if we're returning failure. */
 	ASSERT(!error || xlog_is_shutdown(log));

