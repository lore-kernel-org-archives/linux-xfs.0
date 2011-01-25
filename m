Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0P3ww1r176084 for <xfs@oss.sgi.com>; Mon, 24 Jan 2011 21:58:58 -0600
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DBA4C8A549F
	for <xfs@oss.sgi.com>; Mon, 24 Jan 2011 20:01:20 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	TA5Ao9UAYzNMBOFu for <xfs@oss.sgi.com>;
	Mon, 24 Jan 2011 20:01:20 -0800 (PST)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1Pha5j-0003Tu-BQ
	for xfs@oss.sgi.com; Tue, 25 Jan 2011 15:01:15 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1Pha3Y-0005Nk-Ty
	for xfs@oss.sgi.com; Tue, 25 Jan 2011 14:59:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/4] xfstests: Speed up test 042
Date: Tue, 25 Jan 2011 14:58:57 +1100
Message-Id: <1295927937-20634-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1295927937-20634-1-git-send-email-david@fromorbit.com>
References: <1295927937-20634-1-git-send-email-david@fromorbit.com>
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

test 042 generates a worst-case fragmented filesystem and uses it to
test xfs_fsr. It uses small 4k files to generate the hole-space-hole
pattern that fragments free space badly. It is much faster to
generate the same pattern by creating a single large file and
punching holes in it.  Also, instead of writing large files to
create unfragmented space, just use preallocation so we don't have
to write the data to disk.

These changes reduce the runtime of the test on a single SATA drive
from 106s to 27s.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 042     |   38 ++++++++++++++++++++++++++++++--------
 042.out |    6 +++---
 2 files changed, 33 insertions(+), 11 deletions(-)

diff --git a/042 b/042
index 7ac5492..c583746 100755
--- a/042
+++ b/042
@@ -100,16 +100,19 @@ echo "done"
 echo -n "Reserve 16 1Mb unfragmented regions... "
 for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16
 do
-    _do "dd if=/dev/zero of=$SCRATCH_MNT/hole$i bs=4096 count=256"
-    _do "dd if=/dev/zero of=$SCRATCH_MNT/space$i bs=4096 count=1"
-    _do "xfs_bmap -v $SCRATCH_MNT/hole$i"
+	_do "$XFS_IO_PROG -f -c \"resvsp 0 1m\" $SCRATCH_MNT/hole$i"
+	_do "$XFS_IO_PROG -f -c \"resvsp 0 4k\" $SCRATCH_MNT/space$i"
+	_do "$XFS_IO_PROG -f -c \"resvsp 0 1m\" $SCRATCH_MNT/hole$i"
+	_do "xfs_bmap -vp $SCRATCH_MNT/hole$i"
 done
 echo "done" 
 
 # set up filesystem
-echo -n "Fill filesystem with 4k files, generate manifest... "
-fill_options="--verbose --seed=0 --filesize=4096 --stddev=0 --sync=1000000"
-_do "src/fill2fs $fill_options --dir=$SCRATCH_MNT/fill --list=- > $tmp.manifest"
+echo -n "Fill filesystem with fill file... "
+for i in `seq 0 1 31`; do
+	_do "$XFS_IO_PROG -fs -c \"pwrite -S$i ${i}m 1m\" $SCRATCH_MNT/fill"
+done
+_do "xfs_bmap -vp $SCRATCH_MNT/fill"
 echo "done"
 # flush the filesystem - make sure there is no space "lost" to pre-allocation
 _do "umount $SCRATCH_MNT"
@@ -119,7 +122,18 @@ _do "dd if=/dev/zero of=$SCRATCH_MNT/pad bs=4096"
 echo "done"
 
 # create fragmented file
-_do "Delete every second file" "_cull_files"
+#_do "Delete every second file" "_cull_files"
+echo -n "Punch every second 4k block... "
+for i in `seq 0 8 32768`; do
+	# This generates excessive output that significantly slows down the
+	# test. It's not necessary for debug, so just bin it.
+	$XFS_IO_PROG -f -c "unresvsp ${i}k 4k" $SCRATCH_MNT/fill \
+								> /dev/null 2>&1
+done
+_do "xfs_bmap -vp $SCRATCH_MNT/fill"
+_do "sum $SCRATCH_MNT/fill >$tmp.fillsum1"
+echo "done"
+
 echo -n "Create one very large file... "
 _do "src/fill2 -d nbytes=16000000,file=$SCRATCH_MNT/fragmented"
 echo "done"
@@ -130,7 +144,15 @@ _do "Remove other files" "rm -rf $SCRATCH_MNT/{pad,hole*}"
 # defragment
 _do "Run xfs_fsr on filesystem" "$XFS_FSR_PROG -v $SCRATCH_MNT/fragmented"
 _do "xfs_bmap -v $SCRATCH_MNT/fragmented"
-_do "Check 4k files" "src/fill2fs_check $tmp.manifest"
+
+echo -n "Check fill file... "
+_do "sum $SCRATCH_MNT/fill >$tmp.fillsum2"
+if ! _do "diff $tmp.fillsum1 $tmp.fillsum2"; then
+    echo "fail"
+    echo "Fill file is corrupt/missing after fsr. Test failed see $seq.full"
+    status=1; exit
+fi
+echo "done"
 
 # check
 echo -n "Check large file... "
diff --git a/042.out b/042.out
index 7f2e837..f5b37b3 100644
--- a/042.out
+++ b/042.out
@@ -1,13 +1,13 @@
 QA output created by 042
 Make a 48 megabyte filesystem on SCRATCH_DEV and mount... done
 Reserve 16 1Mb unfragmented regions... done
-Fill filesystem with 4k files, generate manifest... done
+Fill filesystem with fill file... done
 Use up any further available space using dd... done
-Delete every second file... done
+Punch every second 4k block... done
 Create one very large file... done
 Remove other files... done
 Run xfs_fsr on filesystem... done
-Check 4k files... done
+Check fill file... done
 Check large file... done
 Checking filesystem... done
 xfs_fsr tests passed.
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
