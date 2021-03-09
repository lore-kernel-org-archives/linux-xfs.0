Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	LOTS_OF_MONEY,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0BAFC433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 04:41:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A54CF6528D
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 04:41:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbhCIEkm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Mar 2021 23:40:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:32860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229872AbhCIEkP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Mar 2021 23:40:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D15B36523B;
        Tue,  9 Mar 2021 04:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615264814;
        bh=UrcceFFjmTQRogHNHnizLL7HLDHcmj2usP6zC065DlY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=cV7C0E4k91au0OYExa9NaaogUcPqbyh7R9/D+bpa0Ogab7ZHT4hHFoBylbH99THNp
         3vu/fUO2HSXjm8sUtMO8CAHIuEAtB/uFamMvohVoym82wb9+O58Sp+6EVWRkYUbwZv
         eHMM9mDnHYBuiDnSl4A0AZmWpVOLcGowqgtFByMkVCimDmWXJW48JNbGcuj3WU8xHt
         Jf6WStOoSuOqSAN+XZAhnJ68Z6HncdLF7TCR4kBAD2jx1XaEGEaDID7kgDOQ/YMjbk
         KKmnGWtym9LVYVIIGtPaYWCQfsjkTTRYjDNC1NMTWsLL/FqxJ1rfOZXf2Lz7apcDLy
         lQTKttKJFL7/g==
Subject: [PATCH 02/10] generic: test reflink and copy_file_range behavior with
 O_SYNC and FS_XFLAG_SYNC files
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Mon, 08 Mar 2021 20:40:14 -0800
Message-ID: <161526481473.1214319.4844099354726360669.stgit@magnolia>
In-Reply-To: <161526480371.1214319.3263690953532787783.stgit@magnolia>
References: <161526480371.1214319.3263690953532787783.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add two regression tests to make sure that FICLONERANGE and the splice
based copy_file_range actually flush all data and metadata to disk
before the call ends.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 tests/generic/947     |  118 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/947.out |   15 ++++++
 tests/generic/948     |   92 ++++++++++++++++++++++++++++++++++++++
 tests/generic/948.out |    9 ++++
 tests/generic/group   |    2 +
 5 files changed, 236 insertions(+)
 create mode 100755 tests/generic/947
 create mode 100644 tests/generic/947.out
 create mode 100755 tests/generic/948
 create mode 100644 tests/generic/948.out


diff --git a/tests/generic/947 b/tests/generic/947
new file mode 100755
index 00000000..d0edb876
--- /dev/null
+++ b/tests/generic/947
@@ -0,0 +1,118 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2021 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 947
+#
+# Make sure that reflink forces the log out if we open the file with O_SYNC or
+# set FS_XFLAG_SYNC on the file.  We test that it actually forced the log by
+# using dm-error to shut down the fs without flushing the log and then
+# remounting to check file contents.  This is a regression test for commit
+# 5ffce3cc22a0 ("xfs: force the log after remapping a synchronous-writes file")
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
+	_dmerror_unmount
+	_dmerror_cleanup
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+. ./common/dmerror
+
+# real QA test starts here
+_supported_fs generic
+_require_dm_target error
+_require_scratch_reflink
+_require_xfs_io_command "chattr" "s"
+_require_cp_reflink
+
+rm -f $seqres.full
+
+# Format filesystem and set up quota limits
+_scratch_mkfs > $seqres.full
+_require_metadata_journaling $SCRATCH_DEV
+_dmerror_init
+_dmerror_mount
+
+# Test that O_SYNC actually results in file data being written even if the
+# fs immediately dies
+echo "test o_sync write"
+$XFS_IO_PROG -x -f -s -c "pwrite -S 0x58 0 1m -b 1m" $SCRATCH_MNT/0 >> $seqres.full
+_dmerror_load_error_table
+_dmerror_unmount
+_dmerror_load_working_table
+_dmerror_mount
+md5sum $SCRATCH_MNT/0 | _filter_scratch
+
+# Set up initial files for reflink test
+$XFS_IO_PROG -f -c 'pwrite -S 0x58 0 1m -b 1m' $SCRATCH_MNT/a >> $seqres.full
+$XFS_IO_PROG -f -c 'pwrite -S 0x59 0 1m -b 1m' $SCRATCH_MNT/c >> $seqres.full
+_cp_reflink $SCRATCH_MNT/a $SCRATCH_MNT/e
+_cp_reflink $SCRATCH_MNT/c $SCRATCH_MNT/d
+touch $SCRATCH_MNT/b
+sync
+
+# Test that reflink forces dirty data/metadata to disk when destination file
+# opened with O_SYNC
+echo "test reflink flag not set o_sync"
+$XFS_IO_PROG -x -s -c "reflink $SCRATCH_MNT/a" $SCRATCH_MNT/b >> $seqres.full
+_dmerror_load_error_table
+_dmerror_unmount
+_dmerror_load_working_table
+_dmerror_mount
+md5sum $SCRATCH_MNT/a $SCRATCH_MNT/b | _filter_scratch
+
+# Test that reflink to a shared file forces dirty data/metadata to disk when
+# destination is opened with O_SYNC
+echo "test reflink flag already set o_sync"
+$XFS_IO_PROG -x -s -c "reflink $SCRATCH_MNT/a" $SCRATCH_MNT/d >> $seqres.full
+_dmerror_load_error_table
+_dmerror_unmount
+_dmerror_load_working_table
+_dmerror_mount
+md5sum $SCRATCH_MNT/a $SCRATCH_MNT/d | _filter_scratch
+
+# Set up the two files with chattr +S
+rm -f $SCRATCH_MNT/b $SCRATCH_MNT/d
+_cp_reflink $SCRATCH_MNT/c $SCRATCH_MNT/d
+touch $SCRATCH_MNT/b
+chattr +S $SCRATCH_MNT/b $SCRATCH_MNT/d
+sync
+
+# Test that reflink forces dirty data/metadata to disk when destination file
+# has the sync iflag set
+echo "test reflink flag not set iflag"
+$XFS_IO_PROG -x -c "reflink $SCRATCH_MNT/a" $SCRATCH_MNT/b >> $seqres.full
+_dmerror_load_error_table
+_dmerror_unmount
+_dmerror_load_working_table
+_dmerror_mount
+md5sum $SCRATCH_MNT/a $SCRATCH_MNT/b | _filter_scratch
+
+# Test that reflink to a shared file forces dirty data/metadata to disk when
+# destination file has the sync iflag set
+echo "test reflink flag already set iflag"
+$XFS_IO_PROG -x -c "reflink $SCRATCH_MNT/a" $SCRATCH_MNT/d >> $seqres.full
+_dmerror_load_error_table
+_dmerror_unmount
+_dmerror_load_working_table
+_dmerror_mount
+md5sum $SCRATCH_MNT/a $SCRATCH_MNT/d | _filter_scratch
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/947.out b/tests/generic/947.out
new file mode 100644
index 00000000..05ba10d1
--- /dev/null
+++ b/tests/generic/947.out
@@ -0,0 +1,15 @@
+QA output created by 947
+test o_sync write
+310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/0
+test reflink flag not set o_sync
+310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
+310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/b
+test reflink flag already set o_sync
+310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
+310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/d
+test reflink flag not set iflag
+310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
+310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/b
+test reflink flag already set iflag
+310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
+310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/d
diff --git a/tests/generic/948 b/tests/generic/948
new file mode 100755
index 00000000..b79cd279
--- /dev/null
+++ b/tests/generic/948
@@ -0,0 +1,92 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2021 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 948
+#
+# Make sure that copy_file_range forces the log out if we open the file with
+# O_SYNC or set FS_XFLAG_SYNC on the file.  We test that it actually forced the
+# log by using dm-error to shut down the fs without flushing the log and then
+# remounting to check file contents.  This is a regression test for commit
+# 5ffce3cc22a0 ("xfs: force the log after remapping a synchronous-writes file")
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
+	_dmerror_unmount
+	_dmerror_cleanup
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/dmerror
+
+# real QA test starts here
+_supported_fs generic
+_require_dm_target error
+_require_xfs_io_command "chattr" "s"
+_require_scratch
+
+rm -f $seqres.full
+
+# Format filesystem and set up quota limits
+_scratch_mkfs > $seqres.full
+_require_metadata_journaling $SCRATCH_DEV
+_dmerror_init
+_dmerror_mount
+
+# Test that O_SYNC actually results in file data being written even if the
+# fs immediately dies
+echo "test o_sync write"
+$XFS_IO_PROG -x -f -s -c "pwrite -S 0x58 0 1m -b 1m" $SCRATCH_MNT/0 >> $seqres.full
+_dmerror_load_error_table
+_dmerror_unmount
+_dmerror_load_working_table
+_dmerror_mount
+md5sum $SCRATCH_MNT/0 | _filter_scratch
+
+# Set up initial files for copy test
+$XFS_IO_PROG -f -c 'pwrite -S 0x58 0 1m -b 1m' $SCRATCH_MNT/a >> $seqres.full
+touch $SCRATCH_MNT/b
+sync
+
+# Test that unaligned copy file range forces dirty data/metadata to disk when
+# destination file opened with O_SYNC
+echo "test unaligned copy range o_sync"
+$XFS_IO_PROG -x -s -c "copy_range -s 13 -d 13 -l 1048550 $SCRATCH_MNT/a" $SCRATCH_MNT/b >> $seqres.full
+_dmerror_load_error_table
+_dmerror_unmount
+_dmerror_load_working_table
+_dmerror_mount
+md5sum $SCRATCH_MNT/a $SCRATCH_MNT/b | _filter_scratch
+
+# Set up dest file with chattr +S
+rm -f $SCRATCH_MNT/b
+touch $SCRATCH_MNT/b
+chattr +S $SCRATCH_MNT/b
+sync
+
+# Test that unaligned copy file range forces dirty data/metadata to disk when
+# destination file has the sync iflag set
+echo "test unaligned copy range iflag"
+$XFS_IO_PROG -x -c "copy_range -s 13 -d 13 -l 1048550 $SCRATCH_MNT/a" $SCRATCH_MNT/b >> $seqres.full
+_dmerror_load_error_table
+_dmerror_unmount
+_dmerror_load_working_table
+_dmerror_mount
+md5sum $SCRATCH_MNT/a $SCRATCH_MNT/b | _filter_scratch
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/948.out b/tests/generic/948.out
new file mode 100644
index 00000000..eec6c0dc
--- /dev/null
+++ b/tests/generic/948.out
@@ -0,0 +1,9 @@
+QA output created by 948
+test o_sync write
+310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/0
+test unaligned copy range o_sync
+310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
+2a715d2093b5aca82783a0c5943ac0b8  SCRATCH_MNT/b
+test unaligned copy range iflag
+310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
+2a715d2093b5aca82783a0c5943ac0b8  SCRATCH_MNT/b
diff --git a/tests/generic/group b/tests/generic/group
index 84db3789..d5cfdd51 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -628,3 +628,5 @@
 623 auto quick shutdown
 624 auto quick verity
 625 auto quick verity
+947 auto quick rw clone
+948 auto quick rw copy_range

