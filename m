Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8878AC433B4
	for <linux-xfs@archiver.kernel.org>; Mon,  3 May 2021 21:35:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5EDA4613B4
	for <linux-xfs@archiver.kernel.org>; Mon,  3 May 2021 21:35:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbhECVgv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 3 May 2021 17:36:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:42112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229497AbhECVgu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 3 May 2021 17:36:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC9E7611AC
        for <linux-xfs@vger.kernel.org>; Mon,  3 May 2021 21:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620077756;
        bh=0JlL9YWzCwd828jBLkcXMesSbOSDCY2N4D1Wfdn7iD0=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=UADuS4P5cEB0DP9LTmK1ZBNzkQqn3SsH3D1xnAPBL0Pb5wg1G9orRlDku3dZH3Bpj
         PfN32teEfwv6HAH19W8A3LugMdqAzcLtsT2br4npw8dFTQlGoC7cik/JrE0mhqMj9p
         TD6hk4jYRY2FIew8F7VRO02PFO+B9iGvanZjUxNMQIjm/sYhM+po1om4JQxzXivVNg
         3O3QgrXGDX20tq22zMqw0ag8aGugE+ud0FUoi27tPobOpPZaoajC/jleFPwo72v9GU
         LFRgXXwDXPaDlgdcapaAy3glkVHPxlBpciM5aSOy+4U8J9wvXr8ES/47mu55y/lKvw
         zbpJVrxZpnQbQ==
Date:   Mon, 3 May 2021 14:35:56 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: test fsx with extent size hints set on a realtime file
Message-ID: <20210503213556.GB7448@magnolia>
References: <162007768318.836421.15582644026342097489.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162007768318.836421.15582644026342097489.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

This is a regression test for the two realtime allocator bug fixes:

xfs: adjust rt allocation minlen when extszhint > rtextsize
xfs: retry allocations when locality-based search fails

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/775     |  172 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/775.out |    3 +
 tests/xfs/group   |    1 
 3 files changed, 176 insertions(+)
 create mode 100755 tests/xfs/775
 create mode 100644 tests/xfs/775.out

diff --git a/tests/xfs/775 b/tests/xfs/775
new file mode 100755
index 00000000..b2deed90
--- /dev/null
+++ b/tests/xfs/775
@@ -0,0 +1,172 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2021, Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 775
+#
+# Regression test for two fixes in the realtime allocator:
+#
+# xfs: adjust rt allocation minlen when extszhint > rtextsize
+# xfs: retry allocations when locality-based search fails
+#
+# The first bug occurs when an extent size hint is set on a realtime file.
+# xfs_bmapi_rtalloc adjusts the offset and length of the allocation request to
+# try to satisfy the hint, but doesn't adjust minlen to match.  If the
+# allocator finds free space that isn't large enough to map even a single block
+# of the original request, bmapi_write will return ENOSPC and the write fails
+# even though there's plenty of space.
+#
+# The second bug occurs when an extent size hint is set on a file, we ask to
+# allocate blocks in an empty region immediately adjacent to a previous
+# allocation, and the nearest available free space isn't anywhere near the
+# previous allocation, the near allocator will give up and return ENOSPC, even
+# if there's sufficient free realtime extents to satisfy the allocation
+# request.
+#
+# Both bugs can be exploited by the same user call sequence, so here's a
+# targeted test that runs in less time than the reproducers that are listed in
+# the fix patches themselves.
+#
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_require_scratch
+_require_realtime
+_require_xfs_io_command "falloc"
+_require_xfs_io_command "fpunch"
+_require_test_program "punch-alternating"
+
+rm -f $seqres.full
+
+fill_rtdev()
+{
+	file=$1
+
+	filesize=`_get_available_space $SCRATCH_MNT`
+	$XFS_IO_PROG -f -c "truncate $filesize" -c "falloc 0 $filesize" $file
+
+	chunks=20
+	chunksizemb=$((filesize / chunks / 1048576))
+	seq 1 $chunks | while read f; do
+		echo "$((f * chunksizemb)) file size $f / 20"
+		$XFS_IO_PROG -fc "falloc -k $(( (f - 1) * chunksizemb))m ${chunksizemb}m" $file
+	done
+
+	chunks=100
+	chunksizemb=$((filesize / chunks / 1048576))
+	seq 80 $chunks | while read f; do
+		echo "$((f * chunksizemb)) file size $f / $chunks"
+		$XFS_IO_PROG -fc "falloc -k $(( (f - 1) * chunksizemb))m ${chunksizemb}m" $file
+	done
+
+	filesizemb=$((filesize / 1048576))
+	$XFS_IO_PROG -fc "falloc -k 0 ${filesizemb}m" $file
+
+	# Try again anyway
+	avail=`_get_available_space $SCRATCH_MNT`
+	$XFS_IO_PROG -fc "pwrite -S 0x65 0 $avail" ${file}
+}
+
+echo "Format and mount"
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+
+# This is a test of the rt allocator; force all files to be created realtime
+$XFS_IO_PROG -c 'chattr +t' $SCRATCH_MNT
+
+# Set the extent size hint larger than the realtime extent size.  This is
+# necessary to exercise the minlen constraints on the realtime allocator.
+fsbsize=$($XFS_IO_PROG -c 'statfs' $SCRATCH_MNT | grep geom.bsize | awk '{print $3}')
+rtextsize_blks=$($XFS_IO_PROG -c 'statfs' $SCRATCH_MNT | grep geom.rtextsize | awk '{print $3}')
+extsize=$((2 * rtextsize_blks * fsbsize))
+
+echo "rtextsize_blks=$rtextsize_blks extsize=$extsize" >> $seqres.full
+$XFS_IO_PROG -c 'chattr +t' -c "extsize $extsize" $SCRATCH_MNT
+
+# Compute the geometry of the test files we're going to create.  Realtime
+# volumes are simple, which means that we can control the space allocations
+# exactly to exploit bugs!
+#
+# Since this is a test of the near rt allocator, we need to set up the test to
+# have a victim file with at least one rt extent allocated to it and enough
+# free space to allocate at least one more rt extent at an adjacent file
+# offset.  The free space must not be immediately adjacent to the the first
+# extent that we allocate to the victim file, and it must not be large enough
+# to satisfy the entire allocation request all at once.
+#
+# Our free space fragmentation strategy is the usual fallocate-and-punch swiss
+# cheese file, which means the free space is split into five sections:
+#
+# The first will be remapped into the victim file.
+#
+# The second section exists to prevent the free extents from being adjacent to
+# the first section.  It will be very large, since we allocate all the rt
+# space.
+#
+# The last three sections will have every other rt extent punched out to create
+# some free space.
+remap_sz=$((extsize * 2))
+required_sz=$((5 * remap_sz))
+free_rtspace=$(_get_available_space $SCRATCH_MNT)
+if [ $free_rtspace -lt $required_sz ]; then
+	_notrun "Insufficient free space on rt volume.  Needed $required_sz, saw $free_rtspace."
+fi
+
+# Allocate all the space on the rt volume so that we can control space
+# allocations exactly.
+fill_rtdev $SCRATCH_MNT/bigfile &>> $seqres.full
+
+# We need at least 4 remap sections to proceed
+bigfile_sz=$(stat -c '%s' $SCRATCH_MNT/bigfile)
+if [ $bigfile_sz -lt $required_sz ]; then
+	_notrun "Free space control file needed $required_sz bytes, got $bigfile_sz."
+fi
+
+# Remap the first remap section to a victim file.
+$XFS_IO_PROG -c "fpunch 0 $remap_sz" $SCRATCH_MNT/bigfile
+$XFS_IO_PROG -f -c "truncate $required_sz" -c "falloc 0 $remap_sz" $SCRATCH_MNT/victim
+
+# Punch out every other extent of the last two sections, to fragment free space.
+frag_sz=$((remap_sz * 3))
+punch_off=$((bigfile_sz - frag_sz))
+$here/src/punch-alternating $SCRATCH_MNT/bigfile -o $((punch_off / fsbsize)) -i $((rtextsize_blks * 2)) -s $rtextsize_blks
+
+# Make sure we have some free rtextents.
+free_rtx=$($XFS_IO_PROG -c 'statfs' $SCRATCH_MNT | grep counts.freertx | awk '{print $3}')
+if [ $free_rtx -eq 0 ]; then
+	echo "Expected fragmented free rt space, found none."
+fi
+
+# Try to double the amount of blocks in the victim file.  On a buggy kernel,
+# the rt allocator will fail immediately with ENOSPC even though we left enough
+# free space for the write will complete fully.
+echo "Try to write a bunch of stuff to the fragmented rt space"
+$XFS_IO_PROG -c "pwrite -S 0x63 -b $remap_sz $remap_sz $remap_sz" -c stat $SCRATCH_MNT/victim >> $seqres.full
+
+# The victim file should own at least two sections' worth of blocks.
+victim_sectors=$(stat -c '%b' $SCRATCH_MNT/victim)
+victim_space_usage=$((victim_sectors * 512))
+expected_usage=$((remap_sz * 2))
+
+if [ $victim_space_usage -lt $expected_usage ]; then
+	echo "Victim file should be using at least $expected_usage bytes, saw $victim_space_usage."
+fi
+
+status=0
+exit
diff --git a/tests/xfs/775.out b/tests/xfs/775.out
new file mode 100644
index 00000000..f5a72156
--- /dev/null
+++ b/tests/xfs/775.out
@@ -0,0 +1,3 @@
+QA output created by 775
+Format and mount
+Try to write a bunch of stuff to the fragmented rt space
diff --git a/tests/xfs/group b/tests/xfs/group
index 76e31167..5f1ef5d6 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -529,5 +529,6 @@
 538 auto stress
 539 auto quick mount
 757 auto quick attr repair
+775 auto quick rw realtime
 908 auto quick bigtime
 909 auto quick bigtime quota
