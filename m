Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 313E8C3DA7D
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:52:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235978AbiLaAwb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:52:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235930AbiLaAwa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:52:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 303B5186CF;
        Fri, 30 Dec 2022 16:52:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A49AC61D47;
        Sat, 31 Dec 2022 00:52:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F26B7C433EF;
        Sat, 31 Dec 2022 00:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672447946;
        bh=egWQGmh8TTruVN192dJq6s70SqU+sDgEYlue7CpnVmQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=o3fA5AX4CbuUYzswIvoR4Rzv1iAUv3iYPiy77RdI1GS3rbUWkXkX2Tk1jQxYAmAYa
         srAJkqgxO4NyfbD16Om4SSG2OClFu+GTd0uwfyueGEmRdl+7dFYWbtgX8wnGXI0/nE
         KFVUqT52hGzMGx3kCE3LoZsLS4DoBI+Xrvv7txhsN1bbkHty6InFMyK+4bOp4uN+4z
         czxhYh7K3j6xD0ZAkzITgHvKJVUpy247zN5Qym7bysYpdLBV0rUnXL6g2nfMrJiSfW
         qIVBGSQnn8VcfXJ2P7bhTz8rFUc0mDxzD/u7+a3x0BqZXTynAWf4VrFZsln80CjVnA
         fo+4sKeD3E4cw==
Subject: [PATCH 3/7] generic: test new vfs swapext ioctl
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:19:48 -0800
Message-ID: <167243878860.732172.12480859111756252957.stgit@magnolia>
In-Reply-To: <167243878818.732172.6392253687008406885.stgit@magnolia>
References: <167243878818.732172.6392253687008406885.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Test the new vfs swapext ioctl.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/rc              |   13 +++++
 common/reflink         |   33 +++++++++++++
 tests/generic/1203     |   58 ++++++++++++++++++++++
 tests/generic/1203.out |    2 +
 tests/generic/1204     |  100 ++++++++++++++++++++++++++++++++++++++
 tests/generic/1204.out |   86 +++++++++++++++++++++++++++++++++
 tests/generic/1205     |  116 ++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/1205.out |   90 ++++++++++++++++++++++++++++++++++
 tests/generic/1206     |   76 +++++++++++++++++++++++++++++
 tests/generic/1206.out |   32 ++++++++++++
 tests/generic/1207     |  122 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/1207.out |   48 ++++++++++++++++++
 tests/generic/1209     |  101 ++++++++++++++++++++++++++++++++++++++
 tests/generic/1209.out |   33 +++++++++++++
 tests/generic/1210     |   48 ++++++++++++++++++
 tests/generic/1210.out |    6 ++
 tests/generic/1211     |  105 ++++++++++++++++++++++++++++++++++++++++
 tests/generic/1211.out |   40 +++++++++++++++
 tests/generic/1212     |   58 ++++++++++++++++++++++
 tests/generic/1212.out |    2 +
 tests/generic/1213     |  126 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/1213.out |   48 ++++++++++++++++++
 tests/generic/1214     |   63 ++++++++++++++++++++++++
 tests/generic/1214.out |    2 +
 tests/generic/1215     |   70 +++++++++++++++++++++++++++
 tests/generic/1215.out |    2 +
 tests/xfs/1208         |   62 ++++++++++++++++++++++++
 tests/xfs/1208.out     |   10 ++++
 28 files changed, 1552 insertions(+)
 create mode 100755 tests/generic/1203
 create mode 100644 tests/generic/1203.out
 create mode 100755 tests/generic/1204
 create mode 100644 tests/generic/1204.out
 create mode 100755 tests/generic/1205
 create mode 100644 tests/generic/1205.out
 create mode 100755 tests/generic/1206
 create mode 100644 tests/generic/1206.out
 create mode 100755 tests/generic/1207
 create mode 100644 tests/generic/1207.out
 create mode 100755 tests/generic/1209
 create mode 100644 tests/generic/1209.out
 create mode 100755 tests/generic/1210
 create mode 100644 tests/generic/1210.out
 create mode 100755 tests/generic/1211
 create mode 100644 tests/generic/1211.out
 create mode 100755 tests/generic/1212
 create mode 100644 tests/generic/1212.out
 create mode 100755 tests/generic/1213
 create mode 100644 tests/generic/1213.out
 create mode 100755 tests/generic/1214
 create mode 100644 tests/generic/1214.out
 create mode 100755 tests/generic/1215
 create mode 100644 tests/generic/1215.out
 create mode 100755 tests/xfs/1208
 create mode 100644 tests/xfs/1208.out


diff --git a/common/rc b/common/rc
index 88ecc1837d..cfe765de2e 100644
--- a/common/rc
+++ b/common/rc
@@ -2575,6 +2575,17 @@ _require_xfs_io_command()
 		echo $testio | grep -q "Inappropriate ioctl" && \
 			_notrun "xfs_io $command support is missing"
 		;;
+	"startupdate"|"commitupdate"|"cancelupdate")
+		$XFS_IO_PROG -f -c 'pwrite -S 0x58 0 128k -b 128k' $testfile > /dev/null
+		testio=$($XFS_IO_PROG -c "startupdate $param" \
+				-c 'pwrite -S 0x59 0 192k' \
+				-c 'commitupdate' $testfile 2>&1)
+		echo $testio | grep -q "Inappropriate ioctl" && \
+			_notrun "xfs_io $command $param support is missing"
+		echo $testio | grep -q "Operation not supported" && \
+			_notrun "xfs_io $command $param kernel support is missing"
+		param_checked="$param"
+		;;
 	"swapext")
 		$XFS_IO_PROG -f -c 'pwrite -S 0x58 0 128k -b 128k' $testfile > /dev/null
 		$XFS_IO_PROG -f -c 'truncate 128k' $testfile.1 > /dev/null
@@ -2583,6 +2594,8 @@ _require_xfs_io_command()
 			_notrun "xfs_io $command $param support is missing"
 		echo $testio | grep -q "Inappropriate ioctl" && \
 			_notrun "xfs_io $command $param ioctl support is missing"
+		echo $testio | grep -q "Operation not supported" && \
+			_notrun "xfs_io $command $param kernel support is missing"
 		rm -f $testfile.1
 		param_checked="$param"
 		;;
diff --git a/common/reflink b/common/reflink
index 76e9cb7d32..22adc4449b 100644
--- a/common/reflink
+++ b/common/reflink
@@ -325,6 +325,39 @@ _weave_reflink_regular() {
 	done
 }
 
+# Create a file of interleaved holes, unwritten blocks, and regular blocks.
+_weave_file_rainbow() {
+	blksz=$1
+	nr=$2
+	dfile=$3
+
+	$XFS_IO_PROG -f -c "truncate $((blksz * nr))" $dfile
+	_pwrite_byte 0x00 0 $((blksz * nr)) $dfile.chk
+	# 0 blocks are unwritten
+	seq 1 5 $((nr - 1)) | while read i; do
+		$XFS_IO_PROG -f -c "falloc $((blksz * i)) $blksz" $dfile
+		_pwrite_byte 0x00 $((blksz * i)) $blksz $dfile.chk
+	done
+	# 1 blocks are holes
+	seq 2 5 $((nr - 1)) | while read i; do
+		_pwrite_byte 0x00 $((blksz * i)) $blksz $dfile.chk
+	done
+	# 2 blocks are regular
+	seq 3 5 $((nr - 1)) | while read i; do
+		_pwrite_byte 0x71 $((blksz * i)) $blksz $dfile
+		_pwrite_byte 0x71 $((blksz * i)) $blksz $dfile.chk
+	done
+	# 3 blocks are holes
+	seq 2 5 $((nr - 1)) | while read i; do
+		_pwrite_byte 0x00 $((blksz * i)) $blksz $dfile.chk
+	done
+	# 4 blocks are delalloc
+	seq 4 5 $((nr - 1)) | while read i; do
+		_pwrite_byte 0x62 $((blksz * i)) $blksz $dfile
+		_pwrite_byte 0x62 $((blksz * i)) $blksz $dfile.chk
+	done
+}
+
 # Create a file of interleaved holes, unwritten blocks, regular blocks, and
 # reflinked blocks
 _weave_reflink_rainbow() {
diff --git a/tests/generic/1203 b/tests/generic/1203
new file mode 100755
index 0000000000..890b0b4c86
--- /dev/null
+++ b/tests/generic/1203
@@ -0,0 +1,58 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1202
+#
+# Make sure that swapext modifies ctime and not mtime of the file.
+
+. ./common/preamble
+_begin_fstest auto quick fiexchange swapext
+
+# Override the default cleanup function.
+_cleanup()
+{
+	cd /
+	rm -r -f $tmp.* $dir
+}
+
+# Import common functions.
+. ./common/filter
+
+# real QA test starts here
+_require_test_program punch-alternating
+_require_xfs_io_command swapext '-v vfs'
+_require_test
+
+dir=$TEST_DIR/test-$seq
+mkdir -p $dir
+
+# Set up initial files
+$XFS_IO_PROG -f -c 'pwrite -S 0x58 0 256k -b 1m' $dir/a >> $seqres.full
+$here/src/punch-alternating $dir/a
+$XFS_IO_PROG -f -c 'pwrite -S 0x59 0 256k -b 1m' $dir/b >> $seqres.full
+
+# Snapshot the 'a' file before we swap
+echo before >> $seqres.full
+md5sum $dir/a $dir/b >> $seqres.full
+old_mtime="$(echo $(stat -c '%y' $dir/a $dir/b))"
+old_ctime="$(echo $(stat -c '%z' $dir/a $dir/b))"
+stat -c '%y %Y %z %Z' $dir/a $dir/b >> $seqres.full
+
+# Now try to swapext
+$XFS_IO_PROG -c "swapext $dir/b" $dir/a
+
+# Snapshot the 'a' file after we swap
+echo after >> $seqres.full
+md5sum $dir/a $dir/b >> $seqres.full
+new_mtime="$(echo $(stat -c '%y' $dir/a $dir/b))"
+new_ctime="$(echo $(stat -c '%z' $dir/a $dir/b))"
+stat -c '%y %Y %z %Z' $dir/a $dir/b >> $seqres.full
+
+test "$new_mtime" = "$old_mtime" && echo "mtime: $new_mtime == $old_mtime"
+test "$new_ctime" = "$old_ctime" && echo "ctime: $new_ctime == $old_ctime"
+
+# success, all done
+echo Silence is golden.
+status=0
+exit
diff --git a/tests/generic/1203.out b/tests/generic/1203.out
new file mode 100644
index 0000000000..904b25beb4
--- /dev/null
+++ b/tests/generic/1203.out
@@ -0,0 +1,2 @@
+QA output created by 1203
+Silence is golden.
diff --git a/tests/generic/1204 b/tests/generic/1204
new file mode 100755
index 0000000000..5db3878520
--- /dev/null
+++ b/tests/generic/1204
@@ -0,0 +1,100 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1204
+#
+# Test swapext between ranges of two different files.
+
+. ./common/preamble
+_begin_fstest auto quick fiexchange swapext
+
+# Override the default cleanup function.
+_cleanup()
+{
+	cd /
+	rm -r -f $tmp.* $dir
+}
+
+# Import common functions.
+. ./common/filter
+. ./common/reflink
+
+# real QA test starts here
+_require_xfs_io_command swapext '-v vfs -s 64k -l 64k'
+_require_xfs_io_command "falloc"
+_require_test
+
+filesnap() {
+	echo "$1"
+	if [ "$2" != "$3" ]; then
+		md5sum $2 $3 | _filter_test_dir
+	else
+		md5sum $2 | _filter_test_dir
+	fi
+}
+
+test_swapext_once() {
+	filesnap "$1: before swapext" $dir/$3 $dir/$4
+	$XFS_IO_PROG -c "swapext -v vfs $2 $dir/$3" $dir/$4
+	filesnap "$1: after swapext" $dir/$3 $dir/$4
+	_test_cycle_mount
+	filesnap "$1: after cycling mount" $dir/$3 $dir/$4
+	echo
+}
+
+test_swapext_two() {
+	# swapext the same range of two files
+	test_swapext_once "$@: samerange" \
+		"-s $((blksz * 3)) -d $((blksz * 3)) -l $((blksz * 5))" b a
+
+	# swapext different ranges of two files
+	test_swapext_once "$@: diffrange" \
+		"-s $((blksz * 37)) -d $((blksz * 47)) -l $((blksz * 7))" b a
+
+	# swapext overlapping ranges of two files
+	test_swapext_once "$@: overlap" \
+		"-s $((blksz * 17)) -d $((blksz * 23)) -l $((blksz * 7))" b a
+}
+
+dir=$TEST_DIR/test-$seq
+mkdir -p $dir
+blksz=65536
+nrblks=57
+_require_congruent_file_oplen $TEST_DIR $blksz
+
+# Set up some simple files for a first test.
+rm -rf $dir/a $dir/b
+_pwrite_byte 0x58 0 $((blksz * nrblks)) $dir/a >> $seqres.full
+_pwrite_byte 0x59 0 $((blksz * nrblks)) $dir/b >> $seqres.full
+test_swapext_two "simple"
+
+# Make some files that don't end an aligned offset.
+rm -rf $dir/a $dir/b
+_pwrite_byte 0x58 0 $(( (blksz * nrblks) + 37)) $dir/a >> $seqres.full
+_pwrite_byte 0x59 0 $(( (blksz * nrblks) + 37)) $dir/b >> $seqres.full
+test_swapext_once "unalignedeof" "" a b
+
+# Set up some crazy rainbow files
+rm -rf $dir/a $dir/b
+_weave_file_rainbow $blksz $nrblks $dir/a >> $seqres.full
+_weave_file_rainbow $blksz $nrblks $dir/b >> $seqres.full
+test_swapext_two "rainbow"
+
+# Now set up a simple file for testing within the same file
+rm -rf $dir/c
+$XFS_IO_PROG -f -c "pwrite -S 0x58 0 $((blksz * nrblks))" \
+	-c "pwrite -S 0x59 $((blksz * nrblks)) $((blksz * nrblks))" \
+	$dir/c >> $seqres.full
+
+# swapext the same offset into the 'X' and 'Y' regions of the file
+test_swapext_once "single: sameXandY" \
+	"-s $((blksz * 3)) -d $((blksz * (nrblks + 3))) -l $((blksz * 5))" c c
+
+# swapext the same offset into the 'X' and 'Y' regions of the file
+test_swapext_once "single: overlap" \
+	"-s $((blksz * 13)) -d $((blksz * 17)) -l $((blksz * 5))" c c
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/1204.out b/tests/generic/1204.out
new file mode 100644
index 0000000000..cdf9f7315d
--- /dev/null
+++ b/tests/generic/1204.out
@@ -0,0 +1,86 @@
+QA output created by 1204
+simple: samerange: before swapext
+db85d578204631f2b4eb1e73974253c2  TEST_DIR/test-1204/b
+d0425612f15c6071022cf7127620f63d  TEST_DIR/test-1204/a
+simple: samerange: after swapext
+20beef1c9ed7de02e4229c69bd43bd8f  TEST_DIR/test-1204/b
+e7697fa99d08f7eb76fa3fb963fe916a  TEST_DIR/test-1204/a
+simple: samerange: after cycling mount
+20beef1c9ed7de02e4229c69bd43bd8f  TEST_DIR/test-1204/b
+e7697fa99d08f7eb76fa3fb963fe916a  TEST_DIR/test-1204/a
+
+simple: diffrange: before swapext
+20beef1c9ed7de02e4229c69bd43bd8f  TEST_DIR/test-1204/b
+e7697fa99d08f7eb76fa3fb963fe916a  TEST_DIR/test-1204/a
+simple: diffrange: after swapext
+cd32ce54c295fcdf571ce7f8220fac56  TEST_DIR/test-1204/b
+d9771c5bb6d9db00b9abe65a4410e1a6  TEST_DIR/test-1204/a
+simple: diffrange: after cycling mount
+cd32ce54c295fcdf571ce7f8220fac56  TEST_DIR/test-1204/b
+d9771c5bb6d9db00b9abe65a4410e1a6  TEST_DIR/test-1204/a
+
+simple: overlap: before swapext
+cd32ce54c295fcdf571ce7f8220fac56  TEST_DIR/test-1204/b
+d9771c5bb6d9db00b9abe65a4410e1a6  TEST_DIR/test-1204/a
+simple: overlap: after swapext
+e0fff655f6a08fc2f03ee01e4767060c  TEST_DIR/test-1204/b
+ec7d764c85e583e305028c9cba5b25b6  TEST_DIR/test-1204/a
+simple: overlap: after cycling mount
+e0fff655f6a08fc2f03ee01e4767060c  TEST_DIR/test-1204/b
+ec7d764c85e583e305028c9cba5b25b6  TEST_DIR/test-1204/a
+
+unalignedeof: before swapext
+9f8c731a4f1946ffdda8c33e82417f2d  TEST_DIR/test-1204/a
+7a5d2ba7508226751c835292e28cd227  TEST_DIR/test-1204/b
+unalignedeof: after swapext
+7a5d2ba7508226751c835292e28cd227  TEST_DIR/test-1204/a
+9f8c731a4f1946ffdda8c33e82417f2d  TEST_DIR/test-1204/b
+unalignedeof: after cycling mount
+7a5d2ba7508226751c835292e28cd227  TEST_DIR/test-1204/a
+9f8c731a4f1946ffdda8c33e82417f2d  TEST_DIR/test-1204/b
+
+rainbow: samerange: before swapext
+48b41ee1970eb71064b77181f42634cf  TEST_DIR/test-1204/b
+48b41ee1970eb71064b77181f42634cf  TEST_DIR/test-1204/a
+rainbow: samerange: after swapext
+48b41ee1970eb71064b77181f42634cf  TEST_DIR/test-1204/b
+48b41ee1970eb71064b77181f42634cf  TEST_DIR/test-1204/a
+rainbow: samerange: after cycling mount
+48b41ee1970eb71064b77181f42634cf  TEST_DIR/test-1204/b
+48b41ee1970eb71064b77181f42634cf  TEST_DIR/test-1204/a
+
+rainbow: diffrange: before swapext
+48b41ee1970eb71064b77181f42634cf  TEST_DIR/test-1204/b
+48b41ee1970eb71064b77181f42634cf  TEST_DIR/test-1204/a
+rainbow: diffrange: after swapext
+48b41ee1970eb71064b77181f42634cf  TEST_DIR/test-1204/b
+48b41ee1970eb71064b77181f42634cf  TEST_DIR/test-1204/a
+rainbow: diffrange: after cycling mount
+48b41ee1970eb71064b77181f42634cf  TEST_DIR/test-1204/b
+48b41ee1970eb71064b77181f42634cf  TEST_DIR/test-1204/a
+
+rainbow: overlap: before swapext
+48b41ee1970eb71064b77181f42634cf  TEST_DIR/test-1204/b
+48b41ee1970eb71064b77181f42634cf  TEST_DIR/test-1204/a
+rainbow: overlap: after swapext
+6753bc585e3c71d53bfaae11d2ffee99  TEST_DIR/test-1204/b
+39597abd4d9d0c9ceac22b77eb00c373  TEST_DIR/test-1204/a
+rainbow: overlap: after cycling mount
+6753bc585e3c71d53bfaae11d2ffee99  TEST_DIR/test-1204/b
+39597abd4d9d0c9ceac22b77eb00c373  TEST_DIR/test-1204/a
+
+single: sameXandY: before swapext
+39e17753fa9e923a3b5928e13775e358  TEST_DIR/test-1204/c
+single: sameXandY: after swapext
+8262c617070703fb0e2a28d8f05e3112  TEST_DIR/test-1204/c
+single: sameXandY: after cycling mount
+8262c617070703fb0e2a28d8f05e3112  TEST_DIR/test-1204/c
+
+single: overlap: before swapext
+8262c617070703fb0e2a28d8f05e3112  TEST_DIR/test-1204/c
+swapext: Invalid argument
+single: overlap: after swapext
+8262c617070703fb0e2a28d8f05e3112  TEST_DIR/test-1204/c
+single: overlap: after cycling mount
+8262c617070703fb0e2a28d8f05e3112  TEST_DIR/test-1204/c
+
diff --git a/tests/generic/1205 b/tests/generic/1205
new file mode 100755
index 0000000000..dfa5adf0e1
--- /dev/null
+++ b/tests/generic/1205
@@ -0,0 +1,116 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1205
+#
+# Test swapext between ranges of two different files, when one of the files
+# is shared.
+
+. ./common/preamble
+_begin_fstest auto quick fiexchange swapext
+
+# Override the default cleanup function.
+_cleanup()
+{
+	cd /
+	rm -r -f $tmp.* $dir
+}
+
+# Import common functions.
+. ./common/filter
+. ./common/reflink
+
+# real QA test starts here
+_require_xfs_io_command swapext '-v vfs'
+_require_xfs_io_command "falloc"
+_require_test_reflink
+
+filesnap() {
+	echo "$1"
+	if [ "$2" != "$3" ]; then
+		md5sum $2 $3 | _filter_test_dir
+	else
+		md5sum $2 | _filter_test_dir
+	fi
+}
+
+test_swapext_once() {
+	filesnap "$1: before swapext" $dir/$3 $dir/$4
+	$XFS_IO_PROG -c "swapext -v vfs $2 $dir/$3" $dir/$4
+	filesnap "$1: after swapext" $dir/$3 $dir/$4
+	_test_cycle_mount
+	filesnap "$1: after cycling mount" $dir/$3 $dir/$4
+	echo
+}
+
+test_swapext_two() {
+	# swapext the same range of two files
+	test_swapext_once "$@: samerange" \
+		"-s $((blksz * 3)) -d $((blksz * 3)) -l $((blksz * 5))" b a
+
+	# swapext different ranges of two files
+	test_swapext_once "$@: diffrange" \
+		"-s $((blksz * 37)) -d $((blksz * 47)) -l $((blksz * 7))" b a
+
+	# swapext overlapping ranges of two files
+	test_swapext_once "$@: overlap" \
+		"-s $((blksz * 17)) -d $((blksz * 23)) -l $((blksz * 7))" b a
+
+	# Now let's overwrite a entirely to make sure COW works
+	echo "overwrite A and B entirely"
+	md5sum $dir/sharea | _filter_test_dir
+	$XFS_IO_PROG -c "pwrite -S 0x60 0 $((blksz * nrblks))" $dir/a >> $seqres.full
+	$XFS_IO_PROG -c "pwrite -S 0x60 0 $((blksz * nrblks))" $dir/b >> $seqres.full
+	md5sum $dir/sharea | _filter_test_dir
+	_test_cycle_mount
+	md5sum $dir/sharea | _filter_test_dir
+	echo
+}
+
+dir=$TEST_DIR/test-$seq
+mkdir -p $dir
+blksz=65536
+_require_congruent_file_oplen $TEST_DIR $blksz
+nrblks=57
+
+# Set up some simple files for a first test.
+rm -f $dir/a $dir/b $dir/sharea
+_pwrite_byte 0x58 0 $((blksz * nrblks)) $dir/a >> $seqres.full
+_pwrite_byte 0x59 0 $((blksz * nrblks)) $dir/b >> $seqres.full
+_cp_reflink $dir/a $dir/sharea
+test_swapext_two "simple"
+
+# Set up some crazy rainbow files
+rm -f $dir/a $dir/b $dir/sharea
+_weave_file_rainbow $blksz $nrblks $dir/a >> $seqres.full
+_weave_file_rainbow $blksz $nrblks $dir/b >> $seqres.full
+_cp_reflink $dir/a $dir/sharea
+test_swapext_two "rainbow"
+
+# Now set up a simple file for testing within the same file
+rm -f $dir/c $dir/sharec
+$XFS_IO_PROG -f -c "pwrite -S 0x58 0 $((blksz * nrblks))" \
+	-c "pwrite -S 0x59 $((blksz * nrblks)) $((blksz * nrblks))" \
+	$dir/c >> $seqres.full
+_cp_reflink $dir/c $dir/sharec
+
+# swapext the same offset into the 'X' and 'Y' regions of the file
+test_swapext_once "single: sameXandY" \
+	"-s $((blksz * 3)) -d $((blksz * (nrblks + 3))) -l $((blksz * 5))" c c
+
+# swapext the same offset into the 'X' and 'Y' regions of the file
+test_swapext_once "single: overlap" \
+	"-s $((blksz * 13)) -d $((blksz * 17)) -l $((blksz * 5))" c c
+
+# Now let's overwrite a entirely to make sure COW works
+echo "overwrite C entirely"
+md5sum $dir/sharec | _filter_test_dir
+$XFS_IO_PROG -c "pwrite -S 0x60 0 $((blksz * nrblks))" $dir/c >> $seqres.full
+md5sum $dir/sharec | _filter_test_dir
+_test_cycle_mount
+md5sum $dir/sharec | _filter_test_dir
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/1205.out b/tests/generic/1205.out
new file mode 100644
index 0000000000..9a95742e78
--- /dev/null
+++ b/tests/generic/1205.out
@@ -0,0 +1,90 @@
+QA output created by 1205
+simple: samerange: before swapext
+db85d578204631f2b4eb1e73974253c2  TEST_DIR/test-1205/b
+d0425612f15c6071022cf7127620f63d  TEST_DIR/test-1205/a
+simple: samerange: after swapext
+20beef1c9ed7de02e4229c69bd43bd8f  TEST_DIR/test-1205/b
+e7697fa99d08f7eb76fa3fb963fe916a  TEST_DIR/test-1205/a
+simple: samerange: after cycling mount
+20beef1c9ed7de02e4229c69bd43bd8f  TEST_DIR/test-1205/b
+e7697fa99d08f7eb76fa3fb963fe916a  TEST_DIR/test-1205/a
+
+simple: diffrange: before swapext
+20beef1c9ed7de02e4229c69bd43bd8f  TEST_DIR/test-1205/b
+e7697fa99d08f7eb76fa3fb963fe916a  TEST_DIR/test-1205/a
+simple: diffrange: after swapext
+cd32ce54c295fcdf571ce7f8220fac56  TEST_DIR/test-1205/b
+d9771c5bb6d9db00b9abe65a4410e1a6  TEST_DIR/test-1205/a
+simple: diffrange: after cycling mount
+cd32ce54c295fcdf571ce7f8220fac56  TEST_DIR/test-1205/b
+d9771c5bb6d9db00b9abe65a4410e1a6  TEST_DIR/test-1205/a
+
+simple: overlap: before swapext
+cd32ce54c295fcdf571ce7f8220fac56  TEST_DIR/test-1205/b
+d9771c5bb6d9db00b9abe65a4410e1a6  TEST_DIR/test-1205/a
+simple: overlap: after swapext
+e0fff655f6a08fc2f03ee01e4767060c  TEST_DIR/test-1205/b
+ec7d764c85e583e305028c9cba5b25b6  TEST_DIR/test-1205/a
+simple: overlap: after cycling mount
+e0fff655f6a08fc2f03ee01e4767060c  TEST_DIR/test-1205/b
+ec7d764c85e583e305028c9cba5b25b6  TEST_DIR/test-1205/a
+
+overwrite A and B entirely
+d0425612f15c6071022cf7127620f63d  TEST_DIR/test-1205/sharea
+d0425612f15c6071022cf7127620f63d  TEST_DIR/test-1205/sharea
+d0425612f15c6071022cf7127620f63d  TEST_DIR/test-1205/sharea
+
+rainbow: samerange: before swapext
+48b41ee1970eb71064b77181f42634cf  TEST_DIR/test-1205/b
+48b41ee1970eb71064b77181f42634cf  TEST_DIR/test-1205/a
+rainbow: samerange: after swapext
+48b41ee1970eb71064b77181f42634cf  TEST_DIR/test-1205/b
+48b41ee1970eb71064b77181f42634cf  TEST_DIR/test-1205/a
+rainbow: samerange: after cycling mount
+48b41ee1970eb71064b77181f42634cf  TEST_DIR/test-1205/b
+48b41ee1970eb71064b77181f42634cf  TEST_DIR/test-1205/a
+
+rainbow: diffrange: before swapext
+48b41ee1970eb71064b77181f42634cf  TEST_DIR/test-1205/b
+48b41ee1970eb71064b77181f42634cf  TEST_DIR/test-1205/a
+rainbow: diffrange: after swapext
+48b41ee1970eb71064b77181f42634cf  TEST_DIR/test-1205/b
+48b41ee1970eb71064b77181f42634cf  TEST_DIR/test-1205/a
+rainbow: diffrange: after cycling mount
+48b41ee1970eb71064b77181f42634cf  TEST_DIR/test-1205/b
+48b41ee1970eb71064b77181f42634cf  TEST_DIR/test-1205/a
+
+rainbow: overlap: before swapext
+48b41ee1970eb71064b77181f42634cf  TEST_DIR/test-1205/b
+48b41ee1970eb71064b77181f42634cf  TEST_DIR/test-1205/a
+rainbow: overlap: after swapext
+6753bc585e3c71d53bfaae11d2ffee99  TEST_DIR/test-1205/b
+39597abd4d9d0c9ceac22b77eb00c373  TEST_DIR/test-1205/a
+rainbow: overlap: after cycling mount
+6753bc585e3c71d53bfaae11d2ffee99  TEST_DIR/test-1205/b
+39597abd4d9d0c9ceac22b77eb00c373  TEST_DIR/test-1205/a
+
+overwrite A and B entirely
+48b41ee1970eb71064b77181f42634cf  TEST_DIR/test-1205/sharea
+48b41ee1970eb71064b77181f42634cf  TEST_DIR/test-1205/sharea
+48b41ee1970eb71064b77181f42634cf  TEST_DIR/test-1205/sharea
+
+single: sameXandY: before swapext
+39e17753fa9e923a3b5928e13775e358  TEST_DIR/test-1205/c
+single: sameXandY: after swapext
+8262c617070703fb0e2a28d8f05e3112  TEST_DIR/test-1205/c
+single: sameXandY: after cycling mount
+8262c617070703fb0e2a28d8f05e3112  TEST_DIR/test-1205/c
+
+single: overlap: before swapext
+8262c617070703fb0e2a28d8f05e3112  TEST_DIR/test-1205/c
+swapext: Invalid argument
+single: overlap: after swapext
+8262c617070703fb0e2a28d8f05e3112  TEST_DIR/test-1205/c
+single: overlap: after cycling mount
+8262c617070703fb0e2a28d8f05e3112  TEST_DIR/test-1205/c
+
+overwrite C entirely
+39e17753fa9e923a3b5928e13775e358  TEST_DIR/test-1205/sharec
+39e17753fa9e923a3b5928e13775e358  TEST_DIR/test-1205/sharec
+39e17753fa9e923a3b5928e13775e358  TEST_DIR/test-1205/sharec
diff --git a/tests/generic/1206 b/tests/generic/1206
new file mode 100755
index 0000000000..a4d9dd083e
--- /dev/null
+++ b/tests/generic/1206
@@ -0,0 +1,76 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1206
+#
+# Test swapext between two files of unlike size.
+
+. ./common/preamble
+_begin_fstest auto quick fiexchange swapext
+
+# Override the default cleanup function.
+_cleanup()
+{
+	cd /
+	rm -r -f $tmp.* $dir
+}
+
+# Import common functions.
+. ./common/filter
+. ./common/reflink
+
+# real QA test starts here
+_require_xfs_io_command swapext '-v vfs -s 64k -l 64k'
+_require_test
+
+filesnap() {
+	echo "$1"
+	if [ "$2" != "$3" ]; then
+		md5sum $2 $3 | _filter_test_dir
+	else
+		md5sum $2 | _filter_test_dir
+	fi
+}
+
+test_swapext_once() {
+	local tag=$1
+	local a_len=$2
+	local b_len=$3
+	local a_off=$4
+	local b_off=$5
+	local len=$6
+
+	# len is either a block count or -e to swap to EOF
+	if [ "$len" != "-e" ]; then
+		len="-l $((blksz * len))"
+	fi
+
+	rm -f $dir/a $dir/b
+	_pwrite_byte 0x58 0 $((blksz * a_len)) $dir/a >> $seqres.full
+	_pwrite_byte 0x59 0 $((blksz * b_len)) $dir/b >> $seqres.full
+	filesnap "$tag: before swapext" $dir/a $dir/b
+
+	cmd="swapext -v vfs -s $((blksz * a_off)) -d $((blksz * b_off)) $len $dir/a"
+	echo "$cmd" >> $seqres.full
+	$XFS_IO_PROG -c "$cmd" $dir/b
+	filesnap "$tag: after swapext" $dir/a $dir/b
+
+	_test_cycle_mount
+	filesnap "$tag: after cycling mount" $dir/a $dir/b
+	echo
+}
+
+dir=$TEST_DIR/test-$seq
+mkdir -p $dir
+blksz=65536
+
+test_swapext_once "last 5 blocks" 27 37 22 32 5
+
+test_swapext_once "whole file to eof" 27 37 0 0 -e
+
+test_swapext_once "blocks 30-40" 27 37 30 30 10
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/1206.out b/tests/generic/1206.out
new file mode 100644
index 0000000000..82f4185684
--- /dev/null
+++ b/tests/generic/1206.out
@@ -0,0 +1,32 @@
+QA output created by 1206
+last 5 blocks: before swapext
+207ea56e0ccbf50d38fd3a2d842aa170  TEST_DIR/test-1206/a
+eb58941d31f5be1e4e22df8c536dd490  TEST_DIR/test-1206/b
+last 5 blocks: after swapext
+3f34470fe9feb8513d5f3a8538f2c5f3  TEST_DIR/test-1206/a
+c3daca7dd9218371cd0dc64f11e4b0bf  TEST_DIR/test-1206/b
+last 5 blocks: after cycling mount
+3f34470fe9feb8513d5f3a8538f2c5f3  TEST_DIR/test-1206/a
+c3daca7dd9218371cd0dc64f11e4b0bf  TEST_DIR/test-1206/b
+
+whole file to eof: before swapext
+207ea56e0ccbf50d38fd3a2d842aa170  TEST_DIR/test-1206/a
+eb58941d31f5be1e4e22df8c536dd490  TEST_DIR/test-1206/b
+whole file to eof: after swapext
+eb58941d31f5be1e4e22df8c536dd490  TEST_DIR/test-1206/a
+207ea56e0ccbf50d38fd3a2d842aa170  TEST_DIR/test-1206/b
+whole file to eof: after cycling mount
+eb58941d31f5be1e4e22df8c536dd490  TEST_DIR/test-1206/a
+207ea56e0ccbf50d38fd3a2d842aa170  TEST_DIR/test-1206/b
+
+blocks 30-40: before swapext
+207ea56e0ccbf50d38fd3a2d842aa170  TEST_DIR/test-1206/a
+eb58941d31f5be1e4e22df8c536dd490  TEST_DIR/test-1206/b
+swapext: Invalid argument
+blocks 30-40: after swapext
+207ea56e0ccbf50d38fd3a2d842aa170  TEST_DIR/test-1206/a
+eb58941d31f5be1e4e22df8c536dd490  TEST_DIR/test-1206/b
+blocks 30-40: after cycling mount
+207ea56e0ccbf50d38fd3a2d842aa170  TEST_DIR/test-1206/a
+eb58941d31f5be1e4e22df8c536dd490  TEST_DIR/test-1206/b
+
diff --git a/tests/generic/1207 b/tests/generic/1207
new file mode 100755
index 0000000000..3a69a1ec57
--- /dev/null
+++ b/tests/generic/1207
@@ -0,0 +1,122 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1207
+#
+# Test atomic file updates when (a) the length is the same; (b) the length
+# is different; and (c) someone modifies the original file and we need to
+# cancel the update.  The file contents are cloned into the staging file,
+# and some of the contents are updated.
+
+. ./common/preamble
+_begin_fstest auto quick fiexchange swapext
+
+# Override the default cleanup function.
+_cleanup()
+{
+	cd /
+	rm -r -f $tmp.* $dir
+}
+
+# Import common functions.
+. ./common/filter
+. ./common/reflink
+
+# real QA test starts here
+_require_xfs_io_command swapext '-v vfs'
+_require_xfs_io_command startupdate
+_require_test_reflink
+_require_test
+
+filesnap() {
+	echo "$1"
+	md5sum $2 | _filter_test_dir
+}
+
+mkfile() {
+	rm -f $dir/a
+	_pwrite_byte 0x58 0 $((blksz * nrblks)) $dir/a >> $seqres.full
+	sync
+}
+
+dir=$TEST_DIR/test-$seq
+mkdir -p $dir
+blksz=65536
+nrblks=64
+
+# Use the atomic file update staging prototype in xfs_io to update a file.
+mkfile
+filesnap "before commit" $dir/a
+
+$XFS_IO_PROG \
+	-c 'startupdate' \
+	-c 'pwrite -S 0x60 44k 55k -b 1m' \
+	-c 'commitupdate -q' \
+	"$dir/a" 2>&1 | _filter_xfs_io | _filter_test_dir
+
+filesnap "after commit" $dir/a
+echo
+
+# Use the atomic file updates to replace a file with a shorter file.
+mkfile
+filesnap "before shorten commit" $dir/a
+
+$XFS_IO_PROG \
+	-c 'startupdate' \
+	-c 'truncate 55k' \
+	-c 'pwrite -S 0x60 0 55k' \
+	-c 'commitupdate -q' \
+	"$dir/a" 2>&1 | _filter_xfs_io | _filter_test_dir
+
+filesnap "after shorten commit" $dir/a
+echo
+
+# Use the atomic file updates to replace a file with a longer file.
+mkfile
+filesnap "before lengthen commit" $dir/a
+
+$XFS_IO_PROG \
+	-c 'startupdate' \
+	-c "pwrite -S 0x60 0 $(( (blksz * nrblks) + 37373 ))" \
+	-c 'commitupdate -q' \
+	"$dir/a" 2>&1 | _filter_xfs_io | _filter_test_dir
+
+filesnap "after lengthen commit" $dir/a
+echo
+
+# Use the atomic file update staging prototype in xfs_io to cancel updating a
+# file.
+mkfile
+filesnap "before cancel" $dir/a
+
+$XFS_IO_PROG \
+	-c 'startupdate' \
+	-c 'pwrite -S 0x60 44k 55k -b 1m' \
+	-c 'cancelupdate' \
+	"$dir/a" 2>&1 | _filter_xfs_io | _filter_test_dir
+
+filesnap "after cancel" $dir/a
+echo
+
+# Now try the update but with the A file open separately so that we clobber
+# mtime and fail the update.
+mkfile
+filesnap "before fail commit" $dir/a
+
+$XFS_IO_PROG \
+	-c "open $dir/a" \
+	-c 'startupdate' \
+	-c 'pwrite -S 0x58 44k 55k -b 1m' \
+	-c 'file 0' \
+	-c 'close' \
+	-c 'pwrite -S 0x61 22k 11k -b 1m' \
+	-c 'commitupdate -q' \
+	"$dir/a" 2>&1 | _filter_xfs_io | _filter_test_dir
+
+filesnap "after fail commit" $dir/a
+echo
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/1207.out b/tests/generic/1207.out
new file mode 100644
index 0000000000..ee33564067
--- /dev/null
+++ b/tests/generic/1207.out
@@ -0,0 +1,48 @@
+QA output created by 1207
+before commit
+d712f003e9d467e063cda1baf319b928  TEST_DIR/test-1207/a
+wrote 56320/56320 bytes at offset 45056
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+Committed updates to 'TEST_DIR/test-1207/a'.
+after commit
+bedbd22b58a680219a1225353f6195fa  TEST_DIR/test-1207/a
+
+before shorten commit
+d712f003e9d467e063cda1baf319b928  TEST_DIR/test-1207/a
+wrote 56320/56320 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+Committed updates to 'TEST_DIR/test-1207/a'.
+after shorten commit
+52353039d89c5f2b76b9003464e5276a  TEST_DIR/test-1207/a
+
+before lengthen commit
+d712f003e9d467e063cda1baf319b928  TEST_DIR/test-1207/a
+wrote 4231677/4231677 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+Committed updates to 'TEST_DIR/test-1207/a'.
+after lengthen commit
+1839e7c6bf616160dc51b12179db2642  TEST_DIR/test-1207/a
+
+before cancel
+d712f003e9d467e063cda1baf319b928  TEST_DIR/test-1207/a
+wrote 56320/56320 bytes at offset 45056
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+Cancelled updates to 'TEST_DIR/test-1207/a'.
+after cancel
+d712f003e9d467e063cda1baf319b928  TEST_DIR/test-1207/a
+
+before fail commit
+d712f003e9d467e063cda1baf319b928  TEST_DIR/test-1207/a
+committing update: Device or resource busy
+wrote 56320/56320 bytes at offset 45056
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 56320/56320 bytes at offset 45056
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+[000] TEST_DIR/test-1207/a (xfs,non-sync,non-direct,read-write)
+ 001  TEST_DIR/test-1207/a (fileupdate) (xfs,non-sync,non-direct,read-write)
+[000] TEST_DIR/test-1207/a (fileupdate) (xfs,non-sync,non-direct,read-write)
+wrote 11264/11264 bytes at offset 22528
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+after fail commit
+d712f003e9d467e063cda1baf319b928  TEST_DIR/test-1207/a
+
diff --git a/tests/generic/1209 b/tests/generic/1209
new file mode 100755
index 0000000000..6b287654ca
--- /dev/null
+++ b/tests/generic/1209
@@ -0,0 +1,101 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1209
+#
+# Try invalid parameters to see if they fail.
+
+. ./common/preamble
+_begin_fstest auto quick fiexchange swapext
+
+# Override the default cleanup function.
+_cleanup()
+{
+	cd /
+	rm -r -f $tmp.* $dir
+}
+
+# Import common functions.
+. ./common/filter
+. ./common/reflink
+
+# real QA test starts here
+_require_xfs_io_command swapext '-v vfs'
+_require_xfs_io_command startupdate
+_require_test
+_require_scratch
+_require_chattr i
+
+dir=$TEST_DIR/test-$seq
+mkdir -p $dir
+blksz=65536
+nrblks=64
+
+_scratch_mkfs >> $seqres.full
+_scratch_mount
+
+_pwrite_byte 0x58 0 $((blksz * nrblks)) $dir/a >> $seqres.full
+_pwrite_byte 0x58 0 $((blksz * nrblks)) $dir/b >> $seqres.full
+
+echo Immutable files
+$XFS_IO_PROG -c 'chattr +i' -c "swapext $dir/b" $dir/a
+$CHATTR_PROG -i $dir/a
+
+echo Readonly files
+$XFS_IO_PROG -r -c "swapext $dir/b" $dir/a
+
+echo Directories
+$XFS_IO_PROG -c "swapext $dir/b" $dir
+
+echo Unaligned ranges
+$XFS_IO_PROG -c "swapext -s 37 -d 61 -l 17 $dir/b" $dir/a
+
+echo file1 range entirely beyond EOF
+$XFS_IO_PROG -c "swapext -s $(( blksz * (nrblks + 500) )) -d 0 -l $blksz $dir/b" $dir/a
+
+echo file2 range entirely beyond EOF
+$XFS_IO_PROG -c "swapext -d $(( blksz * (nrblks + 500) )) -s 0 -l $blksz $dir/b" $dir/a
+
+echo Both ranges entirely beyond EOF
+$XFS_IO_PROG -c "swapext -d $(( blksz * (nrblks + 500) )) -s $(( blksz * (nrblks + 500) )) -l $blksz $dir/b" $dir/a
+
+echo file1 range crossing EOF
+$XFS_IO_PROG -c "swapext -s $(( blksz * (nrblks - 1) )) -d 0 -l $((2 * blksz)) $dir/b" $dir/a
+
+echo file2 range crossing EOF
+$XFS_IO_PROG -c "swapext -d $(( blksz * (nrblks  - 1) )) -s 0 -l $((2 * blksz)) $dir/b" $dir/a
+
+echo Both ranges crossing EOF
+$XFS_IO_PROG -c "swapext -d $(( blksz * (nrblks - 1) )) -s $(( blksz * (nrblks - 1) )) -l $((blksz * 2)) $dir/b" $dir/a
+
+echo file1 unaligned EOF to file2 nowhere near EOF
+_pwrite_byte 0x58 $((blksz * nrblks)) 37 $dir/a >> $seqres.full
+_pwrite_byte 0x59 $((blksz * nrblks)) 37 $dir/b >> $seqres.full
+$XFS_IO_PROG -c "swapext -d 0 -s $(( blksz * nrblks )) -l 37 $dir/b" $dir/a
+
+echo file2 unaligned EOF to file1 nowhere near EOF
+$XFS_IO_PROG -c "swapext -s 0 -d $(( blksz * nrblks )) -l 37 $dir/b" $dir/a
+
+echo Files of unequal length
+_pwrite_byte 0x58 $((blksz * nrblks)) $((blksz * 2)) $dir/a >> $seqres.full
+_pwrite_byte 0x59 $((blksz * nrblks)) $blksz $dir/b >> $seqres.full
+$XFS_IO_PROG -c "swapext $dir/b" $dir/a
+
+echo Files on different filesystems
+_pwrite_byte 0x58 0 $((blksz * nrblks)) $SCRATCH_MNT/c >> $seqres.full
+$XFS_IO_PROG -c "swapext $SCRATCH_MNT/c" $dir/a
+
+echo Files on different mounts
+mkdir -p $SCRATCH_MNT/xyz
+mount --bind $dir $SCRATCH_MNT/xyz --bind
+_pwrite_byte 0x60 0 $((blksz * (nrblks + 2))) $dir/c >> $seqres.full
+$XFS_IO_PROG -c "swapext $SCRATCH_MNT/xyz/c" $dir/a
+umount $SCRATCH_MNT/xyz
+
+echo Swapping a file with itself
+$XFS_IO_PROG -c "swapext $dir/a" $dir/a
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/1209.out b/tests/generic/1209.out
new file mode 100644
index 0000000000..a051ed97d9
--- /dev/null
+++ b/tests/generic/1209.out
@@ -0,0 +1,33 @@
+QA output created by 1209
+Immutable files
+swapext: Operation not permitted
+Readonly files
+swapext: Bad file descriptor
+Directories
+swapext: Is a directory
+Unaligned ranges
+swapext: Invalid argument
+file1 range entirely beyond EOF
+swapext: Invalid argument
+file2 range entirely beyond EOF
+swapext: Invalid argument
+Both ranges entirely beyond EOF
+swapext: Invalid argument
+file1 range crossing EOF
+swapext: Invalid argument
+file2 range crossing EOF
+swapext: Invalid argument
+Both ranges crossing EOF
+swapext: Invalid argument
+file1 unaligned EOF to file2 nowhere near EOF
+swapext: Invalid argument
+file2 unaligned EOF to file1 nowhere near EOF
+swapext: Invalid argument
+Files of unequal length
+swapext: Bad address
+Files on different filesystems
+swapext: Invalid cross-device link
+Files on different mounts
+swapext: Invalid cross-device link
+Swapping a file with itself
+swapext: Invalid argument
diff --git a/tests/generic/1210 b/tests/generic/1210
new file mode 100755
index 0000000000..93a325ad7a
--- /dev/null
+++ b/tests/generic/1210
@@ -0,0 +1,48 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1210
+#
+# Make sure swapext honors RLIMIT_FSIZE.
+
+. ./common/preamble
+_begin_fstest auto quick fiexchange swapext
+
+# Override the default cleanup function.
+_cleanup()
+{
+	cd /
+	rm -r -f $tmp.* $dir
+}
+
+# Import common functions.
+. ./common/filter
+. ./common/reflink
+
+# real QA test starts here
+_require_xfs_io_command swapext '-v vfs'
+_require_test
+
+dir=$TEST_DIR/test-$seq
+mkdir -p $dir
+blksz=65536
+nrblks=64
+
+# Create some 4M files to test swapext
+_pwrite_byte 0x58 0 $((blksz * nrblks)) $dir/a >> $seqres.full
+_pwrite_byte 0x59 0 $((blksz * nrblks)) $dir/b >> $seqres.full
+sync
+md5sum $dir/a $dir/b | _filter_test_dir
+
+# Set FSIZE to twice the blocksize (IOWs, 128k)
+ulimit -f $(( (blksz * 2) / 512))
+ulimit -a >> $seqres.full
+
+# Now try to swapext
+$XFS_IO_PROG -c "swapext $dir/b" $dir/a
+md5sum $dir/a $dir/b | _filter_test_dir
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/1210.out b/tests/generic/1210.out
new file mode 100644
index 0000000000..02d41b8838
--- /dev/null
+++ b/tests/generic/1210.out
@@ -0,0 +1,6 @@
+QA output created by 1210
+d712f003e9d467e063cda1baf319b928  TEST_DIR/test-1210/a
+901e136269b8d283d311697b7c6dc1f2  TEST_DIR/test-1210/b
+swapext: Invalid argument
+d712f003e9d467e063cda1baf319b928  TEST_DIR/test-1210/a
+901e136269b8d283d311697b7c6dc1f2  TEST_DIR/test-1210/b
diff --git a/tests/generic/1211 b/tests/generic/1211
new file mode 100755
index 0000000000..f7b8a8d280
--- /dev/null
+++ b/tests/generic/1211
@@ -0,0 +1,105 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1211
+#
+# Test atomic file replacement when (a) the length is the same; (b) the length
+# is different; and (c) someone modifies the original file and we need to
+# cancel the update.  The staging file is created empty, which implies that the
+# caller wants a full file replacement.
+
+. ./common/preamble
+_begin_fstest auto quick fiexchange swapext
+
+# Override the default cleanup function.
+_cleanup()
+{
+	cd /
+	rm -r -f $tmp.* $dir
+}
+
+# Import common functions.
+. ./common/filter
+
+# real QA test starts here
+_require_xfs_io_command swapext '-v vfs'
+_require_xfs_io_command startupdate '-e'
+_require_test
+
+filesnap() {
+	echo "$1"
+	md5sum $2 | _filter_test_dir
+}
+
+mkfile() {
+	rm -f $dir/a
+	_pwrite_byte 0x58 0 $((blksz * nrblks)) $dir/a >> $seqres.full
+	sync
+}
+
+dir=$TEST_DIR/test-$seq
+mkdir -p $dir
+blksz=65536
+nrblks=64
+
+# Use the atomic file update staging prototype in xfs_io to update a file.
+mkfile
+filesnap "before commit" $dir/a
+
+$XFS_IO_PROG \
+	-c 'startupdate -e' \
+	-c "pwrite -S 0x60 0 $((blksz * nrblks))" \
+	-c 'commitupdate -q' \
+	"$dir/a" 2>&1 | _filter_xfs_io | _filter_test_dir
+
+filesnap "after commit" $dir/a
+echo
+
+# Use the atomic file updates to replace a file with a shorter file.
+mkfile
+filesnap "before shorten commit" $dir/a
+
+$XFS_IO_PROG \
+	-c 'startupdate -e' \
+	-c 'pwrite -S 0x60 0 55k' \
+	-c 'commitupdate -q' \
+	"$dir/a" 2>&1 | _filter_xfs_io | _filter_test_dir
+
+filesnap "after shorten commit" $dir/a
+echo
+
+# Use the atomic file updates to replace a file with a longer file.
+mkfile
+filesnap "before lengthen commit" $dir/a
+
+$XFS_IO_PROG \
+	-c 'startupdate -e' \
+	-c "pwrite -S 0x60 0 $(( (blksz * nrblks) + 37373 ))" \
+	-c 'commitupdate -q' \
+	"$dir/a" 2>&1 | _filter_xfs_io | _filter_test_dir
+
+filesnap "after lengthen commit" $dir/a
+echo
+
+# Now try the update but with the A file open separately so that we clobber
+# mtime and fail the update.
+mkfile
+filesnap "before fail commit" $dir/a
+
+$XFS_IO_PROG \
+	-c "open $dir/a" \
+	-c 'startupdate -e ' \
+	-c 'pwrite -S 0x58 44k 55k -b 1m' \
+	-c 'file 0' \
+	-c 'close' \
+	-c 'pwrite -S 0x61 22k 11k -b 1m' \
+	-c 'commitupdate -q' \
+	"$dir/a" 2>&1 | _filter_xfs_io | _filter_test_dir
+
+filesnap "after fail commit" $dir/a
+echo
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/1211.out b/tests/generic/1211.out
new file mode 100644
index 0000000000..a149de198f
--- /dev/null
+++ b/tests/generic/1211.out
@@ -0,0 +1,40 @@
+QA output created by 1211
+before commit
+d712f003e9d467e063cda1baf319b928  TEST_DIR/test-1211/a
+wrote 4194304/4194304 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+Committed updates to 'TEST_DIR/test-1211/a'.
+after commit
+0558063c531ca7c7864fc5a4923f7144  TEST_DIR/test-1211/a
+
+before shorten commit
+d712f003e9d467e063cda1baf319b928  TEST_DIR/test-1211/a
+wrote 56320/56320 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+Committed updates to 'TEST_DIR/test-1211/a'.
+after shorten commit
+52353039d89c5f2b76b9003464e5276a  TEST_DIR/test-1211/a
+
+before lengthen commit
+d712f003e9d467e063cda1baf319b928  TEST_DIR/test-1211/a
+wrote 4231677/4231677 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+Committed updates to 'TEST_DIR/test-1211/a'.
+after lengthen commit
+1839e7c6bf616160dc51b12179db2642  TEST_DIR/test-1211/a
+
+before fail commit
+d712f003e9d467e063cda1baf319b928  TEST_DIR/test-1211/a
+committing update: Device or resource busy
+wrote 56320/56320 bytes at offset 45056
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 56320/56320 bytes at offset 45056
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+[000] TEST_DIR/test-1211/a (xfs,non-sync,non-direct,read-write)
+ 001  TEST_DIR/test-1211/a (fileupdate) (xfs,non-sync,non-direct,read-write)
+[000] TEST_DIR/test-1211/a (fileupdate) (xfs,non-sync,non-direct,read-write)
+wrote 11264/11264 bytes at offset 22528
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+after fail commit
+d712f003e9d467e063cda1baf319b928  TEST_DIR/test-1211/a
+
diff --git a/tests/generic/1212 b/tests/generic/1212
new file mode 100755
index 0000000000..c6599e3a35
--- /dev/null
+++ b/tests/generic/1212
@@ -0,0 +1,58 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1212
+#
+# Stress testing with a lot of extents.
+
+. ./common/preamble
+_begin_fstest auto quick fiexchange swapext
+
+# Override the default cleanup function.
+_cleanup()
+{
+	cd /
+	rm -r -f $tmp.* $dir
+}
+
+# Import common functions.
+. ./common/filter
+
+# real QA test starts here
+_require_xfs_io_command swapext '-v vfs'
+_require_test_program punch-alternating
+_require_test
+
+dir=$TEST_DIR/test-$seq
+mkdir -p $dir
+blksz=$(_get_file_block_size $TEST_DIR)
+nrblks=$((LOAD_FACTOR * 100000))
+
+_require_fs_space $TEST_DIR $(( (2 * blksz * nrblks) / 1024 ))
+
+# Create some big swiss cheese files to test swapext with a lot of extents
+_pwrite_byte 0x58 0 $((blksz * nrblks)) $dir/a >> $seqres.full
+$here/src/punch-alternating $dir/a
+_pwrite_byte 0x59 0 $((blksz * nrblks)) $dir/b >> $seqres.full
+$here/src/punch-alternating -o 1 $dir/b
+filefrag -v $dir/a $dir/b >> $seqres.full
+
+# Now try to swapext
+md5_a="$(md5sum < $dir/a)"
+md5_b="$(md5sum < $dir/b)"
+date >> $seqres.full
+$XFS_IO_PROG -c "swapext $dir/b" $dir/a
+date >> $seqres.full
+
+echo "md5_a=$md5_a" >> $seqres.full
+echo "md5_b=$md5_b" >> $seqres.full
+md5sum $dir/a $dir/b >> $seqres.full
+
+test "$(md5sum < $dir/b)" = "$md5_a" || echo "file b does not match former a"
+test "$(md5sum < $dir/a)" = "$md5_b" || echo "file a does not match former b"
+
+echo "Silence is golden!"
+# success, all done
+status=0
+exit
diff --git a/tests/generic/1212.out b/tests/generic/1212.out
new file mode 100644
index 0000000000..fb775977ca
--- /dev/null
+++ b/tests/generic/1212.out
@@ -0,0 +1,2 @@
+QA output created by 1212
+Silence is golden!
diff --git a/tests/generic/1213 b/tests/generic/1213
new file mode 100755
index 0000000000..d466263a9d
--- /dev/null
+++ b/tests/generic/1213
@@ -0,0 +1,126 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1213
+#
+# Test non-root atomic file updates when (a) the file contents are cloned into
+# the staging file; and (b) when the staging file is created empty.
+
+. ./common/preamble
+_begin_fstest auto quick fiexchange swapext
+
+# Override the default cleanup function.
+_cleanup()
+{
+	cd /
+	rm -r -f $tmp.* $dir
+}
+
+# Import common functions.
+. ./common/filter
+. ./common/reflink
+
+# real QA test starts here
+_require_xfs_io_command startupdate
+_require_test_reflink
+_require_test
+_require_user
+
+filesnap() {
+	echo "$1"
+	md5sum $2 | _filter_test_dir
+}
+
+mkfile() {
+	rm -f $dir/a
+	_pwrite_byte 0x58 0 $((blksz * nrblks)) $dir/a >> $seqres.full
+	chown $qa_user $dir/a $dir/
+	sync
+}
+
+dir=$TEST_DIR/test-$seq
+mkdir -p $dir
+blksz=65536
+nrblks=64
+
+# Use the atomic file update staging prototype in xfs_io to update a file.
+mkfile
+filesnap "before commit" $dir/a
+
+cmd="$XFS_IO_PROG \
+	-c 'startupdate' \
+	-c 'pwrite -S 0x60 44k 55k -b 1m' \
+	-c 'commitupdate -q' \
+	\"$dir/a\""
+su -s /bin/bash -c "$cmd" $qa_user 2>&1 | _filter_xfs_io | _filter_test_dir
+
+filesnap "after commit" $dir/a
+echo
+
+# Use the atomic file updates to replace a file with a shorter file.
+mkfile
+filesnap "before shorten commit" $dir/a
+
+cmd="$XFS_IO_PROG \
+	-c 'startupdate' \
+	-c 'truncate 55k' \
+	-c 'pwrite -S 0x60 0 55k' \
+	-c 'commitupdate -q' \
+	\"$dir/a\""
+su -s /bin/bash -c "$cmd" $qa_user 2>&1 | _filter_xfs_io | _filter_test_dir
+
+filesnap "after shorten commit" $dir/a
+echo
+
+# Use the atomic file updates to replace a file with a longer file.
+mkfile
+filesnap "before lengthen commit" $dir/a
+
+cmd="$XFS_IO_PROG \
+	-c 'startupdate' \
+	-c \"pwrite -S 0x60 0 $(( (blksz * nrblks) + 37373 ))\" \
+	-c 'commitupdate -q' \
+	\"$dir/a\""
+su -s /bin/bash -c "$cmd" $qa_user 2>&1 | _filter_xfs_io | _filter_test_dir
+
+filesnap "after lengthen commit" $dir/a
+echo
+
+# Use the atomic file update staging prototype in xfs_io to cancel updating a
+# file.
+mkfile
+filesnap "before cancel" $dir/a
+
+cmd="$XFS_IO_PROG \
+	-c 'startupdate' \
+	-c 'pwrite -S 0x60 44k 55k -b 1m' \
+	-c 'cancelupdate' \
+	\"$dir/a\""
+su -s /bin/bash -c "$cmd" $qa_user 2>&1 | _filter_xfs_io | _filter_test_dir
+
+filesnap "after cancel" $dir/a
+echo
+
+# Now try the update but with the A file open separately so that we clobber
+# mtime and fail the update.
+mkfile
+filesnap "before fail commit" $dir/a
+
+cmd="$XFS_IO_PROG \
+	-c \"open $dir/a\" \
+	-c 'startupdate' \
+	-c 'pwrite -S 0x58 44k 55k -b 1m' \
+	-c 'file 0' \
+	-c 'close' \
+	-c 'pwrite -S 0x61 22k 11k -b 1m' \
+	-c 'commitupdate -q' \
+	\"$dir/a\""
+su -s /bin/bash -c "$cmd" $qa_user 2>&1 | _filter_xfs_io | _filter_test_dir
+
+filesnap "after fail commit" $dir/a
+echo
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/1213.out b/tests/generic/1213.out
new file mode 100644
index 0000000000..b5a140560d
--- /dev/null
+++ b/tests/generic/1213.out
@@ -0,0 +1,48 @@
+QA output created by 1213
+before commit
+d712f003e9d467e063cda1baf319b928  TEST_DIR/test-1213/a
+wrote 56320/56320 bytes at offset 45056
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+Committed updates to 'TEST_DIR/test-1213/a'.
+after commit
+bedbd22b58a680219a1225353f6195fa  TEST_DIR/test-1213/a
+
+before shorten commit
+d712f003e9d467e063cda1baf319b928  TEST_DIR/test-1213/a
+wrote 56320/56320 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+Committed updates to 'TEST_DIR/test-1213/a'.
+after shorten commit
+52353039d89c5f2b76b9003464e5276a  TEST_DIR/test-1213/a
+
+before lengthen commit
+d712f003e9d467e063cda1baf319b928  TEST_DIR/test-1213/a
+wrote 4231677/4231677 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+Committed updates to 'TEST_DIR/test-1213/a'.
+after lengthen commit
+1839e7c6bf616160dc51b12179db2642  TEST_DIR/test-1213/a
+
+before cancel
+d712f003e9d467e063cda1baf319b928  TEST_DIR/test-1213/a
+wrote 56320/56320 bytes at offset 45056
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+Cancelled updates to 'TEST_DIR/test-1213/a'.
+after cancel
+d712f003e9d467e063cda1baf319b928  TEST_DIR/test-1213/a
+
+before fail commit
+d712f003e9d467e063cda1baf319b928  TEST_DIR/test-1213/a
+committing update: Device or resource busy
+wrote 56320/56320 bytes at offset 45056
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 56320/56320 bytes at offset 45056
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+[000] TEST_DIR/test-1213/a (xfs,non-sync,non-direct,read-write)
+ 001  TEST_DIR/test-1213/a (fileupdate) (xfs,non-sync,non-direct,read-write)
+[000] TEST_DIR/test-1213/a (fileupdate) (xfs,non-sync,non-direct,read-write)
+wrote 11264/11264 bytes at offset 22528
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+after fail commit
+d712f003e9d467e063cda1baf319b928  TEST_DIR/test-1213/a
+
diff --git a/tests/generic/1214 b/tests/generic/1214
new file mode 100755
index 0000000000..0cacc57e9c
--- /dev/null
+++ b/tests/generic/1214
@@ -0,0 +1,63 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1214
+#
+# Test swapext with the fsync flag flushes everything to disk before the call
+# returns.
+
+. ./common/preamble
+_begin_fstest auto quick fiexchange swapext
+
+# Override the default cleanup function.
+_cleanup()
+{
+	cd /
+	rm -r -f $tmp.* $dir
+}
+
+# Import common functions.
+. ./common/filter
+. ./common/reflink
+
+# real QA test starts here
+_require_test_program "punch-alternating"
+_require_xfs_io_command swapext '-v vfs -a'
+_require_scratch
+_require_scratch_shutdown
+
+_scratch_mkfs >> $seqres.full
+_scratch_mount
+
+_pwrite_byte 0x58 0 2m $SCRATCH_MNT/a >> $seqres.full
+_pwrite_byte 0x59 0 2m $SCRATCH_MNT/b >> $seqres.full
+$here/src/punch-alternating $SCRATCH_MNT/a
+$here/src/punch-alternating $SCRATCH_MNT/b
+
+old_a=$(md5sum $SCRATCH_MNT/a | awk '{print $1}')
+old_b=$(md5sum $SCRATCH_MNT/b | awk '{print $1}')
+echo "md5 a: $old_a md5 b: $old_b" >> $seqres.full
+
+od -tx1 -Ad -c $SCRATCH_MNT/a > /tmp/a0
+od -tx1 -Ad -c $SCRATCH_MNT/b > /tmp/b0
+
+echo swap >> $seqres.full
+$XFS_IO_PROG -c "swapext -v vfs -a -e -f -u $SCRATCH_MNT/a" $SCRATCH_MNT/b
+_scratch_shutdown
+_scratch_cycle_mount
+
+new_a=$(md5sum $SCRATCH_MNT/a | awk '{print $1}')
+new_b=$(md5sum $SCRATCH_MNT/b | awk '{print $1}')
+echo "md5 a: $new_a md5 b: $new_b" >> $seqres.full
+
+test $old_a = $new_b || echo "scratch file B doesn't match old file A"
+test $old_b = $new_a || echo "scratch file A doesn't match old file B"
+
+od -tx1 -Ad -c $SCRATCH_MNT/a > /tmp/a1
+od -tx1 -Ad -c $SCRATCH_MNT/b > /tmp/b1
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/generic/1214.out b/tests/generic/1214.out
new file mode 100644
index 0000000000..a529e42333
--- /dev/null
+++ b/tests/generic/1214.out
@@ -0,0 +1,2 @@
+QA output created by 1214
+Silence is golden
diff --git a/tests/generic/1215 b/tests/generic/1215
new file mode 100755
index 0000000000..28eb8356d8
--- /dev/null
+++ b/tests/generic/1215
@@ -0,0 +1,70 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1215
+#
+# Test swapext with the dry run flag doesn't change anything.
+
+. ./common/preamble
+_begin_fstest auto quick fiexchange swapext
+
+# Override the default cleanup function.
+_cleanup()
+{
+	cd /
+	rm -r -f $tmp.* $dir
+}
+
+# Import common functions.
+. ./common/filter
+. ./common/reflink
+
+# real QA test starts here
+_require_test_program "punch-alternating"
+_require_xfs_io_command swapext '-v vfs'
+_require_scratch
+
+_scratch_mkfs >> $seqres.full
+_scratch_mount
+
+_pwrite_byte 0x58 0 1m $SCRATCH_MNT/a >> $seqres.full
+_pwrite_byte 0x59 0 2m $SCRATCH_MNT/b >> $seqres.full
+$XFS_IO_PROG -c 'truncate 2m' $SCRATCH_MNT/a
+$here/src/punch-alternating $SCRATCH_MNT/a
+$here/src/punch-alternating $SCRATCH_MNT/b
+
+old_a=$(md5sum $SCRATCH_MNT/a | awk '{print $1}')
+old_b=$(md5sum $SCRATCH_MNT/b | awk '{print $1}')
+echo "md5 a: $old_a md5 b: $old_b" >> $seqres.full
+
+# Test swapext with the -n option, which will do all the input parameter
+# checking and return 0 without changing anything.
+echo dry run swap >> $seqres.full
+$XFS_IO_PROG -c "swapext -v vfs -n -f -u $SCRATCH_MNT/a" $SCRATCH_MNT/b
+_scratch_cycle_mount
+
+new_a=$(md5sum $SCRATCH_MNT/a | awk '{print $1}')
+new_b=$(md5sum $SCRATCH_MNT/b | awk '{print $1}')
+echo "md5 a: $new_a md5 b: $new_b" >> $seqres.full
+
+test $old_a = $new_a || echo "scratch file A should not have swapped"
+test $old_b = $new_b || echo "scratch file B should not have swapped"
+
+# Do it again, but without the -n option, to prove that we can actually
+# swap the file contents.
+echo actual swap >> $seqres.full
+$XFS_IO_PROG -c "swapext -v vfs -f -u $SCRATCH_MNT/a" $SCRATCH_MNT/b
+_scratch_cycle_mount
+
+new_a=$(md5sum $SCRATCH_MNT/a | awk '{print $1}')
+new_b=$(md5sum $SCRATCH_MNT/b | awk '{print $1}')
+echo "md5 a: $new_a md5 b: $new_b" >> $seqres.full
+
+test $old_a = $new_b || echo "scratch file A should have swapped"
+test $old_b = $new_a || echo "scratch file B should have swapped"
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/generic/1215.out b/tests/generic/1215.out
new file mode 100644
index 0000000000..f68a8e6998
--- /dev/null
+++ b/tests/generic/1215.out
@@ -0,0 +1,2 @@
+QA output created by 1215
+Silence is golden
diff --git a/tests/xfs/1208 b/tests/xfs/1208
new file mode 100755
index 0000000000..3106a4036c
--- /dev/null
+++ b/tests/xfs/1208
@@ -0,0 +1,62 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1208
+#
+# Make sure an atomic swapext actually runs to completion even if we shut
+# down the filesystem midway through.
+
+. ./common/preamble
+_begin_fstest auto quick fiexchange swapext
+
+# Override the default cleanup function.
+_cleanup()
+{
+	cd /
+	rm -r -f $tmp.* $dir
+}
+
+# Import common functions.
+. ./common/filter
+. ./common/reflink
+. ./common/inject
+
+# real QA test starts here
+_supported_fs xfs
+_require_xfs_io_command swapext '-v vfs -a'
+_require_test_program "punch-alternating"
+_require_xfs_io_command startupdate
+_require_xfs_io_error_injection "bmap_finish_one"
+_require_test
+
+filesnap() {
+	echo "$1"
+	md5sum $dir/a $dir/b $dir/c | _filter_test_dir
+}
+
+dir=$TEST_DIR/test-$seq
+mkdir -p $dir
+blksz=65536
+nrblks=137
+
+# Create two files to swap, and try to fragment the first file.
+rm -f $dir/a
+_pwrite_byte 0x58 0 $((blksz * nrblks)) $dir/a >> $seqres.full
+$here/src/punch-alternating $dir/a
+_pwrite_byte 0x59 0 $((blksz * nrblks)) $dir/b >> $seqres.full
+_pwrite_byte 0x59 0 $((blksz * nrblks)) $dir/c >> $seqres.full
+_pwrite_byte 0x58 0 $((blksz * nrblks)) $dir/a >> $seqres.full
+sync
+
+# Inject a bmap error and trigger it via swapext.
+filesnap "before commit"
+$XFS_IO_PROG -x -c 'inject bmap_finish_one' -c "swapext $dir/b" $dir/a
+
+# Check the file afterwards.
+_test_cycle_mount
+filesnap "after commit"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1208.out b/tests/xfs/1208.out
new file mode 100644
index 0000000000..b6aa1b6231
--- /dev/null
+++ b/tests/xfs/1208.out
@@ -0,0 +1,10 @@
+QA output created by 1208
+before commit
+c7221b1494117327570a0958b0abca51  TEST_DIR/test-1208/a
+30cc2b6b307081e10972317013efb0f3  TEST_DIR/test-1208/b
+30cc2b6b307081e10972317013efb0f3  TEST_DIR/test-1208/c
+swapext: Input/output error
+after commit
+30cc2b6b307081e10972317013efb0f3  TEST_DIR/test-1208/a
+c7221b1494117327570a0958b0abca51  TEST_DIR/test-1208/b
+30cc2b6b307081e10972317013efb0f3  TEST_DIR/test-1208/c

