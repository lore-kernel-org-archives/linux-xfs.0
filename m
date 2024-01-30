Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 252E8376F4
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 05:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706591057; cv=none; b=bNardaclWqdMGgOPVLIwQAe4cbSWllaH7XldFmWnC4e5enFxXKSxrSnzKVAgTCFbjmZLMxFbgZArzoZj4Zqr2mHyJDEBsR8bfbiufvDPLtFoFj+CEO5pAocOY8NWgR1VUete6f4nRt8p5k9JoyhHwRHJJPlF7Q4EROkqvS40i2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706591057; c=relaxed/simple;
	bh=DmIw+b3GtudtxRdkFD7wAj3mYConXS4CB31NEuIATOA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=axlQpm1HzD+FQbv4MlwzzKa3VbCmN0kiAVBukU4AM2LGvr/cW2TesvlPNX0SV57D2LIh1CZO7eWqFTr8GG8/bWsoXdE68ziT6sOGOHu1zFBqT9EQqA6aFA4mg0LD2OCt4SEJ7huGWHxrQ06BwNvtwGXjCp0DZMhNDQ1FN/lsnyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z12LQOjr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z12LQOjr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6658C433C7;
	Tue, 30 Jan 2024 05:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706591057;
	bh=DmIw+b3GtudtxRdkFD7wAj3mYConXS4CB31NEuIATOA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Z12LQOjrCjMI8TMS20UInDZEYtTIvW2K6c2HGrsmK+eNlpQfYMwQMVGIDaTKlsPje
	 dVOq/ETl67eq68Mk0X+CZOoEd4TgOMVNOTxrEgWWNxmup2G0DEACyYtpKoJzrBpWkM
	 5hBidkp115xeHxgUIMowP1ZYPMnBmB19r8cBPT1hgwYX/9KTzTLkqbvBKrvwmpPURE
	 DtS2zRs3xv82TLmwcbMBTB0d084pvMKQpaXC9KbPqcP8qCCOPNmDnV7ewum2hhzmcv
	 o8jzeMzKCnaJabMBLIU+3qsmaSUR69mzZ8W/BDirN5N7X1pKyCuunpafBp2hWXvAzl
	 aL99UWWXzv/HA==
Date: Mon, 29 Jan 2024 21:04:16 -0800
Subject: [PATCH 3/6] xfs: allow scrub to hook metadata updates in other
 writers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <170659061886.3353019.596403778386618930.stgit@frogsfrogsfrogs>
In-Reply-To: <170659061824.3353019.15854398821862048839.stgit@frogsfrogsfrogs>
References: <170659061824.3353019.15854398821862048839.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

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

Originally, I selected srcu notifiers over blocking notifiers to
implement live hooks because they seemed to have fewer impacts to
scalability.  The per-call cost of srcu_notifier_call_chain is higher
(19ns) than blocking_notifier_ (4ns) in the single threaded case, but
blocking notifiers use an rwsem to stabilize the list.  Cacheline
bouncing for that rwsem is costly to runtime code when there are a lot
of CPUs running regular filesystem operations.  If there are no hooks
installed, this is a total waste of CPU time.

Therefore, I stuck with srcu notifiers, despite trading off single
threaded performance for multithreaded performance.  I also wasn't
thrilled with the very high teardown time for srcu notifiers, since the
caller has to wait for the next rcu grace period.  This can take a long
time if there are a lot of CPUs.

Then I discovered the jump label implementation of static keys.

Jump labels use kernel code patching to replace a branch with a nop sled
when the key is disabled.  IOWs, they can eliminate the overhead of
_call_chain when there are no hooks enabled.  This makes blocking
notifiers competitive again -- scrub runs faster because teardown of the
chain is a lot cheaper, and runtime code only pays the rwsem locking
overhead when scrub is actually running.

With jump labels enabled, calls to empty notifier chains are elided from
the call sites when there are no hooks registered, which means that the
overhead is 0.36ns when fsck is not running.  This is perfect for most
of the architectures that XFS is expected to run on (e.g. x86, powerpc,
arm64, s390x, riscv).

For architectures that don't support jump labels (e.g. m68k) the runtime
overhead of checking the static key is an atomic counter read.  This
isn't great, but it's still cheaper than taking a shared rwsem.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Kconfig     |    5 ++++
 fs/xfs/Makefile    |    1 +
 fs/xfs/xfs_hooks.c |   52 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_hooks.h |   65 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_linux.h |    1 +
 5 files changed, 124 insertions(+)
 create mode 100644 fs/xfs/xfs_hooks.c
 create mode 100644 fs/xfs/xfs_hooks.h


diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
index 567fb37274d35..fa7eb3e2a2484 100644
--- a/fs/xfs/Kconfig
+++ b/fs/xfs/Kconfig
@@ -124,11 +124,16 @@ config XFS_DRAIN_INTENTS
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
+	select XFS_LIVE_HOOKS
 	select XFS_DRAIN_INTENTS
 	help
 	  If you say Y here you will be able to check metadata on a
diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index e5990a392ad62..7a5c637e449e5 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -137,6 +137,7 @@ xfs-$(CONFIG_FS_DAX)		+= xfs_notify_failure.o
 endif
 
 xfs-$(CONFIG_XFS_DRAIN_INTENTS)	+= xfs_drain.o
+xfs-$(CONFIG_XFS_LIVE_HOOKS)	+= xfs_hooks.o
 
 # online scrub/repair
 ifeq ($(CONFIG_XFS_ONLINE_SCRUB),y)
diff --git a/fs/xfs/xfs_hooks.c b/fs/xfs/xfs_hooks.c
new file mode 100644
index 0000000000000..a58d1de2d37da
--- /dev/null
+++ b/fs/xfs/xfs_hooks.c
@@ -0,0 +1,52 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
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
diff --git a/fs/xfs/xfs_hooks.h b/fs/xfs/xfs_hooks.h
new file mode 100644
index 0000000000000..60b8a58315369
--- /dev/null
+++ b/fs/xfs/xfs_hooks.h
@@ -0,0 +1,65 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef XFS_HOOKS_H_
+#define XFS_HOOKS_H_
+
+#ifdef CONFIG_XFS_LIVE_HOOKS
+struct xfs_hooks {
+	struct blocking_notifier_head	head;
+};
+
+/*
+ * If jump labels are enabled in Kconfig, the static key uses nop sleds and
+ * code patching to eliminate the overhead of taking the rwsem in
+ * blocking_notifier_call_chain when there are no hooks configured.  If not,
+ * the static key per-call overhead is an atomic read.  Most arches that can
+ * handle XFS also support jump labels.
+ *
+ * Note: Patching the kernel code requires taking the cpu hotplug lock.  Other
+ * parts of the kernel allocate memory with that lock held, which means that
+ * XFS callers cannot hold any locks that might be used by memory reclaim or
+ * writeback when calling the static_branch_{inc,dec} functions.
+ */
+# define DEFINE_STATIC_XFS_HOOK_SWITCH(name) \
+	static DEFINE_STATIC_KEY_FALSE(name)
+# define xfs_hooks_switch_on(name)	static_branch_inc(name)
+# define xfs_hooks_switch_off(name)	static_branch_dec(name)
+# define xfs_hooks_switched_on(name)	static_branch_unlikely(name)
+
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
+
+struct xfs_hooks { /* empty */ };
+
+# define DEFINE_STATIC_XFS_HOOK_SWITCH(name)
+# define xfs_hooks_switch_on(name)		((void)0)
+# define xfs_hooks_switch_off(name)		((void)0)
+# define xfs_hooks_switched_on(name)		(false)
+
+# define xfs_hooks_init(chain)			((void)0)
+# define xfs_hooks_call(chain, val, priv)	(NOTIFY_DONE)
+#endif
+
+#endif /* XFS_HOOKS_H_ */
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index d7873e0360f0b..73854ad981eb5 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -82,6 +82,7 @@ typedef __u32			xfs_nlink_t;
 #include "xfs_buf.h"
 #include "xfs_message.h"
 #include "xfs_drain.h"
+#include "xfs_hooks.h"
 
 #ifdef __BIG_ENDIAN
 #define XFS_NATIVE_HOST 1

