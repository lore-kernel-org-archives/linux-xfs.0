Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o047txhX082334 for <xfs@oss.sgi.com>; Mon, 4 Jan 2010 01:55:59 -0600
Received: from moutng.kundenserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 565B11C27FB3
	for <xfs@oss.sgi.com>; Sun,  3 Jan 2010 23:56:48 -0800 (PST)
Received: from moutng.kundenserver.de (moutng.kundenserver.de
	[212.227.126.171]) by cuda.sgi.com with ESMTP id
	Q2AcpCjZFvNWVt6S for <xfs@oss.sgi.com>;
	Sun, 03 Jan 2010 23:56:48 -0800 (PST)
Date: Sun, 3 Jan 2010 23:56:45 -0800 (PST)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: [PATCH] remove bashisms from xfstests
In-Reply-To: <alpine.DEB.2.01.1001032307210.3483@bogon.housecafe.de>
Message-ID: <alpine.DEB.2.01.1001032348240.3483@bogon.housecafe.de>
References: <alpine.DEB.2.01.1001030125040.3483@bogon.housecafe.de>
	<87vdfjceke.fsf@basil.nowhere.org>
	<alpine.DEB.2.01.1001032307210.3483@bogon.housecafe.de>
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
To: Andi Kleen <andi@firstfloor.org>
Cc: xfs@oss.sgi.com

On Sun, 3 Jan 2010 at 23:27, Christian Kujau wrote:
> OK, here's one with only changing /bin/sh to /bin/bash, for all scripts 
> carrying bashisms according to checkbashisms(1). With this patch applied, 
> I can now run xfstests w/o changing my /bin/sh to something else.

Well, almost - I'm still getting errors, because some of the scripts are 
not executed but sourced. Although the ./check script is /bin/bash now, 
the sourced scripts seem to get executed via /bin/sh, at least that's what 
I've experienced. Here's an additional patch, changing only the common.* 
scripts, for they are being sourced. Right now xfstests is running test 
013 and no errors so far.

Christian.

Signed-off-by: Christian Kujau <lists@nerdbynature.de>

diff -Nrup xfstests.orig/common xfstests/common
--- xfstests.orig/common	2010-01-03 23:03:32.029290001 -0800
+++ xfstests/common	2010-01-03 23:36:04.722433002 -0800
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
--- xfstests.orig/common.attr	2010-01-03 23:03:32.039295001 -0800
+++ xfstests/common.attr	2010-01-03 23:36:27.602433002 -0800
@@ -1,4 +1,3 @@
-##/bin/sh
 #-----------------------------------------------------------------------
 #  Copyright (c) 2000-2004 Silicon Graphics, Inc.  All Rights Reserved.
 #  This program is free software; you can redistribute it and/or modify
@@ -77,11 +76,11 @@ _acl_list()
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
--- xfstests.orig/common.bonnie	2010-01-03 23:03:32.049300001 -0800
+++ xfstests/common.bonnie	2010-01-03 23:36:48.682433002 -0800
@@ -1,4 +1,3 @@
-##/bin/sh
 #
 # Copyright (c) 2002-2004 Silicon Graphics, Inc.  All Rights Reserved.
 #
@@ -17,7 +16,7 @@
 #
 
 #check bonnie is installed
-if [ "`whereis bonnie++`" == "bonnie++:"]; then
+if [ "`whereis bonnie++`" = "bonnie++:"]; then
         echo $0 error bonnie not installed.
         exit
 fi
diff -Nrup xfstests.orig/common.config xfstests/common.config
--- xfstests.orig/common.config	2010-01-03 23:03:32.059305001 -0800
+++ xfstests/common.config	2010-01-03 23:33:46.432433002 -0800
@@ -1,4 +1,3 @@
-##/bin/sh
 #
 # Copyright (c) 2000-2003,2006 Silicon Graphics, Inc.  All Rights Reserved.
 #
diff -Nrup xfstests.orig/common.dbench xfstests/common.dbench
--- xfstests.orig/common.dbench	2010-01-03 23:03:32.059305001 -0800
+++ xfstests/common.dbench	2010-01-03 23:37:14.602433002 -0800
@@ -1,4 +1,3 @@
-##/bin/sh
 #
 # Copyright (c) 2002-2005 Silicon Graphics, Inc.  All Rights Reserved.
 #
@@ -17,7 +16,7 @@
 #
 
 #check dbench is installed
-if [ "`whereis dbench`" == "dbench:"]; then
+if [ "`whereis dbench`" = "dbench:"]; then
         echo $0 error dbench not installed.
         exit
 fi
diff -Nrup xfstests.orig/common.defrag xfstests/common.defrag
--- xfstests.orig/common.defrag	2010-01-03 23:03:32.079315001 -0800
+++ xfstests/common.defrag	2010-01-03 23:33:49.662433002 -0800
@@ -1,4 +1,3 @@
-##/bin/sh
 #
 # Copyright (c) 2009 Eric Sandeen
 # All Rights Reserved.
diff -Nrup xfstests.orig/common.dmapi xfstests/common.dmapi
--- xfstests.orig/common.dmapi	2010-01-03 23:03:32.079315001 -0800
+++ xfstests/common.dmapi	2010-01-03 23:33:51.212433002 -0800
@@ -1,4 +1,3 @@
-##/bin/sh
 #
 # Copyright (c) 2006 Silicon Graphics, Inc.  All Rights Reserved.
 #
diff -Nrup xfstests.orig/common.dump xfstests/common.dump
--- xfstests.orig/common.dump	2010-01-03 23:03:32.099325001 -0800
+++ xfstests/common.dump	2010-01-03 23:38:42.102433002 -0800
@@ -1,4 +1,3 @@
-#/bin/sh
 #
 # Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.  All Rights Reserved.
 #
@@ -111,7 +110,7 @@ _check_onl()
 	else
 	    sleep 1
 	fi
-	let i=$i+1
+	i=$((i + 1))
     done
 
 
@@ -149,7 +148,7 @@ _wait_tape()
 	else
 	    sleep 1
 	fi
-	let i=$i+1
+	i=$((i + 1))
     done
 }
 
@@ -208,7 +207,7 @@ _require_tape()
 {
     dumptape=$1
 
-    if [ -z "$dumptape" -o "@" == "$dumptape" ]; then
+    if [ -z "$dumptape" -o "@" = "$dumptape" ]; then
         echo "This test requires a dump tape - none was specified"
 	echo "No dump tape specified" >$seq.notrun
 	status=$NOTRUNSTS
@@ -701,7 +700,7 @@ _create_hardlinks()
 	_hardlink=$_fname$_suffix
 	echo "creating hardlink $_hardlink to $_fname"
 	ln $_fname $_hardlink
-	let _j=$_j+1
+	_j=$((_j + 1))
     done
 }
 
@@ -717,7 +716,7 @@ _create_hardset()
     _i=1
     while [ $_i -le $_numsets ]; do
 	_create_hardlinks file$_i 5
-	let _i=$_i+1
+	_i=$((_i + 1))
     done
 }
 
@@ -993,7 +992,7 @@ _do_dump_multi_file()
     while [ $i -lt $multi ]
     do
 	multi_args="$multi_args -f $dump_file.$i -M $media_label.$i"
-	let i=$i+1
+	i=$((i + 1))
     done
 
     echo "Dumping to files..."
@@ -1113,7 +1112,7 @@ _do_restore_multi_file()
     while [ $i -lt $multi ]
     do
 	multi_args="$multi_args -f $dump_file.$i"
-	let i=$i+1
+	i=$((i + 1))
     done
 
     echo "Restoring from file..."
@@ -1384,7 +1383,7 @@ _check_quota_entries()
 #
 _check_quota_dumprestore()
 {
-    if [ "$HOSTOS" == "IRIX" ]; then
+    if [ "$HOSTOS" = "IRIX" ]; then
 	_check_quota 'user quota information' \
 		     'group quota information' \
 		     'project quota information' | \
diff -Nrup xfstests.orig/common.filestreams xfstests/common.filestreams
--- xfstests.orig/common.filestreams	2010-01-03 23:03:32.109330001 -0800
+++ xfstests/common.filestreams	2010-01-03 23:39:04.502433002 -0800
@@ -1,4 +1,3 @@
-##/bin/sh
 #
 # Copyright (c) 2007 Silicon Graphics, Inc.  All Rights Reserved.
 #
@@ -24,7 +23,7 @@ _check_filestreams_support()
 	local irix_timeout_sysvar="xfs_mfstream_timeout"
 	local linux_timeout_procvar="/proc/sys/fs/xfs/filestream_centisecs"
 	local streams_avail=""
-	if [ "$HOSTOS" == "IRIX" ]; then
+	if [ "$HOSTOS" = "IRIX" ]; then
 		# check for the filestreams timeout systune variable in irix
 		streams_avail=`systune $irix_timeout_sysvar 2>&1 |
 			perl -ne 'if (/'$irix_timeout_sysvar'\s+=\s+\d+/) {print "true"}'`
@@ -33,7 +32,7 @@ _check_filestreams_support()
 		[ -f $linux_timeout_procvar ] && streams_avail="true"
 	fi
 
-	if [ "$streams_avail" == "true" ]; then
+	if [ "$streams_avail" = "true" ]; then
 		return 0
 	else
 		return 1
@@ -45,7 +44,7 @@ _set_stream_timeout_centisecs()
 	local new_timeout_csecs=$1
 	local irix_timeout_sysvar="xfs_mfstream_timeout"
 	local linux_timeout_procvar="/proc/sys/fs/xfs/filestream_centisecs"
-	if [ "$HOSTOS" == "IRIX" ]; then
+	if [ "$HOSTOS" = "IRIX" ]; then
 		echo y | systune -r $irix_timeout_sysvar $new_timeout_csecs >/dev/null
 	else
 		echo $new_timeout_csecs > $linux_timeout_procvar
@@ -70,7 +69,7 @@ _do_stream()
 	cd $directory_name
 
 	local dd_cmd=""
-	if [ "$HOSTOS" == "IRIX" ]; then
+	if [ "$HOSTOS" = "IRIX" ]; then
 		# for irix use lmdd
 		dd_cmd="lmdd"
 		[ "$dio" = "1" ] && dd_cmd="$dd_cmd odirect=1"
@@ -114,7 +113,7 @@ _check_for_dupes()
         local this_num_two
         for this_num_one in $num_str_one; do
                 for this_num_two in $num_str_two; do
-                        if [ "$this_num_one" == "$this_num_two" ]; then
+                        if [ "$this_num_one" = "$this_num_two" ]; then
 				echo "duplicate AG $this_num_one found" \
 					>> $here/$seq.full
 				return 1
@@ -140,7 +139,7 @@ _test_streams() {
 	_scratch_mkfs_xfs -dsize=$size,agcount=$agcount >/dev/null 2>&1 \
 		|| _fail "mkfs failed"
 
-	if [ "$use_iflag" = "0" -o "$HOSTOS" == "IRIX" ]; then
+	if [ "$use_iflag" = "0" -o "$HOSTOS" = "IRIX" ]; then
 		# mount using filestreams mount option
 		_scratch_mount "-o filestreams" \
 			|| _fail "filestreams mount failed"
diff -Nrup xfstests.orig/common.filter xfstests/common.filter
--- xfstests.orig/common.filter	2010-01-03 23:03:32.119335001 -0800
+++ xfstests/common.filter	2010-01-03 23:33:56.372433002 -0800
@@ -1,4 +1,3 @@
-##/bin/sh
 #
 # Copyright (c) 2000-2001 Silicon Graphics, Inc.  All Rights Reserved.
 #
diff -Nrup xfstests.orig/common.log xfstests/common.log
--- xfstests.orig/common.log	2010-01-03 23:03:32.119335001 -0800
+++ xfstests/common.log	2010-01-03 23:44:11.282433002 -0800
@@ -1,4 +1,3 @@
-##/bin/sh
 #
 # Copyright (c) 2000-2002 Silicon Graphics, Inc.  All Rights Reserved.
 #
@@ -314,8 +313,12 @@ _create_log()
     # generate some log traffic - but not too much - life gets a little
     # more complicated if the log wraps around. This traffic is
     # pretty much arbitary, but could probably be made better than this.
-    touch $SCRATCH_MNT/{0,1,2,3,4,5,6,7,8,9}{0,1,2,3,4,5,6,7,8,9}
-	
+    i=1
+    while [ $i -le 100 ]; do
+    	touch $SCRATCH_MNT/$i
+	i=$((i + 1))
+    done
+
     # unmount the FS
     _full "umount"
     umount $SCRATCH_DEV >>$seq.full 2>&1
@@ -342,9 +345,11 @@ _create_log_sync()
 
     # generate some log traffic - but not too much
     # add some syncs to get the log flushed to disk 
-    for file in $SCRATCH_MNT/{0,1,2,3,4,5,6,7,8,9}{0,1,2,3,4,5,6,7,8,9}; do
-	touch $file
+    i=1
+    while [ $i -le 100 ]; do
+    	touch $SCRATCH_MNT/$i
 	sync
+	i=$((i + 1))
     done
 
     # unmount the FS
diff -Nrup xfstests.orig/common.metaperf xfstests/common.metaperf
--- xfstests.orig/common.metaperf	2010-01-03 23:03:32.129340001 -0800
+++ xfstests/common.metaperf	2010-01-03 23:33:59.432433002 -0800
@@ -1,4 +1,3 @@
-##/bin/sh
 #
 # Copyright (c) 2003-2005 Silicon Graphics, Inc.  All Rights Reserved.
 #
diff -Nrup xfstests.orig/common.punch xfstests/common.punch
--- xfstests.orig/common.punch	2010-01-03 23:03:32.139345001 -0800
+++ xfstests/common.punch	2010-01-03 23:39:55.132433002 -0800
@@ -1,4 +1,3 @@
-##/bin/sh
 #
 # Copyright (c) 2007 Silicon Graphics, Inc.  All Rights Reserved.
 #
@@ -40,7 +39,7 @@ _spawn_test_file() {
 	-c "extsize" \
 	$test_file
 
-	if [ "$reserve_space" == "noresv" ]; then
+	if [ "$reserve_space" = "noresv" ]; then
 		echo "+ not using resvsp at file creation"
 		$XFS_IO_PROG -f \
 		-c "truncate $file_size" \
@@ -62,13 +61,13 @@ _do_punch() {
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
@@ -123,7 +122,7 @@ _test_punch() {
 	local this_punch_type=""
 	local dmap_punch_used=0
 	for this_punch_type in "${punch_types[@]}"; do
-		[ "$this_punch_type" == "d" ] && dmap_punch_used=1
+		[ "$this_punch_type" = "d" ] && dmap_punch_used=1
 	done
 	if [ $dmap_punch_used -ne 0 ]; then
 		# a punch type of dm_punch has been specified, do a dmapi mount
@@ -161,13 +160,13 @@ _test_punch() {
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
--- xfstests.orig/common.quota	2010-01-03 23:03:32.149350001 -0800
+++ xfstests/common.quota	2010-01-03 23:40:10.632433002 -0800
@@ -1,4 +1,3 @@
-##/bin/sh
 #
 # Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
 # All Rights Reserved.
@@ -117,7 +116,7 @@ _choose_gid()
 
 _choose_prid()
 {
-    if [ "X$projid_file" == "X" ]; then
+    if [ "X$projid_file" = "X" ]; then
 	projid_file=/etc/projid
     fi
     if [ ! -f $projid_file ]; then
diff -Nrup xfstests.orig/common.rc xfstests/common.rc
--- xfstests.orig/common.rc	2010-01-03 23:03:32.159355001 -0800
+++ xfstests/common.rc	2010-01-03 23:41:30.712433002 -0800
@@ -1,5 +1,4 @@
-##/bin/sh
-#-----------------------------------------------------------------------
+#
 #  Copyright (c) 2000-2006 Silicon Graphics, Inc.  All Rights Reserved.
 #  This program is free software; you can redistribute it and/or modify
 #  it under the terms of the GNU General Public License as published by
@@ -18,11 +17,11 @@
 #
 #  Contact information: Silicon Graphics, Inc., 1500 Crittenden Lane,
 #  Mountain View, CA 94043, USA, or: http://www.sgi.com
-#-----------------------------------------------------------------------
+#
 
 dd()
 {
-   if [ "$HOSTOS" == "Linux" ]
+   if [ "$HOSTOS" = "Linux" ]
    then	
 	command dd --help | grep noxfer > /dev/null 2>&1
 	
@@ -186,7 +185,7 @@ _mount_ops_filter()
     params="$*"
     
     #get mount point to handle dmapi mtpt option correctly
-    let last_index=$#-1
+    last_index=$(($# - 1))
     [ $last_index -gt 0 ] && shift $last_index
     FS_ESCAPED=$1
     
@@ -409,7 +408,7 @@ _df_device()
     fi
 
     $DF_PROG 2>/dev/null | $AWK_PROG -v what=$1 '
-        match($1,what) && NF==1 {
+        match($1,what) && NF == 1 {
             v=$1
             getline
             print v, $0
@@ -439,7 +438,7 @@ _df_dir()
     fi
 
     $DF_PROG $1 2>/dev/null | $AWK_PROG -v what=$1 '
-        NR == 2 && NF==1 {
+        NR == 2 && NF == 1 {
             v=$1
             getline
             print v, $0;
@@ -720,7 +719,7 @@ _require_user()
 {
     qa_user=fsgqa
     cat /etc/passwd | grep -q $qa_user
-    [ "$?" == "0" ] || _notrun "$qa_user user not defined."
+    [ "$?" = "0" ] || _notrun "$qa_user user not defined."
 }
 
 # check that xfs_io, glibc, kernel, and filesystem all (!) support
@@ -983,7 +982,7 @@ _udf_test_known_error_filter()
 
 _check_udf_filesystem()
 {
-    [ "$DISABLE_UDF_TEST" == "1" ] && return
+    [ "$DISABLE_UDF_TEST" = "1" ] && return
 
     if [ $# -ne 1 -a $# -ne 2 ]
     then
@@ -1212,9 +1211,9 @@ _link_out_file()
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
@@ -1238,7 +1237,7 @@ _nfiles()
                 if [ $size -gt 0 ]; then
                     dd if=/dev/zero of=$file bs=1024 count=$size
                 fi
-		let f=$f+1
+		f=$((f + 1))
         done
 }
 
@@ -1252,7 +1251,7 @@ _descend()
         _nfiles $files           # files for this dir
 
         [ $depth -eq 0 ] && return
-	let deep=$depth-1 # go 1 down
+	deep=$((depth - 1))	# go 1 down
 
         [ $verbose = true ] && echo "descending, depth from leaves = $deep"
 
@@ -1260,7 +1259,7 @@ _descend()
         while [ $d -lt $dirs ]
         do
                 _descend d$d $deep &
-		let d=$d+1
+		d=$((d + 1))
                 wait
         done
 }
diff -Nrup xfstests.orig/common.repair xfstests/common.repair
--- xfstests.orig/common.repair	2010-01-03 23:03:32.169360001 -0800
+++ xfstests/common.repair	2010-01-03 23:34:06.322433002 -0800
@@ -1,4 +1,3 @@
-##/bin/sh
 #
 # Copyright (c) 2000-2002 Silicon Graphics, Inc.  All Rights Reserved.
 #
-- 
BOFH excuse #306:

CPU-angle has to be adjusted because of vibrations coming from the nearby road

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
