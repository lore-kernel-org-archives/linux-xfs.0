Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9A2EPRU139937 for <xfs@oss.sgi.com>; Sun, 9 Oct 2011 21:14:25 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9F97455E1C7
	for <xfs@oss.sgi.com>; Sun,  9 Oct 2011 19:14:23 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	0c8Ibm2eQfncwpU3 for <xfs@oss.sgi.com>;
	Sun, 09 Oct 2011 19:14:23 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1RD5Nj-0003tU-AE
	for xfs@oss.sgi.com; Mon, 10 Oct 2011 13:14:19 +1100
Received: from dave by disappointment with local (Exim 4.76)
	(envelope-from <dave@disappointment.disaster>) id 1RD5Ni-0005H2-SE
	for xfs@oss.sgi.com; Mon, 10 Oct 2011 13:14:18 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/2] xfstests: make 225 use SCRATCH_DEV
Date: Mon, 10 Oct 2011 13:14:14 +1100
Message-Id: <1318212855-20212-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1318212855-20212-1-git-send-email-david@fromorbit.com>
References: <1318212855-20212-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Use the scratch device for test 225 so that both custom mkfs and
mount options impact the test (e.g. filesystem block size). This
exposes test failures when using 512 byte block sizes, which
currently not tested unless the test device is specifically created
with a 512 byte block size.

Also clean up the file names to include the test number, and don't
remove the test files after the test has finished so that it leaves
behind a corpse that can be dissected when the test fails.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 225 |   33 +++++++++++++++------------------
 1 files changed, 15 insertions(+), 18 deletions(-)

diff --git a/225 b/225
index 76be888..e7f1d9c 100755
--- a/225
+++ b/225
@@ -45,20 +45,17 @@ _cleanup()
 # real QA test starts here
 _supported_fs generic
 _supported_os Linux
+_require_scratch
 
-_setup_testdir
+_scratch_mkfs > /dev/null 2>&1
+_scratch_mount > /dev/null 2>&1
 
-fiemapfile=$TEST_DIR/fiemap.$$
-fiemaplog=$TEST_DIR/fiemap.$$.log
+rm -f $seq.full
+fiemapfile=$SCRATCH_MNT/$seq.fiemap
+fiemaplog=$SCRATCH_MNT/$seq.log
 
-[ -x $here/src/fiemap-tester ] || _notrun "fiemap-tester not built"
 
-_cleanup()
-{
-	rm -f $fiemapfile
-	rm -f $fiemaplog
-}
-trap "_cleanup; exit \$status" 0 1 2 3 15
+[ -x $here/src/fiemap-tester ] || _notrun "fiemap-tester not built"
 
 seed=`date +%s`
 
@@ -67,16 +64,16 @@ echo "using seed $seed" >> $fiemaplog
 echo "fiemap run without preallocation, with sync"
 $here/src/fiemap-tester -q -S -s $seed -p 0 -r 200 $fiemapfile 2>&1 | tee -a $fiemaplog
 
-echo "fiemap run without preallocation or sync"
-$here/src/fiemap-tester -q -s $seed -p 0 -r 200 $fiemapfile 2>&1 | tee -a $fiemaplog
-
-if grep -q "Operation not supported" $fiemaplog; then
-      _notrun "FIEMAP not supported by this filesystem type: $FSTYP"
+if [ $? -ne 0 ]; then
+	if grep -q "Operation not supported" $fiemaplog; then
+	      _notrun "FIEMAP not supported by this filesystem type: $FSTYP"
+	fi
+	status=$?
+	exit
 fi
 
-rm -f $fiemapfile
-rm -f $fiemaplog
-rm -f $seq.full
+echo "fiemap run without preallocation or sync"
+$here/src/fiemap-tester -q -s $seed -p 0 -r 200 $fiemapfile 2>&1 | tee -a $fiemaplog
 
 status=0
 exit
-- 
1.7.5.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
