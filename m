Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3LKPcTo151234 for <xfs@oss.sgi.com>; Tue, 21 Apr 2009 15:25:38 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4C26D1CD8D94
	for <xfs@oss.sgi.com>; Tue, 21 Apr 2009 13:25:33 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id EML6Wyx01iR0nKac for <xfs@oss.sgi.com>;
	Tue, 21 Apr 2009 13:25:33 -0700 (PDT)
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n3LKPXJk016708
	for <xfs@oss.sgi.com>; Tue, 21 Apr 2009 16:25:33 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n3LKPWrm016807
	for <xfs@oss.sgi.com>; Tue, 21 Apr 2009 16:25:32 -0400
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n3LKPVrJ018520
	for <xfs@oss.sgi.com>; Tue, 21 Apr 2009 16:25:32 -0400
Message-ID: <49EE2BBB.3070008@sandeen.net>
Date: Tue, 21 Apr 2009 15:25:31 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfstests: fix up features2 tests for lazy-count=1
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs mailing list <xfs@oss.sgi.com>

A few more tests are unhappy with a lazy-count=1 change;
specify lazy-count=0 in them for these tests.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/186 b/186
index e8706e4..3e487ab 100755
--- a/186
+++ b/186
@@ -135,7 +135,7 @@ _supported_os Linux
 _require_scratch
 rm -f $seq.full
 
-_scratch_mkfs -i attr=2,size=512 >/dev/null 2>&1
+_scratch_mkfs -i attr=2,size=512 -l lazy-count=0 >/dev/null 2>&1
 
 # set inum to root dir ino
 # we'll add in dirents and EAs into the root directory
diff --git a/187 b/187
index 4e79055..8ae3ef9 100755
--- a/187
+++ b/187
@@ -54,7 +54,7 @@ export MOUNT_OPTIONS=""
 # Make sure that when we think we are testing with morebits off
 # that we really are.
 # Trying to future-proof in case mkfs defaults change.
-_scratch_mkfs -i attr=1 >/dev/null 2>&1
+_scratch_mkfs -i attr=1 -l lazy-count=0 >/dev/null 2>&1
 $XFS_DB_PROG -c version $SCRATCH_DEV 2>&1 >$tmp.db
 if grep -i morebits $tmp.db
 then
diff --git a/199 b/199
index 099cc1c..c7dcbdd 100644
--- a/199
+++ b/199
@@ -35,7 +35,7 @@ _supported_os Linux
 
 _require_scratch
 
-_scratch_mkfs_xfs >/dev/null 2>&1
+_scratch_mkfs_xfs -l lazy-count=0>/dev/null 2>&1
 
 #
 # Print the current flags.  Just a dummy so that the test breaks

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
