Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA3EPcgQ017947 for <xfs@oss.sgi.com>; Thu, 3 Nov 2011 09:25:39 -0500
Received: from mail-bw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1AA7012FF495
	for <xfs@oss.sgi.com>; Thu,  3 Nov 2011 07:25:36 -0700 (PDT)
Received: from mail-bw0-f53.google.com (mail-bw0-f53.google.com
	[209.85.214.53]) by cuda.sgi.com with ESMTP id CD0DFu43iGitE4Fc
	for <xfs@oss.sgi.com>; Thu, 03 Nov 2011 07:25:36 -0700 (PDT)
Received: by mail-bw0-f53.google.com with SMTP id zs8so1398030bkb.26
	for <xfs@oss.sgi.com>; Thu, 03 Nov 2011 07:25:36 -0700 (PDT)
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 07/12] xfstests: fsstress add FS_IOC_{SET,
	GET}FLAGS operations v2
Date: Thu,  3 Nov 2011 18:24:56 +0400
Message-Id: <1320330301-2682-8-git-send-email-dmonakhov@openvz.org>
In-Reply-To: <1320330301-2682-1-git-send-email-dmonakhov@openvz.org>
References: <1320330301-2682-1-git-send-email-dmonakhov@openvz.org>
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
To: linux-fsdevel@vger.kernel.org
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, aelder@sgi.com, tytso@mit.edu, hch@lst.de, xfs@oss.sgi.com

Add two new operations:
- getattr: ioctl(fd, FS_IOC_GETFLAGS, &fl)
- setattr: ioctl(fd, FS_IOC_SETFLAGS, &random_flags)
Attribute mask may be passed via -M opt, by default is (~0).
By default FS_IOC_SETFLAGS has zero probability because
it may produce inodes with APPEND or IMMUTABLE flags which
are not deletable by default. Let's assumes that one who
enable it knows how to delete such inodes.
For example like follows:
find $TEST_PATH -exec chattr -i -a {} \;
rm -rf $TEST_PATH

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 aclocal.m4     |    4 +++
 configure.in   |    1 +
 ltp/fsstress.c |   68 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 72 insertions(+), 1 deletions(-)

diff --git a/aclocal.m4 b/aclocal.m4
index 5532606..5739004 100644
--- a/aclocal.m4
+++ b/aclocal.m4
@@ -21,6 +21,10 @@ AC_DEFUN([AC_PACKAGE_WANT_LINUX_PRCTL_H],
     AC_SUBST(have_prctl)
   ])
 
+AC_DEFUN([AC_PACKAGE_WANT_LINUX_FS_H],
+  [ AC_CHECK_HEADER([linux/fs.h])
+  ])
+
 AC_DEFUN([AC_PACKAGE_WANT_FALLOCATE],
   [ AC_MSG_CHECKING([for fallocate])
     AC_TRY_LINK([
diff --git a/configure.in b/configure.in
index 76d23e4..3b40e55 100644
--- a/configure.in
+++ b/configure.in
@@ -68,6 +68,7 @@ in
 		AC_PACKAGE_WANT_LINUX_FIEMAP_H
 		AC_PACKAGE_WANT_FALLOCATE
 		AC_PACKAGE_WANT_LINUX_PRCTL_H
+		AC_PACKAGE_WANT_LINUX_FS_H
 		;;
 esac
 
diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index f4c8d81..997f068 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -37,6 +37,15 @@
 #ifdef HAVE_SYS_PRCTL_H
 #include <sys/prctl.h>
 #endif
+
+#include <linux/fs.h>
+#ifndef FS_IOC_GETFLAGS
+#define FS_IOC_GETFLAGS                 _IOR('f', 1, long)
+#endif
+#ifndef FS_IOC_SETFLAGS
+#define FS_IOC_SETFLAGS                 _IOW('f', 2, long)
+#endif
+
 #include <math.h>
 #define XFS_ERRTAG_MAX		17
 #define XFS_IDMODULO_MAX	31	/* user/group IDs (1 << x)  */
@@ -58,6 +67,7 @@ typedef enum {
 	OP_FDATASYNC,
 	OP_FREESP,
 	OP_FSYNC,
+	OP_GETATTR,
 	OP_GETDENTS,
 	OP_LINK,
 	OP_MKDIR,
@@ -68,6 +78,7 @@ typedef enum {
 	OP_RENAME,
 	OP_RESVSP,
 	OP_RMDIR,
+	OP_SETATTR,
 	OP_SETXATTR,
 	OP_STAT,
 	OP_SYMLINK,
@@ -140,6 +151,7 @@ void	fallocate_f(int, long);
 void	fdatasync_f(int, long);
 void	freesp_f(int, long);
 void	fsync_f(int, long);
+void	getattr_f(int, long);
 void	getdents_f(int, long);
 void	link_f(int, long);
 void	mkdir_f(int, long);
@@ -150,6 +162,7 @@ void	readlink_f(int, long);
 void	rename_f(int, long);
 void	resvsp_f(int, long);
 void	rmdir_f(int, long);
+void	setattr_f(int, long);
 void	setxattr_f(int, long);
 void	stat_f(int, long);
 void	symlink_f(int, long);
@@ -173,6 +186,7 @@ opdesc_t	ops[] = {
 	{ OP_FDATASYNC, "fdatasync", fdatasync_f, 1, 1 },
 	{ OP_FREESP, "freesp", freesp_f, 1, 1 },
 	{ OP_FSYNC, "fsync", fsync_f, 1, 1 },
+	{ OP_GETATTR, "getattr", getattr_f, 1, 0 },
 	{ OP_GETDENTS, "getdents", getdents_f, 1, 0 },
 	{ OP_LINK, "link", link_f, 1, 1 },
 	{ OP_MKDIR, "mkdir", mkdir_f, 2, 1 },
@@ -183,6 +197,7 @@ opdesc_t	ops[] = {
 	{ OP_RENAME, "rename", rename_f, 2, 1 },
 	{ OP_RESVSP, "resvsp", resvsp_f, 1, 1 },
 	{ OP_RMDIR, "rmdir", rmdir_f, 1, 1 },
+	{ OP_SETATTR, "setattr", setattr_f, 0, 1 },
 	{ OP_SETXATTR, "setxattr", setxattr_f, 1, 1 },
 	{ OP_STAT, "stat", stat_f, 1, 0 },
 	{ OP_SYMLINK, "symlink", symlink_f, 2, 1 },
@@ -218,6 +233,7 @@ int		nops;
 int		nproc = 1;
 int		operations = 1;
 unsigned int	idmodulo = XFS_IDMODULO_MAX;
+unsigned int	attr_mask = ~0;
 int		procid;
 int		rtpct;
 unsigned long	seed = 0;
@@ -296,7 +312,7 @@ int main(int argc, char **argv)
 	nops = sizeof(ops) / sizeof(ops[0]);
 	ops_end = &ops[nops];
 	myprog = argv[0];
-	while ((c = getopt(argc, argv, "d:e:f:i:m:n:o:p:rs:S:vwzH")) != -1) {
+	while ((c = getopt(argc, argv, "d:e:f:i:m:M:n:o:p:rs:S:vwzH")) != -1) {
 		switch (c) {
 		case 'd':
 			dirname = optarg;
@@ -356,6 +372,9 @@ int main(int argc, char **argv)
 		case 'z':
 			zero_freq();
 			break;
+		case 'M':
+		  	attr_mask = strtoul(optarg, NULL, 0);
+			break;
 		case 'S':
 			i = 0;
 			if (optarg[0] == 'c')
@@ -2199,6 +2218,29 @@ fsync_f(int opno, long r)
 }
 
 void
+getattr_f(int opno, long r)
+{
+	int		fd;
+	int		e;
+	pathname_t	f;
+	uint		fl;
+	int		v;
+
+	init_pathname(&f);
+	if (!get_fname(FT_ANYm, r, &f, NULL, NULL, &v))
+		append_pathname(&f, ".");
+	fd = open_path(&f, O_RDWR);
+	e = fd < 0 ? errno : 0;
+	check_cwd();
+
+	e = ioctl(fd, FS_IOC_GETFLAGS, &fl);
+	if (v)
+		printf("%d/%d: getattr %s %u %d\n", procid, opno, f.path, fl, e);
+	free_pathname(&f);
+	close(fd);
+}
+
+void
 getdents_f(int opno, long r)
 {
 	DIR		*dir;
@@ -2644,6 +2686,30 @@ rmdir_f(int opno, long r)
 }
 
 void
+setattr_f(int opno, long r)
+{
+	int		fd;
+	int		e;
+	pathname_t	f;
+	uint		fl;
+	int		v;
+
+	init_pathname(&f);
+	if (!get_fname(FT_ANYm, r, &f, NULL, NULL, &v))
+		append_pathname(&f, ".");
+	fd = open_path(&f, O_RDWR);
+	e = fd < 0 ? errno : 0;
+	check_cwd();
+
+	fl = attr_mask & (uint)random();
+	e = ioctl(fd, FS_IOC_SETFLAGS, &fl);
+	if (v)
+		printf("%d/%d: setattr %s %x %d\n", procid, opno, f.path, fl, e);
+	free_pathname(&f);
+	close(fd);
+}
+
+void
 stat_f(int opno, long r)
 {
 	int		e;
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
