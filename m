Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p28Faw4p242749 for <xfs@oss.sgi.com>; Tue, 8 Mar 2011 09:36:58 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 63D141B06576
	for <xfs@oss.sgi.com>; Tue,  8 Mar 2011 07:39:52 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id djolqe57oExYqAIb for
	<xfs@oss.sgi.com>; Tue, 08 Mar 2011 07:39:52 -0800 (PST)
Message-ID: <4D764DC4.4030506@redhat.com>
Date: Tue, 08 Mar 2011 09:39:48 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests 225: Run with different random seeds
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
To: xfs-oss <xfs@oss.sgi.com>
Cc: Chris Mason <chris.mason@oracle.com>

Running the fiemap-tester with a unique random seed each time
may uncover some things missed by always using the default.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/225 b/225
index 2dea3c2..76be888 100755
--- a/225
+++ b/225
@@ -60,11 +60,15 @@ _cleanup()
 }
 trap "_cleanup; exit \$status" 0 1 2 3 15
 
+seed=`date +%s`
+
+echo "using seed $seed" >> $fiemaplog
+
 echo "fiemap run without preallocation, with sync"
-$here/src/fiemap-tester -q -S -p 0 -r 200 $fiemapfile 2>&1 | tee $fiemaplog
+$here/src/fiemap-tester -q -S -s $seed -p 0 -r 200 $fiemapfile 2>&1 | tee -a $fiemaplog
 
 echo "fiemap run without preallocation or sync"
-$here/src/fiemap-tester -q -p 0 -r 200 $fiemapfile 2>&1 | tee $fiemaplog
+$here/src/fiemap-tester -q -s $seed -p 0 -r 200 $fiemapfile 2>&1 | tee -a $fiemaplog
 
 if grep -q "Operation not supported" $fiemaplog; then
       _notrun "FIEMAP not supported by this filesystem type: $FSTYP"

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
