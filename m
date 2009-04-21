Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3LKDa1I150596 for <xfs@oss.sgi.com>; Tue, 21 Apr 2009 15:13:36 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F0C3A22DB43
	for <xfs@oss.sgi.com>; Tue, 21 Apr 2009 13:13:32 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id wMj6pLJfyjARZl5f for <xfs@oss.sgi.com>;
	Tue, 21 Apr 2009 13:13:32 -0700 (PDT)
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n3LKDVSY013793
	for <xfs@oss.sgi.com>; Tue, 21 Apr 2009 16:13:31 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n3LKDVOW013593
	for <xfs@oss.sgi.com>; Tue, 21 Apr 2009 16:13:31 -0400
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n3LKDUsq016447
	for <xfs@oss.sgi.com>; Tue, 21 Apr 2009 16:13:30 -0400
Message-ID: <49EE28EA.4010409@sandeen.net>
Date: Tue, 21 Apr 2009 15:13:30 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfstests: enforce lazy-count=0 in log tests 018, 081, 082
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

I was experimenting w/ default lazy-count=1, and it broke a few tests.
Seems simplest to enforce lazy-count=0 in the common.log routines
for now, and fix up the output?  (vs. updating all the expected
output for these tests...)

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---


diff --git a/common.log b/common.log
index b651ceb..edfd5c1 100644
--- a/common.log
+++ b/common.log
@@ -272,7 +272,7 @@ _mkfs_log()
 {
     # create the FS
     # mkfs options to append to log size otion can be specified ($*)
-    export MKFS_OPTIONS="-l size=2000b $*"
+    export MKFS_OPTIONS="-l size=2000b -l lazy-count=0 $*"
     _full "mkfs"
     _scratch_mkfs_xfs >>$seq.full 2>&1
     if [ $? -ne 0 ] ; then diff --git a/018.out b/018.out
index 53840f0..3118b6e 100644
--- a/018.out
+++ b/018.out
@@ -1,17 +1,17 @@
 QA output created by 018
 *** init FS
-*** compare logprint: 018.op with 018.fulldir/op.mnt-onoalign,logbsize=32k.mkfs-lsize=2000b-lversion=1.filtered
-*** compare logprint: 018.trans_inode with 018.fulldir/trans_inode.mnt-onoalign,logbsize=32k.mkfs-lsize=2000b-lversion=1.filtered
-*** compare logprint: 018.trans_buf with 018.fulldir/trans_buf.mnt-onoalign,logbsize=32k.mkfs-lsize=2000b-lversion=1.filtered
-*** compare logprint: 018.op with 018.fulldir/op.mnt-onoalign,logbsize=32k.mkfs-lsize=2000b-lversion=2.filtered
-*** compare logprint: 018.trans_inode with 018.fulldir/trans_inode.mnt-onoalign,logbsize=32k.mkfs-lsize=2000b-lversion=2.filtered
-*** compare logprint: 018.trans_buf with 018.fulldir/trans_buf.mnt-onoalign,logbsize=32k.mkfs-lsize=2000b-lversion=2.filtered
-*** compare logprint: 018.op with 018.fulldir/op.mnt-onoalign,logbsize=64k.mkfs-lsize=2000b-lversion=2.filtered
-*** compare logprint: 018.trans_inode with 018.fulldir/trans_inode.mnt-onoalign,logbsize=64k.mkfs-lsize=2000b-lversion=2.filtered
-*** compare logprint: 018.trans_buf with 018.fulldir/trans_buf.mnt-onoalign,logbsize=64k.mkfs-lsize=2000b-lversion=2.filtered
-*** compare logprint: 018.op with 018.fulldir/op.mnt-onoalign,logbsize=128k.mkfs-lsize=2000b-lversion=2.filtered
-*** compare logprint: 018.trans_inode with 018.fulldir/trans_inode.mnt-onoalign,logbsize=128k.mkfs-lsize=2000b-lversion=2.filtered
-*** compare logprint: 018.trans_buf with 018.fulldir/trans_buf.mnt-onoalign,logbsize=128k.mkfs-lsize=2000b-lversion=2.filtered
-*** compare logprint: 018.op with 018.fulldir/op.mnt-onoalign,logbsize=256k.mkfs-lsize=2000b-lversion=2.filtered
-*** compare logprint: 018.trans_inode with 018.fulldir/trans_inode.mnt-onoalign,logbsize=256k.mkfs-lsize=2000b-lversion=2.filtered
-*** compare logprint: 018.trans_buf with 018.fulldir/trans_buf.mnt-onoalign,logbsize=256k.mkfs-lsize=2000b-lversion=2.filtered
+*** compare logprint: 018.op with 018.fulldir/op.mnt-onoalign,logbsize=32k.mkfs-lsize=2000b-llazy-count=0-lversion=1.filtered
+*** compare logprint: 018.trans_inode with 018.fulldir/trans_inode.mnt-onoalign,logbsize=32k.mkfs-lsize=2000b-llazy-count=0-lversion=1.filtered
+*** compare logprint: 018.trans_buf with 018.fulldir/trans_buf.mnt-onoalign,logbsize=32k.mkfs-lsize=2000b-llazy-count=0-lversion=1.filtered
+*** compare logprint: 018.op with 018.fulldir/op.mnt-onoalign,logbsize=32k.mkfs-lsize=2000b-llazy-count=0-lversion=2.filtered
+*** compare logprint: 018.trans_inode with 018.fulldir/trans_inode.mnt-onoalign,logbsize=32k.mkfs-lsize=2000b-llazy-count=0-lversion=2.filtered
+*** compare logprint: 018.trans_buf with 018.fulldir/trans_buf.mnt-onoalign,logbsize=32k.mkfs-lsize=2000b-llazy-count=0-lversion=2.filtered
+*** compare logprint: 018.op with 018.fulldir/op.mnt-onoalign,logbsize=64k.mkfs-lsize=2000b-llazy-count=0-lversion=2.filtered
+*** compare logprint: 018.trans_inode with 018.fulldir/trans_inode.mnt-onoalign,logbsize=64k.mkfs-lsize=2000b-llazy-count=0-lversion=2.filtered
+*** compare logprint: 018.trans_buf with 018.fulldir/trans_buf.mnt-onoalign,logbsize=64k.mkfs-lsize=2000b-llazy-count=0-lversion=2.filtered
+*** compare logprint: 018.op with 018.fulldir/op.mnt-onoalign,logbsize=128k.mkfs-lsize=2000b-llazy-count=0-lversion=2.filtered
+*** compare logprint: 018.trans_inode with 018.fulldir/trans_inode.mnt-onoalign,logbsize=128k.mkfs-lsize=2000b-llazy-count=0-lversion=2.filtered
+*** compare logprint: 018.trans_buf with 018.fulldir/trans_buf.mnt-onoalign,logbsize=128k.mkfs-lsize=2000b-llazy-count=0-lversion=2.filtered
+*** compare logprint: 018.op with 018.fulldir/op.mnt-onoalign,logbsize=256k.mkfs-lsize=2000b-llazy-count=0-lversion=2.filtered
+*** compare logprint: 018.trans_inode with 018.fulldir/trans_inode.mnt-onoalign,logbsize=256k.mkfs-lsize=2000b-llazy-count=0-lversion=2.filtered
+*** compare logprint: 018.trans_buf with 018.fulldir/trans_buf.mnt-onoalign,logbsize=256k.mkfs-lsize=2000b-llazy-count=0-lversion=2.filtered
diff --git a/081.out b/081.out
index bf533a4..efc6211 100644
--- a/081.out
+++ b/081.out
@@ -1,4 +1,4 @@
 QA output created by 081
 *** init FS
-*** compare logprint: 081.ugquota.trans_inode with 081.fulldir/trans_inode.mnt-oquota,gquota.mkfs-lsize=2000b-lversion=1.filtered
+*** compare logprint: 081.ugquota.trans_inode with 081.fulldir/trans_inode.mnt-oquota,gquota.mkfs-lsize=2000b-llazy-count=0-lversion=1.filtered
 *** unmount
diff --git a/082.out b/082.out
index e875ab5..edd6b2b 100644
--- a/082.out
+++ b/082.out
@@ -1,39 +1,39 @@
 QA output created by 082
 *** init FS
 --- mkfs=version=2, mnt=logbsize=32k, sync=sync ---
-*** compare logprint: 082.trans_inode with 082.fulldir/trans_inode.mnt-ologbsize=32k.mkfs-lsize=2000b-lversion=2.sync.filtered
-*** compare logprint: 082.trans_buf with 082.fulldir/trans_buf.mnt-ologbsize=32k.mkfs-lsize=2000b-lversion=2.sync.filtered
+*** compare logprint: 082.trans_inode with 082.fulldir/trans_inode.mnt-ologbsize=32k.mkfs-lsize=2000b-llazy-count=0-lversion=2.sync.filtered
+*** compare logprint: 082.trans_buf with 082.fulldir/trans_buf.mnt-ologbsize=32k.mkfs-lsize=2000b-llazy-count=0-lversion=2.sync.filtered
 --- mkfs=version=2,su=4096, mnt=logbsize=32k, sync=sync ---
-*** compare logprint: 082.trans_inode with 082.fulldir/trans_inode.mnt-ologbsize=32k.mkfs-lsize=2000b-lversion=2,su=4096.sync.filtered
-*** compare logprint: 082.trans_buf with 082.fulldir/trans_buf.mnt-ologbsize=32k.mkfs-lsize=2000b-lversion=2,su=4096.sync.filtered
+*** compare logprint: 082.trans_inode with 082.fulldir/trans_inode.mnt-ologbsize=32k.mkfs-lsize=2000b-llazy-count=0-lversion=2,su=4096.sync.filtered
+*** compare logprint: 082.trans_buf with 082.fulldir/trans_buf.mnt-ologbsize=32k.mkfs-lsize=2000b-llazy-count=0-lversion=2,su=4096.sync.filtered
 --- mkfs=version=2,su=32768, mnt=logbsize=32k, sync=sync ---
-*** compare logprint: 082.trans_inode with 082.fulldir/trans_inode.mnt-ologbsize=32k.mkfs-lsize=2000b-lversion=2,su=32768.sync.filtered
-*** compare logprint: 082.trans_buf with 082.fulldir/trans_buf.mnt-ologbsize=32k.mkfs-lsize=2000b-lversion=2,su=32768.sync.filtered
+*** compare logprint: 082.trans_inode with 082.fulldir/trans_inode.mnt-ologbsize=32k.mkfs-lsize=2000b-llazy-count=0-lversion=2,su=32768.sync.filtered
+*** compare logprint: 082.trans_buf with 082.fulldir/trans_buf.mnt-ologbsize=32k.mkfs-lsize=2000b-llazy-count=0-lversion=2,su=32768.sync.filtered
 --- mkfs=version=2,su=36864, mnt=logbsize=32k, sync=sync ---
 
-*** Cannot mkfs for this test using option specified: -l size=2000b -l version=2,su=36864 ***
+*** Cannot mkfs for this test using option specified: -l size=2000b -l lazy-count=0 -l version=2,su=36864 ***
 
 --- mkfs=version=2,su=5120, mnt=logbsize=32k, sync=sync ---
 
-*** Cannot mkfs for this test using option specified: -l size=2000b -l version=2,su=5120 ***
+*** Cannot mkfs for this test using option specified: -l size=2000b -l lazy-count=0 -l version=2,su=5120 ***
 
 --- mkfs=version=2, mnt=logbsize=32k, sync=nosync ---
-*** compare logprint: 082.op with 082.fulldir/op.mnt-ologbsize=32k.mkfs-lsize=2000b-lversion=2.nosync.filtered
-*** compare logprint: 082.trans_inode with 082.fulldir/trans_inode.mnt-ologbsize=32k.mkfs-lsize=2000b-lversion=2.nosync.filtered
-*** compare logprint: 082.trans_buf with 082.fulldir/trans_buf.mnt-ologbsize=32k.mkfs-lsize=2000b-lversion=2.nosync.filtered
+*** compare logprint: 082.op with 082.fulldir/op.mnt-ologbsize=32k.mkfs-lsize=2000b-llazy-count=0-lversion=2.nosync.filtered
+*** compare logprint: 082.trans_inode with 082.fulldir/trans_inode.mnt-ologbsize=32k.mkfs-lsize=2000b-llazy-count=0-lversion=2.nosync.filtered
+*** compare logprint: 082.trans_buf with 082.fulldir/trans_buf.mnt-ologbsize=32k.mkfs-lsize=2000b-llazy-count=0-lversion=2.nosync.filtered
 --- mkfs=version=2,su=4096, mnt=logbsize=32k, sync=nosync ---
-*** compare logprint: 082.op with 082.fulldir/op.mnt-ologbsize=32k.mkfs-lsize=2000b-lversion=2,su=4096.nosync.filtered
-*** compare logprint: 082.trans_inode with 082.fulldir/trans_inode.mnt-ologbsize=32k.mkfs-lsize=2000b-lversion=2,su=4096.nosync.filtered
-*** compare logprint: 082.trans_buf with 082.fulldir/trans_buf.mnt-ologbsize=32k.mkfs-lsize=2000b-lversion=2,su=4096.nosync.filtered
+*** compare logprint: 082.op with 082.fulldir/op.mnt-ologbsize=32k.mkfs-lsize=2000b-llazy-count=0-lversion=2,su=4096.nosync.filtered
+*** compare logprint: 082.trans_inode with 082.fulldir/trans_inode.mnt-ologbsize=32k.mkfs-lsize=2000b-llazy-count=0-lversion=2,su=4096.nosync.filtered
+*** compare logprint: 082.trans_buf with 082.fulldir/trans_buf.mnt-ologbsize=32k.mkfs-lsize=2000b-llazy-count=0-lversion=2,su=4096.nosync.filtered
 --- mkfs=version=2,su=32768, mnt=logbsize=32k, sync=nosync ---
-*** compare logprint: 082.op with 082.fulldir/op.mnt-ologbsize=32k.mkfs-lsize=2000b-lversion=2,su=32768.nosync.filtered
-*** compare logprint: 082.trans_inode with 082.fulldir/trans_inode.mnt-ologbsize=32k.mkfs-lsize=2000b-lversion=2,su=32768.nosync.filtered
-*** compare logprint: 082.trans_buf with 082.fulldir/trans_buf.mnt-ologbsize=32k.mkfs-lsize=2000b-lversion=2,su=32768.nosync.filtered
+*** compare logprint: 082.op with 082.fulldir/op.mnt-ologbsize=32k.mkfs-lsize=2000b-llazy-count=0-lversion=2,su=32768.nosync.filtered
+*** compare logprint: 082.trans_inode with 082.fulldir/trans_inode.mnt-ologbsize=32k.mkfs-lsize=2000b-llazy-count=0-lversion=2,su=32768.nosync.filtered
+*** compare logprint: 082.trans_buf with 082.fulldir/trans_buf.mnt-ologbsize=32k.mkfs-lsize=2000b-llazy-count=0-lversion=2,su=32768.nosync.filtered
 --- mkfs=version=2,su=36864, mnt=logbsize=32k, sync=nosync ---
 
-*** Cannot mkfs for this test using option specified: -l size=2000b -l version=2,su=36864 ***
+*** Cannot mkfs for this test using option specified: -l size=2000b -l lazy-count=0 -l version=2,su=36864 ***
 
 --- mkfs=version=2,su=5120, mnt=logbsize=32k, sync=nosync ---
 
-*** Cannot mkfs for this test using option specified: -l size=2000b -l version=2,su=5120 ***
+*** Cannot mkfs for this test using option specified: -l size=2000b -l lazy-count=0 -l version=2,su=5120 ***
 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
