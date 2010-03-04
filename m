Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o241kHfG126619 for <xfs@oss.sgi.com>; Wed, 3 Mar 2010 19:46:17 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BF025216C7A
	for <xfs@oss.sgi.com>; Wed,  3 Mar 2010 17:47:44 -0800 (PST)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	hFJTI03RUYFPS7fV for <xfs@oss.sgi.com>;
	Wed, 03 Mar 2010 17:47:44 -0800 (PST)
Received: from discord (unverified [121.44.103.80])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	15786675-1927428
	for <xfs@oss.sgi.com>; Thu, 04 Mar 2010 12:17:43 +1030 (CDT)
Received: from disturbed ([192.168.1.9]) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1Nn0AA-0004an-6z
	for xfs@oss.sgi.com; Thu, 04 Mar 2010 12:47:42 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1Nn0A2-000256-IC
	for xfs@oss.sgi.com; Thu, 04 Mar 2010 12:47:34 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfsqa: define resblks for tests near ENOSPC
Date: Thu,  4 Mar 2010 12:47:34 +1100
Message-Id: <1267667254-7971-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Several tests assume a certain amount of disk space free after the
reserve block pool is filled. Changing the default size of the
reserve block pool breaks these tests because there is less space
available that first thought.

Change these tests to specify a known reserve block pool size of
1024 blocks to ensure that they continue to work correctly even if
the default size changes.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 104 |    4 ++++
 204 |    4 ++++
 205 |    4 ++++
 3 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/104 b/104
index b35c43b..c119822 100755
--- a/104
+++ b/104
@@ -48,6 +48,10 @@ _create_scratch()
 		echo "failed to mount $SCRATCH_DEV"
 		exit 1
 	fi
+
+	# fix the reserve block pool to a known size so that the enospc
+	# calculations work out correctly.
+	xfs_io -x -c "resblks 1024" $SCRATCH_MNT > /dev/null 2>&1
 }
 
 _fill_scratch()
diff --git a/204 b/204
index 8b94f60..3abe794 100755
--- a/204
+++ b/204
@@ -44,6 +44,10 @@ SIZE=`expr 104 \* 1024 \* 1024`
 _scratch_mkfs_sized $SIZE  &> /dev/null
 _scratch_mount
 
+# fix the reserve block pool to a known size so that the enospc calculations
+# work out correctly.
+xfs_io -x -c "resblks 1024" $SCRATCH_MNT >> $seq.full 2>&1
+
 for i in `seq 1 22500`; do
     echo -n > $SCRATCH_MNT/$i
     echo XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX > $SCRATCH_MNT/$i
diff --git a/205 b/205
index 3f45185..5487ea4 100755
--- a/205
+++ b/205
@@ -43,6 +43,10 @@ _require_scratch
 _scratch_mkfs_xfs -d size=16m -b size=512 >/dev/null
 _scratch_mount
 
+# fix the reserve block pool to a known size so that the enospc calculations
+# work out correctly.
+xfs_io -x -c "resblks 1024" $SCRATCH_MNT >> $seq.full 2>&1
+
 # on a 16MB filesystem, there's 32768x512byte blocks. used is:
 #	- 4944 in the log,
 #	- 32+1 for the root inode cluster
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
