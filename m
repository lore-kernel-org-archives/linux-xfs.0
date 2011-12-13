Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBD0hOPB130057 for <xfs@oss.sgi.com>; Mon, 12 Dec 2011 18:43:24 -0600
Received: from fgwmail6.fujitsu.co.jp (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C26F91EAA436
	for <xfs@oss.sgi.com>; Mon, 12 Dec 2011 16:42:57 -0800 (PST)
Received: from fgwmail6.fujitsu.co.jp (fgwmail6.fujitsu.co.jp [192.51.44.36])
	by cuda.sgi.com with ESMTP id nwxNoKJ2nyB8Epnb for
	<xfs@oss.sgi.com>; Mon, 12 Dec 2011 16:42:57 -0800 (PST)
Received: from m1.gw.fujitsu.co.jp (unknown [10.0.50.71])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 6F95D3EE0B5
	for <xfs@oss.sgi.com>; Tue, 13 Dec 2011 09:42:55 +0900 (JST)
Received: from smail (m1 [127.0.0.1])
	by outgoing.m1.gw.fujitsu.co.jp (Postfix) with ESMTP id 55F2245DE60
	for <xfs@oss.sgi.com>; Tue, 13 Dec 2011 09:42:55 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (s1.gw.fujitsu.co.jp [10.0.50.91])
	by m1.gw.fujitsu.co.jp (Postfix) with ESMTP id 3540245DE69
	for <xfs@oss.sgi.com>; Tue, 13 Dec 2011 09:42:55 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id 26E0C1DB804A
	for <xfs@oss.sgi.com>; Tue, 13 Dec 2011 09:42:55 +0900 (JST)
Received: from m000.s.css.fujitsu.com (m000.s.css.fujitsu.com [10.23.4.38])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id D7C371DB8048
	for <xfs@oss.sgi.com>; Tue, 13 Dec 2011 09:42:54 +0900 (JST)
Date: Tue, 13 Dec 2011 09:42:46 +0900
From: Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>
Subject: [PATCH] update 068 to reproduce an unfreeze hanging up problem
Message-Id: <20111213094245.4004.61FB500B@jp.fujitsu.com>
MIME-Version: 1.0
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

update 068 to reproduce an unfreeze hanging up problem which is unfreeze
function, thaw_super(), sometimes hangs up if flush kernel thread does
writeback to the same filesystem concurrently.
The problem occurs on ext4 and ext3. They are reported at
ext4:
http://marc.info/?l=linux-ext4&m=132339590004560&w=2
ext3:
http://marc.info/?l=linux-ext4&m=131536612113658&w=2

This test runs freeze/unfreeze under heavy load. If the problem is
reproduced, this test will hang up because "xfs_freeze -u" hangs up...

Signed-off-by: Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>
---
 068     |   17 +++----
 068.out |  160 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 167 insertions(+), 10 deletions(-)

diff --git a/068 b/068
index 5d0053d..3b3597d 100755
--- a/068
+++ b/068
@@ -32,7 +32,7 @@ here=`pwd`
 tmp=/tmp/$$
 status=0	# success is the default!
 
-ITERATIONS=10
+ITERATIONS=50
 
 _cleanup()
 {
@@ -51,7 +51,7 @@ trap "_cleanup" 0 1 2 3 15
 . ./common.filter
 
 # real QA test starts here
-_supported_fs xfs
+_supported_fs ext3 ext4 xfs
 _supported_os Linux IRIX
 
 _require_scratch
@@ -62,7 +62,7 @@ rm -f $seq.full
 umount $SCRATCH_DEV >/dev/null 2>&1
 echo "*** MKFS ***"                         >>$seq.full
 echo ""                                     >>$seq.full
-_scratch_mkfs_xfs                           >>$seq.full 2>&1 \
+_scratch_mkfs                               >>$seq.full 2>&1 \
     || _fail "mkfs failed"
 _scratch_mount                              >>$seq.full 2>&1 \
     || _fail "mount failed"
@@ -75,12 +75,11 @@ touch $tmp.running
     STRESS_DIR="$SCRATCH_MNT/fsstress_test_dir"
     mkdir "$STRESS_DIR"
 
-    procs=2
-    nops=200
+    procs=100
+    nops=1000
     while [ -f "$tmp.running" ]
-      do
-      #	-w ensures that the only ops are ones which cause write I/O
-      $FSSTRESS_PROG -d $STRESS_DIR -w -p $procs -n $nops $FSSTRESS_AVOID \
+    do
+      $FSSTRESS_PROG -d $STRESS_DIR -p $procs -n $nops $FSSTRESS_AVOID \
 	  > /dev/null 2>&1
     done
 
@@ -99,13 +98,11 @@ do
 	xfs_freeze -f "$SCRATCH_MNT" | tee -a $seq.full
 	[ $? != 0 ] && echo xfs_freeze -f "$SCRATCH_MNT" failed | \
 	    tee -a $seq.full
-	sleep 2
 
 	echo "*** thawing  \$SCRATCH_MNT" | tee -a $seq.full
 	xfs_freeze -u "$SCRATCH_MNT" | tee -a $seq.full
 	[ $? != 0 ] && echo xfs_freeze -u "$SCRATCH_MNT" failed | \
 	    tee -a $seq.full
-	sleep 2
 
 	echo  | tee -a $seq.full
 	let i=$i+1
diff --git a/068.out b/068.out
index 363d0e9..11eb58d 100644
--- a/068.out
+++ b/068.out
@@ -41,3 +41,163 @@ QA output created by 068
 *** freezing $SCRATCH_MNT
 *** thawing  $SCRATCH_MNT
 
+*** iteration: 10
+*** freezing $SCRATCH_MNT
+*** thawing  $SCRATCH_MNT
+
+*** iteration: 11
+*** freezing $SCRATCH_MNT
+*** thawing  $SCRATCH_MNT
+
+*** iteration: 12
+*** freezing $SCRATCH_MNT
+*** thawing  $SCRATCH_MNT
+
+*** iteration: 13
+*** freezing $SCRATCH_MNT
+*** thawing  $SCRATCH_MNT
+
+*** iteration: 14
+*** freezing $SCRATCH_MNT
+*** thawing  $SCRATCH_MNT
+
+*** iteration: 15
+*** freezing $SCRATCH_MNT
+*** thawing  $SCRATCH_MNT
+
+*** iteration: 16
+*** freezing $SCRATCH_MNT
+*** thawing  $SCRATCH_MNT
+
+*** iteration: 17
+*** freezing $SCRATCH_MNT
+*** thawing  $SCRATCH_MNT
+
+*** iteration: 18
+*** freezing $SCRATCH_MNT
+*** thawing  $SCRATCH_MNT
+
+*** iteration: 19
+*** freezing $SCRATCH_MNT
+*** thawing  $SCRATCH_MNT
+
+*** iteration: 20
+*** freezing $SCRATCH_MNT
+*** thawing  $SCRATCH_MNT
+
+*** iteration: 21
+*** freezing $SCRATCH_MNT
+*** thawing  $SCRATCH_MNT
+
+*** iteration: 22
+*** freezing $SCRATCH_MNT
+*** thawing  $SCRATCH_MNT
+
+*** iteration: 23
+*** freezing $SCRATCH_MNT
+*** thawing  $SCRATCH_MNT
+
+*** iteration: 24
+*** freezing $SCRATCH_MNT
+*** thawing  $SCRATCH_MNT
+
+*** iteration: 25
+*** freezing $SCRATCH_MNT
+*** thawing  $SCRATCH_MNT
+
+*** iteration: 26
+*** freezing $SCRATCH_MNT
+*** thawing  $SCRATCH_MNT
+
+*** iteration: 27
+*** freezing $SCRATCH_MNT
+*** thawing  $SCRATCH_MNT
+
+*** iteration: 28
+*** freezing $SCRATCH_MNT
+*** thawing  $SCRATCH_MNT
+
+*** iteration: 29
+*** freezing $SCRATCH_MNT
+*** thawing  $SCRATCH_MNT
+
+*** iteration: 30
+*** freezing $SCRATCH_MNT
+*** thawing  $SCRATCH_MNT
+
+*** iteration: 31
+*** freezing $SCRATCH_MNT
+*** thawing  $SCRATCH_MNT
+
+*** iteration: 32
+*** freezing $SCRATCH_MNT
+*** thawing  $SCRATCH_MNT
+
+*** iteration: 33
+*** freezing $SCRATCH_MNT
+*** thawing  $SCRATCH_MNT
+
+*** iteration: 34
+*** freezing $SCRATCH_MNT
+*** thawing  $SCRATCH_MNT
+
+*** iteration: 35
+*** freezing $SCRATCH_MNT
+*** thawing  $SCRATCH_MNT
+
+*** iteration: 36
+*** freezing $SCRATCH_MNT
+*** thawing  $SCRATCH_MNT
+
+*** iteration: 37
+*** freezing $SCRATCH_MNT
+*** thawing  $SCRATCH_MNT
+
+*** iteration: 38
+*** freezing $SCRATCH_MNT
+*** thawing  $SCRATCH_MNT
+
+*** iteration: 39
+*** freezing $SCRATCH_MNT
+*** thawing  $SCRATCH_MNT
+
+*** iteration: 40
+*** freezing $SCRATCH_MNT
+*** thawing  $SCRATCH_MNT
+
+*** iteration: 41
+*** freezing $SCRATCH_MNT
+*** thawing  $SCRATCH_MNT
+
+*** iteration: 42
+*** freezing $SCRATCH_MNT
+*** thawing  $SCRATCH_MNT
+
+*** iteration: 43
+*** freezing $SCRATCH_MNT
+*** thawing  $SCRATCH_MNT
+
+*** iteration: 44
+*** freezing $SCRATCH_MNT
+*** thawing  $SCRATCH_MNT
+
+*** iteration: 45
+*** freezing $SCRATCH_MNT
+*** thawing  $SCRATCH_MNT
+
+*** iteration: 46
+*** freezing $SCRATCH_MNT
+*** thawing  $SCRATCH_MNT
+
+*** iteration: 47
+*** freezing $SCRATCH_MNT
+*** thawing  $SCRATCH_MNT
+
+*** iteration: 48
+*** freezing $SCRATCH_MNT
+*** thawing  $SCRATCH_MNT
+
+*** iteration: 49
+*** freezing $SCRATCH_MNT
+*** thawing  $SCRATCH_MNT
+
-- 
1.7.1

Thanks,
Masayoshi Mizuma


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
