Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n84MYtZ7246830 for <xfs@oss.sgi.com>; Fri, 4 Sep 2009 17:35:05 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E82FB42B84F
	for <xfs@oss.sgi.com>; Fri,  4 Sep 2009 15:35:40 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id D3x8zZYtZCmmAfIx for
	<xfs@oss.sgi.com>; Fri, 04 Sep 2009 15:35:40 -0700 (PDT)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n84MZdGX025638
	for <xfs@oss.sgi.com>; Fri, 4 Sep 2009 18:35:39 -0400
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id n84MZcZA009199
	for <xfs@oss.sgi.com>; Fri, 4 Sep 2009 18:35:38 -0400
Message-ID: <4AA19639.6090208@sandeen.net>
Date: Fri, 04 Sep 2009 17:35:37 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfsprogs: mark some functions as noreturn
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs mailing list <xfs@oss.sgi.com>

Static checkers are a lot less noisy if they know certain
functions are noreturn.

Making this change removed about 50 errors from "clang" output.
(http://clang-analyzer.llvm.org) output.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 69d91c5..ab8a7d9 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -27,7 +27,7 @@
  */
 static void conflict(char opt, char *tab[], int oldidx, int newidx);
 static void illegal(char *value, char *opt);
-static void reqval(char opt, char *tab[], int idx);
+static __attribute__((noreturn)) void reqval(char opt, char *tab[], int idx);
 static void respec(char opt, char *tab[], int idx);
 static void unknown(char opt, char *s);
 static int  ispow2(unsigned int i);
@@ -2464,7 +2464,7 @@ ispow2(
 	return (i & (i - 1)) == 0;
 }
 
-static void
+static void __attribute__((noreturn))
 reqval(
 	char		opt,
 	char		*tab[],
diff --git a/repair/err_protos.h b/repair/err_protos.h
index 556e9b9..6944950 100644
--- a/repair/err_protos.h
+++ b/repair/err_protos.h
@@ -16,7 +16,11 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
-void	do_abort(char const *, ...);		/* abort, internal error */
-void	do_error(char const *, ...);		/* abort, system error */
-void	do_warn(char const *, ...);		/* issue warning */
-void	do_log(char const *, ...);		/* issue log message */
+/* abort, internal error */
+void  __attribute__((noreturn)) do_abort(char const *, ...);
+/* abort, system error */
+void  __attribute__((noreturn)) do_error(char const *, ...);
+/* issue warning */
+void do_warn(char const *, ...);
+/* issue log message */
+void do_log(char const *, ...);
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index e9e5965..5dfc3c3 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -351,7 +351,7 @@ do_msg(int do_abort, char const *msg, va_list args)
 	}
 }
 
-void
+void __attribute__((noreturn))
 do_error(char const *msg, ...)
 {
 	va_list args;
@@ -366,7 +366,7 @@ do_error(char const *msg, ...)
  * like do_error, only the error is internal, no system
  * error so no oserror processing
  */
-void
+void __attribute__((noreturn))
 do_abort(char const *msg, ...)
 {
 	va_list args;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
