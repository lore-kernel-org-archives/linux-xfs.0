Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51270 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754264AbdDFIgN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 6 Apr 2017 04:36:13 -0400
Subject: [PATCH 4/4] xfstests: Check the stx_attributes settable by chattr
 [ver #10]
From: David Howells <dhowells@redhat.com>
Date: Thu, 06 Apr 2017 09:36:10 +0100
Message-ID: <149146777070.12770.11964173659473823270.stgit@warthog.procyon.org.uk>
In-Reply-To: <149146774821.12770.3592235770964461857.stgit@warthog.procyon.org.uk>
References: <149146774821.12770.3592235770964461857.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: hch@infradead.org, amir73il@gmail.com, david@fromorbit.com, fstests@vger.kernel.org, dhowells@redhat.com, linux-fsdevel@vger.kernel.org

Check the stx_attributes that can be set by calling chattr.

The script probes the filesystem with chattr to find out which of +a, +c,
+d and +i are supported before testing combinations of attrs.  Note that if
a filesystem supports chattr with these, but doesn't paste the flag values
into stx_attributes, the test will fail as there's no way to distinguish
cleared from unset.

Certain chattr flags are reflected in specific stx_attributes flags:

	chattr flag	stx_attributes flag
	+a		STATX_ATTR_APPEND
	+c		STATX_ATTR_COMPRESSED
	+d		STATX_ATTR_NODUMP
	+i		STATX_ATTR_IMMUTABLE

Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---

 doc/requirement-checking.txt |   22 +++++-
 src/stat_test.c              |   71 ++++++++++++++++++
 tests/generic/423            |  164 ++++++++++++++++++++++++++++++++++++++++++
 tests/generic/423.out        |    2 +
 tests/generic/group          |    1 
 5 files changed, 259 insertions(+), 1 deletion(-)
 create mode 100755 tests/generic/423
 create mode 100644 tests/generic/423.out

diff --git a/doc/requirement-checking.txt b/doc/requirement-checking.txt
index f3fc9f4..730c7ac 100644
--- a/doc/requirement-checking.txt
+++ b/doc/requirement-checking.txt
@@ -12,7 +12,11 @@ they have.  This is done with _require_<xxx> macros, which may take parameters.
 	_require_test_program <name>
 	_require_xfs_io_command <name> [<switch>]
 
- (2) System call requirements.
+ (2) Filesystem capability requirements.
+
+	_require_chattr <letters>
+
+ (3) System call requirements.
 
 	_require_statx
 
@@ -67,6 +71,22 @@ _require_xfs_io_command <name> [<switch>]
      the +x and -x arguments (DAX attribute).
 
 
+==================================
+FILESYSTEM CAPABILITY REQUIREMENTS
+==================================
+
+_require_chattr <letters>
+
+     The test requires that the filesystem attribute set by the chattr command
+     with +<letters> as an argument be available and supported by the $TEST_DEV
+     filesystem.  No check is made of the scratch filesystem.  For example:
+
+	_require_chattr ai
+
+     tests to see if setting the append-only and immutable attributes on a file
+     (chattr +a +i) is supported.
+
+
 ========================
 SYSTEM CALL REQUIREMENTS
 ========================
diff --git a/src/stat_test.c b/src/stat_test.c
index 3d7e275..3dc44bb 100644
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
@@ -565,6 +596,40 @@ static void check_field(const struct statx *stx, char *arg)
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
@@ -670,6 +735,12 @@ int main(int argc, char **argv)
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
diff --git a/tests/generic/423 b/tests/generic/423
new file mode 100755
index 0000000..75581ab
--- /dev/null
+++ b/tests/generic/423
@@ -0,0 +1,164 @@
+#! /bin/bash
+# FS QA Test 423
+#
+# Test the statx stx_attribute flags that can be set with chattr
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2017 Red Hat, Inc.  All Rights Reserved.
+# Written by David Howells (dhowells@redhat.com)
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
+status=1
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+	$CHATTR_PROG -a -i $testfile
+	rm -f $testfile
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
+_require_test_program stat_test
+_require_statx
+_require_command "$CHATTR_PROG" chattr
+
+function check_stat () {
+    $here/src/stat_test $* || echo stat_test failed
+}
+
+testfile=$TEST_DIR/$seq-file
+touch $testfile
+
+# Work out what chattrs are supported on the fs under test
+a_supported=""
+c_supported=""
+d_supported=""
+i_supported=""
+a_list="0"
+c_list="0"
+d_list="0"
+i_list="0"
+
+if $CHATTR_PROG +a $testfile >&/dev/null
+then
+    a_supported=1
+    a_list="+a -a"
+fi
+
+if $CHATTR_PROG +c $testfile >&/dev/null
+then
+    c_supported=1
+    c_list="+c -c"
+fi
+
+if $CHATTR_PROG +d $testfile >&/dev/null
+then
+    d_supported=1
+    d_list="+d -d"
+fi
+
+if $CHATTR_PROG +i $testfile >&/dev/null
+then
+    i_supported=1
+    i_list="+i -i"
+fi
+
+echo "a=$a_supported d=$d_supported c=$c_supported i=$i_supported" >>$seqres.full
+
+if [ "$a_supported$c_supported$d_supported$i_supported" = "" ]
+then
+    _notrun "file system doesn't support any of $CHATTR_PROG +a/+c/+d/+i"
+fi
+
+$CHATTR_PROG -a -c -d -i $testfile
+
+###############################################################################
+#
+# Now do the actual test.  We can turn on and off append (a), compressed (c),
+# immutable (i) and no-dump (d) and theoretically see the output in the
+# attribute flags.  The following associations can be seen:
+#
+#	$CHATTR_PROG flag	stx_attributes flag
+#	+a		STATX_ATTR_APPEND
+#	+c		STATX_ATTR_COMPRESSED
+#	+d		STATX_ATTR_NODUMP
+#	+i		STATX_ATTR_IMMUTABLE
+#
+# Note, however, that if the filesystem doesn't paste this information into
+# stx_attributes, there's no way to tell the difference between cleared and
+# unset.
+#
+###############################################################################
+function try () {
+    echo Trying "$*" >>$seqres.full
+    $CHATTR_PROG ${a_supported:+$1} \
+	   ${c_supported:+$2} \
+	   ${d_supported:+$3} \
+	   ${i_supported:+$4} \
+	   $testfile
+    check_stat $testfile \
+	       ${a_supported:+attr=${1/a/append}} \
+	       ${c_supported:+attr=${2/c/compressed}} \
+	       ${d_supported:+attr=${3/d/nodump}} \
+	       ${i_supported:+attr=${4/i/immutable}} \
+	       stx_type=file \
+	       stx_size=0 \
+	       stx_rdev_major=0 \
+	       stx_rdev_minor=0 \
+	       stx_nlink=1
+}
+
+for a in $a_list
+do
+    for c in $c_list
+    do
+	for d in $d_list
+	do
+	    for i in $i_list
+	    do
+		try $a $c $d $i
+	    done
+	done
+    done
+done
+
+# For tradition's sake
+echo "Silence is golden"
+
+# Done.  We leave the success determination to the output comparator.
+status=0
+exit
diff --git a/tests/generic/423.out b/tests/generic/423.out
new file mode 100644
index 0000000..22c4029
--- /dev/null
+++ b/tests/generic/423.out
@@ -0,0 +1,2 @@
+QA output created by 423
+Silence is golden
diff --git a/tests/generic/group b/tests/generic/group
index d747385..52553fa 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -425,3 +425,4 @@
 420 auto quick punch
 421 auto quick encrypt dangerous
 422 auto quick
+423 auto quick

