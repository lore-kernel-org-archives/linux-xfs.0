Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A653C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 24 May 2022 05:36:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232414AbiEXFgg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 May 2022 01:36:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234516AbiEXFgf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 May 2022 01:36:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85E1F3466A
        for <linux-xfs@vger.kernel.org>; Mon, 23 May 2022 22:36:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 43DB6B8169C
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 05:36:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D48F1C385AA;
        Tue, 24 May 2022 05:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653370591;
        bh=4/WJZEXYA+dVmpd/G41CBe5+kCzO/o88JT7bKF5dmrQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=dQ0Jp9/MGuM46J/s0AKHCsUikQNh9ixTmsYwnswG6dmbjO00BpNEY7Um5TSdFXf9M
         Wwqoi9Dk70RTyrPgive+Iw+VFZcDXYH1Rob/jR8BiLD4jUjA1KUrqGVbu36WtTepJV
         SnB1HOMA39kKQ49A9Wrp2OifIzFURd4DfY3xvCJ6FDJ6UPFehwNVtQOOYMvIiwhQ5K
         Kw70PueLOUdkzajmqGUHFqBLnqVr4qhZSWJZjeG6qCc+LAaZqmhetbBkVZI8acQD3K
         jGTrK99QQW3g+dMxOMZF/VE09RsU1cUKAs6sOAz6UZoTg85uueYBnMkNtrSCW7/Whb
         oCvCIieEddmoA==
Subject: [PATCH 2/5] xfs: implement per-mount warnings for scrub and shrink
 usage
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        allison.henderson@oracle.com
Date:   Mon, 23 May 2022 22:36:31 -0700
Message-ID: <165337059142.994444.15610566270833642160.stgit@magnolia>
In-Reply-To: <165337058023.994444.12794741176651030531.stgit@magnolia>
References: <165337058023.994444.12794741176651030531.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Currently, we don't have a consistent story around logging when an
EXPERIMENTAL feature gets turned on at runtime -- online fsck and shrink
log a message once per day across all mounts, and the recently merged
LARP mode only ever does it once per insmod cycle or reboot.

Because EXPERIMENTAL tags are supposed to go away eventually, convert
the existing daily warnings into state flags that travel with the mount,
and warn once per mount.  Making this an opstate flag means that we'll
be able to capture the experimental usage in the ftrace output too.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/scrub.c |   17 ++---------------
 fs/xfs/xfs_fsops.c   |    7 +------
 fs/xfs/xfs_message.h |    6 ++++++
 fs/xfs/xfs_mount.h   |   15 ++++++++++++++-
 4 files changed, 23 insertions(+), 22 deletions(-)


diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index b11870d07c56..2e8e400f10a9 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -340,20 +340,6 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 	},
 };
 
-/* This isn't a stable feature, warn once per day. */
-static inline void
-xchk_experimental_warning(
-	struct xfs_mount	*mp)
-{
-	static struct ratelimit_state scrub_warning = RATELIMIT_STATE_INIT(
-			"xchk_warning", 86400 * HZ, 1);
-	ratelimit_set_flags(&scrub_warning, RATELIMIT_MSG_ON_RELEASE);
-
-	if (__ratelimit(&scrub_warning))
-		xfs_alert(mp,
-"EXPERIMENTAL online scrub feature in use. Use at your own risk!");
-}
-
 static int
 xchk_validate_inputs(
 	struct xfs_mount		*mp,
@@ -478,7 +464,8 @@ xfs_scrub_metadata(
 	if (error)
 		goto out;
 
-	xchk_experimental_warning(mp);
+	xfs_warn_mount(mp, XFS_OPSTATE_WARNED_SCRUB,
+ "EXPERIMENTAL online scrub feature in use. Use at your own risk!");
 
 	sc = kmem_zalloc(sizeof(struct xfs_scrub), KM_NOFS | KM_MAYFAIL);
 	if (!sc) {
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 888839e75d11..d4a77c53f94b 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -149,12 +149,7 @@ xfs_growfs_data_private(
 		error = xfs_resizefs_init_new_ags(tp, &id, oagcount, nagcount,
 						  delta, &lastag_extended);
 	} else {
-		static struct ratelimit_state shrink_warning = \
-			RATELIMIT_STATE_INIT("shrink_warning", 86400 * HZ, 1);
-		ratelimit_set_flags(&shrink_warning, RATELIMIT_MSG_ON_RELEASE);
-
-		if (__ratelimit(&shrink_warning))
-			xfs_alert(mp,
+		xfs_warn_mount(mp, XFS_OPSTATE_WARNED_SHRINK,
 	"EXPERIMENTAL online shrink feature in use. Use at your own risk!");
 
 		error = xfs_ag_shrink_space(mp, &tp, nagcount - 1, -delta);
diff --git a/fs/xfs/xfs_message.h b/fs/xfs/xfs_message.h
index 55ee464ab59f..cc323775a12c 100644
--- a/fs/xfs/xfs_message.h
+++ b/fs/xfs/xfs_message.h
@@ -75,6 +75,12 @@ do {									\
 #define xfs_debug_ratelimited(dev, fmt, ...)				\
 	xfs_printk_ratelimited(xfs_debug, dev, fmt, ##__VA_ARGS__)
 
+#define xfs_warn_mount(mp, warntag, fmt, ...)				\
+do {									\
+	if (xfs_should_warn((mp), (warntag)))				\
+		xfs_warn((mp), (fmt), ##__VA_ARGS__);			\
+} while (0)
+
 #define xfs_warn_once(dev, fmt, ...)				\
 	xfs_printk_once(xfs_warn, dev, fmt, ##__VA_ARGS__)
 #define xfs_notice_once(dev, fmt, ...)				\
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 8c42786e4942..93a954271db2 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -391,6 +391,11 @@ __XFS_HAS_FEAT(nouuid, NOUUID)
  */
 #define XFS_OPSTATE_BLOCKGC_ENABLED	6
 
+/* Kernel has logged a warning about online fsck being used on this fs. */
+#define XFS_OPSTATE_WARNED_SCRUB	7
+/* Kernel has logged a warning about shrink being used on this fs. */
+#define XFS_OPSTATE_WARNED_SHRINK	8
+
 #define __XFS_IS_OPSTATE(name, NAME) \
 static inline bool xfs_is_ ## name (struct xfs_mount *mp) \
 { \
@@ -413,6 +418,12 @@ __XFS_IS_OPSTATE(readonly, READONLY)
 __XFS_IS_OPSTATE(inodegc_enabled, INODEGC_ENABLED)
 __XFS_IS_OPSTATE(blockgc_enabled, BLOCKGC_ENABLED)
 
+static inline bool
+xfs_should_warn(struct xfs_mount *mp, long nr)
+{
+	return !test_and_set_bit(nr, &mp->m_opstate);
+}
+
 #define XFS_OPSTATE_STRINGS \
 	{ (1UL << XFS_OPSTATE_UNMOUNTING),		"unmounting" }, \
 	{ (1UL << XFS_OPSTATE_CLEAN),			"clean" }, \
@@ -420,7 +431,9 @@ __XFS_IS_OPSTATE(blockgc_enabled, BLOCKGC_ENABLED)
 	{ (1UL << XFS_OPSTATE_INODE32),			"inode32" }, \
 	{ (1UL << XFS_OPSTATE_READONLY),		"read_only" }, \
 	{ (1UL << XFS_OPSTATE_INODEGC_ENABLED),		"inodegc" }, \
-	{ (1UL << XFS_OPSTATE_BLOCKGC_ENABLED),		"blockgc" }
+	{ (1UL << XFS_OPSTATE_BLOCKGC_ENABLED),		"blockgc" }, \
+	{ (1UL << XFS_OPSTATE_WARNED_SCRUB),		"wscrub" }, \
+	{ (1UL << XFS_OPSTATE_WARNED_SHRINK),		"wshrink" }
 
 /*
  * Max and min values for mount-option defined I/O

