Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77BEEC433E4
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Mar 2021 04:21:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46F086198E
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Mar 2021 04:21:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbhCWEU3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Mar 2021 00:20:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:46280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229504AbhCWEUG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 Mar 2021 00:20:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6BE1161990;
        Tue, 23 Mar 2021 04:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616473206;
        bh=CS4SH8KgPIx8OVy4L/LLCrTlKjbpVjHmTpCCMJgbQ2g=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=GE/LtvsADoXRaMj1ZK1nYJ+40klLwl7VJNNmt2ZYsQhjLbRNm6+j68ThR90jkV1aD
         pv4HVdnnxkXjfSupZEDsuYbt8ARVkvvr+Y7XWWQgJ7xoQ+ZdvW4uCxKyksjtXuwX3R
         lO/aHp4s0fMMEVwnxFAh4ylxkO/W0tMTivO7tz1jkb2Gpiwq/1MwhFbrsDyG2C1JqG
         wHwESmbUgJbuBoeSSxsTX2tAYNqz0zSn3wbE+MR+m6eswyYbszR2BSOug0pc8t4PoI
         z8LsRaH+yEwsxnJ10Om2fHGjjIAKG4q3w1II06+wMOuacKv7l6puGuIBE2baAxf8FE
         +jg3mYKCyqCAA==
Subject: [PATCH 1/3] xfs: test rtalloc alignment and math errors
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Mon, 22 Mar 2021 21:20:06 -0700
Message-ID: <161647320615.3430465.16963127280244500558.stgit@magnolia>
In-Reply-To: <161647320063.3430465.17720673716578854275.stgit@magnolia>
References: <161647320063.3430465.17720673716578854275.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add a couple of regression tests for "xfs: make sure the rt allocator
doesn't run off the end" and "xfs: ensure that fpunch, fcollapse, and
finsert operations are aligned to rt extent size".

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/759     |  102 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/759.out |    2 +
 tests/xfs/760     |   68 +++++++++++++++++++++++++++++++++++
 tests/xfs/760.out |    9 +++++
 tests/xfs/group   |    2 +
 5 files changed, 183 insertions(+)
 create mode 100755 tests/xfs/759
 create mode 100644 tests/xfs/759.out
 create mode 100755 tests/xfs/760
 create mode 100644 tests/xfs/760.out


diff --git a/tests/xfs/759 b/tests/xfs/759
new file mode 100755
index 00000000..d9031808
--- /dev/null
+++ b/tests/xfs/759
@@ -0,0 +1,102 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2021 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 759
+#
+# This is a regression test for commit 2a6ca4baed62 ("xfs: make sure the rt
+# allocator doesn't run off the end") which fixes an overflow error in the
+# _near realtime allocator.  If the rt bitmap ends exactly at the end of a
+# block and the number of rt extents is large enough to allow an allocation
+# request larger than the maximum extent size, it's possible that during a
+# large allocation request, the allocator will fail to constrain maxlen on the
+# second run through the loop, and the rt bitmap range check will run right off
+# the end of the rtbitmap file.  When this happens, xfs triggers a verifier
+# error and returns EFSCORRUPTED.
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
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_fs xfs
+_require_scratch
+_require_realtime
+_require_test_program "punch-alternating"
+
+rm -f $seqres.full
+
+# Format filesystem to get the block size
+_scratch_mkfs > $seqres.full
+_scratch_mount >> $seqres.full
+
+blksz=$(_get_block_size $SCRATCH_MNT)
+rextsize=$($XFS_INFO_PROG $SCRATCH_MNT | grep realtime.*extsz | sed -e 's/^.*extsz=\([0-9]*\).*$/\1/g')
+rextblks=$((rextsize / blksz))
+
+echo "blksz $blksz rextsize $rextsize rextblks $rextblks" >> $seqres.full
+
+_scratch_unmount
+
+# Format filesystem with a realtime volume whose size fits the following:
+# 1. Longer than (XFS MAXEXTLEN * blocksize) bytes so that a large fallocate
+#    request can create a maximally sized data fork extent mapping and then
+#    ask the allocator for even more blocks.
+# 2. Exactly a multiple of (NBBY * blksz * rextsize) bytes.
+
+rtsize1=$((2097151 * blksz))
+rtsize2=$((8 * blksz * rextsize))
+rtsize=$(( $(blockdev --getsz $SCRATCH_RTDEV) * 512 ))
+
+echo "rtsize1 $rtsize1 rtsize2 $rtsize2 rtsize $rtsize" >> $seqres.full
+
+test $rtsize -gt $rtsize1 || \
+	_notrun "scratch rt device too small, need $rtsize1 bytes"
+test $rtsize -gt $rtsize2 || \
+	_notrun "scratch rt device too small, need $rtsize2 bytes"
+
+rtsize=$((rtsize - (rtsize % rtsize2)))
+
+echo "rt size will be $rtsize" >> $seqres.full
+
+_scratch_mkfs -r size=$rtsize >> $seqres.full
+_scratch_mount >> $seqres.full
+
+# Make sure the root directory has rtinherit set so our test file will too
+$XFS_IO_PROG -c 'chattr +t' $SCRATCH_MNT
+
+# Allocate some stuff at the start, to force the first falloc of the ouch file
+# to happen somewhere in the middle of the rt volume
+$XFS_IO_PROG -f -c 'falloc 0 64m' "$SCRATCH_MNT/b"
+$here/src/punch-alternating -i $((rextblks * 2)) -s $((rextblks)) "$SCRATCH_MNT/b"
+
+avail="$(df -P "$SCRATCH_MNT" | awk 'END {print $4}')"1
+toobig="$((avail * 2))"
+
+# falloc the ouch file in the middle of the rt extent to exercise the near
+# allocator in the last step.
+$XFS_IO_PROG -f -c 'falloc 0 1g' "$SCRATCH_MNT/ouch"
+
+# Try to get the near allocator to overflow on an allocation that matches
+# exactly one of the rtsummary size levels.  This should return ENOSPC and
+# not EFSCORRUPTED.
+$XFS_IO_PROG -f -c "falloc 0 ${toobig}k" "$SCRATCH_MNT/ouch"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/759.out b/tests/xfs/759.out
new file mode 100644
index 00000000..df693d50
--- /dev/null
+++ b/tests/xfs/759.out
@@ -0,0 +1,2 @@
+QA output created by 759
+fallocate: No space left on device
diff --git a/tests/xfs/760 b/tests/xfs/760
new file mode 100755
index 00000000..7f2b52d4
--- /dev/null
+++ b/tests/xfs/760
@@ -0,0 +1,68 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2021 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 760
+#
+# Make sure we validate realtime extent size alignment for fallocate modes.
+# This is a regression test for fe341eb151ec ("xfs: ensure that fpunch,
+# fcollapse, and finsert operations are aligned to rt extent size")
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
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_fs xfs
+_require_scratch
+_require_realtime
+_require_xfs_io_command "fcollapse"
+_require_xfs_io_command "finsert"
+_require_xfs_io_command "funshare"
+_require_xfs_io_command "fzero"
+_require_xfs_io_command "falloc"
+
+rm -f $seqres.full
+
+# Format filesystem with a 256k realtime extent size
+_scratch_mkfs -r extsize=256k > $seqres.full
+_scratch_mount >> $seqres.full
+
+blksz=$(_get_block_size $SCRATCH_MNT)
+rextsize=$($XFS_INFO_PROG $SCRATCH_MNT | grep realtime.*extsz | sed -e 's/^.*extsz=\([0-9]*\).*$/\1/g')
+rextblks=$((rextsize / blksz))
+
+echo "blksz $blksz rextsize $rextsize rextblks $rextblks" >> $seqres.full
+
+# Make sure the root directory has rtinherit set so our test file will too
+$XFS_IO_PROG -c 'chattr +t' $SCRATCH_MNT
+
+sz=$((rextsize * 100))
+range="$((blksz * 3)) $blksz"
+
+for verb in fpunch finsert fcollapse fzero funshare falloc; do
+	echo "test $verb"
+	$XFS_IO_PROG -f -c "falloc 0 $sz" "$SCRATCH_MNT/b"
+	$XFS_IO_PROG -f -c "$verb $range" "$SCRATCH_MNT/b"
+	rm -f "$SCRATCH_MNT/b"
+	_scratch_cycle_mount
+done
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/760.out b/tests/xfs/760.out
new file mode 100644
index 00000000..3d73c6fa
--- /dev/null
+++ b/tests/xfs/760.out
@@ -0,0 +1,9 @@
+QA output created by 760
+test fpunch
+test finsert
+fallocate: Invalid argument
+test fcollapse
+fallocate: Invalid argument
+test fzero
+test funshare
+test falloc
diff --git a/tests/xfs/group b/tests/xfs/group
index 219a4cfe..eebe7dde 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -515,3 +515,5 @@
 536 auto quick reflink
 537 auto quick
 538 auto stress
+759 auto quick rw realtime
+760 auto quick rw realtime collapse insert unshare zero prealloc

