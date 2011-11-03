Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA3EPioD018002 for <xfs@oss.sgi.com>; Thu, 3 Nov 2011 09:25:44 -0500
Received: from mail-bw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3A2145683EB
	for <xfs@oss.sgi.com>; Thu,  3 Nov 2011 07:25:43 -0700 (PDT)
Received: from mail-bw0-f53.google.com (mail-bw0-f53.google.com
	[209.85.214.53]) by cuda.sgi.com with ESMTP id LzmPSn5soQJ0imJy
	for <xfs@oss.sgi.com>; Thu, 03 Nov 2011 07:25:43 -0700 (PDT)
Received: by mail-bw0-f53.google.com with SMTP id zs8so1398069bkb.26
	for <xfs@oss.sgi.com>; Thu, 03 Nov 2011 07:25:43 -0700 (PDT)
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 05/12] xfstests: freeze fsstress options for 117'th
Date: Thu,  3 Nov 2011 18:24:54 +0400
Message-Id: <1320330301-2682-6-git-send-email-dmonakhov@openvz.org>
In-Reply-To: <1320330301-2682-1-git-send-email-dmonakhov@openvz.org>
References: <1320330301-2682-1-git-send-email-dmonakhov@openvz.org>
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
To: linux-fsdevel@vger.kernel.org
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, aelder@sgi.com, tytso@mit.edu, hch@lst.de, xfs@oss.sgi.com

This is regression tescase for explicit combination of seed+fs_opts.
Let's hardcode all options to prevent interactions with fsstress
changes in future.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 117 |   39 ++++++++++++++++++++++++++++-----------
 1 files changed, 28 insertions(+), 11 deletions(-)

diff --git a/117 b/117
index edec157..2e3f658 100755
--- a/117
+++ b/117
@@ -33,8 +33,34 @@ tmp=/tmp/$$
 status=1	# failure is the default!
 trap "_cleanup; exit \$status" 0 1 2 3 15
 
-# seed for fsstress known to cause curruptions
+# seed and options for fsstress known to cause curruptions
 seed=1122413794
+fss_ops=" -z \
+    -f attr_remove=100 \
+    -f attr_set=100 \
+    -f chown=3 \
+    -f creat=4 \
+    -f dread=4 \
+    -f dwrite=4 \
+    -f fdatasync=1 \
+    -f fsync=1 \
+    -f getdents=1 \
+    -f link=1 \
+    -f mkdir=2 \
+    -f mknod=2 \
+    -f read=1 \
+    -f readlink=1 \
+    -f rename=2 \
+    -f rmdir=1 \
+    -f setxattr=1 \
+    -f stat=1 \
+    -f symlink=2 \
+    -f sync=1 \
+    -f truncate=2 \
+    -f unlink=1 \
+    -f write=4 \
+    -s $seed \
+    -m 31 -n 1000 -p 1"
 
 ITERATIONS=10
 
@@ -76,16 +102,7 @@ while [ $i -lt $ITERATIONS ]; do
     echo fsstress iteration: $i | tee -a $seq.full
     $FSSTRESS_PROG \
 	-d $SCRATCH_MNT/fsstress \
-	-f allocsp=0 \
-	-f freesp=0 \
-	-f bulkstat=0 \
-	-f bulkstat1=0 \
-	-f resvsp=0 \
-	-f unresvsp=0 \
-	-f attr_set=100 \
-	-f attr_remove=100 \
-        -s $seed \
-	-p 1 -n 1000 -S c >>$seq.full 2>&1
+	$fss_ops -S c >>$seq.full 2>&1
 
     let i=$i+1
 done
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
