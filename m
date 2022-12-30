Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70494C46467
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:30:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236403AbiLaDaT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:30:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236433AbiLaDaB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:30:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB9BD1659F;
        Fri, 30 Dec 2022 19:30:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B6E4B81DDB;
        Sat, 31 Dec 2022 03:29:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18905C433EF;
        Sat, 31 Dec 2022 03:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672457398;
        bh=w5Olm+IHvx7OA9BizKYwVMqrcIpd8/x0mBpZQx4dICM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=svGoJU96n8p69L/S0C2BjUHLRNSwR84t1KoTAphCJmpTHoOCAuM4Sheit6dHkq/YV
         lej7q/yenK86fLDsEp76JdJ9n22XuWSatF2C38t8NES9xvwKa7DW2Vj3UyAlz+TzGX
         9FqgHz9gWbz0FuUHIGdBDb8LvZByec8aWJgwVK1E37boekFTm3/BRKERhHWNZ/L1ql
         g3iBWJoUKCCTjSgUkMqgQtniFxuGi3rH2kFjSmIEwJHl0LywPBo5uxtK+2rnd166Cb
         u603+Ca+O51D5C/yWULnQf3GSvY8p0koAJzKuWYD3e40D8I7pUNKpeTqXMn+tN6UVt
         uD8AhpF0EU5bA==
Subject: [PATCH 1/1] xfs: test clearing of free space
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:21:17 -0800
Message-ID: <167243887793.742091.4995044378945793592.stgit@magnolia>
In-Reply-To: <167243887781.742091.16659657751012326997.stgit@magnolia>
References: <167243887781.742091.16659657751012326997.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Simple regression test for the spaceman clearspace command, which tries
to free all the used space in some part of the filesystem.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/rc          |    2 +
 tests/xfs/1400     |   57 +++++++++++++++++++++++++++++++++++++
 tests/xfs/1400.out |    2 +
 tests/xfs/1401     |   80 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1401.out |    2 +
 5 files changed, 142 insertions(+), 1 deletion(-)
 create mode 100755 tests/xfs/1400
 create mode 100644 tests/xfs/1400.out
 create mode 100755 tests/xfs/1401
 create mode 100644 tests/xfs/1401.out


diff --git a/common/rc b/common/rc
index 20fe51f502..bf1d0ded39 100644
--- a/common/rc
+++ b/common/rc
@@ -2512,7 +2512,7 @@ _require_xfs_io_command()
 		testio=`$XFS_IO_PROG -F -f -c "$command $param 0 1m" $testfile 2>&1`
 		param_checked="$param"
 		;;
-	"fpunch" | "fcollapse" | "zero" | "fzero" | "finsert" | "funshare")
+	"fpunch" | "fcollapse" | "zero" | "fzero" | "finsert" | "funshare" | "fmapfree")
 		local blocksize=$(_get_file_block_size $TEST_DIR)
 		testio=`$XFS_IO_PROG -F -f -c "pwrite 0 $((5 * $blocksize))" \
 			-c "fsync" -c "$command $blocksize $((2 * $blocksize))" \
diff --git a/tests/xfs/1400 b/tests/xfs/1400
new file mode 100755
index 0000000000..c054bf6ed7
--- /dev/null
+++ b/tests/xfs/1400
@@ -0,0 +1,57 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test 1400
+#
+# Basic functionality testing for FALLOC_FL_MAP_FREE
+#
+. ./common/preamble
+_begin_fstest auto prealloc
+
+# Import common functions.
+. ./common/filter
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs generic
+_require_scratch
+_require_xfs_io_command "fmapfree"
+
+_scratch_mkfs | _filter_mkfs 2> $tmp.mkfs > /dev/null
+_scratch_mount >> $seqres.full
+. $tmp.mkfs
+
+testfile="$SCRATCH_MNT/$seq.txt"
+touch $testfile
+if $XFS_IO_PROG -c 'stat -v' $testfile | grep -q 'realtime'; then
+	# realtime
+	increment=$((dbsize * rtblocks / 10))
+	length=$((dbsize * rtblocks))
+else
+	# data
+	increment=$((dbsize * dblocks / 10))
+	length=$((dbsize * dblocks))
+fi
+
+free_bytes=$(stat -f -c '%f * %S' $testfile | bc)
+
+echo "free space: $free_bytes; increment: $increment; length: $length" >> $seqres.full
+
+# Map all the free space on that device, 10% at a time
+for ((start = 0; start < length; start += increment)); do
+	$XFS_IO_PROG -f -c "fmapfree $start $increment" $testfile
+done
+
+space_used=$(stat -c '%b * %B' $testfile | bc)
+
+echo "space captured: $space_used" >> $seqres.full
+$FILEFRAG_PROG -v $testfile >> $seqres.full
+
+# Did we get within 10% of the free space?
+_within_tolerance "mapfree space used" $space_used $free_bytes 10% -v
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1400.out b/tests/xfs/1400.out
new file mode 100644
index 0000000000..601404d7a4
--- /dev/null
+++ b/tests/xfs/1400.out
@@ -0,0 +1,2 @@
+QA output created by 1400
+mapfree space used is in range
diff --git a/tests/xfs/1401 b/tests/xfs/1401
new file mode 100755
index 0000000000..8c0a545858
--- /dev/null
+++ b/tests/xfs/1401
@@ -0,0 +1,80 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1401
+#
+# Basic functionality testing for the free space defragmenter.
+#
+. ./common/preamble
+_begin_fstest auto defrag shrinkfs
+
+# Override the default cleanup function.
+# _cleanup()
+# {
+# 	cd /
+# 	rm -r -f $tmp.*
+# }
+
+# Import common functions.
+. ./common/filter
+
+# real QA test starts here
+
+_notrun "XXX test is not ready yet; you need to deal with tail blocks"
+
+# Modify as appropriate.
+_supported_fs generic
+_require_scratch
+_require_xfs_spaceman_command "clearfree"
+
+_scratch_mkfs | _filter_mkfs 2> $tmp.mkfs > /dev/null
+cat $tmp.mkfs >> $seqres.full
+. $tmp.mkfs
+_scratch_mount >> $seqres.full
+
+cpus=$(( $(src/feature -o) * 4))
+
+# Use fsstress to create a directory tree with some variability
+FSSTRESS_ARGS=$(_scale_fsstress_args -p 4 -d $SCRATCH_MNT -n 4000 $FSSTRESS_AVOID)
+$FSSTRESS_PROG $FSSTRESS_ARGS >> $seqres.full
+
+$XFS_IO_PROG -c 'stat -v' $SCRATCH_MNT >> $seqres.full
+
+if $XFS_IO_PROG -c 'stat -v' $SCRATCH_MNT | grep -q 'rt-inherit'; then
+	# realtime
+	increment=$((dbsize * rtblocks / agcount))
+	length=$((dbsize * rtblocks))
+	fsmap_devarg="-r"
+else
+	# data
+	increment=$((dbsize * agsize))
+	length=$((dbsize * dblocks))
+	fsmap_devarg="-d"
+fi
+
+echo "start: $start; increment: $increment; length: $length" >> $seqres.full
+$DF_PROG $SCRATCH_MNT >> $seqres.full
+
+TRACE_PROG="strace -s99 -e fallocate,ioctl,openat -o $tmp.strace"
+
+for ((start = 0; start < length; start += increment)); do
+	echo "---------------------------" >> $seqres.full
+	echo "start: $start end: $((start + increment))" >> $seqres.full
+	echo "---------------------------" >> $seqres.full
+
+	fsmap_args="-vvvv $fsmap_devarg $((start / 512)) $((increment / 512))"
+	clearfree_args="-vall $start $increment"
+
+	$XFS_IO_PROG -c "fsmap $fsmap_args" $SCRATCH_MNT > $tmp.before
+	$TRACE_PROG $XFS_SPACEMAN_PROG -c "clearfree $clearfree_args" $SCRATCH_MNT &>> $seqres.full || break
+	cat $tmp.strace >> $seqres.full
+	$XFS_IO_PROG -c "fsmap $fsmap_args" $SCRATCH_MNT > $tmp.after
+	cat $tmp.before >> $seqres.full
+	cat $tmp.after >> $seqres.full
+done
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/1401.out b/tests/xfs/1401.out
new file mode 100644
index 0000000000..504999381e
--- /dev/null
+++ b/tests/xfs/1401.out
@@ -0,0 +1,2 @@
+QA output created by 1401
+Silence is golden

