Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29B61C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:34:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235438AbiL3XeJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:34:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231282AbiL3XeI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:34:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 460C21DDF0
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:34:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E6FBFB81D97
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:34:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1712C433D2;
        Fri, 30 Dec 2022 23:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672443244;
        bh=L8AXkrrL7wSaKAEmwBWNehD8Wp9AaKklyAzUuSFHl8k=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=sNmQuTD5+H8nOL/Q3R3lQzLQs6mppZ+rAyz8AXF1mQraekoAQ6W5/cwxbh7/5I11E
         Bu9n4D2lwSRYylFNdntBx58j0djNoYdCgbdMV+QYV7RFQX6CqkrumjQPhzGBxYEkug
         a9zCIPQ2rBeqVyTMR55sJRUqe5KVacdrpLRXROT1BBue307QWyJnBF3251d8XnGheo
         s5lwM93efuJ4Uy4c1AQ3N3Y8BCP2qkFeopKKc105kfj2p1MA34zCmPzaIcoI/H+5x0
         vdXTFHoch4di4MiiOHUP3lIqOcHsMUUwqyPRRw8n3Mape55RwoTkk5svn+QAhKSV83
         UtDv96sTrqovw==
Subject: [PATCH 4/4] xfs: allow blocking notifier chains with filesystem hooks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:13:03 -0800
Message-ID: <167243838390.695519.7389091201360281273.stgit@magnolia>
In-Reply-To: <167243838331.695519.18058154683213474280.stgit@magnolia>
References: <167243838331.695519.18058154683213474280.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Make it so that we can switch between notifier chain implementations for
testing purposes.  On the author's test system, calling an empty srcu
notifier chain cost about 19ns per call, vs. 4ns for a blocking notifier
chain.  Hm.  Might we actually want regular blocking notifiers?

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Kconfig     |   33 ++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_hooks.c |   41 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_hooks.h |    6 +++++-
 3 files changed, 78 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
index db60944ab3c3..54806c2b80d4 100644
--- a/fs/xfs/Kconfig
+++ b/fs/xfs/Kconfig
@@ -106,7 +106,6 @@ config XFS_ONLINE_SCRUB
 	default n
 	depends on XFS_FS
 	depends on TMPFS && SHMEM
-	depends on SRCU
 	select XFS_LIVE_HOOKS
 	select XFS_DRAIN_INTENTS
 	help
@@ -122,6 +121,38 @@ config XFS_ONLINE_SCRUB
 
 	  If unsure, say N.
 
+choice
+	prompt "XFS hook implementation"
+	depends on XFS_FS && XFS_LIVE_HOOKS && XFS_ONLINE_SCRUB
+	default XFS_LIVE_HOOKS_BLOCKING if HAVE_ARCH_JUMP_LABEL
+	default XFS_LIVE_HOOKS_SRCU if !HAVE_ARCH_JUMP_LABEL
+	help
+	  Pick one
+
+config XFS_LIVE_HOOKS_SRCU
+	bool "SRCU notifier chains"
+	depends on SRCU
+	help
+	  Use SRCU notifier chains for filesystem hooks.  These have very low
+	  overhead for event initiators (the main filesystem) and higher
+	  overhead for chain modifiers (scrub waits for RCU grace).  This is
+	  the best option when jump labels are not supported or there are many
+	  CPUs in the system.
+
+	  This may cause problems with CPU hotplug invoking reclaim invoking
+	  XFS.
+
+config XFS_LIVE_HOOKS_BLOCKING
+	bool "Blocking notifier chains"
+	help
+	  Use blocking notifier chains for filesystem hooks.  These have medium
+	  overhead for event initiators (the main fs) and chain modifiers
+	  (scrub) due to their use of rwsems.  This is the best option when
+	  jump labels can be used to eliminate overhead for the filesystem when
+	  scrub is not running.
+
+endchoice
+
 config XFS_ONLINE_REPAIR
 	bool "XFS online metadata repair support"
 	default n
diff --git a/fs/xfs/xfs_hooks.c b/fs/xfs/xfs_hooks.c
index 3f958ece0dc0..653fc1f82516 100644
--- a/fs/xfs/xfs_hooks.c
+++ b/fs/xfs/xfs_hooks.c
@@ -12,6 +12,7 @@
 #include "xfs_ag.h"
 #include "xfs_trace.h"
 
+#if defined(CONFIG_XFS_LIVE_HOOKS_SRCU)
 /* Initialize a notifier chain. */
 void
 xfs_hooks_init(
@@ -51,3 +52,43 @@ xfs_hooks_call(
 {
 	return srcu_notifier_call_chain(&chain->head, val, priv);
 }
+#elif defined(CONFIG_XFS_LIVE_HOOKS_BLOCKING)
+/* Initialize a notifier chain. */
+void
+xfs_hooks_init(
+	struct xfs_hooks	*chain)
+{
+	BLOCKING_INIT_NOTIFIER_HEAD(&chain->head);
+}
+
+/* Make it so a function gets called whenever we hit a certain hook point. */
+int
+xfs_hooks_add(
+	struct xfs_hooks	*chain,
+	struct xfs_hook		*hook)
+{
+	ASSERT(hook->nb.notifier_call != NULL);
+	BUILD_BUG_ON(offsetof(struct xfs_hook, nb) != 0);
+
+	return blocking_notifier_chain_register(&chain->head, &hook->nb);
+}
+
+/* Remove a previously installed hook. */
+void
+xfs_hooks_del(
+	struct xfs_hooks	*chain,
+	struct xfs_hook		*hook)
+{
+	blocking_notifier_chain_unregister(&chain->head, &hook->nb);
+}
+
+/* Call a hook.  Returns the NOTIFY_* value returned by the last hook. */
+int
+xfs_hooks_call(
+	struct xfs_hooks	*chain,
+	unsigned long		val,
+	void			*priv)
+{
+	return blocking_notifier_call_chain(&chain->head, val, priv);
+}
+#endif /* CONFIG_XFS_LIVE_HOOKS_BLOCKING */
diff --git a/fs/xfs/xfs_hooks.h b/fs/xfs/xfs_hooks.h
index 9cd3f6e07751..7e5ef53f5829 100644
--- a/fs/xfs/xfs_hooks.h
+++ b/fs/xfs/xfs_hooks.h
@@ -6,10 +6,14 @@
 #ifndef XFS_HOOKS_H_
 #define XFS_HOOKS_H_
 
-#ifdef CONFIG_XFS_LIVE_HOOKS
+#if defined(CONFIG_XFS_LIVE_HOOKS_SRCU)
 struct xfs_hooks {
 	struct srcu_notifier_head	head;
 };
+#elif defined(CONFIG_XFS_LIVE_HOOKS_BLOCKING)
+struct xfs_hooks {
+	struct blocking_notifier_head	head;
+};
 #else
 struct xfs_hooks { /* empty */ };
 #endif

