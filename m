Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBE27C7EE31
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Mar 2023 02:59:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbjCAC7b (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Feb 2023 21:59:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbjCAC7a (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Feb 2023 21:59:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E8E61C32C;
        Tue, 28 Feb 2023 18:59:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B08EB611F3;
        Wed,  1 Mar 2023 02:59:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 199F2C433EF;
        Wed,  1 Mar 2023 02:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677639567;
        bh=VD29bY+us+j3LFFtFzU+z2TI0TNWl6A+pxU08EReyug=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=CkFToiVZUXQbmQBYSed8NmKMbw8WPzwu1C76344cOSZzObVTRIF+mCF9leoONX3iT
         y674CMpsdrwnjiLUiTEAZJMEb7sqd5tPydWnEQF+JSK5RRAY2sTaBIElkjTwuHQp0Y
         i4G39OJNSDHbfoTrMkxp16lPWCW5YRWrhytNOaFH315vq1nR/vfpOlA1WJMRVhIu03
         lMp9dmPzPpk5NEWB+PzYjafdGI6LLAp2/RO2u5H3krvi4JVE1G5fJRK4054X5OKtSs
         0coZxIXxGFgVkRXZQ5WY4f2avAN0QIxPf5D3+OGupTi4x0pW7DtO23Mj6kPvByVWqZ
         7cap2ISUcytGA==
Subject: [PATCH 4/7] generic, xfs: test scatter-gather atomic file updates
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 28 Feb 2023 18:59:26 -0800
Message-ID: <167763956666.3796922.871998280981893774.stgit@magnolia>
In-Reply-To: <167763954409.3796922.11086772690906428270.stgit@magnolia>
References: <167763954409.3796922.11086772690906428270.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Make sure that FILE_SWAP_RANGE_SKIP_FILE1_HOLES does what we want it to
do -- provide a means to implement scatter-gather atomic file writes.
That means we create a temporary file, write whatever sparse bits to it
that we want, and swap the non-hole parts of the temp file.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/xfs             |   19 +++++++++++++++
 tests/generic/1216     |   53 ++++++++++++++++++++++++++++++++++++++++++
 tests/generic/1216.out |    6 +++++
 tests/generic/1217     |   56 ++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/1217.out |    4 +++
 tests/xfs/1211         |   59 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1211.out     |    7 ++++++
 tests/xfs/1212         |   61 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1212.out     |    5 ++++
 9 files changed, 270 insertions(+)
 create mode 100755 tests/generic/1216
 create mode 100644 tests/generic/1216.out
 create mode 100755 tests/generic/1217
 create mode 100644 tests/generic/1217.out
 create mode 100755 tests/xfs/1211
 create mode 100644 tests/xfs/1211.out
 create mode 100755 tests/xfs/1212
 create mode 100644 tests/xfs/1212.out


diff --git a/common/xfs b/common/xfs
index b2328f1549..11e675c0d2 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1763,3 +1763,22 @@ _scratch_xfs_find_agbtree_height() {
 
 	return 1
 }
+
+_require_xfs_mkfs_atomicswap()
+{
+	# atomicswap can be activated on rmap or reflink filesystems.
+	# reflink is newer (4.9 for reflink vs. 4.8 for rmap) so test that.
+	_scratch_mkfs_xfs_supported -m reflink=1 >/dev/null 2>&1 || \
+		_notrun "mkfs.xfs doesn't have atomicswap dependent features"
+}
+
+_require_xfs_scratch_atomicswap()
+{
+	_require_xfs_mkfs_atomicswap
+	_require_scratch
+	_require_xfs_io_command swapext '-v vfs -a'
+	_scratch_mkfs -m reflink=1 > /dev/null
+	_try_scratch_mount || \
+		_notrun "atomicswap dependencies not supported by scratch filesystem type: $FSTYP"
+	_scratch_unmount
+}
diff --git a/tests/generic/1216 b/tests/generic/1216
new file mode 100755
index 0000000000..802cfe14d4
--- /dev/null
+++ b/tests/generic/1216
@@ -0,0 +1,53 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1216
+#
+# Test scatter-gather atomic file writes.  We create a temporary file, write
+# sparsely to it, then use FILE_SWAP_RANGE_SKIP_FILE1_HOLES flag to swap
+# atomicallly only the ranges that we wrote.
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
+_require_xfs_io_command swapext '-v vfs -a'
+_require_scratch
+
+_scratch_mkfs >> $seqres.full
+_scratch_mount
+_require_congruent_file_oplen $SCRATCH_MNT 65536
+
+# Create original file
+_pwrite_byte 0x58 0 1m $SCRATCH_MNT/a >> $seqres.full
+
+# Create the donor file
+_pwrite_byte 0x59 64k 64k $SCRATCH_MNT/b >> $seqres.full
+_pwrite_byte 0x57 768k 64k $SCRATCH_MNT/b >> $seqres.full
+$XFS_IO_PROG -c 'truncate 1m' $SCRATCH_MNT/b
+
+md5sum $SCRATCH_MNT/a | _filter_scratch
+md5sum $SCRATCH_MNT/b | _filter_scratch
+
+# Test swapext.  -h means skip holes in /b, and -e means operate to EOF
+echo swap | tee -a $seqres.full
+$XFS_IO_PROG -c "swapext -v vfs -f -u -h -e -a $SCRATCH_MNT/b" $SCRATCH_MNT/a
+_scratch_cycle_mount
+
+md5sum $SCRATCH_MNT/a | _filter_scratch
+md5sum $SCRATCH_MNT/b | _filter_scratch
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/1216.out b/tests/generic/1216.out
new file mode 100644
index 0000000000..2b49d5cfa8
--- /dev/null
+++ b/tests/generic/1216.out
@@ -0,0 +1,6 @@
+QA output created by 1216
+310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
+c9fb827e2e3e579dc2a733ddad486d1d  SCRATCH_MNT/b
+swap
+e9cbfe8489a68efaa5fcf40cf3106118  SCRATCH_MNT/a
+faf8ed02a5b0638096a817abcc6c2127  SCRATCH_MNT/b
diff --git a/tests/generic/1217 b/tests/generic/1217
new file mode 100755
index 0000000000..78c49751f7
--- /dev/null
+++ b/tests/generic/1217
@@ -0,0 +1,56 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1217
+#
+# Test scatter-gather atomic file commits.  Use the startupdate command to
+# create a temporary file, write sparsely to it, then commitupdate -h to
+# perform the scattered update.
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
+_require_xfs_io_command swapext '-v vfs -a'
+_require_xfs_io_command startupdate '-e'
+_require_scratch
+
+_scratch_mkfs >> $seqres.full
+_scratch_mount
+_require_congruent_file_oplen $SCRATCH_MNT 65536
+
+# Create original file
+_pwrite_byte 0x58 0 1m $SCRATCH_MNT/a >> $seqres.full
+sync
+md5sum $SCRATCH_MNT/a | _filter_scratch
+
+# Test atomic scatter-gather file commits.
+echo commit | tee -a $seqres.full
+$XFS_IO_PROG \
+	-c 'bmap -elpv' \
+	-c 'startupdate -e' \
+	-c 'truncate 1m' \
+	-c 'pwrite -S 0x59 64k 64k' \
+	-c 'pwrite -S 0x57 768k 64k' \
+	-c 'bmap -elpv' \
+	-c 'commitupdate -h -k' \
+	-c 'bmap -elpv' \
+	$SCRATCH_MNT/a >> $seqres.full
+_scratch_cycle_mount
+
+md5sum $SCRATCH_MNT/a | _filter_scratch
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/1217.out b/tests/generic/1217.out
new file mode 100644
index 0000000000..73bf89895d
--- /dev/null
+++ b/tests/generic/1217.out
@@ -0,0 +1,4 @@
+QA output created by 1217
+310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
+commit
+e9cbfe8489a68efaa5fcf40cf3106118  SCRATCH_MNT/a
diff --git a/tests/xfs/1211 b/tests/xfs/1211
new file mode 100755
index 0000000000..6297b8ad67
--- /dev/null
+++ b/tests/xfs/1211
@@ -0,0 +1,59 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1211
+#
+# Test scatter-gather atomic file writes.  We create a temporary file, write
+# sparsely to it, then use FILE_SWAP_RANGE_SKIP_FILE1_HOLES flag to swap
+# atomicallly only the ranges that we wrote.  Inject an error so that we can
+# test that log recovery finishes the swap.
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
+. ./common/inject
+
+# real QA test starts here
+_supported_fs xfs
+_require_xfs_io_command swapext '-v vfs -a'
+_require_xfs_scratch_atomicswap
+_require_xfs_io_error_injection "bmap_finish_one"
+
+_scratch_mkfs >> $seqres.full
+_scratch_mount
+_require_congruent_file_oplen $SCRATCH_MNT 65536
+
+# Create original file
+_pwrite_byte 0x58 0 1m $SCRATCH_MNT/a >> $seqres.full
+
+# Create the donor file
+_pwrite_byte 0x59 64k 64k $SCRATCH_MNT/b >> $seqres.full
+_pwrite_byte 0x57 768k 64k $SCRATCH_MNT/b >> $seqres.full
+$XFS_IO_PROG -c 'truncate 1m' $SCRATCH_MNT/b
+sync
+
+md5sum $SCRATCH_MNT/a | _filter_scratch
+md5sum $SCRATCH_MNT/b | _filter_scratch
+
+# Test swapext.  -h means skip holes in /b, and -e means operate to EOF
+echo swap | tee -a $seqres.full
+$XFS_IO_PROG -x -c 'inject bmap_finish_one' \
+	-c "swapext -v vfs -f -u -h -e -a $SCRATCH_MNT/b" $SCRATCH_MNT/a
+_scratch_cycle_mount
+
+md5sum $SCRATCH_MNT/a | _filter_scratch
+md5sum $SCRATCH_MNT/b | _filter_scratch
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1211.out b/tests/xfs/1211.out
new file mode 100644
index 0000000000..19412c21a1
--- /dev/null
+++ b/tests/xfs/1211.out
@@ -0,0 +1,7 @@
+QA output created by 1211
+310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
+c9fb827e2e3e579dc2a733ddad486d1d  SCRATCH_MNT/b
+swap
+swapext: Input/output error
+e9cbfe8489a68efaa5fcf40cf3106118  SCRATCH_MNT/a
+faf8ed02a5b0638096a817abcc6c2127  SCRATCH_MNT/b
diff --git a/tests/xfs/1212 b/tests/xfs/1212
new file mode 100755
index 0000000000..d2292d65a2
--- /dev/null
+++ b/tests/xfs/1212
@@ -0,0 +1,61 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1212
+#
+# Test scatter-gather atomic file commits.  Use the startupdate command to
+# create a temporary file, write sparsely to it, then commitupdate -h to
+# perform the scattered update.  Inject an error so that we can test that log
+# recovery finishes the swap.
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
+. ./common/inject
+
+# real QA test starts here
+_supported_fs xfs
+_require_xfs_io_command swapext '-v vfs -a'
+_require_xfs_io_command startupdate '-e'
+_require_xfs_scratch_atomicswap
+_require_xfs_io_error_injection "bmap_finish_one"
+
+_scratch_mkfs >> $seqres.full
+_scratch_mount
+
+# Create original file
+_pwrite_byte 0x58 0 1m $SCRATCH_MNT/a >> $seqres.full
+sync
+md5sum $SCRATCH_MNT/a | _filter_scratch
+
+# Test atomic scatter-gather file commits.
+echo commit | tee -a $seqres.full
+$XFS_IO_PROG -x \
+	-c 'bmap -elpv' \
+	-c 'startupdate -e' \
+	-c 'truncate 1m' \
+	-c 'pwrite -S 0x59 64k 64k' \
+	-c 'pwrite -S 0x57 768k 64k' \
+	-c 'sync' \
+	-c 'bmap -elpv' \
+	-c 'inject bmap_finish_one' \
+	-c 'commitupdate -h -k' \
+	$SCRATCH_MNT/a >> $seqres.full
+_scratch_cycle_mount
+
+$XFS_IO_PROG -c 'bmap -elpv' $SCRATCH_MNT/a >> $seqres.full
+md5sum $SCRATCH_MNT/a | _filter_scratch
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1212.out b/tests/xfs/1212.out
new file mode 100644
index 0000000000..29718e2024
--- /dev/null
+++ b/tests/xfs/1212.out
@@ -0,0 +1,5 @@
+QA output created by 1212
+310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
+commit
+committing update: Input/output error
+e9cbfe8489a68efaa5fcf40cf3106118  SCRATCH_MNT/a

