Return-Path: <SRS0=lWMA=WT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C86D8C3A589
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Aug 2019 03:58:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 81BB82341F
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Aug 2019 03:58:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QEr1CYOr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389964AbfHWD6G (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Aug 2019 23:58:06 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:45504 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389534AbfHWD6F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Aug 2019 23:58:05 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7N3sSlq173988;
        Fri, 23 Aug 2019 03:57:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=S9kBUVm17hXvoWdyh7Ne9DSOZkOMaQ2oq41iXhRoSmM=;
 b=QEr1CYOr4dsMYWXc22D16u1e2SjzBkPzHez7rK0msvIDCJa5XzqhzoI/kNvpTGLKhTmo
 eT8qRWDKNkfpFGx9gEHNYKTL0SLiqt+E6WHZiH97bLSaejfwnT/gTTxghzMG+0AWIvog
 jh+n5b3NKzGEvehddHdR93RD4+BNR9X2WDll7EVnXYzdlPPOaM9hED1uoEj5358FR/qN
 w7qqReQHraRXcCIzfa/KUOK6Rd02pLsErnSt/OfVhMNGVBQtaStke8dCIigo65yjnYEV
 Od9lU788BEu0+Su+rrpQ+DgLQBx1G9f/ZJy2cDQqBHx8DrMJ0+Z9Th0NmloleX0lzA1y aw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2ue9hq1v1w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Aug 2019 03:57:37 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7N3rv4a054755;
        Fri, 23 Aug 2019 03:57:37 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2uj1y01d8a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Aug 2019 03:57:37 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7N3va7D026769;
        Fri, 23 Aug 2019 03:57:36 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 22 Aug 2019 20:57:35 -0700
Date:   Thu, 22 Aug 2019 20:57:34 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>,
        Salvatore Bonaccorso <carnil@debian.org>,
        Security Officers <security@kernel.org>,
        Debian Security Team <team@security.debian.org>,
        benjamin.moody@gmail.com, Ben Hutchings <benh@debian.org>,
        Christoph Hellwig <hch@infradead.org>,
        fstests <fstests@vger.kernel.org>
Subject: [PATCH] generic: test for failure to unlock inode after chgrp fails
 with EDQUOT
Message-ID: <20190823035734.GH1037350@magnolia>
References: <20190823035528.GH1037422@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190823035528.GH1037422@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9357 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908230040
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9357 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908230040
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
---
 tests/generic/719     |   56 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/719.out |    2 ++
 tests/generic/group   |    1 +
 3 files changed, 59 insertions(+)
 create mode 100755 tests/generic/719
 create mode 100644 tests/generic/719.out

diff --git a/tests/generic/719 b/tests/generic/719
new file mode 100755
index 00000000..2771a1f3
--- /dev/null
+++ b/tests/generic/719
@@ -0,0 +1,56 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-newer
+# Copyright (c) 2019, Oracle and/or its affiliates.  All Rights Reserved.
+#
+# FS QA Test No. 719
+#
+# Regression test for chgrp returning to userspace with ILOCK held after a
+# hard quota error.  This causes the filesystem to hang, so it is (for now)
+# a dangerous test.
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
index e998d1d5..bb93bccc 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -572,3 +572,4 @@
 716 dangerous_norepair
 717 auto quick rw swap
 718 auto quick rw swap
+719 dangerous
