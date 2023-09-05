Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EAA3CA0FFA
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Sep 2023 18:20:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbjIESUU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Sep 2023 14:20:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239151AbjIESUK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Sep 2023 14:20:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CE33F4
        for <linux-xfs@vger.kernel.org>; Tue,  5 Sep 2023 11:19:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 624D0B81593
        for <linux-xfs@vger.kernel.org>; Tue,  5 Sep 2023 16:33:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04E1CC433C7;
        Tue,  5 Sep 2023 16:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693931584;
        bh=4AYFhAKY5hDuOuYymS/lDylkp60C/z1KYHfgrhWGmIg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fjPmxlixLOJjbD5ECo+TblREzI/MIo9m897Uu3dud7f7diF9SwD2iqQ+J42dKHLRk
         59z4m5qgsLNYsASHbZvlc85lMI7K3pa5BAFxPgHdHcnRrWvSxRWlnRc9XG1fRVv5y5
         aw1S0wMuTrSIWMzMDgDy1loEpkjfvSlzCN73TDRnl8ILWO8TEe2HJxigWCTL7NKX2/
         KmW8JyDAzVsUGBkqbEZRVh6KJZrbzkGc0HG9DONTN03hWD2tReHZPeWIxF45Ac8zBO
         tJtVqo9zU5F1z1u2oU5VHHa1gHPnn+7PomHbJyt1QAsQU4WA+VcMC+QAiNXDOxW480
         et+cAYgyWGrVw==
Date:   Tue, 5 Sep 2023 09:33:03 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     chandan.babu@gmail.com
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: [PATCH v1.1 3/3] xfs: make inode unlinked bucket recovery work with
 quotacheck
Message-ID: <20230905163303.GU28186@frogsfrogsfrogs>
References: <169375774749.3323693.18063212270653101716.stgit@frogsfrogsfrogs>
 <169375776451.3323693.17265659636054853468.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169375776451.3323693.17265659636054853468.stgit@frogsfrogsfrogs>
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
v1.1: s/CONFIG_QUOTA/CONFIG_XFS_QUOTA/ and fix tracepoint flags decoding
---
 fs/xfs/xfs_inode.c |   12 +++++++++---
 fs/xfs/xfs_inode.h |    5 ++++-
 fs/xfs/xfs_mount.h |   10 +++++++++-
 fs/xfs/xfs_qm.c    |    7 +++++++
 4 files changed, 29 insertions(+), 5 deletions(-)

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
index 6e2806654e94..d19cca099bc3 100644
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
+#ifdef CONFIG_XFS_QUOTA
+__XFS_IS_OPSTATE(quotacheck_running, QUOTACHECK_RUNNING)
+#else
+# define xfs_is_quotacheck_running(mp)	(false)
+#endif
 
 static inline bool
 xfs_should_warn(struct xfs_mount *mp, long nr)
@@ -444,7 +451,8 @@ xfs_should_warn(struct xfs_mount *mp, long nr)
 	{ (1UL << XFS_OPSTATE_BLOCKGC_ENABLED),		"blockgc" }, \
 	{ (1UL << XFS_OPSTATE_WARNED_SCRUB),		"wscrub" }, \
 	{ (1UL << XFS_OPSTATE_WARNED_SHRINK),		"wshrink" }, \
-	{ (1UL << XFS_OPSTATE_WARNED_LARP),		"wlarp" }
+	{ (1UL << XFS_OPSTATE_WARNED_LARP),		"wlarp" }, \
+	{ (1UL << XFS_OPSTATE_QUOTACHECK_RUNNING),	"quotacheck" }
 
 /*
  * Max and min values for mount-option defined I/O
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
