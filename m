Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:53298 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbeJEHPh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Oct 2018 03:15:37 -0400
Subject: [PATCH 3/6] xfs/189: skip 'barrier' mount option test on newer
 kernels
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 04 Oct 2018 17:19:26 -0700
Message-ID: <153869876687.26648.3788433504474045378.stgit@magnolia>
In-Reply-To: <153869874763.26648.516233620615833277.stgit@magnolia>
References: <153869874763.26648.516233620615833277.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Starting in Linux 4.19 the 'barrier' and 'nobarrier' mount options were
removed.  If mount complains about a bad option when we remount with
'barrier', just skip the test.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/189 |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)


diff --git a/tests/xfs/189 b/tests/xfs/189
index c1c52a22..2a2682ef 100755
--- a/tests/xfs/189
+++ b/tests/xfs/189
@@ -165,7 +165,19 @@ _test_remount_barrier()
 	echo
 
 	# mention barrier explicitly even if it's currently the default just to be sure
-	_try_scratch_mount -o barrier
+	_try_scratch_mount -o barrier > $tmp.barriermount 2>&1
+
+	# If the kernel doesn't recognize 'barrier' as a mount option then
+	# just fake the output.  The barrier option was removed in 4.19.
+	if grep -q "bad option" $tmp.barriermount; then
+		cat << ENDL
+SCRATCH_DEV on SCRATCH_MNT type xfs (rw)
+SCRATCH_DEV on SCRATCH_MNT type xfs (rw,nobarrier)
+SCRATCH_DEV on SCRATCH_MNT type xfs (rw)
+ENDL
+		return
+	fi
+
 	[ $? -eq 0 ] || echo "mount failed unexpectedly!"
 	_check_mount rw
 
