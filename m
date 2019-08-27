Return-Path: <SRS0=DGLX=WX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB342C3A5A3
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Aug 2019 15:09:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 996852189D
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Aug 2019 15:09:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Unw3gAjb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730326AbfH0PJH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Aug 2019 11:09:07 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:54548 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730312AbfH0PJH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Aug 2019 11:09:07 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7RExV3L112160;
        Tue, 27 Aug 2019 15:08:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=MczUmeziLgB/JTVa5SqeIK0A/cdhin61qIKkFvJAyG4=;
 b=Unw3gAjbqKJKkNxQP/LgS89a8aTHdnwyJB7aAmgMV1vm7z6YAeDZP7uFD9+vhTkdzxKA
 5SihCIlO0dmO/MCywbIA66OXBzkWXx0s4FwjTB0GYcquqPaJnrR+bjqN/OCVov8ohHji
 VrK2HITIob54LpQ1zql4ONyQLAgdU37nCfRHYEjBtQ6+KhFcYU7I8t0KNUVgRgvA1JtU
 dxqNMkZIbu0RAmPrgBwbK+y5WH+vdaHHxtt6m5vHl/nt04e1dTQWpMRdDzCfXU0RJ56N
 B/G4is2f8lZCJ17KcDjOH9SAV3kjgmZDwECB+Ka5rxQrBBrHK/uBZb1D45nlezEvzpyS UA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2un6qtr45n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Aug 2019 15:08:54 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7REwD0O057526;
        Tue, 27 Aug 2019 15:08:54 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2un5rjkqcj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Aug 2019 15:08:53 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7RF8qRw007982;
        Tue, 27 Aug 2019 15:08:52 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 27 Aug 2019 08:08:52 -0700
Date:   Tue, 27 Aug 2019 08:08:50 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        xfs <linux-xfs@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>,
        Salvatore Bonaccorso <carnil@debian.org>,
        Security Officers <security@kernel.org>,
        Debian Security Team <team@security.debian.org>,
        benjamin.moody@gmail.com, Ben Hutchings <benh@debian.org>,
        fstests <fstests@vger.kernel.org>
Subject: [PATCH v3] generic: test for failure to unlock inode after chgrp
 fails with EDQUOT
Message-ID: <20190827150850.GC1037528@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9362 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908270155
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9362 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908270155
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

This is a regression test that checks for xfs drivers that fail to
unlock the inode after changing the group id fails with EDQUOT.  It
pairs with "xfs: fix missing ILOCK unlock when xfs_setattr_nonsize fails
due to EDQUOT".

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
v2: fix spdx tag even though i have no idea what i'm doing
---
 tests/generic/719     |   59 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/719.out |    2 ++
 tests/generic/group   |    1 +
 3 files changed, 62 insertions(+)
 create mode 100755 tests/generic/719
 create mode 100644 tests/generic/719.out

diff --git a/tests/generic/719 b/tests/generic/719
new file mode 100755
index 00000000..4ba10380
--- /dev/null
+++ b/tests/generic/719
@@ -0,0 +1,59 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0+
+# Copyright (c) 2019, Oracle and/or its affiliates.  All Rights Reserved.
+#
+# FS QA Test No. 719
+#
+# Regression test for chgrp returning to userspace with ILOCK held after a
+# hard quota error.  This causes the filesystem to hang, so it is (for now)
+# a dangerous test.
+#
+# This test goes with commit 1fb254aa983bf ("xfs: fix missing ILOCK unlock when
+# xfs_setattr_nonsize fails due to EDQUOT")
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
+. ./common/quota
+. ./common/filter
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs generic
+_require_scratch
+_require_quota
+_require_user
+
+rm -f $seqres.full
+
+_qmount_option "grpquota"
+_scratch_mkfs > $seqres.full
+_qmount
+
+dir="$SCRATCH_MNT/dummy"
+mkdir -p $dir
+chown $qa_user $dir
+$XFS_QUOTA_PROG -x -f -c "limit -g bsoft=100k bhard=100k $qa_user" $SCRATCH_MNT
+
+$XFS_IO_PROG -f -c 'pwrite -S 0x58 0 1m' $dir/foo >> $seqres.full
+chown $qa_user "${dir}/foo"
+su $qa_user -c "chgrp $qa_user ${dir}/foo" 2>&1 | _filter_scratch
+ls -la ${dir} >> $seqres.full
+$XFS_QUOTA_PROG -x -f -c 'report -hag' $SCRATCH_MNT >> $seqres.full
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/719.out b/tests/generic/719.out
new file mode 100644
index 00000000..8f9d51b5
--- /dev/null
+++ b/tests/generic/719.out
@@ -0,0 +1,2 @@
+QA output created by 719
+chgrp: changing group of 'SCRATCH_MNT/dummy/foo': Disk quota exceeded
diff --git a/tests/generic/group b/tests/generic/group
index 2e4a6f79..cd418106 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -568,3 +568,4 @@
 563 auto quick
 564 auto quick copy_range
 565 auto quick copy_range
+719 auto quick quota metadata
