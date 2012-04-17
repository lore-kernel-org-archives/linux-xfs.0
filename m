Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3H9PihT037652 for <xfs@oss.sgi.com>; Tue, 17 Apr 2012 04:25:44 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id pNMFnGSM6gkQRwnB for
	<xfs@oss.sgi.com>; Tue, 17 Apr 2012 02:25:43 -0700 (PDT)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q3H9PgNg025741
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 17 Apr 2012 05:25:42 -0400
From: Tom Marek <tmarek@redhat.com>
Subject: [PATCH 3/3 V2] xfstests 273: fix of reading scratch size and removing
	lost+found
Date: Tue, 17 Apr 2012 11:24:47 +0200
Message-Id: <1334654687-25450-3-git-send-email-tmarek@redhat.com>
In-Reply-To: <1334654687-25450-1-git-send-email-tmarek@redhat.com>
References: <y>
 <1334654687-25450-1-git-send-email-tmarek@redhat.com>
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
Cc: Tom Marek <tmarek@redhat.com>, lczerner@redhat.com, dchinner@redhat.com

There were two reasons why test 273 was failing. Firstrly, it was removing
everything from SCRATCH_MNT directory at the beginning of tests including
the lost+found directory. This cauesd error while checking scratch fs after
finishing test. Secondly, obtaining of the partition size was not counting
with with behaviour of df utility which may split the line containg
informations about one partition when it is too long thus it may have returned
nothing.

First problem was solved with removing all unnecessary rm -rf commands and the
second one was fixed with alternative awk script which is able to deal with
any line splitting possible.

Signed-off-by: Tom Marek <tmarek@redhat.com>
Reviewed-by: Lukas Czerner <lczerner@redhat.com>
---
 273 |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/273 b/273
index 2965132..86262d1 100755
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
 
@@ -66,9 +66,9 @@ _file_create()
 		exit
 	fi
 
-	cd $SCRATCH_MNT/origin
+	cd $SCRATCH_MNT
 
-	_disksize=`df --block-size=1 | grep $SCRATCH_DEV | awk '{print $2}'`
+	_disksize=`df --block-size=1 $SCRATCH_DEV | awk -v sd=$SCRATCH_DEV 'BEGIN{c=0}{for(i=1;i<=NF;++i){a[c]=$i;++c}}END{for(entry in a){if(a[entry] ~ sd){print a[entry + 3]; break}}}'`
 	_disksize=$(($_disksize / 3))
 	_num=$(($_disksize / $count / $threads / 4096))
 	_count=$count
@@ -105,8 +105,6 @@ _do_workload()
 {
 	_pids=""
 	_pid=1
-	
-	rm -rf $SCRATCH_MNT/*
 
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
