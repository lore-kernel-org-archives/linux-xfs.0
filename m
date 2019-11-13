Return-Path: <SRS0=J5MO=ZF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B2E3C17441
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 02:44:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 41559222CA
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 02:44:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RmezrV0G"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727437AbfKMCoz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Nov 2019 21:44:55 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:46244 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727226AbfKMCoz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Nov 2019 21:44:55 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAD2i6oN076868;
        Wed, 13 Nov 2019 02:44:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=euJWO6JyOhqvkw/nNwobksJ9PbT/nBYTTHQHaAvgwIQ=;
 b=RmezrV0GsU/tjnhuymgmS1/VCzJjr4uTZ+vHh3OR7a9KMNdv8DXxr0YZKUVAHlOBJBjK
 /W8YEAh8qLlPSONYLTQf8YZv7rvCWipEofnljZg90l/dHnieOjsEi+UnlKwxu95RrQN0
 /8nBSiore5aEDVnNs78xw9ngAcGk5x85cuzGNNmlwRzcKvc/GFcHwZLHZ/NUDIVFltoK
 mnPilT0c+tqMp/1rWuP0TUZMXNsE5qGqdQb0mR+1Qer33e6Id+GAegWhPhJlJ3vl0nl0
 FcFUe0WcWrnZQUbj4gp8V0Wc+2dI/YipqOQ6W9DxNRtn5MHEOS8CP3pldLTLIOsLQ/1+ HA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2w5ndq934p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 02:44:53 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAD2hmop042919;
        Wed, 13 Nov 2019 02:44:52 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2w7khmfyuu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 02:44:52 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xAD2ip9w003595;
        Wed, 13 Nov 2019 02:44:52 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 Nov 2019 18:44:51 -0800
Date:   Tue, 12 Nov 2019 18:44:50 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com
Cc:     xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>
Subject: [PATCH] generic: test unwritten extent conversion extent mapping
 quota accounting
Message-ID: <20191113024450.GI6235@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9439 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911130022
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9439 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911130022
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Regression test to ensure that dquots are attached to the inode when
we're performing unwritten extent conversion after a directio write and
the extent mapping btree splits.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/946     |  121 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/946.out |    2 +
 tests/generic/group   |    1 
 3 files changed, 124 insertions(+)
 create mode 100755 tests/generic/946
 create mode 100644 tests/generic/946.out

diff --git a/tests/generic/946 b/tests/generic/946
new file mode 100755
index 00000000..ab020ee5
--- /dev/null
+++ b/tests/generic/946
@@ -0,0 +1,121 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2019, Oracle and/or its affiliates.  All Rights Reserved.
+#
+# FS QA Test No. 946
+#
+# Regression test to ensure that dquots are attached to the inode when we're
+# performing unwritten extent conversion after a directio write and the extent
+# mapping btree splits.  On an unpatched kernel, the quota accounting will be
+# become incorrect.
+#
+# This test accompanies the commit 2815a16d7ff623 "xfs: attach dquots and
+# reserve quota blocks during unwritten conversion".
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
+. ./common/quota
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs generic
+_require_user
+_require_quota
+_require_xfs_io_command "falloc"
+_require_scratch
+
+rm -f $seqres.full
+
+cat > $tmp.awk << ENDL
+{
+if (\$1 == qa_user && \$2 != blocks)
+	printf("%s: quota blocks %dKiB, expected %dKiB!\n", qa_user, \$2, blocks);
+}
+ENDL
+
+# Make sure that the quota blocks accounting for qa_user on the scratch fs
+# matches the stat blocks counter for the only file on the scratch fs that
+# is owned by qa_user.  Note that stat reports in units of 512b blocks whereas
+# repquota reports in units of 1k blocks.
+check_quota_accounting()
+{
+	$XFS_IO_PROG -c stat $testfile > $tmp.out
+	cat $tmp.out >> $seqres.full
+	local stat_blocks=$(grep 'stat.blocks' $tmp.out | awk '{print $3 / 2}')
+
+	_report_quota_blocks $SCRATCH_MNT > $tmp.out
+	cat $tmp.out >> $seqres.full
+	awk -v qa_user=$qa_user -v blocks=$stat_blocks -f $tmp.awk $tmp.out
+}
+
+_scratch_mkfs > $seqres.full
+
+# This test must have user quota enabled
+_qmount_option usrquota
+_qmount >> $seqres.full
+
+testfile=$SCRATCH_MNT/test-$seq
+touch $testfile
+chown $qa_user $testfile
+
+# Preallocate a file with just enough space that when we write every other
+# block of the file, the extent mapping tree will expand to a two-block tree.
+# Each tree block has a 56-byte header, and each mapping consumes 16 bytes.
+meta_blksz=$(_get_block_size $SCRATCH_MNT)
+file_blksz=$(_get_file_block_size $SCRATCH_MNT)
+
+mappings_per_bmbt_block=$(( (meta_blksz - 56) / 16))
+extents_needed=$((mappings_per_bmbt_block * 2))
+sz=$((extents_needed * file_blksz))
+
+$XFS_IO_PROG -f -c "falloc 0 $sz" $testfile >> $seqres.full
+check_quota_accounting
+
+# Cycle the mount to detach dquots and expand the bmbt to a single block.
+_qmount >> $seqres.full
+for ((i = 0; i < mappings_per_bmbt_block; i += 2)); do
+	offset=$((i * file_blksz))
+	$XFS_IO_PROG -d -c "pwrite $offset $file_blksz" $testfile >> $seqres.full
+done
+check_quota_accounting
+
+# Cycle the mount to detach dquots and expand the bmbt to multiple blocks.
+# A buggy kernel will forget to attach the dquots before the bmbt split and
+# this will cause us to lose a block in the quota accounting.
+_qmount >> $seqres.full
+for ((i = mappings_per_bmbt_block; i < extents_needed; i += 2)); do
+	offset=$((i * file_blksz))
+	$XFS_IO_PROG -d -c "pwrite $offset $file_blksz" $testfile >> $seqres.full
+done
+check_quota_accounting
+
+# Remove the test file, which (if the quota accounting is incorrect) will
+# also trigger assertions when we try to free more blocks from the dquot than
+# were accounted to the dquot.  Only do this if assertions aren't going to be
+# fatal, since the check_quota_accounting above should be enough to fail the
+# test when the kernel is buggy.
+bug_on_assert="/sys/fs/xfs/debug/bug_on_assert"
+if [ -f $bug_on_assert ] && grep -q "0" $bug_on_assert; then
+	rm -f $testfile
+fi
+
+echo Silence is golden.
+# success, all done
+status=0
+exit
diff --git a/tests/generic/946.out b/tests/generic/946.out
new file mode 100644
index 00000000..353c860d
--- /dev/null
+++ b/tests/generic/946.out
@@ -0,0 +1,2 @@
+QA output created by 946
+Silence is golden.
diff --git a/tests/generic/group b/tests/generic/group
index 308f86f2..29437599 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -589,3 +589,4 @@
 584 auto quick encrypt
 585 auto rename
 722 auto quick rw falloc
+946 auto quick rw prealloc falloc
