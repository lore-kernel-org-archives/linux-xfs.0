Return-Path: <SRS0=m1l6=DW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83ED7C4363A
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 07:22:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E5BF2225F
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 07:22:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728885AbgJOHWK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Oct 2020 03:22:10 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:60707 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726462AbgJOHWJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 03:22:09 -0400
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 15F233AB123
        for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2020 18:21:57 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kSxaG-000hvQ-Iw
        for linux-xfs@vger.kernel.org; Thu, 15 Oct 2020 18:21:56 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1kSxaG-006qLg-B8
        for linux-xfs@vger.kernel.org; Thu, 15 Oct 2020 18:21:56 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 07/27] xfsprogs: introduce liburcu support
Date:   Thu, 15 Oct 2020 18:21:35 +1100
Message-Id: <20201015072155.1631135-8-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201015072155.1631135-1-david@fromorbit.com>
References: <20201015072155.1631135-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=afefHYAZSVUA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=xNf9USuDAAAA:8
        a=HJXtOWahcpWd6xppAhgA:9 a=AjGcO6oz07-iQ99wixmX:22
        a=SEwjQc04WA-l_NiBhQ7s:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The upcoming buffer cache rework/kerenl sync-up requires atomic
variables. I could use C++11 atomics build into GCC, but they are a
pain to work with and shoe-horn into the kernel atomic variable API.

Much easier is to introduce a dependency on liburcu - the userspace
RCU library. This provides atomic variables that very closely match
the kernel atomic variable API, and it provides a very similar
memory model and memory barrier support to the kernel. And we get
RCU support that has an identical interface to the kernel and works
the same way.

Hence kernel code written with RCU algorithms and atomic variables
will just slot straight into the userspace xfsprogs code without us
having to think about whether the lockless algorithms will work in
userspace or not. This reduces glue and hoop jumping, and gets us
a step closer to having the entire userspace libxfs code MT safe.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 configure.ac               |  3 +++
 copy/Makefile              |  3 ++-
 copy/xfs_copy.c            |  3 +++
 db/Makefile                |  3 ++-
 debian/control             |  2 +-
 growfs/Makefile            |  3 ++-
 include/builddefs.in       |  4 +++-
 include/platform_defs.h.in |  1 +
 libfrog/workqueue.c        |  3 +++
 libxfs/init.c              |  3 +++
 libxfs/libxfs_priv.h       |  3 +--
 logprint/Makefile          |  3 ++-
 m4/Makefile                |  1 +
 m4/package_urcu.m4         | 22 ++++++++++++++++++++++
 mdrestore/Makefile         |  3 ++-
 mkfs/Makefile              |  2 +-
 repair/Makefile            |  2 +-
 repair/prefetch.c          |  9 +++++++--
 repair/progress.c          |  4 +++-
 scrub/Makefile             |  3 ++-
 scrub/progress.c           |  2 ++
 21 files changed, 67 insertions(+), 15 deletions(-)
 create mode 100644 m4/package_urcu.m4

diff --git a/configure.ac b/configure.ac
index dc57bbd7cd8c..378622e89232 100644
--- a/configure.ac
+++ b/configure.ac
@@ -154,6 +154,9 @@ AC_PACKAGE_NEED_UUIDCOMPARE
 AC_PACKAGE_NEED_PTHREAD_H
 AC_PACKAGE_NEED_PTHREADMUTEXINIT
 
+AC_PACKAGE_NEED_URCU_H
+AC_PACKAGE_NEED_RCU_INIT
+
 AC_HAVE_FADVISE
 AC_HAVE_MADVISE
 AC_HAVE_MINCORE
diff --git a/copy/Makefile b/copy/Makefile
index 449b235fad40..1b00cd0d5743 100644
--- a/copy/Makefile
+++ b/copy/Makefile
@@ -9,7 +9,8 @@ LTCOMMAND = xfs_copy
 CFILES = xfs_copy.c
 HFILES = xfs_copy.h
 
-LLDLIBS = $(LIBXFS) $(LIBXLOG) $(LIBFROG) $(LIBUUID) $(LIBPTHREAD) $(LIBRT)
+LLDLIBS = $(LIBXFS) $(LIBXLOG) $(LIBFROG) $(LIBUUID) $(LIBPTHREAD) $(LIBRT) \
+	  $(LIBURCU)
 LTDEPENDENCIES = $(LIBXFS) $(LIBXLOG) $(LIBFROG)
 LLDFLAGS = -static-libtool-libs
 
diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index fc7d225fe6a2..f5eff96976d7 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -110,6 +110,7 @@ do_message(int flags, int code, const char *fmt, ...)
 		fprintf(stderr,
 			_("Aborting XFS copy -- logfile error -- reason: %s\n"),
 			strerror(errno));
+		rcu_unregister_thread();
 		pthread_exit(NULL);
 	}
 }
@@ -224,6 +225,7 @@ begin_reader(void *arg)
 {
 	thread_args	*args = arg;
 
+	rcu_register_thread();
 	for (;;) {
 		pthread_mutex_lock(&args->wait);
 		if (do_write(args, NULL))
@@ -243,6 +245,7 @@ handle_error:
 	if (--glob_masks.num_working == 0)
 		pthread_mutex_unlock(&mainwait);
 	pthread_mutex_unlock(&glob_masks.mutex);
+	rcu_unregister_thread();
 	pthread_exit(NULL);
 	return NULL;
 }
diff --git a/db/Makefile b/db/Makefile
index 9bd9bf514f5d..4e44adc03577 100644
--- a/db/Makefile
+++ b/db/Makefile
@@ -17,7 +17,8 @@ HFILES = addr.h agf.h agfl.h agi.h attr.h attrshort.h bit.h block.h bmap.h \
 CFILES = $(HFILES:.h=.c) btdump.c btheight.c convert.c info.c
 LSRCFILES = xfs_admin.sh xfs_ncheck.sh xfs_metadump.sh
 
-LLDLIBS	= $(LIBXFS) $(LIBXLOG) $(LIBFROG) $(LIBUUID) $(LIBRT) $(LIBPTHREAD)
+LLDLIBS	= $(LIBXFS) $(LIBXLOG) $(LIBFROG) $(LIBUUID) $(LIBRT) $(LIBPTHREAD) \
+	  $(LIBURCU)
 LTDEPENDENCIES = $(LIBXFS) $(LIBXLOG) $(LIBFROG)
 LLDFLAGS += -static-libtool-libs
 
diff --git a/debian/control b/debian/control
index ddd17850e378..2a97fa633a1b 100644
--- a/debian/control
+++ b/debian/control
@@ -3,7 +3,7 @@ Section: admin
 Priority: optional
 Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
 Uploaders: Nathan Scott <nathans@debian.org>, Anibal Monsalve Salazar <anibal@debian.org>
-Build-Depends: uuid-dev, dh-autoreconf, debhelper (>= 5), gettext, libtool, libedit-dev, libblkid-dev (>= 2.17), linux-libc-dev, libdevmapper-dev, libattr1-dev, libicu-dev, dh-python, pkg-config
+Build-Depends: uuid-dev, dh-autoreconf, debhelper (>= 5), gettext, libtool, libedit-dev, libblkid-dev (>= 2.17), linux-libc-dev, libdevmapper-dev, libattr1-dev, libicu-dev, dh-python, pkg-config, liburcu-dev
 Standards-Version: 4.0.0
 Homepage: https://xfs.wiki.kernel.org/
 
diff --git a/growfs/Makefile b/growfs/Makefile
index a107d348ab6d..08601de77ab3 100644
--- a/growfs/Makefile
+++ b/growfs/Makefile
@@ -9,7 +9,8 @@ LTCOMMAND = xfs_growfs
 
 CFILES = xfs_growfs.c
 
-LLDLIBS = $(LIBXFS) $(LIBXCMD) $(LIBFROG) $(LIBUUID) $(LIBRT) $(LIBPTHREAD)
+LLDLIBS = $(LIBXFS) $(LIBXCMD) $(LIBFROG) $(LIBUUID) $(LIBRT) $(LIBPTHREAD) \
+	  $(LIBURCU)
 
 ifeq ($(ENABLE_EDITLINE),yes)
 LLDLIBS += $(LIBEDITLINE) $(LIBTERMCAP)
diff --git a/include/builddefs.in b/include/builddefs.in
index e8f447f92baf..78eddf4a9852 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -22,6 +22,7 @@ LDFLAGS =
 
 LIBRT = @librt@
 LIBUUID = @libuuid@
+LIBURCU = @liburcu@
 LIBPTHREAD = @libpthread@
 LIBTERMCAP = @libtermcap@
 LIBEDITLINE = @libeditline@
@@ -125,7 +126,8 @@ CROND_DIR = @crond_dir@
 GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall
 #	   -Wbitwise -Wno-transparent-union -Wno-old-initializer -Wno-decl
 
-PCFLAGS = -D_GNU_SOURCE $(GCCFLAGS)
+# _LGPL_SOURCE is for liburcu to work correctly with GPL/LGPL programs
+PCFLAGS = -D_LGPL_SOURCE -D_GNU_SOURCE $(GCCFLAGS)
 ifeq ($(HAVE_UMODE_T),yes)
 PCFLAGS += -DHAVE_UMODE_T
 endif
diff --git a/include/platform_defs.h.in b/include/platform_defs.h.in
index 1f7ceafb1fbc..8af43f3b8d8a 100644
--- a/include/platform_defs.h.in
+++ b/include/platform_defs.h.in
@@ -23,6 +23,7 @@
 #include <limits.h>
 #include <stdbool.h>
 #include <libgen.h>
+#include <urcu.h>
 
 typedef struct filldir		filldir_t;
 
diff --git a/libfrog/workqueue.c b/libfrog/workqueue.c
index fe3de4289379..cd232d9bddc0 100644
--- a/libfrog/workqueue.c
+++ b/libfrog/workqueue.c
@@ -11,6 +11,7 @@
 #include <stdbool.h>
 #include <errno.h>
 #include <assert.h>
+#include <urcu.h>
 #include "workqueue.h"
 
 /* Main processing thread */
@@ -24,6 +25,7 @@ workqueue_thread(void *arg)
 	 * Loop pulling work from the passed in work queue.
 	 * Check for notification to exit after every chunk of work.
 	 */
+	rcu_register_thread();
 	while (1) {
 		pthread_mutex_lock(&wq->lock);
 
@@ -52,6 +54,7 @@ workqueue_thread(void *arg)
 		(wi->function)(wi->queue, wi->index, wi->arg);
 		free(wi);
 	}
+	rcu_unregister_thread();
 
 	return NULL;
 }
diff --git a/libxfs/init.c b/libxfs/init.c
index 4dab7d25727e..477487e985c4 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -310,6 +310,8 @@ libxfs_init(libxfs_init_t *a)
 	fd = -1;
 	flags = (a->isreadonly | a->isdirect);
 
+	rcu_init();
+	rcu_register_thread();
 	radix_tree_init();
 
 	if (a->volname) {
@@ -957,6 +959,7 @@ libxfs_destroy(
 	libxfs_bcache_free();
 	cache_destroy(libxfs_bcache);
 	leaked = destroy_zones();
+	rcu_unregister_thread();
 	if (getenv("LIBXFS_LEAK_CHECK") && leaked)
 		exit(1);
 }
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index b88939c04adb..4cce1d680921 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -194,8 +194,7 @@ enum ce { CE_DEBUG, CE_CONT, CE_NOTE, CE_WARN, CE_ALERT, CE_PANIC };
 #define spin_unlock(a)		((void) 0)
 #define likely(x)		(x)
 #define unlikely(x)		(x)
-#define rcu_read_lock()		((void) 0)
-#define rcu_read_unlock()	((void) 0)
+
 /* Need to be able to handle this bare or in control flow */
 static inline bool WARN_ON(bool expr) {
 	return (expr);
diff --git a/logprint/Makefile b/logprint/Makefile
index 758504b39f0f..cdedbd0dbe82 100644
--- a/logprint/Makefile
+++ b/logprint/Makefile
@@ -12,7 +12,8 @@ CFILES = logprint.c \
 	 log_copy.c log_dump.c log_misc.c \
 	 log_print_all.c log_print_trans.c log_redo.c
 
-LLDLIBS	= $(LIBXFS) $(LIBXLOG) $(LIBFROG) $(LIBUUID) $(LIBRT) $(LIBPTHREAD)
+LLDLIBS	= $(LIBXFS) $(LIBXLOG) $(LIBFROG) $(LIBUUID) $(LIBRT) $(LIBPTHREAD) \
+	  $(LIBURCU)
 LTDEPENDENCIES = $(LIBXFS) $(LIBXLOG) $(LIBFROG)
 LLDFLAGS = -static-libtool-libs
 
diff --git a/m4/Makefile b/m4/Makefile
index c6c73dc9bbee..7312053039f4 100644
--- a/m4/Makefile
+++ b/m4/Makefile
@@ -24,6 +24,7 @@ LSRCFILES = \
 	package_services.m4 \
 	package_types.m4 \
 	package_icu.m4 \
+	package_urcu.m4 \
 	package_utilies.m4 \
 	package_uuiddev.m4 \
 	multilib.m4 \
diff --git a/m4/package_urcu.m4 b/m4/package_urcu.m4
new file mode 100644
index 000000000000..9b0dee35d9a1
--- /dev/null
+++ b/m4/package_urcu.m4
@@ -0,0 +1,22 @@
+AC_DEFUN([AC_PACKAGE_NEED_URCU_H],
+  [ AC_CHECK_HEADERS(urcu.h)
+    if test $ac_cv_header_urcu_h = no; then
+	AC_CHECK_HEADERS(urcu.h,, [
+	echo
+	echo 'FATAL ERROR: could not find a valid urcu header.'
+	exit 1])
+    fi
+  ])
+
+AC_DEFUN([AC_PACKAGE_NEED_RCU_INIT],
+  [ AC_MSG_CHECKING([for liburcu])
+    AC_TRY_COMPILE([
+#define _GNU_SOURCE
+#include <urcu.h>
+    ], [
+	rcu_init();
+    ],	liburcu=-lurcu
+	AC_MSG_RESULT(yes),
+	AC_MSG_RESULT(no))
+    AC_SUBST(liburcu)
+  ])
diff --git a/mdrestore/Makefile b/mdrestore/Makefile
index d946955b0517..8f28ddab326b 100644
--- a/mdrestore/Makefile
+++ b/mdrestore/Makefile
@@ -8,7 +8,8 @@ include $(TOPDIR)/include/builddefs
 LTCOMMAND = xfs_mdrestore
 CFILES = xfs_mdrestore.c
 
-LLDLIBS = $(LIBXFS) $(LIBFROG) $(LIBRT) $(LIBPTHREAD) $(LIBUUID)
+LLDLIBS = $(LIBXFS) $(LIBFROG) $(LIBRT) $(LIBPTHREAD) $(LIBUUID) \
+	  $(LIBURCU)
 LTDEPENDENCIES = $(LIBXFS) $(LIBFROG)
 LLDFLAGS = -static
 
diff --git a/mkfs/Makefile b/mkfs/Makefile
index b8805f7e1ea1..811ba9dbe29b 100644
--- a/mkfs/Makefile
+++ b/mkfs/Makefile
@@ -11,7 +11,7 @@ HFILES =
 CFILES = proto.c xfs_mkfs.c
 
 LLDLIBS += $(LIBXFS) $(LIBXCMD) $(LIBFROG) $(LIBRT) $(LIBPTHREAD) $(LIBBLKID) \
-	$(LIBUUID) $(LIBINIH)
+	$(LIBUUID) $(LIBINIH) $(LIBURCU)
 LTDEPENDENCIES += $(LIBXFS) $(LIBXCMD) $(LIBFROG)
 LLDFLAGS = -static-libtool-libs
 
diff --git a/repair/Makefile b/repair/Makefile
index 5f0764d1c3cd..47536ca1cc11 100644
--- a/repair/Makefile
+++ b/repair/Makefile
@@ -72,7 +72,7 @@ CFILES = \
 	xfs_repair.c
 
 LLDLIBS = $(LIBXFS) $(LIBXLOG) $(LIBXCMD) $(LIBFROG) $(LIBUUID) $(LIBRT) \
-	$(LIBPTHREAD) $(LIBBLKID)
+	$(LIBPTHREAD) $(LIBBLKID) $(LIBURCU)
 LTDEPENDENCIES = $(LIBXFS) $(LIBXLOG) $(LIBXCMD) $(LIBFROG)
 LLDFLAGS = -static-libtool-libs
 
diff --git a/repair/prefetch.c b/repair/prefetch.c
index 48affa1869f8..22a0c0c902d9 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -660,6 +660,7 @@ pf_io_worker(
 	if (buf == NULL)
 		return NULL;
 
+	rcu_register_thread();
 	pthread_mutex_lock(&args->lock);
 	while (!args->queuing_done || !btree_is_empty(args->io_queue)) {
 		pftrace("waiting to start prefetch I/O for AG %d", args->agno);
@@ -682,6 +683,7 @@ pf_io_worker(
 	free(buf);
 
 	pftrace("finished prefetch I/O for AG %d", args->agno);
+	rcu_unregister_thread();
 
 	return NULL;
 }
@@ -726,6 +728,8 @@ pf_queuing_worker(
 	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
 	unsigned long long	cluster_mask;
 
+	rcu_register_thread();
+
 	cluster_mask = (1ULL << igeo->inodes_per_cluster) - 1;
 
 	for (i = 0; i < PF_THREAD_COUNT; i++) {
@@ -739,7 +743,7 @@ pf_queuing_worker(
 			args->io_threads[i] = 0;
 			if (i == 0) {
 				pf_skip_prefetch_thread(args);
-				return NULL;
+				goto out;
 			}
 			/*
 			 * since we have at least one I/O thread, use them for
@@ -779,7 +783,6 @@ pf_queuing_worker(
 			 * Start processing as well, in case everything so
 			 * far was already prefetched and the queue is empty.
 			 */
-			
 			pf_start_io_workers(args);
 			pf_start_processing(args);
 			sem_wait(&args->ra_count);
@@ -841,6 +844,8 @@ pf_queuing_worker(
 	if (next_args)
 		pf_create_prefetch_thread(next_args);
 
+out:
+	rcu_unregister_thread();
 	return NULL;
 }
 
diff --git a/repair/progress.c b/repair/progress.c
index e5a9c1efa822..f6c4d988444e 100644
--- a/repair/progress.c
+++ b/repair/progress.c
@@ -182,6 +182,7 @@ progress_rpt_thread (void *p)
 		do_error (_("progress_rpt: cannot malloc progress msg buffer\n"));
 
 	running = 1;
+	rcu_register_thread();
 
 	/*
 	 * Specify a repeating timer that fires each MSG_INTERVAL seconds.
@@ -286,7 +287,8 @@ progress_rpt_thread (void *p)
 		do_warn(_("cannot delete timer\n"));
 
 	free (msgbuf);
-	return (NULL);
+	rcu_unregister_thread();
+	return NULL;
 }
 
 int
diff --git a/scrub/Makefile b/scrub/Makefile
index 47c887eb79a1..849e3afd5af3 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -71,7 +71,8 @@ spacemap.c \
 vfs.c \
 xfs_scrub.c
 
-LLDLIBS += $(LIBHANDLE) $(LIBFROG) $(LIBPTHREAD) $(LIBICU_LIBS) $(LIBRT)
+LLDLIBS += $(LIBHANDLE) $(LIBFROG) $(LIBPTHREAD) $(LIBICU_LIBS) $(LIBRT) \
+	$(LIBURCU)
 LTDEPENDENCIES += $(LIBHANDLE) $(LIBFROG)
 LLDFLAGS = -static
 
diff --git a/scrub/progress.c b/scrub/progress.c
index d8130ca5f93c..4a66fb0d5cfb 100644
--- a/scrub/progress.c
+++ b/scrub/progress.c
@@ -117,6 +117,7 @@ progress_report_thread(void *arg)
 	struct timespec		abstime;
 	int			ret;
 
+	rcu_register_thread();
 	pthread_mutex_lock(&pt.lock);
 	while (1) {
 		uint64_t	progress_val;
@@ -140,6 +141,7 @@ progress_report_thread(void *arg)
 			progress_report(progress_val);
 	}
 	pthread_mutex_unlock(&pt.lock);
+	rcu_unregister_thread();
 	return NULL;
 }
 
-- 
2.28.0

