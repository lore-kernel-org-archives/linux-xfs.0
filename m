Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAA08N4q008856 for <xfs@oss.sgi.com>; Wed, 9 Nov 2011 18:08:23 -0600
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4A25810416CD
	for <xfs@oss.sgi.com>; Wed,  9 Nov 2011 16:08:21 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	1MMgrBPCfl1Yq7jY for <xfs@oss.sgi.com>;
	Wed, 09 Nov 2011 16:08:21 -0800 (PST)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1ROIBn-0000mn-2V
	for xfs@oss.sgi.com; Thu, 10 Nov 2011 11:08:19 +1100
Received: from dave by disappointment with local (Exim 4.76)
	(envelope-from <dave@disappointment.disaster>) id 1ROIBm-0000rO-Pt
	for xfs@oss.sgi.com; Thu, 10 Nov 2011 11:08:18 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfstests: fix logging on test 205
Date: Thu, 10 Nov 2011 11:08:18 +1100
Message-Id: <1320883698-3262-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Make the logging of operations in test 205 to the 205.full file work
correctly. This prevents the overwrite of mkfs status, and leaves
the 205.full file around for later analysis even on successful test
runs.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 205 |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/205 b/205
index 35d6992..bd916a1 100755
--- a/205
+++ b/205
@@ -40,12 +40,14 @@ _supported_os Linux
 
 _require_scratch
 
-_scratch_mkfs_xfs -d size=16m -b size=512 >/dev/null
+rm -f $seq.full
+
+_scratch_mkfs_xfs -d size=16m -b size=512 >> $seq.full 2>&1
 _scratch_mount
 
 # fix the reserve block pool to a known size so that the enospc calculations
 # work out correctly.
-_scratch_resvblks 1024 > $seq.full 2>&1
+_scratch_resvblks 1024 >> $seq.full 2>&1
 
 # on a 16MB filesystem, there's 32768x512byte blocks. used is:
 #	- 4944 in the log,
@@ -79,5 +81,4 @@ dd if=/dev/zero of=$SCRATCH_MNT/fred bs=15 count=$[26745/15*512] 2>&1 | _filter_
 
 # success, all done
 echo "*** done"
-rm -f $seq.full
 status=0
-- 
1.7.5.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
