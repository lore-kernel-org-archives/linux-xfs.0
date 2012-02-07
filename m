Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q17HTkgw247135 for <xfs@oss.sgi.com>; Tue, 7 Feb 2012 11:29:47 -0600
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id wHAY2o9I5MKtIDBb for
	<xfs@oss.sgi.com>; Tue, 07 Feb 2012 09:29:45 -0800 (PST)
Message-ID: <4F315F88.3020200@redhat.com>
Date: Tue, 07 Feb 2012 11:29:44 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests: 068: run fsstress in read/write mode
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
To: xfs-oss <xfs@oss.sgi.com>, Jan Kara <jack@suse.cz>

Jan Kara was testing filesystem freeze, and was consistently locking
up, although my tests of 068 were passing.  He pointed out that
he was running in read/write mode, and it was atime updates causing
the trouble.  Sure enough, dropping "-w" from fsstress locked me up
too.  Change this so we get better (and more realistic) coverage.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
cc: Jan Kara <jack@suse.cz>
---


diff --git a/068 b/068
index 6f08f18..b15409e 100755
--- a/068
+++ b/068
@@ -79,8 +79,9 @@ touch $tmp.running
     nops=200
     while [ -f "$tmp.running" ]
       do
-      #	-w ensures that the only ops are ones which cause write I/O
-      $FSSTRESS_PROG -d $STRESS_DIR -w -p $procs -n $nops $FSSTRESS_AVOID \
+      # We do both read & write IO - not only is this more realistic,
+      # but it also potentially tests atime updates
+      $FSSTRESS_PROG -d $STRESS_DIR -p $procs -n $nops $FSSTRESS_AVOID \
 	  > /dev/null 2>&1
     done
 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
