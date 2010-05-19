Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4JMfx8A159917 for <xfs@oss.sgi.com>; Wed, 19 May 2010 17:41:59 -0500
Received: from stout.americas.sgi.com (stout.americas.sgi.com [128.162.232.50])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7348AAC02D
	for <xfs@oss.sgi.com>; Wed, 19 May 2010 15:44:15 -0700 (PDT)
Received: from stout.americas.sgi.com (localhost6.localdomain6 [127.0.0.1])
	by stout.americas.sgi.com (8.14.3/8.14.2) with ESMTP id o4JMiEfW014865
	for <xfs@oss.sgi.com>; Wed, 19 May 2010 17:44:14 -0500
Received: (from aelder@localhost)
	by stout.americas.sgi.com (8.14.3/8.14.3/Submit) id o4JMiEPY014864
	for xfs@oss.sgi.com; Wed, 19 May 2010 17:44:14 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201005192244.o4JMiEPY014864@stout.americas.sgi.com>
Date: Wed, 19 May 2010 17:44:14 -0500
Subject: xfstests: 226: have xfs_io use bigger buffers
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
To: xfs@oss.sgi.com

By default xfs_io uses a buffer size of 4096 bytes.  On test 226,
the result is that the test runs much slower (at least an order
of magnitude) than it needs to.

Add a flag to the "pwrite" command sent to xfs_io so it uses
larger buffers, thereby speeding things up considerably.

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 226 |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

Index: b/226
===================================================================
--- a/226
+++ b/226
@@ -49,10 +49,14 @@ _scratch_mount
 
 loops=16
 
+# Buffer size argument supplied to xfs_io "pwrite" command
+buffer="-b $(expr 512 \* 1024)"
+
 echo "--> $loops buffered 64m writes in a loop"
 for I in `seq 1 $loops`; do
 	echo -n "$I "
-	xfs_io -F -f -c 'pwrite 0 64m' $SCRATCH_MNT/test >> $seq.full
+	xfs_io -F -f \
+		-c "pwrite ${buffer} 0 64m" $SCRATCH_MNT/test >> $seq.full
 	rm -f $SCRATCH_MNT/test
 done
 
@@ -63,7 +67,8 @@ _scratch_mount
 echo "--> $loops direct 64m writes in a loop"
 for I in `seq 1 $loops`; do
 	echo -n "$I "
-	xfs_io -F -f -d -c 'pwrite 0 64m' $SCRATCH_MNT/test >> $seq.full
+	xfs_io -F -f -d \
+		-c "pwrite ${buffer} 0 64m" $SCRATCH_MNT/test >> $seq.full
 	rm -f $SCRATCH_MNT/test 
 done
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
