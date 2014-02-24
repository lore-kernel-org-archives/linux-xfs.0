Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B18C27F5A
	for <xfs@oss.sgi.com>; Sun, 23 Feb 2014 21:06:30 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9128F304043
	for <xfs@oss.sgi.com>; Sun, 23 Feb 2014 19:06:27 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	k9qKuDin7fHRY5NA for <xfs@oss.sgi.com>;
	Sun, 23 Feb 2014 19:06:22 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WHls1-0004Ps-FA
	for xfs@oss.sgi.com; Mon, 24 Feb 2014 14:06:17 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1WHls1-0007oy-EC
	for xfs@oss.sgi.com; Mon, 24 Feb 2014 14:06:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/6] xfs/189: noattr2 invalid for CRC enabled filesystems
Date: Mon, 24 Feb 2014 14:06:11 +1100
Message-Id: <1393211175-30016-3-git-send-email-david@fromorbit.com>
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

Version 5 filesystems always have attr2 format enabled, and it
cannot be turned off via the noattr2 mount option. As such, attempts
to mount with noattr2 will be rejected and this causes cascading
failures within the test.

Hence detect if we've created a CRC enabled filesystem, and if this
is the case _notrun the test.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 common/attr   | 10 ++++++++++
 tests/xfs/189 |  2 ++
 2 files changed, 12 insertions(+)

diff --git a/common/attr b/common/attr
index 1f3e57f..83bf9d1 100644
--- a/common/attr
+++ b/common/attr
@@ -196,6 +196,16 @@ _require_attr_v1()
 		|| _notrun "attr v1 not supported on $SCRATCH_DEV"
 }
 
+# check if we support the noattr2 mount option
+_require_noattr2()
+{
+	_scratch_mkfs_xfs > /dev/null 2>&1 \
+		|| _fail "_scratch_mkfs_xfs failed on $SCRATCH_DEV"
+	_mount -o noattr2 $SCRATCH_DEV > /dev/null 2>&1 \
+		|| _notrun "noattr2 mount option not supported on $SCRATCH_DEV"
+	_scratch_unmount
+}
+
 # getfattr -R returns info in readdir order which varies from fs to fs.
 # This sorts the output by filename
 _sort_getfattr_output()
diff --git a/tests/xfs/189 b/tests/xfs/189
index 27bfb63..a56bbde 100755
--- a/tests/xfs/189
+++ b/tests/xfs/189
@@ -230,6 +230,7 @@ _putback_scratch_fstab()
 # get standard environment, filters and checks
 . ./common/rc
 . ./common/filter
+. ./common/attr
 
 # real QA test starts here
 _supported_fs xfs
@@ -237,6 +238,7 @@ _supported_os Linux
 
 _need_to_be_root
 _require_scratch
+_require_noattr2
 
 unset SCRATCH_RTDEV
 unset SCRATCH_LOGDEV
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
