Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC8B2C4320A
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Sep 2021 00:12:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2D6B61008
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Sep 2021 00:12:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243229AbhIAANY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Aug 2021 20:13:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:47048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243032AbhIAANW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 31 Aug 2021 20:13:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A22016102A;
        Wed,  1 Sep 2021 00:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630455146;
        bh=diHVnVm/al9ZWrD0vPhjiohMfB6ni5hlCZN0qE4gdbM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=GxLNW6f2Gine6TyY5wgpNzIKwtM0SJli3MpwBWf6loyT6vK+LnEY9a7BSdqswgbIN
         PR0oLGfarpwoFXcG0W1OHEDdeallf55jVv/LjGZTUgONIwf65GJselNPu/JCiooY7X
         N2UBHaMtr4NsNt+n8LXQYHfzOGOxmYIxIO3Hq+HLBBzGV2yGTo9VOfmvwkY2yI8Eeh
         CTHemvUxGC72KVc3FaXmflx/Ndj11E3S1os6W3nSt0rDzXcCH4FI5XkRB/FOhtwgpa
         kk2ouu7gnAt9ulFvjwsqZQzbsSfJuaNqkcvwXpPpCSttNdJqcxdwwNCko2IhB82gmz
         ktxdu/XhfthJA==
Subject: [PATCH 4/4] xfs: regresion test for fsmap problems with realtime
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 31 Aug 2021 17:12:26 -0700
Message-ID: <163045514640.771394.1779112875987604476.stgit@magnolia>
In-Reply-To: <163045512451.771394.12554760323831932499.stgit@magnolia>
References: <163045512451.771394.12554760323831932499.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

This is a regression test for:

xfs: make xfs_rtalloc_query_range input parameters const
xfs: fix off-by-one error when the last rt extent is in use
xfs: make fsmap backend function key parameters const

In which we synthesize an XFS with a realtime volume and a special
realtime volume to trip the bugs fixed by all three patches that
resulted in incomplete fsmap output.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/922     |  183 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/922.out |    2 +
 2 files changed, 185 insertions(+)
 create mode 100755 tests/xfs/922
 create mode 100644 tests/xfs/922.out


diff --git a/tests/xfs/922 b/tests/xfs/922
new file mode 100755
index 00000000..95304d57
--- /dev/null
+++ b/tests/xfs/922
@@ -0,0 +1,183 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2021 Oracle.  All Rights Reserved.
+#
+# FS QA Test 922
+#
+# Regression test for commits:
+#
+# c02f6529864a ("xfs: make xfs_rtalloc_query_range input parameters const")
+# 9ab72f222774 ("xfs: fix off-by-one error when the last rt extent is in use")
+# 7e1826e05ba6 ("xfs: make fsmap backend function key parameters const")
+#
+# These commits fix a bug in fsmap where the data device fsmap function would
+# corrupt the high key passed to the rt fsmap function if the data device
+# number is smaller than the rt device number and the data device itself is
+# smaller than the rt device.
+#
+. ./common/preamble
+_begin_fstest auto fsmap
+
+_cleanup()
+{
+	cd /
+	rm -r -f $tmp.*
+	_scratch_unmount
+	test -n "$ddloop" && _destroy_loop_device "$ddloop"
+	test -n "$rtloop" && _destroy_loop_device "$rtloop"
+	test -n "$ddfile" && rm -f "$ddfile"
+	test -n "$rtfile" && rm -f "$rtfile"
+	test -n "$old_use_external" && USE_EXTERNAL="$old_use_external"
+}
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs generic
+_require_test
+
+# Synthesize data and rt volumes that as needed to trigger the bug
+ddfile=$TEST_DIR/data
+rtfile=$TEST_DIR/rt
+rm -f "$rtfile" "$ddfile"
+
+ddsize="$((100 * 1048576))"
+rtsize="$((200 * 1048576))"
+
+truncate -s $ddsize $ddfile
+truncate -s $rtsize $rtfile
+ddloop="$(_create_loop_device $ddfile)"
+rtloop="$(_create_loop_device $rtfile)"
+
+test -z "$ddloop" && _fail "Could not create data loop device"
+test -z "$rtloop" && _fail "Could not create rt loop device"
+
+# dataloop must have a smaller device number than rtloop because fsmap sorts
+# the output by device number
+ddmajor=$(stat -c '%t' "$ddloop")
+rtmajor=$(stat -c '%t' "$rtloop")
+test $ddmajor -le $rtmajor || \
+	_notrun "Data loopdev major $ddmajor larger than rt major $rtmajor"
+
+ddminor=$(stat -c '%T' "$ddloop")
+rtminor=$(stat -c '%T' "$rtloop")
+test $ddmajor -le $rtmajor || \
+	_notrun "Data loopdev minor $ddminor larger than rt minor $rtminor"
+
+# Inject our custom-built devices as an rt-capable scratch device.
+# We avoid touching "require_scratch" so that post-test fsck will not try to
+# run on our synthesized scratch device.
+old_use_external="$USE_EXTERNAL"
+USE_EXTERNAL=yes
+SCRATCH_RTDEV="$rtloop"
+SCRATCH_DEV="$ddloop"
+
+_scratch_mkfs >> $seqres.full
+_try_scratch_mount >> $seqres.full || \
+	_notrun "mount with injected rt device failed"
+
+# Create a file that we'll use to seed fsmap entries for the rt device,
+# and force the root directory to create only data device files
+rtfile="$SCRATCH_MNT/rtfile"
+$XFS_IO_PROG -R -f -c 'stat -v' $rtfile | grep -q 'fsxattr.*xflags.*realtime' || \
+	_notrun "could not create realtime file"
+$XFS_IO_PROG -c 'chattr -t' $SCRATCH_MNT
+rtextsize="$(stat -c '%o' $rtfile)"
+
+# Make sure the data device is smaller than the rt device by at least a few
+# realtime extents.
+ddbytes="$(stat -f -c '%S * %b' $SCRATCH_MNT | bc)"
+rtbytes="$(stat -f -c '%S * %b' $rtfile | bc)"
+
+test "$ddbytes" -lt "$((rtbytes + (10 * rtextsize) ))" || \
+	echo "data device ($ddbytes) has more bytes than rt ($rtbytes)"
+
+# Craft the layout of the sole realtime file in such a way that the only
+# allocated space on the realtime device is at a physical disk address that is
+# higher than the size of the data device.  For realtime files this is really
+# easy because fallocate for the first rt file always starts allocating at
+# physical offset zero.
+alloc_rtx="$((rtbytes / rtextsize))"
+$XFS_IO_PROG -c "falloc 0 $((alloc_rtx * rtextsize))" $rtfile
+
+expected_end="$(( (alloc_rtx * rtextsize - 1) / 512 ))"
+
+# Print extent mapping of rtfile in format:
+# file_offset file_end physical_offset physical_end
+rtfile_exts() {
+	$XFS_IO_PROG -c 'bmap -elp' $rtfile | \
+		egrep -v '(^/|EXT:|hole)' | \
+		tr ':.[]' '    ' | \
+		while read junk foff fend physoff physend junk; do
+			echo "$foff $fend $physoff $physend"
+		done
+}
+
+# Make sure that we actually got the entire device.
+rtfile_exts | awk -v end=$expected_end '
+{
+	if ($3 != 0)
+		printf("%s: unexpected physical offset %s, wanted 0\n", $0, $3);
+	if ($4 != end)
+		printf("%s: unexpected physical end %s, wanted %d\n", $0, $4, end);
+}'
+
+# Now punch out a range that is slightly larger than the size of the data
+# device.
+punch_bytes="$((ddsize + rtextsize))"
+punch_rtx="$((punch_bytes / rtextsize))"
+$XFS_IO_PROG -c "fpunch 0 $((punch_rtx * rtextsize))" $rtfile
+
+expected_offset="$((punch_rtx * rtextsize / 512))"
+
+echo "rtfile should have physical extent from $expected_offset to $expected_end sectors" >> $seqres.full
+
+# Make sure that the realtime file now has only one extent at the end of the
+# realtime device
+rtfile_exts | awk -v offset=$expected_offset -v end=$expected_end '
+{
+	if ($3 != offset)
+		printf("%s: unexpected physical offset %s, wanted %d\n", $0, $3, offset);
+	if ($4 != end)
+		printf("%s: unexpected physical end %s, wanted %d\n", $0, $4, end);
+}'
+
+$XFS_IO_PROG -c 'bmap -elpv' $rtfile >> $seqres.full
+$XFS_IO_PROG -c 'fsmap' $SCRATCH_MNT >> $seqres.full
+
+fsmap() {
+	$XFS_IO_PROG -c 'fsmap' $SCRATCH_MNT | \
+		grep -v 'EXT:' | \
+		tr ':.[]' '    ' | \
+		while read junk major minor physoff physend junk; do
+			echo "$major:$minor $physoff $physend"
+		done
+}
+
+# Check the fsmap output contains a record for the realtime device at a
+# physical offset higher than end of the data device and corresponding to the
+# beginning of the non-punched area.
+fsmap | awk -v dev="$rtmajor:$rtminor" -v offset=$expected_offset -v end=$expected_end '
+BEGIN {
+	found_start = 0;
+	found_end = 0;
+}
+{
+	if ($1 == dev && $2 >= offset) {
+		found_start = 1;
+		if ($3 == end) {
+			found_end = 1;
+		}
+	}
+}
+END {
+	if (found_start == 0)
+		printf("No fsmap record for rtdev %s above sector %d\n", dev, offset);
+	if (found_end == 0)
+		printf("No fsmap record for rtdev %s ending at sector %d\n", dev, end);
+}'
+
+echo Silence is golden
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/922.out b/tests/xfs/922.out
new file mode 100644
index 00000000..3f90539d
--- /dev/null
+++ b/tests/xfs/922.out
@@ -0,0 +1,2 @@
+QA output created by 922
+Silence is golden

