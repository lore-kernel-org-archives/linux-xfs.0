Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA51FC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:33:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235506AbiL3Xdy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:33:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235488AbiL3Xdx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:33:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FB7912D20
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:33:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B30E461C2C
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:33:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26BD0C433EF;
        Fri, 30 Dec 2022 23:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672443229;
        bh=+pLtnewfx/JzyjwLhsiHVXSxm97mvkJ8PG4VJLCaGWs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ROvGZMERtfDwO2LkFxbe3qNjbWmlEvUsgvBzLhP6RwyZavPlwg2ETENxsCwX2FRJe
         IYuOoGopxjvycxA10Y1NqYzErhaRHZaVP+aQi8aZArW0D+N/Li9qKsQ5Cgz81FYbXJ
         3uRDW0WEAFLT78k3k55jBJ6fxiQ5LfYEBsAcDLsFgfj+N0gsa8lxhKQH6GGBz+N4q2
         /BiCcS/bNVhhyyfIooupKFdkryXezoN2BWP1mSLcRu9vSxnZBCWUa8e1D8R7cqesyk
         VVMiI+preeBADK018GE7i3hQRBitskRZGnf1lomE165ED/0SABtcrhZlr8jtleQCds
         JIy4TdxzRhOqA==
Subject: [PATCH 3/4] xfs: allow scrub to hook metadata updates in other
 writers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:13:03 -0800
Message-ID: <167243838376.695519.14503514599358219813.stgit@magnolia>
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

Certain types of filesystem metadata can only be checked by scanning
every file in the entire filesystem.  Specific examples of this include
quota counts, file link counts, and reverse mappings of file extents.
Directory and parent pointer reconstruction may also fall into this
category.  File scanning is much trickier than scanning AG metadata
because we have to take inode locks in the same order as the rest of
[VX]FS, we can't be holding buffer locks when we do that, and scanning
the whole filesystem takes time.

Earlier versions of the online repair patchset relied heavily on
fsfreeze as a means to quiesce the filesystem so that we could take
locks in the proper order without worrying about concurrent updates from
other writers.  Reviewers of those patches opined that freezing the
entire fs to check and repair something was not sufficiently better than
unmounting to run fsck offline.  I don't agree with that 100%, but the
message was clear: find a way to repair things that minimizes the
quiet period where nobody can write to the filesystem.

Generally, building btree indexes online can be split into two phases: a
collection phase where we compute the records that will be put into the
new btree; and a construction phase, where we construct the physical
btree blocks and persist them.  While it's simple to hold resource locks
for the entirety of the two phases to ensure that the new index is
consistent with the rest of the system, we don't need to hold resource
locks during the collection phase if we have a means to receive live
updates of other work going on elsewhere in the system.

The goal of this patch, then, is to enable online fsck to learn about
metadata updates going on in other threads while it constructs a shadow
copy of the metadata records to verify or correct the real metadata.  To
minimize the overhead when online fsck isn't running, we use srcu
notifiers because they prioritize fast access to the notifier call chain
(particularly when the chain is empty) at a cost to configuring
notifiers.  Online fsck should be relatively infrequent, so this is
acceptable.

The intended usage model is fairly simple.  Code that modifies a
metadata structure of interest should declare a xfs_hook_chain structure
in some well defined place, and call xfs_hook_call whenever an update
happens.  Online fsck code should define a struct notifier_block and use
xfs_hook_add to attach the block to the chain, along with a function to
be called.  This function should synchronize with the fsck scanner to
update whatever in-memory data the scanner is collecting.  When
finished, xfs_hook_del removes the notifier from the list and waits for
them all to complete.

On the author's computer, calling an empty srcu notifier chain was
observed to have an overhead averaging ~40ns with a maximum of 60ns.
Adding a no-op notifier function increased the average to ~58ns and
66ns.  When the quotacheck live update notifier is attached, the average
increases to ~322ns with a max of 372ns to update scrub's in-memory
observation data, assuming no lock contention.

With jump labels enabled, calls to empty srcu notifier chains are elided
from the call sites when there are no hooks registered, which means that
the overhead is 0.36ns when fsck is not running.  For compilers that do
not support jump labels (all major architectures do), the overhead of a
no-op notifier call is less bad (on a many-cpu system) than the atomic
counter ops, so we make the hook switch itself a nop.

Note: This new code is also split out as a separate patch from its
initial user so that the author can move patches around his tree with
ease.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Kconfig     |    6 +++++
 fs/xfs/Makefile    |    1 +
 fs/xfs/xfs_hooks.c |   53 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_hooks.h |   68 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_linux.h |    1 +
 5 files changed, 129 insertions(+)
 create mode 100644 fs/xfs/xfs_hooks.c
 create mode 100644 fs/xfs/xfs_hooks.h


diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
index 6077ac04c0c3..db60944ab3c3 100644
--- a/fs/xfs/Kconfig
+++ b/fs/xfs/Kconfig
@@ -97,11 +97,17 @@ config XFS_DRAIN_INTENTS
 	bool
 	select JUMP_LABEL if HAVE_ARCH_JUMP_LABEL
 
+config XFS_LIVE_HOOKS
+	bool
+	select JUMP_LABEL if HAVE_ARCH_JUMP_LABEL
+
 config XFS_ONLINE_SCRUB
 	bool "XFS online metadata check support"
 	default n
 	depends on XFS_FS
 	depends on TMPFS && SHMEM
+	depends on SRCU
+	select XFS_LIVE_HOOKS
 	select XFS_DRAIN_INTENTS
 	help
 	  If you say Y here you will be able to check metadata on a
diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index a0321f26f06d..76b6095154bf 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -136,6 +136,7 @@ xfs-$(CONFIG_FS_DAX)		+= xfs_notify_failure.o
 endif
 
 xfs-$(CONFIG_XFS_DRAIN_INTENTS)	+= xfs_drain.o
+xfs-$(CONFIG_XFS_LIVE_HOOKS)	+= xfs_hooks.o
 
 # online scrub/repair
 ifeq ($(CONFIG_XFS_ONLINE_SCRUB),y)
diff --git a/fs/xfs/xfs_hooks.c b/fs/xfs/xfs_hooks.c
new file mode 100644
index 000000000000..3f958ece0dc0
--- /dev/null
+++ b/fs/xfs/xfs_hooks.c
@@ -0,0 +1,53 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2022 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_ag.h"
+#include "xfs_trace.h"
+
+/* Initialize a notifier chain. */
+void
+xfs_hooks_init(
+	struct xfs_hooks	*chain)
+{
+	srcu_init_notifier_head(&chain->head);
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
+	return srcu_notifier_chain_register(&chain->head, &hook->nb);
+}
+
+/* Remove a previously installed hook. */
+void
+xfs_hooks_del(
+	struct xfs_hooks	*chain,
+	struct xfs_hook		*hook)
+{
+	srcu_notifier_chain_unregister(&chain->head, &hook->nb);
+	rcu_barrier();
+}
+
+/* Call a hook.  Returns the NOTIFY_* value returned by the last hook. */
+int
+xfs_hooks_call(
+	struct xfs_hooks	*chain,
+	unsigned long		val,
+	void			*priv)
+{
+	return srcu_notifier_call_chain(&chain->head, val, priv);
+}
diff --git a/fs/xfs/xfs_hooks.h b/fs/xfs/xfs_hooks.h
new file mode 100644
index 000000000000..9cd3f6e07751
--- /dev/null
+++ b/fs/xfs/xfs_hooks.h
@@ -0,0 +1,68 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2022 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef XFS_HOOKS_H_
+#define XFS_HOOKS_H_
+
+#ifdef CONFIG_XFS_LIVE_HOOKS
+struct xfs_hooks {
+	struct srcu_notifier_head	head;
+};
+#else
+struct xfs_hooks { /* empty */ };
+#endif
+
+/*
+ * If hooks and jump labels are enabled, we use jump labels (aka patching of
+ * the code segment) to avoid the minute overhead of calling an empty notifier
+ * chain when we know there are no callers.  If hooks are enabled without jump
+ * labels, hardwire the predicate to true because calling an empty srcu
+ * notifier chain isn't so expensive.
+ */
+#if defined(CONFIG_JUMP_LABEL) && defined(CONFIG_XFS_LIVE_HOOKS)
+# define DEFINE_STATIC_XFS_HOOK_SWITCH(name) \
+	static DEFINE_STATIC_KEY_FALSE(name)
+# define xfs_hooks_switch_on(name)	static_branch_inc(name)
+# define xfs_hooks_switch_off(name)	static_branch_dec(name)
+# define xfs_hooks_switched_on(name)	static_branch_unlikely(name)
+#elif defined(CONFIG_XFS_LIVE_HOOKS)
+# define DEFINE_STATIC_XFS_HOOK_SWITCH(name)
+# define xfs_hooks_switch_on(name)	((void)0)
+# define xfs_hooks_switch_off(name)	((void)0)
+# define xfs_hooks_switched_on(name)	(true)
+#else
+# define DEFINE_STATIC_XFS_HOOK_SWITCH(name)
+# define xfs_hooks_switch_on(name)	((void)0)
+# define xfs_hooks_switch_off(name)	((void)0)
+# define xfs_hooks_switched_on(name)	(false)
+#endif /* JUMP_LABEL && XFS_LIVE_HOOKS */
+
+#ifdef CONFIG_XFS_LIVE_HOOKS
+struct xfs_hook {
+	/* This must come at the start of the structure. */
+	struct notifier_block		nb;
+};
+
+typedef	int (*xfs_hook_fn_t)(struct xfs_hook *hook, unsigned long action,
+		void *data);
+
+void xfs_hooks_init(struct xfs_hooks *chain);
+int xfs_hooks_add(struct xfs_hooks *chain, struct xfs_hook *hook);
+void xfs_hooks_del(struct xfs_hooks *chain, struct xfs_hook *hook);
+int xfs_hooks_call(struct xfs_hooks *chain, unsigned long action,
+		void *priv);
+
+static inline void xfs_hook_setup(struct xfs_hook *hook, xfs_hook_fn_t fn)
+{
+	hook->nb.notifier_call = (notifier_fn_t)fn;
+	hook->nb.priority = 0;
+}
+
+#else
+# define xfs_hooks_init(chain)			((void)0)
+# define xfs_hooks_call(chain, val, priv)	(NOTIFY_DONE)
+#endif
+
+#endif /* XFS_HOOKS_H_ */
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index 51e84f824a7c..3847719c3026 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -80,6 +80,7 @@ typedef __u32			xfs_nlink_t;
 #include "xfs_buf.h"
 #include "xfs_message.h"
 #include "xfs_drain.h"
+#include "xfs_hooks.h"
 
 #ifdef __BIG_ENDIAN
 #define XFS_NATIVE_HOST 1

