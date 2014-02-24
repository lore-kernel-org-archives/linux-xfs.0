Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A6EE77F37
	for <xfs@oss.sgi.com>; Sun, 23 Feb 2014 21:06:28 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 95E868F8033
	for <xfs@oss.sgi.com>; Sun, 23 Feb 2014 19:06:28 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	BS1gJmGeX4FYKQW0 for <xfs@oss.sgi.com>;
	Sun, 23 Feb 2014 19:06:27 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WHls1-0004Pw-HZ
	for xfs@oss.sgi.com; Mon, 24 Feb 2014 14:06:17 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1WHls1-0007pI-Gc
	for xfs@oss.sgi.com; Mon, 24 Feb 2014 14:06:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 6/6] xfs/167: need at least 10GB of scratch space to run
Date: Mon, 24 Feb 2014 14:06:15 +1100
Message-Id: <1393211175-30016-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1393211175-30016-1-git-send-email-david@fromorbit.com>
References: <1393211175-30016-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

When running on a ramdisk, the fsstress background workload consumes
a GB of disk space every 5 seconds. This leads to the test failing
with ENOSPC because the test file cannot be created due otthe
background load cosuming it all. Hence don't run this test unless
the scratch device is large enough not to hit ENOSPC conditions.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 tests/xfs/167 | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tests/xfs/167 b/tests/xfs/167
index ab0156f..875bd31 100755
--- a/tests/xfs/167
+++ b/tests/xfs/167
@@ -62,6 +62,12 @@ _require_scratch
 _scratch_mkfs_xfs >/dev/null 2>&1
 _scratch_mount
 
+# fast devices can consume disk space at a rate of 1GB every 5s via the
+# background workload. With 50 test loops, at 1 second per loop, that means we
+# need at least 10GB of disk space to ensure this test will not fail with ENOSPC
+# errors.
+_require_fs_space $SCRATCH_MNT 10485760
+
 TEST_FILE=$SCRATCH_MNT/test_file
 TEST_PROG=$here/src/unwritten_sync
 LOOPS=50
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
