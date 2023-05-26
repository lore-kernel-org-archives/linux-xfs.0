Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C476C7EE2E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 00:57:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbjEZA5G (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 20:57:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbjEZA5F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:57:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE69312E
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:57:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B3B064C1E
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:57:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1B7FC433D2;
        Fri, 26 May 2023 00:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685062623;
        bh=ZRARaHCzQBs0AIxhWO2sstCOHeJ+zU3h+ZmkZbn2dNk=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=l3u7Ua8/ZsJzAknipGqM5W6GO6HKYx5J7eoIr6Zk22kN1G2kJfjO6tRfRF36eydy6
         +6FB78Tn/AREzw/qhRz6g6ewHRequQdOR0UaGhB/gDF9LfkT/1YOaho1+7XX0mMjW8
         PitjwT+XJLUQvwIqqoHxSlVR530YIGPRnTW00SShrXRKUiP2aXNmDXjjZxBVmmmQSa
         52/GBtV+BKhHIaDwiigNW2DARGwNL/jyAotS0/fXxpoOMvhWLD6dKKTDxn8s8CCpic
         RJS0XC0e8sdJqXP/OrOuAvGMcX/NjFkuu0O70134tAl1Z6lp8ncheolK8NROdgPxJx
         W5ClwvnhrtYVw==
Date:   Thu, 25 May 2023 17:57:02 -0700
Subject: [PATCH 4/4] xfs: allow blocking notifier chains with filesystem hooks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506059512.3730949.2335949939380637947.stgit@frogsfrogsfrogs>
In-Reply-To: <168506059451.3730949.8525428478120924050.stgit@frogsfrogsfrogs>
References: <168506059451.3730949.8525428478120924050.stgit@frogsfrogsfrogs>
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
index 41f0ca3b6469..acd56ebe77f9 100644
--- a/fs/xfs/Kconfig
+++ b/fs/xfs/Kconfig
@@ -133,7 +133,6 @@ config XFS_ONLINE_SCRUB
 	default n
 	depends on XFS_FS
 	depends on TMPFS && SHMEM
-	depends on SRCU
 	select XFS_LIVE_HOOKS
 	select XFS_DRAIN_INTENTS
 	help
@@ -149,6 +148,38 @@ config XFS_ONLINE_SCRUB
 
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
index fd0b4ee01309..ee074ae5e68e 100644
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
index a67ae36525b5..c7ad821f5f9f 100644
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

