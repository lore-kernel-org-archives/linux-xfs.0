Return-Path: <SRS0=37eZ=4V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DBD9C3F2D1
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Mar 2020 02:46:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EBD6F214DB
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Mar 2020 02:46:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bkIxcFH9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387488AbgCDCqw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Mar 2020 21:46:52 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:45140 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387411AbgCDCqw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Mar 2020 21:46:52 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0242i3v4173337;
        Wed, 4 Mar 2020 02:46:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=RcyaUvtCq+GADJ1rzOCG/+LsXihT3VDLV91QZKovmFs=;
 b=bkIxcFH9wUo4JZkXT0rMukn8SnW3Z1xYFywI0rXG2hZhb10a9DwyEDBDFW/kXyRq7Vhe
 IUCTgjUEQo3CFhs5MdbenQpVDGVaMwMglgW2Gm3ouF7aHXmIFtnk7C7JpOM0yMnJZcBU
 woKMx/WAfA8arbXfNYajHFCtibxZZVe5cZVLdCcNIhbXghlLOA9n10XgjFAfwsSBM3Kj
 oE9AKxT+hBAP04Su+z6qjsD3MBVI5uQkzKamHE5KNQjt1DEWT3YKUumyN1Q6br2ilmjn
 GMbieUOqlBp4oKzoOS2Akl7JAG5ictZ8QNNIYL9INBvxhafT5bCjmlZjHG+Bknz4iLQb mQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2yffwqud18-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Mar 2020 02:46:50 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0242ilgZ137748;
        Wed, 4 Mar 2020 02:46:49 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2yg1eng08v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Mar 2020 02:46:49 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0242kmoY012478;
        Wed, 4 Mar 2020 02:46:48 GMT
Received: from localhost (/10.159.225.108)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Mar 2020 18:46:47 -0800
Subject: [PATCH 3/3] xfs: make sure xfs_db/xfs_quota commands are documented
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Tue, 03 Mar 2020 18:46:47 -0800
Message-ID: <158329000698.2374922.9344618703224232004.stgit@magnolia>
In-Reply-To: <158328998787.2374922.4223951558305234252.stgit@magnolia>
References: <158328998787.2374922.4223951558305234252.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9549 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003040019
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9549 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 suspectscore=0
 phishscore=0 clxscore=1015 bulkscore=0 adultscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003040019
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Make sure all the xfs_db/xfs_quota commands are documented.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/754     |   57 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/754.out |    2 ++
 tests/xfs/755     |   53 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/755.out |    2 ++
 tests/xfs/group   |    2 ++
 5 files changed, 116 insertions(+)
 create mode 100755 tests/xfs/754
 create mode 100644 tests/xfs/754.out
 create mode 100755 tests/xfs/755
 create mode 100644 tests/xfs/755.out


diff --git a/tests/xfs/754 b/tests/xfs/754
new file mode 100755
index 00000000..ba0885be
--- /dev/null
+++ b/tests/xfs/754
@@ -0,0 +1,57 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-newer
+# Copyright (c) 2020, Oracle and/or its affiliates.  All Rights Reserved.
+#
+# FS QA Test No. 754
+#
+# Ensure all xfs_db commands are documented.
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
+	rm -f $tmp.* $file
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+
+# real QA test starts here
+_supported_fs xfs
+_supported_os Linux
+_require_command "$XFS_DB_PROG" "xfs_db"
+_require_command "$MAN_PROG" man
+_require_test
+
+echo "Silence is golden"
+
+MANPAGE=$($MAN_PROG --path xfs_db)
+
+case "$MANPAGE" in
+*.gz|*.z\|*.Z)	CAT=zcat;;
+*.bz2)		CAT=bzcat;;
+*.xz)		CAT=xzcat;;
+*)		CAT=cat;;
+esac
+_require_command `which $CAT` $CAT
+
+file=$TEST_DIR/xx.$seq
+truncate -s 128m $file
+$MKFS_XFS_PROG $file >> /dev/null
+
+for COMMAND in `$XFS_DB_PROG -x -c help $file | awk '{print $1}' | grep -v "^Use"`; do
+  $CAT "$MANPAGE" | egrep -q "^\.B.*$COMMAND" || \
+	echo "$COMMAND not documented in the xfs_db manpage"
+done
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/754.out b/tests/xfs/754.out
new file mode 100644
index 00000000..9e7cda82
--- /dev/null
+++ b/tests/xfs/754.out
@@ -0,0 +1,2 @@
+QA output created by 754
+Silence is golden
diff --git a/tests/xfs/755 b/tests/xfs/755
new file mode 100755
index 00000000..0e5d85ab
--- /dev/null
+++ b/tests/xfs/755
@@ -0,0 +1,53 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-newer
+# Copyright (c) 2020, Oracle and/or its affiliates.  All Rights Reserved.
+#
+# FS QA Test No. 755
+#
+# Ensure all xfs_quota commands are documented.
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
+	rm -f $tmp.* $file
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+
+# real QA test starts here
+_supported_fs xfs
+_supported_os Linux
+_require_command "$XFS_QUOTA_PROG" "xfs_quota"
+_require_command "$MAN_PROG" man
+_require_test
+
+echo "Silence is golden"
+
+MANPAGE=$($MAN_PROG --path xfs_quota)
+
+case "$MANPAGE" in
+*.gz|*.z\|*.Z)	CAT=zcat;;
+*.bz2)		CAT=bzcat;;
+*.xz)		CAT=xzcat;;
+*)		CAT=cat;;
+esac
+_require_command `which $CAT` $CAT
+
+for COMMAND in `$XFS_QUOTA_PROG -x -c help $file | awk '{print $1}' | grep -v "^Use"`; do
+  $CAT "$MANPAGE" | egrep -q "^\.B.*$COMMAND" || \
+	echo "$COMMAND not documented in the xfs_quota manpage"
+done
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/755.out b/tests/xfs/755.out
new file mode 100644
index 00000000..7c9ea51c
--- /dev/null
+++ b/tests/xfs/755.out
@@ -0,0 +1,2 @@
+QA output created by 755
+Silence is golden
diff --git a/tests/xfs/group b/tests/xfs/group
index 522d4bc4..aadbb971 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -511,3 +511,5 @@
 511 auto quick quota
 512 auto quick acl attr
 513 auto mount
+754 auto quick db
+755 auto quick quota

