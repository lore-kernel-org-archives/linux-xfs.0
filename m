Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9LIwvv4054730 for <xfs@oss.sgi.com>; Thu, 21 Oct 2010 13:58:57 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201010211900.o9LJ086G002762@stout.americas.sgi.com>
Date: Thu, 21 Oct 2010 14:00:08 -0500
Subject: xfstests: use a common _filter_scratch function
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

There are a number of tests that use a shell function called
"filter_scratch" or "_filter_scratch" in order to have the actual
scratch device or mount point show up in test output with a symbolic
name.  There are two sets, each following a slightly different
convention.  Put a common _filter_scratch function definition in
"common.filter" and have all test scripts use that instead.
Choosing one of the two conventions meant that a few test output
files had to be changed.

In addition, add a call to _filter_scratch to test 185, and update
its output accordingly.

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 062           |    5 -----
 103           |    5 -----
 108           |   18 +++++-------------
 108.out       |   48 ++++++++++++++++++++++++------------------------
 185           |    6 +++---
 185.out       |   30 +++++++++++++++---------------
 200           |    6 ------
 219           |   14 +++-----------
 219.out       |   28 ++++++++++++++--------------
 223           |    5 -----
 230           |   14 +++-----------
 230.out       |    8 ++++----
 231           |    8 --------
 232           |    8 --------
 233           |    8 --------
 235           |   18 +++++-------------
 235.out       |   10 +++++-----
 common.filter |    5 +++++
 common.quota  |    8 ++++----
 19 files changed, 90 insertions(+), 162 deletions(-)

Index: b/062
===================================================================
--- a/062
+++ b/062
@@ -45,11 +45,6 @@ _cleanup()
 }
 trap "_cleanup; exit \$status" 0 1 2 3 15
 
-_filter_scratch()
-{
-	    sed -e "s,$SCRATCH_MNT,SCRATCH_MNT,g"
-}
-
 _linux_attr_calls()
 {
     echo "*** set/get one initially empty attribute"
Index: b/103
===================================================================
--- a/103
+++ b/103
@@ -54,11 +54,6 @@ _create_scratch()
 	fi
 }
 
-_filter_scratch()
-{
-	sed -e "s,$SCRATCH_MNT,SCRATCH_MNT,g"
-}
-
 _filter_ln()
 {
     sed -e "s,SCRATCH_MNT/nosymlink/target - Operation not permitted,ln: creating symbolic link \`SCRATCH_MNT/nosymlink/target\' to \`SCRATCH_MNT/nosymlink/source\': Operation not permitted,g" \
Index: b/108
===================================================================
--- a/108
+++ b/108
@@ -37,14 +37,6 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2
 . ./common.filter
 . ./common.quota
 
-filter_scratch()
-{
-	perl -ne "
-s,$SCRATCH_MNT,[SCR_MNT],;
-s,$SCRATCH_DEV,[SCR_DEV],;
-	print;"
-}
-
 # real QA test starts here
 _supported_fs xfs
 _supported_os Linux #IRIX
@@ -59,7 +51,7 @@ test_files()
 	chown $uid $SCRATCH_MNT/{buffer,direct,mmap}
 	chgrp $gid $SCRATCH_MNT/{buffer,direct,mmap}
 	for file in $SCRATCH_MNT/{buffer,direct,mmap}; do
-		$here/src/lstat64 $file | head -3 | filter_scratch
+		$here/src/lstat64 $file | head -3 | _filter_scratch
 		$XFS_IO_PROG -c lsproj $file
 	done
 }
@@ -78,11 +70,11 @@ test_accounting()
 	echo "--- completed parallel IO ($type)" >>$seq.full
 
 	for file in $SCRATCH_MNT/{buffer,direct,mmap}; do
-		$here/src/lstat64 $file | head -3 | filter_scratch
+		$here/src/lstat64 $file | head -3 | _filter_scratch
 	done
-	xfs_quota -c "quota -hnb -$type $id" $QARGS | filter_scratch
-	xfs_quota -c "quota -hni -$type $id" $QARGS | filter_scratch
-	xfs_quota -c "quota -hnr -$type $id" $QARGS | filter_scratch
+	xfs_quota -c "quota -hnb -$type $id" $QARGS | _filter_scratch
+	xfs_quota -c "quota -hni -$type $id" $QARGS | _filter_scratch
+	xfs_quota -c "quota -hnr -$type $id" $QARGS | _filter_scratch
 }
 
 export MOUNT_OPTIONS="-opquota"
Index: b/108.out
===================================================================
--- a/108.out
+++ b/108.out
@@ -9,93 +9,93 @@ realtime =RDEV extsz=XXX blocks=XXX, rte
 ### test user accounting
 
 ### create files, setting up ownership (type=u)
-  File: "[SCR_MNT]/buffer"
+  File: "SCRATCH_MNT/buffer"
   Size: 0            Filetype: Regular File
   Mode: (0600/-rw-------)         Uid: (1)  Gid: (2)
 projid = 3
-  File: "[SCR_MNT]/direct"
+  File: "SCRATCH_MNT/direct"
   Size: 0            Filetype: Regular File
   Mode: (0600/-rw-------)         Uid: (1)  Gid: (2)
 projid = 3
-  File: "[SCR_MNT]/mmap"
+  File: "SCRATCH_MNT/mmap"
   Size: 0            Filetype: Regular File
   Mode: (0600/-rw-------)         Uid: (1)  Gid: (2)
 projid = 3
 ### some controlled buffered, direct and mmapd IO (type=u)
-  File: "[SCR_MNT]/buffer"
+  File: "SCRATCH_MNT/buffer"
   Size: 16777216     Filetype: Regular File
   Mode: (0600/-rw-------)         Uid: (1)  Gid: (2)
-  File: "[SCR_MNT]/direct"
+  File: "SCRATCH_MNT/direct"
   Size: 16777216     Filetype: Regular File
   Mode: (0600/-rw-------)         Uid: (1)  Gid: (2)
-  File: "[SCR_MNT]/mmap"
+  File: "SCRATCH_MNT/mmap"
   Size: 16777216     Filetype: Regular File
   Mode: (0600/-rw-------)         Uid: (1)  Gid: (2)
 Disk quotas for User #1 (1)
 Filesystem   Blocks  Quota  Limit Warn/Time    Mounted on
-[SCR_DEV]       48M      0      0  00 [------] [SCR_MNT]
+SCRATCH_DEV        48M      0      0  00 [------] SCRATCH_MNT
 Disk quotas for User #1 (1)
 Filesystem    Files  Quota  Limit Warn/Time    Mounted on
-[SCR_DEV]         3      0      0  00 [------] [SCR_MNT]
+SCRATCH_DEV          3      0      0  00 [------] SCRATCH_MNT
 
 ### test group accounting
 
 ### create files, setting up ownership (type=g)
-  File: "[SCR_MNT]/buffer"
+  File: "SCRATCH_MNT/buffer"
   Size: 0            Filetype: Regular File
   Mode: (0600/-rw-------)         Uid: (1)  Gid: (2)
 projid = 3
-  File: "[SCR_MNT]/direct"
+  File: "SCRATCH_MNT/direct"
   Size: 0            Filetype: Regular File
   Mode: (0600/-rw-------)         Uid: (1)  Gid: (2)
 projid = 3
-  File: "[SCR_MNT]/mmap"
+  File: "SCRATCH_MNT/mmap"
   Size: 0            Filetype: Regular File
   Mode: (0600/-rw-------)         Uid: (1)  Gid: (2)
 projid = 3
 ### some controlled buffered, direct and mmapd IO (type=g)
-  File: "[SCR_MNT]/buffer"
+  File: "SCRATCH_MNT/buffer"
   Size: 16777216     Filetype: Regular File
   Mode: (0600/-rw-------)         Uid: (1)  Gid: (2)
-  File: "[SCR_MNT]/direct"
+  File: "SCRATCH_MNT/direct"
   Size: 16777216     Filetype: Regular File
   Mode: (0600/-rw-------)         Uid: (1)  Gid: (2)
-  File: "[SCR_MNT]/mmap"
+  File: "SCRATCH_MNT/mmap"
   Size: 16777216     Filetype: Regular File
   Mode: (0600/-rw-------)         Uid: (1)  Gid: (2)
 Disk quotas for Group #2 (2)
 Filesystem   Blocks  Quota  Limit Warn/Time    Mounted on
-[SCR_DEV]       48M      0      0  00 [------] [SCR_MNT]
+SCRATCH_DEV        48M      0      0  00 [------] SCRATCH_MNT
 Disk quotas for Group #2 (2)
 Filesystem    Files  Quota  Limit Warn/Time    Mounted on
-[SCR_DEV]         3      0      0  00 [------] [SCR_MNT]
+SCRATCH_DEV          3      0      0  00 [------] SCRATCH_MNT
 
 ### create files, setting up ownership (type=p)
-  File: "[SCR_MNT]/buffer"
+  File: "SCRATCH_MNT/buffer"
   Size: 0            Filetype: Regular File
   Mode: (0600/-rw-------)         Uid: (1)  Gid: (2)
 projid = 3
-  File: "[SCR_MNT]/direct"
+  File: "SCRATCH_MNT/direct"
   Size: 0            Filetype: Regular File
   Mode: (0600/-rw-------)         Uid: (1)  Gid: (2)
 projid = 3
-  File: "[SCR_MNT]/mmap"
+  File: "SCRATCH_MNT/mmap"
   Size: 0            Filetype: Regular File
   Mode: (0600/-rw-------)         Uid: (1)  Gid: (2)
 projid = 3
 ### some controlled buffered, direct and mmapd IO (type=p)
-  File: "[SCR_MNT]/buffer"
+  File: "SCRATCH_MNT/buffer"
   Size: 16777216     Filetype: Regular File
   Mode: (0600/-rw-------)         Uid: (1)  Gid: (2)
-  File: "[SCR_MNT]/direct"
+  File: "SCRATCH_MNT/direct"
   Size: 16777216     Filetype: Regular File
   Mode: (0600/-rw-------)         Uid: (1)  Gid: (2)
-  File: "[SCR_MNT]/mmap"
+  File: "SCRATCH_MNT/mmap"
   Size: 16777216     Filetype: Regular File
   Mode: (0600/-rw-------)         Uid: (1)  Gid: (2)
 Disk quotas for Project #3 (3)
 Filesystem   Blocks  Quota  Limit Warn/Time    Mounted on
-[SCR_DEV]       48M      0      0  00 [------] [SCR_MNT]
+SCRATCH_DEV        48M      0      0  00 [------] SCRATCH_MNT
 Disk quotas for Project #3 (3)
 Filesystem    Files  Quota  Limit Warn/Time    Mounted on
-[SCR_DEV]         3      0      0  00 [------] [SCR_MNT]
+SCRATCH_DEV          3      0      0  00 [------] SCRATCH_MNT
Index: b/185
===================================================================
--- a/185
+++ b/185
@@ -71,14 +71,14 @@ cat $tmp.dmapi-param | sed s/'\#.*'//g| 
 
 	echo "Method:	xfsctl"
 	dd if=/dev/zero bs=1024k count=3 of=$f >/dev/null 2>&1
-	$e -x -l$l -o$o $f
+	$e -x -l$l -o$o $f | _filter_scratch
 
 	echo "Method:	dmapi_probe"
 	dd if=/dev/zero bs=1024k count=3 of=$f >/dev/null 2>&1
-	$e -l$l -o$o $f
+	$e -l$l -o$o $f | _filter_scratch
 
 	echo "Method:	dmapi_punch"
-	$e -p -l$l -o$o $f 
+	$e -p -l$l -o$o $f | _filter_scratch
 	echo "======================================================="
 done
 
Index: b/185.out
===================================================================
--- a/185.out
+++ b/185.out
@@ -2,70 +2,70 @@ QA output created by 185
 =======================================================
 Testing with length = 16k, offset = 0
 Method:	xfsctl
-Running Punch hole with xfsctl(XFS_IOC_FREESP64) on /mnt/scratch/dmapi/holly_file with settings:
+Running Punch hole with xfsctl(XFS_IOC_FREESP64) on SCRATCH_MNT/dmapi/holly_file with settings:
   offset = '0', length = '16384', sid = '0'
 ok.
 Method:	dmapi_probe
-Running DMAPI probe hole on /mnt/scratch/dmapi/holly_file with settings:
+Running DMAPI probe hole on SCRATCH_MNT/dmapi/holly_file with settings:
   offset = '0', length = '16384', sid = '0'
 roffp is 0, rlenp is 16384
 Method:	dmapi_punch
-Running DMAPI punch hole on /mnt/scratch/dmapi/holly_file with settings:
+Running DMAPI punch hole on SCRATCH_MNT/dmapi/holly_file with settings:
   offset = '0', length = '16384', sid = '0'
 =======================================================
 =======================================================
 Testing with length = 1k, offset = 0
 Method:	xfsctl
-Running Punch hole with xfsctl(XFS_IOC_FREESP64) on /mnt/scratch/dmapi/holly_file with settings:
+Running Punch hole with xfsctl(XFS_IOC_FREESP64) on SCRATCH_MNT/dmapi/holly_file with settings:
   offset = '0', length = '1024', sid = '0'
 ok.
 Method:	dmapi_probe
-Running DMAPI probe hole on /mnt/scratch/dmapi/holly_file with settings:
+Running DMAPI probe hole on SCRATCH_MNT/dmapi/holly_file with settings:
   offset = '0', length = '1024', sid = '0'
 roffp is 0, rlenp is 1024
 Method:	dmapi_punch
-Running DMAPI punch hole on /mnt/scratch/dmapi/holly_file with settings:
+Running DMAPI punch hole on SCRATCH_MNT/dmapi/holly_file with settings:
   offset = '0', length = '1024', sid = '0'
 =======================================================
 =======================================================
 Testing with length = 1k, offset = 4k
 Method:	xfsctl
-Running Punch hole with xfsctl(XFS_IOC_FREESP64) on /mnt/scratch/dmapi/holly_file with settings:
+Running Punch hole with xfsctl(XFS_IOC_FREESP64) on SCRATCH_MNT/dmapi/holly_file with settings:
   offset = '4096', length = '1024', sid = '0'
 ok.
 Method:	dmapi_probe
-Running DMAPI probe hole on /mnt/scratch/dmapi/holly_file with settings:
+Running DMAPI probe hole on SCRATCH_MNT/dmapi/holly_file with settings:
   offset = '4096', length = '1024', sid = '0'
 roffp is 4096, rlenp is 1024
 Method:	dmapi_punch
-Running DMAPI punch hole on /mnt/scratch/dmapi/holly_file with settings:
+Running DMAPI punch hole on SCRATCH_MNT/dmapi/holly_file with settings:
   offset = '4096', length = '1024', sid = '0'
 =======================================================
 =======================================================
 Testing with length = 4k, offset = 1k
 Method:	xfsctl
-Running Punch hole with xfsctl(XFS_IOC_FREESP64) on /mnt/scratch/dmapi/holly_file with settings:
+Running Punch hole with xfsctl(XFS_IOC_FREESP64) on SCRATCH_MNT/dmapi/holly_file with settings:
   offset = '1024', length = '4096', sid = '0'
 ok.
 Method:	dmapi_probe
-Running DMAPI probe hole on /mnt/scratch/dmapi/holly_file with settings:
+Running DMAPI probe hole on SCRATCH_MNT/dmapi/holly_file with settings:
   offset = '1024', length = '4096', sid = '0'
 roffp is 1024, rlenp is 4096
 Method:	dmapi_punch
-Running DMAPI punch hole on /mnt/scratch/dmapi/holly_file with settings:
+Running DMAPI punch hole on SCRATCH_MNT/dmapi/holly_file with settings:
   offset = '1024', length = '4096', sid = '0'
 =======================================================
 =======================================================
 Testing with length = 1024k, offset = 512k
 Method:	xfsctl
-Running Punch hole with xfsctl(XFS_IOC_FREESP64) on /mnt/scratch/dmapi/holly_file with settings:
+Running Punch hole with xfsctl(XFS_IOC_FREESP64) on SCRATCH_MNT/dmapi/holly_file with settings:
   offset = '524288', length = '1048576', sid = '0'
 ok.
 Method:	dmapi_probe
-Running DMAPI probe hole on /mnt/scratch/dmapi/holly_file with settings:
+Running DMAPI probe hole on SCRATCH_MNT/dmapi/holly_file with settings:
   offset = '524288', length = '1048576', sid = '0'
 roffp is 524288, rlenp is 1048576
 Method:	dmapi_punch
-Running DMAPI punch hole on /mnt/scratch/dmapi/holly_file with settings:
+Running DMAPI punch hole on SCRATCH_MNT/dmapi/holly_file with settings:
   offset = '524288', length = '1048576', sid = '0'
 =======================================================
Index: b/200
===================================================================
--- a/200
+++ b/200
@@ -30,12 +30,6 @@ here=`pwd`
 tmp=/tmp/$$
 status=1	# failure is the default!
 
-_filter_scratch()
-{
-	sed -e "s,$SCRATCH_DEV,SCRATCH_DEV,g" | \
-		sed -e "s,$SCRATCH_MNT,SCRATCH_MNT,g"
-}
-
 _cleanup()
 {
 	cd /
Index: b/219
===================================================================
--- a/219
+++ b/219
@@ -40,14 +40,6 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2
 . ./common.filter
 . ./common.quota
 
-filter_scratch()
-{
-	perl -ne "
-s,$SCRATCH_MNT,[SCR_MNT],;
-s,$SCRATCH_DEV,[SCR_DEV],;
-	print;"
-}
-
 # real QA test starts here
 _supported_fs generic
 _supported_os Linux #IRIX
@@ -62,7 +54,7 @@ test_files()
 	chown $uid $SCRATCH_MNT/{buffer,direct,mmap}
 	chgrp $gid $SCRATCH_MNT/{buffer,direct,mmap}
 	for file in $SCRATCH_MNT/{buffer,direct,mmap}; do
-		$here/src/lstat64 $file | head -3 | filter_scratch
+		$here/src/lstat64 $file | head -3 | _filter_scratch
 	done
 }
 
@@ -82,10 +74,10 @@ test_accounting()
 	echo "--- completed parallel IO ($type)" >>$seq.full
 
 	for file in $SCRATCH_MNT/{buffer,direct,mmap}; do
-		$here/src/lstat64 $file | head -3 | filter_scratch
+		$here/src/lstat64 $file | head -3 | _filter_scratch
 	done
 
-	repquota -$type -n $SCRATCH_MNT  | grep -v "^#0" | filter_scratch |
+	repquota -$type -n $SCRATCH_MNT  | grep -v "^#0" | _filter_scratch |
 	awk '/^#/ { if (seen[$1]) next; seen[$1]++; } { print; }'
 }
 
Index: b/219.out
===================================================================
--- a/219.out
+++ b/219.out
@@ -3,26 +3,26 @@ QA output created by 219
 ### test user accounting
 
 ### create files, setting up ownership (type=u)
-  File: "[SCR_MNT]/buffer"
+  File: "SCRATCH_MNT/buffer"
   Size: 0            Filetype: Regular File
   Mode: (0644/-rw-r--r--)         Uid: (1)  Gid: (2)
-  File: "[SCR_MNT]/direct"
+  File: "SCRATCH_MNT/direct"
   Size: 0            Filetype: Regular File
   Mode: (0644/-rw-r--r--)         Uid: (1)  Gid: (2)
-  File: "[SCR_MNT]/mmap"
+  File: "SCRATCH_MNT/mmap"
   Size: 0            Filetype: Regular File
   Mode: (0644/-rw-r--r--)         Uid: (1)  Gid: (2)
 ### some controlled buffered, direct and mmapd IO (type=u)
-  File: "[SCR_MNT]/buffer"
+  File: "SCRATCH_MNT/buffer"
   Size: 49152        Filetype: Regular File
   Mode: (0644/-rw-r--r--)         Uid: (1)  Gid: (2)
-  File: "[SCR_MNT]/direct"
+  File: "SCRATCH_MNT/direct"
   Size: 49152        Filetype: Regular File
   Mode: (0644/-rw-r--r--)         Uid: (1)  Gid: (2)
-  File: "[SCR_MNT]/mmap"
+  File: "SCRATCH_MNT/mmap"
   Size: 49152        Filetype: Regular File
   Mode: (0644/-rw-r--r--)         Uid: (1)  Gid: (2)
-*** Report for user quotas on device [SCR_DEV]
+*** Report for user quotas on device SCRATCH_DEV
 Block grace time: 7days; Inode grace time: 7days
                         Block limits                File limits
 User            used    soft    hard  grace    used  soft  hard  grace
@@ -34,26 +34,26 @@ User            used    soft    hard  gr
 ### test group accounting
 
 ### create files, setting up ownership (type=g)
-  File: "[SCR_MNT]/buffer"
+  File: "SCRATCH_MNT/buffer"
   Size: 0            Filetype: Regular File
   Mode: (0644/-rw-r--r--)         Uid: (1)  Gid: (2)
-  File: "[SCR_MNT]/direct"
+  File: "SCRATCH_MNT/direct"
   Size: 0            Filetype: Regular File
   Mode: (0644/-rw-r--r--)         Uid: (1)  Gid: (2)
-  File: "[SCR_MNT]/mmap"
+  File: "SCRATCH_MNT/mmap"
   Size: 0            Filetype: Regular File
   Mode: (0644/-rw-r--r--)         Uid: (1)  Gid: (2)
 ### some controlled buffered, direct and mmapd IO (type=g)
-  File: "[SCR_MNT]/buffer"
+  File: "SCRATCH_MNT/buffer"
   Size: 49152        Filetype: Regular File
   Mode: (0644/-rw-r--r--)         Uid: (1)  Gid: (2)
-  File: "[SCR_MNT]/direct"
+  File: "SCRATCH_MNT/direct"
   Size: 49152        Filetype: Regular File
   Mode: (0644/-rw-r--r--)         Uid: (1)  Gid: (2)
-  File: "[SCR_MNT]/mmap"
+  File: "SCRATCH_MNT/mmap"
   Size: 49152        Filetype: Regular File
   Mode: (0644/-rw-r--r--)         Uid: (1)  Gid: (2)
-*** Report for group quotas on device [SCR_DEV]
+*** Report for group quotas on device SCRATCH_DEV
 Block grace time: 7days; Inode grace time: 7days
                         Block limits                File limits
 Group           used    soft    hard  grace    used  soft  hard  grace
Index: b/223
===================================================================
--- a/223
+++ b/223
@@ -51,11 +51,6 @@ _require_xfs_io_falloc
 
 rm -f $seq.full
 
-_filter_scratch()
-{
-	sed -e "s,$SCRATCH_MNT,SCRATCH_MNT,g"
-}
-
 BLOCKSIZE=4096
 
 for SUNIT_K in 8 16 32 64 128; do
Index: b/230
===================================================================
--- a/230
+++ b/230
@@ -40,14 +40,6 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2
 . ./common.filter
 . ./common.quota
 
-filter_scratch()
-{
-	perl -ne "
-s,$SCRATCH_MNT,[SCR_MNT],;
-s,$SCRATCH_DEV,[SCR_DEV],;
-	print;"
-}
-
 # real QA test starts here
 _supported_fs generic
 _supported_os Linux #IRIX
@@ -96,19 +88,19 @@ test_enforcement()
 	setquota -$type $qa_user 0 0 3 5 $SCRATCH_MNT
 	echo "Touch 3+4"
 	su $qa_user -c "touch $SCRATCH_MNT/file3 $SCRATCH_MNT/file4" \
-		2>&1 >>$seq.full | filter_scratch | tee -a $seq.full
+		2>&1 >>$seq.full | _filter_scratch | tee -a $seq.full
 	repquota -$type $SCRATCH_MNT  | grep -v "^root" >>$seq.full 2>&1
 	# Try to exceed inode hardlimit
 	echo "Touch 5+6"
 	su $qa_user -c "touch $SCRATCH_MNT/file5 $SCRATCH_MNT/file6" \
-		2>&1 >>$seq.full | filter_scratch | tee -a $seq.full
+		2>&1 >>$seq.full | _filter_scratch | tee -a $seq.full
 	repquota -$type $SCRATCH_MNT  | grep -v "^root" >>$seq.full 2>&1
 	# Wait and check grace time enforcement
 	rm -f $SCRATCH_MNT/file5 >>$seq.full 2>&1
 	sleep $((grace+1))
 	echo "Touch 5"
 	su $qa_user -c "touch $SCRATCH_MNT/file5" 2>&1 >>$seq.full |
-		filter_scratch | tee -a $seq.full
+		_filter_scratch | tee -a $seq.full
 	repquota -$type $SCRATCH_MNT  | grep -v "^root" >>$seq.full 2>&1
 	echo "--- completed IO ($type)" >>$seq.full
 }
Index: b/230.out
===================================================================
--- a/230.out
+++ b/230.out
@@ -12,9 +12,9 @@ Write 4096...
 pwrite64: Disk quota exceeded
 Touch 3+4
 Touch 5+6
-touch: cannot touch `[SCR_MNT]/file6': Disk quota exceeded
+touch: cannot touch `SCRATCH_MNT/file6': Disk quota exceeded
 Touch 5
-touch: cannot touch `[SCR_MNT]/file5': Disk quota exceeded
+touch: cannot touch `SCRATCH_MNT/file5': Disk quota exceeded
 
 ### test group limit enforcement
 
@@ -28,6 +28,6 @@ Write 4096...
 pwrite64: Disk quota exceeded
 Touch 3+4
 Touch 5+6
-touch: cannot touch `[SCR_MNT]/file6': Disk quota exceeded
+touch: cannot touch `SCRATCH_MNT/file6': Disk quota exceeded
 Touch 5
-touch: cannot touch `[SCR_MNT]/file5': Disk quota exceeded
+touch: cannot touch `SCRATCH_MNT/file5': Disk quota exceeded
Index: b/231
===================================================================
--- a/231
+++ b/231
@@ -41,14 +41,6 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2
 FSX_FILE_SIZE=64000000
 FSX_ARGS="-q -l $FSX_FILE_SIZE -o 65536 -N 20000"
 
-filter_scratch()
-{
-        perl -ne "
-s,$SCRATCH_MNT,[SCR_MNT],;
-s,$SCRATCH_DEV,[SCR_DEV],;
-        print;"
-}
-
 _fsx()
 {
 	tasks=$1
Index: b/232
===================================================================
--- a/232
+++ b/232
@@ -38,14 +38,6 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2
 . ./common.filter
 . ./common.quota
 
-filter_scratch()
-{
-        perl -ne "
-s,$SCRATCH_MNT,[SCR_MNT],;
-s,$SCRATCH_DEV,[SCR_DEV],;
-        print;"
-}
-
 _filter_num()
 {
 	tee -a $here/$seq.full |\
Index: b/233
===================================================================
--- a/233
+++ b/233
@@ -42,14 +42,6 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2
 FSX_FILE_SIZE=64000000
 FSX_ARGS="-q -l $FSX_FILE_SIZE -o 65536 -S 191110531 -N 100000"
 
-filter_scratch()
-{
-        perl -ne "
-s,$SCRATCH_MNT,[SCR_MNT],;
-s,$SCRATCH_DEV,[SCR_DEV],;
-        print;"
-}
-
 _filter_num()
 {
 	tee -a $here/$seq.full |\
Index: b/235
===================================================================
--- a/235
+++ b/235
@@ -40,14 +40,6 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2
 . ./common.filter
 . ./common.quota
 
-filter_scratch()
-{
-	perl -ne "
-s,$SCRATCH_MNT,[SCR_MNT],;
-s,$SCRATCH_DEV,[SCR_DEV],;
-	print;"
-}
-
 # real QA test starts here
 _supported_fs generic
 _supported_os Linux #IRIX
@@ -67,15 +59,15 @@ quotaon $SCRATCH_MNT 2>/dev/null
 touch $SCRATCH_MNT/testfile
 chown $qa_user:$qa_user $SCRATCH_MNT/testfile
 
-repquota -u -g $SCRATCH_MNT  | grep -v "^root" | filter_scratch
+repquota -u -g $SCRATCH_MNT  | grep -v "^root" | _filter_scratch
 
-mount -o remount,ro $SCRATCH_DEV 2>&1 | tee -a $seq.full | filter_scratch
-touch $SCRATCH_MNT/failed 2>&1 | tee -a $seq.full | filter_scratch
-mount -o remount,rw $SCRATCH_DEV 2>&1 | tee -a $seq.full | filter_scratch
+mount -o remount,ro $SCRATCH_DEV 2>&1 | tee -a $seq.full | _filter_scratch
+touch $SCRATCH_MNT/failed 2>&1 | tee -a $seq.full | _filter_scratch
+mount -o remount,rw $SCRATCH_DEV 2>&1 | tee -a $seq.full | _filter_scratch
 
 $XFS_IO_PROG -F -c 'pwrite 0 16k' -c 'fsync' \
 			$SCRATCH_MNT/testfile >>$seq.full 2>&1
-repquota -u -g $SCRATCH_MNT  | grep -v "^root" | filter_scratch
+repquota -u -g $SCRATCH_MNT  | grep -v "^root" | _filter_scratch
 
 umount $SCRATCH_DEV 2>/dev/null
 
Index: b/235.out
===================================================================
--- a/235.out
+++ b/235.out
@@ -1,5 +1,5 @@
 QA output created by 235
-*** Report for user quotas on device [SCR_DEV]
+*** Report for user quotas on device SCRATCH_DEV
 Block grace time: 7days; Inode grace time: 7days
                         Block limits                File limits
 User            used    soft    hard  grace    used  soft  hard  grace
@@ -7,7 +7,7 @@ User            used    soft    hard  gr
 fsgqa     --       0       0       0              1     0     0       
 
 
-*** Report for group quotas on device [SCR_DEV]
+*** Report for group quotas on device SCRATCH_DEV
 Block grace time: 7days; Inode grace time: 7days
                         Block limits                File limits
 Group           used    soft    hard  grace    used  soft  hard  grace
@@ -15,8 +15,8 @@ Group           used    soft    hard  gr
 fsgqa     --       0       0       0              1     0     0       
 
 
-touch: cannot touch `[SCR_MNT]/failed': Read-only file system
-*** Report for user quotas on device [SCR_DEV]
+touch: cannot touch `SCRATCH_MNT/failed': Read-only file system
+*** Report for user quotas on device SCRATCH_DEV
 Block grace time: 7days; Inode grace time: 7days
                         Block limits                File limits
 User            used    soft    hard  grace    used  soft  hard  grace
@@ -24,7 +24,7 @@ User            used    soft    hard  gr
 fsgqa     --      16       0       0              1     0     0       
 
 
-*** Report for group quotas on device [SCR_DEV]
+*** Report for group quotas on device SCRATCH_DEV
 Block grace time: 7days; Inode grace time: 7days
                         Block limits                File limits
 Group           used    soft    hard  grace    used  soft  hard  grace
Index: b/common.filter
===================================================================
--- a/common.filter
+++ b/common.filter
@@ -214,5 +214,10 @@ _filter_xfs_io_unique()
     common_line_filter | _filter_xfs_io
 }
 
+_filter_scratch()
+{
+	sed -e "s,$SCRATCH_DEV,SCRATCH_DEV,g" -e "s,$SCRATCH_MNT,SCRATCH_MNT,g"
+}
+
 # make sure this script returns success
 /bin/true
Index: b/common.quota
===================================================================
--- a/common.quota
+++ b/common.quota
@@ -234,9 +234,9 @@ _check_quota_usage()
 		VFS_QUOTA=1
 		quotaon -f -u -g $SCRATCH_MNT 2>/dev/null
 	fi
-	repquota -u -n $SCRATCH_MNT  | grep -v "^#0" | filter_scratch |
+	repquota -u -n $SCRATCH_MNT  | grep -v "^#0" | _filter_scratch |
 		sort >$tmp.user.orig
-	repquota -g -n $SCRATCH_MNT  | grep -v "^#0" | filter_scratch |
+	repquota -g -n $SCRATCH_MNT  | grep -v "^#0" | _filter_scratch |
 		sort >$tmp.group.orig
 	if [ $VFS_QUOTA -eq 1 ]; then
 		quotacheck -u -g $SCRATCH_MNT 2>/dev/null
@@ -245,9 +245,9 @@ _check_quota_usage()
 		mount -o remount,noquota $SCRATCH_DEV
 		mount -o remount,usrquota,grpquota $SCRATCH_DEV
 	fi
-	repquota -u -n $SCRATCH_MNT  | grep -v "^#0" | filter_scratch |
+	repquota -u -n $SCRATCH_MNT  | grep -v "^#0" | _filter_scratch |
 		sort >$tmp.user.checked
-	repquota -g -n $SCRATCH_MNT  | grep -v "^#0" | filter_scratch |
+	repquota -g -n $SCRATCH_MNT  | grep -v "^#0" | _filter_scratch |
 		sort >$tmp.group.checked
 	if [ $VFS_QUOTA -eq 1 ]; then
 		quotaon -u -g $SCRATCH_MNT 2>/dev/null

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
