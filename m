Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 581227F58
	for <xfs@oss.sgi.com>; Sun, 23 Feb 2014 21:06:31 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 11B388F8033
	for <xfs@oss.sgi.com>; Sun, 23 Feb 2014 19:06:31 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Q2jqSWsQFgE4kvjG for <xfs@oss.sgi.com>;
	Sun, 23 Feb 2014 19:06:29 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WHls1-0004Pt-Fl
	for xfs@oss.sgi.com; Mon, 24 Feb 2014 14:06:17 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1WHls1-0007p3-En
	for xfs@oss.sgi.com; Mon, 24 Feb 2014 14:06:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/6] generic/003: ensure time changes between stat calls
Date: Mon, 24 Feb 2014 14:06:12 +1100
Message-Id: <1393211175-30016-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1393211175-30016-1-git-send-email-david@fromorbit.com>
References: <1393211175-30016-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

On a fast device like a ramdisk, kernel time may not have changed
between a stat of a file and some operation on it immediately
afterwards. Hence there is no guarantee that an operation actually
changes the timestamps of a file immediately after it is stat'd.

Hence, ensure that the times will change by sleeping for a second
between the initial stat that reads the timestamps and the
operations that is supposed to modify them. This way we ensure that
the timestamp will change if the filesystem is correctly
implemented.

While there, fix the indenting to be 8 space tabs and correct the
header which is missing the bash shell declaration and the test
number identifier.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 tests/generic/003 | 110 ++++++++++++++++++++++++++++++------------------------
 1 file changed, 61 insertions(+), 49 deletions(-)

diff --git a/tests/generic/003 b/tests/generic/003
index 3a11ab3..5c2d383 100755
--- a/tests/generic/003
+++ b/tests/generic/003
@@ -1,3 +1,6 @@
+#! /bin/bash
+# FS QA Test No. generic/003
+#
 # Tests the noatime, relatime, strictatime and nodiratime mount options.
 # There is an extra check for Btrfs to ensure that the access time is
 # never updated on read-only subvolumes. (Regression test for bug fixed
@@ -49,41 +52,40 @@ _require_relatime
 rm -f $seqres.full
 
 _stat() {
-    stat --printf="%x;%y;%z" $1
+	stat --printf="%x;%y;%z" $1
 }
 
 _compare_stat_times() {
-    updated=$1      # 3 chars indicating if access, modify and
-                    # change times should be updated (Y) or not (N)
-    IFS=';' read -a first_stat <<< "$2"   # Convert first stat to array
-    IFS=';' read -a second_stat <<< "$3"  # Convert second stat to array
-    test_step=$4    # Will be printed to output stream in case of an
-                    # error, to make debugging easier
-    types=( access modify change )
-
-    for i in 0 1 2; do
-        if [ "${first_stat[$i]}" == "${second_stat[$i]}" ]; then
-            if [ "${updated:$i:1}" == "Y" ]; then
-                echo -n "ERROR: ${types[$i]} time has not been updated "
-                echo $test_step
-            fi
-        else
-            if [ "${updated:$i:1}" == "N" ]; then
-                echo -n "ERROR: ${types[$i]} time has changed "
-                echo $test_step
-            fi
-        fi
-    done
+	updated=$1	# 3 chars indicating if access, modify and
+			# change times should be updated (Y) or not (N)
+	IFS=';' read -a first_stat <<< "$2"   # Convert first stat to array
+	IFS=';' read -a second_stat <<< "$3"  # Convert second stat to array
+	test_step=$4	# Will be printed to output stream in case of an
+			# error, to make debugging easier
+	types=( access modify change )
+
+	for i in 0 1 2; do
+		if [ "${first_stat[$i]}" == "${second_stat[$i]}" ]; then
+			if [ "${updated:$i:1}" == "N" ]; then
+				continue;
+			fi
+			echo -n "ERROR: ${types[$i]} time has not been updated "
+			echo $test_step
+		elif [ "${updated:$i:1}" == "N" ]; then
+			echo -n "ERROR: ${types[$i]} time has changed "
+			echo $test_step
+		fi
+	done
 }
 
 _scratch_mkfs >> $seqres.full 2>&1 || _fail "mkfs failed"
 _scratch_mount "-o relatime"
 
 if [ "$FSTYP" = "btrfs" ]; then
-    TPATH=$SCRATCH_MNT/sub1
-    $BTRFS_UTIL_PROG subvolume create $TPATH > $seqres.full
+	TPATH=$SCRATCH_MNT/sub1
+	$BTRFS_UTIL_PROG subvolume create $TPATH > $seqres.full
 else
-    TPATH=$SCRATCH_MNT
+	TPATH=$SCRATCH_MNT
 fi
 
 mkdir $TPATH/dir1
@@ -91,62 +93,69 @@ echo "aaa" > $TPATH/dir1/file1
 file1_stat_before_first_access=`_stat $TPATH/dir1/file1`
 
 # Accessing file1 the first time
+sleep 1
 cat $TPATH/dir1/file1 > /dev/null
 file1_stat_after_first_access=`_stat $TPATH/dir1/file1`
 _compare_stat_times YNN "$file1_stat_before_first_access" \
-    "$file1_stat_after_first_access" "after accessing file1 first time"
+	"$file1_stat_after_first_access" "after accessing file1 first time"
 
 # Accessing file1 a second time
+sleep 1
 cat $TPATH/dir1/file1 > /dev/null
 file1_stat_after_second_access=`_stat $TPATH/dir1/file1`
 _compare_stat_times NNN "$file1_stat_after_first_access" \
-    "$file1_stat_after_second_access" "after accessing file1 second time"
+	"$file1_stat_after_second_access" "after accessing file1 second time"
 
 # Remounting with nodiratime option
 _scratch_unmount
 _scratch_mount "-o nodiratime"
 file1_stat_after_remount=`_stat $TPATH/dir1/file1`
 _compare_stat_times NNN "$file1_stat_after_second_access" \
-    "$file1_stat_after_remount" "for file1 after remount"
+	"$file1_stat_after_remount" "for file1 after remount"
 
 # Creating dir2 and file2, checking directory stats
 mkdir $TPATH/dir2
 dir2_stat_before_file_creation=`_stat $TPATH/dir2`
+sleep 1
 echo "bbb" > $TPATH/dir2/file2
 dir2_stat_after_file_creation=`_stat $TPATH/dir2`
 _compare_stat_times NYY "$dir2_stat_before_file_creation" \
-    "$dir2_stat_after_file_creation" "for dir2 after file creation"
+	"$dir2_stat_after_file_creation" "for dir2 after file creation"
 
 # Accessing file2
 file2_stat_before_first_access=`_stat $TPATH/dir2/file2`
+sleep 1
 cat $TPATH/dir2/file2 > /dev/null
 file2_stat_after_first_access=`_stat $TPATH/dir2/file2`
 _compare_stat_times YNN "$file2_stat_before_first_access" \
-    "$file2_stat_after_first_access" "after accessing file2"
+	"$file2_stat_after_first_access" "after accessing file2"
 dir2_stat_after_file_access=`_stat $TPATH/dir2`
 _compare_stat_times NNN "$dir2_stat_after_file_creation" \
-    "$dir2_stat_after_file_access" "for dir2 after file access"
+	"$dir2_stat_after_file_access" "for dir2 after file access"
 
 # Remounting with noatime option, creating a file and accessing it
 _scratch_unmount
 _scratch_mount "-o noatime"
 echo "ccc" > $TPATH/dir2/file3
 file3_stat_before_first_access=`_stat $TPATH/dir2/file3`
+sleep 1
 cat $TPATH/dir2/file3 > /dev/null
 file3_stat_after_first_access=`_stat $TPATH/dir2/file3`
 _compare_stat_times NNN "$file3_stat_before_first_access" \
-    "$file3_stat_after_first_access" "after accessing file3 first time"
+	"$file3_stat_after_first_access" "after accessing file3 first time"
 
 # Checking that the modify and change times are still updated
 file1_stat_before_modify=`_stat $TPATH/dir1/file1`
+sleep 1
 echo "xyz" > $TPATH/dir1/file1
 file1_stat_after_modify=`_stat $TPATH/dir1/file1`
 _compare_stat_times NYY "$file1_stat_before_modify" \
-    "$file1_stat_after_modify" "after modifying file1"
+	"$file1_stat_after_modify" "after modifying file1"
+sleep 1
 mv $TPATH/dir1/file1 $TPATH/dir1/file1_renamed
 file1_stat_after_change=`_stat $TPATH/dir1/file1_renamed`
 _compare_stat_times NNY "$file1_stat_after_modify" \
-    "$file1_stat_after_change" "after changing file1"
+	"$file1_stat_after_change" "after changing file1"
 
 # Remounting with strictatime option and
 # accessing a previously created file twice
@@ -155,30 +164,33 @@ _scratch_mount "-o strictatime"
 cat $TPATH/dir2/file3 > /dev/null
 file3_stat_after_second_access=`_stat $TPATH/dir2/file3`
 _compare_stat_times YNN "$file3_stat_after_first_access" \
-    "$file3_stat_after_second_access" "after accessing file3 second time"
+	"$file3_stat_after_second_access" "after accessing file3 second time"
+sleep 1
 cat $TPATH/dir2/file3 > /dev/null
 file3_stat_after_third_access=`_stat $TPATH/dir2/file3`
 _compare_stat_times YNN "$file3_stat_after_second_access" \
-    "$file3_stat_after_third_access" "after accessing file3 third time"
+	"$file3_stat_after_third_access" "after accessing file3 third time"
 
 # Btrfs only: Creating readonly snapshot. Access time should never
 # be updated, even when the strictatime mount option is active
 if [ "$FSTYP" = "btrfs" ]; then
-    SPATH=$SCRATCH_MNT/snap1
-    btrfs subvol snapshot -r $TPATH $SPATH >> $seqres.full
-    dir2_stat_readonly_before_access=`_stat $SPATH/dir2`
-    ls $SPATH/dir2 >> $seqres.full
-    cat $SPATH/dir2/file3 >> $seqres.full
-    dir2_stat_readonly_after_access=`_stat $SPATH/dir2`
-    _compare_stat_times NNN "$dir2_stat_readonly_before_access" \
-        "$dir2_stat_readonly_after_access" "for dir in readonly subvol"
-    file3_stat_readonly_after_access=`_stat $SPATH/dir2/file3`
-    _compare_stat_times NNN "$file3_stat_after_third_access" \
-        "$file3_stat_readonly_after_access" "for file in readonly subvol"
+	SPATH=$SCRATCH_MNT/snap1
+	btrfs subvol snapshot -r $TPATH $SPATH >> $seqres.full
+	dir2_stat_readonly_before_access=`_stat $SPATH/dir2`
+	sleep 1
+	ls $SPATH/dir2 >> $seqres.full
+	cat $SPATH/dir2/file3 >> $seqres.full
+	dir2_stat_readonly_after_access=`_stat $SPATH/dir2`
+	_compare_stat_times NNN "$dir2_stat_readonly_before_access" \
+		"$dir2_stat_readonly_after_access" "for dir in readonly subvol"
+	file3_stat_readonly_after_access=`_stat $SPATH/dir2/file3`
+	_compare_stat_times NNN "$file3_stat_after_third_access" \
+		"$file3_stat_readonly_after_access" "for file in readonly subvol"
 fi
 
 # Remounting read-only. Access time should never be updated, despite the
 # strictatime mount option.
+sleep 1
 dir2_stat_before_ro_mount=`_stat $TPATH/dir2`
 file3_stat_before_ro_mount=`_stat $TPATH/dir2/file3`
 _scratch_unmount
@@ -187,10 +199,10 @@ ls $TPATH/dir2 > /dev/null
 cat $TPATH/dir2/file3 > /dev/null
 dir2_stat_after_ro_mount=`_stat $TPATH/dir2`
 _compare_stat_times NNN "$dir2_stat_before_ro_mount" \
-    "$dir2_stat_after_ro_mount" "for dir in read-only filesystem"
+	"$dir2_stat_after_ro_mount" "for dir in read-only filesystem"
 file3_stat_after_ro_mount=`_stat $TPATH/dir2/file3`
 _compare_stat_times NNN "$file3_stat_before_ro_mount" \
-    "$file3_stat_after_ro_mount" "for file in read-only filesystem"
+	"$file3_stat_after_ro_mount" "for file in read-only filesystem"
 
 # success, all done
 _scratch_unmount
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
