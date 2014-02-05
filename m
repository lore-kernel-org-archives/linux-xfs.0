Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 25C867F51
	for <xfs@oss.sgi.com>; Wed,  5 Feb 2014 02:46:50 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B16DFAC002
	for <xfs@oss.sgi.com>; Wed,  5 Feb 2014 00:46:46 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	lE6TOrAWcCzdPObR for <xfs@oss.sgi.com>;
	Wed, 05 Feb 2014 00:46:44 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1WAy80-0004Uj-RX
	for xfs@oss.sgi.com; Wed, 05 Feb 2014 19:46:40 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1WAy80-0001sH-QI
	for xfs@oss.sgi.com; Wed, 05 Feb 2014 19:46:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs/189: noattr2 invalid for CRC enabled filesystems
Date: Wed,  5 Feb 2014 19:46:40 +1100
Message-Id: <1391590000-7171-1-git-send-email-david@fromorbit.com>
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

Version 5 filesystems always have attr2 format enabled, and it
cannot be turned off via the noattr2 mount option. As such, attempts
to mount with noattr2 will be rejected and this causes cascading
failures within the test.

Hence detect if we've created a CRC enabled filesystem, and if this
is the case _notrun the test.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 tests/xfs/189 | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/tests/xfs/189 b/tests/xfs/189
index 27bfb63..addf7ce 100755
--- a/tests/xfs/189
+++ b/tests/xfs/189
@@ -241,7 +241,16 @@ _require_scratch
 unset SCRATCH_RTDEV
 unset SCRATCH_LOGDEV
 
-_scratch_mkfs_xfs | _filter_mkfs 2>/dev/null
+_scratch_mkfs_xfs | _filter_mkfs 2> $tmp.mkfs
+
+# check to see if we've made a CRC enabled filesystem. If so,
+# we can't run the test because CRc enabled filesystems don't support
+# noattr2 mount options and this will cause cascading failures that are
+# impossible to filter.
+. $tmp.mkfs
+if [ $crc -eq 1 ]; then
+	_notrun "Filesystem CRCs enabled, noattr2 is not supported."
+fi
 
 _add_scratch_fstab
 _test_remount_rw
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
