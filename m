Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77E45C61DA4
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:45:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbjBPUpN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:45:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBPUpM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:45:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D594C4ECEF
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:45:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 71E6E60A65
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:45:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D753BC433D2;
        Thu, 16 Feb 2023 20:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676580309;
        bh=kDzVmd+hFK73SN1uncK16M145pFBfbcH42bKLm6QTd4=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=j0/yfnQF5PRksyCgf41Qc2RQ3mbNZxUR1HNp7tSchQOyl0cHnHloLqtZT+GBMmfgd
         pXY2WxaBYEQHvTT2e0NWKLH1X6fyJWg7vP8c2wrlx0wn28+PlHO65YEnAdI2CxEg42
         fBxVSARoskpl0Nqr5I4gK6ut7qoZiW4YFKFyAPLqbZ2AwDJnrJNma2TVI9h1lj4Kh5
         blLo9dAsfW4RduQfFZupz72OSaFyTtVHw4jAhWf+XThv0I2gHaTCTytFLq5xTV5UMe
         0zvvuGnjHd0haB13ov3UgnFFLfI6Oe7eSSWsvTKH1zFiEIXy7kV8qpnoj8A3y7ZLb0
         m59jPQRy/Qv4g==
Date:   Thu, 16 Feb 2023 12:45:09 -0800
Subject: [PATCH 13/23] xfs: allow scrub to hook metadata updates in other
 writers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657874021.3474338.5882984305089454964.stgit@magnolia>
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
 fs/xfs/Makefile    |    2 ++
 fs/xfs/xfs_hooks.c |   53 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_hooks.h |   68 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_linux.h |    1 +
 5 files changed, 130 insertions(+)
 create mode 100644 fs/xfs/xfs_hooks.c
 create mode 100644 fs/xfs/xfs_hooks.h


diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
index 7f12b40146b3..e99821c4c337 100644
--- a/fs/xfs/Kconfig
+++ b/fs/xfs/Kconfig
@@ -92,12 +92,18 @@ config XFS_RT
 	  See the xfs man page in section 5 for additional information.
 
 	  If unsure, say N.
+ 
+config XFS_LIVE_HOOKS
+	bool
+	select JUMP_LABEL if HAVE_ARCH_JUMP_LABEL
 
 config XFS_ONLINE_SCRUB
 	bool "XFS online metadata check support"
 	default n
 	depends on XFS_FS
 	depends on TMPFS && SHMEM
+	depends on SRCU
+	select XFS_LIVE_HOOKS
 	help
 	  If you say Y here you will be able to check metadata on a
 	  mounted XFS filesystem.  This feature is intended to reduce
diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 69805b4ad79f..64a3cc396e16 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -137,6 +137,8 @@ ifeq ($(CONFIG_MEMORY_FAILURE),y)
 xfs-$(CONFIG_FS_DAX)		+= xfs_notify_failure.o
 endif
 
+xfs-$(CONFIG_XFS_LIVE_HOOKS)	+= xfs_hooks.o
+
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
index 000000000000..8dd5baffb84a
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
+static inline void xfs_hook_setup(struct xfs_hook *hook, notifier_fn_t fn)
+{
+	hook->nb.notifier_call = fn;
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
index f9878021e7d0..c05f7e309c3e 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -79,6 +79,7 @@ typedef __u32			xfs_nlink_t;
 #include "xfs_cksum.h"
 #include "xfs_buf.h"
 #include "xfs_message.h"
+#include "xfs_hooks.h"
 
 #ifdef __BIG_ENDIAN
 #define XFS_NATIVE_HOST 1

