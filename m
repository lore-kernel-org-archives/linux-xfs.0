Return-Path: <SRS0=2cgH=B3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7069EC433E3
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 23:01:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C7C320674
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 23:01:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qHmD5s3a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728239AbgHQXBN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Aug 2020 19:01:13 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:53304 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728171AbgHQXBK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Aug 2020 19:01:10 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07HMvPF8050021;
        Mon, 17 Aug 2020 23:01:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=HrKUevwODpTMU16sd9yaBbJ3yneCdNDu+DPD41i1jk0=;
 b=qHmD5s3adIXeSF95SEVqEWdab9NAVD7sEYS97p3/n59efyOZYJhFCEuC8DQ7dSOZZeHa
 ZuvrnujggZfWgn8le26gb2b3VuJ/lDxlU04AJ+qhpd/SoovkRtSKa5foqAnFWQ7g5eHd
 DKTbz9+Co9KXDFR7Ent5zbXCNZ3q3jH0yBFYS/4R1d9462ZFV4iRKI61Q0cV12CzNXWH
 9zqNXUl3LgZYQoE4Wuy7KgdQ+fxzAuKJ1LRGE6IEdAYhZR7mIoDov5ioKUwO5GSd49+/
 wuhsXiXJxiNGdvy2WeXivNEB1bexO6AwmSlE7zVwAPxkRaLhMmE/1/HXTTOf/CgOHUK+ Wg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 32x7nm9k0a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 17 Aug 2020 23:01:08 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07HMvjTC113905;
        Mon, 17 Aug 2020 23:01:08 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 32xsm18un1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Aug 2020 23:01:08 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07HN17ZV015638;
        Mon, 17 Aug 2020 23:01:07 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 17 Aug 2020 16:01:07 -0700
Subject: [PATCH 2/4] xfs: test inobtcount upgrade
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Mon, 17 Aug 2020 16:01:06 -0700
Message-ID: <159770526657.3960575.11874406628211391398.stgit@magnolia>
In-Reply-To: <159770525400.3960575.11977829712550002800.stgit@magnolia>
References: <159770525400.3960575.11977829712550002800.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 malwarescore=0 mlxscore=0 phishscore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008170153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 impostorscore=0 priorityscore=1501 adultscore=0 mlxscore=0 mlxlogscore=999
 lowpriorityscore=0 bulkscore=0 phishscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008170153
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Make sure we can actually upgrade filesystems to support inobtcounts.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/xfs        |   16 ++++++++++++++
 tests/xfs/910     |   60 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/910.out |    3 +++
 tests/xfs/group   |    1 +
 4 files changed, 80 insertions(+)
 create mode 100755 tests/xfs/910
 create mode 100644 tests/xfs/910.out


diff --git a/common/xfs b/common/xfs
index ce279041..05ed768a 100644
--- a/common/xfs
+++ b/common/xfs
@@ -955,3 +955,19 @@ _xfs_get_cowgc_interval() {
 		_fail "Can't find cowgc interval procfs knob?"
 	fi
 }
+
+_require_xfs_mkfs_inobtcount()
+{
+	_scratch_mkfs_xfs_supported -m inobtcount=1 >/dev/null 2>&1 \
+	   || _notrun "mkfs.xfs doesn't have inobtcount feature"
+}
+
+_require_xfs_scratch_inobtcount()
+{
+	_require_scratch
+
+	_scratch_mkfs -m inobtcount=1 > /dev/null
+	_try_scratch_mount || \
+		_notrun "inobtcount not supported by scratch filesystem type: $FSTYP"
+	_scratch_unmount
+}
diff --git a/tests/xfs/910 b/tests/xfs/910
new file mode 100755
index 00000000..3cc5fca2
--- /dev/null
+++ b/tests/xfs/910
@@ -0,0 +1,60 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2020, Oracle and/or its affiliates.  All Rights Reserved.
+#
+# FS QA Test No. 910
+#
+# Check that we can upgrade a filesystem to support inobtcount and that
+# everything works properly after the upgrade.
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
+_require_command "$XFS_ADMIN_PROG" "xfs_admin"
+_require_xfs_mkfs_inobtcount
+_require_xfs_scratch_inobtcount
+
+rm -f $seqres.full
+
+# Format V5 filesystem without inode btree counter support and populate it
+_scratch_mkfs -m crc=1,inobtcount=0 > $seqres.full
+_scratch_xfs_db -c 'version' -c 'sb 0' -c 'p' >> $seqres.full
+_scratch_mount >> $seqres.full
+
+echo moo > $SCRATCH_MNT/urk
+
+_scratch_unmount
+_check_scratch_fs
+
+# Now upgrade to inobtcount support
+_scratch_xfs_admin -O inobtcount >> $seqres.full
+_check_scratch_fs
+_scratch_xfs_db -c 'version' -c 'sb 0' -c 'p' -c 'agi 0' -c 'p' >> $seqres.full
+
+# Mount again, look at our files
+_scratch_mount >> $seqres.full
+cat $SCRATCH_MNT/urk
+
+# success, all done
+echo Silence is golden.
+status=0
+exit
diff --git a/tests/xfs/910.out b/tests/xfs/910.out
new file mode 100644
index 00000000..83992f49
--- /dev/null
+++ b/tests/xfs/910.out
@@ -0,0 +1,3 @@
+QA output created by 910
+moo
+Silence is golden.
diff --git a/tests/xfs/group b/tests/xfs/group
index 8ecdc5ba..b144d391 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -531,4 +531,5 @@
 746 auto quick online_repair
 747 auto quick scrub
 748 auto quick scrub
+910 auto quick inobtcount
 915 auto quick quota

