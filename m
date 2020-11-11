Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,LOTS_OF_MONEY,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60301C55ABD
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Nov 2020 00:46:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 043AB21D7F
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Nov 2020 00:46:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="s0hbJZUj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732086AbgKKAqP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Nov 2020 19:46:15 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:36110 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731234AbgKKAqP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Nov 2020 19:46:15 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AB0ZaiW016919;
        Wed, 11 Nov 2020 00:46:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=v1IAZkiAF3NM9o24W9oT6qepmKmulpIzg/r4pzdzeh4=;
 b=s0hbJZUjEJeJ2NCO2iuLk4ZdyGKXXFowjBMIgrF1MqG0E6nYGTzglfTFECzoeo5RgbGK
 WVsDAZR5QzMervxZklyPDsQDL4BX85jto12/IjGv+hRBSbtfUPXwsiYTRusKYsEhJSRf
 /lHDN+3YbnqHiIeThXvvqyZDOZO5A5hPH8XLwl74tkNs5uFxMlmSaCz85D/qZGIbtEZK
 EG5s+lNe7yHheVpjKF0GzeXyF2HHOFC6mtUPwSFwodoJWZc8LvLcKkV6Y36eqCB8K6+N
 x09bVKicTWlFgKKJsbCkyqxnWGWhpd8Ga59XfdubwFhX2wYJqSYAl9UZl9t0yRm7tU8W 1Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 34p72emv8q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 11 Nov 2020 00:46:11 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AB0VEth095433;
        Wed, 11 Nov 2020 00:44:11 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 34p55pau3t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Nov 2020 00:44:11 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AB0iAOm018286;
        Wed, 11 Nov 2020 00:44:10 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Nov 2020 16:44:09 -0800
Subject: [PATCH 3/7] generic: test reflink and copy_file_range behavior with
 O_SYNC and FS_XFLAG_SYNC files
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, guaneryu@gmail.com
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Tue, 10 Nov 2020 16:44:08 -0800
Message-ID: <160505544844.1388823.7727157246785406013.stgit@magnolia>
In-Reply-To: <160505542802.1388823.10368384826199448253.stgit@magnolia>
References: <160505542802.1388823.10368384826199448253.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011110001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 suspectscore=0 lowpriorityscore=0 adultscore=0 phishscore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011110001
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add two regression tests to make sure that FICLONERANGE and the splice
based copy_file_range actually flush all data and metadata to disk
before the call ends.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 tests/generic/947     |  117 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/947.out |   15 ++++++
 tests/generic/948     |   90 ++++++++++++++++++++++++++++++++++++++
 tests/generic/948.out |    9 ++++
 tests/generic/group   |    2 +
 5 files changed, 233 insertions(+)
 create mode 100755 tests/generic/947
 create mode 100644 tests/generic/947.out
 create mode 100755 tests/generic/948
 create mode 100644 tests/generic/948.out


diff --git a/tests/generic/947 b/tests/generic/947
new file mode 100755
index 00000000..d2adf745
--- /dev/null
+++ b/tests/generic/947
@@ -0,0 +1,117 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2020, Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 947
+#
+# Make sure that reflink forces the log out if we open the file with O_SYNC or
+# set FS_XFLAG_SYNC on the file.  We test that it actually forced the log by
+# using dm-error to shut down the fs without flushing the log and then
+# remounting to check file contents.
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
index 00000000..83fe414b
--- /dev/null
+++ b/tests/generic/948
@@ -0,0 +1,90 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2020, Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 948
+#
+# Make sure that copy_file_range forces the log out if we open the file with
+# O_SYNC or set FS_XFLAG_SYNC on the file.  We test that it actually forced the
+# log by using dm-error to shut down the fs without flushing the log and then
+# remounting to check file contents.
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
index ab8ae74e..4300158e 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -617,3 +617,5 @@
 612 auto quick clone
 613 auto quick encrypt
 614 auto quick rw
+947 auto quick rw clone
+948 auto quick rw copy_range

