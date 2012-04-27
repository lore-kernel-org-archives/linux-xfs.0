Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3RA7aOP150182 for <xfs@oss.sgi.com>; Fri, 27 Apr 2012 05:07:36 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 4fHP0qh9awFR1UAq for
	<xfs@oss.sgi.com>; Fri, 27 Apr 2012 03:07:35 -0700 (PDT)
From: Tom Marek <tmarek@redhat.com>
Subject: [PATCH 2/2 V2] xfstests 273: fix of reading scratch size and removing
	lost+found
Date: Fri, 27 Apr 2012 12:07:20 +0200
Message-Id: <1335521240-24098-2-git-send-email-tmarek@redhat.com>
In-Reply-To: <1335521240-24098-1-git-send-email-tmarek@redhat.com>
References: <1335521240-24098-1-git-send-email-tmarek@redhat.com>
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
Cc: Tom Marek <tmarek@redhat.com>, lczerner@redhat.com, sandeen@sandeen.net, dchinner@redhat.com

There were two reasons why test 273 was failing. Firstrly, when running on
ext4 fs it was removing everything from SCRATCH_MNT directory at the beginning
of tests including the lost+found directory. This caused error while checking
scratch fs after finishing test. Secondly, obtaining of the partition size was
not counting with with behaviour of df utility which may split the line containg
informations about one partition when it is too long thus it may have returned
nothing.

First problem was solved with removing all unnecessary rm -rf commands and the
second one was fixed with alternative awk script which is able to deal with
any line splitting possible. Also 'umount $SCRATCH_DEV' was substituted for
'_scratch_unmount'.

Cc: sandeen@sandeen.net
Signed-off-by: Tom Marek <tmarek@redhat.com>
---
V2: cleaning of $SCRATCH_MNT removed from cleanup()

 273 |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/273 b/273
index 2965132..da9172d 100755
--- a/273
+++ b/273
@@ -35,7 +35,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
 	cd /
-	rm -rf $SCRATCH_MNT/* $tmp.*
+	rm -rf $tmp.*
 	_scratch_unmount
 }
 
@@ -68,7 +68,7 @@ _file_create()
 
 	cd $SCRATCH_MNT/origin
 
-	_disksize=`df --block-size=1 | grep $SCRATCH_DEV | awk '{print $2}'`
+	_disksize=`df --block-size=1 $SCRATCH_DEV | awk -v sd=$SCRATCH_DEV 'BEGIN{c=0}{for(i=1;i<=NF;++i){a[c]=$i;++c}}END{for(entry in a){if(a[entry] ~ sd){print a[entry + 3]; break}}}'`
 	_disksize=$(($_disksize / 3))
 	_num=$(($_disksize / $count / $threads / 4096))
 	_count=$count
@@ -106,8 +106,6 @@ _do_workload()
 	_pids=""
 	_pid=1
 	
-	rm -rf $SCRATCH_MNT/*
-
 	_threads_set
 	_file_create
 
@@ -134,7 +132,7 @@ echo "------------------------------"
 
 rm -f $seq.full
 
-umount $SCRATCH_DEV 2>/dev/null
+_scratch_unmount 2>/dev/null
 _scratch_mkfs_sized $((2 * 1024 * 1024 * 1024)) >>$seq.full 2>&1
 _scratch_mount
 
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
