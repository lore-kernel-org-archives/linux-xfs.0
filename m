Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5AA7C433DB
	for <linux-xfs@archiver.kernel.org>; Sat, 13 Feb 2021 05:34:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6FEF464E8D
	for <linux-xfs@archiver.kernel.org>; Sat, 13 Feb 2021 05:34:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230454AbhBMFeT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 13 Feb 2021 00:34:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:56196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229436AbhBMFeL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 13 Feb 2021 00:34:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 31B6B64E23;
        Sat, 13 Feb 2021 05:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613194410;
        bh=x/zSxpK+3d1rzz2s8LRZC3nSJDiaKULq6SVSzJm0lOI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=RSbOjMLDyQmjTIja3dg+00hZ2HiMuhNdqeNzNjx77MLoImPtpK8R1Jy8hQIKEmtJu
         n9wKaknJVoI/v8ZmYaBqDdFWH0Od2GBBHxiI/OMt2FPCgOut1NxPNRqbRwkM8u5BkN
         r2czUNcPZ8gwejo/eyutBH/m+bJvQQY6xk/MTkDBXtXD+srWgXeTtigdTQ8KBblyDF
         jqyMnP83/m9RSuwoeGtJ+pKufmpcQpCgSSx+xklQAWVEP3mVFyd5t04miGHjlD68dz
         YwBoEN9ZqGZ/meiASHd8pRzEFjLeHwQbGElMMFa6tLHERiuIU8c75YFnyXKvWTPRqH
         3aiTNDk5sBAjg==
Subject: [PATCH 2/2] xfs: test that the needsrepair feature works as
 advertised
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 12 Feb 2021 21:33:29 -0800
Message-ID: <161319440988.403424.4376552322884441241.stgit@magnolia>
In-Reply-To: <161319439859.403424.12347303262615931894.stgit@magnolia>
References: <161319439859.403424.12347303262615931894.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Make sure that the needsrepair feature flag can be cleared only by
repair and that mounts are prohibited when the feature is set.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/768     |   84 ++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/768.out |    2 +
 tests/xfs/770     |  101 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/770.out |    2 +
 tests/xfs/group   |    2 +
 5 files changed, 191 insertions(+)
 create mode 100755 tests/xfs/768
 create mode 100644 tests/xfs/768.out
 create mode 100755 tests/xfs/770
 create mode 100644 tests/xfs/770.out


diff --git a/tests/xfs/768 b/tests/xfs/768
new file mode 100755
index 00000000..9649fddf
--- /dev/null
+++ b/tests/xfs/768
@@ -0,0 +1,84 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2021 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 768
+#
+# Make sure that the kernel won't mount a filesystem if repair forcibly sets
+# NEEDSREPAIR while fixing metadata.  Corrupt a directory in such a way as
+# to force repair to write an invalid dirent value as a sentinel to trigger a
+# repair activity in a later phase.  Use a debug knob in xfs_repair to abort
+# the repair immediately after forcing the flag on.
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1    # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.* $fake_logfile $fake_rtfile
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_fs xfs
+_require_scratch
+grep -q LIBXFS_DEBUG_WRITE_CRASH $XFS_REPAIR_PROG || \
+		_notrun "libxfs write failure injection hook not detected?"
+
+rm -f $seqres.full
+
+# Set up a real filesystem for our actual test
+_scratch_mkfs -m crc=1 >> $seqres.full
+
+# Create a directory large enough to have a dir data block.  2k worth of
+# dirent names ought to do it.
+_scratch_mount
+mkdir -p $SCRATCH_MNT/fubar
+for i in $(seq 0 256 2048); do
+	fname=$(printf "%0255d" $i)
+	ln -s -f urk $SCRATCH_MNT/fubar/$fname
+done
+inum=$(stat -c '%i' $SCRATCH_MNT/fubar)
+_scratch_unmount
+
+# Fuzz the directory
+_scratch_xfs_db -x -c "inode $inum" -c "dblock 0" \
+	-c "fuzz -d bu[2].inumber add" >> $seqres.full
+
+# Try to repair the directory, force it to crash after setting needsrepair
+LIBXFS_DEBUG_WRITE_CRASH=ddev=2 _scratch_xfs_repair 2>> $seqres.full
+test $? -eq 137 || echo "repair should have been killed??"
+_scratch_xfs_db -c 'version' >> $seqres.full
+
+# We can't mount, right?
+_scratch_xfs_db -c 'version' | grep -q NEEDSREPAIR || \
+	echo "NEEDSREPAIR should be set on superblock"
+_try_scratch_mount &> $tmp.mount
+res=$?
+_filter_scratch < $tmp.mount
+if [ $res -eq 0 ]; then
+	echo "Should not be able to mount after needsrepair crash"
+	_scratch_unmount
+fi
+
+# Repair properly this time and retry the mount
+_scratch_xfs_repair 2>> $seqres.full
+_scratch_xfs_db -c 'version' >> $seqres.full
+_scratch_xfs_db -c 'version' | grep -q NEEDSREPAIR && \
+	echo "NEEDSREPAIR should not be set on superblock"
+
+_scratch_mount
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/768.out b/tests/xfs/768.out
new file mode 100644
index 00000000..a7fec26a
--- /dev/null
+++ b/tests/xfs/768.out
@@ -0,0 +1,2 @@
+QA output created by 768
+mount: SCRATCH_MNT: mount(2) system call failed: Structure needs cleaning.
diff --git a/tests/xfs/770 b/tests/xfs/770
new file mode 100755
index 00000000..c16d0049
--- /dev/null
+++ b/tests/xfs/770
@@ -0,0 +1,101 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2021 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 770
+#
+# Populate a filesystem with all types of metadata, then run repair with the
+# libxfs write failure trigger set to go after a single write.  Check that the
+# injected error trips, causing repair to abort, that needsrepair is set on the
+# fs, the kernel won't mount; and that a non-injecting repair run clears
+# needsrepair and makes the filesystem mountable again.
+#
+# Repeat with the trip point set to successively higher numbers of writes until
+# we hit ~200 writes or repair manages to run to completion without tripping.
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1    # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.* $fake_logfile $fake_rtfile
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/populate
+. ./common/filter
+
+# real QA test starts here
+_supported_fs xfs
+
+_require_scratch_xfs_crc		# needsrepair only exists for v5
+_require_populate_commands
+
+rm -f ${RESULT_DIR}/require_scratch	# we take care of checking the fs
+rm -f $seqres.full
+
+max_writes=200			# 200 loops should be enough for anyone
+nr_incr=$((13 / TIME_FACTOR))
+test $nr_incr -lt 1 && nr_incr=1
+for ((nr_writes = 1; nr_writes < max_writes; nr_writes += nr_incr)); do
+	test -w /dev/ttyprintk && \
+		echo "fail after $nr_writes writes" >> /dev/ttyprintk
+	echo "fail after $nr_writes writes" >> $seqres.full
+
+	# Populate the filesystem
+	_scratch_populate_cached nofill >> $seqres.full 2>&1
+
+	# Start a repair and force it to abort after some number of writes
+	LIBXFS_DEBUG_WRITE_CRASH=ddev=$nr_writes _scratch_xfs_repair 2>> $seqres.full
+	res=$?
+	if [ $res -ne 0 ] && [ $res -ne 137 ]; then
+		echo "repair failed with $res??"
+		break
+	elif [ $res -eq 0 ]; then
+		[ $nr_writes -eq 1 ] && \
+			echo "ran to completion on the first try?"
+		break
+	fi
+
+	_scratch_xfs_db -c 'version' >> $seqres.full
+	if _scratch_xfs_db -c 'version' | grep -q NEEDSREPAIR; then
+		# NEEDSREPAIR is set, so check that we can't mount.
+		_try_scratch_mount &>> $seqres.full
+		if [ $? -eq 0 ]; then
+			echo "Should not be able to mount after repair crash"
+			_scratch_unmount
+		fi
+	elif _scratch_xfs_repair -n &>> $seqres.full; then
+		# NEEDSREPAIR was not set, but repair -n didn't find problems.
+		# It's possible that the write failure injector triggered on
+		# the write that clears NEEDSREPAIR.
+		true
+	else
+		# NEEDSREPAIR was not set, but there are errors!
+		echo "NEEDSREPAIR should be set on corrupt fs"
+	fi
+
+	# Repair properly this time and retry the mount
+	_scratch_xfs_repair 2>> $seqres.full
+	_scratch_xfs_db -c 'version' >> $seqres.full
+	_scratch_xfs_db -c 'version' | grep -q NEEDSREPAIR && \
+		echo "NEEDSREPAIR should not be set on superblock"
+
+	# Make sure all the checking tools think this fs is ok
+	_scratch_mount
+	_check_scratch_fs
+	_scratch_unmount
+done
+
+# success, all done
+echo Silence is golden.
+status=0
+exit
diff --git a/tests/xfs/770.out b/tests/xfs/770.out
new file mode 100644
index 00000000..725d740b
--- /dev/null
+++ b/tests/xfs/770.out
@@ -0,0 +1,2 @@
+QA output created by 770
+Silence is golden.
diff --git a/tests/xfs/group b/tests/xfs/group
index 316c2e1e..b4bb006d 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -506,6 +506,8 @@
 761 auto quick realtime
 763 auto quick rw realtime
 765 auto quick quota
+768 auto quick repair
+770 auto repair
 915 auto quick quota
 917 auto quick db
 918 auto quick db

