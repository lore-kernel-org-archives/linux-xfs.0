Return-Path: <SRS0=GxFA=6H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A30F0C2BA19
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Apr 2020 23:34:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7141C2064A
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Apr 2020 23:34:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NkAO33eg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728183AbgDWXeW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Apr 2020 19:34:22 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60088 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726060AbgDWXeV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Apr 2020 19:34:21 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03NNXeZG143829;
        Thu, 23 Apr 2020 23:34:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=J6VDgDEms5P9mFwi25Zml/+fS4n2dc9TPGM6ZIyXYC4=;
 b=NkAO33egZBoc/0Bd4Dnp2ZNmC/uQlHuP46v9d7dForfxkOa/fPTdOLzahirxr6G1VpTY
 s6xEbWhQJY4cOePXosOCsBZa3RRN8452HdD2DVR8WNkka1uFK2pxKBqx4nQIyLy4F7Bp
 74H5W9v/E8XsLxg173nUuL23jOg9adYf0OypFoxlgYDlQgSrxTbnQ0dM5hcJhf2xGEkD
 RC1kulhmoP1co+OxpEIKJBnESNQVlAmMGEUE+YHNGQdkdsrmqNCyBILi+5Z31FYArUyH
 UBBwH/IWaufF5LqbdwZyM2IpH+VV3QwlVEVgJA59UZeca8jV4JRi5x2TQ3t5D+t1MUZe pQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 30ketdhmaf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Apr 2020 23:34:18 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03NNVjQL164129;
        Thu, 23 Apr 2020 23:32:18 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 30gb3wet0y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Apr 2020 23:32:17 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03NNWGcu032568;
        Thu, 23 Apr 2020 23:32:16 GMT
Received: from localhost (/10.159.232.248)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 23 Apr 2020 16:32:16 -0700
Subject: [PATCH 4/4] xfs: test sunit/swidth updates
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Thu, 23 Apr 2020 16:32:15 -0700
Message-ID: <158768473510.3019475.13810129822322030743.stgit@magnolia>
In-Reply-To: <158768470761.3019475.18353274420657119359.stgit@magnolia>
References: <158768470761.3019475.18353274420657119359.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9600 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 suspectscore=0 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004230169
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9600 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 spamscore=0
 impostorscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 mlxscore=0
 priorityscore=1501 clxscore=1015 suspectscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004230169
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add one test to make sure that we can update sunit without blowing up
the filesystem.  This is a regression test for 13eaec4b2adf ("xfs: don't
commit sunit/swidth updates to disk if that would cause repair
failures").

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
index 00000000..c586342f
--- /dev/null
+++ b/tests/xfs/751
@@ -0,0 +1,181 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2020, Oracle and/or its affiliates.  All Rights Reserved.
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
index a626b786..bb77e94b 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -513,6 +513,7 @@
 513 auto mount
 514 auto quick db
 515 auto quick quota
+751 auto quick
 755 auto quick fsmap freeze
 913 auto quick quota
 914 auto quick reflink

