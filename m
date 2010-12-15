Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBFF5fHr211493 for <xfs@oss.sgi.com>; Wed, 15 Dec 2010 09:05:41 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 262981CCD204
	for <xfs@oss.sgi.com>; Wed, 15 Dec 2010 07:07:34 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Cp3BPprD7CCX620o for
	<xfs@oss.sgi.com>; Wed, 15 Dec 2010 07:07:34 -0800 (PST)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oBFF7VK3022704
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 15 Dec 2010 10:07:31 -0500
Received: from [10.34.26.208] (dhcp-26-208.brq.redhat.com [10.34.26.208])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id oBFF5dW4013811
	for <xfs@oss.sgi.com>; Wed, 15 Dec 2010 10:05:39 -0500
Subject: xfstests: filter spaces in xfs_quota output in test case 108
From: Boris Ranto <branto@redhat.com>
Date: Wed, 15 Dec 2010 16:05:38 +0100
Message-ID: <1292425538.3220.14.camel@dhcp-31-190.brq.redhat.com>
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
To: xfs <xfs@oss.sgi.com>

Program xfs_quota can output different amounts of spaces when it is trying to align its output.
This can cause output mismatch on several systems when testing test case 108.

Attached patch will filter all the consecutive spaces in xfs_quota output to just one space making the test case independent of the alignment.

Signed-off-by: Boris Ranto <branto@redhat.com>

diff -urpN a/xfstests/108 b/xfstests/108
--- a/xfstests/108      2010-12-09 11:34:37.733245986 +0100
+++ b/xfstests/108      2010-12-14 14:50:16.813494309 +0100
@@ -72,9 +72,9 @@ test_accounting()
        for file in $SCRATCH_MNT/{buffer,direct,mmap}; do
                $here/src/lstat64 $file | head -3 | _filter_scratch
        done
-       xfs_quota -c "quota -hnb -$type $id" $QARGS | _filter_scratch
-       xfs_quota -c "quota -hni -$type $id" $QARGS | _filter_scratch
-       xfs_quota -c "quota -hnr -$type $id" $QARGS | _filter_scratch
+       xfs_quota -c "quota -hnb -$type $id" $QARGS | _filter_scratch | _filter_spaces
+       xfs_quota -c "quota -hni -$type $id" $QARGS | _filter_scratch | _filter_spaces
+       xfs_quota -c "quota -hnr -$type $id" $QARGS | _filter_scratch | _filter_spaces
 }
 
 export MOUNT_OPTIONS="-opquota"
diff -urpN a/xfstests/108.out b/xfstests/108.out
--- a/xfstests/108.out  2010-12-09 11:24:48.973251551 +0100
+++ b/xfstests/108.out  2010-12-14 15:01:33.640484268 +0100
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
--- a/xfstests/common.filter    2010-12-09 11:24:44.315240233 +0100
+++ b/xfstests/common.filter    2010-12-14 14:45:53.566228712 +0100
@@ -224,5 +224,10 @@ _filter_scratch()
        sed -e "s,$SCRATCH_DEV,SCRATCH_DEV,g" -e "s,$SCRATCH_MNT,SCRATCH_MNT,g"
 }
 
+_filter_spaces()
+{
+       sed -e 's/ [ ]*/ /g'
+}
+
 # make sure this script returns success
 /bin/true


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
