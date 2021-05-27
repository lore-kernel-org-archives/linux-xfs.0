Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C412FC4708A
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 08:47:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8FFF613D1
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 08:47:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235554AbhE0ItP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 May 2021 04:49:15 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:34960 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S235516AbhE0ItP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 May 2021 04:49:15 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14R8aixI031811;
        Thu, 27 May 2021 04:47:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=FOyWnpTvQQBW27gvuDa4YvEfj71P50XyRPcrpvt1FeU=;
 b=nAl6Q6dDlFGVtr+e6VKJJF7F67colIXognCjd3Q4dtJx2Neh16iEIseLTmgvqU/w2G6G
 tS+JyDimP8PSGSIZqM2/UJHTDUJqcZ+s01z+P0CXiVhCxblaG1aQafMqfk6Zr/yzg3/A
 Q8hoS2LPrHEvwCEHxQe5RJGnUipWVhtOUCBugEkHHUqzZ1REpzGfg3qZhqBbiTicb35Z
 mmS18NChi7Z6bH7Lur2Olb3OcJIE0urLlCb4HfJled0kPzPrxPoEieSAGSpF0XttZFPQ
 Nr66z5wTxiqDLPqHAbYpP9sloh+LxgKI7x6HrXE0V3ToPRCwySrEyTu2660y7i0XR1dz 7A== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38t7a2j158-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 May 2021 04:47:41 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 14R8iG7o022022;
        Thu, 27 May 2021 08:47:40 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 38sba2ru1y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 May 2021 08:47:40 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14R8l8mN36307450
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 May 2021 08:47:08 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0B5FA11C058;
        Thu, 27 May 2021 08:47:38 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AD54611C050;
        Thu, 27 May 2021 08:47:37 +0000 (GMT)
Received: from localhost (unknown [9.85.91.152])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 27 May 2021 08:47:37 +0000 (GMT)
From:   Ritesh Harjani <riteshh@linux.ibm.com>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org,
        Anju T Sudhakar <anju@linux.vnet.ibm.com>,
        Ritesh Harjani <riteshh@linux.ibm.com>
Subject: [PATCH] generic/639: Add tiny swapfile test
Date:   Thu, 27 May 2021 14:17:28 +0530
Message-Id: <e1f9798462ef60648db24b6291e1b149b114f2f2.1622105066.git.riteshh@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: VB09QqYBgj4tMHEuThL8P9xZ0ipYias6
X-Proofpoint-GUID: VB09QqYBgj4tMHEuThL8P9xZ0ipYias6
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-27_04:2021-05-26,2021-05-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 clxscore=1011 suspectscore=0 adultscore=0 mlxlogscore=999 malwarescore=0
 lowpriorityscore=0 spamscore=0 phishscore=0 priorityscore=1501 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105270056
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This adds a swap test for tiny discontiguous swapfile.
This was causing a kernel crash on XFS with kernel <= v4.18 and could
cause a invalid huge swapfile to get registered on latest kernel which
may lead to random corruption later.
(This happens only on bs < ps configuration)

More details about the kernel issue could be found in commit msg of the
fix at [1].

[1]: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=5808fecc572391867fcd929662b29c12e6d08d81

Signed-off-by: Ritesh Harjani <riteshh@linux.ibm.com>
---
 tests/generic/639     | 78 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/639.out |  2 ++
 tests/generic/group   |  1 +
 3 files changed, 81 insertions(+)
 create mode 100755 tests/generic/639
 create mode 100644 tests/generic/639.out

diff --git a/tests/generic/639 b/tests/generic/639
new file mode 100755
index 00000000..3c6d8f1b
--- /dev/null
+++ b/tests/generic/639
@@ -0,0 +1,78 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2021 YOUR NAME HERE.  All Rights Reserved.
+#
+# FS QA Test 639
+#
+# Test tiny swapfile with discontiguity. This was causing a kernel crash on XFS
+# with kernel version <= v4.18. And/or could cause a invalid swapfilesize to get
+# registered, which could cause some corruption later in the running kernel.
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=0	# success is the default!
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
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs generic
+_require_test
+_require_xfs_io_command "fcollapse"
+_require_test_program mkswap
+_require_test_program swapon
+_require_scratch_swapfile
+
+_scratch_mkfs >>$seqres.full 2>&1
+_scratch_mount >>$seqres.full 2>&1
+
+SWAPFILE=$SCRATCH_MNT/swapscratch-$seq
+PS=$(get_page_size)
+BS=$(_get_block_size $SCRATCH_MNT)
+
+if [ $BS -gt $(($PS / 4)) ]; then
+	_notrun "This test requires blocksize atleast less or equal to pagesize/4, bs=$BS, ps=$PS"
+fi
+
+# create a swapfile
+$XFS_IO_PROG -f -c "pwrite 0 $(($PS + $PS + $BS + $BS))" -c fsync $SWAPFILE >> $seqres.full
+$XFS_IO_PROG -c "fcollapse $(($PS - $BS)) $BS" $SWAPFILE >> $seqres.full
+$XFS_IO_PROG -c "fcollapse $(($PS*2 - $BS*2)) $BS" $SWAPFILE >> $seqres.full
+$CHATTR_PROG +C $SWAPFILE >> $seqres.full 2>&1
+"$here/src/mkswap" $SWAPFILE
+
+"$here/src/swapon" $SWAPFILE >> $seqres.full 2>&1
+ret=$?
+if [ $ret -eq 0 ]; then
+	swapsize_kb=$(cat /proc/swaps |grep $SWAPFILE |awk '{print $3}')
+	swapsize=$(($swapsize_kb * 1024))
+	filesize=$(_get_filesize $SWAPFILE)
+
+	# error case
+	if [ $swapsize -gt $filesize ]; then
+		status=1
+		echo "Allocated swap size($swapsize) cannot be greater than swapfile size($filesize)"
+	fi
+fi
+swapoff $SWAPFILE >> $seqres.full 2>&1
+
+echo "Silence is golden"
+exit
diff --git a/tests/generic/639.out b/tests/generic/639.out
new file mode 100644
index 00000000..62c66537
--- /dev/null
+++ b/tests/generic/639.out
@@ -0,0 +1,2 @@
+QA output created by 639
+Silence is golden
diff --git a/tests/generic/group b/tests/generic/group
index 9a636b23..48ffa3c7 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -641,3 +641,4 @@
 636 auto quick swap
 637 auto quick dir
 638 auto quick rw
+639 auto quick swap
-- 
2.31.1

