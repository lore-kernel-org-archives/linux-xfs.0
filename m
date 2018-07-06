Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:44976 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932812AbeGFPBY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Jul 2018 11:01:24 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w66EwvjW064324
        for <linux-xfs@vger.kernel.org>; Fri, 6 Jul 2018 15:01:23 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2k0dnjt23d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 06 Jul 2018 15:01:23 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w66F1MQ5023393
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 6 Jul 2018 15:01:22 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w66F1MCV025720
        for <linux-xfs@vger.kernel.org>; Fri, 6 Jul 2018 15:01:22 GMT
Date: Fri, 6 Jul 2018 08:01:07 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [RFC DONOTAPPLY PATCH] xfstests: test mkfs.xfs config files
Message-ID: <20180706150107.GV32415@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

Simple tests of the upcoming mkfs.xfs config file feature.  First we
have some simple tests of properly formatted config files, then
improperly formatted config files, then we test any distro-supplied
config files, and finally we try to spot conflicts between config file
options and the cli.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/xfs        |   10 ++
 tests/xfs/716     |  276 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/716.out |   20 ++++
 tests/xfs/717     |  155 ++++++++++++++++++++++++++++++
 tests/xfs/717.out |   30 ++++++
 tests/xfs/718     |   64 ++++++++++++
 tests/xfs/718.out |    1 
 tests/xfs/719     |   59 +++++++++++
 tests/xfs/719.out |    2 
 tests/xfs/720     |   51 ++++++++++
 tests/xfs/720.out |    1 
 tests/xfs/721     |   65 ++++++++++++
 tests/xfs/721.out |    3 +
 tests/xfs/group   |    6 +
 14 files changed, 743 insertions(+)
 create mode 100755 tests/xfs/716
 create mode 100644 tests/xfs/716.out
 create mode 100755 tests/xfs/717
 create mode 100644 tests/xfs/717.out
 create mode 100755 tests/xfs/718
 create mode 100644 tests/xfs/718.out
 create mode 100755 tests/xfs/719
 create mode 100644 tests/xfs/719.out
 create mode 100755 tests/xfs/720
 create mode 100644 tests/xfs/720.out
 create mode 100755 tests/xfs/721
 create mode 100644 tests/xfs/721.out

diff --git a/common/xfs b/common/xfs
index 33d819d7..150129b0 100644
--- a/common/xfs
+++ b/common/xfs
@@ -605,6 +605,16 @@ _require_xfs_mkfs_ciname()
 		|| _notrun "need case-insensitive naming support in mkfs.xfs"
 }
 
+# this test requires mkfs.xfs have configuration file support
+_require_xfs_mkfs_cfgfile()
+{
+	echo > /tmp/a
+	_scratch_mkfs_xfs_supported -c /tmp/a >/dev/null 2>&1
+	res=$?
+	rm -rf /tmp/a
+	test $res -eq 0 || _notrun "need configuration file support in mkfs.xfs"
+}
+
 # XFS_DEBUG requirements
 _require_xfs_debug()
 {
diff --git a/tests/xfs/716 b/tests/xfs/716
new file mode 100755
index 00000000..0f5bdac9
--- /dev/null
+++ b/tests/xfs/716
@@ -0,0 +1,276 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Oracle.  All Rights Reserved.
+#
+# FS QA Test 716
+#
+# Feed valid mkfs config files to the mkfs parser to ensure that they are
+# recognized as valid.
+#
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap '_cleanup; exit $status' 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.* $def_cfgfile $fsimg
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
+_supported_os Linux
+_require_test
+_require_scratch_nocheck
+_require_xfs_mkfs_cfgfile
+
+def_cfgfile=$TEST_DIR/a
+fsimg=$TEST_DIR/a.img
+rm -rf $def_cfgfile $fsimg
+truncate -s 20t $fsimg
+
+test_mkfs_config() {
+	local cfgfile="$1"
+	if [ -z "$cfgfile" ] || [ "$cfgfile" = "-" ]; then
+		cfgfile=$def_cfgfile
+		cat > $cfgfile
+	fi
+	$MKFS_XFS_PROG -c $cfgfile -f -N $fsimg >> $seqres.full 2> $tmp.err
+	cat $tmp.err | _filter_test_dir
+}
+
+echo Simplest config file
+cat > $def_cfgfile << ENDL
+[metadata]
+crc = 0
+ENDL
+test_mkfs_config $def_cfgfile
+
+echo Piped-in config file
+test_mkfs_config << ENDL
+[metadata]
+crc = 0
+ENDL
+test_mkfs_config << ENDL
+[metadata]
+crc = 1
+ENDL
+
+echo Full line comment
+test_mkfs_config << ENDL
+# This is a full line comment.
+[metadata]
+crc = 0
+ENDL
+test_mkfs_config << ENDL
+ # This is a full line comment.
+[metadata]
+crc = 0
+ENDL
+test_mkfs_config << ENDL
+#This is a full line comment.
+[metadata]
+crc = 0
+ENDL
+
+echo End of line comment
+test_mkfs_config << ENDL
+[metadata]
+crc = 0 # This is an eol comment.
+ENDL
+test_mkfs_config << ENDL
+[metadata]
+crc = 0#This is an eol comment.
+ENDL
+test_mkfs_config << ENDL
+[metadata]
+crc = 0 #This is an eol comment.
+ENDL
+
+echo Multiple directives
+test_mkfs_config << ENDL
+[metadata]
+crc = 0
+finobt = 0
+ENDL
+
+echo Multiple sections
+test_mkfs_config << ENDL
+[metadata]
+crc = 0
+
+[inode]
+sparse = 0
+ENDL
+
+echo No directives at all
+test_mkfs_config << ENDL
+[metadata]
+ENDL
+
+echo Single space around the section name
+test_mkfs_config << ENDL
+ [metadata]
+crc = 0
+ENDL
+test_mkfs_config << ENDL
+[ metadata]
+crc = 0
+ENDL
+test_mkfs_config << ENDL
+[metadata ]
+crc = 0
+ENDL
+test_mkfs_config << ENDL
+[metadata] 
+crc = 0
+ENDL
+
+echo Two spaces around the section name
+test_mkfs_config << ENDL
+ [ metadata]
+crc = 0
+ENDL
+test_mkfs_config << ENDL
+ [metadata ]
+crc = 0
+ENDL
+test_mkfs_config << ENDL
+ [metadata] 
+crc = 0
+ENDL
+test_mkfs_config << ENDL
+[ metadata ]
+crc = 0
+ENDL
+test_mkfs_config << ENDL
+[ metadata] 
+crc = 0
+ENDL
+test_mkfs_config << ENDL
+[metadata ] 
+crc = 0
+ENDL
+
+echo Three spaces
+test_mkfs_config << ENDL
+ [ metadata ]
+crc = 0
+ENDL
+test_mkfs_config << ENDL
+ [metadata ] 
+crc = 0
+ENDL
+
+echo Four spaces
+test_mkfs_config << ENDL
+ [ metadata ] 
+crc = 0
+ENDL
+
+echo Mix of spaces and tabs
+test_mkfs_config << ENDL
+   	 		 	 [	  	 		metadata		  	  	    	  ] 	 	 	    	
+crc = 0
+ENDL
+
+echo Single space around the key/value directive
+test_mkfs_config << ENDL
+[metadata]
+ crc=0
+ENDL
+test_mkfs_config << ENDL
+[metadata]
+crc =0
+ENDL
+test_mkfs_config << ENDL
+[metadata]
+crc= 0
+ENDL
+test_mkfs_config << ENDL
+[metadata]
+crc=0 
+ENDL
+
+echo Two spaces around the key/value directive
+test_mkfs_config << ENDL
+[metadata]
+ crc =0
+ENDL
+test_mkfs_config << ENDL
+[metadata]
+ crc= 0
+ENDL
+test_mkfs_config << ENDL
+[metadata]
+ crc=0 
+ENDL
+test_mkfs_config << ENDL
+[metadata]
+crc = 0
+ENDL
+test_mkfs_config << ENDL
+[metadata]
+crc =0 
+ENDL
+test_mkfs_config << ENDL
+[metadata]
+crc= 0 
+ENDL
+
+echo Three spaces around the key/value directive
+test_mkfs_config << ENDL
+[metadata]
+ crc = 0
+ENDL
+test_mkfs_config << ENDL
+[metadata]
+ crc= 0 
+ENDL
+test_mkfs_config << ENDL
+[metadata]
+crc = 0 
+ENDL
+
+echo Four spaces around the key/value directive
+test_mkfs_config << ENDL
+[metadata]
+ crc = 0 
+ENDL
+
+echo Arbitrary spaces and tabs
+test_mkfs_config << ENDL
+[metadata]
+	  crc 	  	=   	  	 0	  	 	  
+ENDL
+
+echo ambiguous comment/section names
+test_mkfs_config << ENDL
+[metadata]
+#[data]
+crc = 0
+ENDL
+
+echo ambiguous comment/variable names
+test_mkfs_config << ENDL
+[metadata]
+#foo = 0 # is this a comment or a key '#foo' ?
+ENDL
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/716.out b/tests/xfs/716.out
new file mode 100644
index 00000000..b39f59ad
--- /dev/null
+++ b/tests/xfs/716.out
@@ -0,0 +1,20 @@
+QA output created by 716
+Simplest config file
+Piped-in config file
+Full line comment
+End of line comment
+Multiple directives
+Multiple sections
+No directives at all
+Single space around the section name
+Two spaces around the section name
+Three spaces
+Four spaces
+Mix of spaces and tabs
+Single space around the key/value directive
+Two spaces around the key/value directive
+Three spaces around the key/value directive
+Four spaces around the key/value directive
+Arbitrary spaces and tabs
+ambiguous comment/section names
+ambiguous comment/variable names
diff --git a/tests/xfs/717 b/tests/xfs/717
new file mode 100755
index 00000000..65df7ac3
--- /dev/null
+++ b/tests/xfs/717
@@ -0,0 +1,155 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Oracle.  All Rights Reserved.
+#
+# FS QA Test 717
+#
+# Feed invalid mkfs config files to the mkfs parser to ensure that they are
+# recognized as invalid.
+#
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap '_cleanup; exit $status' 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.* $def_cfgfile $fsimg
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
+_supported_os Linux
+_require_test
+_require_scratch_nocheck
+_require_xfs_mkfs_cfgfile
+
+def_cfgfile=$TEST_DIR/a
+fsimg=$TEST_DIR/a.img
+rm -rf $def_cfgfile $fsimg
+truncate -s 20t $fsimg
+
+test_mkfs_config() {
+	local cfgfile="$1"
+	if [ -z "$cfgfile" ] || [ "$cfgfile" = "-" ]; then
+		cfgfile=$def_cfgfile
+		cat > $cfgfile
+	fi
+	$MKFS_XFS_PROG -c $cfgfile -f -N $fsimg >> $seqres.full 2> $tmp.err
+	cat $tmp.err | _filter_test_dir
+}
+
+echo Spaces in the middle of a section name
+test_mkfs_config << ENDL
+[meta data]
+crc = 0
+ENDL
+test_mkfs_config << ENDL
+[meta	data]
+crc = 0
+ENDL
+
+echo Spaces in the middle of a key name
+test_mkfs_config << ENDL
+[metadata]
+c rc = 0
+ENDL
+
+echo Invalid value
+test_mkfs_config << ENDL
+[metadata]
+crc = waffles
+ENDL
+
+echo Nonexistent sections
+test_mkfs_config << ENDL
+[goober]
+crc = 0
+ENDL
+
+echo Nonexistent keys
+test_mkfs_config << ENDL
+[metadata]
+goober = 0
+ENDL
+
+echo Strictly base-10 numbers for booleans only
+test_mkfs_config << ENDL
+[metadata]
+crc = 0x0
+ENDL
+test_mkfs_config << ENDL
+[metadata]
+crc = 00
+ENDL
+
+echo Only zero or one
+test_mkfs_config << ENDL
+[metadata]
+crc = 50
+ENDL
+test_mkfs_config << ENDL
+[metadata]
+crc = -1
+ENDL
+
+echo sysctl style files
+test_mkfs_config << ENDL
+metadata.crc = 1
+ENDL
+
+echo binaries
+test_mkfs_config $MKFS_XFS_PROG 2>&1 | sed -e "s#$MKFS_XFS_PROG#MKFS_XFS_PROG#g"
+
+echo respecified options
+test_mkfs_config << ENDL
+[metadata]
+crc = 0
+crc = 1
+ENDL
+
+echo respecified sections
+test_mkfs_config << ENDL
+[metadata]
+crc = 0
+[metadata]
+crc = 1
+ENDL
+
+echo ambiguous comment/section names
+test_mkfs_config << ENDL
+[meta#data]
+crc = 0
+ENDL
+
+echo ambiguous comment/variable names
+test_mkfs_config << ENDL
+[metadata]
+fo#o = 0
+ENDL
+test_mkfs_config << ENDL
+[metadata]
+foo#=# 0
+ENDL
+test_mkfs_config << ENDL
+[metadata]
+foo =# 0
+ENDL
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/717.out b/tests/xfs/717.out
new file mode 100644
index 00000000..68c2f634
--- /dev/null
+++ b/tests/xfs/717.out
@@ -0,0 +1,30 @@
+QA output created by 717
+Spaces in the middle of a section name
+TEST_DIR/a:1: line not recognized as a section header or a key/value pair.
+TEST_DIR/a:1: line not recognized as a section header or a key/value pair.
+Spaces in the middle of a key name
+TEST_DIR/a:2: line not recognized as a section header or a key/value pair.
+Invalid value
+TEST_DIR/a:2: could not interpret value 'waffles'.
+Nonexistent sections
+TEST_DIR/a:1: section 'goober' not recognized.
+Nonexistent keys
+TEST_DIR/a:2: key 'goober' is not a part of section 'metadata'.
+Strictly base-10 numbers for booleans only
+Only zero or one
+TEST_DIR/a:2: metadata.crc value '50' must be 0 or 1.
+TEST_DIR/a:2: metadata.crc value '-1' must be 0 or 1.
+sysctl style files
+TEST_DIR/a:1: key 'metadata.crc' is not in a section.
+binaries
+MKFS_XFS_PROG:1: line not recognized as a section header or a key/value pair.
+respecified options
+TEST_DIR/a:3: section 'metadata' key 'crc' already seen.
+respecified sections
+TEST_DIR/a:3: section 'metadata' already seen.
+ambiguous comment/section names
+TEST_DIR/a:1: line not recognized as a section header or a key/value pair.
+ambiguous comment/variable names
+TEST_DIR/a:2: line not recognized as a section header or a key/value pair.
+TEST_DIR/a:2: line not recognized as a section header or a key/value pair.
+TEST_DIR/a:2: line not recognized as a section header or a key/value pair.
diff --git a/tests/xfs/718 b/tests/xfs/718
new file mode 100755
index 00000000..62b36fd0
--- /dev/null
+++ b/tests/xfs/718
@@ -0,0 +1,64 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Oracle.  All Rights Reserved.
+#
+# FS QA Test 718
+#
+# Test formatting with a well known config file.
+#
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap '_cleanup; exit $status' 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.* $def_cfgfile $fsimg
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
+_supported_os Linux
+_require_test
+_require_scratch_nocheck
+_require_xfs_mkfs_cfgfile
+
+def_cfgfile=$TEST_DIR/a
+fsimg=$TEST_DIR/a.img
+rm -rf $def_cfgfile $fsimg
+truncate -s 20t $fsimg
+
+cat > $def_cfgfile << ENDL
+[metadata]
+crc = 1
+rmapbt = 1
+reflink = 1
+
+[inode]
+sparse = 1
+ENDL
+
+$MKFS_XFS_PROG -c $def_cfgfile -f $SCRATCH_DEV > $tmp.mkfs
+cat $tmp.mkfs >> $seqres.full
+grep -q 'crc=1' $tmp.mkfs || _fail 'v5 not enabled'
+grep -q 'rmapbt=1' $tmp.mkfs || _fail 'rmap not enabled'
+grep -q 'reflink=1' $tmp.mkfs || _fail 'reflink not enabled'
+grep -q 'sparse=1' $tmp.mkfs || _fail 'sparse inodes not enabled'
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/718.out b/tests/xfs/718.out
new file mode 100644
index 00000000..34c1819d
--- /dev/null
+++ b/tests/xfs/718.out
@@ -0,0 +1 @@
+QA output created by 718
diff --git a/tests/xfs/719 b/tests/xfs/719
new file mode 100755
index 00000000..de519dfa
--- /dev/null
+++ b/tests/xfs/719
@@ -0,0 +1,59 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Oracle.  All Rights Reserved.
+#
+# FS QA Test 719
+#
+# Test formatting with a config file that contains conflicting options.
+#
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap '_cleanup; exit $status' 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.* $def_cfgfile
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
+_supported_os Linux
+_require_test
+_require_scratch_nocheck
+_require_xfs_mkfs_cfgfile
+
+def_cfgfile=$TEST_DIR/a
+rm -rf $def_cfgfile
+
+cat > $def_cfgfile << ENDL
+[metadata]
+crc = 0
+rmapbt = 1
+reflink = 1
+
+[inode]
+sparse = 1
+ENDL
+
+$MKFS_XFS_PROG -c $def_cfgfile -f $SCRATCH_DEV > $tmp.mkfs 2>&1
+cat $tmp.mkfs >> $seqres.full
+grep 'rmapbt not supported without CRC support' $tmp.mkfs
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/719.out b/tests/xfs/719.out
new file mode 100644
index 00000000..43e56f5d
--- /dev/null
+++ b/tests/xfs/719.out
@@ -0,0 +1,2 @@
+QA output created by 719
+rmapbt not supported without CRC support
diff --git a/tests/xfs/720 b/tests/xfs/720
new file mode 100755
index 00000000..22ea60c5
--- /dev/null
+++ b/tests/xfs/720
@@ -0,0 +1,51 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Oracle.  All Rights Reserved.
+#
+# FS QA Test 720
+#
+# Test formatting with all the distro-provided config files.
+#
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap '_cleanup; exit $status' 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.* $def_cfgfile
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
+_supported_os Linux
+_require_test
+_require_scratch_nocheck
+_require_xfs_mkfs_cfgfile
+
+ls /etc/xfs/mkfs/* 2> /dev/null | while read cfgfile; do
+	echo "Format with $cfgfile" >> $seqres.full
+	$MKFS_XFS_PROG -c $cfgfile -f $SCRATCH_DEV >> $seqres.full
+
+	short_cfg=$(basename $cfgfile)
+	echo "Format with $short_cfg" >> $seqres.full
+	$MKFS_XFS_PROG -c $short_cfg -f $SCRATCH_DEV >> $seqres.full
+done
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/720.out b/tests/xfs/720.out
new file mode 100644
index 00000000..625af162
--- /dev/null
+++ b/tests/xfs/720.out
@@ -0,0 +1 @@
+QA output created by 720
diff --git a/tests/xfs/721 b/tests/xfs/721
new file mode 100755
index 00000000..cf625766
--- /dev/null
+++ b/tests/xfs/721
@@ -0,0 +1,65 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Oracle.  All Rights Reserved.
+#
+# FS QA Test 721
+#
+# Test formatting with conflicts between the config file and the cli.
+#
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap '_cleanup; exit $status' 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.* $def_cfgfile
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
+_supported_os Linux
+_require_test
+_require_scratch_nocheck
+_require_xfs_mkfs_cfgfile
+
+def_cfgfile=$TEST_DIR/a
+rm -rf $def_cfgfile
+
+# disable crc in config file, enable rmapbt (which requires crc=1) in cli
+cat > $def_cfgfile << ENDL
+[metadata]
+crc = 0
+ENDL
+
+$MKFS_XFS_PROG -c $def_cfgfile -f -m rmapbt=1 $SCRATCH_DEV > $tmp.mkfs 2>&1
+cat $tmp.mkfs >> $seqres.full
+grep 'rmapbt not supported without CRC support' $tmp.mkfs
+
+# enable rmapbt (which requires crc=1) in config file, disable crc in cli
+cat > $def_cfgfile << ENDL
+[metadata]
+rmapbt = 1
+ENDL
+
+$MKFS_XFS_PROG -c $def_cfgfile -f -m crc=0 $SCRATCH_DEV > $tmp.mkfs 2>&1
+cat $tmp.mkfs >> $seqres.full
+grep 'rmapbt not supported without CRC support' $tmp.mkfs
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/721.out b/tests/xfs/721.out
new file mode 100644
index 00000000..23f10ee2
--- /dev/null
+++ b/tests/xfs/721.out
@@ -0,0 +1,3 @@
+QA output created by 721
+rmapbt not supported without CRC support
+rmapbt not supported without CRC support
diff --git a/tests/xfs/group b/tests/xfs/group
index f825e6b8..becd4a03 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -450,6 +450,12 @@
 450 auto quick rmap
 451 auto quick metadata repair
 452 auto db
+716 auto quick mkfs
+717 auto quick mkfs
+718 auto quick mkfs
+719 auto quick mkfs
+720 auto quick mkfs
+721 auto quick mkfs
 1387 dangerous_fuzzers dangerous_norepair
 1388 dangerous_fuzzers dangerous_norepair
 1389 dangerous_fuzzers dangerous_norepair
