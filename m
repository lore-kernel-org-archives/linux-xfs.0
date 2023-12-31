Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37F8FB675
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FjZqrlbR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB9B2C433C8;
	Sun, 31 Dec 2023 20:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704053129;
	bh=sPKWROwCgArMvY8nzg2ncJ2aK9uRJtvzafQz8CTLrJY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=FjZqrlbRSEcBiy/PFlT9W7he2MbozHTWtNXYMs+307ICWEPWjQqTQ6bkKl2Zx2+Pv
	 IMENGPk2eNYVkvkk23Orm6g3rqvKjY20F45RdbKrnLq1FDvpGeUIsgvj7J6EPFmI7Q
	 T6maomCs9p33eUSaKV0GtodF4u5VyRpgU4zsSzOdMxmKpgz/yPmC9Enjdw44syKlra
	 nhHp7yHbZIX7AL96X9IB5v3AS6varWSGPiqXOmqZMOINXzMkKP6CZSIlBlE7Tobqge
	 w9jZFagkkg5SgY7IJ4ZWXTmE0lVqDi6KS2wvUfddBgQ3l6RiMFDDDdwoXjl1JTAyPk
	 ZxTWc9QLoHAkA==
Date: Sun, 31 Dec 2023 12:05:29 -0800
Subject: [PATCH 4/7] xfs: allow blocking notifier chains with filesystem hooks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404826571.1747630.2096311818934079737.stgit@frogsfrogsfrogs>
In-Reply-To: <170404826492.1747630.1053076578437373265.stgit@frogsfrogsfrogs>
References: <170404826492.1747630.1053076578437373265.stgit@frogsfrogsfrogs>
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

Make it so that we can switch between notifier chain implementations for
testing purposes.  On the author's test system, calling an empty srcu
notifier chain cost about 19ns per call, vs. 4ns for a blocking notifier
chain.  Hm.  Might we actually want regular blocking notifiers?

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Kconfig     |   31 +++++++++++++++++++++++++++++++
 fs/xfs/xfs_hooks.c |   41 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_hooks.h |    6 +++++-
 3 files changed, 77 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
index fa7eb3e2a2484..dbcf55377e9fe 100644
--- a/fs/xfs/Kconfig
+++ b/fs/xfs/Kconfig
@@ -165,6 +165,37 @@ config XFS_ONLINE_SCRUB_STATS
 
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
index 757aadc90eb03..8f7e449442972 100644
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
index f3d0631147f28..751f348a8cc0f 100644
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

