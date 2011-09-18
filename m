Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8IEtLEb182410 for <xfs@oss.sgi.com>; Sun, 18 Sep 2011 09:55:21 -0500
Received: from mail-bw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 27BFB16A8FB2
	for <xfs@oss.sgi.com>; Sun, 18 Sep 2011 08:00:26 -0700 (PDT)
Received: from mail-bw0-f53.google.com (mail-bw0-f53.google.com
	[209.85.214.53]) by cuda.sgi.com with ESMTP id IRefbUafQYGHsHLh
	for <xfs@oss.sgi.com>; Sun, 18 Sep 2011 08:00:26 -0700 (PDT)
Received: by bkbzt12 with SMTP id zt12so5665502bkb.26
	for <xfs@oss.sgi.com>; Sun, 18 Sep 2011 07:55:18 -0700 (PDT)
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 1/2] xfstest: fsstress should kill children tasks before exit
Date: Sun, 18 Sep 2011 18:54:58 +0400
Message-Id: <1316357699-22692-1-git-send-email-dmonakhov@openvz.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org, Dmitry Monakhov <dmonakhov@openvz.org>, linux-ext4@vger.kernel.org

It is very hard to predict runtime for fsstress. In many cases it
is useful to give test to run a reasonable time, and then kill it.
But currently there is no reliable way to kill test without leaving
running children.
This patch add sanity cleanup logic which looks follow:
 - On sigterm received by parent, it resend signal to it's children
 - Wait for each child to terminates
 - EXTRA_SANITY: Even if parent was killed by other signal, children
   will be terminated with SIGKILL to preven staled children.

So now one can simply run fsstress like this:
./fsstress -p 1000 -n999999999 -d $TEST_DIR &
PID=$!
sleep 300
kill $PID
wait $PID

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 aclocal.m4     |    5 +++++
 configure.in   |    1 +
 ltp/fsstress.c |   38 +++++++++++++++++++++++++++++++++++++-
 3 files changed, 43 insertions(+), 1 deletions(-)

diff --git a/aclocal.m4 b/aclocal.m4
index 168eb59..5532606 100644
--- a/aclocal.m4
+++ b/aclocal.m4
@@ -16,6 +16,11 @@ AC_DEFUN([AC_PACKAGE_WANT_LINUX_FIEMAP_H],
     AC_SUBST(have_fiemap)
   ])
 
+AC_DEFUN([AC_PACKAGE_WANT_LINUX_PRCTL_H],
+  [ AC_CHECK_HEADERS([sys/prctl.h], [ have_prctl=true ], [ have_prctl=false ])
+    AC_SUBST(have_prctl)
+  ])
+
 AC_DEFUN([AC_PACKAGE_WANT_FALLOCATE],
   [ AC_MSG_CHECKING([for fallocate])
     AC_TRY_LINK([
diff --git a/configure.in b/configure.in
index c697b4f..76d23e4 100644
--- a/configure.in
+++ b/configure.in
@@ -67,6 +67,7 @@ in
 		AC_PACKAGE_WANT_DMAPI
 		AC_PACKAGE_WANT_LINUX_FIEMAP_H
 		AC_PACKAGE_WANT_FALLOCATE
+		AC_PACKAGE_WANT_LINUX_PRCTL_H
 		;;
 esac
 
diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index c37cddf..cee2cad 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -28,7 +28,9 @@
 #ifndef HAVE_ATTR_LIST
 #define attr_list(path, buf, size, flags, cursor) (errno = -ENOSYS, -1)
 #endif
-
+#ifdef HAVE_SYS_PRCTL_H
+#include <sys/prctl.h>
+#endif
 #include <math.h>
 #define XFS_ERRTAG_MAX		17
 #define XFS_IDMODULO_MAX	31	/* user/group IDs (1 << x)  */
@@ -209,6 +211,7 @@ int		rtpct;
 unsigned long	seed = 0;
 ino_t		top_ino;
 int		verbose = 0;
+int 		should_stop = 0;
 
 void	add_to_flist(int, int, int);
 void	append_pathname(pathname_t *, char *);
@@ -253,6 +256,10 @@ void	usage(void);
 void	write_freq(void);
 void	zero_freq(void);
 
+void sg_handler(int signum) {
+	should_stop = 1;
+}
+
 int main(int argc, char **argv)
 {
 	char		buf[10];
@@ -267,6 +274,7 @@ int main(int argc, char **argv)
 	ptrdiff_t	srval;
 	int             nousage = 0;
 	xfs_error_injection_t	        err_inj;
+	struct sigaction action;
 
 	errrange = errtag = 0;
 	umask(0);
@@ -407,15 +415,43 @@ int main(int argc, char **argv)
 		}
 	} else
 		close(fd);
+	if (setpgid(0, 0) < 0) {
+		perror("setpgrp failed");
+		exit(1);
+	}
+	action.sa_handler = sg_handler;
+	sigemptyset(&action.sa_mask);
+	action.sa_flags = 0;
+	if (sigaction(SIGTERM, &action, 0)) {
+		perror("sigaction failed");
+		exit(1);
+	}
+
 	for (i = 0; i < nproc; i++) {
 		if (fork() == 0) {
+			action.sa_handler = SIG_DFL;
+			sigemptyset(&action.sa_mask);
+			if (sigaction(SIGTERM, &action, 0))
+				return 1;
+#ifdef HAVE_SYS_PRCTL_H
+			prctl(PR_SET_PDEATHSIG, SIGKILL);
+			if (getppid() == 1) /* parent died already? */
+				return 0;
+#endif
 			procid = i;
 			doproc();
 			return 0;
 		}
 	}
+	while (wait(&stat) > 0 && !should_stop) {
+		continue;
+	}
+	action.sa_flags = SA_RESTART;
+	sigaction(SIGTERM, &action, 0);
+	kill(-getpid(), SIGTERM);
 	while (wait(&stat) > 0)
 		continue;
+
 	if (errtag != 0) {
 		err_inj.errtag = 0;
 		err_inj.fd = fd;
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
