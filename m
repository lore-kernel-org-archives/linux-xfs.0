Return-Path: <SRS0=2cgH=B3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19B91C433E1
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 23:03:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB90D20709
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 23:03:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="yMlJdufU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726457AbgHQXDZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Aug 2020 19:03:25 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43386 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726324AbgHQXDZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Aug 2020 19:03:25 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07HMuvV9136124;
        Mon, 17 Aug 2020 23:03:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=mcnX/8DZTfT0aHYxjsCRxU1nbVmNU5JJmlaauqDgX18=;
 b=yMlJdufUVBseSWzbxZNKSYeetel9nFlgjj/Hdm7ORD+dwTXlmbVr9OKjEGfJkfk6kmwp
 j1EMsWJDXEfJB/09obim6v31U3haMuKJuKXgjZFOIL2FwmlOOixea9CIW/Aw68ndb6w0
 N/I4mHKzsllE6Djcju/YcpoSDcUIUUjRAueZjLl8u2UK8X6rmlqbS7Aqg2SBsgikdiYf
 QD37NlNvtryhnde9k33YNqILap36JSNH8pSnvOrN/AEzzm1pDkOVQprzcUu/tiPTV6dC
 Z/lPBtIihc0OK7XQy9zs8X6eDNV5o5XjRH4QAcLLKRZFoGbIijNijea/8qfZOu9Ro1SO IQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 32x8bn1geq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 17 Aug 2020 23:03:22 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07HMw9xT084706;
        Mon, 17 Aug 2020 23:01:22 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 32xsfr5c5j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Aug 2020 23:01:22 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07HN1Ls0026421;
        Mon, 17 Aug 2020 23:01:21 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 17 Aug 2020 16:01:20 -0700
Subject: [PATCH 4/4] xfs: test upgrading filesystem to bigtime
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Mon, 17 Aug 2020 16:01:19 -0700
Message-ID: <159770527916.3960575.1560206777561534458.stgit@magnolia>
In-Reply-To: <159770525400.3960575.11977829712550002800.stgit@magnolia>
References: <159770525400.3960575.11977829712550002800.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 spamscore=0 suspectscore=0 mlxscore=0 phishscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008170153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 lowpriorityscore=0
 impostorscore=0 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 priorityscore=1501 bulkscore=0 clxscore=1015 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008170153
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Test that we can upgrade an existing filesystem to use bigtime.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/xfs        |   16 +++++++++++
 tests/xfs/908     |   74 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/908.out |    3 ++
 tests/xfs/909     |   77 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/909.out |   12 ++++++++
 tests/xfs/group   |    2 +
 6 files changed, 184 insertions(+)
 create mode 100755 tests/xfs/908
 create mode 100644 tests/xfs/908.out
 create mode 100755 tests/xfs/909
 create mode 100644 tests/xfs/909.out


diff --git a/common/xfs b/common/xfs
index 252a5c0d..c0735a51 100644
--- a/common/xfs
+++ b/common/xfs
@@ -985,3 +985,19 @@ _xfs_timestamp_range()
 		$dbprog -f -c 'timelimit --compact' | awk '{printf("%s %s", $1, $2);}'
 	fi
 }
+
+_require_xfs_mkfs_bigtime()
+{
+	_scratch_mkfs_xfs_supported -m bigtime=1 >/dev/null 2>&1 \
+	   || _notrun "mkfs.xfs doesn't have bigtime feature"
+}
+
+_require_xfs_scratch_bigtime()
+{
+	_require_scratch
+
+	_scratch_mkfs -m bigtime=1 > /dev/null
+	_try_scratch_mount || \
+		_notrun "bigtime not supported by scratch filesystem type: $FSTYP"
+	_scratch_unmount
+}
diff --git a/tests/xfs/908 b/tests/xfs/908
new file mode 100755
index 00000000..e313e14b
--- /dev/null
+++ b/tests/xfs/908
@@ -0,0 +1,74 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2020, Oracle and/or its affiliates.  All Rights Reserved.
+#
+# FS QA Test No. 908
+#
+# Check that we can upgrade a filesystem to support bigtime and that inode
+# timestamps work properly after the upgrade.
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
+
+# real QA test starts here
+_supported_fs xfs
+_supported_os Linux
+_require_xfs_mkfs_crc
+_require_xfs_mkfs_bigtime
+_require_xfs_scratch_bigtime
+
+date --date='Jan 1 00:00:00 UTC 2040' > /dev/null 2>&1 || \
+	_notrun "Userspace does not support dates past 2038."
+
+rm -f $seqres.full
+
+# Format V5 filesystem without bigtime support and populate it
+_scratch_mkfs -m crc=1,bigtime=0 > $seqres.full
+_scratch_xfs_db -c 'version' -c 'sb 0' -c 'p' >> $seqres.full
+_scratch_mount >> $seqres.full
+
+touch $SCRATCH_MNT/a
+touch $SCRATCH_MNT/b
+ls -la $SCRATCH_MNT/* >> $seqres.full
+
+_scratch_unmount
+_check_scratch_fs
+
+# Now upgrade to bigtime support
+_scratch_xfs_admin -O bigtime >> $seqres.full
+_check_scratch_fs
+_scratch_xfs_db -c 'version' -c 'sb 0' -c 'p' >> $seqres.full
+
+# Mount again, look at our files
+_scratch_mount >> $seqres.full
+ls -la $SCRATCH_MNT/* >> $seqres.full
+
+# Modify some timestamps
+touch -d 'Feb 22 22:22:22 UTC 2222' $SCRATCH_MNT/b
+
+_scratch_cycle_mount
+
+# Did the timestamp survive?
+ls -la $SCRATCH_MNT/* >> $seqres.full
+TZ=UTC stat -c '%Y' $SCRATCH_MNT/b
+
+# success, all done
+echo Silence is golden.
+status=0
+exit
diff --git a/tests/xfs/908.out b/tests/xfs/908.out
new file mode 100644
index 00000000..38fdf6b3
--- /dev/null
+++ b/tests/xfs/908.out
@@ -0,0 +1,3 @@
+QA output created by 908
+7956915742
+Silence is golden.
diff --git a/tests/xfs/909 b/tests/xfs/909
new file mode 100755
index 00000000..8d8675da
--- /dev/null
+++ b/tests/xfs/909
@@ -0,0 +1,77 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2020, Oracle and/or its affiliates.  All Rights Reserved.
+#
+# FS QA Test No. 909
+#
+# Check that we can upgrade a filesystem to support bigtime and that quota
+# timers work properly after the upgrade.
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
+_supported_fs xfs
+_supported_os Linux
+_require_quota
+_require_xfs_mkfs_crc
+_require_xfs_mkfs_bigtime
+_require_xfs_scratch_bigtime
+
+date --date='Jan 1 00:00:00 UTC 2040' > /dev/null 2>&1 || \
+	_notrun "Userspace does not support dates past 2038."
+
+rm -f $seqres.full
+
+# Format V5 filesystem without bigtime support and populate it
+_scratch_mkfs -m crc=1,bigtime=0 > $seqres.full
+_qmount_option "usrquota"
+_scratch_xfs_db -c 'version' -c 'sb 0' -c 'p' >> $seqres.full
+_scratch_mount >> $seqres.full
+
+touch $SCRATCH_MNT/a
+touch $SCRATCH_MNT/b
+$XFS_QUOTA_PROG -x -c 'timer -u 300m' $SCRATCH_MNT
+$XFS_QUOTA_PROG -x -c 'state' $SCRATCH_MNT | grep 'grace time'
+
+_scratch_unmount
+
+# Now upgrade to bigtime support
+_scratch_xfs_admin -O bigtime >> $seqres.full
+_check_scratch_fs
+_scratch_xfs_db -c 'version' -c 'sb 0' -c 'p' >> $seqres.full
+
+# Mount again, see if our quota timer survived
+_scratch_mount
+$XFS_QUOTA_PROG -x -c 'state' $SCRATCH_MNT | grep 'grace time'
+
+# Create a file to force the dirty dquot out to disk
+touch -d 'Feb 22 22:22:22 UTC 2222' $SCRATCH_MNT/b
+
+_scratch_cycle_mount
+
+# Did the timer (and the timestamp) survive?
+TZ=UTC stat -c '%Y' $SCRATCH_MNT/b
+$XFS_QUOTA_PROG -x -c 'state' $SCRATCH_MNT | grep 'grace time'
+
+# success, all done
+echo Silence is golden.
+status=0
+exit
diff --git a/tests/xfs/909.out b/tests/xfs/909.out
new file mode 100644
index 00000000..70e1b082
--- /dev/null
+++ b/tests/xfs/909.out
@@ -0,0 +1,12 @@
+QA output created by 909
+Blocks grace time: [0 days 05:00:00]
+Inodes grace time: [0 days 05:00:00]
+Realtime Blocks grace time: [0 days 05:00:00]
+Blocks grace time: [0 days 05:00:00]
+Inodes grace time: [0 days 05:00:00]
+Realtime Blocks grace time: [0 days 05:00:00]
+7956915742
+Blocks grace time: [0 days 05:00:00]
+Inodes grace time: [0 days 05:00:00]
+Realtime Blocks grace time: [0 days 05:00:00]
+Silence is golden.
diff --git a/tests/xfs/group b/tests/xfs/group
index 0063fd19..93fdaba9 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -531,6 +531,8 @@
 746 auto quick online_repair
 747 auto quick scrub
 748 auto quick scrub
+908 auto quick bigtime
+909 auto quick bigtime quota
 910 auto quick inobtcount
 911 auto quick bigtime
 915 auto quick quota

