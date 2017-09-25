Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:53122 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932107AbdIYT42 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Sep 2017 15:56:28 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v8PJqpxk011307
        for <linux-xfs@vger.kernel.org>; Mon, 25 Sep 2017 12:56:26 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2d77rw05f9-2
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Mon, 25 Sep 2017 12:56:26 -0700
From: Richard Wareing <rwareing@fb.com>
Subject: [PATCH v2 3/3] xfs/realtime: Fix direct invocations of xfs_repair
Date: Mon, 25 Sep 2017 12:56:25 -0700
Message-ID: <20170925195625.756877-3-rwareing@fb.com>
In-Reply-To: <20170925195625.756877-1-rwareing@fb.com>
References: <20170925195625.756877-1-rwareing@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, darrick.wong@oracle.com

Fixes direct invocations of xfs_repair to add in -r option if required.

Signed-off-by: Richard Wareing <rwareing@fb.com>
---
Changes since v1:
* Fixed kill -9 in test xfs/070

 tests/xfs/070 | 3 ++-
 tests/xfs/291 | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/tests/xfs/070 b/tests/xfs/070
index 0ae6eff..a06e998 100755
--- a/tests/xfs/070
+++ b/tests/xfs/070
@@ -56,7 +56,8 @@ _cleanup()
 _xfs_repair_noscan()
 {
 	# invoke repair directly so we can kill the process if need be
-	$XFS_REPAIR_PROG $SCRATCH_DEV 2>&1 | tee -a $seqres.full > $tmp.repair &
+	[ -n "$SCRATCH_RTDEV" ] && rt_repair_opts="-r $SCRATCH_RTDEV"
+	$XFS_REPAIR_PROG $rt_repair_opts $SCRATCH_DEV 2>&1 | tee -a $seqres.full > $tmp.repair &
 	repair_pid=$!
 
 	# monitor progress for as long as it is running
diff --git a/tests/xfs/291 b/tests/xfs/291
index 3f5295c..140fa33 100755
--- a/tests/xfs/291
+++ b/tests/xfs/291
@@ -122,7 +122,8 @@ _xfs_check $SCRATCH_DEV >> $seqres.full 2>&1 || _fail "xfs_check failed"
 # Can xfs_metadump cope with this monster?
 _scratch_metadump $tmp.metadump || _fail "xfs_metadump failed"
 xfs_mdrestore $tmp.metadump $tmp.img || _fail "xfs_mdrestore failed"
-xfs_repair -f $tmp.img >> $seqres.full 2>&1 || _fail "xfs_repair of metadump failed"
+[ -n "$SCRATCH_RTDEV" ] && rt_repair_opts="-r $SCRATCH_RTDEV"
+xfs_repair $rt_repair_opts -f $tmp.img >> $seqres.full 2>&1 || _fail "xfs_repair of metadump failed"
 
 # Yes it can; success, all done
 status=0
-- 
2.9.5

