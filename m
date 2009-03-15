Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2FB65eI005281 for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 06:06:26 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A33B919A0A0
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 04:05:41 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail02.adl2.internode.on.net
	[203.16.214.66]) by cuda.sgi.com with ESMTP id yNBXay4htAoGl0jA
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 04:05:41 -0700 (PDT)
Received: from destruction.internal (unverified [203.206.165.193])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	354572691-1927428
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 21:19:52 +1030 (CDT)
Received: from dave by destruction.internal with local (Exim 4.69)
	(envelope-from <dave@destruction>) id 1LinuX-0004nn-JW
	for xfs@oss.sgi.com; Sun, 15 Mar 2009 21:49:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/3] [XFSQA] Reduce the number of processes forked
Date: Sun, 15 Mar 2009 21:49:39 +1100
Message-Id: <1237114181-18431-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1237114181-18431-1-git-send-email-david@fromorbit.com>
References: <1237114181-18431-1-git-send-email-david@fromorbit.com>
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

One of the big cpu time consumers when running xfsqa on UML
is forking of new processes. when looping lots of times,
using 'expr' to calculate the loop counter increment means
we fork at least once every loop. using shell builtins means
that we don't fork and many tests run substantially faster.

Some tests are even runnable with this modification. e.g. 110
went from taking 4500s to run down to 9s with the loop iterators
changed to avoid forking.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 007         |    2 +-
 028         |    2 +-
 031         |    2 +-
 047         |    2 +-
 053         |    4 ++--
 064         |    8 ++++----
 065         |    8 ++++----
 068         |    6 +++---
 071         |    2 +-
 089         |    2 +-
 109         |    8 ++++----
 110         |    6 +++---
 111         |    2 +-
 113         |    2 +-
 114         |    4 ++--
 117         |    2 +-
 119         |    2 +-
 136         |   14 +++++++-------
 137         |    4 ++--
 138         |    4 ++--
 139         |    4 ++--
 140         |    4 ++--
 149         |    2 +-
 165         |    8 ++++----
 179         |    4 ++--
 180         |    4 ++--
 182         |    4 ++--
 common.attr |    6 +++---
 common.dump |   12 ++++++------
 common.rc   |   10 +++++-----
 30 files changed, 72 insertions(+), 72 deletions(-)

diff --git a/007 b/007
index e8c6610..290f716 100755
--- a/007
+++ b/007
@@ -50,7 +50,7 @@ num_filenames=100
 i=1
 while [ $i -le $num_filenames ]; do
   echo "nametest.$i" >>$sourcefile
-  i=`expr $i + 1`
+  let i=$i+1
 done
 
 mkdir $testdir/$seq
diff --git a/028 b/028
index 1b679f2..2c353fa 100755
--- a/028
+++ b/028
@@ -44,7 +44,7 @@ while [ $i -lt 5 ]; do
     fi
     rm $dump_file
     sleep 2
-    i=`expr $i + 1`
+    let i=$i+1
 done
 
 echo "middate = $middate" >>$seq.full
diff --git a/031 b/031
index 779cf27..7ddd842 100755
--- a/031
+++ b/031
@@ -71,7 +71,7 @@ EOF
 
 	while [ $count -lt $total ]
 	do
-		count=`expr $count + 1`
+		let count=$count+1
 		cat >>$tmp.proto <<EOF
 ${count}_of_${total}_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx ---755 3 1 /bin/true
 EOF
diff --git a/047 b/047
index 168ada1..7ee9ed5 100755
--- a/047
+++ b/047
@@ -44,7 +44,7 @@ while [ $i -lt 5 ]; do
     fi
     rm $dump_file
     sleep 2
-    i=`expr $i + 1`
+    let i=$i+1
 done
 
 echo "middate = $middate" >>$seq.full
diff --git a/053 b/053
index f260e1a..dbd2d5d 100755
--- a/053
+++ b/053
@@ -54,7 +54,7 @@ for acl in $acls
 do
   _do "touch $test.$i"
   _do "chacl $acl $test.$i"
-  i=`expr $i + 1`
+  let i=$i+1
 done
 
 list_acls()
@@ -63,7 +63,7 @@ list_acls()
   for acl in $acls
   do
     chacl -l $test.$i | _acl_filter_id | sed -e "s!$SCRATCH_MNT!\$SCRATCH_MNT!"
-    i=`expr $i + 1`
+    let i=$i+1
   done
 }
 
diff --git a/064 b/064
index 27ee1da..5a7d4b4 100755
--- a/064
+++ b/064
@@ -58,7 +58,7 @@ while [ $i -le 9 ]; do
     date >>$seq.full
     find $SCRATCH_MNT -exec $here/src/lstat64 {} \; | sed 's/(00.*)//' >$tmp.dates.$i
     if [ $i -gt 0 ]; then
-       level_1=`expr $i - 1`
+       let level_1=$i-1
        diff -c $tmp.dates.$level_1 $tmp.dates.$i >>$seq.full
     else
        cat $tmp.dates.$i >>$seq.full
@@ -66,7 +66,7 @@ while [ $i -le 9 ]; do
 
     dump_file=$tmp.df.level$i
     _do_dump_file -l $i
-    i=`expr $i + 1`	
+    let i=$i+1
 done
 
 echo "Listing of what files we start with:"
@@ -79,7 +79,7 @@ while [ $i -le 9 ]; do
     echo "restoring from df.level$i"
     dump_file=$tmp.df.level$i
     _do_restore_toc
-    i=`expr $i + 1`	
+    let i=$i+1
 done
 
 echo "Do the cumulative restores"
@@ -91,7 +91,7 @@ while [ $i -le 9 ]; do
     _do_restore_file_cum -l $i
     echo "ls -l restore_dir"
     ls -lR $restore_dir | _ls_size_filter | _check_quota_file
-    i=`expr $i + 1`	
+    let i=$i+1
 done
 
 # success, all done
diff --git a/065 b/065
index b193f28..4252b11 100755
--- a/065
+++ b/065
@@ -146,7 +146,7 @@ while [ $i -le $num_dumps ]; do
 
     dump_file=$tmp.df.level$i
     _do_dump_file -l $i
-    i=`expr $i + 1`
+    let i=$i+1
 done
 
 echo "Look at what files are contained in the inc. dump"
@@ -156,7 +156,7 @@ while [ $i -le $num_dumps ]; do
     echo "restoring from df.level$i"
     dump_file=$tmp.df.level$i
     _do_restore_toc
-    i=`expr $i + 1`
+    let i=$i+1
 done
 
 echo "Do the cumulative restores"
@@ -168,7 +168,7 @@ while [ $i -le $num_dumps ]; do
     _do_restore_file_cum -l $i
     echo "list restore_dir"
     _list_dir $restore_dir | _check_quota_file | tee $tmp.restorals.$i
-    i=`expr $i + 1`
+    let i=$i+1
 done
 
 echo ""
@@ -178,7 +178,7 @@ while [ $i -le $num_dumps ]; do
     echo "Comparing ls of FS with restored FS at level $i"
     diff -s $tmp.ls.$i $tmp.restorals.$i | sed "s#$tmp#TMP#g"
     echo ""
-    i=`expr $i + 1`
+    let i=$i+1
 done
 
 
diff --git a/068 b/068
index eb8b936..af060ae 100755
--- a/068
+++ b/068
@@ -75,7 +75,7 @@ touch $tmp.running
 } &
 
 i=0
-ITERATIONS=`expr $ITERATIONS - 1`
+let ITERATIONS=$ITERATIONS-1
 
 echo | tee -a $seq.full
 while [ $i -le $ITERATIONS ]
@@ -94,7 +94,7 @@ do
 	sleep 2
 
 	echo  | tee -a $seq.full
-	i=`expr $i + 1`
+	let i=$i+1
 done
 
 # stop fsstress iterations
@@ -105,4 +105,4 @@ wait
 
 _check_scratch_fs
 
-exit 1
\ No newline at end of file
+exit 1
diff --git a/071 b/071
index 5e621ba..4e95804 100755
--- a/071
+++ b/071
@@ -137,7 +137,7 @@ do
     echo === Iterating, `expr $upperbound - $count` remains
     echo
     echo
-    count=`expr $count + 1`
+    let count=$count+1
 done
 
 # success, all done
diff --git a/089 b/089
index db7525b..9f77c05 100755
--- a/089
+++ b/089
@@ -30,7 +30,7 @@ addentries()
 
 	while [ $count -gt 0 ]; do
 		touch `printf $pattern $count`
-		count=`expr $count - 1`
+		let count=$count-1
 	done
 }
 
diff --git a/109 b/109
index 913ceea..845f1f2 100755
--- a/109
+++ b/109
@@ -38,7 +38,7 @@ populate()
 	while [ $i -le $files -a "X$faststart" = "X" ]; do
 		file=$SCRATCH_MNT/f$i
 		xfs_io -f -d -c 'pwrite -b 64k 0 64k' $file >/dev/null
-		i=`expr $i + 1`
+		let i=$i+1
 	done
 
 	# remove every second file, freeing up lots of space
@@ -46,7 +46,7 @@ populate()
 	i=1
 	while [ $i -le $files -a "X$faststart" = "X" ]; do
 		rm $SCRATCH_MNT/f$i
-		i=`expr $i + 2`
+		let i=$i+2
 	done
 
 	echo "flushing changes via umount/mount."
@@ -67,10 +67,10 @@ allocate()
 				xfs_io -f -c 'pwrite -b 64k 0 16m' $file \
 					>/dev/null 2>&1
 				rm $file
-				j=`expr $j + 1`
+				let j=$j+1
 			done
 		} &
-		i=`expr $i + 1`
+		let i=$i+1
 	done
 
 	wait
diff --git a/110 b/110
index c578d35..85b313c 100755
--- a/110
+++ b/110
@@ -52,8 +52,8 @@ E=10030600
 while [ $I -le $E ]
 do
     echo > $SCRATCH_MNT/test/${STR1}${STR2}${STR3}${I}
-    I=`expr $I + 1`
-    [ `expr $I % 1000` -eq 0 ] && echo "Created $I/$E"
+    let I=$I+1
+    [ $[$I % 1000] -eq 0 ] && echo "Created $I/$E"
 done
 
 sync
@@ -63,7 +63,7 @@ E=10030599
 while [ $I -le $E ]
 do
     rm $SCRATCH_MNT/test/${STR1}${STR2}${STR3}${I} &
-    I=`expr $I + 1`
+    let I=$I+1
 done
 
 _check_scratch_fs
diff --git a/111 b/111
index 46f1395..060c0bc 100755
--- a/111
+++ b/111
@@ -39,7 +39,7 @@ I=0
 while [ $I -lt 1000 ]
 do
     cp src/itrash.c $SCRATCH_MNT/${I}
-    I=`expr $I + 1`
+    let I=$I+1
 done
 umount $SCRATCH_DEV
 
diff --git a/113 b/113
index 9c435cf..49c8cee 100755
--- a/113
+++ b/113
@@ -41,7 +41,7 @@ _do_test()
     [ $__proc -gt 1 ] && _param="-t $__proc $_param"
     while [ $__proc -gt 1 ]; do
         _files="$_files $testdir/aiostress.$$.$_n.$__proc"
-	__proc=`expr $__proc - 1`
+	let __proc=$__proc-1
     done
     rm -f $_files
  
diff --git a/114 b/114
index 5f7c23d..af8608c 100755
--- a/114
+++ b/114
@@ -135,8 +135,8 @@ _test_hardlink()
 	paths="$d/l1 $d/l2 $d/l3 $d2/l4 $d2/l5 $d2/l6"
 	i=0
 	for x in $paths; do
-		i=`expr $i + 1`
-		j=`expr $i % 2`
+		let i=$i+1
+		let j=$i%2
 		if [ $j -eq 0 ]; then
 			echo "rm'ing $x"
 			rm $x
diff --git a/117 b/117
index 5fee416..7cb91d1 100755
--- a/117
+++ b/117
@@ -71,7 +71,7 @@ while [ $i -lt $ITERATIONS ]; do
         -s $seed \
 	-S -p 1 -n 1000 >>$seq.full 2>&1
 
-    i=`expr $i + 1`
+    let i=$i+1
 done
 
 cd /
diff --git a/119 b/119
index 8d23495..055928c 100755
--- a/119
+++ b/119
@@ -54,7 +54,7 @@ while [ $i -lt $max ]; do
 	xfs_freeze -f $SCRATCH_MNT
 	xfs_freeze -u $SCRATCH_MNT
 	echo -n .
-	i=`expr $i + 1`
+	let i=$i+1
 done
 echo "done"
 
diff --git a/136 b/136
index 0978ac9..c3e010c 100755
--- a/136
+++ b/136
@@ -61,7 +61,7 @@ add_eas()
     i=$start
     while [ $i -le $end ]; do 
 	attr -s name.$i -V value $file >/dev/null
-	i=`expr $i + 1`
+	let i=$i+1
     done
 }
 
@@ -73,7 +73,7 @@ rm_eas()
     i=$start
     while [ $i -le $end ]; do 
 	attr -r name.$i $file >/dev/null
-	i=`expr $i + 1`
+	let i=$i+1
     done
 }
 
@@ -171,7 +171,7 @@ _test_add_extents()
 	while [ $j -le 30 ]; do
 	    do_extents $j
 	    _print_inode
-	    j=`expr $j + 2`
+	    let j=$j+2
 	done
 
 	#scale down
@@ -179,7 +179,7 @@ _test_add_extents()
 	while [ $j -ge 1 ]; do
 	    do_extents $j
 	    _print_inode
-	    j=`expr $j - 2`
+	    let j=$j-2
 	done
 
 	#build up
@@ -187,7 +187,7 @@ _test_add_extents()
 	while [ $j -le 30 ]; do
 	    do_extents $j
 	    _print_inode
-	    j=`expr $j + 2`
+	    let j=$j+2
 	done
 }
 
@@ -211,7 +211,7 @@ _test_extents_eas()
 	    _print_inode
 	    _print_inode_u > $tmp.u1
 	    for j in `seq 1 $EAs_inc $EAs_max`; do
-		k=`expr $j + $EAs_inc - 1`
+		let k=$k+$EAs_inc-1
 		add_eas $j $k
 	    done
 	    # should have same extents
@@ -256,7 +256,7 @@ _test_eas_extents()
 	EAs_inc=5
 	for j in `seq 1 $EAs_inc $EAs_max`; do
 
-	    k=`expr $j + $EAs_inc - 1`
+	    let k=$k+$EAs_inc-1
 	    add_eas $j $k
 	    echo "--- EAs: $j ---"
 
diff --git a/137 b/137
index 4dbf847..f27a248 100755
--- a/137
+++ b/137
@@ -47,7 +47,7 @@ do
 		echo error creating/writing file $file
 		exit
 	fi
-	i=`expr $i + 1`
+	let i=$i+1
 done
 
 # give the system a chance to write something out
@@ -90,7 +90,7 @@ do
 			rm -f $file
 		fi
 	fi
-	i=`expr $i + 1`
+	let i=$i+1
 done
 
 status=0
diff --git a/138 b/138
index 7cf9020..bf36e3d 100755
--- a/138
+++ b/138
@@ -53,7 +53,7 @@ do
 		echo error truncating file $file
 		exit
 	fi
-	i=`expr $i + 1`
+	let i=$i+1
 done
 
 # give the system a chance to write something out
@@ -96,7 +96,7 @@ do
 			rm -f $file
 		fi
 	fi
-	i=`expr $i + 1`
+	let i=$i+1
 done
 
 status=0
diff --git a/139 b/139
index 4805279..5fd2a64 100755
--- a/139
+++ b/139
@@ -53,7 +53,7 @@ do
 		echo error truncating file $file
 		exit
 	fi
-	i=`expr $i + 1`
+	let i=$i+1
 done
 
 # give the system a chance to write something out
@@ -96,7 +96,7 @@ do
 			rm -f $file
 		fi
 	fi
-	i=`expr $i + 1`
+	let i=$i+1
 done
 
 status=0
diff --git a/140 b/140
index 797efc4..e5d63a6 100755
--- a/140
+++ b/140
@@ -53,7 +53,7 @@ do
 		echo error truncating file $file
 		exit
 	fi
-	i=`expr $i + 1`
+	let i=$i+1
 done
 
 # give the system a chance to write something out
@@ -93,7 +93,7 @@ do
 			rm -f $file
 		fi
 	fi
-	i=`expr $i + 1`
+	let i=$i+1
 done
 
 status=0
diff --git a/149 b/149
index 0e9d974..8fea8af 100755
--- a/149
+++ b/149
@@ -74,7 +74,7 @@ EOF
 
 	while [ $count -lt $total ]
 	do
-		count=`expr $count + 1`
+		let count=$count+1
 		cat >>$tmp.proto <<EOF
 ${count}_of_${total}_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx ---755 3 1 /bin/true
 EOF
diff --git a/165 b/165
index 9eda608..7356a4c 100644
--- a/165
+++ b/165
@@ -82,8 +82,8 @@ do
 
 	$XFS_IO_PROG -c "unresvsp $offset $length" -c "bmap -vp" $testfile | _filter_bmap
 
-	off=`expr $off + $len` # skip over 1
-	off=`expr $off + $len`
+	let off=$off+$len # skip over 1
+	let off=$off+$len
 done
 
 off=0
@@ -111,8 +111,8 @@ do
 	#$XFS_IO_PROG -r -c "pread -v -b $bufsize $offset $length" $testfile
         #sleep 5
 
-	off=`expr $off + $len` # skip over 1
-	off=`expr $off + $len`
+	let off=$off+$len # skip over 1
+	let off=$off+$len
 done
 
 wait
diff --git a/179 b/179
index 6efb70f..c7cd9a7 100644
--- a/179
+++ b/179
@@ -63,7 +63,7 @@ _check_files()
 		else
 			echo file $file missing - fsync failed
 		fi
-		i=`expr $i + 1`
+		let i=$i+1
 	done
 }
 
@@ -78,7 +78,7 @@ do
 		echo error creating/writing file $file
 		exit
 	fi
-	i=`expr $i + 1`
+	let i=$i+1
 done
 
 # shutdown immediately after, then remount and test
diff --git a/180 b/180
index 3ad7972..52a4f7c 100644
--- a/180
+++ b/180
@@ -68,7 +68,7 @@ _check_files()
 		else
 			echo file $file missing - sync failed
 		fi
-		i=`expr $i + 1`
+		let i=$i+1
 	done
 }
 
@@ -83,7 +83,7 @@ do
 		echo error creating/writing file $file
 		exit
 	fi
-	i=`expr $i + 1`
+	let i=$i+1
 done
 
 # sync, then shutdown immediately after, then remount and test
diff --git a/182 b/182
index fdede6d..f112f30 100644
--- a/182
+++ b/182
@@ -63,7 +63,7 @@ _check_files()
 		else
 			echo file $file missing - sync failed
 		fi
-		i=`expr $i + 1`
+		let i=$i+1
 	done
 }
 
@@ -78,7 +78,7 @@ do
 		echo error creating/writing file $file
 		exit
 	fi
-	i=`expr $i + 1`
+	let i=$i+1
 done
 
 # sync, then shutdown immediately after, then remount and test
diff --git a/common.attr b/common.attr
index 31f71f2..5f16273 100644
--- a/common.attr
+++ b/common.attr
@@ -77,11 +77,11 @@ _acl_list()
 #
 _create_n_aces()
 {
-    n=`expr $1 - 4`
+    let n=$1-4
     acl='u::rwx,g::rwx,o::rwx,m::rwx' # 4 ace acl start
     while [ $n -ne 0 ]; do
-       acl="$acl,u:$n:rwx"
-       n=`expr $n - 1` 
+	acl="$acl,u:$n:rwx"
+	let n=$n-1
     done
     echo $acl
 }
diff --git a/common.dump b/common.dump
index c80a9c1..6d2f120 100644
--- a/common.dump
+++ b/common.dump
@@ -97,7 +97,7 @@ _check_onl()
 	else
 	    sleep 1
 	fi
-	i=`expr $i + 1`
+	let i=$i+1
     done
 
 
@@ -135,7 +135,7 @@ _wait_tape()
 	else
 	    sleep 1
 	fi
-	i=`expr $i + 1`
+	let i=$i+1
     done
 }
 
@@ -681,7 +681,7 @@ _create_hardlinks()
 	_hardlink=$_fname$_suffix
 	echo "creating hardlink $_hardlink to $_fname"
 	ln $_fname $_hardlink
-	_j=`expr $_j + 1`
+	let _j=$_j+1
     done
 }
 
@@ -697,7 +697,7 @@ _create_hardset()
     _i=1
     while [ $_i -le $_numsets ]; do
 	_create_hardlinks file$_i 5
-	_i=`expr $_i + 1`
+	let _i=$_i+1
     done
 }
 
@@ -973,7 +973,7 @@ _do_dump_multi_file()
     while [ $i -lt $multi ]
     do
 	multi_args="$multi_args -f $dump_file.$i -M $media_label.$i"
-	i=`expr $i + 1`
+	let i=$i+1
     done
 
     echo "Dumping to files..."
@@ -1093,7 +1093,7 @@ _do_restore_multi_file()
     while [ $i -lt $multi ]
     do
 	multi_args="$multi_args -f $dump_file.$i"
-	i=`expr $i + 1`
+	let i=$i+1
     done
 
     echo "Restoring from file..."
diff --git a/common.rc b/common.rc
index a51ac70..36f978b 100644
--- a/common.rc
+++ b/common.rc
@@ -152,7 +152,7 @@ _mount_ops_filter()
     params="$*"
     
     #get mount point to handle dmapi mtpt option correctly
-    last_index=`expr $# - 1`
+    let last_index=$#-1
     [ $last_index -gt 0 ] && shift $last_index
     FS_ESCAPED=$1
     
@@ -1114,11 +1114,11 @@ _nfiles()
         while [ $f -lt $1 ]
         do
                 file=f$f
-                touch $file
+                echo > $file
                 if [ $size -gt 0 ]; then
                     dd if=/dev/zero of=$file bs=1024 count=$size
                 fi
-                f=`expr $f + 1`
+		let f=$f+1
         done
 }
 
@@ -1132,7 +1132,7 @@ _descend()
         _nfiles $files           # files for this dir
 
         [ $depth -eq 0 ] && return
-        deep=`expr $depth - 1`  # go 1 down
+	let deep=$depth-1 # go 1 down
 
         [ $verbose = true ] && echo "descending, depth from leaves = $deep"
 
@@ -1140,7 +1140,7 @@ _descend()
         while [ $d -lt $dirs ]
         do
                 _descend d$d $deep &
-                d=`expr $d + 1`
+		let d=$d+1
                 wait
         done
 }
-- 
1.6.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
