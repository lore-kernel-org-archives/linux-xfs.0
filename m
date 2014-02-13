Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A65357F58
	for <xfs@oss.sgi.com>; Thu, 13 Feb 2014 09:23:47 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8B53E8F8039
	for <xfs@oss.sgi.com>; Thu, 13 Feb 2014 07:23:47 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id IyTVOwcfTGMzk3n8 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 13 Feb 2014 07:23:43 -0800 (PST)
From: Koen De Wit <koen.de.wit@oracle.com>
Subject: [PATCH] xfstests: test for atime-related mount options
Date: Thu, 13 Feb 2014 16:23:36 +0100
Message-Id: <1392305016-7424-1-git-send-email-koen.de.wit@oracle.com>
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
Cc: Koen De Wit <koen.de.wit@oracle.com>, linux-btrfs@vger.kernel.org

Tests the noatime, relatime, strictatime and nodiratime mount options.

There is an extra check for Btrfs to ensure that the access time is
never updated on read-only subvolumes. (Regression test for bug fixed
with commit 93fd63c2f001ca6797c6b15b696a484b165b4800)

Signed-off-by: Koen De Wit <koen.de.wit@oracle.com>
---
 tests/generic/323     |  186 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/323.out |    2 +
 tests/generic/group   |    1 +
 3 files changed, 189 insertions(+), 0 deletions(-)
 create mode 100644 tests/generic/323
 create mode 100644 tests/generic/323.out

diff --git a/tests/generic/323 b/tests/generic/323
new file mode 100644
index 0000000..423b141
--- /dev/null
+++ b/tests/generic/323
@@ -0,0 +1,186 @@
+# Tests the noatime, relatime, strictatime and nodiratime mount options.
+# There is an extra check for Btrfs to ensure that the access time is
+# never updated on read-only subvolumes. (Regression test for bug fixed
+# with commit 93fd63c2f001ca6797c6b15b696a484b165b4800)
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2014, Oracle and/or its affiliates.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#-----------------------------------------------------------------------
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    rm -f $*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+
+_supported_fs generic
+_supported_os Linux
+_require_scratch
+
+rm -f $seqres.full
+
+_stat() {
+    stat --printf="%x;%y;%z" $1
+}
+
+_compare_stat_times() {
+    updated=$1      # 3 chars indicating if access, modify and
+                    # change times should be updated (Y) or not (N)
+    IFS=';' read -a first_stat <<< "$2"   # Convert first stat to array
+    IFS=';' read -a second_stat <<< "$3"  # Convert second stat to array
+    test_step=$4    # Will be printed to output stream in case of an
+                    # error, to make debugging easier
+    types=( access modify change )
+
+    for i in 0 1 2; do
+        if [ "${first_stat[$i]}" == "${second_stat[$i]}" ]; then
+            if [ "${updated:$i:1}" == "Y" ]; then
+                echo -n "ERROR: ${types[$i]} time has not been updated "
+                echo $test_step
+            fi
+        else
+            if [ "${updated:$i:1}" == "N" ]; then
+                echo -n "ERROR: ${types[$i]} time has changed "
+                echo $test_step
+            fi
+        fi
+    done
+}
+
+_scratch_mkfs >> $seqres.full 2>&1 || _fail "mkfs failed"
+_scratch_mount
+
+cat /proc/mounts | grep "$SCRATCH_MNT" | grep relatime >> $seqres.full
+[ $? -ne 0 ] && echo "The relatime mount option should be the default."
+
+if [ "$FSTYP" = "btrfs" ]; then
+    TPATH=$SCRATCH_MNT/sub1
+    $BTRFS_UTIL_PROG subvolume create $TPATH > $seqres.full
+else
+    TPATH=$SCRATCH_MNT
+fi
+
+mkdir $TPATH/dir1
+echo "aaa" > $TPATH/dir1/file1
+file1_stat_before_first_access=`_stat $TPATH/dir1/file1`
+
+# Accessing file1 the first time
+cat $TPATH/dir1/file1 > /dev/null
+file1_stat_after_first_access=`_stat $TPATH/dir1/file1`
+_compare_stat_times YNN "$file1_stat_before_first_access" \
+    "$file1_stat_after_first_access" "after accessing file1 first time"
+
+# Accessing file1 a second time
+cat $TPATH/dir1/file1 > /dev/null
+file1_stat_after_second_access=`_stat $TPATH/dir1/file1`
+_compare_stat_times NNN "$file1_stat_after_first_access" \
+    "$file1_stat_after_second_access" "after accessing file1 second time"
+
+# Remounting with nodiratime option
+_scratch_unmount
+_scratch_mount "-o nodiratime"
+file1_stat_after_remount=`_stat $TPATH/dir1/file1`
+_compare_stat_times NNN "$file1_stat_after_second_access" \
+    "$file1_stat_after_remount" "for file1 after remount"
+
+# Creating dir2 and file2, checking directory stats
+mkdir $TPATH/dir2
+dir2_stat_before_file_creation=`_stat $TPATH/dir2`
+echo "bbb" > $TPATH/dir2/file2
+dir2_stat_after_file_creation=`_stat $TPATH/dir2`
+_compare_stat_times NYY "$dir2_stat_before_file_creation" \
+    "$dir2_stat_after_file_creation" "for dir2 after file creation"
+
+# Accessing file2
+file2_stat_before_first_access=`_stat $TPATH/dir2/file2`
+cat $TPATH/dir2/file2 > /dev/null
+file2_stat_after_first_access=`_stat $TPATH/dir2/file2`
+_compare_stat_times YNN "$file2_stat_before_first_access" \
+    "$file2_stat_after_first_access" "after accessing file2"
+dir2_stat_after_file_access=`_stat $TPATH/dir2`
+_compare_stat_times NNN "$dir2_stat_after_file_creation" \
+    "$dir2_stat_after_file_access" "for dir2 after file access"
+
+# Remounting with noatime option, creating a file and accessing it
+_scratch_unmount
+_scratch_mount "-o noatime"
+echo "ccc" > $TPATH/dir2/file3
+file3_stat_before_first_access=`_stat $TPATH/dir2/file3`
+cat $TPATH/dir2/file3 > /dev/null
+file3_stat_after_first_access=`_stat $TPATH/dir2/file3`
+_compare_stat_times NNN "$file3_stat_before_first_access" \
+    "$file3_stat_after_first_access" "after accessing file3 first time"
+
+# Checking that the modify and change times are still updated
+file1_stat_before_modify=`_stat $TPATH/dir1/file1`
+echo "xyz" > $TPATH/dir1/file1
+file1_stat_after_modify=`_stat $TPATH/dir1/file1`
+_compare_stat_times NYY "$file1_stat_before_modify" \
+    "$file1_stat_after_modify" "after modifying file1"
+mv $TPATH/dir1/file1 $TPATH/dir1/file1_renamed
+file1_stat_after_change=`_stat $TPATH/dir1/file1_renamed`
+_compare_stat_times NNY "$file1_stat_after_modify" \
+    "$file1_stat_after_change" "after changing file1"
+
+# Remounting with strictatime option and
+# accessing a previously created file twice
+_scratch_unmount
+_scratch_mount "-o strictatime"
+cat $TPATH/dir2/file3 > /dev/null
+file3_stat_after_second_access=`_stat $TPATH/dir2/file3`
+_compare_stat_times YNN "$file3_stat_after_first_access" \
+    "$file3_stat_after_second_access" "after accessing file3 second time"
+cat $TPATH/dir2/file3 > /dev/null
+file3_stat_after_third_access=`_stat $TPATH/dir2/file3`
+_compare_stat_times YNN "$file3_stat_after_second_access" \
+    "$file3_stat_after_third_access" "after accessing file3 third time"
+
+# Btrfs only: Creating readonly snapshot. Access time should never
+# be updated, even when the strictatime mount option is active
+if [ "$FSTYP" = "btrfs" ]; then
+    SPATH=$SCRATCH_MNT/snap1
+    btrfs subvol snapshot -r $TPATH $SPATH >> $seqres.full
+    dir2_stat_readonly_before_access=`_stat $SPATH/dir2`
+    ls $SPATH/dir2 >> $seqres.full
+    cat $SPATH/dir2/file3 >> $seqres.full
+    dir2_stat_readonly_after_access=`_stat $SPATH/dir2`
+    _compare_stat_times NNN "$dir2_stat_readonly_before_access" \
+        "$dir2_stat_readonly_after_access" "for dir in readonly subvol"
+    file3_stat_readonly_after_access=`_stat $SPATH/dir2/file3`
+    _compare_stat_times NNN "$file3_stat_after_third_access" \
+        "$file3_stat_readonly_after_access" "for file in readonly subvol"
+fi
+
+# success, all done
+_scratch_unmount
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/generic/323.out b/tests/generic/323.out
new file mode 100644
index 0000000..5dba9b5
--- /dev/null
+++ b/tests/generic/323.out
@@ -0,0 +1,2 @@
+QA output created by 323
+Silence is golden
diff --git a/tests/generic/group b/tests/generic/group
index f492461..3a72ee4 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -125,3 +125,4 @@
 320 auto rw
 321 auto quick metadata log
 322 auto quick metadata log
+323 atime auto quick
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
