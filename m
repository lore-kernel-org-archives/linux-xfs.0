Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C144C83F2C
	for <linux-xfs@archiver.kernel.org>; Sun,  3 Sep 2023 16:16:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244625AbjICQQJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 3 Sep 2023 12:16:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237525AbjICQQJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Sep 2023 12:16:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15317FE
        for <linux-xfs@vger.kernel.org>; Sun,  3 Sep 2023 09:16:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A075960DB7
        for <linux-xfs@vger.kernel.org>; Sun,  3 Sep 2023 16:16:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0677BC433C7;
        Sun,  3 Sep 2023 16:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693757765;
        bh=ToN0sqIwPGnrhTedvupzdtizHGpqAz6ZQhOPhW743gU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=QlMkLgaoUu0DyQQi7+rpN8+dnHiKRsg6i2rtIAtx80qQCzZTzn/D1dJklxfdc+IIJ
         zO7DCcEVRq1Uo7RqzQdtww75MjpeSZgb4c+ORetDWiXTnnn0KUhO1i4faJUtFfyiBj
         BrX6iBj6cctvYd/olssc6oJcx90SA22y1eUvMYQZk7imNNXoNQzJMte5035r3z14wC
         oG2ohIgpR0TA6OVE37aEIoCyT4qaOU+ioDhzPOXrujX3IfXvxbaGHHzwDN9SJvF0im
         pfwXaFhMy5BLCxBkW5TFaBKuQxHgJ9bqJ50wFGTYkUOFsZvARzoFjWEhsRvIRW7kPt
         d4qpG3uGpM6jQ==
Subject: [PATCH 3/3] xfs: make inode unlinked bucket recovery work with
 quotacheck
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     chandan.babu@gmail.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Sun, 03 Sep 2023 09:16:04 -0700
Message-ID: <169375776451.3323693.17265659636054853468.stgit@frogsfrogsfrogs>
In-Reply-To: <169375774749.3323693.18063212270653101716.stgit@frogsfrogsfrogs>
References: <169375774749.3323693.18063212270653101716.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Teach quotacheck to reload the unlinked inode lists when walking the
inode table.  This requires extra state handling, since it's possible
that a reloaded inode will get inactivated before quotacheck tries to
scan it; in this case, we need to ensure that the reloaded inode does
not have dquots attached when it is freed.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_inode.c |   12 +++++++++---
 fs/xfs/xfs_inode.h |    5 ++++-
 fs/xfs/xfs_mount.h |    7 +++++++
 fs/xfs/xfs_qm.c    |    7 +++++++
 4 files changed, 27 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 56f6bde6001b..22af7268169b 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1743,9 +1743,13 @@ xfs_inactive(
 	     ip->i_df.if_nextents > 0 || ip->i_delayed_blks > 0))
 		truncate = 1;
 
-	error = xfs_qm_dqattach(ip);
-	if (error)
-		goto out;
+	if (xfs_iflags_test(ip, XFS_IQUOTAUNCHECKED)) {
+		xfs_qm_dqdetach(ip);
+	} else {
+		error = xfs_qm_dqattach(ip);
+		if (error)
+			goto out;
+	}
 
 	if (S_ISLNK(VFS_I(ip)->i_mode))
 		error = xfs_inactive_symlink(ip);
@@ -1963,6 +1967,8 @@ xfs_iunlink_reload_next(
 	trace_xfs_iunlink_reload_next(next_ip);
 rele:
 	ASSERT(!(VFS_I(next_ip)->i_state & I_DONTCACHE));
+	if (xfs_is_quotacheck_running(mp) && next_ip)
+		xfs_iflags_set(next_ip, XFS_IQUOTAUNCHECKED);
 	xfs_irele(next_ip);
 	return error;
 }
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index a111b5551ecd..0c5bdb91152e 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -344,6 +344,9 @@ static inline bool xfs_inode_has_large_extent_counts(struct xfs_inode *ip)
  */
 #define XFS_INACTIVATING	(1 << 13)
 
+/* Quotacheck is running but inode has not been added to quota counts. */
+#define XFS_IQUOTAUNCHECKED	(1 << 14)
+
 /* All inode state flags related to inode reclaim. */
 #define XFS_ALL_IRECLAIM_FLAGS	(XFS_IRECLAIMABLE | \
 				 XFS_IRECLAIM | \
@@ -358,7 +361,7 @@ static inline bool xfs_inode_has_large_extent_counts(struct xfs_inode *ip)
 #define XFS_IRECLAIM_RESET_FLAGS	\
 	(XFS_IRECLAIMABLE | XFS_IRECLAIM | \
 	 XFS_IDIRTY_RELEASE | XFS_ITRUNCATED | XFS_NEED_INACTIVE | \
-	 XFS_INACTIVATING)
+	 XFS_INACTIVATING | XFS_IQUOTAUNCHECKED)
 
 /*
  * Flags for inode locking.
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 6e2806654e94..e6ae627ac771 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -405,6 +405,8 @@ __XFS_HAS_FEAT(nouuid, NOUUID)
 #define XFS_OPSTATE_WARNED_SHRINK	8
 /* Kernel has logged a warning about logged xattr updates being used. */
 #define XFS_OPSTATE_WARNED_LARP		9
+/* Mount time quotacheck is running */
+#define XFS_OPSTATE_QUOTACHECK_RUNNING	10
 
 #define __XFS_IS_OPSTATE(name, NAME) \
 static inline bool xfs_is_ ## name (struct xfs_mount *mp) \
@@ -427,6 +429,11 @@ __XFS_IS_OPSTATE(inode32, INODE32)
 __XFS_IS_OPSTATE(readonly, READONLY)
 __XFS_IS_OPSTATE(inodegc_enabled, INODEGC_ENABLED)
 __XFS_IS_OPSTATE(blockgc_enabled, BLOCKGC_ENABLED)
+#ifdef CONFIG_QUOTA
+__XFS_IS_OPSTATE(quotacheck_running, QUOTACHECK_RUNNING)
+#else
+# define xfs_is_quotacheck_running(mp)	(false)
+#endif
 
 static inline bool
 xfs_should_warn(struct xfs_mount *mp, long nr)
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 6abcc34fafd8..7256090c3895 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1160,6 +1160,10 @@ xfs_qm_dqusage_adjust(
 	if (error)
 		return error;
 
+	error = xfs_inode_reload_unlinked(ip);
+	if (error)
+		goto error0;
+
 	ASSERT(ip->i_delayed_blks == 0);
 
 	if (XFS_IS_REALTIME_INODE(ip)) {
@@ -1173,6 +1177,7 @@ xfs_qm_dqusage_adjust(
 	}
 
 	nblks = (xfs_qcnt_t)ip->i_nblocks - rtblks;
+	xfs_iflags_clear(ip, XFS_IQUOTAUNCHECKED);
 
 	/*
 	 * Add the (disk blocks and inode) resources occupied by this
@@ -1319,8 +1324,10 @@ xfs_qm_quotacheck(
 		flags |= XFS_PQUOTA_CHKD;
 	}
 
+	xfs_set_quotacheck_running(mp);
 	error = xfs_iwalk_threaded(mp, 0, 0, xfs_qm_dqusage_adjust, 0, true,
 			NULL);
+	xfs_clear_quotacheck_running(mp);
 
 	/*
 	 * On error, the inode walk may have partially populated the dquot

