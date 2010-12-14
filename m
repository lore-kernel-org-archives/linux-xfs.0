Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBEEprjV131851 for <xfs@oss.sgi.com>; Tue, 14 Dec 2010 08:51:53 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E96A51E9572
	for <xfs@oss.sgi.com>; Tue, 14 Dec 2010 06:53:45 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id iFKNoMc2gLc2ftqd for
	<xfs@oss.sgi.com>; Tue, 14 Dec 2010 06:53:45 -0800 (PST)
Subject: Re: xfstests: fix 108 through config mechanism
From: Boris Ranto <branto@redhat.com>
In-Reply-To: <20101210143717.GB1415@infradead.org>
References: <1291905612.3196.49.camel@dhcp-31-190.brq.redhat.com>
	<20101210143717.GB1415@infradead.org>
Date: Tue, 14 Dec 2010 15:53:37 +0100
Message-ID: <1292338417.3296.57.camel@dhcp-31-190.brq.redhat.com>
Mime-Version: 1.0
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
Cc: xfs@oss.sgi.com

On Fri, 2010-12-10 at 09:37 -0500, Christoph Hellwig wrote:
> I don't rally like the per-test option.  What about adding a
> _filter_xfs_quota helper that uses sed to output a canonical
> number of whitespaces?
> 

I didn't like it much either but I found it quite easy to implement with quite high probability of future usage.

I found the following modification sufficient although I'm not sure I put the _filter_spaces in right place (I'd say it's quite universal so it could find a usage in other cases):

diff -urpN a/xfstests/108 b/xfstests/108
--- a/xfstests/108	2010-12-09 11:34:37.733245986 +0100
+++ b/xfstests/108	2010-12-14 14:50:16.813494309 +0100
@@ -72,9 +72,9 @@ test_accounting()
 	for file in $SCRATCH_MNT/{buffer,direct,mmap}; do
 		$here/src/lstat64 $file | head -3 | _filter_scratch
 	done
-	xfs_quota -c "quota -hnb -$type $id" $QARGS | _filter_scratch
-	xfs_quota -c "quota -hni -$type $id" $QARGS | _filter_scratch
-	xfs_quota -c "quota -hnr -$type $id" $QARGS | _filter_scratch
+	xfs_quota -c "quota -hnb -$type $id" $QARGS | _filter_scratch | _filter_spaces
+	xfs_quota -c "quota -hni -$type $id" $QARGS | _filter_scratch | _filter_spaces
+	xfs_quota -c "quota -hnr -$type $id" $QARGS | _filter_scratch | _filter_spaces
 }
 
 export MOUNT_OPTIONS="-opquota"
diff -urpN a/xfstests/108.out b/xfstests/108.out
--- a/xfstests/108.out	2010-12-09 11:24:48.973251551 +0100
+++ b/xfstests/108.out	2010-12-14 15:01:33.640484268 +0100
@@ -32,11 +32,11 @@ projid = 3
   Size: 16777216     Filetype: Regular File
   Mode: (0600/-rw-------)         Uid: (1)  Gid: (2)
 Disk quotas for User #1 (1)
-Filesystem   Blocks  Quota  Limit Warn/Time    Mounted on
-SCRATCH_DEV        48M      0      0  00 [------] SCRATCH_MNT
+Filesystem Blocks Quota Limit Warn/Time Mounted on
+SCRATCH_DEV 48M 0 0 00 [------] SCRATCH_MNT
 Disk quotas for User #1 (1)
-Filesystem    Files  Quota  Limit Warn/Time    Mounted on
-SCRATCH_DEV          3      0      0  00 [------] SCRATCH_MNT
+Filesystem Files Quota Limit Warn/Time Mounted on
+SCRATCH_DEV 3 0 0 00 [------] SCRATCH_MNT
 
 ### test group accounting
 
@@ -64,11 +64,11 @@ projid = 3
   Size: 16777216     Filetype: Regular File
   Mode: (0600/-rw-------)         Uid: (1)  Gid: (2)
 Disk quotas for Group #2 (2)
-Filesystem   Blocks  Quota  Limit Warn/Time    Mounted on
-SCRATCH_DEV        48M      0      0  00 [------] SCRATCH_MNT
+Filesystem Blocks Quota Limit Warn/Time Mounted on
+SCRATCH_DEV 48M 0 0 00 [------] SCRATCH_MNT
 Disk quotas for Group #2 (2)
-Filesystem    Files  Quota  Limit Warn/Time    Mounted on
-SCRATCH_DEV          3      0      0  00 [------] SCRATCH_MNT
+Filesystem Files Quota Limit Warn/Time Mounted on
+SCRATCH_DEV 3 0 0 00 [------] SCRATCH_MNT
 
 ### create files, setting up ownership (type=p)
   File: "SCRATCH_MNT/buffer"
@@ -94,8 +94,8 @@ projid = 3
   Size: 16777216     Filetype: Regular File
   Mode: (0600/-rw-------)         Uid: (1)  Gid: (2)
 Disk quotas for Project #3 (3)
-Filesystem   Blocks  Quota  Limit Warn/Time    Mounted on
-SCRATCH_DEV        48M      0      0  00 [------] SCRATCH_MNT
+Filesystem Blocks Quota Limit Warn/Time Mounted on
+SCRATCH_DEV 48M 0 0 00 [------] SCRATCH_MNT
 Disk quotas for Project #3 (3)
-Filesystem    Files  Quota  Limit Warn/Time    Mounted on
-SCRATCH_DEV          3      0      0  00 [------] SCRATCH_MNT
+Filesystem Files Quota Limit Warn/Time Mounted on
+SCRATCH_DEV 3 0 0 00 [------] SCRATCH_MNT
diff -urpN a/xfstests/common.filter b/xfstests/common.filter
--- a/xfstests/common.filter	2010-12-09 11:24:44.315240233 +0100
+++ b/xfstests/common.filter	2010-12-14 14:45:53.566228712 +0100
@@ -224,5 +224,10 @@ _filter_scratch()
 	sed -e "s,$SCRATCH_DEV,SCRATCH_DEV,g" -e "s,$SCRATCH_MNT,SCRATCH_MNT,g"
 }
 
+_filter_spaces()
+{
+	sed -e 's/ [ ]*/ /g'
+}
+
 # make sure this script returns success
 /bin/true

Signed-off-by: Boris Ranto <branto@redhat.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
