Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:35372 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932245AbeBGVTh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Feb 2018 16:19:37 -0500
Subject: [PATCH 2/4] xfs: skip xfs_check in _check_xfs_filesystem
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 07 Feb 2018 13:19:31 -0800
Message-ID: <151803837117.19313.3481001926133028039.stgit@magnolia>
In-Reply-To: <151803835881.19313.17455678207236452557.stgit@magnolia>
References: <151803835881.19313.17455678207236452557.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

xfs_check has been long obsolete, so stop running it automatically
after every test.  Tests that explicitly want xfs_check can call it
via _scratch_xfs_check or _xfs_check; that part doesn't go away.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/xfs |   17 -----------------
 1 file changed, 17 deletions(-)


diff --git a/common/xfs b/common/xfs
index 3dba40d..c63e5dc 100644
--- a/common/xfs
+++ b/common/xfs
@@ -386,23 +386,6 @@ _check_xfs_filesystem()
 		ok=0
 	fi
 
-	# xfs_check runs out of memory on large files, so even providing the test
-	# option (-t) to avoid indexing the free space trees doesn't make it pass on
-	# large filesystems. Avoid it.
-	if [ "$LARGE_SCRATCH_DEV" != yes ]; then
-		_xfs_check $extra_log_options $device 2>&1 |\
-			_fix_malloc >$tmp.fs_check
-	fi
-	if [ -s $tmp.fs_check ]; then
-		_log_err "_check_xfs_filesystem: filesystem on $device is inconsistent (c)"
-		echo "*** xfs_check output ***"		>>$seqres.full
-		cat $tmp.fs_check			>>$seqres.full
-		echo "*** end xfs_check output"		>>$seqres.full
-
-		xfs_metadump $device $seqres.check	>>$seqres.full 2>&1
-		ok=0
-	fi
-
 	$XFS_REPAIR_PROG -n $extra_options $extra_log_options $extra_rt_options $device >$tmp.repair 2>&1
 	if [ $? -ne 0 ]; then
 		_log_err "_check_xfs_filesystem: filesystem on $device is inconsistent (r)"

