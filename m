Return-Path: <SRS0=QbY/=2I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1FA4C3F68F
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Dec 2019 04:19:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A7EC124650
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Dec 2019 04:19:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Pf3RuMvy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726492AbfLRETf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Dec 2019 23:19:35 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:53780 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726387AbfLRETe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Dec 2019 23:19:34 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBI4JIXQ145504;
        Wed, 18 Dec 2019 04:19:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=s4ojAC7WjL5dBcU3QEpTqr9V6kmYBhs6Sgxpqm8i1AE=;
 b=Pf3RuMvyXhdO2GtKNQd7ubAgRpNlarL+w4EpBTYKcXsaQrbudBH9CfySdVZgSFuDfQqr
 vHdRdKw7CZu4kduyh9+9nWvaFagSGhqdwgoAvfyKI2rebm9lKVkmtMBYJL4HiSg3eXiQ
 lutRXqh3W5FEzK74tdk6X4PQV8n/uqSJi8yY5UIfC+5sFl/0BhiYFyzKBiZ5KeUzZKMu
 W5yGgFpYjah84tZ0FEZlUBQDJOY2IGMrNgs+5+WUmt6ah0NrK1wf/BKtwIvWsRbHBfXr
 5cUaVfmNK01HkTnDQ35RNAMgRg/vS2g0SzTqevocLktuEuXKo26oZDlBA7BYn4v+Q20V zg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2wvrcrax9k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Dec 2019 04:19:28 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBI4JHI0012866;
        Wed, 18 Dec 2019 04:19:27 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2wxm75m0jw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Dec 2019 04:19:27 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xBI4IYtr025233;
        Wed, 18 Dec 2019 04:18:34 GMT
Received: from localhost (/10.159.137.228)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 17 Dec 2019 20:18:34 -0800
Date:   Tue, 17 Dec 2019 20:18:31 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>, Alex Lyakas <alex@zadara.com>,
        Dave Chinner <david@fromorbit.com>,
        fstests <fstests@vger.kernel.org>
Subject: [RFC PATCH] xfs: test sunit/swidth updates
Message-ID: <20191218041831.GK12765@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9474 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912180032
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9474 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912180032
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add one test to make sure that we can update sunit without blowing up
the filesystem.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/751     |  181 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/751.out |    9 +++
 tests/xfs/group   |    1 
 3 files changed, 191 insertions(+)
 create mode 100755 tests/xfs/751
 create mode 100644 tests/xfs/751.out

diff --git a/tests/xfs/751 b/tests/xfs/751
new file mode 100755
index 00000000..861fed4c
--- /dev/null
+++ b/tests/xfs/751
@@ -0,0 +1,181 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-newer
+# Copyright (c) 2019, Oracle and/or its affiliates.  All Rights Reserved.
+#
+# FS QA Test No. 751
+#
+# Update sunit and width and make sure that the filesystem still passes
+# xfs_repair afterwards.
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
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/fuzzy
+
+# real QA test starts here
+_supported_fs xfs
+_supported_os Linux
+_require_scratch_nocheck
+
+# Assume that if we can run scrub on the test dev we can run it on the scratch
+# fs too.
+run_scrub=0
+_supports_xfs_scrub $TEST_DIR $TEST_DEV && run_scrub=1
+
+log()
+{
+	echo "$@" | tee -a $seqres.full /dev/ttyprintk
+}
+
+__test_mount_opts()
+{
+	local mounted=0
+
+	# Try to mount the fs with our test options.
+	_try_scratch_mount "$@" >> $seqres.full 2>&1 && mounted=1
+	if [ $mounted -gt 0 ]; then
+		# Implant a sentinel file to see if repair nukes the directory
+		# later.  Scrub, unmount, and check for errors.
+		echo moo > $SCRATCH_MNT/a
+		grep "$SCRATCH_MNT" /proc/mounts >> $seqres.full
+		test $run_scrub -gt 0 && \
+			_scratch_scrub -n >> $seqres.full
+		_scratch_unmount
+		_scratch_xfs_repair -n >> $seqres.full 2>&1 || \
+			echo "Repair found problems."
+	else
+		echo "mount failed" >> $seqres.full
+	fi
+	_scratch_xfs_db -c 'sb 0' -c 'p unit width' >> $seqres.full
+
+	# Run xfs_repair in repair mode to see if it can be baited into nuking
+	# the root filesystem on account of the sunit update.
+	_scratch_xfs_repair >> $seqres.full 2>&1
+
+	# If the previous mount succeeded, mount the fs and look for the file
+	# we implanted.
+	if [ $mounted -gt 0 ]; then
+		_scratch_mount
+		test -f $SCRATCH_MNT/a || echo "Root directory got nuked."
+		_scratch_unmount
+	fi
+
+	echo >> $seqres.full
+}
+
+test_sunit_opts()
+{
+	echo "Format with 4k stripe unit; 1x stripe width" >> $seqres.full
+	_scratch_mkfs -b size=4k -d sunit=8,swidth=8 >> $seqres.full 2>&1
+
+	__test_mount_opts "$@"
+}
+
+test_su_opts()
+{
+	local mounted=0
+
+	echo "Format with 256k stripe unit; 4x stripe width" >> $seqres.full
+	_scratch_mkfs -b size=1k -d su=256k,sw=4 >> $seqres.full 2>&1
+
+	__test_mount_opts "$@"
+}
+
+test_repair_detection()
+{
+	local mounted=0
+
+	echo "Format with 256k stripe unit; 4x stripe width" >> $seqres.full
+	_scratch_mkfs -b size=1k -d su=256k,sw=4 >> $seqres.full 2>&1
+
+	# Try to mount the fs with our test options.
+	_try_scratch_mount >> $seqres.full 2>&1 && mounted=1
+	if [ $mounted -gt 0 ]; then
+		# Implant a sentinel file to see if repair nukes the directory
+		# later.  Scrub, unmount, and check for errors.
+		echo moo > $SCRATCH_MNT/a
+		grep "$SCRATCH_MNT" /proc/mounts >> $seqres.full
+		test $run_scrub -gt 0 && \
+			_scratch_scrub -n >> $seqres.full
+		_scratch_unmount
+		_scratch_xfs_repair -n >> $seqres.full 2>&1 || \
+			echo "Repair found problems."
+	else
+		echo "mount failed" >> $seqres.full
+	fi
+
+	# Update the superblock like the kernel used to do.
+	_scratch_xfs_db -c 'sb 0' -c 'p unit width' >> $seqres.full
+	_scratch_xfs_db -x -c 'sb 0' -c 'write -d unit 256' -c 'write -d width 1024' >> $seqres.full
+	_scratch_xfs_db -c 'sb 0' -c 'p unit width' >> $seqres.full
+
+	# Run xfs_repair in repair mode to see if it can be baited into nuking
+	# the root filesystem on account of the sunit update.
+	_scratch_xfs_repair >> $seqres.full 2>&1
+
+	# If the previous mount succeeded, mount the fs and look for the file
+	# we implanted.
+	if [ $mounted -gt 0 ]; then
+		_scratch_mount
+		test -f $SCRATCH_MNT/a || echo "Root directory got nuked."
+		_scratch_unmount
+	fi
+
+	echo >> $seqres.full
+}
+
+# Format with a 256k stripe unit and 4x stripe width, and try various mount
+# options that want to change that and see if they blow up.  Normally you
+# would never change the stripe *unit*, so it's no wonder this is not well
+# tested.
+
+log "Test: no raid parameters"
+test_su_opts
+
+log "Test: 256k stripe unit; 4x stripe width"
+test_su_opts -o sunit=512,swidth=2048
+
+log "Test: 256k stripe unit; 5x stripe width"
+test_su_opts -o sunit=512,swidth=2560
+
+# Note: Larger stripe units probably won't mount
+log "Test: 512k stripe unit; 4x stripe width"
+test_su_opts -o sunit=1024,swidth=4096
+
+log "Test: 512k stripe unit; 3x stripe width"
+test_su_opts -o sunit=1024,swidth=3072
+
+# Note: Should succeed with kernel warnings, and should not create repair
+# failures or nuke the root directory.
+log "Test: 128k stripe unit; 8x stripe width"
+test_su_opts -o sunit=256,swidth=2048
+
+# Note: Should succeed without nuking the root dir
+log "Test: Repair of 128k stripe unit; 8x stripe width"
+test_repair_detection
+
+# Brian Foster noticed a bug in an earlier version of the patch that avoids
+# updating the ondisk sunit/swidth values if they would cause later repair
+# failures.  The bug was that we wouldn't convert the kernel mount option sunit
+# value to the correct incore units until after computing the inode geometry.
+# This caused it to behave incorrectly when the filesystem was formatted with
+# sunit=1fsb and the mount options try to increase swidth.
+log "Test: Formatting with sunit=1fsb,swidth=1fsb and mounting with larger swidth"
+test_sunit_opts -o sunit=8,swidth=64
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/751.out b/tests/xfs/751.out
new file mode 100644
index 00000000..451c07be
--- /dev/null
+++ b/tests/xfs/751.out
@@ -0,0 +1,9 @@
+QA output created by 751
+Test: no raid parameters
+Test: 256k stripe unit; 4x stripe width
+Test: 256k stripe unit; 5x stripe width
+Test: 512k stripe unit; 4x stripe width
+Test: 512k stripe unit; 3x stripe width
+Test: 128k stripe unit; 8x stripe width
+Test: Repair of 128k stripe unit; 8x stripe width
+Test: Formatting with sunit=1fsb,swidth=1fsb and mounting with larger swidth
diff --git a/tests/xfs/group b/tests/xfs/group
index 9f91864f..f36cf1da 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -510,5 +510,6 @@
 511 auto quick quota
 747 auto quick scrub
 748 auto quick scrub
+751 auto quick
 753 auto quick mkfs
 912 auto quick label
