Return-Path: <SRS0=GxFA=6H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71F73C55186
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Apr 2020 23:32:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4FE9920736
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Apr 2020 23:32:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lNCz9QCV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726431AbgDWXcG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Apr 2020 19:32:06 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:44298 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726071AbgDWXcG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Apr 2020 19:32:06 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03NNSX7g110736;
        Thu, 23 Apr 2020 23:32:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=mCARlnDWl2MkvgEJ0RrRVAwzMNudjqv78FadlNPlLFg=;
 b=lNCz9QCVHyJpFT0tWSYf7fcWEhhUw9/QDxM39xm8Er4me/V76mMzaFrItKT9TPEXl5hc
 kpEzrahEhkPJrnC2fNHb+SiyuUFzA0CiMVxYGqXa8JBUTUbzFLpehDc6tzJWGsq4LB8K
 gTsFk6h6K5gCtPpDfcBR3Wq5ymZ89kn8GA9HJKtfdbjQB7nuupS61y2iAqViae8berVy
 NhsRjO2JGl3bcPNa8KFJFOFygD63AVWNXuopqqOU37fCD9T0+X1lz1IvuyX8QGrwojyT
 4k52MXP3Q5dsBbwxQvt+ytROY9OmKdByuqsPbOhUjdj4u3ZFbFTB3jr9Sh5jIxQtnNYl bg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 30jvq4xbqu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Apr 2020 23:32:04 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03NNViC3163984;
        Thu, 23 Apr 2020 23:32:04 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 30gb3westy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Apr 2020 23:32:04 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03NNW436003426;
        Thu, 23 Apr 2020 23:32:04 GMT
Received: from localhost (/10.159.232.248)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 23 Apr 2020 16:32:03 -0700
Subject: [PATCH 2/4] xfs: race freeze and fsmap for a while to see if we
 livelock
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Thu, 23 Apr 2020 16:32:02 -0700
Message-ID: <158768472236.3019475.7921951820050889421.stgit@magnolia>
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 mlxscore=0 adultscore=0 mlxlogscore=999 phishscore=0 impostorscore=0
 clxscore=1015 bulkscore=0 spamscore=0 priorityscore=1501 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004230168
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Run fsfreeze and fsmap against each other in a loop to see if we observe
any livelocks, crashes, or odd slowness from either operation.  This is
a regression test for 27fb5a72f50aa77 ("xfs: prohibit fs freezing when
using empty transactions").

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/755     |  108 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/755.out |    4 ++
 tests/xfs/group   |    1 
 3 files changed, 113 insertions(+)
 create mode 100755 tests/xfs/755
 create mode 100644 tests/xfs/755.out


diff --git a/tests/xfs/755 b/tests/xfs/755
new file mode 100755
index 00000000..56ad3485
--- /dev/null
+++ b/tests/xfs/755
@@ -0,0 +1,108 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2020 Oracle, Inc.  All Rights Reserved.
+#
+# FS QA Test No. 755
+#
+# Race freeze and fsmap for a while to see if we crash or livelock.
+#
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	$XFS_IO_PROG -x -c 'thaw' $SCRATCH_MNT > /dev/null 2>&1
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/fuzzy
+. ./common/inject
+. ./common/xfs
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_xfs_scratch_rmapbt
+_require_xfs_io_command "fsmap"
+_require_command "$KILLALL_PROG" killall
+
+echo "Format and populate"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+
+STRESS_DIR="$SCRATCH_MNT/testdir"
+mkdir -p $STRESS_DIR
+
+for i in $(seq 0 9); do
+	mkdir -p $STRESS_DIR/$i
+	for j in $(seq 0 9); do
+		mkdir -p $STRESS_DIR/$i/$j
+		for k in $(seq 0 9); do
+			echo x > $STRESS_DIR/$i/$j/$k
+		done
+	done
+done
+
+cpus=$(( $(src/feature -o) * 4 * LOAD_FACTOR))
+
+echo "Concurrent fsmap and freeze"
+filter_output() {
+	egrep -v '(Device or resource busy|Invalid argument)'
+}
+freeze_loop() {
+	end="$1"
+
+	while [ "$(date +%s)" -lt $end ]; do
+		$XFS_IO_PROG -x -c 'freeze' $SCRATCH_MNT 2>&1 | filter_output
+		$XFS_IO_PROG -x -c 'thaw' $SCRATCH_MNT 2>&1 | filter_output
+	done
+}
+fsmap_loop() {
+	end="$1"
+
+	while [ "$(date +%s)" -lt $end ]; do
+		$XFS_IO_PROG -c 'fsmap -v' $SCRATCH_MNT > /dev/null
+	done
+}
+stress_loop() {
+	end="$1"
+
+	FSSTRESS_ARGS=$(_scale_fsstress_args -p 4 -d $SCRATCH_MNT -n 2000 $FSSTRESS_AVOID)
+	while [ "$(date +%s)" -lt $end ]; do
+		$FSSTRESS_PROG $FSSTRESS_ARGS >> $seqres.full
+	done
+}
+
+start=$(date +%s)
+end=$((start + (30 * TIME_FACTOR) ))
+
+echo "Loop started at $(date --date="@${start}"), ending at $(date --date="@${end}")" >> $seqres.full
+stress_loop $end &
+freeze_loop $end &
+fsmap_loop $end &
+
+# Wait until 2 seconds after the loops should have finished...
+while [ "$(date +%s)" -lt $((end + 2)) ]; do
+	sleep 1
+done
+
+# ...and clean up after the loops in case they didn't do it themselves.
+$KILLALL_PROG -TERM xfs_io fsstress >> $seqres.full 2>&1
+$XFS_IO_PROG -x -c 'thaw' $SCRATCH_MNT >> $seqres.full 2>&1
+
+echo "Loop finished at $(date)" >> $seqres.full
+echo "Test done"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/755.out b/tests/xfs/755.out
new file mode 100644
index 00000000..cf681c86
--- /dev/null
+++ b/tests/xfs/755.out
@@ -0,0 +1,4 @@
+QA output created by 755
+Format and populate
+Concurrent fsmap and freeze
+Test done
diff --git a/tests/xfs/group b/tests/xfs/group
index d39daf00..b0e4816f 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -513,4 +513,5 @@
 513 auto mount
 514 auto quick db
 515 auto quick quota
+755 auto quick fsmap freeze
 914 auto quick reflink

