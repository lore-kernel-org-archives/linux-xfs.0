Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o03ATNa7220022 for <xfs@oss.sgi.com>; Sun, 3 Jan 2010 04:29:23 -0600
Received: from moutng.kundenserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1B90915047B4
	for <xfs@oss.sgi.com>; Sun,  3 Jan 2010 02:30:09 -0800 (PST)
Received: from moutng.kundenserver.de (moutng.kundenserver.de
	[212.227.126.187]) by cuda.sgi.com with ESMTP id
	c3PlCNRRVCvT5FbE for <xfs@oss.sgi.com>;
	Sun, 03 Jan 2010 02:30:09 -0800 (PST)
Received: from localhost ([127.0.0.1])
	by bogon.housecafe.de with esmtp (Exim 4.69)
	(envelope-from <lists@nerdbynature.de>) id 1NRNin-0000MF-Ha
	for xfs@oss.sgi.com; Sun, 03 Jan 2010 11:30:05 +0100
Date: Sun, 3 Jan 2010 02:30:05 -0800 (PST)
From: Christian Kujau <lists@nerdbynature.de>
Subject: [PATCH] remove bashisms from xfstests
Message-ID: <alpine.DEB.2.01.1001030125040.3483@bogon.housecafe.de>
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

While trying to run xfstests, I encountered several errors due to the fact 
that my /bin/sh is not linked to /bin/bash but to dash(1), which can be 
made the default /bin/sh in Debian based systems. The patch below is 
rather large and is touching many files, but it's pretty straightfoward:

1) convert brace expansions (e.g. "rm -f symlink_{0,1,2,3}")
2) convert "let..." into something (hopefully) more portable
3) replace 'a == b' with 'a = b' in bourne shell scripts

With these changes applied, xfstests is actually running on this box 
(tested on Ubuntu/9.10). I don't have an IRIX system to test on though.
There are still a few things left to fix, as I'm still get a few errors
while running the tests, but without these changes the testsuit pretty
much would not run at all.

Thoughts?

Christian.

 71 files changed, 197 insertions(+), 175 deletions(-)

diff -Nrup xfstests.orig/005 xfstests/005
--- xfstests.orig/005	2010-01-03 00:42:16.471617592 -0800
+++ xfstests/005	2010-01-03 00:43:56.321617592 -0800
@@ -45,7 +45,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 1
 _cleanup()
 {
     cd $testdir
-    rm -f symlink_{0,1,2,3}{0,1,2,3,4,5,6,7,8,9} symlink_self empty_file
+    rm -f symlink_* empty_file
     cd /
     _cleanup_testdir
 }
@@ -70,7 +70,7 @@ _touch()
 _supported_fs generic
 
 # IRIX UDF does not support symlinks
-if [ $FSTYP == 'udf' ]; then
+if [ $FSTYP = 'udf' ]; then
     _supported_os Linux
 else
     _supported_os Linux IRIX
@@ -82,17 +82,24 @@ cd $testdir
 
 o=empty_file
 touch $o
-for f in symlink_{0,1,2,3}{0,1,2,3,4,5,6,7,8,9}
+f=1
+while [ $f -le 40 ]
 do
-    ln -s $o $f
+    ln -s $o symlink_$f
     o=$f
+    o=symlink_$f
+    f=$((f + 1))
 done
 
 ln -s symlink_self symlink_self
 
 echo "*** touch deep symlinks"
 echo ""
-_touch symlink_{0,1,2,3}{0,1,2,3,4,5,6,7,8,9}
+i=1
+while [ $i -le 40 ]; do
+	_touch symlink_"$i"
+	i=$((i + 1))
+done
 echo ""
 echo "*** touch recusive symlinks"
 echo ""
diff -Nrup xfstests.orig/007 xfstests/007
--- xfstests.orig/007	2010-01-03 00:42:16.481617592 -0800
+++ xfstests/007	2010-01-03 00:43:56.321617592 -0800
@@ -64,7 +64,7 @@ num_filenames=100
 i=1
 while [ $i -le $num_filenames ]; do
   echo "nametest.$i" >>$sourcefile
-  let i=$i+1
+  i=$((i + 1))
 done
 
 mkdir $testdir/$seq
diff -Nrup xfstests.orig/010 xfstests/010
--- xfstests.orig/010	2010-01-03 00:42:16.501617592 -0800
+++ xfstests/010	2010-01-03 00:43:56.321617592 -0800
@@ -36,7 +36,7 @@ _cleanup()
 {
     cd /
     rm -f $tmp.*
-    rm -f $testdir/DBtest*.{pag,dir}
+    rm -f $testdir/DBtest*.pag $testdir/DBtest*.dir
     _cleanup_testdir
 }
 
diff -Nrup xfstests.orig/016 xfstests/016
--- xfstests.orig/016	2010-01-03 00:42:16.521617592 -0800
+++ xfstests/016	2010-01-03 00:43:56.321617592 -0800
@@ -102,7 +102,7 @@ _log_traffic()
     do
         touch $out
         rm $out
-        let "count = count - 1"
+        count=$((count - 1))
     done
 
     echo "   *** unmount"
diff -Nrup xfstests.orig/020 xfstests/020
--- xfstests.orig/020	2010-01-03 00:42:16.541617592 -0800
+++ xfstests/020	2010-01-03 00:43:56.321617592 -0800
@@ -128,7 +128,7 @@ do
         exit 1
     fi
     
-    let "v = v + 1"
+    v=$((v + 1))
 done
 
 echo "*** check"
@@ -151,7 +151,7 @@ do
         exit 1
     fi
     
-    let "v = v + 1"
+    v=$((v + 1))
 done
 
 _attr_list $testfile
diff -Nrup xfstests.orig/028 xfstests/028
--- xfstests.orig/028	2010-01-03 00:42:16.581617592 -0800
+++ xfstests/028	2010-01-03 00:43:56.321617592 -0800
@@ -58,7 +58,7 @@ while [ $i -lt 5 ]; do
     fi
     rm $dump_file
     sleep 2
-    let i=$i+1
+    i=$((i + 1))
 done
 
 echo "middate = $middate" >>$seq.full
--- xfstests.orig/031	2010-01-03 00:42:16.591617592 -0800
+++ xfstests/031	2010-01-03 02:19:04.505494591 -0800
@@ -69,6 +69,7 @@ _check_repair()
 _create_proto()
 {
 	total=$1
+	isize=256
 	count=0
 
 	# take inode size into account for non-shortform directories...
@@ -85,7 +86,7 @@ EOF
 
 	while [ $count -lt $total ]
 	do
-		let count=$count+1
+		count=$((count + 1))
 		cat >>$tmp.proto <<EOF
 ${count}_of_${total}_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx ---755 3 1 /bin/true
 EOF
diff -Nrup xfstests.orig/032 xfstests/032
--- xfstests.orig/032	2010-01-03 00:42:16.601617592 -0800
+++ xfstests/032	2010-01-03 00:43:56.321617592 -0800
@@ -66,6 +66,7 @@ do
 	[ $fs = ext3 ] && preargs="-F"
 	[ $fs = ext4 ] && preargs="-F"
 	[ $fs = ext4dev ] && preargs="-F"
+	[ $fs = nilfs2 ] && preargs="-q"
 
 	# overwite the first few Kb - should blow away superblocks
 	src/devzero -n 20 $SCRATCH_DEV >/dev/null
diff -Nrup xfstests.orig/043 xfstests/043
--- xfstests.orig/043	2010-01-03 00:42:16.651617592 -0800
+++ xfstests/043	2010-01-03 00:43:56.321617592 -0800
@@ -49,7 +49,7 @@ _require_tape $TAPE_DEV 
 _create_dumpdir_fill
 _erase_hard
 _do_dump_sub
-rm -rf /var/{,lib/}xfsdump/inventory # delete it - let cleanup fix it
+rm -rf /var/lib/xfsdump/inventory /var/xfsdump/inventory # delete it - let cleanup fix it
 _do_restore
 _diff_compare_sub
 _ls_compare_sub
diff -Nrup xfstests.orig/044 xfstests/044
--- xfstests.orig/044	2010-01-03 00:42:16.661617592 -0800
+++ xfstests/044	2010-01-03 00:43:56.321617592 -0800
@@ -172,7 +172,7 @@ echo "*** write large dirty log"
 $here/src/loggen -u 2 -e 16000 -z 100 >$SCRATCH_LOGDEV
 _check_mount
 
-echo -e -n "\n\r*** XFS QA 044 - done\n\r\n\r" >/dev/console
+printf "\n\r*** XFS QA 044 - done\n\r\n\r" >/dev/console
 
 status=0
 # if error
diff -Nrup xfstests.orig/047 xfstests/047
--- xfstests.orig/047	2010-01-03 00:42:16.671617592 -0800
+++ xfstests/047	2010-01-03 00:43:56.321617592 -0800
@@ -58,7 +58,7 @@ while [ $i -lt 5 ]; do
     fi
     rm $dump_file
     sleep 2
-    let i=$i+1
+    i=$((i + 1))
 done
 
 echo "middate = $middate" >>$seq.full
diff -Nrup xfstests.orig/050 xfstests/050
--- xfstests.orig/050	2010-01-03 00:42:16.681617592 -0800
+++ xfstests/050	2010-01-03 00:43:56.321617592 -0800
@@ -181,7 +181,7 @@ EOF
 projid_file="$tmp.projid"
 
 echo "*** user"
-if [ "$HOSTOS" == "IRIX" ]
+if [ "$HOSTOS" = "IRIX" ]
 then
 	_qmount_option "quota"
 else
@@ -194,7 +194,7 @@ _qmount_option "gquota"
 _exercise
 
 echo "*** uqnoenforce"
-if [ "$HOSTOS" == "IRIX" ]
+if [ "$HOSTOS" = "IRIX" ]
 then
 	_qmount_option "qnoenforce"
 else
diff -Nrup xfstests.orig/051 xfstests/051
--- xfstests.orig/051	2010-01-03 00:42:16.691617592 -0800
+++ xfstests/051	2010-01-03 00:43:56.321617592 -0800
@@ -289,16 +289,13 @@ chacl -l acldir/file2 | _acl_filter_id
 echo ""
 echo "=== Recursive change ACL ==="
 rm -fr root
-mkdir root
-pushd root >/dev/null
 # create an arbitrary little tree
 for i in 1 2 3 4 5 6 7 8 9 0
 do
-	mkdir -p a/$i
-	mkdir -p b/c$i/$i
-	touch a/$i/mumble
+	mkdir -p root/a/$i
+	mkdir -p root/b/c$i/$i
+	touch root/a/$i/mumble
 done
-popd >/dev/null
 chown -R 12345.54321 root
 echo "Change #1..."
 $runas -u 12345 -g 54321 -- `which chacl` -r u::rwx,g::-w-,o::--x root
diff -Nrup xfstests.orig/053 xfstests/053
--- xfstests.orig/053	2010-01-03 00:42:16.701617592 -0800
+++ xfstests/053	2010-01-03 00:43:56.321617592 -0800
@@ -68,7 +68,7 @@ for acl in $acls
 do
   _do "touch $test.$i"
   _do "chacl $acl $test.$i"
-  let i=$i+1
+  i=$((i + 1))
 done
 
 list_acls()
@@ -77,7 +77,7 @@ list_acls()
   for acl in $acls
   do
     chacl -l $test.$i | _acl_filter_id | sed -e "s!$SCRATCH_MNT!\$SCRATCH_MNT!"
-    let i=$i+1
+    i=$((i + 1))
   done
 }
 
diff -Nrup xfstests.orig/064 xfstests/064
--- xfstests.orig/064	2010-01-03 00:42:16.751617592 -0800
+++ xfstests/064	2010-01-03 00:43:56.321617592 -0800
@@ -72,7 +72,7 @@ while [ $i -le 9 ]; do
     date >>$seq.full
     find $SCRATCH_MNT -exec $here/src/lstat64 {} \; | sed 's/(00.*)//' >$tmp.dates.$i
     if [ $i -gt 0 ]; then
-       let level_1=$i-1
+       level_1=$((i - 1))
        diff -c $tmp.dates.$level_1 $tmp.dates.$i >>$seq.full
     else
        cat $tmp.dates.$i >>$seq.full
@@ -80,7 +80,7 @@ while [ $i -le 9 ]; do
 
     dump_file=$tmp.df.level$i
     _do_dump_file -l $i
-    let i=$i+1
+    i=$((i + 1))
 done
 
 echo "Listing of what files we start with:"
@@ -93,7 +93,7 @@ while [ $i -le 9 ]; do
     echo "restoring from df.level$i"
     dump_file=$tmp.df.level$i
     _do_restore_toc
-    let i=$i+1
+    i=$((i + 1))
 done
 
 echo "Do the cumulative restores"
@@ -105,7 +105,7 @@ while [ $i -le 9 ]; do
     _do_restore_file_cum -l $i
     echo "ls -l restore_dir"
     ls -lR $restore_dir | _ls_size_filter | _check_quota_file
-    let i=$i+1
+    i=$((i + 1))
 done
 
 # success, all done
diff -Nrup xfstests.orig/065 xfstests/065
--- xfstests.orig/065	2010-01-03 00:42:16.751617592 -0800
+++ xfstests/065	2010-01-03 00:43:56.321617592 -0800
@@ -160,7 +160,7 @@ while [ $i -le $num_dumps ]; do
 
     dump_file=$tmp.df.level$i
     _do_dump_file -l $i
-    let i=$i+1
+    i=$((i + 1))
 done
 
 echo "Look at what files are contained in the inc. dump"
@@ -170,7 +170,7 @@ while [ $i -le $num_dumps ]; do
     echo "restoring from df.level$i"
     dump_file=$tmp.df.level$i
     _do_restore_toc
-    let i=$i+1
+    i=$((i + 1))
 done
 
 echo "Do the cumulative restores"
@@ -182,7 +182,7 @@ while [ $i -le $num_dumps ]; do
     _do_restore_file_cum -l $i
     echo "list restore_dir"
     _list_dir $restore_dir | _check_quota_file | tee $tmp.restorals.$i
-    let i=$i+1
+    i=$((i + 1))
 done
 
 echo ""
@@ -192,7 +192,7 @@ while [ $i -le $num_dumps ]; do
     echo "Comparing ls of FS with restored FS at level $i"
     diff -s $tmp.ls.$i $tmp.restorals.$i | sed "s#$tmp#TMP#g"
     echo ""
-    let i=$i+1
+    i=$((i + 1))
 done
 
 
diff -Nrup xfstests.orig/067 xfstests/067
--- xfstests.orig/067	2010-01-03 00:42:16.761617592 -0800
+++ xfstests/067	2010-01-03 00:43:56.321617592 -0800
@@ -50,7 +50,7 @@ _require_scratch
 # set up fs for 1K inodes
 isize=0
 _scratch_mkfs_xfs | _filter_mkfs >$seq.full 2>$tmp.mkfs
-[ $? -eq 0 ] && source $tmp.mkfs
+[ $? -eq 0 ] && . $tmp.mkfs
 if [ "$isize" -lt 1024 ]; then
     _scratch_mkfs_xfs -i size=1024 >>$here/$seq.full \
 	|| _notrun "Cannot mkfs for this test using MKFS_OPTIONS specified"
diff -Nrup xfstests.orig/068 xfstests/068
--- xfstests.orig/068	2010-01-03 00:42:16.771617592 -0800
+++ xfstests/068	2010-01-03 00:43:56.331617592 -0800
@@ -89,7 +89,7 @@ touch $tmp.running
 } &
 
 i=0
-let ITERATIONS=$ITERATIONS-1
+ITERATIONS=$((ITERATIONS - 1))
 
 echo | tee -a $seq.full
 while [ $i -le $ITERATIONS ]
@@ -108,7 +108,7 @@ do
 	sleep 2
 
 	echo  | tee -a $seq.full
-	let i=$i+1
+	i=$((i + 1))
 done
 
 # stop fsstress iterations
diff -Nrup xfstests.orig/071 xfstests/071
--- xfstests.orig/071	2010-01-03 00:42:16.781617592 -0800
+++ xfstests/071	2010-01-03 00:43:56.331617592 -0800
@@ -145,7 +145,7 @@ do
     echo === Iterating, `expr $upperbound - $count` remains
     echo
     echo
-    let count=$count+1
+    count=$((count + 1))
 done
 
 # success, all done
diff -Nrup xfstests.orig/074 xfstests/074
--- xfstests.orig/074	2010-01-03 00:42:16.801617592 -0800
+++ xfstests/074	2010-01-03 00:43:56.331617592 -0800
@@ -119,7 +119,7 @@ _supported_os IRIX Linux
 # These params can take a while on different CPUs/OSs
 # so we set them differently for different machines
 #
-if [ $HOSTOS == "IRIX" ]; then 
+if [ $HOSTOS = "IRIX" ]; then 
     if uname -R | grep -iq debug; then 
         # e.g. getting around 37secs for 1,1,1 on IP30 debug
 	numchildren=2
@@ -133,7 +133,7 @@ if [ $HOSTOS == "IRIX" ]; then 
 	numchildren=3
         param_type="IRIX nondebug"
     fi
-elif [ $HOSTOS == "Linux" ]; then
+elif [ $HOSTOS = "Linux" ]; then
     if uname -a | grep -q SMP; then
         numloops=10
         numfiles=5
diff -Nrup xfstests.orig/075 xfstests/075
--- xfstests.orig/075	2010-01-03 00:42:16.801617592 -0800
+++ xfstests/075	2010-01-03 00:43:56.331617592 -0800
@@ -79,7 +79,7 @@ _do_test()
     cd $out
     if ! $here/ltp/fsx $_param -P $here $seq.$_n >/dev/null
     then
-	echo "    fsx ($_param) failed, $? - compare $seq.$_n.{good,bad,fsxlog}"
+	echo "    fsx ($_param) failed, $? - compare $seq.$_n.good/bad/fsxlog"
 	mv $out/$seq.$_n $here/$seq.$_n.full
 	od -xAx $here/$seq.$_n.full > $here/$seq.$_n.bad
 	od -xAx $here/$seq.$_n.fsxgood > $here/$seq.$_n.good
@@ -159,5 +159,5 @@ _do_test 1 "-d -N $numops1 -S 0 -x"
 _do_test 2 "-d -N $numops2 -l $filelen -S 0"
 _do_test 3 "-d -N $numops2 -l $filelen -S 0 -x"
 
-rm -f $seq.*.fsx{good,log}
+rm -f $seq.*.fsxgood $seq.*.fsxlog
 exit 0
diff -Nrup xfstests.orig/084 xfstests/084
--- xfstests.orig/084	2010-01-03 00:42:16.841617592 -0800
+++ xfstests/084	2010-01-03 00:43:56.331617592 -0800
@@ -54,7 +54,7 @@ pgsize=`$here/src/feature -s`
 _supported_fs xfs
 _supported_os IRIX Linux
 
-if [ $HOSTOS == "IRIX" ]; then 
+if [ $HOSTOS = "IRIX" ]; then 
     if uname -R | grep -iq debug; then 
         # taking up to 23 mins on my 512K octane on debug
         # not worth worrying about
diff -Nrup xfstests.orig/085 xfstests/085
--- xfstests.orig/085	2010-01-03 00:42:16.851617592 -0800
+++ xfstests/085	2010-01-03 00:43:56.331617592 -0800
@@ -58,7 +58,11 @@ _scratch_mount >>$seq.full 2>&1 \
     || _fail "mount failed: $MOUNT_OPTIONS"
 
 echo "touch files"
-touch $SCRATCH_MNT/{0,1,2,3,4,5,6,7,8,9}{0,1,2,3,4,5,6,7,8,9}
+f=1
+while [ $f -le 100 ]; do
+	touch $SCRATCH_MNT/$f
+	f=$((f + 1))
+done
 
 echo "godown"
 src/godown -v -f $SCRATCH_MNT >> $seq.full
diff -Nrup xfstests.orig/086 xfstests/086
--- xfstests.orig/086	2010-01-03 00:42:16.851617592 -0800
+++ xfstests/086	2010-01-03 00:43:56.331617592 -0800
@@ -102,15 +102,22 @@ for s in sync nosync ; do
 	if [ $s = "sync" ]; then
 	    # generate some log traffic - but not too much
 	    # add some syncs to get the log flushed to disk 
-	    for file in $SCRATCH_MNT/{0,1,2,3,4,5,6,7,8,9}{0,1,2,3,4,5,6,7,8,9}; do
-		touch $file
+	    file=1
+	    while [ $file -le 100 ]; do
+		touch $SCRATCH_MNT/$file
+		file=$((file + 1))
 		sync
 	    done
 	else
 	    # generate some log traffic - but not too much - life gets a little
 	    # more complicated if the log wraps around. This traffic is
 	    # pretty much arbitary, but could probably be made better than this.
-	    touch $SCRATCH_MNT/{0,1,2,3,4,5,6,7,8,9}{0,1,2,3,4,5,6,7,8,9}
+	    file=1
+	    while [ $file -le 100 ]; do
+		touch $SCRATCH_MNT/$file
+		file=$((file + 1))
+		sync
+	    done
 	fi
 
 	# check before on what FS should look like
diff -Nrup xfstests.orig/089 xfstests/089
--- xfstests.orig/089	2010-01-03 00:42:16.871617592 -0800
+++ xfstests/089	2010-01-03 00:43:56.331617592 -0800
@@ -44,7 +44,7 @@ addentries()
 
 	while [ $count -gt 0 ]; do
 		touch `printf $pattern $count`
-		let count=$count-1
+		count=$((count - 1))
 	done
 }
 
diff -Nrup xfstests.orig/091 xfstests/091
--- xfstests.orig/091	2010-01-03 00:42:16.881617592 -0800
+++ xfstests/091	2010-01-03 00:43:56.331617592 -0800
@@ -40,7 +40,7 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2
 _supported_fs xfs
 _supported_os Linux IRIX
 
-[ $HOSTOS == IRIX ] && _notrun "Not working on IRIX yet"
+[ $HOSTOS = IRIX ] && _notrun "Not working on IRIX yet"
 
 rm -f $seq.full
 
@@ -66,7 +66,7 @@ kernel=`uname -r  | sed -e 's/\(2\..\).*
 if [ "$HOSTOS" = "Linux" -a "$kernel" = "2.6" ]; then
 	xfs_info $TEST_DIR | _filter_mkfs 2> $tmp.info > /dev/null
 	if [ $? -eq 0 ]; then
-		source $tmp.info
+		. $tmp.info
 		bsize=$sectsz
 	fi
 fi
diff -Nrup xfstests.orig/097 xfstests/097
--- xfstests.orig/097	2010-01-03 00:42:16.911617592 -0800
+++ xfstests/097	2010-01-03 00:43:56.331617592 -0800
@@ -49,7 +49,7 @@ _umount_and_mount()
 {
     cd /
     umount $TARGET_DIR
-    if [ "$FSTYP" == "xfs" ]; then
+    if [ "$FSTYP" = "xfs" ]; then
 	_test_mount
     else
 	_scratch_mount
@@ -65,7 +65,7 @@ _umount_and_mount()
 # link correct .out file
 # This is done bacause udf and xfs print attrs in different orders.
 rm -rf $seq.out
-if [ "$FSTYP" == "xfs" ]; then
+if [ "$FSTYP" = "xfs" ]; then
     ln -s $seq.out.xfs $seq.out
 else
     ln -s $seq.out.udf $seq.out
@@ -79,7 +79,7 @@ _require_scratch
 _setup_testdir 
 
 TARGET_DIR=$SCRATCH_MNT
-[ "$FSTYP" == "xfs" ] && TARGET_DIR=$TEST_DIR
+[ "$FSTYP" = "xfs" ] && TARGET_DIR=$TEST_DIR
 cd $TARGET_DIR
 
 echo "create file foo"
diff -Nrup xfstests.orig/099 xfstests/099
--- xfstests.orig/099	2010-01-03 00:42:16.921617592 -0800
+++ xfstests/099	2010-01-03 00:43:56.331617592 -0800
@@ -40,7 +40,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 1
 runas=$here/src/runas
 
 TARGET_DIR=$SCRATCH_MNT
-[ "$FSTYP" == "xfs" ] && TARGET_DIR=$TEST_DIR
+[ "$FSTYP" = "xfs" ] && TARGET_DIR=$TEST_DIR
 
 _cleanup()
 {
@@ -331,7 +331,7 @@ _acl_list largeaclfile | _filter_aces_no
 
 #-------------------------------------------------------
 
-if [ "$FSTYP" == "udf" ]; then
+if [ "$FSTYP" = "udf" ]; then
     cd /
     umount $TARGET_DIR
     # Check the filesystem
diff -Nrup xfstests.orig/100 xfstests/100
--- xfstests.orig/100	2010-01-03 00:42:16.921617592 -0800
+++ xfstests/100	2010-01-03 00:43:56.331617592 -0800
@@ -48,7 +48,7 @@ _supported_os IRIX Linux
 
 # Use _populate_fs() in common.rc to create a directory structure.
 TEMP_DIR=/tmp
-[ "$FSTYP" == "xfs" ] && TEMP_DIR=$TEST_DIR
+[ "$FSTYP" = "xfs" ] && TEMP_DIR=$TEST_DIR
 TAR_FILE=temp.tar
 NDIRS=3
 NFILES=6
diff -Nrup xfstests.orig/105 xfstests/105
--- xfstests.orig/105	2010-01-03 00:42:16.941617592 -0800
+++ xfstests/105	2010-01-03 00:43:56.331617592 -0800
@@ -79,9 +79,9 @@ echo data > subdir/file
 ls -l subdir/file | awk '{ print $1, $3 }'
 
 # add an ACL with a user ACE which has no exec permission 
-if [ "$HOSTOS" == "Linux" ]; then
+if [ "$HOSTOS" = "Linux" ]; then
     setfacl -m u:$acl1:r subdir
-elif [ "$HOSTOS" == "IRIX" ]; then
+elif [ "$HOSTOS" = "IRIX" ]; then
     chacl u:$acl:r--,g::---,o::--- subdir
 else
     echo "Unknown OS!"
diff -Nrup xfstests.orig/108 xfstests/108
--- xfstests.orig/108	2010-01-03 00:42:16.961617592 -0800
+++ xfstests/108	2010-01-03 00:43:56.331617592 -0800
@@ -55,11 +55,11 @@ _require_prjquota
 test_files()
 {
 	echo; echo "### create files, setting up ownership (type=$type)"
-	rm -f $SCRATCH_MNT/{buffer,direct,mmap}
-	$XFS_IO_PROG -fc "chproj $prid" $SCRATCH_MNT/{buffer,direct,mmap}
-	chown $uid $SCRATCH_MNT/{buffer,direct,mmap}
-	chgrp $gid $SCRATCH_MNT/{buffer,direct,mmap}
-	for file in $SCRATCH_MNT/{buffer,direct,mmap}; do
+	rm -f $SCRATCH_MNT/buffer $SCRATCH_MNT/direct $SCRATCH_MNT/mmap
+	$XFS_IO_PROG -fc "chproj $prid" $SCRATCH_MNT/buffer $SCRATCH_MNT/direct $SCRATCH_MNT/mmap
+	chown $uid $SCRATCH_MNT/buffer $SCRATCH_MNT/direct $SCRATCH_MNT/mmap
+	chgrp $gid $SCRATCH_MNT/buffer $SCRATCH_MNT/direct $SCRATCH_MNT/mmap
+	for file in $SCRATCH_MNT/buffer $SCRATCH_MNT/direct $SCRATCH_MNT/mmap; do
 		$here/src/lstat64 $file | head -3 | filter_scratch
 		$XFS_IO_PROG -c lsproj $file
 	done
@@ -78,7 +78,7 @@ test_accounting()
 	wait
 	echo "--- completed parallel IO ($type)" >>$seq.full
 
-	for file in $SCRATCH_MNT/{buffer,direct,mmap}; do
+	for file in $SCRATCH_MNT/buffer $SCRATCH_MNT/direct $SCRATCH_MNT/mmap; do
 		$here/src/lstat64 $file | head -3 | filter_scratch
 	done
 	xfs_quota -c "quota -hnb -$type $id" $QARGS | filter_scratch
diff -Nrup xfstests.orig/109 xfstests/109
--- xfstests.orig/109	2010-01-03 00:42:16.961617592 -0800
+++ xfstests/109	2010-01-03 00:43:56.331617592 -0800
@@ -52,7 +52,7 @@ populate()
 	while [ $i -le $files -a "X$faststart" = "X" ]; do
 		file=$SCRATCH_MNT/f$i
 		xfs_io -f -d -c 'pwrite -b 64k 0 64k' $file >/dev/null
-		let i=$i+1
+		i=$((i + 1))
 	done
 
 	# remove every second file, freeing up lots of space
@@ -60,7 +60,7 @@ populate()
 	i=1
 	while [ $i -le $files -a "X$faststart" = "X" ]; do
 		rm $SCRATCH_MNT/f$i
-		let i=$i+2
+		i=$((i + 2))
 	done
 
 	echo "flushing changes via umount/mount."
@@ -81,10 +81,10 @@ allocate()
 				xfs_io -f -c 'pwrite -b 64k 0 16m' $file \
 					>/dev/null 2>&1
 				rm $file
-				let j=$j+1
+				j=$((j + 1))
 			done
 		} &
-		let i=$i+1
+		i=$((i + 1))
 	done
 
 	wait
diff -Nrup xfstests.orig/110 xfstests/110
--- xfstests.orig/110	2010-01-03 00:42:16.971617592 -0800
+++ xfstests/110	2010-01-03 00:43:56.331617592 -0800
@@ -66,8 +66,8 @@ E=10030600
 while [ $I -le $E ]
 do
     echo > $SCRATCH_MNT/test/${STR1}${STR2}${STR3}${I}
-    let I=$I+1
-    [ $[$I % 1000] -eq 0 ] && echo "Created $I/$E"
+    I=$((I + 1))
+    [ `expr $I % 1000` -eq 0 ] && echo "Created $I/$E"
 done
 
 sync
@@ -77,7 +77,7 @@ E=10030599
 while [ $I -le $E ]
 do
     rm $SCRATCH_MNT/test/${STR1}${STR2}${STR3}${I} &
-    let I=$I+1
+    I=$((I + 1))
 done
 
 _check_scratch_fs
diff -Nrup xfstests.orig/111 xfstests/111
--- xfstests.orig/111	2010-01-03 00:42:16.971617592 -0800
+++ xfstests/111	2010-01-03 00:43:56.331617592 -0800
@@ -55,7 +55,7 @@ I=0
 while [ $I -lt 1000 ]
 do
     cp src/itrash.c $SCRATCH_MNT/${I}
-    let I=$I+1
+    I=$((I + 1))
 done
 umount $SCRATCH_DEV
 
diff -Nrup xfstests.orig/112 xfstests/112
--- xfstests.orig/112	2010-01-03 00:42:16.981617592 -0800
+++ xfstests/112	2010-01-03 00:43:56.331617592 -0800
@@ -161,5 +161,5 @@ _do_test 1 "-A -d -N $numops1 -S 0 -x"
 _do_test 2 "-A -d -N $numops2 -l $filelen -S 0"
 _do_test 3 "-A -d -N $numops2 -l $filelen -S 0 -x"
 
-rm -f $seq.*.fsx{good,log}
+rm -f $seq.*.fsxgood $seq.*.fsxlog
 exit 0
diff -Nrup xfstests.orig/113 xfstests/113
--- xfstests.orig/113	2010-01-03 00:42:16.981617592 -0800
+++ xfstests/113	2010-01-03 00:43:56.331617592 -0800
@@ -55,7 +55,7 @@ _do_test()
     [ $__proc -gt 1 ] && _param="-t $__proc $_param"
     while [ $__proc -gt 1 ]; do
         _files="$_files $testdir/aiostress.$$.$_n.$__proc"
-	let __proc=$__proc-1
+	__proc=$((__proc - 1))
     done
     rm -f $_files
  
diff -Nrup xfstests.orig/114 xfstests/114
--- xfstests.orig/114	2010-01-03 00:42:16.991617592 -0800
+++ xfstests/114	2010-01-03 00:43:56.331617592 -0800
@@ -149,8 +149,8 @@ _test_hardlink()
 	paths="$d/l1 $d/l2 $d/l3 $d2/l4 $d2/l5 $d2/l6"
 	i=0
 	for x in $paths; do
-		let i=$i+1
-		let j=$i%2
+		i=$((i + 1))
+		j=`expr $i % 2`
 		if [ $j -eq 0 ]; then
 			echo "rm'ing $x"
 			rm $x
diff -Nrup xfstests.orig/117 xfstests/117
--- xfstests.orig/117	2010-01-03 00:42:17.001617592 -0800
+++ xfstests/117	2010-01-03 00:43:56.331617592 -0800
@@ -85,7 +85,7 @@ while [ $i -lt $ITERATIONS ]; do
         -s $seed \
 	-S -p 1 -n 1000 >>$seq.full 2>&1
 
-    let i=$i+1
+    i=$((i + 1))
 done
 
 cd /
diff -Nrup xfstests.orig/118 xfstests/118
--- xfstests.orig/118	2010-01-03 00:42:17.011617592 -0800
+++ xfstests/118	2010-01-03 00:43:56.331617592 -0800
@@ -57,17 +57,17 @@ _require_quota
 _chowning_file()
 {
 	file=file.chown
-	let start=$1
-	let limit=$2
-	let delta=$3
+	start=$1
+	limit=$2
+	delta=$3
 
 	cd $SCRATCH_MNT
-	let count=$start
-	while (( count < limit )); do
+	count=$start
+	while [ $count -lt $limit ]; do
 	    touch $file
 	    chown $count.$count $file
-	    echo -n "."
-	    let count=count+delta
+	    printf "."
+	    count=$((count + delta))
 	done
 	echo ""
 }
diff -Nrup xfstests.orig/119 xfstests/119
--- xfstests.orig/119	2010-01-03 00:42:17.011617592 -0800
+++ xfstests/119	2010-01-03 00:43:56.331617592 -0800
@@ -68,7 +68,7 @@ while [ $i -lt $max ]; do
 	xfs_freeze -f $SCRATCH_MNT
 	xfs_freeze -u $SCRATCH_MNT
 	echo -n .
-	let i=$i+1
+	i=$((i + 1))
 done
 echo "done"
 
diff -Nrup xfstests.orig/122 xfstests/122
--- xfstests.orig/122	2010-01-03 00:42:17.021617592 -0800
+++ xfstests/122	2010-01-03 00:43:56.331617592 -0800
@@ -46,7 +46,7 @@ _require_command /usr/bin/indent
 _type_size_filter()
 {
 	# lazy SB adds __be32 agf_btreeblks - pv960372
-	if [ "$($MKFS_XFS_PROG 2>&1 | grep -c lazy-count )" == "0" ]; then
+	if [ "$($MKFS_XFS_PROG 2>&1 | grep -c lazy-count )" = "0" ]; then
 		perl -ne '
 s/sizeof\( xfs_agf_t \) = 60/sizeof( xfs_agf_t ) = <SIZE>/;
 		print;'
diff -Nrup xfstests.orig/123 xfstests/123
--- xfstests.orig/123	2010-01-03 00:42:17.031617592 -0800
+++ xfstests/123	2010-01-03 00:43:56.331617592 -0800
@@ -58,7 +58,7 @@ s,^\s*$,,;
 
 _user_do()
 {
-    if [ "$HOSTOS" == "IRIX" ]
+    if [ "$HOSTOS" = "IRIX" ]
 	then
 	echo $1 | /bin/sh "su $qa_user 2>&1" | _filter_user_do
     else
diff -Nrup xfstests.orig/124 xfstests/124
--- xfstests.orig/124	2010-01-03 00:42:17.031617592 -0800
+++ xfstests/124	2010-01-03 00:43:56.331617592 -0800
@@ -59,21 +59,21 @@ _scratch_mount
 for TESTFILE in $testdir/rw_pattern.tmp $SCRATCH_MNT/rw_pattern.tmp
   do
   count=1
-  while (( count < 101 ))
+  while [ $count -lt 101 ]
     do
     src/preallo_rw_pattern_writer $TESTFILE
     src/preallo_rw_pattern_reader $TESTFILE
-    if (test $? -ne 0) then
+    if [ $? -ne 0 ]; then
 	echo Read/Write Pattern Test FAILED.
 	_cleanup
 	exit 1
     fi
     rm $TESTFILE
-    ((count=count+1))
+    count=$((count + 1))
   done #done for count of  100
 done
 
-if (test $? -eq 0 ) then
+if [ $? -eq 0 ]; then
     status=0
 fi
 
diff -Nrup xfstests.orig/134 xfstests/134
--- xfstests.orig/134	2010-01-03 00:42:17.081617592 -0800
+++ xfstests/134	2010-01-03 00:43:56.331617592 -0800
@@ -101,7 +101,7 @@ cp $dir/2 $dir/3
 
 xfs_quota -D $tmp.projects -P $tmp.projid -x -c "repquota -inN -p" $SCRATCH_DEV | tr -s '[:space:]'
 
-if [ "$HOSTOS" == "IRIX" ] ; then
+if [ "$HOSTOS" = "IRIX" ] ; then
     mkfile 1M $TEST_DIR/6
 else
     xfs_mkfile 1M $TEST_DIR/6
diff -Nrup xfstests.orig/136 xfstests/136
--- xfstests.orig/136	2010-01-03 00:42:17.091617592 -0800
+++ xfstests/136	2010-01-03 00:43:56.331617592 -0800
@@ -75,7 +75,7 @@ add_eas()
     i=$start
     while [ $i -le $end ]; do 
 	attr -s name.$i -V value $file >/dev/null
-	let i=$i+1
+	i=$((i + 1))
     done
 }
 
@@ -87,7 +87,7 @@ rm_eas()
     i=$start
     while [ $i -le $end ]; do 
 	attr -r name.$i $file >/dev/null
-	let i=$i+1
+	i=$((i + 1))
     done
 }
 
@@ -185,7 +185,7 @@ _test_add_extents()
 	while [ $j -le 30 ]; do
 	    do_extents $j
 	    _print_inode
-	    let j=$j+2
+	    j=$((j + 2))
 	done
 
 	#scale down
@@ -193,7 +193,7 @@ _test_add_extents()
 	while [ $j -ge 1 ]; do
 	    do_extents $j
 	    _print_inode
-	    let j=$j-2
+	    j=$((j - 2))
 	done
 
 	#build up
@@ -201,7 +201,7 @@ _test_add_extents()
 	while [ $j -le 30 ]; do
 	    do_extents $j
 	    _print_inode
-	    let j=$j+2
+	    j=$((j + 2))
 	done
 }
 
@@ -225,7 +225,7 @@ _test_extents_eas()
 	    _print_inode
 	    _print_inode_u > $tmp.u1
 	    for j in `seq 1 $EAs_inc $EAs_max`; do
-		let k=$k+$EAs_inc-1
+		k=$((k+ EAs_inc - 1))
 		add_eas $j $k
 	    done
 	    # should have same extents
@@ -270,7 +270,7 @@ _test_eas_extents()
 	EAs_inc=5
 	for j in `seq 1 $EAs_inc $EAs_max`; do
 
-	    let k=$k+$EAs_inc-1
+	    k=$((k + EAs_inc - 1))
 	    add_eas $j $k
 	    echo "--- EAs: $j ---"
 
diff -Nrup xfstests.orig/137 xfstests/137
--- xfstests.orig/137	2010-01-03 00:42:17.101617592 -0800
+++ xfstests/137	2010-01-03 00:43:56.331617592 -0800
@@ -61,7 +61,7 @@ do
 		echo error creating/writing file $file
 		exit
 	fi
-	let i=$i+1
+	i=$((i + 1))
 done
 
 # give the system a chance to write something out
@@ -104,7 +104,7 @@ do
 			rm -f $file
 		fi
 	fi
-	let i=$i+1
+	i=$((i + 1))
 done
 
 status=0
diff -Nrup xfstests.orig/138 xfstests/138
--- xfstests.orig/138	2010-01-03 00:42:17.101617592 -0800
+++ xfstests/138	2010-01-03 00:43:56.331617592 -0800
@@ -67,7 +67,7 @@ do
 		echo error truncating file $file
 		exit
 	fi
-	let i=$i+1
+	i=$((i + 1))
 done
 
 # give the system a chance to write something out
@@ -110,7 +110,7 @@ do
 			rm -f $file
 		fi
 	fi
-	let i=$i+1
+	i=$((i + 1))
 done
 
 status=0
diff -Nrup xfstests.orig/139 xfstests/139
--- xfstests.orig/139	2010-01-03 00:42:17.101617592 -0800
+++ xfstests/139	2010-01-03 00:43:56.331617592 -0800
@@ -67,7 +67,7 @@ do
 		echo error truncating file $file
 		exit
 	fi
-	let i=$i+1
+	i=$((i + 1))
 done
 
 # give the system a chance to write something out
@@ -110,7 +110,7 @@ do
 			rm -f $file
 		fi
 	fi
-	let i=$i+1
+	i=$((i + 1))
 done
 
 status=0
diff -Nrup xfstests.orig/140 xfstests/140
--- xfstests.orig/140	2010-01-03 00:42:17.111617592 -0800
+++ xfstests/140	2010-01-03 00:43:56.331617592 -0800
@@ -67,7 +67,7 @@ do
 		echo error truncating file $file
 		exit
 	fi
-	let i=$i+1
+	i=$((i + 1))
 done
 
 # give the system a chance to write something out
@@ -107,7 +107,7 @@ do
 			rm -f $file
 		fi
 	fi
-	let i=$i+1
+	i=$((i + 1))
 done
 
 status=0
diff -Nrup xfstests.orig/149 xfstests/149
--- xfstests.orig/149	2010-01-03 00:42:17.151617592 -0800
+++ xfstests/149	2010-01-03 00:43:56.331617592 -0800
@@ -88,7 +88,7 @@ EOF
 
 	while [ $count -lt $total ]
 	do
-		let count=$count+1
+		count=$((count + 1))
 		cat >>$tmp.proto <<EOF
 ${count}_of_${total}_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx ---755 3 1 /bin/true
 EOF
diff -Nrup xfstests.orig/158 xfstests/158
--- xfstests.orig/158	2010-01-03 00:42:17.191617592 -0800
+++ xfstests/158	2010-01-03 00:43:56.331617592 -0800
@@ -64,25 +64,25 @@ _set_file_attr() {
 atime_before="`_get_file_attr dt_atime`"
 _set_file_attr -a 05m $SCRATCH_MNT/dmapi_test
 atime_after="`_get_file_attr dt_atime`"
-[ "$atime_before" == "$atime_after" ] && echo "dt_atime not updated"
+[ "$atime_before" = "$atime_after" ] && echo "dt_atime not updated"
 
 #dt_mtime
 mtime_before="`_get_file_attr dt_mtime`"
 _set_file_attr -m 10m $SCRATCH_MNT/dmapi_test
 mtime_after="`_get_file_attr dt_mtime`"
-[ "$mtime_before" == "$mtime_after" ] && echo "mt_mtime not updated"
+[ "$mtime_before" = "$mtime_after" ] && echo "mt_mtime not updated"
 
 #dt_ctime
 ctime_before="`_get_file_attr dt_ctime`"
 _set_file_attr -c 15m $SCRATCH_MNT/dmapi_test
 ctime_after="`_get_file_attr dt_ctime`"
-[ "$ctime_before" == "$ctime_after" ] && echo "dt_ctime not updated"
+[ "$ctime_before" = "$ctime_after" ] && echo "dt_ctime not updated"
 
 #dt_dtime
 dtime_before="`_get_file_attr dt_dtime`"
 _set_file_attr -d 20m $SCRATCH_MNT/dmapi_test
 dtime_after="`_get_file_attr dt_dtime`"
-[ "$dtime_before" == "$dtime_after" ] && echo "dt_dtime not updated"
+[ "$dtime_before" = "$dtime_after" ] && echo "dt_dtime not updated"
 
 # -M mode
 _set_file_attr -M 744 $SCRATCH_MNT/dmapi_test
diff -Nrup xfstests.orig/165 xfstests/165
--- xfstests.orig/165	2010-01-03 00:42:17.231617592 -0800
+++ xfstests/165	2010-01-03 00:43:56.331617592 -0800
@@ -96,8 +96,7 @@ do
 
 	$XFS_IO_PROG -c "unresvsp $offset $length" -c "bmap -vp" $testfile | _filter_bmap
 
-	let off=$off+$len # skip over 1
-	let off=$off+$len
+	off=$((off + len + len))	# skip over 1
 done
 
 off=0
@@ -125,8 +124,7 @@ do
 	#$XFS_IO_PROG -r -c "pread -v -b $bufsize $offset $length" $testfile
         #sleep 5
 
-	let off=$off+$len # skip over 1
-	let off=$off+$len
+	off=$((off + len + len))	# skip over 1
 done
 
 wait
diff -Nrup xfstests.orig/178 xfstests/178
--- xfstests.orig/178	2010-01-03 00:42:17.291617592 -0800
+++ xfstests/178	2010-01-03 00:43:56.331617592 -0800
@@ -92,7 +92,7 @@ fi
 _dd_repair_check $SCRATCH_DEV $sectsz
 
 # smaller AGCOUNT
-let "agcount=$agcount-2"
+agcount=$((agcount - 2))
 _scratch_mkfs_xfs -dagcount=$agcount >/dev/null 2>&1 \
         || _fail "mkfs failed!"
 
diff -Nrup xfstests.orig/179 xfstests/179
--- xfstests.orig/179	2010-01-03 00:42:17.291617592 -0800
+++ xfstests/179	2010-01-03 00:43:56.341617592 -0800
@@ -77,7 +77,7 @@ _check_files()
 		else
 			echo file $file missing - fsync failed
 		fi
-		let i=$i+1
+		i=$((i + 1))
 	done
 }
 
@@ -92,7 +92,7 @@ do
 		echo error creating/writing file $file
 		exit
 	fi
-	let i=$i+1
+	i=$((i + 1))
 done
 
 # shutdown immediately after, then remount and test
diff -Nrup xfstests.orig/180 xfstests/180
--- xfstests.orig/180	2010-01-03 00:42:17.301617592 -0800
+++ xfstests/180	2010-01-03 00:43:56.341617592 -0800
@@ -82,7 +82,7 @@ _check_files()
 		else
 			echo file $file missing - sync failed
 		fi
-		let i=$i+1
+		i=$((i + 1))
 	done
 }
 
@@ -97,7 +97,7 @@ do
 		echo error creating/writing file $file
 		exit
 	fi
-	let i=$i+1
+	i=$((i + 1))
 done
 
 # sync, then shutdown immediately after, then remount and test
diff -Nrup xfstests.orig/182 xfstests/182
--- xfstests.orig/182	2010-01-03 00:42:17.311617592 -0800
+++ xfstests/182	2010-01-03 00:43:56.341617592 -0800
@@ -77,7 +77,7 @@ _check_files()
 		else
 			echo file $file missing - sync failed
 		fi
-		let i=$i+1
+		i=$((i + 1))
 	done
 }
 
@@ -92,7 +92,7 @@ do
 		echo error creating/writing file $file
 		exit
 	fi
-	let i=$i+1
+	i=$((i + 1))
 done
 
 # sync, then shutdown immediately after, then remount and test
diff -Nrup xfstests.orig/190 xfstests/190
--- xfstests.orig/190	2010-01-03 00:42:17.341617592 -0800
+++ xfstests/190	2010-01-03 00:43:56.341617592 -0800
@@ -72,21 +72,21 @@ echo Verifying holes are in the correct 
 xfs_bmap=`xfs_bmap $SCRATCH_MNT/$filename`
 xfs_bmap $SCRATCH_MNT/$filename >> $seq.full
 for i in $holes ; do
-	holeStart=$[`echo $i|$SED_PROG 's/:/ /g'|awk '{print $1}'`];
-	holeEnd=$[`echo $i|$SED_PROG 's/:/ /g'|awk '{print $2}'`];
+	holeStart=`echo $i | $SED_PROG 's/:/ /g' | awk '{print $1}'`
+	holeEnd=`echo $i | $SED_PROG 's/:/ /g' | awk '{print $2}'`
 
 	#Round hole size down to a multiple of $fsblocksize
-	holeEnd=$[(($holeStart+$holeEnd)/$fsblocksize)*$fsblocksize]
+	holeEnd=`expr \( \( $holeStart + $holeEnd \) / $fsblocksize \) \* $fsblocksize`
 
 	#Round hole start up to a multiple of $fsblocksize
-	if [ $[$holeStart % $fsblocksize] -gt 0 ] ; then
-		holeStart=$[($holeStart/$fsblocksize +1) * $fsblocksize]
+	if [ `expr $holeStart % $fsblocksize` -gt 0 ] ; then
+		holeStart=`expr \( $holeStart / $fsblocksize +1 \) \* $fsblocksize`
 	fi
 	#xfs_bmap prints holes in the following format
 	#                1: [8..15]: hole
-	bmap="\[$[$holeStart/512]..$[($holeEnd/512) -1]\]";
+	bmap="\[`expr $holeStart / 512`..`expr \( $holeEnd / 512 \) - 1`\]"
 	echo $bmap >> $seq.full
-	if [ $holeEnd == $holeStart ] ; then
+	if [ $holeEnd = $holeStart ] ; then
 		continue #there is no hole
 	fi
 	if ! echo $xfs_bmap|grep -q $bmap; then
@@ -94,7 +94,7 @@ for i in $holes ; do
 		status=1;
 	fi
 done
-if [ $status == 0 ] ; then
+if [ $status = 0 ] ; then
 	echo Test $seq Passed.
 fi
 
diff -Nrup xfstests.orig/200 xfstests/200
--- xfstests.orig/200	2010-01-03 00:42:17.391617592 -0800
+++ xfstests/200	2010-01-03 00:43:56.341617592 -0800
@@ -84,7 +84,11 @@ echo "mounting read-write block device:"
 _scratch_mount 2>&1 | _filter_scratch
 
 echo "touch files"
-touch $SCRATCH_MNT/{0,1,2,3,4,5,6,7,8,9}{0,1,2,3,4,5,6,7,8,9}
+i=1
+while [ $i -le 100 ]; do
+	touch $SCRATCH_MNT/$i
+	i=$((i + 1))
+done
 
 echo "going down:"
 src/godown -f $SCRATCH_MNT
diff -Nrup xfstests.orig/203 xfstests/203
--- xfstests.orig/203	2010-01-03 00:42:17.401617592 -0800
+++ xfstests/203	2010-01-03 00:43:56.341617592 -0800
@@ -35,12 +35,12 @@ _write_holes()
 {
 	file=$1
 	holes=$2
-	let writes=$holes+1
+	writes=$((holes + 1))
 
 	offset=0
 	for i in `seq 0 $writes`; do
 		xfs_io -f $file -c "pwrite -q $offset 1"
-		let offset=$offset+0x100000
+		offset=$((offset + 0x100000))
 	done
 }
 
diff -Nrup xfstests.orig/205 xfstests/205
--- xfstests.orig/205	2010-01-03 00:42:17.411617592 -0800
+++ xfstests/205	2010-01-03 00:43:56.341617592 -0800
@@ -71,7 +71,7 @@ dd if=/dev/zero of=$SCRATCH_MNT/fred bs=
 
 echo "*** one file, a few bytes at a time"
 # now try a single file of that size
-dd if=/dev/zero of=$SCRATCH_MNT/fred bs=15 count=$[26745/15*512] 2>&1 | _filter_dd
+dd if=/dev/zero of=$SCRATCH_MNT/fred bs=15 count=`expr 26745 / 15 \* 512` 2>&1 | _filter_dd
 
 # success, all done
 echo "*** done"
diff -Nrup xfstests.orig/common xfstests/common
--- xfstests.orig/common	2010-01-03 00:42:18.711617592 -0800
+++ xfstests/common	2010-01-03 00:43:56.341617592 -0800
@@ -1,4 +1,3 @@
-##/bin/sh 
 #
 # Copyright (c) 2000-2005 Silicon Graphics, Inc.  All Rights Reserved.
 #
@@ -45,7 +44,7 @@ randomize=false
 rm -f $tmp.list $tmp.tmp $tmp.sed
 
 # Autodetect fs type based on what's on $TEST_DEV
-if [ "$HOSTOS" == "Linux" ]
+if [ "$HOSTOS" = "Linux" ]
 then
     export FSTYP=`blkid -s TYPE -o value $TEST_DEV`
 else
diff -Nrup xfstests.orig/common.attr xfstests/common.attr
--- xfstests.orig/common.attr	2010-01-03 00:42:18.711617592 -0800
+++ xfstests/common.attr	2010-01-03 00:43:56.341617592 -0800
@@ -77,11 +77,11 @@ _acl_list()
 #
 _create_n_aces()
 {
-    let n=$1-4
+    n=$(($1 - 4))
     acl='u::rwx,g::rwx,o::rwx,m::rwx' # 4 ace acl start
     while [ $n -ne 0 ]; do
 	acl="$acl,u:$n:rwx"
-	let n=$n-1
+	n=$((n - 1))
     done
     echo $acl
 }
diff -Nrup xfstests.orig/common.bonnie xfstests/common.bonnie
--- xfstests.orig/common.bonnie	2010-01-03 00:42:18.721617592 -0800
+++ xfstests/common.bonnie	2010-01-03 01:11:24.505239592 -0800
@@ -17,7 +17,7 @@
 #
 
 #check bonnie is installed
-if [ "`whereis bonnie++`" == "bonnie++:"]; then
+if [ "`whereis bonnie++`" = "bonnie++:"]; then
         echo $0 error bonnie not installed.
         exit
 fi
diff -Nrup xfstests.orig/common.config xfstests/common.config
--- xfstests.orig/common.config	2010-01-03 00:42:18.721617592 -0800
+++ xfstests/common.config	2010-01-03 00:43:56.341617592 -0800
@@ -1,4 +1,3 @@
-##/bin/sh
 #
 # Copyright (c) 2000-2003,2006 Silicon Graphics, Inc.  All Rights Reserved.
 #
diff -Nrup xfstests.orig/common.dbench xfstests/common.dbench
--- xfstests.orig/common.dbench	2010-01-03 00:42:18.731617592 -0800
+++ xfstests/common.dbench	2010-01-03 00:46:42.621617592 -0800
@@ -17,7 +17,7 @@
 #
 
 #check dbench is installed
-if [ "`whereis dbench`" == "dbench:"]; then
+if [ "`whereis dbench`" = "dbench:"]; then
         echo $0 error dbench not installed.
         exit
 fi
diff -Nrup xfstests.orig/common.dump xfstests/common.dump
--- xfstests.orig/common.dump	2010-01-03 00:42:18.741617592 -0800
+++ xfstests/common.dump	2010-01-03 00:48:10.391617592 -0800
@@ -111,7 +111,7 @@ _check_onl()
 	else
 	    sleep 1
 	fi
-	let i=$i+1
+	i=$((i + 1))
     done
 
 
@@ -149,7 +149,7 @@ _wait_tape()
 	else
 	    sleep 1
 	fi
-	let i=$i+1
+	i=$((i + 1))
     done
 }
 
@@ -208,7 +208,7 @@ _require_tape()
 {
     dumptape=$1
 
-    if [ -z "$dumptape" -o "@" == "$dumptape" ]; then
+    if [ -z "$dumptape" -o "@" = "$dumptape" ]; then
         echo "This test requires a dump tape - none was specified"
 	echo "No dump tape specified" >$seq.notrun
 	status=$NOTRUNSTS
@@ -701,7 +701,7 @@ _create_hardlinks()
 	_hardlink=$_fname$_suffix
 	echo "creating hardlink $_hardlink to $_fname"
 	ln $_fname $_hardlink
-	let _j=$_j+1
+	_j=$((_j + 1))
     done
 }
 
@@ -717,7 +717,7 @@ _create_hardset()
     _i=1
     while [ $_i -le $_numsets ]; do
 	_create_hardlinks file$_i 5
-	let _i=$_i+1
+	_i=$((_i + 1))
     done
 }
 
@@ -993,7 +993,7 @@ _do_dump_multi_file()
     while [ $i -lt $multi ]
     do
 	multi_args="$multi_args -f $dump_file.$i -M $media_label.$i"
-	let i=$i+1
+	i=$((i + 1))
     done
 
     echo "Dumping to files..."
@@ -1113,7 +1113,7 @@ _do_restore_multi_file()
     while [ $i -lt $multi ]
     do
 	multi_args="$multi_args -f $dump_file.$i"
-	let i=$i+1
+	i=$((i + 1))
     done
 
     echo "Restoring from file..."
@@ -1384,7 +1384,7 @@ _check_quota_entries()
 #
 _check_quota_dumprestore()
 {
-    if [ "$HOSTOS" == "IRIX" ]; then
+    if [ "$HOSTOS" = "IRIX" ]; then
 	_check_quota 'user quota information' \
 		     'group quota information' \
 		     'project quota information' | \
diff -Nrup xfstests.orig/common.filestreams xfstests/common.filestreams
--- xfstests.orig/common.filestreams	2010-01-03 00:42:18.741617592 -0800
+++ xfstests/common.filestreams	2010-01-03 00:48:38.301617592 -0800
@@ -24,7 +24,7 @@ _check_filestreams_support()
 	local irix_timeout_sysvar="xfs_mfstream_timeout"
 	local linux_timeout_procvar="/proc/sys/fs/xfs/filestream_centisecs"
 	local streams_avail=""
-	if [ "$HOSTOS" == "IRIX" ]; then
+	if [ "$HOSTOS" = "IRIX" ]; then
 		# check for the filestreams timeout systune variable in irix
 		streams_avail=`systune $irix_timeout_sysvar 2>&1 |
 			perl -ne 'if (/'$irix_timeout_sysvar'\s+=\s+\d+/) {print "true"}'`
@@ -33,7 +33,7 @@ _check_filestreams_support()
 		[ -f $linux_timeout_procvar ] && streams_avail="true"
 	fi
 
-	if [ "$streams_avail" == "true" ]; then
+	if [ "$streams_avail" = "true" ]; then
 		return 0
 	else
 		return 1
@@ -45,7 +45,7 @@ _set_stream_timeout_centisecs()
 	local new_timeout_csecs=$1
 	local irix_timeout_sysvar="xfs_mfstream_timeout"
 	local linux_timeout_procvar="/proc/sys/fs/xfs/filestream_centisecs"
-	if [ "$HOSTOS" == "IRIX" ]; then
+	if [ "$HOSTOS" = "IRIX" ]; then
 		echo y | systune -r $irix_timeout_sysvar $new_timeout_csecs >/dev/null
 	else
 		echo $new_timeout_csecs > $linux_timeout_procvar
@@ -70,7 +70,7 @@ _do_stream()
 	cd $directory_name
 
 	local dd_cmd=""
-	if [ "$HOSTOS" == "IRIX" ]; then
+	if [ "$HOSTOS" = "IRIX" ]; then
 		# for irix use lmdd
 		dd_cmd="lmdd"
 		[ "$dio" = "1" ] && dd_cmd="$dd_cmd odirect=1"
@@ -114,7 +114,7 @@ _check_for_dupes()
         local this_num_two
         for this_num_one in $num_str_one; do
                 for this_num_two in $num_str_two; do
-                        if [ "$this_num_one" == "$this_num_two" ]; then
+                        if [ "$this_num_one" = "$this_num_two" ]; then
 				echo "duplicate AG $this_num_one found" \
 					>> $here/$seq.full
 				return 1
@@ -140,7 +140,7 @@ _test_streams() {
 	_scratch_mkfs_xfs -dsize=$size,agcount=$agcount >/dev/null 2>&1 \
 		|| _fail "mkfs failed"
 
-	if [ "$use_iflag" = "0" -o "$HOSTOS" == "IRIX" ]; then
+	if [ "$use_iflag" = "0" -o "$HOSTOS" = "IRIX" ]; then
 		# mount using filestreams mount option
 		_scratch_mount "-o filestreams" \
 			|| _fail "filestreams mount failed"
diff -Nrup xfstests.orig/common.log xfstests/common.log
--- xfstests.orig/common.log	2010-01-03 00:42:18.751617592 -0800
+++ xfstests/common.log	2010-01-03 01:19:20.602131591 -0800
@@ -314,7 +314,11 @@ _create_log()
     # generate some log traffic - but not too much - life gets a little
     # more complicated if the log wraps around. This traffic is
     # pretty much arbitary, but could probably be made better than this.
-    touch $SCRATCH_MNT/{0,1,2,3,4,5,6,7,8,9}{0,1,2,3,4,5,6,7,8,9}
+    i=1
+    while [ $i -le 100 ]; do
+    	touch $SCRATCH_MNT/$i
+	i=$((i + 1))
+    done
 	
     # unmount the FS
     _full "umount"
@@ -342,9 +346,11 @@ _create_log_sync()
 
     # generate some log traffic - but not too much
     # add some syncs to get the log flushed to disk 
-    for file in $SCRATCH_MNT/{0,1,2,3,4,5,6,7,8,9}{0,1,2,3,4,5,6,7,8,9}; do
-	touch $file
+    i=1
+    while [ $i -le 100 ]; do
+	touch $SCRATCH_MNT/$i
 	sync
+	i=$((i + 1))
     done
 
     # unmount the FS
diff -Nrup xfstests.orig/common.punch xfstests/common.punch
--- xfstests.orig/common.punch	2010-01-03 00:42:18.761617592 -0800
+++ xfstests/common.punch	2010-01-03 00:49:22.511617592 -0800
@@ -40,7 +40,7 @@ _spawn_test_file() {
 	-c "extsize" \
 	$test_file
 
-	if [ "$reserve_space" == "noresv" ]; then
+	if [ "$reserve_space" = "noresv" ]; then
 		echo "+ not using resvsp at file creation"
 		$XFS_IO_PROG -f \
 		-c "truncate $file_size" \
@@ -62,13 +62,13 @@ _do_punch() {
 	local punch_type=$4		# u for unresvsp, d for dm_punch
 	local test_file=$5
 
-	if [ "$punch_type" == "u" ]; then
+	if [ "$punch_type" = "u" ]; then
 		echo "+ hole punch using unresvsp"
 		$XFS_IO_PROG -f \
 		-c "unresvsp $punch_offset $punch_size" \
 		$test_file
 	fi
-	if [ "$punch_type" == "d" ]; then
+	if [ "$punch_type" = "d" ]; then
 		echo "+ hole punch using dmapi punch_hole"
 		${DMAPI_QASUITE1_DIR}cmd/punch_hole -o $punch_offset -l $punch_size \
 			${SCRATCH_MNT}/$test_file
@@ -123,7 +123,7 @@ _test_punch() {
 	local this_punch_type=""
 	local dmap_punch_used=0
 	for this_punch_type in "${punch_types[@]}"; do
-		[ "$this_punch_type" == "d" ] && dmap_punch_used=1
+		[ "$this_punch_type" = "d" ] && dmap_punch_used=1
 	done
 	if [ $dmap_punch_used -ne 0 ]; then
 		# a punch type of dm_punch has been specified, do a dmapi mount
@@ -161,13 +161,13 @@ _test_punch() {
 	local punch_index=0
 	local write_index=0
 	for operation in "${punch_write_order[@]}"; do
-		if [ "$operation" == "p" ]; then
+		if [ "$operation" = "p" ]; then
 			_do_punch $blksize ${punch_points_blks[$punch_index]} \
 				${punch_sizes_blks[$punch_index]} ${punch_types[$punch_index]} \
 				$filename
 			punch_index=`expr $punch_index + 1`
 		fi
-		if [ "$operation" == "w" ]; then
+		if [ "$operation" = "w" ]; then
 			_do_write $blksize ${write_points_blks[$write_index]} \
 				${write_sizes_blks[$write_index]} $filename
 			write_index=`expr $write_index + 1`
diff -Nrup xfstests.orig/common.quota xfstests/common.quota
--- xfstests.orig/common.quota	2010-01-03 00:42:18.771617592 -0800
+++ xfstests/common.quota	2010-01-03 00:49:41.321617592 -0800
@@ -104,7 +104,7 @@ _choose_gid()
 
 _choose_prid()
 {
-    if [ "X$projid_file" == "X" ]; then
+    if [ "X$projid_file" = "X" ]; then
 	projid_file=/etc/projid
     fi
     if [ ! -f $projid_file ]; then
diff -Nrup xfstests.orig/common.rc xfstests/common.rc
--- xfstests.orig/common.rc	2010-01-03 00:42:18.771617592 -0800
+++ xfstests/common.rc	2010-01-03 00:50:11.001617592 -0800
@@ -1,4 +1,3 @@
-##/bin/sh
 #-----------------------------------------------------------------------
 #  Copyright (c) 2000-2006 Silicon Graphics, Inc.  All Rights Reserved.
 #  This program is free software; you can redistribute it and/or modify
@@ -22,7 +21,7 @@
 
 dd()
 {
-   if [ "$HOSTOS" == "Linux" ]
+   if [ "$HOSTOS" = "Linux" ]
    then	
 	command dd --help | grep noxfer > /dev/null 2>&1
 	
@@ -170,7 +169,7 @@ _mount_ops_filter()
     params="$*"
     
     #get mount point to handle dmapi mtpt option correctly
-    let last_index=$#-1
+    last_index=$(($# - 1))
     [ $last_index -gt 0 ] && shift $last_index
     FS_ESCAPED=$1
     
@@ -701,7 +700,7 @@ _require_user()
 {
     qa_user=fsgqa
     cat /etc/passwd | grep -q $qa_user
-    [ "$?" == "0" ] || _notrun "$qa_user user not defined."
+    [ "$?" = "0" ] || _notrun "$qa_user user not defined."
 }
 
 # check that xfs_io, glibc, kernel, and filesystem all (!) support
@@ -964,7 +963,7 @@ _udf_test_known_error_filter()
 
 _check_udf_filesystem()
 {
-    [ "$DISABLE_UDF_TEST" == "1" ] && return
+    [ "$DISABLE_UDF_TEST" = "1" ] && return
 
     if [ $# -ne 1 -a $# -ne 2 ]
     then
@@ -1193,9 +1192,9 @@ _link_out_file()
       exit
    fi
    rm -f $1
-   if [ "`uname`" == "IRIX64" ] || [ "`uname`" == "IRIX" ]; then
+   if [ "`uname`" = "IRIX64" ] || [ "`uname`" = "IRIX" ]; then
       ln -s $1.irix $1
-   elif [ "`uname`" == "Linux" ]; then
+   elif [ "`uname`" = "Linux" ]; then
       ln -s $1.linux $1
    else
       echo Error test $seq does not run on the operating system: `uname`
@@ -1219,7 +1218,7 @@ _nfiles()
                 if [ $size -gt 0 ]; then
                     dd if=/dev/zero of=$file bs=1024 count=$size
                 fi
-		let f=$f+1
+		f=$((f + 1))
         done
 }
 
@@ -1233,7 +1232,7 @@ _descend()
         _nfiles $files           # files for this dir
 
         [ $depth -eq 0 ] && return
-	let deep=$depth-1 # go 1 down
+	deep=$((depth - 1))	# go 1 down
 
         [ $verbose = true ] && echo "descending, depth from leaves = $deep"
 
@@ -1241,7 +1240,7 @@ _descend()
         while [ $d -lt $dirs ]
         do
                 _descend d$d $deep &
-		let d=$d+1
+		d=$((d + 1))
                 wait
         done
 }
-- 
BOFH excuse #134:

because of network lag due to too many people playing deathmatch

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
