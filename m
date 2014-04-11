Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 33F797F56
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2014 10:52:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DB58A304053
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2014 08:52:08 -0700 (PDT)
Received: from mail-ee0-f48.google.com (mail-ee0-f48.google.com
	[74.125.83.48]) by cuda.sgi.com with ESMTP id bcHGTB4Er2OcDc47
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 11 Apr 2014 08:52:05 -0700 (PDT)
Received: by mail-ee0-f48.google.com with SMTP id b57so4263276eek.35
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2014 08:52:04 -0700 (PDT)
From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [PATCH 1/4] renameat2 syscall: add infrastructure
Date: Fri, 11 Apr 2014 17:51:54 +0200
Message-Id: <1397231517-4641-1-git-send-email-miklos@szeredi.hu>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Miklos Szeredi <mszeredi@suse.cz>

From: Miklos Szeredi <mszeredi@suse.cz>

The renameat2() syscall was merged into 3.15-rc (merge commit: 7df934526c0b).

This adds the shared infrastructure for the actual test scripts.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 .gitignore       |   1 +
 common/renameat2 | 129 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 configure.ac     |   2 +
 src/Makefile     |   3 +-
 src/renameat2.c  | 102 +++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 236 insertions(+), 1 deletion(-)
 create mode 100644 common/renameat2
 create mode 100644 src/renameat2.c

diff --git a/.gitignore b/.gitignore
index e8c5012..66e6ee8 100644
--- a/.gitignore
+++ b/.gitignore
@@ -106,6 +106,7 @@
 /src/aio-dio-regress/aio-io-setup-with-nonwritable-context-pointer
 /src/aio-dio-regress/aiodio_sparse2
 /src/cloner
+/src/renameat2
 
 # dmapi/ binaries
 /dmapi/src/common/cmd/read_invis
diff --git a/common/renameat2 b/common/renameat2
new file mode 100644
index 0000000..a335169
--- /dev/null
+++ b/common/renameat2
@@ -0,0 +1,129 @@
+######
+#
+# renameat2 helpers
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2014 Miklos Szeredi.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#-----------------------------------------------------------------------
+#
+
+#
+# Setup source or dest
+#
+_setup_one()
+{
+	local path=$1
+	local type=$2
+
+	case $type in
+		none)	;;
+		regu)	echo foo > $path;;
+		symb)	ln -s foo $path;;
+		dire)	mkdir $path;;
+		tree)	mkdir $path; echo foo > $path/bar;;
+	esac
+}
+
+#
+# Cleanup source or dest
+#
+_cleanup_one()
+{
+	local path=$1
+
+	if test -d $path; then
+		rm -f $path/bar
+		rmdir $path
+	else
+		rm -f $path
+	fi
+}
+
+#
+# Check type of source or destination
+#
+_showtype_one()
+{
+	local path=$1
+
+	if test -e $path -o -h $path; then
+		if test -d $path -a -e $path/bar; then
+			echo -n "tree"
+		else
+			echo -n `stat -c %F $path | cut -b-4`
+		fi
+	else
+		echo -n "none"
+	fi
+}
+
+#
+# This runs renameat2 on all combinations of source and dest
+#
+_rename_tests_source_dest()
+{
+	local source=$1
+	local dest=$2
+	local options=$3
+
+	for stype in none regu symb dire tree; do
+		for dtype in none regu symb dire tree; do
+			echo -n "$options $stype/$dtype -> "
+			_setup_one $source $stype
+			_setup_one $dest $dtype
+			src/renameat2 $source $dest $flags
+			if test $? == 0; then
+				_showtype_one $source
+				echo -n "/"
+				_showtype_one $dest
+				echo "."
+			fi
+			_cleanup_one $source
+			_cleanup_one $dest
+		done
+	done
+}
+
+#
+# This runs _rename_tests_source_dest() for both same-directory and
+# cross-directory renames
+#
+_rename_tests()
+{
+	local testdir=$1
+	local flags=$2
+
+	#same directory renames
+	_rename_tests_source_dest $testdir/src $testdir/dst     "samedir "
+
+	#cross directory renames
+	mkdir $testdir/x $testdir/y
+	_rename_tests_source_dest $testdir/x/src $testdir/y/dst "crossdir"
+	rmdir $testdir/x $testdir/y
+}
+
+#
+# This checks whether the renameat2 syscall is supported
+#
+_requires_renameat2()
+{
+	if test ! -x src/renameat2; then
+		_notrun "renameat2 binary not found"
+	fi
+	if ! src/renameat2 -t; then
+		_notrun "kernel doesn't support renameat2 syscall"
+	fi
+}
diff --git a/configure.ac b/configure.ac
index 2f95c4c..43e6029 100644
--- a/configure.ac
+++ b/configure.ac
@@ -76,6 +76,8 @@ in
 		;;
 esac
 
+AC_CHECK_FUNCS([renameat2])
+
 AC_CONFIG_HEADER(include/config.h)
 AC_CONFIG_FILES([include/builddefs])
 AC_OUTPUT
diff --git a/src/Makefile b/src/Makefile
index 2dbc696..d754048 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -18,7 +18,8 @@ LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
 	locktest unwritten_mmap bulkstat_unlink_test t_stripealign \
 	bulkstat_unlink_test_modified t_dir_offset t_futimens t_immutable \
 	stale_handle pwrite_mmap_blocked t_dir_offset2 seek_sanity_test \
-	seek_copy_test t_readdir_1 t_readdir_2 fsync-tester nsexec cloner
+	seek_copy_test t_readdir_1 t_readdir_2 fsync-tester nsexec cloner \
+	renameat2
 
 SUBDIRS =
 
diff --git a/src/renameat2.c b/src/renameat2.c
new file mode 100644
index 0000000..5145959
--- /dev/null
+++ b/src/renameat2.c
@@ -0,0 +1,102 @@
+/*
+ * Copyright (c) 2014, Miklos Szeredi <mszeredi@suse.cz>
+ * This file is published under GPL2+.
+ *
+ * This is a trivial wrapper around the renameat2 syscall.
+ */
+
+#include "global.h"
+
+#ifndef HAVE_RENAMEAT2
+#include <sys/syscall.h>
+
+#if !defined(SYS_renameat2) && defined(__x86_64__)
+#define SYS_renameat2 316
+#endif
+
+static int renameat2(int dfd1, const char *path1,
+		     int dfd2, const char *path2,
+		     unsigned int flags)
+{
+#ifdef SYS_renameat2
+	return syscall(SYS_renameat2, dfd1, path1, dfd2, path2, flags);
+#else
+	errno = ENOSYS;
+	return -1;
+#endif
+}
+#endif
+
+#ifndef RENAME_NOREPLACE
+#define RENAME_NOREPLACE	(1 << 0)	/* Don't overwrite target */
+#endif
+#ifndef RENAME_EXCHANGE
+#define RENAME_EXCHANGE		(1 << 1)	/* Exchange source and dest */
+#endif
+#ifndef RENAME_WHITEOUT
+#define RENAME_WHITEOUT		(1 << 2)	/* Whiteout source */
+#endif
+
+int main(int argc, char *argv[])
+{
+	int ret;
+	int c;
+	const char *path1 = NULL;
+	const char *path2 = NULL;
+	unsigned int flags = 0;
+	int test = 0;
+
+	for (c = 1; c < argc; c++) {
+		if (argv[c][0] == '-') {
+			switch (argv[c][1]) {
+			case 't':
+				test = 1;
+				break;
+			case 'n':
+				flags |= RENAME_NOREPLACE;
+				break;
+			case 'x':
+				flags |= RENAME_EXCHANGE;
+				break;
+			case 'w':
+				flags |= RENAME_WHITEOUT;
+				break;
+			default:
+				goto usage;
+			}
+		} else if (!path1) {
+			path1 = argv[c];
+		} else if (!path2) {
+			path2 = argv[c];
+		} else {
+			goto usage;
+		}
+	}
+
+	if (!test && (!path1 || !path2))
+		goto usage;
+
+	ret = renameat2(AT_FDCWD, path1, AT_FDCWD, path2, flags);
+	if (ret == -1) {
+		if (test) {
+			if (errno == ENOSYS || errno == EINVAL)
+				return 1;
+			else
+				return 0;
+		}
+		perror("");
+		return 1;
+	}
+
+	return 0;
+
+usage:
+	fprintf(stderr,
+		"usage: %s [-t] [-n|-x|-w] path1 path2\n"
+		"  -t  test\n"
+		"  -n  noreplace\n"
+		"  -x  exchange\n"
+		"  -w  whiteout\n", argv[0]);
+
+	return 1;
+}
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
