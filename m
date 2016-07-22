Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4AA397CA0
	for <xfs@oss.sgi.com>; Fri, 22 Jul 2016 05:24:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C8F2D8F8037
	for <xfs@oss.sgi.com>; Fri, 22 Jul 2016 03:24:17 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 6XlNQHpwrE04O1Jv (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 22 Jul 2016 03:24:13 -0700 (PDT)
From: Zorro Lang <zlang@redhat.com>
Subject: [PATCH v3] xfs/106: rewrite this case for run it as auto test again
Date: Fri, 22 Jul 2016 18:24:06 +0800
Message-Id: <1469183046-23483-1-git-send-email-zlang@redhat.com>
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
To: fstests@vger.kernel.org
Cc: Zorro Lang <zlang@redhat.com>, eguan@redhat.com, xfs@oss.sgi.com

xfs/106 try to do some basic xfs_quota functionality test. I think
basic function test is important, especially there're only few
cases about xfs_quota now. But due to it's too old, there're 3
problems cause no one run it again:
   1. Some quota commands can't be used, but this case try to use it.
      e.g. "warn" command.
   2. Some quota commands can be used now, but this case doesn't test
      them, because they can't work previously. e.g. "disable, enable,
      off and remove" commands
   3. Some expected output in 106.out file become incorrect now.

I rewrite this case for above 3 reasons. This case nearly test all
xfs_quota commands and options now, except:
   1. some "-v" options
   2. all "-a" options. I can't control the golden file if print all
      filesystem's quota info in it.
   3. default quota. I think it can be tested in another cases.
   4. project command options. I will write another case to test it.
   5. report command -l option. It's a new option, will cause failure
      if someone test on a release with xfsprogs-3.1.
   6. quot command -c option. It maybe output different histogram in
      different system or machine.
   7. warn command. This feature is not currently implemented.
   8. print, df, free, help, quit and path commands.

Signed-off-by: Zorro Lang <zlang@redhat.com>
---

Hi,

This V3 patch do below change:
  1. use tab to instead of 4 space
  2. do scratch_mkfs before project quota test

Thanks,
Zorro

 tests/xfs/106     | 361 +++++++++++++++----------
 tests/xfs/106.out | 790 +++++++++++++++++++++++++++++++-----------------------
 tests/xfs/group   |   2 +-
 3 files changed, 675 insertions(+), 478 deletions(-)

diff --git a/tests/xfs/106 b/tests/xfs/106
index 74658a6..d491410 100755
--- a/tests/xfs/106
+++ b/tests/xfs/106
@@ -31,208 +31,291 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=1	# failure is the default!
-trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+}
 
 # get standard environment, filters and checks
 . ./common/rc
 . ./common/filter
 . ./common/quota
 
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
 _supported_fs xfs
-_supported_os Linux #IRIX
+_supported_os Linux
 _require_scratch
 _require_xfs_quota
+_require_user
+_require_group
 
-# real QA test starts here
-_scratch_mkfs_xfs | _filter_mkfs 2>$tmp.mkfs
-cat $tmp.mkfs >$seqres.full
-. $tmp.mkfs
+_scratch_mkfs_xfs >>$seqres.full 2>&1
 
-# setup a default run
-if [ -z "$MOUNT_OPTIONS" ]; then
-	export MOUNT_OPTIONS="-o pquota,sync"
-else
-	export MOUNT_OPTIONS="$MOUNT_OPTIONS -o sync"
-fi
+uqid=`id -u fsgqa`
+gqid=`id -g fsgqa`
+pqid=10
+cat >$tmp.projects <<EOF
+$pqid:$SCRATCH_MNT
+EOF
 
-_qmount
-_require_prjquota $SCRATCH_DEV
+cat >$tmp.projid <<EOF
+root:0
+fsgqa:$pqid
+EOF
+
+create_files()
+{
+	local bs=$1
+	local inum=$2
 
-# initial populate
-target=$SCRATCH_MNT/target
-$FSSTRESS_PROG -z -s 57069 -m 8 -n 1000 -p 4 \
--f allocsp=1 \
--f chown=3 \
--f creat=4 \
--f dwrite=4 \
--f fallocate=1 \
--f fdatasync=1 \
--f fiemap=1 \
--f freesp=1 \
--f fsync=1 \
--f link=1 \
--f mkdir=2 \
--f mknod=2 \
--f punch=1 \
--f rename=2 \
--f resvsp=1 \
--f rmdir=1 \
--f setxattr=1 \
--f symlink=2 \
--f sync=1 \
--f truncate=2 \
--f unlink=1 \
--f unresvsp=1 \
--f write=4 \
--d $target
-
-$FSSTRESS_PROG -z -s 57069 -m 8 -n 1000 -p 4 \
--f chown=500 \
--f setxattr=500 \
--d $target
-
-# also use space, to be able to go over/under limits easily
-uid=255
-gid=254
-prid=253
-rm -f $SCRATCH_MNT/resv
-$XFS_IO_PROG -fc "resvsp 0 200m" -c "chproj $prid" $SCRATCH_MNT/resv
-chown $uid $SCRATCH_MNT/resv
-chgrp $gid $SCRATCH_MNT/resv
+	echo "Using type=$type id=$id" >> $seqres.full
 
-_qmount
+	for ((i=0; i<$((inum-1)); i++)); do
+		_file_as_id $SCRATCH_MNT/inode$i $id $type 1024 0
+	done
+
+	_file_as_id $SCRATCH_MNT/block $id $type $bs 1
+}
+
+clean_files()
+{
+	rm -rf $SCRATCH_MNT/* 2>/dev/null
+	rm -rf $tmp.quot 2>/dev/null
+	rm -rf $tmp.quota 2>/dev/null
+}
+
+filter_quot()
+{
+	_filter_quota | grep -v "root \|\#0 " \
+		| sed -e '/#[0-9]*/s/#[0-9]*/#ID/g'
+}
+
+filter_report()
+{
+	_filter_quota | grep -v "^root \|^\#0 " \
+		| sed -e '/^#[0-9]*/s/^#[0-9]*/#ID/g'
+}
+
+filter_quota()
+{
+	_filter_quota | sed -e "/Disk quotas for/s/([0-9]*)/(ID)/g" \
+			    -e "/Disk quotas for/s/#[0-9]*/#ID/g"
+}
 
-filter_xfs_quota()
+filter_state()
 {
-	perl -ne "
-s,$SCRATCH_MNT,[SCR_MNT],;
-s,$SCRATCH_DEV,[SCR_DEV],;
-s/Inode: \#\d+ \(0 blocks, 0 extents\)/Inode: #[INO] (0 blocks, 0 extents)/;
-s/Inode: \#\d+ \(\d+ blocks, \d+ extents\)/Inode: #[INO] (X blocks, Y extents)/;
-	print;"
+	_filter_quota | sed -e "s/Inode: #[0-9]* (0 blocks, 0 extents)/Inode: #[INO] (0 blocks, 0 extents)/g" \
+			    -e "s/Inode: #[0-9]* ([0-9]* blocks, [0-9]* extents)/Inode: #[INO] (X blocks, Y extents)/g" \
+			    -e "/[0-9][0-9]:[0-9][0-9]:[0-9][0-9]/s/ [0-9][0-9]:[0-9][0-9]:[0-9][0-9]//g"
 }
 
 test_quot()
 {
-	echo "checking quot command (type=$type)"  # not deterministic on blks
-	xfs_quota -x -c "quot -n -$type" $SCRATCH_MNT >>$seqres.full 2>&1
+	local opt="$*"
+
+	echo "checking quot command (type=$type)"
+	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
+			-c "quot -$type $opt -bi" $SCRATCH_MNT | filter_quot
 }
 
 test_report()
 {
+	local opt="$*"
+
 	echo "checking report command (type=$type)"
-	xfs_quota -x -c "report -h -$type -U 256" $SCRATCH_MNT
+	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
+			-c "report -$type $opt -bi" \
+			$SCRATCH_MNT | filter_report
 }
 
-test_limit1()
+test_quota()
 {
-	echo "checking limit command, pass 1 (type=$type)"
-	xfs_quota -x -c "limit -$type bsoft=100m bhard=100m ihard=2 $id" \
-		$SCRATCH_MNT
-	xfs_quota -x -c "limit -$type isoft=1 rtbsoft=100m rtbhard=110m $id"\
-		$SCRATCH_MNT
-	sleep 2		# let the timer day transition happen
-	xfs_quota -x -c "quota -$type -b -hnv $id" $SCRATCH_MNT
-	xfs_quota -x -c "quota -$type -i -hnv $id" $SCRATCH_MNT
-	#xfs_quota -x -c "quota -$type -r -hnv $id" $SCRATCH_MNT
-}
+	local opt="$*"
 
-test_limit2()
-{
-	# push limits up high, so that timers are cleared, etc. (for later)
-	echo "checking limit command, pass2 (type=$type)"
-	xfs_quota -x -c "limit -$type bsoft=300m bhard=400m ihard=8800 $id" \
-		$SCRATCH_MNT
-	xfs_quota -x -c "limit -$type isoft=8000 rtbsoft=310m rtbhard=410m $id"\
-		$SCRATCH_MNT
-	xfs_quota -x -c "quota -$type -b -hnv $id" $SCRATCH_MNT
-	xfs_quota -x -c "quota -$type -i -hnv $id" $SCRATCH_MNT
-	#xfs_quota -x -c "quota -$type -r -hnv $id" $SCRATCH_MNT
+	echo "checking quota command (type=$type)"
+	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
+			-c "quota -$type $opt -bi $id" \
+			$SCRATCH_MNT | filter_quota
 }
 
-test_warn()
+test_limit()
 {
-	echo "checking warn command (type=$type)"
-	xfs_quota -x -c "warn -$type -b 4 $id" $SCRATCH_MNT
-	xfs_quota -x -c "warn -$type -i 3 $id" $SCRATCH_MNT
-	#xfs_quota -x -c "warn -$type -r 2 $id" $SCRATCH_MNT
-	xfs_quota -x -c "quota -$type -b -hnv $id" $SCRATCH_MNT
-	xfs_quota -x -c "quota -$type -i -hnv $id" $SCRATCH_MNT
-	#xfs_quota -x -c "quota -$type -r -hnv $id" $SCRATCH_MNT
+	local bs=$1
+	local bh=$2
+	local is=$3
+	local ih=$4
+
+	echo "checking limit command (type=$type, bsoft=$bs, bhard=$bh, isoft=$is, ihard=$ih)"
+	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
+			-c "limit -$type bsoft=$bs bhard=$bh fsgqa" \
+			-c "limit -$type isoft=$is ihard=$ih fsgqa" \
+			$SCRATCH_MNT
+
+	# let the timer day transition happen
+	sleep 2
 }
 
 test_timer()
 {
 	echo "checking timer command (type=$type)"
-	xfs_quota -x -c "timer -$type -b 3days" $SCRATCH_MNT
-	xfs_quota -x -c "timer -$type -i 2days" $SCRATCH_MNT
-	#xfs_quota -x -c "timer -$type -r 1day" $SCRATCH_MNT
+	# set 3days+1h for time won't become 2days soon
+	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
+			-c "timer -$type -bi 73h" \
+			$SCRATCH_MNT | _filter_scratch
+}
+
+test_disable()
+{
+	echo "checking disable command (type=$type)"
+	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
+			-c "disable -$type -v" \
+			$SCRATCH_MNT | filter_state
+}
+
+test_enable()
+{
+	echo "checking enable command (type=$type)"
+	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
+			-c "enable -$type -v" $SCRATCH_MNT | filter_state
+}
+
+test_off()
+{
+	echo "checking off command (type=$type)"
+	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
+			-c "off -$type -v" $SCRATCH_MNT | _filter_scratch
+}
+
+test_remove()
+{
+	echo "checking remove command (type=$type)"
+	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
+			-c "remove -$type -v" \
+			$SCRATCH_MNT | _filter_scratch
 }
 
 test_state()
 {
 	echo "checking state command (type=$type)"
-	xfs_quota -x -c "state -$type" $SCRATCH_MNT
-	# not yet working properly?
-	#echo "checking disable command (type=$type)"
-	#xfs_quota -x -c "disable -$type -v" $SCRATCH_MNT
-	#echo "checking enable command (type=$type)"
-	#xfs_quota -x -c "enable -$type -v" $SCRATCH_MNT
-	#echo "checking off command (type=$type)"
-	#xfs_quota -x -c "off -$type -v" $SCRATCH_MNT
-	#echo "checking remove command (type=$type)"
-	#xfs_quota -x -c "remove -$type -v" $SCRATCH_MNT
+	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
+			-c "state -$type" $SCRATCH_MNT | filter_state
 }
 
-test_backup()
+test_dump()
 {
 	echo "checking dump command (type=$type)"
-	rm -f $tmp.backup
-	xfs_quota -x -c "dump -$type -f $tmp.backup -U 256" $SCRATCH_MNT
-	cat $tmp.backup
-
-	echo "changing limits (type=$type)"
-	xfs_quota -x -c "limit -$type isoft=1000 ihard=1100 $id" $SCRATCH_MNT
-	xfs_quota -x -c "quota -$type -i -hnv $id" $SCRATCH_MNT
+	rm -f $tmp.backup 2>>/dev/null
+	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
+			-c "dump -$type -f $tmp.backup" \
+			$SCRATCH_MNT | _filter_scratch
+}
 
+test_restore()
+{
 	echo "checking restore command (type=$type)"
-	xfs_quota -x -c "restore -$type -f $tmp.backup" $SCRATCH_MNT
-	xfs_quota -x -c "quota -$type -i -hnv $id" $SCRATCH_MNT
-	rm -f $tmp.backup
+	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
+			-c "restore -$type -f $tmp.backup" \
+			$SCRATCH_MNT | _filter_scratch
 }
 
 test_xfs_quota()
 {
-	test_quot	; echo
-	test_report	; echo
-	test_timer	; echo
-	test_limit1	; echo
-	test_warn	; echo
-	test_limit2	; echo
-	test_backup	; echo
-	test_state	; echo
-	echo		; echo
+	# init quota
+	echo "init quota limit and timer, and dump it"
+	echo "create_files 1024k 15"; create_files 1024k 15
+	echo "quota remount"; _qmount
+	echo ; test_quot
+	echo ; test_timer
+	echo ; test_limit 512k 2048k 10 20
+	echo ; test_dump
+
+	# report options test
+	echo "report options test"
+	echo ; test_report
+	echo "-N option"; test_report -N
+	echo "-L -U options"; test_report -L $id -U $id
+	echo "-t option"; test_report -t
+	echo "-n option"; test_report -n
+	echo "-h option"; test_report -h
+
+	# quot options test
+	echo "quot options test"
+	echo ; test_quot
+	echo "-f option"; test_quot -f $tmp.quot
+	cat $tmp.quot | filter_quot
+	echo "-n option"; test_quot -n
+
+	# quota options test
+	echo ; test_quota
+	echo "-f option"; test_quota -f $tmp.quota
+	cat $tmp.quota | filter_quota
+	echo "-N option"; test_quota -N
+	echo "-n option"; test_quota -n
+	echo "-h option"; test_quota -h
+
+	# disable/enable test
+	echo "disable quota"
+	echo ; test_disable
+	echo ; test_report -N
+	echo "expect a remove error at here"; test_remove
+	echo ; test_enable
+	echo ; test_report -N
+
+	# off and remove test
+	echo "off and remove test"
+	echo ; test_limit 100m 100m 100 100
+	echo ; test_quota -N
+	echo ; test_off
+	echo ; test_state
+	echo ; test_remove
+	echo ; test_report -N
+	echo "quota remount"; _qmount
+	echo ; test_report -N
+
+	# restore test
+	echo "restore quota"
+	echo ; test_restore
+	echo ; test_report -N
+	echo ; test_state
+	echo "cleanup files"; clean_files
 }
 
-# real QA test starts here
-export MOUNT_OPTIONS="-ouquota,sync"
+echo "----------------------- uquota,sync ---------------------------"
+_qmount_option "uquota,sync"
 _qmount
 type=u
-id=$uid
-test_xfs_quota | filter_xfs_quota
+id=$uqid
+test_xfs_quota
 
-export MOUNT_OPTIONS="-ogquota,sync"
+echo "----------------------- gquota,sync ---------------------------"
+_qmount_option "gquota,sync"
 _qmount
 type=g
-id=$gid
-test_xfs_quota | filter_xfs_quota
+id=$gqid
+test_xfs_quota
 
-export MOUNT_OPTIONS="-opquota,sync"
+echo "----------------------- pquota,sync ---------------------------"
+# Need to clean the group quota before test project quota, because
+# V4 xfs doesn't support separate project inode. So mkfs at here.
+_scratch_unmount
+_scratch_mkfs_xfs >>$seqres.full 2>&1
+_qmount_option "pquota,sync"
 _qmount
 type=p
-id=$prid
-test_xfs_quota | filter_xfs_quota
+id=$pqid
+_require_prjquota $SCRATCH_DEV
+$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
+		-c "project -s $id" \
+		$SCRATCH_MNT > /dev/null
+test_xfs_quota
 
 _scratch_unmount
+# success, all done
 status=0
 exit
diff --git a/tests/xfs/106.out b/tests/xfs/106.out
index 1096acb..e36375d 100644
--- a/tests/xfs/106.out
+++ b/tests/xfs/106.out
@@ -1,379 +1,493 @@
 QA output created by 106
-meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
-data     = bsize=XXX blocks=XXX, imaxpct=PCT
-         = sunit=XXX swidth=XXX, unwritten=X
-naming   =VERN bsize=XXX
-log      =LDEV bsize=XXX blocks=XXX
-realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
+----------------------- uquota,sync ---------------------------
+init quota limit and timer, and dump it
+create_files 1024k 15
+quota remount
+
 checking quot command (type=u)
+SCRATCH_DEV (SCRATCH_MNT) User:
+ 1024 15 fsgqa 
+
+checking timer command (type=u)
+
+checking limit command (type=u, bsoft=512k, bhard=2048k, isoft=10, ihard=20)
+
+checking dump command (type=u)
+report options test
 
 checking report command (type=u)
-User quota on [SCR_MNT] ([SCR_DEV])
-                        Blocks              
-User ID      Used   Soft   Hard Warn/Grace   
----------- --------------------------------- 
-#0          84.4M      0      0  00 [------]
-#1           5.5M      0      0  00 [------]
-#2           1.2M      0      0  00 [------]
-#3           1.2M      0      0  00 [------]
-#4           2.3M      0      0  00 [------]
-#5          1004K      0      0  00 [------]
-#6           2.1M      0      0  00 [------]
-#7           1.0M      0      0  00 [------]
-#8              0      0      0  00 [------]
-#9              0      0      0  00 [------]
-#10             0      0      0  00 [------]
-#11             0      0      0  00 [------]
-#12            8K      0      0  00 [------]
-#13          228K      0      0  00 [------]
-#14             0      0      0  00 [------]
-#15          696K      0      0  00 [------]
-#16             0      0      0  00 [------]
-#17          300K      0      0  00 [------]
-#18             0      0      0  00 [------]
-#20           40K      0      0  00 [------]
-#22          256K      0      0  00 [------]
-#23          128K      0      0  00 [------]
-#24          1.9M      0      0  00 [------]
-#25             0      0      0  00 [------]
-#26          176K      0      0  00 [------]
-#27             0      0      0  00 [------]
-#28             0      0      0  00 [------]
-#29             0      0      0  00 [------]
-#31          616K      0      0  00 [------]
-#32             0      0      0  00 [------]
-#35          128K      0      0  00 [------]
-#37             0      0      0  00 [------]
-#38          100K      0      0  00 [------]
-#40             0      0      0  00 [------]
-#42          412K      0      0  00 [------]
-#44             0      0      0  00 [------]
-#48             0      0      0  00 [------]
-#50             0      0      0  00 [------]
-#53          288K      0      0  00 [------]
-#54             0      0      0  00 [------]
-#55             0      0      0  00 [------]
-#56          400K      0      0  00 [------]
-#58             0      0      0  00 [------]
-#61             0      0      0  00 [------]
-#63          528K      0      0  00 [------]
-#69             0      0      0  00 [------]
-#70          1.2M      0      0  00 [------]
-#72           32K      0      0  00 [------]
-#75          248K      0      0  00 [------]
-#76             0      0      0  00 [------]
-#77             0      0      0  00 [------]
-#78          632K      0      0  00 [------]
-#83          296K      0      0  00 [------]
-#89             0      0      0  00 [------]
-#91            4K      0      0  00 [------]
-#95             0      0      0  00 [------]
-#96             0      0      0  00 [------]
-#105            0      0      0  00 [------]
-#113            0      0      0  00 [------]
-#118            0      0      0  00 [------]
-#127            0      0      0  00 [------]
-#255         200M      0      0  00 [------]
+User quota on SCRATCH_MNT (SCRATCH_DEV)
+ Blocks Inodes 
+User ID Used Soft Hard Warn/Grace Used Soft Hard Warn/ Grace 
+---------- -------------------------------------------------- -------------------------------------------------- 
+fsgqa 1024 512 2048 00 [3 days] 15 10 20 00 [3 days]
 
+-N option
+checking report command (type=u)
+fsgqa 1024 512 2048 00 [3 days] 15 10 20 00 [3 days]
 
-checking timer command (type=u)
+-L -U options
+checking report command (type=u)
+User quota on SCRATCH_MNT (SCRATCH_DEV)
+ Blocks Inodes 
+User ID Used Soft Hard Warn/Grace Used Soft Hard Warn/ Grace 
+---------- -------------------------------------------------- -------------------------------------------------- 
+#ID 1024 512 2048 00 [3 days] 15 10 20 00 [3 days]
 
-checking limit command, pass 1 (type=u)
-Disk quotas for User #255 (255)
-Filesystem   Blocks  Quota  Limit Warn/Time    Mounted on
-[SCR_DEV]      200M   100M   100M  00 [-none-] [SCR_MNT]
-Disk quotas for User #255 (255)
-Filesystem    Files  Quota  Limit Warn/Time    Mounted on
-[SCR_DEV]         1      1      2  00  [1 day] [SCR_MNT]
-
-checking warn command (type=u)
-Disk quotas for User #255 (255)
-Filesystem   Blocks  Quota  Limit Warn/Time    Mounted on
-[SCR_DEV]      200M   100M   100M  04 [-none-] [SCR_MNT]
-Disk quotas for User #255 (255)
-Filesystem    Files  Quota  Limit Warn/Time    Mounted on
-[SCR_DEV]         1      1      2  03  [1 day] [SCR_MNT]
-
-checking limit command, pass2 (type=u)
-Disk quotas for User #255 (255)
-Filesystem   Blocks  Quota  Limit Warn/Time    Mounted on
-[SCR_DEV]      200M   300M   400M  00 [------] [SCR_MNT]
-Disk quotas for User #255 (255)
-Filesystem    Files  Quota  Limit Warn/Time    Mounted on
-[SCR_DEV]         1     8k   8.8k  03 [------] [SCR_MNT]
+-t option
+checking report command (type=u)
+User quota on SCRATCH_MNT (SCRATCH_DEV)
+ Blocks Inodes 
+User ID Used Soft Hard Warn/Grace Used Soft Hard Warn/ Grace 
+---------- -------------------------------------------------- -------------------------------------------------- 
+fsgqa 1024 512 2048 00 [3 days] 15 10 20 00 [3 days]
+
+-n option
+checking report command (type=u)
+User quota on SCRATCH_MNT (SCRATCH_DEV)
+ Blocks Inodes 
+User ID Used Soft Hard Warn/Grace Used Soft Hard Warn/ Grace 
+---------- -------------------------------------------------- -------------------------------------------------- 
+#ID 1024 512 2048 00 [3 days] 15 10 20 00 [3 days]
+
+-h option
+checking report command (type=u)
+User quota on SCRATCH_MNT (SCRATCH_DEV)
+ Blocks Inodes 
+User ID Used Soft Hard Warn/Grace Used Soft Hard Warn/Grace 
+---------- --------------------------------- --------------------------------- 
+fsgqa 1M 512K 2M 00 [3 days] 15 10 20 00 [3 days]
+
+quot options test
+
+checking quot command (type=u)
+SCRATCH_DEV (SCRATCH_MNT) User:
+ 1024 15 fsgqa 
+-f option
+checking quot command (type=u)
+SCRATCH_DEV (SCRATCH_MNT) User:
+ 1024 15 fsgqa 
+-n option
+checking quot command (type=u)
+SCRATCH_DEV (SCRATCH_MNT) User:
+ 1024 15 #ID 
+
+checking quota command (type=u)
+Disk quotas for User fsgqa (ID)
+Filesystem Blocks Quota Limit Warn/Time Files Quota Limit Warn/Time Mounted on
+SCRATCH_DEV 1024 512 2048 00 [3 days] 15 10 20 00 [3 days] SCRATCH_MNT
+-f option
+checking quota command (type=u)
+Disk quotas for User fsgqa (ID)
+Filesystem Blocks Quota Limit Warn/Time Files Quota Limit Warn/Time Mounted on
+SCRATCH_DEV 1024 512 2048 00 [3 days] 15 10 20 00 [3 days] SCRATCH_MNT
+-N option
+checking quota command (type=u)
+SCRATCH_DEV 1024 512 2048 00 [3 days] 15 10 20 00 [3 days] SCRATCH_MNT
+-n option
+checking quota command (type=u)
+Disk quotas for User #ID (ID)
+Filesystem Blocks Quota Limit Warn/Time Files Quota Limit Warn/Time Mounted on
+SCRATCH_DEV 1024 512 2048 00 [3 days] 15 10 20 00 [3 days] SCRATCH_MNT
+-h option
+checking quota command (type=u)
+Disk quotas for User fsgqa (ID)
+Filesystem Blocks Quota Limit Warn/Time Files Quota Limit Warn/Time Mounted on
+SCRATCH_DEV 1M 512K 2M 00 [3 days] 15 10 20 00 [3 days] SCRATCH_MNT
+disable quota
+
+checking disable command (type=u)
+User quota state on SCRATCH_MNT (SCRATCH_DEV)
+ Accounting: ON
+ Enforcement: OFF
+ Inode: #[INO] (X blocks, Y extents)
+Blocks grace time: [3 days]
+Inodes grace time: [3 days]
+Realtime Blocks grace time: [7 days]
+
+checking report command (type=u)
+fsgqa 1024 512 2048 00 [--------] 15 10 20 00 [--------]
+
+expect a remove error at here
+checking remove command (type=u)
+XFS_QUOTARM: Invalid argument
+
+checking enable command (type=u)
+User quota state on SCRATCH_MNT (SCRATCH_DEV)
+ Accounting: ON
+ Enforcement: ON
+ Inode: #[INO] (X blocks, Y extents)
+Blocks grace time: [3 days]
+Inodes grace time: [3 days]
+Realtime Blocks grace time: [7 days]
+
+checking report command (type=u)
+fsgqa 1024 512 2048 00 [3 days] 15 10 20 00 [3 days]
+
+off and remove test
+
+checking limit command (type=u, bsoft=100m, bhard=100m, isoft=100, ihard=100)
+
+checking quota command (type=u)
+SCRATCH_DEV 1024 102400 102400 00 [--------] 15 100 100 00 [--------] SCRATCH_MNT
+
+checking off command (type=u)
+User quota are not enabled on SCRATCH_DEV
+
+checking state command (type=u)
+
+checking remove command (type=u)
+User quota are not enabled on SCRATCH_DEV
+
+checking report command (type=u)
+
+quota remount
+
+checking report command (type=u)
+fsgqa 1024 0 0 00 [--------] 15 0 0 00 [--------]
+
+restore quota
 
-checking dump command (type=u)
-fs = [SCR_DEV]
-255         614400  819200    8000    8800  634880  839680
-changing limits (type=u)
-Disk quotas for User #255 (255)
-Filesystem    Files  Quota  Limit Warn/Time    Mounted on
-[SCR_DEV]         1   1000   1.1k  00 [------] [SCR_MNT]
 checking restore command (type=u)
-Disk quotas for User #255 (255)
-Filesystem    Files  Quota  Limit Warn/Time    Mounted on
-[SCR_DEV]         1     8k   8.8k  00 [------] [SCR_MNT]
+
+checking report command (type=u)
+fsgqa 1024 512 2048 00 [7 days] 15 10 20 00 [7 days]
+
 
 checking state command (type=u)
-User quota state on [SCR_MNT] ([SCR_DEV])
-  Accounting: ON
-  Enforcement: ON
-  Inode: #[INO] (X blocks, Y extents)
-Blocks grace time: [3 days]
-Inodes grace time: [2 days]
+User quota state on SCRATCH_MNT (SCRATCH_DEV)
+ Accounting: ON
+ Enforcement: ON
+ Inode: #[INO] (X blocks, Y extents)
+Blocks grace time: [7 days]
+Inodes grace time: [7 days]
 Realtime Blocks grace time: [7 days]
+cleanup files
+----------------------- gquota,sync ---------------------------
+init quota limit and timer, and dump it
+create_files 1024k 15
+quota remount
+
+checking quot command (type=g)
+SCRATCH_DEV (SCRATCH_MNT) Group:
+ 1024 15 fsgqa 
+
+checking timer command (type=g)
 
+checking limit command (type=g, bsoft=512k, bhard=2048k, isoft=10, ihard=20)
 
+checking dump command (type=g)
+report options test
+
+checking report command (type=g)
+Group quota on SCRATCH_MNT (SCRATCH_DEV)
+ Blocks Inodes 
+Group ID Used Soft Hard Warn/Grace Used Soft Hard Warn/ Grace 
+---------- -------------------------------------------------- -------------------------------------------------- 
+fsgqa 1024 512 2048 00 [3 days] 15 10 20 00 [3 days]
+
+-N option
+checking report command (type=g)
+fsgqa 1024 512 2048 00 [3 days] 15 10 20 00 [3 days]
+
+-L -U options
+checking report command (type=g)
+Group quota on SCRATCH_MNT (SCRATCH_DEV)
+ Blocks Inodes 
+Group ID Used Soft Hard Warn/Grace Used Soft Hard Warn/ Grace 
+---------- -------------------------------------------------- -------------------------------------------------- 
+#ID 1024 512 2048 00 [3 days] 15 10 20 00 [3 days]
+
+-t option
+checking report command (type=g)
+Group quota on SCRATCH_MNT (SCRATCH_DEV)
+ Blocks Inodes 
+Group ID Used Soft Hard Warn/Grace Used Soft Hard Warn/ Grace 
+---------- -------------------------------------------------- -------------------------------------------------- 
+fsgqa 1024 512 2048 00 [3 days] 15 10 20 00 [3 days]
 
+-n option
+checking report command (type=g)
+Group quota on SCRATCH_MNT (SCRATCH_DEV)
+ Blocks Inodes 
+Group ID Used Soft Hard Warn/Grace Used Soft Hard Warn/ Grace 
+---------- -------------------------------------------------- -------------------------------------------------- 
+#ID 1024 512 2048 00 [3 days] 15 10 20 00 [3 days]
+
+-h option
+checking report command (type=g)
+Group quota on SCRATCH_MNT (SCRATCH_DEV)
+ Blocks Inodes 
+Group ID Used Soft Hard Warn/Grace Used Soft Hard Warn/Grace 
+---------- --------------------------------- --------------------------------- 
+fsgqa 1M 512K 2M 00 [3 days] 15 10 20 00 [3 days]
+
+quot options test
+
+checking quot command (type=g)
+SCRATCH_DEV (SCRATCH_MNT) Group:
+ 1024 15 fsgqa 
+-f option
 checking quot command (type=g)
+SCRATCH_DEV (SCRATCH_MNT) Group:
+ 1024 15 fsgqa 
+-n option
+checking quot command (type=g)
+SCRATCH_DEV (SCRATCH_MNT) Group:
+ 1024 15 #ID 
+
+checking quota command (type=g)
+Disk quotas for Group fsgqa (ID)
+Filesystem Blocks Quota Limit Warn/Time Files Quota Limit Warn/Time Mounted on
+SCRATCH_DEV 1024 512 2048 00 [3 days] 15 10 20 00 [3 days] SCRATCH_MNT
+-f option
+checking quota command (type=g)
+Disk quotas for Group fsgqa (ID)
+Filesystem Blocks Quota Limit Warn/Time Files Quota Limit Warn/Time Mounted on
+SCRATCH_DEV 1024 512 2048 00 [3 days] 15 10 20 00 [3 days] SCRATCH_MNT
+-N option
+checking quota command (type=g)
+SCRATCH_DEV 1024 512 2048 00 [3 days] 15 10 20 00 [3 days] SCRATCH_MNT
+-n option
+checking quota command (type=g)
+Disk quotas for Group #ID (ID)
+Filesystem Blocks Quota Limit Warn/Time Files Quota Limit Warn/Time Mounted on
+SCRATCH_DEV 1024 512 2048 00 [3 days] 15 10 20 00 [3 days] SCRATCH_MNT
+-h option
+checking quota command (type=g)
+Disk quotas for Group fsgqa (ID)
+Filesystem Blocks Quota Limit Warn/Time Files Quota Limit Warn/Time Mounted on
+SCRATCH_DEV 1M 512K 2M 00 [3 days] 15 10 20 00 [3 days] SCRATCH_MNT
+disable quota
+
+checking disable command (type=g)
+Group quota state on SCRATCH_MNT (SCRATCH_DEV)
+ Accounting: ON
+ Enforcement: OFF
+ Inode: #[INO] (X blocks, Y extents)
+Blocks grace time: [3 days]
+Inodes grace time: [3 days]
+Realtime Blocks grace time: [7 days]
 
 checking report command (type=g)
-Group quota on [SCR_MNT] ([SCR_DEV])
-                        Blocks              
-Group ID     Used   Soft   Hard Warn/Grace   
----------- --------------------------------- 
-#0          85.0M      0      0  00 [------]
-#1           6.1M      0      0  00 [------]
-#2           676K      0      0  00 [------]
-#3           1.9M      0      0  00 [------]
-#4           604K      0      0  00 [------]
-#5           224K      0      0  00 [------]
-#6           504K      0      0  00 [------]
-#7             4K      0      0  00 [------]
-#8           400K      0      0  00 [------]
-#9              0      0      0  00 [------]
-#10           56K      0      0  00 [------]
-#11          2.6M      0      0  00 [------]
-#12          892K      0      0  00 [------]
-#13             0      0      0  00 [------]
-#14             0      0      0  00 [------]
-#15             0      0      0  00 [------]
-#17             0      0      0  00 [------]
-#20             0      0      0  00 [------]
-#21          616K      0      0  00 [------]
-#22             0      0      0  00 [------]
-#23          472K      0      0  00 [------]
-#24             0      0      0  00 [------]
-#25           36K      0      0  00 [------]
-#26          1.1M      0      0  00 [------]
-#27          128K      0      0  00 [------]
-#28             0      0      0  00 [------]
-#30          248K      0      0  00 [------]
-#31          1.0M      0      0  00 [------]
-#33             0      0      0  00 [------]
-#34             0      0      0  00 [------]
-#35             0      0      0  00 [------]
-#36             0      0      0  00 [------]
-#37             0      0      0  00 [------]
-#38          240K      0      0  00 [------]
-#41          412K      0      0  00 [------]
-#43           32K      0      0  00 [------]
-#44             0      0      0  00 [------]
-#45             0      0      0  00 [------]
-#46             0      0      0  00 [------]
-#49             0      0      0  00 [------]
-#51          124K      0      0  00 [------]
-#53             0      0      0  00 [------]
-#55             0      0      0  00 [------]
-#56          176K      0      0  00 [------]
-#57          288K      0      0  00 [------]
-#58          528K      0      0  00 [------]
-#59             0      0      0  00 [------]
-#67            4K      0      0  00 [------]
-#69          624K      0      0  00 [------]
-#70             0      0      0  00 [------]
-#71             0      0      0  00 [------]
-#72          632K      0      0  00 [------]
-#73             0      0      0  00 [------]
-#75             0      0      0  00 [------]
-#79          100K      0      0  00 [------]
-#87          1.2M      0      0  00 [------]
-#88             0      0      0  00 [------]
-#91             0      0      0  00 [------]
-#94            4K      0      0  00 [------]
-#99          248K      0      0  00 [------]
-#101            0      0      0  00 [------]
-#108            0      0      0  00 [------]
-#112          64K      0      0  00 [------]
-#115         296K      0      0  00 [------]
-#121            0      0      0  00 [------]
-#127            0      0      0  00 [------]
-#254         200M      0      0  00 [------]
+fsgqa 1024 512 2048 00 [--------] 15 10 20 00 [--------]
 
+expect a remove error at here
+checking remove command (type=g)
+XFS_QUOTARM: Invalid argument
 
-checking timer command (type=g)
+checking enable command (type=g)
+Group quota state on SCRATCH_MNT (SCRATCH_DEV)
+ Accounting: ON
+ Enforcement: ON
+ Inode: #[INO] (X blocks, Y extents)
+Blocks grace time: [3 days]
+Inodes grace time: [3 days]
+Realtime Blocks grace time: [7 days]
 
-checking limit command, pass 1 (type=g)
-Disk quotas for Group #254 (254)
-Filesystem   Blocks  Quota  Limit Warn/Time    Mounted on
-[SCR_DEV]      200M   100M   100M  00 [-none-] [SCR_MNT]
-Disk quotas for Group #254 (254)
-Filesystem    Files  Quota  Limit Warn/Time    Mounted on
-[SCR_DEV]         1      1      2  00  [1 day] [SCR_MNT]
-
-checking warn command (type=g)
-Disk quotas for Group #254 (254)
-Filesystem   Blocks  Quota  Limit Warn/Time    Mounted on
-[SCR_DEV]      200M   100M   100M  04 [-none-] [SCR_MNT]
-Disk quotas for Group #254 (254)
-Filesystem    Files  Quota  Limit Warn/Time    Mounted on
-[SCR_DEV]         1      1      2  03  [1 day] [SCR_MNT]
-
-checking limit command, pass2 (type=g)
-Disk quotas for Group #254 (254)
-Filesystem   Blocks  Quota  Limit Warn/Time    Mounted on
-[SCR_DEV]      200M   300M   400M  00 [------] [SCR_MNT]
-Disk quotas for Group #254 (254)
-Filesystem    Files  Quota  Limit Warn/Time    Mounted on
-[SCR_DEV]         1     8k   8.8k  03 [------] [SCR_MNT]
+checking report command (type=g)
+fsgqa 1024 512 2048 00 [3 days] 15 10 20 00 [3 days]
+
+off and remove test
+
+checking limit command (type=g, bsoft=100m, bhard=100m, isoft=100, ihard=100)
+
+checking quota command (type=g)
+SCRATCH_DEV 1024 102400 102400 00 [--------] 15 100 100 00 [--------] SCRATCH_MNT
+
+checking off command (type=g)
+Group quota are not enabled on SCRATCH_DEV
+
+checking state command (type=g)
+
+checking remove command (type=g)
+Group quota are not enabled on SCRATCH_DEV
+
+checking report command (type=g)
+
+quota remount
+
+checking report command (type=g)
+fsgqa 1024 0 0 00 [--------] 15 0 0 00 [--------]
+
+restore quota
 
-checking dump command (type=g)
-fs = [SCR_DEV]
-254         614400  819200    8000    8800  634880  839680
-changing limits (type=g)
-Disk quotas for Group #254 (254)
-Filesystem    Files  Quota  Limit Warn/Time    Mounted on
-[SCR_DEV]         1   1000   1.1k  00 [------] [SCR_MNT]
 checking restore command (type=g)
-Disk quotas for Group #254 (254)
-Filesystem    Files  Quota  Limit Warn/Time    Mounted on
-[SCR_DEV]         1     8k   8.8k  00 [------] [SCR_MNT]
+
+checking report command (type=g)
+fsgqa 1024 512 2048 00 [7 days] 15 10 20 00 [7 days]
+
 
 checking state command (type=g)
-Group quota state on [SCR_MNT] ([SCR_DEV])
-  Accounting: ON
-  Enforcement: ON
-  Inode: #[INO] (X blocks, Y extents)
-Blocks grace time: [3 days]
-Inodes grace time: [2 days]
+Group quota state on SCRATCH_MNT (SCRATCH_DEV)
+ Accounting: ON
+ Enforcement: ON
+ Inode: #[INO] (X blocks, Y extents)
+Blocks grace time: [7 days]
+Inodes grace time: [7 days]
 Realtime Blocks grace time: [7 days]
+cleanup files
+----------------------- pquota,sync ---------------------------
+init quota limit and timer, and dump it
+create_files 1024k 15
+quota remount
 
+checking quot command (type=p)
+SCRATCH_DEV (SCRATCH_MNT) Project:
+ 1024 15 fsgqa 
 
+checking timer command (type=p)
 
-checking quot command (type=p)
+checking limit command (type=p, bsoft=512k, bhard=2048k, isoft=10, ihard=20)
+
+checking dump command (type=p)
+report options test
 
 checking report command (type=p)
-Project quota on [SCR_MNT] ([SCR_DEV])
-                        Blocks              
-Project ID   Used   Soft   Hard Warn/Grace   
----------- --------------------------------- 
-#0          85.0M      0      0  00 [------]
-#1           6.1M      0      0  00 [------]
-#2           676K      0      0  00 [------]
-#3           1.9M      0      0  00 [------]
-#4           604K      0      0  00 [------]
-#5           224K      0      0  00 [------]
-#6           504K      0      0  00 [------]
-#7             4K      0      0  00 [------]
-#8           400K      0      0  00 [------]
-#9              0      0      0  00 [------]
-#10           56K      0      0  00 [------]
-#11          2.6M      0      0  00 [------]
-#12          892K      0      0  00 [------]
-#13             0      0      0  00 [------]
-#14             0      0      0  00 [------]
-#15             0      0      0  00 [------]
-#17             0      0      0  00 [------]
-#20             0      0      0  00 [------]
-#21          616K      0      0  00 [------]
-#22             0      0      0  00 [------]
-#23          472K      0      0  00 [------]
-#24             0      0      0  00 [------]
-#25           36K      0      0  00 [------]
-#26          1.1M      0      0  00 [------]
-#27          128K      0      0  00 [------]
-#28             0      0      0  00 [------]
-#30          248K      0      0  00 [------]
-#31          1.0M      0      0  00 [------]
-#33             0      0      0  00 [------]
-#34             0      0      0  00 [------]
-#35             0      0      0  00 [------]
-#36             0      0      0  00 [------]
-#37             0      0      0  00 [------]
-#38          240K      0      0  00 [------]
-#41          412K      0      0  00 [------]
-#43           32K      0      0  00 [------]
-#44             0      0      0  00 [------]
-#45             0      0      0  00 [------]
-#46             0      0      0  00 [------]
-#49             0      0      0  00 [------]
-#51          124K      0      0  00 [------]
-#53             0      0      0  00 [------]
-#55             0      0      0  00 [------]
-#56          176K      0      0  00 [------]
-#57          288K      0      0  00 [------]
-#58          528K      0      0  00 [------]
-#59             0      0      0  00 [------]
-#67            4K      0      0  00 [------]
-#69          624K      0      0  00 [------]
-#70             0      0      0  00 [------]
-#71             0      0      0  00 [------]
-#72          632K      0      0  00 [------]
-#73             0      0      0  00 [------]
-#75             0      0      0  00 [------]
-#79          100K      0      0  00 [------]
-#87          1.2M      0      0  00 [------]
-#88             0      0      0  00 [------]
-#91             0      0      0  00 [------]
-#94            4K      0      0  00 [------]
-#99          248K      0      0  00 [------]
-#101            0      0      0  00 [------]
-#108            0      0      0  00 [------]
-#112          64K      0      0  00 [------]
-#115         296K      0      0  00 [------]
-#121            0      0      0  00 [------]
-#127            0      0      0  00 [------]
-#254         200M   300M   400M  00 [------]
+Project quota on SCRATCH_MNT (SCRATCH_DEV)
+ Blocks Inodes 
+Project ID Used Soft Hard Warn/Grace Used Soft Hard Warn/ Grace 
+---------- -------------------------------------------------- -------------------------------------------------- 
+fsgqa 1024 512 2048 00 [3 days] 15 10 20 00 [3 days]
 
+-N option
+checking report command (type=p)
+fsgqa 1024 512 2048 00 [3 days] 15 10 20 00 [3 days]
 
-checking timer command (type=p)
+-L -U options
+checking report command (type=p)
+Project quota on SCRATCH_MNT (SCRATCH_DEV)
+ Blocks Inodes 
+Project ID Used Soft Hard Warn/Grace Used Soft Hard Warn/ Grace 
+---------- -------------------------------------------------- -------------------------------------------------- 
+#ID 1024 512 2048 00 [3 days] 15 10 20 00 [3 days]
 
-checking limit command, pass 1 (type=p)
-Disk quotas for Project #253 (253)
-Filesystem   Blocks  Quota  Limit Warn/Time    Mounted on
-[SCR_DEV]         0   100M   100M  00 [------] [SCR_MNT]
-Disk quotas for Project #253 (253)
-Filesystem    Files  Quota  Limit Warn/Time    Mounted on
-[SCR_DEV]         0      1      2  00 [------] [SCR_MNT]
-
-checking warn command (type=p)
-Disk quotas for Project #253 (253)
-Filesystem   Blocks  Quota  Limit Warn/Time    Mounted on
-[SCR_DEV]         0   100M   100M  00 [------] [SCR_MNT]
-Disk quotas for Project #253 (253)
-Filesystem    Files  Quota  Limit Warn/Time    Mounted on
-[SCR_DEV]         0      1      2  00 [------] [SCR_MNT]
-
-checking limit command, pass2 (type=p)
-Disk quotas for Project #253 (253)
-Filesystem   Blocks  Quota  Limit Warn/Time    Mounted on
-[SCR_DEV]         0   300M   400M  00 [------] [SCR_MNT]
-Disk quotas for Project #253 (253)
-Filesystem    Files  Quota  Limit Warn/Time    Mounted on
-[SCR_DEV]         0     8k   8.8k  00 [------] [SCR_MNT]
+-t option
+checking report command (type=p)
+Project quota on SCRATCH_MNT (SCRATCH_DEV)
+ Blocks Inodes 
+Project ID Used Soft Hard Warn/Grace Used Soft Hard Warn/ Grace 
+---------- -------------------------------------------------- -------------------------------------------------- 
+fsgqa 1024 512 2048 00 [3 days] 15 10 20 00 [3 days]
 
-checking dump command (type=p)
-fs = [SCR_DEV]
-253         614400  819200    8000    8800  634880  839680
-fs = [SCR_DEV]
-254         614400  819200    8000    8800  634880  839680
-changing limits (type=p)
-Disk quotas for Project #253 (253)
-Filesystem    Files  Quota  Limit Warn/Time    Mounted on
-[SCR_DEV]         0   1000   1.1k  00 [------] [SCR_MNT]
-checking restore command (type=p)
-Disk quotas for Project #253 (253)
-Filesystem    Files  Quota  Limit Warn/Time    Mounted on
-[SCR_DEV]         0     8k   8.8k  00 [------] [SCR_MNT]
+-n option
+checking report command (type=p)
+Project quota on SCRATCH_MNT (SCRATCH_DEV)
+ Blocks Inodes 
+Project ID Used Soft Hard Warn/Grace Used Soft Hard Warn/ Grace 
+---------- -------------------------------------------------- -------------------------------------------------- 
+#ID 1024 512 2048 00 [3 days] 15 10 20 00 [3 days]
 
-checking state command (type=p)
-Project quota state on [SCR_MNT] ([SCR_DEV])
-  Accounting: ON
-  Enforcement: ON
-  Inode: #[INO] (X blocks, Y extents)
+-h option
+checking report command (type=p)
+Project quota on SCRATCH_MNT (SCRATCH_DEV)
+ Blocks Inodes 
+Project ID Used Soft Hard Warn/Grace Used Soft Hard Warn/Grace 
+---------- --------------------------------- --------------------------------- 
+fsgqa 1M 512K 2M 00 [3 days] 15 10 20 00 [3 days]
+
+quot options test
+
+checking quot command (type=p)
+SCRATCH_DEV (SCRATCH_MNT) Project:
+ 1024 15 fsgqa 
+-f option
+checking quot command (type=p)
+SCRATCH_DEV (SCRATCH_MNT) Project:
+ 1024 15 fsgqa 
+-n option
+checking quot command (type=p)
+SCRATCH_DEV (SCRATCH_MNT) Project:
+ 1024 15 #ID 
+
+checking quota command (type=p)
+Disk quotas for Project fsgqa (ID)
+Filesystem Blocks Quota Limit Warn/Time Files Quota Limit Warn/Time Mounted on
+SCRATCH_DEV 1024 512 2048 00 [3 days] 15 10 20 00 [3 days] SCRATCH_MNT
+-f option
+checking quota command (type=p)
+Disk quotas for Project fsgqa (ID)
+Filesystem Blocks Quota Limit Warn/Time Files Quota Limit Warn/Time Mounted on
+SCRATCH_DEV 1024 512 2048 00 [3 days] 15 10 20 00 [3 days] SCRATCH_MNT
+-N option
+checking quota command (type=p)
+SCRATCH_DEV 1024 512 2048 00 [3 days] 15 10 20 00 [3 days] SCRATCH_MNT
+-n option
+checking quota command (type=p)
+Disk quotas for Project #ID (ID)
+Filesystem Blocks Quota Limit Warn/Time Files Quota Limit Warn/Time Mounted on
+SCRATCH_DEV 1024 512 2048 00 [3 days] 15 10 20 00 [3 days] SCRATCH_MNT
+-h option
+checking quota command (type=p)
+Disk quotas for Project fsgqa (ID)
+Filesystem Blocks Quota Limit Warn/Time Files Quota Limit Warn/Time Mounted on
+SCRATCH_DEV 1M 512K 2M 00 [3 days] 15 10 20 00 [3 days] SCRATCH_MNT
+disable quota
+
+checking disable command (type=p)
+Project quota state on SCRATCH_MNT (SCRATCH_DEV)
+ Accounting: ON
+ Enforcement: OFF
+ Inode: #[INO] (X blocks, Y extents)
 Blocks grace time: [3 days]
-Inodes grace time: [2 days]
+Inodes grace time: [3 days]
 Realtime Blocks grace time: [7 days]
 
+checking report command (type=p)
+fsgqa 1024 512 2048 00 [--------] 15 10 20 00 [--------]
+
+expect a remove error at here
+checking remove command (type=p)
+XFS_QUOTARM: Invalid argument
+
+checking enable command (type=p)
+Project quota state on SCRATCH_MNT (SCRATCH_DEV)
+ Accounting: ON
+ Enforcement: ON
+ Inode: #[INO] (X blocks, Y extents)
+Blocks grace time: [3 days]
+Inodes grace time: [3 days]
+Realtime Blocks grace time: [7 days]
+
+checking report command (type=p)
+fsgqa 1024 512 2048 00 [3 days] 15 10 20 00 [3 days]
+
+off and remove test
+
+checking limit command (type=p, bsoft=100m, bhard=100m, isoft=100, ihard=100)
 
+checking quota command (type=p)
+SCRATCH_DEV 1024 102400 102400 00 [--------] 15 100 100 00 [--------] SCRATCH_MNT
 
+checking off command (type=p)
+Project quota are not enabled on SCRATCH_DEV
+
+checking state command (type=p)
+
+checking remove command (type=p)
+Project quota are not enabled on SCRATCH_DEV
+
+checking report command (type=p)
+
+quota remount
+
+checking report command (type=p)
+fsgqa 1024 0 0 00 [--------] 15 0 0 00 [--------]
+
+restore quota
+
+checking restore command (type=p)
+
+checking report command (type=p)
+fsgqa 1024 512 2048 00 [7 days] 15 10 20 00 [7 days]
+
+
+checking state command (type=p)
+Project quota state on SCRATCH_MNT (SCRATCH_DEV)
+ Accounting: ON
+ Enforcement: ON
+ Inode: #[INO] (X blocks, Y extents)
+Blocks grace time: [7 days]
+Inodes grace time: [7 days]
+Realtime Blocks grace time: [7 days]
+cleanup files
diff --git a/tests/xfs/group b/tests/xfs/group
index 9f8ca0f..76cec6b 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -103,7 +103,7 @@
 103 metadata dir ioctl auto quick
 104 growfs ioctl prealloc auto stress
 105 fuzzers
-106 quota
+106 auto quick quota
 107 quota
 108 quota auto quick
 109 metadata auto
-- 
2.7.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
