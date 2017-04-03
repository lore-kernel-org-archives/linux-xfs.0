Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45298 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751868AbdDCLum (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 3 Apr 2017 07:50:42 -0400
Subject: [PATCH 4/4] xfstests: Check the stx_attributes settable by chattr
 [ver #2]
From: David Howells <dhowells@redhat.com>
Date: Mon, 03 Apr 2017 12:50:39 +0100
Message-ID: <149122023941.24468.4103258611437354896.stgit@warthog.procyon.org.uk>
In-Reply-To: <149122021217.24468.17499686793235286404.stgit@warthog.procyon.org.uk>
References: <149122021217.24468.17499686793235286404.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: hch@infradead.org, amir73il@gmail.com, david@fromorbit.com, fstests@vger.kernel.org, dhowells@redhat.com, linux-fsdevel@vger.kernel.org

Check the stx_attributes that can be set by calling chattr.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 doc/requirement-checking.txt |   16 +++++++
 src/stat_test.c              |   71 ++++++++++++++++++++++++++++++++
 tests/generic/421            |   94 ++++++++++++++++++++++++++++++++++++++++++
 tests/generic/421.out        |    1 
 tests/generic/group          |    1 
 5 files changed, 182 insertions(+), 1 deletion(-)
 create mode 100755 tests/generic/421
 create mode 100644 tests/generic/421.out

diff --git a/doc/requirement-checking.txt b/doc/requirement-checking.txt
index 29f0b74..523b27f 100644
--- a/doc/requirement-checking.txt
+++ b/doc/requirement-checking.txt
@@ -12,7 +12,11 @@ they have.  This is done with _require_<xxx> macros, which may take parameters.
 	_require_test_program
 	_require_xfs_io_command
 
- (2) System call requirements.
+ (2) Filesystem capability requirements.
+
+	_require_chattr
+
+ (3) System call requirements.
 
 	_require_statx
 
@@ -59,6 +63,16 @@ _require_xfs_io_command "falloc"
      the 'falloc' command.
 
 
+==================================
+FILESYSTEM CAPABILITY REQUIREMENTS
+==================================
+
+_require_chattr
+
+     The test requires that the chattr command be available and supported by
+     the $TEST_DEV filesystem.  No check is made of the scratch filesystem.
+
+
 ========================
 SYSTEM CALL REQUIREMENTS
 ========================
diff --git a/src/stat_test.c b/src/stat_test.c
index cb3d4f4..b1205ec 100644
--- a/src/stat_test.c
+++ b/src/stat_test.c
@@ -102,6 +102,30 @@ static int field_cmp(const void *_key, const void *_p)
 	return strcmp(key, p->name);
 }
 
+/*
+ * Sorted list of attribute flags for bsearch().
+ */
+struct attr_name {
+	const char	*name;
+	__u64		attr_flag;
+};
+
+static const struct attr_name attr_list[] = {
+	{ "append",	STATX_ATTR_APPEND },
+	{ "automount",	STATX_ATTR_AUTOMOUNT },
+	{ "compressed",	STATX_ATTR_COMPRESSED },
+	{ "encrypted",	STATX_ATTR_ENCRYPTED },
+	{ "immutable",	STATX_ATTR_IMMUTABLE },
+	{ "nodump",	STATX_ATTR_NODUMP },
+};
+
+static int attr_name_cmp(const void *_key, const void *_p)
+{
+	const char *key = _key;
+	const struct attr_name *p = _p;
+	return strcmp(key, p->name);
+}
+
 struct file_type {
 	const char *name;
 	mode_t mode;
@@ -128,6 +152,13 @@ void format(void)
 	fprintf(stderr, "usage: %s [-v] [-m<mask>] <testfile> [checks]\n", prog);
 	fprintf(stderr, "\t<mask> can be basic, all or a number; all is the default\n");
 	fprintf(stderr, "checks is a list of zero or more of:\n");
+	fprintf(stderr, "\tattr=[+-]<name> -- check an attribute in stx_attributes\n");
+	fprintf(stderr, "\t\tappend -- The file is marked as append only\n");
+	fprintf(stderr, "\t\tautomount -- The object is an automount point\n");
+	fprintf(stderr, "\t\tcompressed -- The file is marked as compressed\n");
+	fprintf(stderr, "\t\tencrypted -- The file is marked as encrypted\n");
+	fprintf(stderr, "\t\timmutable -- The file is marked as immutable\n");
+	fprintf(stderr, "\t\tnodump -- The file is marked as no-dump\n");
 	fprintf(stderr, "\tcmp_ref -- check that the reference file has identical stats\n");
 	fprintf(stderr, "\tref=<file> -- get reference stats from file\n");
 	fprintf(stderr, "\tstx_<field>=<val> -- statx field value check\n");
@@ -564,6 +595,40 @@ static void check_field(const struct statx *stx, char *arg)
 }
 
 /*
+ * Check attributes in stx_attributes.  When stx_attributes_mask gets in
+ * upstream, we will need to consider that also.
+ */
+static void check_attribute(const struct statx *stx, char *arg)
+{
+	const struct attr_name *p;
+	__u64 attr;
+	bool set;
+
+	verbose("check attr %s\n", arg);
+	switch (arg[0]) {
+	case '+': set = true;	break;
+	case '-': set = false;	break;
+	default:
+		bad_arg("attr flag must be marked + (set) or - (unset)\n");
+	}
+	arg++;
+
+	p = bsearch(arg, attr_list, sizeof(attr_list) / sizeof(attr_list[0]),
+		    sizeof(attr_list[0]), attr_name_cmp);
+	if (!p)
+		bad_arg("Unrecognised attr name '%s'\n", arg);
+
+	attr = p->attr_flag;
+	if (set) {
+		check(stx->stx_attributes && attr,
+		      "Attribute %s should be set\n", arg);
+	} else {
+		check(~stx->stx_attributes && attr,
+		      "Attribute %s should be unset\n", arg);
+	}
+}
+
+/*
  * Do the testing.
  */
 int main(int argc, char **argv)
@@ -669,6 +734,12 @@ int main(int argc, char **argv)
 	for (; *argv; argv++) {
 		char *arg = *argv;
 
+		if (strncmp("attr=", arg, 5) == 0) {
+			/* attr=[+-]<attr> - check attribute flag */
+			check_attribute(&stx, arg + 5);
+			continue;
+		}
+
 		if (strcmp("cmp_ref", arg) == 0) {
 			/* cmp_ref - check ref file has same stats */
 			cmp_ref(&stx, mask);
diff --git a/tests/generic/421 b/tests/generic/421
new file mode 100755
index 0000000..3db0b04
--- /dev/null
+++ b/tests/generic/421
@@ -0,0 +1,94 @@
+#! /bin/bash
+# FS QA Test 421
+#
+# Test the statx stx_attribute flags that can be set with chattr
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2017 YOUR NAME HERE.  All Rights Reserved.
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
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=0
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+	rm -f $seq-file
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs generic
+_supported_os IRIX Linux
+_require_test
+_require_test_program "stat_test"
+_require_statx
+_require_chattr
+
+function check_stat () {
+    $here/src/stat_test $* || echo stat_test failed
+}
+
+touch $seq-file
+
+function try () {
+    chattr $* $seq-file
+    check_stat $seq-file \
+	       attr=${1/a/append} \
+	       attr=${2/c/compressed} \
+	       attr=${3/i/immutable} \
+	       attr=${4/d/nodump} \
+	       stx_type=file \
+	       stx_size=0 \
+	       stx_rdev_major=0 \
+	       stx_rdev_minor=0 \
+	       stx_nlink=1
+}
+
+# We can turn on and off append (a), compressed (c), immutable (i) and
+# no-dump (d)
+for a in +a -a
+do
+    for c in +c -c
+    do
+	for i in +i -i
+	do
+	    for d in +d -d
+	    do
+		try $a $c $i $d
+	    done
+	done
+    done
+done
+
+# Done.  We leave the success determination to the output comparator.
+exit
diff --git a/tests/generic/421.out b/tests/generic/421.out
new file mode 100644
index 0000000..984fb43
--- /dev/null
+++ b/tests/generic/421.out
@@ -0,0 +1 @@
+QA output created by 421
diff --git a/tests/generic/group b/tests/generic/group
index 5678101..f8b01fc 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -423,3 +423,4 @@
 418 auto rw
 419 auto quick encrypt
 420 auto quick
+421 auto quick

