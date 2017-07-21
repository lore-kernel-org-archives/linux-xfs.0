Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:35624 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751806AbdGUEkW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jul 2017 00:40:22 -0400
From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH v2 13/15] common: remove IRIX-specific code
Date: Thu, 20 Jul 2017 21:38:51 -0700
Message-Id: <20170721043853.364-14-ebiggers3@gmail.com>
In-Reply-To: <20170721043853.364-1-ebiggers3@gmail.com>
References: <20170721043853.364-1-ebiggers3@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Eric Biggers <ebiggers@google.com>

From: Eric Biggers <ebiggers@google.com>

As xfstests is no longer supported on IRIX, remove IRIX-specific code
from the common helper scripts.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 common/config      | 12 ------------
 common/dump        | 39 +++------------------------------------
 common/filestreams | 43 ++++++-------------------------------------
 common/log         |  1 -
 common/rc          | 23 +++--------------------
 5 files changed, 12 insertions(+), 106 deletions(-)

diff --git a/common/config b/common/config
index 5091db9d..80598d06 100644
--- a/common/config
+++ b/common/config
@@ -52,15 +52,10 @@
 export LANG=C
 export LC_ALL=C
 
-# Warning: don't put freeware before /usr/bsd on IRIX coz you'll
-#  get the wrong hostname and set your system name to -s  :)
-[ -d /usr/bsd ] && PATH=$PATH:/usr/bsd
-[ -d /usr/freeware/bin ] && PATH=$PATH:/usr/freeware/bin
 PATH=".:$PATH"
 
 export HOST=`hostname -s`
 export HOSTOS=`uname -s`
-[ "$HOSTOS" = "IRIX64" ] && export HOSTOS="IRIX"
 
 export MODULAR=0               # using XFS as a module or not
 export BOOT="/boot"            # install target for kernels
@@ -220,13 +215,6 @@ fi
 export UDEV_SETTLE_PROG
 
 case "$HOSTOS" in
-    IRIX*)
-        export MKFS_XFS_PROG="`set_prog_path mkfs_xfs`"
-        export MKFS_UDF_PROG="`set_prog_path mkfs_udf`"
-        export XFS_FSR_PROG="`set_prog_path /usr/etc/fsr_xfs`"
-        export MKFS_NFS_PROG="false"
-        export MKFS_CIFS_PROG="false"
-        ;;
     Linux)
         export MKFS_XFS_PROG="`set_prog_path mkfs.xfs`"
         export MKFS_EXT4_PROG="`set_prog_path mkfs.ext4`"
diff --git a/common/dump b/common/dump
index d6663e0c..b0e4a12f 100644
--- a/common/dump
+++ b/common/dump
@@ -395,8 +395,6 @@ End-of-File
 
 _mk_fillconfig_perm()
 {
-    # dir_guid: ugo=rwx,g+s on dir is for IRIX chmod(1)
-
     cat <<End-of-File >$tmp.config
 # pathname	size/dir  user group mode
 #
@@ -406,7 +404,7 @@ file_sticky	10	$nobody	$nobody	01777
 file_mix1	10	$nobody	$nobody	761
 file_mix2	10	$nobody	$nobody	642
 dir_suid	d	$nobody	$nobody	04777
-dir_guid	d	$nobody	$nobody	ugo=rwx,g+s
+dir_guid	d	$nobody	$nobody	02777
 dir_sticky	d	$nobody	$nobody	01777
 dir_mix1	d	$nobody	$nobody	761
 dir_mix2	d	$nobody	$nobody	642
@@ -798,25 +796,6 @@ _ls_filter()
   | sed -e 's/total [0-9][0-9]*/total TOTAL/'
 }
 
-#
-# Filtering of Irix character hwgraph device names
-# e.g.
-# chardev: /hw/node/xtalk/15/pci/0/scsi_ctlr/0/target/1/lun/0/disk/partition/4/char
-# blkdev:  /dev/dsk/dks0d1s4
-#
-_filter_devchar()
-{
-    $AWK_PROG '
-	/\/hw\/node/ {
-	    sub(/\/hw.*scsi_ctlr\//,"/dev/dsk/dks")  # blah blah /dev/dsk/dks0/target/1/....
-	    sub(/\/target\//,"d")                    # blah blah /dev/dsk/dks0d1/lun/0/disk.....
-	    sub(/\/lun.*partition\//,"s")            # blah blah /dev/dsk/dks0d1s4/char
-	    sub(/\/char/,"")			     # blah blah /dev/dsk/dks0d1s4
-	}
-	{ print }
-    '
-}
-
 
 #
 # Filter out the non-deterministic dump msgs from
@@ -824,7 +803,6 @@ _filter_devchar()
 #
 _dump_filter_main()
 {
-  _filter_devchar |\
   sed \
       -e "s#$__XFSDUMP_PROG#xfsdump#"			\
       -e "s#$XFSRESTORE_PROG#xfsrestore#"		\
@@ -1191,7 +1169,7 @@ _do_restore_toc()
     echo "Contents of dump ..."
     opts="$_restore_debug$restore_args -f $dump_file -t"
     echo "xfsrestore $opts" | _dir_filter
-    cd $SCRATCH_MNT # for IRIX which needs xfs cwd
+    cd $SCRATCH_MNT
     $XFSRESTORE_PROG $opts 2>&1 | tee -a $seqres.full | _dump_filter_main |\
     _check_quota_file |\
     _check_quota_entries |\
@@ -1484,25 +1462,14 @@ _check_quota_entries()
 # xfsrestore: user quota information written to ...'
 # xfsrestore: group quota information written to ...'
 # xfsrestore: project quota information written to ...'
-#
-# If on IRIX then look for:
-# xfsrestore: use 'edquota' to restore quotas
-# Else look for:
 # xfsrestore: use 'xfs_quota' to restore quotas
 #
 _check_quota_dumprestore()
 {
-    if [ "$HOSTOS" == "IRIX" ]; then
 	_check_quota 'user quota information' \
 		     'group quota information' \
 		     'project quota information' | \
-	sed "/xfsrestore:.*use 'edquota' to restore quotas/d"
-    else
-	_check_quota 'user quota information' \
-		     'group quota information' \
-		     'project quota information' | \
-	sed "/xfsrestore:.*use 'xfs_quota' to restore quotas/d"
-    fi
+		sed "/xfsrestore:.*use 'xfs_quota' to restore quotas/d"
 }
 
 #
diff --git a/common/filestreams b/common/filestreams
index 4d146648..f5441f5a 100644
--- a/common/filestreams
+++ b/common/filestreams
@@ -21,35 +21,12 @@
 
 _check_filestreams_support()
 {
-	local irix_timeout_sysvar="xfs_mfstream_timeout"
-	local linux_timeout_procvar="/proc/sys/fs/xfs/filestream_centisecs"
-	local streams_avail=""
-	if [ "$HOSTOS" == "IRIX" ]; then
-		# check for the filestreams timeout systune variable in irix
-		streams_avail=`systune $irix_timeout_sysvar 2>&1 |
-			perl -ne 'if (/'$irix_timeout_sysvar'\s+=\s+\d+/) {print "true"}'`
-	else
-		# check for the filestreams timeout proc entry in linux
-		[ -f $linux_timeout_procvar ] && streams_avail="true"
-	fi
-
-	if [ "$streams_avail" == "true" ]; then
-		return 0
-	else
-		return 1
-	fi
+	[ -f /proc/sys/fs/xfs/filestream_centisecs ]
 }
 
 _set_stream_timeout_centisecs()
 {
-	local new_timeout_csecs=$1
-	local irix_timeout_sysvar="xfs_mfstream_timeout"
-	local linux_timeout_procvar="/proc/sys/fs/xfs/filestream_centisecs"
-	if [ "$HOSTOS" == "IRIX" ]; then
-		echo y | systune -r $irix_timeout_sysvar $new_timeout_csecs >/dev/null
-	else
-		echo $new_timeout_csecs > $linux_timeout_procvar
-	fi
+	echo $1 > /proc/sys/fs/xfs/filestream_centisecs
 }
 
 _do_stream()
@@ -63,22 +40,14 @@ _do_stream()
 	local blocks_in_file=`expr $file_size / $bsize`
 
 	mkdir $directory_name
-	if [ "$iflag" = "1" -a "$HOSTOS" != "IRIX" ]; then
+	if [ "$iflag" = "1" ]; then
 		$XFS_IO_PROG -x -c "chattr +S" $directory_name \
 			|| _fail "chattr of filestream flag"
 	fi
 	cd $directory_name
 
-	local dd_cmd=""
-	if [ "$HOSTOS" == "IRIX" ]; then
-		# for irix use lmdd
-		dd_cmd="lmdd"
-		[ "$dio" = "1" ] && dd_cmd="$dd_cmd odirect=1"
-	else
-		# for linux use dd
-		dd_cmd="dd"
-		[ "$dio" = "1" ] && dd_cmd="$dd_cmd oflag=direct"
-	fi
+	local dd_cmd="dd"
+	[ "$dio" = "1" ] && dd_cmd="$dd_cmd oflag=direct"
 	dd_cmd="$dd_cmd if=/dev/zero bs=${bsize} count=${blocks_in_file}"
 
 	local i=1
@@ -140,7 +109,7 @@ _test_streams() {
 	_scratch_mkfs_xfs -dsize=$size,agcount=$agcount >/dev/null 2>&1 \
 		|| _fail "mkfs failed"
 
-	if [ "$use_iflag" = "0" -o "$HOSTOS" == "IRIX" ]; then
+	if [ "$use_iflag" = "0" ]; then
 		# mount using filestreams mount option
 		_scratch_mount "-o filestreams" \
 			|| _fail "filestreams mount failed"
diff --git a/common/log b/common/log
index d1c19ff5..bdb4ed68 100644
--- a/common/log
+++ b/common/log
@@ -314,7 +314,6 @@ _print_operation()
 # and may not match with the FS mounted at a different LR size 
 # => xlog_do_recovery_pass() can not handle the different hdr sizes
 #    it assumes them all to be the same between the start..finish
-# NB: On IRIX there is no UMOUNT record and so we could start from -s 0.
 
 _print_transaction_inode()
 {
diff --git a/common/rc b/common/rc
index fa1314c6..d3bf8339 100644
--- a/common/rc
+++ b/common/rc
@@ -238,7 +238,7 @@ _scratch_options()
 
     case $type in
     mkfs)
-	[ "$HOSTOS" != "IRIX" ] && SCRATCH_OPTIONS="$SCRATCH_OPTIONS -f"
+	SCRATCH_OPTIONS="$SCRATCH_OPTIONS -f"
 	rt_opt="-r"
         log_opt="-l"
 	;;
@@ -287,14 +287,7 @@ _mount_ops_filter()
     [ $last_index -gt 0 ] && shift $last_index
     FS_ESCAPED=$1
     
-    # irix is fussy about how it is fed its mount options
-    # - multiple -o's are not allowed
-    # - no spaces between comma delimitered options
-    # the sed script replaces all -o's (except the first) with a comma
-    # not required for linux, but won't hurt
-    
-    echo $params | sed -e 's/[[:space:]]\+-o[[:space:]]*/UnIqUe/1; s/[[:space:]]\+-o[[:space:]]*/,/g; s/UnIqUe/ -o /1' \
-        | sed -e 's/dmapi/dmi/' \
+    echo $params | sed -e 's/dmapi/dmi/' \
         | $PERL_PROG -ne "s#mtpt=[^,|^\n|^\s]*#mtpt=$FS_ESCAPED\1\2#; print;"
 
 }
@@ -2116,12 +2109,7 @@ s,^\s*$,,;
 
 _user_do()
 {
-    if [ "$HOSTOS" == "IRIX" ]
-	then
-	echo $1 | /bin/bash "su $qa_user 2>&1" | _filter_user_do
-    else
 	echo $1 | su -s /bin/bash $qa_user 2>&1 | _filter_user_do
-    fi
 }
 
 _require_xfs_io_command()
@@ -2693,9 +2681,7 @@ _full_platform_details()
 
 _get_os_name()
 {
-	if [ "`uname`" == "IRIX64" ] || [ "`uname`" == "IRIX" ]; then
-		echo 'irix'
-	elif [ "`uname`" == "Linux" ]; then
+	if [ "`uname`" == "Linux" ]; then
 		echo 'linux'
 	else
 		echo Unknown operating system: `uname`
@@ -3259,9 +3245,6 @@ run_check()
 
 _require_test_symlinks()
 {
-	# IRIX UDF does not support symlinks
-	[ "$HOSTOS" = "IRIX" -a "$FSTYP" = 'udf' ] && \
-		_notrun "Require symlinks support"
 	target=`mktemp -p $TEST_DIR`
 	link=`mktemp -p $TEST_DIR -u`
 	ln -s `basename $target` $link
-- 
2.13.3

