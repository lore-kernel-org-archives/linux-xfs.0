Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0C9247F37
	for <xfs@oss.sgi.com>; Wed, 18 Nov 2015 08:18:09 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F1A34304039
	for <xfs@oss.sgi.com>; Wed, 18 Nov 2015 06:18:08 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id tFg2Gpr1vTuaOUZQ (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 18 Nov 2015 06:18:03 -0800 (PST)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (Postfix) with ESMTPS id 34BE1C049D4F
	for <xfs@oss.sgi.com>; Wed, 18 Nov 2015 14:18:03 +0000 (UTC)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [XFSTESTS 5/6] Add richacl tests
Date: Wed, 18 Nov 2015 15:17:48 +0100
Message-Id: <1447856269-7872-6-git-send-email-agruenba@redhat.com>
In-Reply-To: <1447856269-7872-1-git-send-email-agruenba@redhat.com>
References: <1447856269-7872-1-git-send-email-agruenba@redhat.com>
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
Cc: Andreas Gruenbacher <agruenba@redhat.com>

Add the Rich Access Control List tests from the richacl package.  The
new tests require TEST_DEV and TEST_DIR to be set.

When the check script is run, it first makes sure that the test
filesystem has richacls enabled or disabled as appropriate: with the
-richacl option, richacls must be enabled; without the -richacl option,
richacls must be disabled.  If TEST_DEV has incorrect richacl support,
the TEST_DEV filesystem is recreated.

The -richacl option currently selects the tests in the richacl group to
be run.  Additional test groups or tests can be specified on the command
line, e.g.,

  ./check -richacl -g quick

(Eventually, the -richacl option will be changed to only skip tests
which are incompatible with richacls.)

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 .gitignore                          |   1 +
 check                               |  39 +++++++-
 common/rc                           |  23 ++++-
 src/Makefile                        |   2 +-
 src/require-richacls.c              |  35 +++++++
 tests/richacl/001-apply-masks       |   1 +
 tests/richacl/002-auto-inheritance  |   1 +
 tests/richacl/003-basic             |   1 +
 tests/richacl/004-chmod             |   1 +
 tests/richacl/005-chown             |   1 +
 tests/richacl/006-create            |   1 +
 tests/richacl/007-ctime             |   1 +
 tests/richacl/008-delete            |   1 +
 tests/richacl/009-setrichacl-modify |   1 +
 tests/richacl/010-write-vs-append   |   1 +
 tests/richacl/Makefile              |  44 +++++++++
 tests/richacl/apply-masks           | 163 ++++++++++++++++++++++++++++++
 tests/richacl/auto-inheritance      | 191 ++++++++++++++++++++++++++++++++++++
 tests/richacl/basic                 |  97 ++++++++++++++++++
 tests/richacl/chmod                 |  40 ++++++++
 tests/richacl/chown                 |  42 ++++++++
 tests/richacl/create                |  36 +++++++
 tests/richacl/ctime                 |  35 +++++++
 tests/richacl/delete                |  89 +++++++++++++++++
 tests/richacl/group                 |  15 +++
 tests/richacl/setrichacl-modify     |  57 +++++++++++
 tests/richacl/test-lib.sh           | 149 ++++++++++++++++++++++++++++
 tests/richacl/write-vs-append       |  54 ++++++++++
 28 files changed, 1114 insertions(+), 8 deletions(-)
 create mode 100644 src/require-richacls.c
 create mode 120000 tests/richacl/001-apply-masks
 create mode 120000 tests/richacl/002-auto-inheritance
 create mode 120000 tests/richacl/003-basic
 create mode 120000 tests/richacl/004-chmod
 create mode 120000 tests/richacl/005-chown
 create mode 120000 tests/richacl/006-create
 create mode 120000 tests/richacl/007-ctime
 create mode 120000 tests/richacl/008-delete
 create mode 120000 tests/richacl/009-setrichacl-modify
 create mode 120000 tests/richacl/010-write-vs-append
 create mode 100644 tests/richacl/Makefile
 create mode 100755 tests/richacl/apply-masks
 create mode 100755 tests/richacl/auto-inheritance
 create mode 100755 tests/richacl/basic
 create mode 100755 tests/richacl/chmod
 create mode 100755 tests/richacl/chown
 create mode 100755 tests/richacl/create
 create mode 100755 tests/richacl/ctime
 create mode 100755 tests/richacl/delete
 create mode 100644 tests/richacl/group
 create mode 100755 tests/richacl/setrichacl-modify
 create mode 100644 tests/richacl/test-lib.sh
 create mode 100755 tests/richacl/write-vs-append

diff --git a/.gitignore b/.gitignore
index 7c25c41..d7ff600 100644
--- a/.gitignore
+++ b/.gitignore
@@ -116,6 +116,7 @@
 /src/cloner
 /src/renameat2
 /src/t_rename_overwrite
+/src/require-richacls
 
 # dmapi/ binaries
 /dmapi/src/common/cmd/read_invis
diff --git a/check b/check
index 5ecc12b..89b6d8a 100755
--- a/check
+++ b/check
@@ -60,7 +60,7 @@ then
     exit 1
 fi
 
-SRC_GROUPS="generic shared"
+SRC_GROUPS="generic shared richacl"
 export SRC_DIR="tests"
 
 usage()
@@ -71,6 +71,7 @@ check options
     -nfs                test NFS
     -cifs               test CIFS
     -tmpfs              test TMPFS
+    -richacl            test Rich Access Control Lists
     -l			line mode diff
     -udiff		show unified diff (default)
     -n			show me, do not run tests
@@ -220,6 +221,11 @@ while [ $# -gt 0 ]; do
 	-cifs)	FSTYP=cifs ;;
 	-tmpfs)	FSTYP=tmpfs ;;
 
+	-richacl)
+		RICHACL=1
+		GROUP_LIST="$GROUP_LIST richacl"
+		;;
+
 	-g)	group=$2 ; shift ;
 		GROUP_LIST="$GROUP_LIST ${group//,/ }"
 		;;
@@ -417,6 +423,34 @@ else
 	trap "_wrapup; exit \$status" 0 1 2 3 15
 fi
 
+# Check if the filesystem on a block device is compatible with how the test
+# suite is being run.  Currently, we use this to check if the filesystem
+# has richacl support when needed.
+_dev_is_compatible() {
+    local dev=$1 HAS_RICHACL=
+
+    case "$FSTYP" in
+    xfs)
+	if xfs_db -r -c version "$dev" | grep -qw RICHACL; then
+	    HAS_RICHACL=1
+	fi
+	;;
+
+    ext2|ext3|ext4)
+	if tune2fs -l "$dev" | grep -q '^Filesystem features.*\<richacl\>'; then
+	    HAS_RICHACL=1
+	fi
+	;;
+
+    *)
+	# Other filesystems don't currently have richacl support; there
+	# is no point in recreating them.
+	HAS_RICHACL=$RICHACL
+	;;
+    esac
+    [ "$HAS_RICHACL" = "$RICHACL" ]
+}
+
 for section in $HOST_OPTIONS_SECTIONS; do
 	OLD_FSTYP=$FSTYP
 	OLD_MOUNT_OPTIONS=$MOUNT_OPTIONS
@@ -446,7 +480,8 @@ for section in $HOST_OPTIONS_SECTIONS; do
 		echo "SECTION       -- $section"
 	fi
 
-	if $RECREATE_TEST_DEV || [ "$OLD_FSTYP" != "$FSTYP" ]; then
+	if $RECREATE_TEST_DEV || [ "$OLD_FSTYP" != "$FSTYP" ] ||
+	   ! _dev_is_compatible "$TEST_DEV"; then
 		echo "RECREATING    -- $FSTYP on $TEST_DEV"
 		umount $TEST_DEV 2> /dev/null
 		if ! _test_mkfs >$tmp.err 2>&1
diff --git a/common/rc b/common/rc
index ce6ae3d..0dd8e4f 100644
--- a/common/rc
+++ b/common/rc
@@ -559,6 +559,19 @@ _scratch_mkfs_ext4()
 
 _test_mkfs()
 {
+    local OPT=$MKFS_OPTIONS
+
+    if [ -n "$RICHACL" ]; then
+	case "$FSTYP" in
+	xfs)
+	    OPT="$OPT -m richacl=1"
+	    ;;
+	ext2|ext3|ext4)
+	    OPT="$OPT -O richacl"
+	    ;;
+	esac
+    fi
+
     case $FSTYP in
     nfs*)
 	# do nothing for nfs
@@ -567,19 +580,19 @@ _test_mkfs()
 	# do nothing for cifs
 	;;
     udf)
-        $MKFS_UDF_PROG $MKFS_OPTIONS $* $TEST_DEV > /dev/null
+        $MKFS_UDF_PROG $OPT $* $TEST_DEV > /dev/null
 	;;
     btrfs)
-        $MKFS_BTRFS_PROG $MKFS_OPTIONS $* $TEST_DEV > /dev/null
+        $MKFS_BTRFS_PROG $OPT $* $TEST_DEV > /dev/null
 	;;
     xfs)
-	$MKFS_PROG -t $FSTYP -- -f $MKFS_OPTIONS $* $TEST_DEV
+	$MKFS_PROG -t $FSTYP -- -f $OPT $* $TEST_DEV
 	;;
     ext2|ext3|ext4)
-	$MKFS_PROG -t $FSTYP -- -F $MKFS_OPTIONS $* $TEST_DEV
+	$MKFS_PROG -t $FSTYP -- -F $OPT $* $TEST_DEV
 	;;
     *)
-	yes | $MKFS_PROG -t $FSTYP -- $MKFS_OPTIONS $* $TEST_DEV
+	yes | $MKFS_PROG -t $FSTYP -- $OPT $* $TEST_DEV
 	;;
     esac
 }
diff --git a/src/Makefile b/src/Makefile
index 4781736..7908f3c 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -19,7 +19,7 @@ LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
 	bulkstat_unlink_test_modified t_dir_offset t_futimens t_immutable \
 	stale_handle pwrite_mmap_blocked t_dir_offset2 seek_sanity_test \
 	seek_copy_test t_readdir_1 t_readdir_2 fsync-tester nsexec cloner \
-	renameat2 t_getcwd e4compact
+	renameat2 t_getcwd e4compact require-richacls
 
 SUBDIRS =
 
diff --git a/src/require-richacls.c b/src/require-richacls.c
new file mode 100644
index 0000000..dce984f
--- /dev/null
+++ b/src/require-richacls.c
@@ -0,0 +1,35 @@
+#ifndef _GNU_SOURCE
+# define _GNU_SOURCE
+#endif
+#include <sys/types.h>
+#include <sys/xattr.h>
+#include <limits.h>
+#include <stdlib.h>
+#include <stdio.h>
+#include <unistd.h>
+#include <string.h>
+#include <errno.h>
+#include <libgen.h>
+
+int main(int argc, char *argv[])
+{
+	int ret;
+
+	ret = getxattr(".", "system.richacl", NULL, 0);
+	if (ret < 0 && errno != ENODATA) {
+		char cwd[PATH_MAX];
+
+		if (!getcwd(cwd, sizeof(cwd)))
+			strcpy(cwd, ".");
+		if (errno == ENOTSUP) {
+			printf("This test requires a filesystem with richacl "
+			       "support at %s\n",
+			       cwd);
+			return 77;
+		} else {
+			perror(cwd);
+			return 1;
+		}
+	}
+	return 0;
+}
diff --git a/tests/richacl/001-apply-masks b/tests/richacl/001-apply-masks
new file mode 120000
index 0000000..256bb2b
--- /dev/null
+++ b/tests/richacl/001-apply-masks
@@ -0,0 +1 @@
+apply-masks
\ No newline at end of file
diff --git a/tests/richacl/002-auto-inheritance b/tests/richacl/002-auto-inheritance
new file mode 120000
index 0000000..98472fc
--- /dev/null
+++ b/tests/richacl/002-auto-inheritance
@@ -0,0 +1 @@
+auto-inheritance
\ No newline at end of file
diff --git a/tests/richacl/003-basic b/tests/richacl/003-basic
new file mode 120000
index 0000000..ea5233d
--- /dev/null
+++ b/tests/richacl/003-basic
@@ -0,0 +1 @@
+basic
\ No newline at end of file
diff --git a/tests/richacl/004-chmod b/tests/richacl/004-chmod
new file mode 120000
index 0000000..8acd9e4
--- /dev/null
+++ b/tests/richacl/004-chmod
@@ -0,0 +1 @@
+chmod
\ No newline at end of file
diff --git a/tests/richacl/005-chown b/tests/richacl/005-chown
new file mode 120000
index 0000000..6fb0fcd
--- /dev/null
+++ b/tests/richacl/005-chown
@@ -0,0 +1 @@
+chown
\ No newline at end of file
diff --git a/tests/richacl/006-create b/tests/richacl/006-create
new file mode 120000
index 0000000..f4ab424
--- /dev/null
+++ b/tests/richacl/006-create
@@ -0,0 +1 @@
+create
\ No newline at end of file
diff --git a/tests/richacl/007-ctime b/tests/richacl/007-ctime
new file mode 120000
index 0000000..3ddadee
--- /dev/null
+++ b/tests/richacl/007-ctime
@@ -0,0 +1 @@
+ctime
\ No newline at end of file
diff --git a/tests/richacl/008-delete b/tests/richacl/008-delete
new file mode 120000
index 0000000..bbd98f4
--- /dev/null
+++ b/tests/richacl/008-delete
@@ -0,0 +1 @@
+delete
\ No newline at end of file
diff --git a/tests/richacl/009-setrichacl-modify b/tests/richacl/009-setrichacl-modify
new file mode 120000
index 0000000..e3ebe54
--- /dev/null
+++ b/tests/richacl/009-setrichacl-modify
@@ -0,0 +1 @@
+setrichacl-modify
\ No newline at end of file
diff --git a/tests/richacl/010-write-vs-append b/tests/richacl/010-write-vs-append
new file mode 120000
index 0000000..f19a074
--- /dev/null
+++ b/tests/richacl/010-write-vs-append
@@ -0,0 +1 @@
+write-vs-append
\ No newline at end of file
diff --git a/tests/richacl/Makefile b/tests/richacl/Makefile
new file mode 100644
index 0000000..46662c5
--- /dev/null
+++ b/tests/richacl/Makefile
@@ -0,0 +1,44 @@
+#
+# Copyright (C) 2015  Red Hat, Inc.
+#
+
+# TOPDIR = ..
+# include $(TOPDIR)/include/builddefs
+#
+# TESTS = apply-masks basic chmod chown create delete setrichacl-modify \
+# 	write-vs-append ctime auto-inheritance
+#
+# LSRCFILES = test-lib.sh $(TESTS)
+#
+# default install install-dev install-lib:
+#
+# include $(BUILDRULES)
+
+#$(TARGETS):
+#	@echo "    [CC]    $@"
+#	$(Q)$(LTLINK) $@.c -o $@ $(CFLAGS) $(LDFLAGS) $(LDLIBS)
+
+#TESTS_ENVIRONMENT = \
+#	abs_top_builddir=$(abs_top_builddir); \
+#	export abs_top_builddir;
+#
+#
+#
+#
+#
+
+TOPDIR = ../..
+include $(TOPDIR)/include/builddefs
+
+TARGET_DIR = $(PKG_LIB_DIR)/$(TESTS_DIR)/richacl
+
+include $(BUILDRULES)
+
+install:
+	$(INSTALL) -m 755 -d $(TARGET_DIR)
+	$(INSTALL) -m 755 [0-9]?? $(TESTS) $(TARGET_DIR)
+	$(INSTALL) -m 644 group $(TARGET_DIR)
+	#$(INSTALL) -m 644 [0-9]??.* $(TARGET_DIR)
+
+# Nothing.
+install-dev install-lib:
diff --git a/tests/richacl/apply-masks b/tests/richacl/apply-masks
new file mode 100755
index 0000000..7a99cf9
--- /dev/null
+++ b/tests/richacl/apply-masks
@@ -0,0 +1,163 @@
+#! /bin/sh
+
+. ${0%/*}/test-lib.sh
+
+require_richacls
+use_tmpdir
+
+ncheck "touch x"
+ncheck "setrichacl --set 'owner@:rwp::allow group@:rwp::allow everyone@:r::allow' x"
+check "getrichacl x" <<EOF
+x:
+    owner@:rwp----------::allow
+    group@:rwp----------::allow
+ everyone@:r------------::allow
+EOF
+
+ncheck "setrichacl --set 'everyone@:wp::allow owner@:r::allow group@:r::allow' x"
+ncheck "chmod 664 x"
+check "getrichacl x" <<EOF
+x:
+    owner@:rwp----------::allow
+    group@:rwp----------::allow
+ everyone@:r------------::allow
+EOF
+
+ncheck "setrichacl --set 'everyone@:wp::deny owner@:rwp::allow group@:rwp::allow' x"
+ncheck "chmod 664 x"
+check "getrichacl x" <<EOF
+x:
+    owner@:rwp----------::allow
+    group@:rwp----------::allow
+ everyone@:r------------::allow
+EOF
+
+ncheck "setrichacl --set 'owner@:rwCo::allow' x"
+check "getrichacl x" <<EOF
+x:
+ owner@:rw-------Co--::allow
+EOF
+
+ncheck "setrichacl --set 'owner@:rwpCo::allow' x"
+check "getrichacl x" <<EOF
+x:
+ owner@:rwp----------::allow
+EOF
+
+ncheck "chmod 644 x"
+check "getrichacl x" <<EOF
+x:
+    owner@:rwp----------::allow
+ everyone@:r------------::allow
+EOF
+
+ncheck "setrichacl --set '77:rwp::allow' x"
+ncheck "chmod 664 x"
+check "getrichacl x" <<EOF
+x:
+    owner@:rwp----------::allow
+        77:rwp----------::allow
+    group@:r------------::deny
+ everyone@:r------------::allow
+EOF
+
+ncheck "chmod 644 x"
+check "getrichacl --numeric-ids x" <<EOF
+x:
+    owner@:rwp----------::allow
+        77:r------------::allow
+    group@:r------------::deny
+ everyone@:r------------::allow
+EOF
+
+ncheck "chmod 664 x"
+check "getrichacl x" <<EOF
+x:
+    owner@:rwp----------::allow
+        77:rwp----------::allow
+    group@:r------------::deny
+ everyone@:r------------::allow
+EOF
+
+ncheck "setrichacl --set '77:rwp::allow everyone@:r::allow' x"
+ncheck "chmod 664 x"
+check "getrichacl x" <<EOF
+x:
+    owner@:rwp----------::allow
+        77:rwp----------::allow
+ everyone@:r------------::allow
+EOF
+
+ncheck "setrichacl --set '77:r::allow everyone@:rwp::allow' x"
+ncheck "chmod 664 x"
+check "getrichacl x" <<EOF
+x:
+        77:rwp----------::allow
+    owner@:rwp----------::allow
+    group@:rwp----------::allow
+ everyone@:r------------::allow
+EOF
+
+ncheck "setrichacl --set '77:wp::deny everyone@:rwp::allow' x"
+ncheck "chmod 664 x"
+check "getrichacl x" <<EOF
+x:
+    owner@:rwp----------::allow
+        77:-wp----------::deny
+    group@:rwp----------::allow
+ everyone@:r------------::allow
+EOF
+
+ncheck "setrichacl --set '77:rwp::allow 77:wp::deny everyone@:rwp::allow' x"
+ncheck "chmod 664 x"
+check "getrichacl x" <<EOF
+x:
+    owner@:rwp----------::allow
+        77:rwp----------::allow
+        77:-wp----------::deny
+    group@:rwp----------::allow
+ everyone@:r------------::allow
+EOF
+
+ncheck "setrichacl --set 'everyone@:rwp::allow' x"
+ncheck "chmod 066 x"
+check "getrichacl x" <<EOF
+x:
+    owner@:rwp----------::deny
+ everyone@:rwp----------::allow
+EOF
+
+ncheck "chmod 006 x"
+check "getrichacl x" <<EOF
+x:
+    owner@:rwp----------::deny
+    group@:rwp----------::deny
+ everyone@:rwp----------::allow
+EOF
+
+ncheck "chmod 606 x"
+check "getrichacl x" <<EOF
+x:
+    owner@:rwp----------::allow
+    group@:rwp----------::deny
+ everyone@:rwp----------::allow
+EOF
+
+ncheck "setrichacl --set '77:rwp::allow everyone@:rwp::allow' x"
+ncheck "chmod 606 x"
+check "getrichacl x" <<EOF
+x:
+    owner@:rwp----------::allow
+    group@:rwp----------::deny
+ everyone@:rwp----------::allow
+EOF
+
+ncheck "chmod 646 x"
+check "getrichacl x" <<EOF
+x:
+        77:r------------::allow
+    owner@:rwp----------::allow
+    group@:-wp----------::deny
+        77:-wp----------::deny
+ everyone@:rwp----------::allow
+EOF
diff --git a/tests/richacl/auto-inheritance b/tests/richacl/auto-inheritance
new file mode 100755
index 0000000..7e40f0b
--- /dev/null
+++ b/tests/richacl/auto-inheritance
@@ -0,0 +1,191 @@
+#! /bin/sh
+
+. ${0%/*}/test-lib.sh
+
+require_richacls
+use_tmpdir
+
+umask 022
+
+ncheck "mkdir d1"
+ncheck "setrichacl --modify 101:rw:fd:deny d1"
+ncheck "setrichacl --modify 102:rw:f:deny d1"
+ncheck "setrichacl --modify 103:rw:d:deny d1"
+ncheck "setrichacl --modify 101:rw:fdig:deny d1"
+
+ncheck "setrichacl --modify flags:a d1"
+
+check "getrichacl --numeric --raw d1" <<EOF
+d1:
+     flags:a
+     owner:rwpxd-----------::mask
+     group:r--x------------::mask
+     other:r--x------------::mask
+       101:rw--------------:fd:deny
+       102:rw--------------:f:deny
+       103:rw--------------:d:deny
+       101:rw--------------:fdig:deny
+    owner@:rwpxd-----------::allow
+ everyone@:r--x------------::allow
+EOF
+
+ncheck "mkdir d1/d2"
+ncheck "touch d1/d3"
+
+# Mode bits derived from inherited ACEs
+check "getrichacl --numeric --raw d1/d2" <<EOF
+d1/d2:
+ flags:map
+ owner:----------------::mask
+ group:----------------::mask
+ other:----------------::mask
+   101:rw--------------:fda:deny
+   102:rw--------------:fia:deny
+   103:rw--------------:da:deny
+   101:rw--------------:fdiga:deny
+EOF
+
+check "getrichacl --numeric --raw d1/d3" <<EOF
+d1/d3:
+ flags:map
+ owner:----------------::mask
+ group:----------------::mask
+ other:----------------::mask
+   101:rw--------------:a:deny
+   102:rw--------------:a:deny
+   101:rw--------------:ga:deny
+EOF
+
+ncheck "mkdir d1/d2/d4"
+ncheck "touch d1/d2/d4/d5"
+
+# Protected files
+ncheck "mkdir d1/d6"
+ncheck "touch d1/d7"
+
+check "getrichacl --numeric --raw d1/d2/d4" <<EOF
+d1/d2/d4:
+ flags:map
+ owner:----------------::mask
+ group:----------------::mask
+ other:----------------::mask
+   101:rw--------------:fda:deny
+   102:rw--------------:fia:deny
+   103:rw--------------:da:deny
+   101:rw--------------:fdiga:deny
+EOF
+
+check "getrichacl --numeric --raw d1/d2/d4/d5" <<EOF
+d1/d2/d4/d5:
+ flags:map
+ owner:----------------::mask
+ group:----------------::mask
+ other:----------------::mask
+   101:rw--------------:a:deny
+   102:rw--------------:a:deny
+   101:rw--------------:ga:deny
+EOF
+
+# Clear protected flag from all the ACLs
+ncheck "setrichacl --modify flags:a d1/d2"
+ncheck "setrichacl --modify flags:a d1/d3"
+ncheck "setrichacl --modify flags:a d1/d2/d4"
+ncheck "setrichacl --modify flags:a d1/d2/d4/d5"
+
+ncheck "getrichacl --numeric d1 | sed -e 's/:fd:deny/:fd:allow/' > acl.txt"
+check "cat acl.txt" <<EOF
+d1:
+     flags:a
+       101:rw-----------:fd:allow
+       102:rw-----------:f:deny
+       103:rw-----------:d:deny
+       101:rw-----------:fdig:deny
+    owner@:rwpxd--------::allow
+ everyone@:r--x---------::allow
+EOF
+
+ncheck "setrichacl --set-file acl.txt d1"
+
+check "getrichacl --numeric --raw d1" <<EOF
+d1:
+     flags:a
+     owner:rwpxd-----------::mask
+     group:rw-x------------::mask
+     other:r--x------------::mask
+       101:rw--------------:fd:allow
+       102:rw--------------:f:deny
+       103:rw--------------:d:deny
+       101:rw--------------:fdig:deny
+    owner@:rwpxd-----------::allow
+ everyone@:r--x------------::allow
+EOF
+
+check "getrichacl --numeric --raw d1/d2" <<EOF
+d1/d2:
+ flags:a
+ owner:rw--------------::mask
+ group:rw--------------::mask
+ other:----------------::mask
+   101:rw--------------:fda:allow
+   102:rw--------------:fia:deny
+   103:rw--------------:da:deny
+   101:rw--------------:fdiga:deny
+EOF
+
+check "getrichacl --numeric --raw d1/d3" <<EOF
+d1/d3:
+ flags:a
+ owner:rw--------------::mask
+ group:rw--------------::mask
+ other:----------------::mask
+   101:rw--------------:a:allow
+   102:rw--------------:a:deny
+   101:rw--------------:ga:deny
+EOF
+
+check "getrichacl --numeric --raw d1/d2/d4" <<EOF
+d1/d2/d4:
+ flags:a
+ owner:rw--------------::mask
+ group:rw--------------::mask
+ other:----------------::mask
+   101:rw--------------:fda:allow
+   102:rw--------------:fia:deny
+   103:rw--------------:da:deny
+   101:rw--------------:fdiga:deny
+EOF
+
+check "getrichacl --numeric --raw d1/d2/d4/d5" <<EOF
+d1/d2/d4/d5:
+ flags:a
+ owner:rw--------------::mask
+ group:rw--------------::mask
+ other:----------------::mask
+   101:rw--------------:a:allow
+   102:rw--------------:a:deny
+   101:rw--------------:ga:deny
+EOF
+
+# No automatic inheritance for protected files
+check "getrichacl --numeric --raw d1/d6" <<EOF
+d1/d6:
+ flags:map
+ owner:----------------::mask
+ group:----------------::mask
+ other:----------------::mask
+   101:rw--------------:fda:deny
+   102:rw--------------:fia:deny
+   103:rw--------------:da:deny
+   101:rw--------------:fdiga:deny
+EOF
+
+check "getrichacl --numeric --raw d1/d7" <<EOF
+d1/d7:
+ flags:map
+ owner:----------------::mask
+ group:----------------::mask
+ other:----------------::mask
+   101:rw--------------:a:deny
+   102:rw--------------:a:deny
+   101:rw--------------:ga:deny
+EOF
diff --git a/tests/richacl/basic b/tests/richacl/basic
new file mode 100755
index 0000000..3c3d0e0
--- /dev/null
+++ b/tests/richacl/basic
@@ -0,0 +1,97 @@
+#! /bin/sh
+
+. ${0%/*}/test-lib.sh
+
+require_richacls
+require_getfattr
+use_tmpdir
+
+umask 022
+
+ncheck "touch x"
+ncheck "setrichacl --set 'everyone@:rwp::allow' x"
+check "ls -l x | sed -e 's/[. ].*//'" <<EOF
+-rw-rw-rw-
+EOF
+
+check "getrichacl x" <<EOF
+x:
+ everyone@:rwp----------::allow
+EOF
+
+ncheck 'chmod 664 x'
+check "ls -l x | sed -e 's/[. ].*//'" <<EOF
+-rw-rw-r--
+EOF
+
+check "getrichacl x" <<EOF
+x:
+    owner@:rwp----------::allow
+    group@:rwp----------::allow
+ everyone@:r------------::allow
+EOF
+
+# Note that unlike how the test cases look at first sight, we do *not* require
+# a richacl-enabled version of ls here ...
+
+ncheck "mkdir sub"
+ncheck "setrichacl --set 'everyone@:rwpxd:fd:allow' sub"
+check "ls -dl sub | sed -e 's/[.+ ].*/+/'" <<EOF
+drwxrwxrwx+
+EOF
+
+#check 'getfattr sub | grep -e system\.richacl' <<EOF
+check 'getfattr -m system\.richacl sub' <<EOF
+# file: sub
+system.richacl
+EOF
+
+ncheck "chmod 775 sub"
+check "ls -dl sub | sed -e 's/[.+ ].*/+/'" <<EOF
+drwxrwxr-x+
+EOF
+
+check 'getfattr -m system\.richacl sub' <<EOF
+# file: sub
+system.richacl
+EOF
+
+check "getrichacl sub" <<EOF
+sub:
+    owner@:rwpxd--------::allow
+    group@:rwpxd--------::allow
+ everyone@:rwpxd--------:fdi:allow
+ everyone@:r--x---------::allow
+EOF
+
+ncheck "touch sub/f"
+check "ls -l sub/f | sed -e 's/[. ].*//'" <<EOF
+-rw-rw-rw-
+EOF
+
+check "getrichacl sub/f" <<EOF
+sub/f:
+ everyone@:rwp----------::allow
+EOF
+
+ncheck "mkdir sub/sub2"
+check "ls -dl sub/sub2 | sed -e 's/[.+ ].*/+/'" <<EOF
+drwxrwxrwx+
+EOF
+
+check "getrichacl sub/sub2" <<EOF
+sub/sub2:
+ everyone@:rwpxd--------:fd:allow
+EOF
+
+ncheck "mkdir -m 750 sub/sub3"
+check "ls -dl sub/sub3 | sed -e 's/[.+ ].*/+/'" <<EOF
+drwxr-x---+
+EOF
+
+check "getrichacl sub/sub3" <<EOF
+sub/sub3:
+    owner@:rwpxd--------::allow
+    group@:r--x---------::allow
+ everyone@:rwpxd--------:fdi:allow
+EOF
diff --git a/tests/richacl/chmod b/tests/richacl/chmod
new file mode 100755
index 0000000..1b229f0
--- /dev/null
+++ b/tests/richacl/chmod
@@ -0,0 +1,40 @@
+#! /bin/sh
+
+. ${0%/*}/test-lib.sh
+
+require_runas
+require_richacls
+use_tmpdir
+
+export LC_ALL=C
+
+# Create file as root
+ncheck "touch a"
+
+# We cannot set the acl as another user
+runas -u 99 -g 99
+check "setrichacl --set '99:rwc::allow' a || echo status: \$?" <<EOF
+a: Operation not permitted
+status: 1
+EOF
+
+# We cannot chmod as another user
+check "chmod 666 a || echo status: \$?" <<EOF
+chmod: changing permissions of 'a': Operation not permitted
+status: 1
+EOF
+
+# Give user 99 the write_acl permission
+runas
+ncheck "setrichacl --set '99:rwpC::allow' a"
+
+# Now user 99 can setrichacl and chmod ...
+runas -u 99 -g 99
+ncheck "setrichacl --set '99:rwpC::allow' a"
+ncheck "chmod 666 a"
+
+# ... but chmod disables the write_acl permission
+check "setrichacl --set '99:rwpC::allow' a || echo status: \$?" <<EOF
+a: Operation not permitted
+status: 1
+EOF
diff --git a/tests/richacl/chown b/tests/richacl/chown
new file mode 100755
index 0000000..2f1389e
--- /dev/null
+++ b/tests/richacl/chown
@@ -0,0 +1,42 @@
+#! /bin/sh
+
+. ${0%/*}/test-lib.sh
+
+require_runas
+require_richacls
+use_tmpdir
+
+export LC_ALL=C
+
+# Create file as root
+ncheck "touch a"
+
+# Chown and chgrp with no take ownership permission fails
+runas -u 99 -g 99
+check "chown 99 a || echo status: \$?" <<EOF
+chown: changing ownership of 'a': Operation not permitted
+status: 1
+EOF
+check "chgrp 99 a || echo status: \$?" <<EOF
+chgrp: changing group of 'a': Operation not permitted
+status: 1
+EOF
+
+# Add the take_ownership permission
+runas
+ncheck "setrichacl --set '99:rwpo::allow' a"
+
+# Chown and chgrp to a user or group the process is not in fails
+runas -u 99 -g 99
+check "chown 100 a || echo status: \$?" <<EOF
+chown: changing ownership of 'a': Operation not permitted
+status: 1
+EOF
+check "chgrp 100 a || echo status: \$?" <<EOF
+chgrp: changing group of 'a': Operation not permitted
+status: 1
+EOF
+
+# Chown and chgrp to a user and group the process is in succeeds
+ncheck "chown 99 a"
+ncheck "chgrp 99 a"
diff --git a/tests/richacl/create b/tests/richacl/create
new file mode 100755
index 0000000..d3d0b98
--- /dev/null
+++ b/tests/richacl/create
@@ -0,0 +1,36 @@
+#! /bin/sh
+
+. ${0%/*}/test-lib.sh
+
+require_runas
+require_richacls
+use_tmpdir
+
+export LC_ALL=C
+
+# Create directories as root with different permissions
+ncheck "mkdir d1 d2 d3"
+ncheck "setrichacl --set '99:wx::allow' d2"
+ncheck "setrichacl --set '99:px::allow' d3"
+
+runas -u 99 -g 99
+
+# Cannot create files or directories without permissions
+check "touch d1/f || :" <<EOF
+touch: cannot touch 'd1/f': Permission denied
+EOF
+check "mkdir d1/d || :" <<EOF
+mkdir: cannot create directory 'd1/d': Permission denied
+EOF
+
+# Can create files with add_file (w) permission
+ncheck "touch d2/f"
+check "mkdir d2/d || :" <<EOF
+mkdir: cannot create directory 'd2/d': Permission denied
+EOF
+
+# Can create directories with add_subdirectory (p) permission
+check "touch d3/f || :" <<EOF
+touch: cannot touch 'd3/f': Permission denied
+EOF
+ncheck "mkdir d3/d"
diff --git a/tests/richacl/ctime b/tests/richacl/ctime
new file mode 100755
index 0000000..b737218
--- /dev/null
+++ b/tests/richacl/ctime
@@ -0,0 +1,35 @@
+#! /bin/sh
+
+. ${0%/*}/test-lib.sh
+
+require_runas
+require_richacls
+use_tmpdir
+
+export LC_ALL=C
+
+ncheck "touch a"
+
+# Without write access, the ctime cannot be changed
+runas -u 99 -g 99
+check "touch a || :" <<EOF
+touch: cannot touch 'a': Permission denied
+EOF
+
+runas
+ncheck "setrichacl --set '99:rw::allow' a"
+
+# With write access, the ctime can be set to the current time, but not to
+# any other time
+runas -u 99 -g 99
+ncheck "touch a"
+check "touch -d '1 hour ago' a || :" <<EOF
+touch: setting times of 'a': Operation not permitted
+EOF
+
+runas
+ncheck "setrichacl --set '99:rwA::allow' a"
+
+# With set_attributes access, the ctime can be set to an arbitrary time
+runas -u 99 -g 99
+ncheck "touch -d '1 hour ago' a"
diff --git a/tests/richacl/delete b/tests/richacl/delete
new file mode 100755
index 0000000..ec4a50f
--- /dev/null
+++ b/tests/richacl/delete
@@ -0,0 +1,89 @@
+#! /bin/sh
+
+. ${0%/*}/test-lib.sh
+
+require_runas
+require_richacls
+use_tmpdir
+
+umask 022
+export LC_ALL=C
+
+ncheck "chmod go+w ."
+ncheck "mkdir d1 d2 d3 d4 d5 d6 d7"
+ncheck "touch d1/f d1/g d2/f d3/f d4/f d5/f d6/f d7/f d7/g d7/h"
+ncheck "chmod o+w d1/g"
+ncheck "chown 99 d2"
+ncheck "chgrp 99 d3"
+ncheck "chmod g+w d3"
+ncheck "setrichacl --set '99:wx::allow' d4"
+ncheck "setrichacl --set '99:d::allow' d5"
+ncheck "setrichacl --set '99:xd::allow' d6"
+ncheck "setrichacl --set '99:D::allow' d7/f d7/g d7/h"
+ncheck "chmod 664 d7/g"
+
+ncheck "mkdir s2 s3 s4 s5 s6 s7"
+ncheck "chmod +t s2 s3 s4 s5 s6 s7"
+ncheck "touch s2/f s3/f s4/f s5/f s6/f s7/f s7/g s7/h"
+ncheck "chown 99 s2"
+ncheck "chgrp 99 s3"
+ncheck "chmod g+w s3"
+ncheck "setrichacl --set '99:wx::allow' s4"
+ncheck "setrichacl --set '99:d::allow' s5"
+ncheck "setrichacl --set '99:xd::allow' s6"
+ncheck "setrichacl --set '99:D::allow' s7/f s7/g s7/h"
+ncheck "chmod 664 s7/g"
+
+runas -u 99 -g 99
+
+# Cannot delete files with no or only with write permissions on the directory
+check "rm -f d1/f d1/g || :" <<EOF
+rm: cannot remove 'd1/f': Permission denied
+rm: cannot remove 'd1/g': Permission denied
+EOF
+
+# Can delete files in directories we own
+ncheck "rm -f d2/f s2/f"
+
+# Can delete files in non-sticky directories we have write access to
+check "rm -f d3/f s3/f || :" <<EOF
+rm: cannot remove 's3/f': Operation not permitted
+EOF
+
+# "Write_data/execute" access does not include delete_child access, so deleting
+# is not allowed:
+check "rm -f d4/f s4/f || :" <<EOF
+rm: cannot remove 'd4/f': Permission denied
+rm: cannot remove 's4/f': Permission denied
+EOF
+
+# "Delete_child" access alone also is not sufficient
+check "rm -f d5/f s5/f || :" <<EOF
+rm: cannot remove 'd5/f': Permission denied
+rm: cannot remove 's5/f': Permission denied
+EOF
+
+# "Execute/delete_child" access is sufficient for non-sticky directories
+check "rm -f d6/f s6/f || :" <<EOF
+rm: cannot remove 's6/f': Operation not permitted
+EOF
+
+# "Delete" access on the child is sufficient, even in sticky directories.
+check "rm -f d7/f s7/f || :" <<EOF
+EOF
+
+# Regression: Delete access must not override add_file / add_subdirectory
+# access.
+ncheck "touch h"
+check "mv h d7/h || :" <<EOF
+mv: cannot move 'h' to 'd7/h': Permission denied
+EOF
+check "mv h s7/h || :" <<EOF
+mv: cannot move 'h' to 's7/h': Permission denied
+EOF
+
+# A chmod turns off the "delete" permission
+check "rm -f d7/g s7/g || :" <<EOF
+rm: cannot remove 'd7/g': Permission denied
+rm: cannot remove 's7/g': Permission denied
+EOF
diff --git a/tests/richacl/group b/tests/richacl/group
new file mode 100644
index 0000000..1fb29f5
--- /dev/null
+++ b/tests/richacl/group
@@ -0,0 +1,15 @@
+# QA groups control file
+# Defines test groups and nominal group owners
+# - do not start group names with a digit
+# - comment line before each group is "new" description
+#
+001-apply-masks richacl
+002-auto-inheritance richacl
+003-basic richacl
+004-chmod richacl
+005-chown richacl
+006-create richacl
+007-ctime richacl
+008-delete richacl
+009-setrichacl-modify richacl
+010-write-vs-append richacl
diff --git a/tests/richacl/setrichacl-modify b/tests/richacl/setrichacl-modify
new file mode 100755
index 0000000..1ff6ae4
--- /dev/null
+++ b/tests/richacl/setrichacl-modify
@@ -0,0 +1,57 @@
+#! /bin/sh
+
+. ${0%/*}/test-lib.sh
+
+require_richacls
+use_tmpdir
+
+umask 022
+
+ncheck "touch f"
+ncheck "setrichacl --set 'flags:a 101:w::deny 101:rw::allow 101:w:a:deny 101:rw:a:allow' f"
+ncheck "setrichacl --modify '202:w::deny' f"
+check "getrichacl --numeric f" <<EOF
+f:
+ flags:a
+   101:-w-----------::deny
+   202:-w-----------::deny
+   101:rw-----------::allow
+   101:-w-----------:a:deny
+   101:rw-----------:a:allow
+EOF
+
+ncheck "setrichacl --set 'flags:a 101:w::deny 101:rw::allow 101:w:a:deny 101:rw:a:allow' f"
+ncheck "setrichacl --modify '202:rw::allow' f"
+check "getrichacl --numeric f" <<EOF
+f:
+ flags:a
+   101:-w-----------::deny
+   101:rw-----------::allow
+   202:rw-----------::allow
+   101:-w-----------:a:deny
+   101:rw-----------:a:allow
+EOF
+
+ncheck "setrichacl --set 'flags:a 101:w::deny 101:rw::allow 101:w:a:deny 101:rw:a:allow' f"
+ncheck "setrichacl --modify '202:w:a:deny' f"
+check "getrichacl --numeric f" <<EOF
+f:
+ flags:a
+   101:-w-----------::deny
+   101:rw-----------::allow
+   101:-w-----------:a:deny
+   202:-w-----------:a:deny
+   101:rw-----------:a:allow
+EOF
+
+ncheck "setrichacl --set 'flags:a 101:w::deny 101:rw::allow 101:w:a:deny 101:rw:a:allow' f"
+ncheck "setrichacl --modify ' 202:rw:a:allow' f"
+check "getrichacl --numeric f" <<EOF
+f:
+ flags:a
+   101:-w-----------::deny
+   101:rw-----------::allow
+   101:-w-----------:a:deny
+   101:rw-----------:a:allow
+   202:rw-----------:a:allow
+EOF
diff --git a/tests/richacl/test-lib.sh b/tests/richacl/test-lib.sh
new file mode 100644
index 0000000..4f264f4
--- /dev/null
+++ b/tests/richacl/test-lib.sh
@@ -0,0 +1,149 @@
+# Library for simple test scripts
+# Copyright (C) 2009, 2011-2013 Free Software Foundation, Inc.
+#
+# Copying and distribution of this file, with or without modification,
+# in any medium, are permitted without royalty provided the copyright
+# notice and this notice are preserved.
+
+use_tmpdir() {
+    tmpdir=$PWD/tmp.$$
+    mkdir "$tmpdir" && cd "$tmpdir" || exit 2
+}
+
+require_runas() {
+    if ! $here/src/runas -u 99 -g 99 true ; then
+	echo "This test must be run as root" >&2
+	exit 77
+    fi
+}
+
+require_richacls() {
+    $here/src/require-richacls || exit $?
+    if ! type -f getrichacl setrichacl > /dev/null; then
+	echo "This test requires the getrichacl and setrichacl utilities" >&2
+	exit 77
+    fi
+}
+
+require_getfattr() {
+    if ! type -f getfattr > /dev/null ; then
+	echo "This test requires the getfattr utility" >&2
+	exit 77
+    fi
+}
+
+_RUNAS=
+runas() {
+    _start_test -1 runas "$*"
+    if [ $# = 0 ]; then
+	_RUNAS=
+    else
+	_RUNAS="$here/src/runas $* --"
+    fi
+    echo "ok"
+}
+
+if diff -u -L expected -L got /dev/null /dev/null 2> /dev/null; then
+    eval '_compare() {
+	diff -u -L expected -L got "$1" "$2"
+    }'
+else
+    eval '_compare() {
+	echo "expected:"
+	cat "$1"
+	echo "got:"
+	cat "$2"
+    }'
+fi
+
+_check() {
+    local frame=$1
+    shift
+    _start_test "$frame" "$*"
+    expected=`cat`
+    if got=`set +x; eval "$_RUNAS $*" 3>&2 </dev/null 2>&1` && \
+            test "$expected" = "$got" ; then
+	echo "ok"
+	checks_succeeded="$checks_succeeded + 1"
+    else
+	echo "FAILED"
+	if test "$expected" != "$got" ; then
+	    echo "$expected" > expected~
+	    echo "$got" > got~
+	    _compare expected~ got~
+	    rm -f expected~ got~
+	fi
+	checks_failed="$checks_failed + 1"
+    fi
+}
+
+check() {
+    _check 0 "$@"
+}
+
+ncheck() {
+    _check 0 "$@" < /dev/null
+}
+
+parent_check() {
+    _check 1 "$@"
+}
+
+parent_ncheck() {
+    _check 1 "$@" < /dev/null
+}
+
+cleanup() {
+    status=$?
+    checks_succeeded=`expr $checks_succeeded`
+    checks_failed=`expr $checks_failed`
+    checks_total=`expr $checks_succeeded + $checks_failed`
+    if test $checks_total -gt 0 ; then
+	if test $checks_failed -gt 0 && test $status -eq 0 ; then
+	    status=1
+	fi
+	echo "$checks_total tests ($checks_succeeded passed," \
+	     "$checks_failed failed)"
+    fi
+    if test -n "$tmpdir" ; then
+	chmod -R u+rwx "$tmpdir" 2>/dev/null
+	cd / && rm -rf "$tmpdir"
+    fi
+    exit $status
+}
+
+if test -z "`echo -n`"; then
+    if eval 'test -n "${BASH_LINENO[0]}" 2>/dev/null'; then
+	eval '
+	    _start_test() {
+		local frame=$1
+		shift
+		printf "[${BASH_LINENO[2+frame]}] $* -- "
+	    }'
+    else
+	eval '
+	    _start_test() {
+		shift
+		printf "* $* -- "
+	    }'
+    fi
+else
+    eval '
+	_start_test() {
+	    shift
+	    printf "* $*\\n"
+	}'
+fi
+
+if ! type cat > /dev/null 2> /dev/null; then
+    echo "This test requires the cat utility" >&2
+    exit 77
+fi
+
+export PATH=$here/src:$PATH
+
+[ -z "$TEST_DIR" ] || cd "$TEST_DIR"
+
+checks_succeeded=0
+checks_failed=0
+trap cleanup 0
diff --git a/tests/richacl/write-vs-append b/tests/richacl/write-vs-append
new file mode 100755
index 0000000..4528f3a
--- /dev/null
+++ b/tests/richacl/write-vs-append
@@ -0,0 +1,54 @@
+#! /bin/sh
+
+. ${0%/*}/test-lib.sh
+
+require_runas
+require_richacls
+use_tmpdir
+
+export LC_ALL=C
+
+ncheck "touch a b c d e f"
+ncheck "setrichacl --set 'owner@:rwp::allow' a"
+ncheck "setrichacl --set 'owner@:rwp::allow 99:w::allow' b"
+ncheck "setrichacl --set 'owner@:rwp::allow 99:p::allow' c"
+ncheck "setrichacl --set 'owner@:rwp::allow 99:wp::allow' d"
+ncheck "setrichacl --set '99:a::deny owner@:rwp::allow 99:w::allow' e"
+ncheck "setrichacl --set '99:w::deny owner@:rwp::allow 99:p::allow' f"
+
+runas -u 99 -g 99
+check "sh -c 'echo a > a' || :" <<EOF
+sh: a: Permission denied
+EOF
+ncheck "sh -c 'echo b > b' || :"
+check "sh -c 'echo c > c' || :" <<EOF
+sh: c: Permission denied
+EOF
+ncheck "sh -c 'echo d > d' || :"
+ncheck "sh -c 'echo e > e' || :"
+check "sh -c 'echo f > f' || :" <<EOF
+sh: f: Permission denied
+EOF
+
+check "sh -c 'echo A >> a' || :" <<EOF
+sh: a: Permission denied
+EOF
+check "sh -c 'echo B >> b' || :" <<EOF
+sh: b: Permission denied
+EOF
+ncheck "sh -c 'echo C >> c' || :"
+ncheck "sh -c 'echo D >> d' || :"
+check "sh -c 'echo E >> e' || :" <<EOF
+sh: e: Permission denied
+EOF
+ncheck "sh -c 'echo F >> f' || :"
+
+runas
+check "cat a b c d e f" <<EOF
+b
+C
+d
+D
+e
+F
+EOF
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
