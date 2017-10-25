Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from LGEAMRELO11.lge.com ([156.147.23.51]:41933 "EHLO
        lgeamrelo11.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932453AbdJYI4d (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Oct 2017 04:56:33 -0400
From: Byungchul Park <byungchul.park@lge.com>
Subject: [PATCH v5 6/9] locking/lockdep: Introduce CONFIG_BOOTPARAM_LOCKDEP_CROSSRELEASE_FULLSTACK
Date: Wed, 25 Oct 2017 17:56:02 +0900
Message-Id: <1508921765-15396-7-git-send-email-byungchul.park@lge.com>
In-Reply-To: <1508921765-15396-1-git-send-email-byungchul.park@lge.com>
References: <1508921765-15396-1-git-send-email-byungchul.park@lge.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: peterz@infradead.org, mingo@kernel.org, axboe@kernel.dk
Cc: johan@kernel.org, tglx@linutronix.de, linux-kernel@vger.kernel.org, linux-mm@kvack.org, tj@kernel.org, johannes.berg@intel.com, oleg@redhat.com, amir73il@gmail.com, david@fromorbit.com, darrick.wong@oracle.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, hch@infradead.org, idryomov@gmail.com, kernel-team@lge.com

The boot parameter, crossrelease_fullstack, was introduced to control
whether to enable unwind in cross-release or not. Add a Kconfig doing
the same thing.

Suggested-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Byungchul Park <byungchul.park@lge.com>
---
 kernel/locking/lockdep.c |  4 ++++
 lib/Kconfig.debug        | 15 +++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index 160b5d6..db933d0 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -76,7 +76,11 @@
 #define lock_stat 0
 #endif
 
+#ifdef CONFIG_BOOTPARAM_LOCKDEP_CROSSRELEASE_FULLSTACK
+static int crossrelease_fullstack = 1;
+#else
 static int crossrelease_fullstack;
+#endif
 static int __init allow_crossrelease_fullstack(char *str)
 {
 	crossrelease_fullstack = 1;
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 4bef610..e4b54a5 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1225,6 +1225,21 @@ config LOCKDEP_COMPLETIONS
 	 A deadlock caused by wait_for_completion() and complete() can be
 	 detected by lockdep using crossrelease feature.
 
+config BOOTPARAM_LOCKDEP_CROSSRELEASE_FULLSTACK
+	bool "Enable the boot parameter, crossrelease_fullstack"
+	depends on LOCKDEP_CROSSRELEASE
+	default n
+	help
+	 The lockdep "cross-release" feature needs to record stack traces
+	 (of calling functions) for all acquisitions, for eventual later
+	 use during analysis. By default only a single caller is recorded,
+	 because the unwind operation can be very expensive with deeper
+	 stack chains.
+
+	 However a boot parameter, crossrelease_fullstack, was
+	 introduced since sometimes deeper traces are required for full
+	 analysis. This option turns on the boot parameter.
+
 config DEBUG_LOCKDEP
 	bool "Lock dependency engine debugging"
 	depends on DEBUG_KERNEL && LOCKDEP
-- 
1.9.1

