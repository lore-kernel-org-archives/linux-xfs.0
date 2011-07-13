Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6DKSqPt099905 for <xfs@oss.sgi.com>; Wed, 13 Jul 2011 15:28:52 -0500
Received: from stout.americas.sgi.com (stout.americas.sgi.com [128.162.232.50])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0C5E88F8035
	for <xfs@oss.sgi.com>; Wed, 13 Jul 2011 13:28:49 -0700 (PDT)
Received: from stout.americas.sgi.com (localhost6.localdomain6 [127.0.0.1])
	by stout.americas.sgi.com (8.14.5/8.14.2) with ESMTP id p6DKSmeR018319
	for <xfs@oss.sgi.com>; Wed, 13 Jul 2011 15:28:48 -0500
Received: (from aelder@localhost)
	by stout.americas.sgi.com (8.14.5/8.14.5/Submit) id p6DKSm8G018318
	for xfs@oss.sgi.com; Wed, 13 Jul 2011 15:28:48 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201107132028.p6DKSm8G018318@stout.americas.sgi.com>
Date: Wed, 13 Jul 2011 15:28:48 -0500
Subject: [PATCH] xfstests: update test 250 and its golden output
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

Test 250 actually runs now that it has golden output defined.  The
output the test produces doesn't match the golden output, however.

The main reason seems to be a oversight in the test--the stderr
output of mkfs wasn't being ignored as it should be (likely for
debugging).  Remove the comment character so the stderr does get
ignored.

Doing this still leaves some other output, but since it's filtered
there's no reason to leave it out of the golden output.  So add
the expected result of filtering into the golden output file.

Finally, this test--unlike almost all of the others--specifies the
value of its "tmp" variable as a relative rather than absolute
path.  I'm sure that works in some places, but it produces errors
for me.  Follow the "tmp=/tmp/$$" convention used elsewhere.

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 250     |    4 ++--
 250.out |    6 ++++++
 2 files changed, 8 insertions(+), 2 deletions(-)

Index: b/250
===================================================================
--- a/250
+++ b/250
@@ -27,7 +27,7 @@ seq=`basename $0`
 echo "QA output created by $seq"
 
 here=`pwd`
-tmp=tmp/$$
+tmp=/tmp/$$
 status=1  # failure is the default!
 trap "_cleanup; exit \$status" 0 1 2 3 15
 
@@ -76,7 +76,7 @@ _test_loop()
 
 	echo "*** mkfs loop file (size=$size)"
 	$MKFS_XFS_PROG -d $dparam \
-		| _filter_mkfs # 2>/dev/null
+		| _filter_mkfs 2>/dev/null
 
 	echo "*** mount loop filesystem"
 	mount -t xfs -o loop $LOOP_DEV $LOOP_MNT
Index: b/250.out
===================================================================
--- a/250.out
+++ b/250.out
@@ -1,6 +1,12 @@
 QA output created by 250
 *** create loop mount point
 *** mkfs loop file (size=50g)
+meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
+data     = bsize=XXX blocks=XXX, imaxpct=PCT
+         = sunit=XXX swidth=XXX, unwritten=X
+naming   =VERN bsize=XXX
+log      =LDEV bsize=XXX blocks=XXX
+realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
 *** mount loop filesystem
 *** preallocate large file
 *** unmount loop filesystem

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
