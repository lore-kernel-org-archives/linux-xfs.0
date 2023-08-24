Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CA6AC727A3
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Aug 2023 23:22:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244048AbjHXXWM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Aug 2023 19:22:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244065AbjHXXVy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Aug 2023 19:21:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18B3A1993
        for <linux-xfs@vger.kernel.org>; Thu, 24 Aug 2023 16:21:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3F8A65314
        for <linux-xfs@vger.kernel.org>; Thu, 24 Aug 2023 23:21:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10A19C433C9;
        Thu, 24 Aug 2023 23:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692919307;
        bh=b3NFzny0HHABVZsHDiAWL7mB8aU+lQQzZVbmVKRUOmw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Jf3SoDfNPTTJVIhcTrq+R4q9WyHEF5T+dYkw/kLWH8ur9v1a5z+ohILLUfj0ObOQx
         z1wd7PHpS6S4tJqfCKQqsFG9GGyq9NWirJe75EFvamJl4GMUO4w/f/2252fdMStbtd
         jdKw74wndc6NzOG8GEf9QdYBP/AgEohLargkCT1mC9DCTvudvYa95Ezy9FyOHS27BI
         8P27Wl2Q6uXFegsLJ1SiwojPspaSpV0FfDTgIFUzpabBWv/gLcQN/qFbizZwlIZ4ec
         VzGje0AVfxruOYmTo75mKPXVkKFpSQ+qWlJsmn7SBxClnNr8abGF46KiAXy57j96QE
         wKN7cuNK1ETlA==
Subject: [PATCH 2/3] xfs: don't allow log recovery when unknown rocompat bits
 are set
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     chandan.babu@gmail.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, sandeen@sandeen.net
Date:   Thu, 24 Aug 2023 16:21:46 -0700
Message-ID: <169291930662.220104.8435560164784332097.stgit@frogsfrogsfrogs>
In-Reply-To: <169291929524.220104.3844042018007786965.stgit@frogsfrogsfrogs>
References: <169291929524.220104.3844042018007786965.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Don't allow log recovery to proceed on a readonly mount if the primary
superblock advertises unknown rocompat bits.  We used to allow this, but
due to a misunderstanding between Dave and Darrick back in 2016, we
cannot do that anymore.  The XFS_SB_FEAT_RO_COMPAT_RMAPBT feature (4.8)
protects RUI log items, and the REFLINK feature (4.9) protects CUI/BUI
log items, which is why we can't allow older kernels to recover them.

Fixes: b87049444ac4 ("xfs: introduce rmap btree definitions")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_log.c         |   17 -----------------
 fs/xfs/xfs_log_recover.c |   25 +++++++++++++++++++++++++
 2 files changed, 25 insertions(+), 17 deletions(-)


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
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 82c81d20459d..b4458b7fd6f7 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3354,6 +3354,7 @@ xlog_recover(
 	struct xlog	*log)
 {
 	xfs_daddr_t	head_blk, tail_blk;
+	bool		unknown_rocompat = false;
 	int		error;
 
 	/* find the tail of the log */
@@ -3370,6 +3371,12 @@ xlog_recover(
 	    !xfs_log_check_lsn(log->l_mp, log->l_mp->m_sb.sb_lsn))
 		return -EINVAL;
 
+	/* Detect unknown rocompat features in the superblock */
+	if (xfs_has_crc(log->l_mp) &&
+	    xfs_sb_has_ro_compat_feature(&log->l_mp->m_sb,
+					 XFS_SB_FEAT_RO_COMPAT_UNKNOWN))
+		unknown_rocompat = true;
+
 	if (tail_blk != head_blk) {
 		/* There used to be a comment here:
 		 *
@@ -3407,6 +3414,24 @@ xlog_recover(
 			return -EINVAL;
 		}
 
+		/*
+		 * Don't allow log recovery on a ro mount if there are unknown
+		 * ro compat bits set.  We used to allow this, but BUI/CUI log
+		 * items are protected by the REFLINK rocompat bit so now we
+		 * cannot.
+		 */
+		if (xfs_is_readonly(log->l_mp) && unknown_rocompat) {
+			xfs_alert(log->l_mp,
+"Superblock has unknown read-only compatible features (0x%x) enabled.",
+				 (log->l_mp->m_sb.sb_features_ro_compat &
+						XFS_SB_FEAT_RO_COMPAT_UNKNOWN));
+			xfs_warn(log->l_mp,
+"The log can not be fully and/or safely recovered by this kernel.");
+			xfs_warn(log->l_mp,
+"Please recover the log on a kernel that supports the unknown features.");
+			return -EINVAL;
+		}
+
 		/*
 		 * Delay log recovery if the debug hook is set. This is debug
 		 * instrumentation to coordinate simulation of I/O failures with

