Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:49962 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753334AbeAKDJE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Jan 2018 22:09:04 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w0B35GAr006130
        for <linux-xfs@vger.kernel.org>; Wed, 10 Jan 2018 19:09:04 -0800
Received: from mail.thefacebook.com ([199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2fduqd8pgy-4
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Wed, 10 Jan 2018 19:09:04 -0800
From: Richard Wareing <rwareing@fb.com>
Subject: [PATCH v3 3/3] xfs/realtime: Fix direct invocations of xfs_repair
Date: Wed, 10 Jan 2018 19:09:01 -0800
Message-ID: <20180111030901.1961285-4-rwareing@fb.com>
In-Reply-To: <20180111030901.1961285-1-rwareing@fb.com>
References: <20180111030901.1961285-1-rwareing@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: darrick.wong@oracle.com, eguan@redhat.com, linux-xfs@vger.kernel.org

Fixes direct invocations of xfs_repair to add in -r option if required.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Richard Wareing <rwareing@fb.com>
---
Changes since v2:
* Added check for USE_EXTERNAL in tests/xfs/291 & tests/xfs/070
* Call xfs_repair via $XFS_REPAIR_PROG

Changes since v1:
* Fixed kill -9 in test xfs/070

 tests/xfs/070 | 5 ++++-
 tests/xfs/291 | 5 ++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/tests/xfs/070 b/tests/xfs/070
index 0ae6eff..0d81977 100755
--- a/tests/xfs/070
+++ b/tests/xfs/070
@@ -56,7 +56,10 @@ _cleanup()
 _xfs_repair_noscan()
 {
 	# invoke repair directly so we can kill the process if need be
-	$XFS_REPAIR_PROG $SCRATCH_DEV 2>&1 | tee -a $seqres.full > $tmp.repair &
+	[ "$USE_EXTERNAL" = yes ] && [ -n "$SCRATCH_RTDEV" ] && \
+    rt_repair_opts="-r $SCRATCH_RTDEV"
+	$XFS_REPAIR_PROG $rt_repair_opts $SCRATCH_DEV 2>&1 |
+    tee -a $seqres.full > $tmp.repair &
 	repair_pid=$!
 
 	# monitor progress for as long as it is running
diff --git a/tests/xfs/291 b/tests/xfs/291
index 3f5295c..3788e62 100755
--- a/tests/xfs/291
+++ b/tests/xfs/291
@@ -122,7 +122,10 @@ _xfs_check $SCRATCH_DEV >> $seqres.full 2>&1 || _fail "xfs_check failed"
 # Can xfs_metadump cope with this monster?
 _scratch_metadump $tmp.metadump || _fail "xfs_metadump failed"
 xfs_mdrestore $tmp.metadump $tmp.img || _fail "xfs_mdrestore failed"
-xfs_repair -f $tmp.img >> $seqres.full 2>&1 || _fail "xfs_repair of metadump failed"
+[ "$USE_EXTERNAL" = yes ] && [ -n "$SCRATCH_RTDEV" ] && \
+  rt_repair_opts="-r $SCRATCH_RTDEV"
+$XFS_REPAIR_PROG $rt_repair_opts -f $tmp.img >> $seqres.full 2>&1 || \
+  _fail "xfs_repair of metadump failed"
 
 # Yes it can; success, all done
 status=0
-- 
2.9.5

