Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1824C636CC
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:45:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbjBPUp3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:45:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBPUp3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:45:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 150BE4B53D
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:45:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BEC06B82958
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:45:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81C02C433EF;
        Thu, 16 Feb 2023 20:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676580325;
        bh=Sx/tGuB7mCA7xL3iqwTuiZhOmTWRsZKFXm34N1ueAkw=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=gPJuZFC1VqvZQ3sruFWSr44qQ0EZcVNBlIHI4lJrxMywHqxP0xKktL6WY4bFw8L1s
         8hVMQo2waEO3VX8wRdTHIQzqIzyu8R08pqU9SdIgAd1OCjgPOBvddeYGXs6hRDma+w
         O779ZARujEAtn2pDx+CY7bGbuSPPj8lGkcLgMc8dvr67QpbmTSWuf3v2jYnskNgN3V
         EGj/cm0+jP4nLVUs0XP4IT68V3DIEGFmBh9vkH4xtIjMXQ+uH7ZJJfPjnZUHpZl4PK
         7gR6BUewEhDIxdobZs/0VCRUyCzMNdU8JzkZ63DhGfc/6kp/ktHg8iIrzCvirlHaD1
         66GjyICtZv3dA==
Date:   Thu, 16 Feb 2023 12:45:25 -0800
Subject: [PATCH 14/23] xfs: allow blocking notifier chains with filesystem
 hooks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657874035.3474338.7910543175754481486.stgit@magnolia>
In-Reply-To: <167657873813.3474338.3118516275923112371.stgit@magnolia>
References: <167657873813.3474338.3118516275923112371.stgit@magnolia>
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
index e99821c4c337..4798a147fd9e 100644
--- a/fs/xfs/Kconfig
+++ b/fs/xfs/Kconfig
@@ -102,7 +102,6 @@ config XFS_ONLINE_SCRUB
 	default n
 	depends on XFS_FS
 	depends on TMPFS && SHMEM
-	depends on SRCU
 	select XFS_LIVE_HOOKS
 	help
 	  If you say Y here you will be able to check metadata on a
@@ -117,6 +116,38 @@ config XFS_ONLINE_SCRUB
 
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
index 8dd5baffb84a..a63f2276f614 100644
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

