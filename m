Return-Path: <SRS0=PA6D=YP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FBD6CA9EB7
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 01:49:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F7332166E
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Oct 2019 01:49:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QeE+Kxhq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730469AbfJVBt6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Oct 2019 21:49:58 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:50056 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727264AbfJVBt5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Oct 2019 21:49:57 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9M1mwiT008620;
        Tue, 22 Oct 2019 01:49:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=Lu7IP0aBz5Y0A/T22tizyr9lzpobsdI9Tm4MJfMX8Mk=;
 b=QeE+Kxhq5KdDsZRN21fdvqGLlZDPT9ZUCPHGsgRCzdKk30ZgOzTGw//wU31XAhtlmkiw
 +9zJwNvRXh2HOv8sMR/ror4SH0UaEwY7H0zcmdW1Gr1dUljIGpNOt95AZ4RX0ZQohxc7
 T+dqiOg09lXkKKxlmvUHCLh36wP6PPhAdNfIA2vWzxd07VCur2ZmYqfFhE6au6KsaUAn
 sLNeNxa9dSUp0X21vn417CGFhl9fxVtMPpY2T0yUtWKDHLd/EWm+jVfct57tXDFCPef4
 JUX4fvX+WRCSZqJJ8IDr60M+gBhZZBHgyf1hsACiZdBHyUWN/k9XCEOYWotNKr0+bJAa zA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2vqu4qk64t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 01:49:55 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9M1lsQg066501;
        Tue, 22 Oct 2019 01:49:54 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2vsakceb9j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 01:49:54 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9M1ns47026596;
        Tue, 22 Oct 2019 01:49:54 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 21 Oct 2019 18:49:53 -0700
Subject: [PATCH 2/2] xfs: make sure the kernel and repair tools catch bad
 names
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Mon, 21 Oct 2019 18:49:52 -0700
Message-ID: <157170899277.1172383.10473571682266133494.stgit@magnolia>
In-Reply-To: <157170897992.1172383.2128928990011336996.stgit@magnolia>
References: <157170897992.1172383.2128928990011336996.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9417 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910220015
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9417 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910220016
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Make sure we actually catch bad names in the kernel.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/749     |  103 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/749.out |    4 ++
 tests/xfs/group   |    1 +
 3 files changed, 108 insertions(+)
 create mode 100755 tests/xfs/749
 create mode 100644 tests/xfs/749.out


diff --git a/tests/xfs/749 b/tests/xfs/749
new file mode 100755
index 00000000..de219979
--- /dev/null
+++ b/tests/xfs/749
@@ -0,0 +1,103 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-newer
+# Copyright (c) 2019, Oracle and/or its affiliates.  All Rights Reserved.
+#
+# FS QA Test No. 749
+#
+# See if we catch corrupt directory names or attr names with nulls or slashes
+# in them.
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
+	umount $mntpt > /dev/null 2>&1
+	test -n "$loopdev" && _destroy_loop_device $loopdev > /dev/null 2>&1
+	rm -r -f $imgfile $mntpt $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_fs xfs
+_supported_os Linux
+_require_test
+
+rm -f $seqres.full
+
+imgfile=$TEST_DIR/img-$seq
+mntpt=$TEST_DIR/mount-$seq
+testdir=$mntpt/testdir
+testfile=$mntpt/testfile
+nullstr="too_many_beans"
+slashstr="are_bad_for_you"
+
+# Format image file
+truncate -s 40m $imgfile
+loopdev=$(_create_loop_device $imgfile)
+$MKFS_XFS_PROG $loopdev >> $seqres.full
+
+# Mount image file
+mkdir -p $mntpt
+mount $loopdev $mntpt
+
+# Create directory entries
+mkdir -p $testdir
+touch $testdir/$nullstr
+touch $testdir/$slashstr
+
+# Create attrs
+touch $testfile
+$ATTR_PROG -s $nullstr -V heh $testfile >> $seqres.full
+$ATTR_PROG -s $slashstr -V heh $testfile >> $seqres.full
+
+# Corrupt the entries
+umount $mntpt
+_destroy_loop_device $loopdev
+cp $imgfile $imgfile.old
+sed -b \
+	-e "s/$nullstr/too_many\x00beans/g" \
+	-e "s/$slashstr/are_bad\/for_you/g" \
+	-i $imgfile
+test "$(md5sum < $imgfile)" != "$(md5sum < $imgfile.old)" ||
+	_fail "sed failed to change the image file?"
+rm -f $imgfile.old
+loopdev=$(_create_loop_device $imgfile)
+mount $loopdev $mntpt
+
+# Try to access the corrupt metadata
+ls $testdir >> $seqres.full 2> $tmp.err
+attr -l $testfile >> $seqres.full 2>> $tmp.err
+cat $tmp.err | _filter_test_dir
+
+# Does scrub complain about this?
+if _supports_xfs_scrub $mntpt $loopdev; then
+	$XFS_SCRUB_PROG -n $mntpt >> $seqres.full 2>&1
+	res=$?
+	test $((res & 1)) -eq 0 && \
+		echo "scrub failed to report corruption ($res)"
+fi
+
+# Does repair complain about this?
+umount $mntpt
+$XFS_REPAIR_PROG -n $loopdev >> $seqres.full 2>&1
+res=$?
+test $res -eq 1 || \
+	echo "repair failed to report corruption ($res)"
+
+_destroy_loop_device $loopdev
+loopdev=
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/749.out b/tests/xfs/749.out
new file mode 100644
index 00000000..db704c87
--- /dev/null
+++ b/tests/xfs/749.out
@@ -0,0 +1,4 @@
+QA output created by 749
+ls: cannot access 'TEST_DIR/mount-749/testdir': Structure needs cleaning
+attr_list: Structure needs cleaning
+Could not list "(null)" for TEST_DIR/mount-749/testfile
diff --git a/tests/xfs/group b/tests/xfs/group
index f4ebcd8c..9600cb4e 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -507,3 +507,4 @@
 509 auto ioctl
 510 auto ioctl quick
 511 auto quick quota
+749 auto quick fuzzers

