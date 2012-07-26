Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6Q9SQTI006812 for <xfs@oss.sgi.com>; Thu, 26 Jul 2012 04:28:26 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	gbEA2WSDNgdmHWDw for <xfs@oss.sgi.com>;
	Thu, 26 Jul 2012 02:28:20 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SuKMh-0001AZ-2H
	for xfs@oss.sgi.com; Thu, 26 Jul 2012 19:28:15 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1SuKMg-0005V3-VS
	for xfs@oss.sgi.com; Thu, 26 Jul 2012 19:28:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 02/18] xfstests: remove bench infrastructure
Date: Thu, 26 Jul 2012 19:27:56 +1000
Message-Id: <1343294892-20991-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1343294892-20991-1-git-send-email-david@fromorbit.com>
References: <1343294892-20991-1-git-send-email-david@fromorbit.com>
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

The benchmark framework inside xfstests is basically unused,
bitrotted and not very useful. If we need benchmarks, lets use a
real benchmark framework, not xfstests. Kill it to remove
dependencies on common and common.rc.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 bench                  |  181 ------------------------------------------------
 common.bonnie          |   41 -----------
 common.config          |    3 +-
 common.dbench          |   73 -------------------
 common.metaperf        |   34 ---------
 common.rc              |    2 +-
 run.bonnie_io          |   66 ------------------
 run.bonnie_ops         |   84 ----------------------
 run.dbench             |   29 --------
 run.dbench10           |   29 --------
 run.dbench100          |   29 --------
 run.dbench2            |   29 --------
 run.dbench20           |   29 --------
 run.dbench50           |   29 --------
 run.dbenchmulti        |   37 ----------
 run.io                 |   61 ----------------
 run.metaperf_10i_1000n |   31 ---------
 run.metaperf_10i_1n    |   31 ---------
 run.metaperf_1i_1n     |   30 --------
 run.pio                |   69 ------------------
 run.rtio               |   61 ----------------
 run.tar                |   40 -----------
 22 files changed, 2 insertions(+), 1016 deletions(-)
 delete mode 100755 bench
 delete mode 100644 common.bonnie
 delete mode 100755 common.dbench
 delete mode 100755 common.metaperf
 delete mode 100755 run.bonnie_io
 delete mode 100755 run.bonnie_ops
 delete mode 100755 run.dbench
 delete mode 100755 run.dbench10
 delete mode 100755 run.dbench100
 delete mode 100755 run.dbench2
 delete mode 100755 run.dbench20
 delete mode 100755 run.dbench50
 delete mode 100755 run.dbenchmulti
 delete mode 100755 run.io
 delete mode 100755 run.metaperf_10i_1000n
 delete mode 100755 run.metaperf_10i_1n
 delete mode 100755 run.metaperf_1i_1n
 delete mode 100755 run.pio
 delete mode 100755 run.rtio
 delete mode 100755 run.tar

diff --git a/bench b/bench
deleted file mode 100755
index f415423..0000000
--- a/bench
+++ /dev/null
@@ -1,181 +0,0 @@
-#!/bin/bash
-#
-# Wrapper for automating benchmarking runs.
-# Usage:   bench passes user group [script]
-#
-# ..where passes is the number of times to run each script; uid/gid
-# gives credentials to use when running the script; and script is a
-# simple wrapper around each actual benchmark tool (eg. see run.*),
-# if this is ommited, all run.* scripts are used in turn.
-#
-# Each run.foo script should report a comma-separated-value list of
-# benchmark results on stdout or fail with a non-zero exit code;
-# unless the -i option is supplied in which case it should instead
-# report a comma-separated-value list of column headers (for report
-# generation purposes).
-#
-#-----------------------------------------------------------------------
-# Copyright (c) 2002-2003 Silicon Graphics, Inc.  All Rights Reserved.
-#
-# This program is free software; you can redistribute it and/or
-# modify it under the terms of the GNU General Public License as
-# published by the Free Software Foundation.
-#
-# This program is distributed in the hope that it would be useful,
-# but WITHOUT ANY WARRANTY; without even the implied warranty of
-# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-# GNU General Public License for more details.
-#
-# You should have received a copy of the GNU General Public License
-# along with this program; if not, write the Free Software Foundation,
-# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
-#
-#-----------------------------------------------------------------------
-#
-# creator
-owner=nathans@sgi.com
-
-iam=bench
-tmp=/tmp/$$
-here=`pwd`; export here
-status=1	# failure is the default!
-
-# get standard environment, filters and checks
-. ./common.rc
-. ./common.filter
-
-_cleanup()
-{
-    echo "        *** umount"
-    umount $SCRATCH_DEV >/dev/null 2>&1
-    rm -f $tmp.*
-}
-
-OUT="bench.out"
-LOG="bench.log"
-FULL="bench.full"
-
-_log()
-{
-    echo "$*" 1>&2
-    echo "$*" >>$LOG
-    echo "$*" >>$FULL
-    sync
-}
-
-_logp()
-{
-    tee -a $FULL
-}
-
-_fail()
-{
-    _log "$*"
-    status=1
-    exit 1
-}
-
-_run_benchmark()
-{
-    pass=1
-    uid=`id -u $user`
-    gid=`id -g $group`
-    
-    while [ $pass -le $passes -o $passes -lt 0 ]
-    do
-        _log "        *** clean scratch device [$bench starting, pass $pass]"
-        _scratch_mkfs 2>&1 | _fix_malloc >>$FULL
-        _log "        *** mounting scratch device"
-        _scratch_mount      || _fail "            !!! failed to mount"
-        
-        _log "        *** mkdir"
-        mkdir $SCRATCH_MNT/bench \
-                            || _fail "            !!! couldn't mkdir benchdir"
-        chown -R $user.$group $SCRATCH_MNT/bench \
-                            || _fail "            !!! couldn't chown benchdir"
-
-        cd $SCRATCH_MNT/bench
-        seq=`perl -e 'printf "results.%s.%03d\n", '$bench', '$pass`
-        rm -f $seq $tmp.out
-
-        _log "        *** bench [$seq]"
-        $here/src/runas -u $uid -g $gid $here/run.$bench >$tmp.out 2>>$FULL
-	[ $? -eq 0 ]        || _fail "            !!! $bench pass $pass failed"
-
-        cd $here
-        _fix_malloc < $tmp.out > $seq
-
-        _log "        *** unmounting scratch device"
-        umount $SCRATCH_DEV 2>&1 | _logp \
-                            || _fail "            !!! failed to umount"
-
-        _log "        *** post-umount filesystem check"
-        _check_scratch_fs
-        
-        let "pass = pass + 1"
-    done
-}
-
-_merge_results()
-{
-    echo Results for $bench benchmark
-    $here/run.$bench -h
-    echo results.$bench.* | sort -nu | xargs cat
-    echo
-}
-
-# real QA test starts here
-
-if [ $# -lt 3 ]; then
-    echo Usage:  bench passes user group [script]
-    exit 1
-fi
-
-passes=$1
-user=$2
-group=$3
-shift; shift; shift
-
-if [ $# -gt 0 ]; then
-    benches="$@"
-else
-    benches=`echo run.* | sed -e 's/run\.//g'`
-fi
-[ -z "$benches" -o "$benches" = "*" ] && _fail "no benchmark scripts found"
-
-trap "_cleanup; exit \$status" 0 1 2 3 15
-
-_require_scratch
-rm -f bench.* results.*
-
-FULL_FSTYP_DETAILS=`_full_fstyp_details`
-FULL_HOST_DETAILS=`_full_platform_details`
-FULL_MKFS_OPTIONS=`_scratch_mkfs_options`
-FULL_MOUNT_OPTIONS=`_scratch_mount_options`
-
-# $OUT is the report which will ultimately be sent, keep it tidy.
-cat >$OUT <<EOF
-FSTYP         -- $FULL_FSTYP_DETAILS
-PLATFORM      -- $FULL_HOST_DETAILS
-MKFS_OPTIONS  -- $FULL_MKFS_OPTIONS
-MOUNT_OPTIONS -- $FULL_MOUNT_OPTIONS
-
-EOF
-
-for bench in $benches
-do
-    echo "" >>$FULL
-    echo "" >$LOG
-    _log "*** benchmark started [passes=$passes, benchmark=$bench]"
-    _log "*** (`date`)"
-    _log "MKFS_OPTIONS  -- $FULL_MKFS_OPTIONS"
-    _log "MOUNT_OPTIONS -- $FULL_MOUNT_OPTIONS"
-    _log "        *** unmounting scratch device"
-    umount $SCRATCH_DEV 2>&1 | _fix_malloc >>$FULL
-
-    _run_benchmark | _fix_malloc
-    _merge_results >>$OUT
-
-    _log "*** done $bench"
-done
-status=0
diff --git a/common.bonnie b/common.bonnie
deleted file mode 100644
index 96ca700..0000000
--- a/common.bonnie
+++ /dev/null
@@ -1,41 +0,0 @@
-##/bin/bash
-#
-# Copyright (c) 2002-2004 Silicon Graphics, Inc.  All Rights Reserved.
-#
-# This program is free software; you can redistribute it and/or
-# modify it under the terms of the GNU General Public License as
-# published by the Free Software Foundation.
-#
-# This program is distributed in the hope that it would be useful,
-# but WITHOUT ANY WARRANTY; without even the implied warranty of
-# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-# GNU General Public License for more details.
-#
-# You should have received a copy of the GNU General Public License
-# along with this program; if not, write the Free Software Foundation,
-# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
-#
-
-#check bonnie is installed
-if [ "`whereis bonnie++`" == "bonnie++:"]; then
-        echo $0 error bonnie not installed.
-        exit
-fi
-
-run_bonnie()
-{
-	# dir, no hostname, quiet, fast (no per-char), ram (no sz checks)
-	tmp=/var/tmp
-
-	mkdir ./bonnie || exit 1
-	defaults="-d ./bonnie -q -f -r 0"
-	defaults="$defaults -u "`id -u`" -g "`id -g`
-	bonnie++ -m '' $defaults $@ >$tmp/$$.bonnie.stdout 2>$tmp/$$.bonnie.stderr
-	status=$?
-	rm -fr ./bonnie
-	[ $status -ne 0 ] && exit 1
-	filter_stdout < $tmp/$$.bonnie.stdout
-	filter_stderr < $tmp/$$.bonnie.stderr 1>&2
-	rm -f $tmp/$$.bonnie.stdout $tmp/$$.bonnie.stderr
-	exit 0
-}
diff --git a/common.config b/common.config
index bb9af93..4fbff81 100644
--- a/common.config
+++ b/common.config
@@ -40,7 +40,7 @@
 #   below or a separate local configuration file can be used (using
 #   the HOST_OPTIONS variable).
 # - This script is shared by the stress test system and the auto-qa
-#   system (includes both regression test and benchmark components).
+#   system
 # - TEST_DEV & TEST_DIR must be assigned.
 # - this script shouldn't make any assertions about filesystem
 #   validity or mountedness.
@@ -150,7 +150,6 @@ export __XFSDUMP_PROG="`set_prog_path xfsdump`"
 export XFSDUMP_PROG="$__XFSDUMP_PROG -e"
 export XFSRESTORE_PROG="`set_prog_path xfsrestore`"
 export XFSINVUTIL_PROG="`set_prog_path xfsinvutil`"
-export DBENCH_PROG="`set_prog_path dbench`"
 export GETFATTR_PROG="`set_prog_path getfattr`"
 export SETFATTR_PROG="`set_prog_path setfattr`"
 export ATTR_PROG="`set_prog_path attr`"
diff --git a/common.dbench b/common.dbench
deleted file mode 100755
index b59be71..0000000
--- a/common.dbench
+++ /dev/null
@@ -1,73 +0,0 @@
-##/bin/bash
-#
-# Copyright (c) 2002-2005 Silicon Graphics, Inc.  All Rights Reserved.
-#
-# This program is free software; you can redistribute it and/or
-# modify it under the terms of the GNU General Public License as
-# published by the Free Software Foundation.
-#
-# This program is distributed in the hope that it would be useful,
-# but WITHOUT ANY WARRANTY; without even the implied warranty of
-# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-# GNU General Public License for more details.
-#
-# You should have received a copy of the GNU General Public License
-# along with this program; if not, write the Free Software Foundation,
-# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
-#
-
-#check dbench is installed
-if [ "`whereis dbench`" == "dbench:" ]; then
-        echo $0 error dbench not installed.
-        exit
-fi
-
-_run_dbench()
-{
-	mkdir ./dbench || exit 1
-	cd dbench
-	dbench -x $1
-	status=$?
-	cd ..
-	rm -fr ./dbench
-	[ $status -ne 0 ] && exit 1
-}
-
-#
-# Sample dbench output:
-# "Throughput 40.6701 MB/sec (NB=50.8376 MB/sec  406.701 MBit/sec)"
-# 
-
-# Output for a single-shot dbench run.
-_format_header()
-{
-	printf "%8s, %s\n" clients MB/sec
-}
-_filter_dbench()
-{
-	clients=$1
-	perl -ne 'm/Throughput (\S+) MB\/sec/ &&
-			{ printf "%8u, %s\n", '$clients', $1 }'
-}
-
-# Output for a "multipass" dbench run.
-_format_header_multipass()
-{
-	while [ $# -gt 1 ]; do
-		printf "%4s::MB/sec," $1
-		shift
-	done
-	printf "%4s::MB/sec\n" $1
-}
-_filter_dbench_multipass()
-{
-	perl -ne '
-	if (m/Throughput (\S+) MB\/sec/) {
-		$results[$count++] = $1;
-	}
-	END {	for ($i = 0; $i < $count - 1; $i++) {
-			printf "%12.3f,", $results[$i];
-		}
-		printf "%12.3f\n", $results[$count-1];
-	}'
-}
diff --git a/common.metaperf b/common.metaperf
deleted file mode 100755
index 9def379..0000000
--- a/common.metaperf
+++ /dev/null
@@ -1,34 +0,0 @@
-##/bin/bash
-#
-# Copyright (c) 2003-2005 Silicon Graphics, Inc.  All Rights Reserved.
-#
-# This program is free software; you can redistribute it and/or
-# modify it under the terms of the GNU General Public License as
-# published by the Free Software Foundation.
-#
-# This program is distributed in the hope that it would be useful,
-# but WITHOUT ANY WARRANTY; without even the implied warranty of
-# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-# GNU General Public License for more details.
-#
-# You should have received a copy of the GNU General Public License
-# along with this program; if not, write the Free Software Foundation,
-# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
-#
-
-_format_metaperf()
-{
-    perl -ne 'm/(\S+): (\d+) times, (\d+) file\(s\) namelen (\d+), time = (\S+) sec, ops\/sec=(\S+), usec\/op = (\S+)/ && { $op{$1} = $7 };
-	END { printf "%8.2f,%8.2f,%8.2f,%8.2f,%8.2f,%8.2f,%8.2f,%8.2f\n",
-		$op{"chown"}, $op{"create"}, $op{"crunlink"}, $op{"linkun"},
-		$op{"open"}, $op{"rename"}, $op{"stat"}, $op{"readdir"} }'
-}
-
-_format_header()
-{
-    # note: we're reporting only the usec/op field
-    printf "%8s,%8s,%8s,%8s,%8s,%8s,%8s,%8s\n" \
-	chown create crulink linkun open rename stat readdir
-}
-
-allops="chown create crunlink linkun open rename stat readdir"
diff --git a/common.rc b/common.rc
index 1b23b66..2ffff41 100644
--- a/common.rc
+++ b/common.rc
@@ -1920,7 +1920,7 @@ _devmgt_add()
 
 ################################################################################
 
-if [ "$iam" != new -a "$iam" != bench ]
+if [ "$iam" != new ]
 then
     # make some further configuration checks here
 
diff --git a/run.bonnie_io b/run.bonnie_io
deleted file mode 100755
index e108650..0000000
--- a/run.bonnie_io
+++ /dev/null
@@ -1,66 +0,0 @@
-#!/bin/bash
-#
-# Copyright (c) 2002-2003 Silicon Graphics, Inc.  All Rights Reserved.
-#
-# This program is free software; you can redistribute it and/or
-# modify it under the terms of the GNU General Public License as
-# published by the Free Software Foundation.
-#
-# This program is distributed in the hope that it would be useful,
-# but WITHOUT ANY WARRANTY; without even the implied warranty of
-# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-# GNU General Public License for more details.
-#
-# You should have received a copy of the GNU General Public License
-# along with this program; if not, write the Free Software Foundation,
-# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
-#
-# 
-# Does a bonnie throughput run (80M file and 1K chunksize if the
-# BONNIE_FILESIZE and/or BONNIE_CHUNKSIZE variables are not set),
-# then massages the output into CSV format with the human-readable
-# output preceding it as a "comment" (ie. #-prefixed).
-# 
-BONNIE_FILESIZE=${BONNIE_FILESIZE:=500M}
-BONNIE_CHUNKSIZE=${BONNIE_CHUNKSIZE:=1K}
-
-[ -z "$here" ] && here=`pwd`
-. $here/common.bonnie
-
-# 
-# Sample bonnie throughput output (stderr):
-#Version 1.02c       ------Sequential Output------ --Sequential Input- --Random-
-#                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
-#Machine   Size:chnk K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
-#          150M:64k           52024  99 88969  99           245492 100  3746 264
-# 
-filter_stderr()
-{
-	sed -e 's/^..................../# /g' | awk '{print} END {print "#"}'
-}
-
-# 
-# Sample bonnie throughput output (stdout):
-# ",150M:64k,,,52024,99,88969,99,,,245492,100,3746.0,264,,,,,,,,,,,,,"
-# 
-filter_stdout()
-{
-	perl -ne '
-		chomp;
-		s/,+/,/g; s/^,//; s/,$//;
-		@values = split /,/;
-		printf "%9s", shift @values;
-		for ($i = 0; $i <= $#values; $i++) {
-			if ($i % 2) { printf ",%4s%%", $values[$i] }
-			else        { printf ",%10s", $values[$i] }
-		}
-		printf "\n";
-	'
-}
-
-if [ $# -gt 0 ]; then
-	printf "%9s,%10s,%5s,%10s,%5s,%10s,%5s,%10s,%5s\n" size:chnk \
-		writeK/s wCPU rewriteK/s rwCPU readK/s rCPU seek/s sCPU
-	exit 0
-fi
-run_bonnie -n 0 -s $BONNIE_FILESIZE:$BONNIE_CHUNKSIZE
diff --git a/run.bonnie_ops b/run.bonnie_ops
deleted file mode 100755
index 609b93c..0000000
--- a/run.bonnie_ops
+++ /dev/null
@@ -1,84 +0,0 @@
-#!/bin/bash
-#
-# Copyright (c) 2002-2003 Silicon Graphics, Inc.  All Rights Reserved.
-#
-# This program is free software; you can redistribute it and/or
-# modify it under the terms of the GNU General Public License as
-# published by the Free Software Foundation.
-#
-# This program is distributed in the hope that it would be useful,
-# but WITHOUT ANY WARRANTY; without even the implied warranty of
-# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-# GNU General Public License for more details.
-#
-# You should have received a copy of the GNU General Public License
-# along with this program; if not, write the Free Software Foundation,
-# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
-#
-# 
-# Do a bonnie++ create/read/delete run using 8192 files (unless
-# BONNIE_KFILES environment variable is set -- note this number
-# is multiplied by 1024 by bonnie++).  By default the files are
-# created in the same directory, BONNIE_NDIRS specifies a count
-# of subdirs to evenly spread files through.  Regular files are
-# created by default (BONNIE_FILETYPE=regular), alternatively
-# the values "symlinks" and "hardlinks" can be used.
-# 
-# The script then massages the output into CSV format with the
-# human-readable output preceding it as a "comment" (#-prefixed).
-# 
-BONNIE_NDIRS=${BONNIE_NDIRS:=1}
-BONNIE_KFILES=${BONNIE_KFILES:=8}
-BONNIE_FILETYPE=${BONNIE_FILETYPE:=regular}
-
-[ -z "$here" ] && here=`pwd`
-. $here/common.bonnie
-
-# 
-# Sample bonnie throughput output (stderr):
-#Version 1.02c       ------Sequential Create------ --------Random Create--------
-#                    -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
-#              files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
-#                  4   525  27 +++++ +++   517  26   526  25 +++++ +++   230  12
-# [ Note: the "files" can also be "^files:max" and possibly other things ]
-filter_stderr()
-{
-	sed -e 's/^..................../# /g' | awk '{print} END {print "#"}'
-}
-
-# 
-# Sample bonnie IOPs output (stdout):
-# ",,,,,,,,,,,,,,4,525,27,+++++,+++,517,26,526,25,+++++,+++,230,12"
-# [ nathans note: always get +++ due to 0:0 for min:max file sizes. ]
-# [ I will need to fix the filter if I ever start using file sizes. ]
-# 
-filter_stdout()
-{
-	perl -ne '
-		chomp;
-		s/\+*//g; s/,+/,/g; s/^,//; s/,$//;
-		@values = split /,/;
-		printf "%9s", 1024 * shift @values;
-		for ($i = 0; $i <= $#values; $i++) {
-			if ($i % 2) { printf ",%4s%%", $values[$i] }
-			else        { printf ",%10s", $values[$i] }
-		}
-		printf "\n";
-	'
-}
-
-if [ $# -gt 0 ]; then
-	printf "%9s,%10s,%5s,%10s,%5s,%10s,%5s,%10s,%5s\n" files \
-		seqCR/s scCPU seqRM/s srCPU randCR/s rcCPU randRM/s rrCPU
-	exit 0
-fi
-
-case "$BONNIE_FILETYPE"
-in
-	regular)  BONNIE_FILETYPE=0 ;;
-	symlink)  BONNIE_FILETYPE=-2 ;;
-	hardlink) BONNIE_FILETYPE=-1 ;;
-	*)  echo "BONNIE_FILETYPE has an unrecognised value" && exit 1 ;;
-esac
-
-run_bonnie -s 0 -n $BONNIE_KFILES:$BONNIE_FILETYPE:0:$BONNIE_NDIRS
diff --git a/run.dbench b/run.dbench
deleted file mode 100755
index 8e86807..0000000
--- a/run.dbench
+++ /dev/null
@@ -1,29 +0,0 @@
-#!/bin/bash
-#
-# Copyright (c) 2002-2003 Silicon Graphics, Inc.  All Rights Reserved.
-#
-# This program is free software; you can redistribute it and/or
-# modify it under the terms of the GNU General Public License as
-# published by the Free Software Foundation.
-#
-# This program is distributed in the hope that it would be useful,
-# but WITHOUT ANY WARRANTY; without even the implied warranty of
-# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-# GNU General Public License for more details.
-#
-# You should have received a copy of the GNU General Public License
-# along with this program; if not, write the Free Software Foundation,
-# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
-#
-# 
-# Does a single-client dbench run
-# 
-
-[ -z "$here" ] && here=`pwd`
-. $here/common.dbench
-
-if [ $# -gt 0 ]; then
-	_format_header
-	exit 0
-fi
-_run_dbench 1 | _filter_dbench 1
diff --git a/run.dbench10 b/run.dbench10
deleted file mode 100755
index e3a08c4..0000000
--- a/run.dbench10
+++ /dev/null
@@ -1,29 +0,0 @@
-#!/bin/bash
-#
-# Copyright (c) 2002-2003 Silicon Graphics, Inc.  All Rights Reserved.
-#
-# This program is free software; you can redistribute it and/or
-# modify it under the terms of the GNU General Public License as
-# published by the Free Software Foundation.
-#
-# This program is distributed in the hope that it would be useful,
-# but WITHOUT ANY WARRANTY; without even the implied warranty of
-# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-# GNU General Public License for more details.
-#
-# You should have received a copy of the GNU General Public License
-# along with this program; if not, write the Free Software Foundation,
-# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
-#
-# 
-# Does a dbench run with 10 clients
-# 
-
-[ -z "$here" ] && here=`pwd`
-. $here/common.dbench
-
-if [ $# -gt 0 ]; then
-	_format_header
-	exit 0
-fi
-_run_dbench 10 | _filter_dbench 10
diff --git a/run.dbench100 b/run.dbench100
deleted file mode 100755
index 51708d1..0000000
--- a/run.dbench100
+++ /dev/null
@@ -1,29 +0,0 @@
-#!/bin/bash
-#
-# Copyright (c) 2002-2003 Silicon Graphics, Inc.  All Rights Reserved.
-#
-# This program is free software; you can redistribute it and/or
-# modify it under the terms of the GNU General Public License as
-# published by the Free Software Foundation.
-#
-# This program is distributed in the hope that it would be useful,
-# but WITHOUT ANY WARRANTY; without even the implied warranty of
-# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-# GNU General Public License for more details.
-#
-# You should have received a copy of the GNU General Public License
-# along with this program; if not, write the Free Software Foundation,
-# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
-#
-# 
-# Does a dbench run with 100 clients
-# 
-
-[ -z "$here" ] && here=`pwd`
-. $here/common.dbench
-
-if [ $# -gt 0 ]; then
-	_format_header
-	exit 0
-fi
-_run_dbench 100 | _filter_dbench 100
diff --git a/run.dbench2 b/run.dbench2
deleted file mode 100755
index c56c208..0000000
--- a/run.dbench2
+++ /dev/null
@@ -1,29 +0,0 @@
-#!/bin/bash
-#
-# Copyright (c) 2002-2003 Silicon Graphics, Inc.  All Rights Reserved.
-#
-# This program is free software; you can redistribute it and/or
-# modify it under the terms of the GNU General Public License as
-# published by the Free Software Foundation.
-#
-# This program is distributed in the hope that it would be useful,
-# but WITHOUT ANY WARRANTY; without even the implied warranty of
-# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-# GNU General Public License for more details.
-#
-# You should have received a copy of the GNU General Public License
-# along with this program; if not, write the Free Software Foundation,
-# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
-#
-# 
-# Does a dbench run with 2 clients
-# 
-
-[ -z "$here" ] && here=`pwd`
-. $here/common.dbench
-
-if [ $# -gt 0 ]; then
-	_format_header
-	exit 0
-fi
-_run_dbench 2 | _filter_dbench 2
diff --git a/run.dbench20 b/run.dbench20
deleted file mode 100755
index 81f713c..0000000
--- a/run.dbench20
+++ /dev/null
@@ -1,29 +0,0 @@
-#!/bin/bash
-#
-# Copyright (c) 2003 Silicon Graphics, Inc.  All Rights Reserved.
-#
-# This program is free software; you can redistribute it and/or
-# modify it under the terms of the GNU General Public License as
-# published by the Free Software Foundation.
-#
-# This program is distributed in the hope that it would be useful,
-# but WITHOUT ANY WARRANTY; without even the implied warranty of
-# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-# GNU General Public License for more details.
-#
-# You should have received a copy of the GNU General Public License
-# along with this program; if not, write the Free Software Foundation,
-# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
-#
-# 
-# Does a dbench run with 20 clients
-# 
-
-[ -z "$here" ] && here=`pwd`
-. $here/common.dbench
-
-if [ $# -gt 0 ]; then
-	_format_header
-	exit 0
-fi
-_run_dbench 20 | _filter_dbench 20
diff --git a/run.dbench50 b/run.dbench50
deleted file mode 100755
index 4c54e0b..0000000
--- a/run.dbench50
+++ /dev/null
@@ -1,29 +0,0 @@
-#!/bin/bash
-#
-# Copyright (c) 2002-2003 Silicon Graphics, Inc.  All Rights Reserved.
-#
-# This program is free software; you can redistribute it and/or
-# modify it under the terms of the GNU General Public License as
-# published by the Free Software Foundation.
-#
-# This program is distributed in the hope that it would be useful,
-# but WITHOUT ANY WARRANTY; without even the implied warranty of
-# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-# GNU General Public License for more details.
-#
-# You should have received a copy of the GNU General Public License
-# along with this program; if not, write the Free Software Foundation,
-# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
-#
-# 
-# Does a dbench run with 50 clients
-# 
-
-[ -z "$here" ] && here=`pwd`
-. $here/common.dbench
-
-if [ $# -gt 0 ]; then
-	_format_header
-	exit 0
-fi
-_run_dbench 50 | _filter_dbench 50
diff --git a/run.dbenchmulti b/run.dbenchmulti
deleted file mode 100755
index 317a100..0000000
--- a/run.dbenchmulti
+++ /dev/null
@@ -1,37 +0,0 @@
-#!/bin/bash
-#
-# Copyright (c) 2003 Silicon Graphics, Inc.  All Rights Reserved.
-#
-# This program is free software; you can redistribute it and/or
-# modify it under the terms of the GNU General Public License as
-# published by the Free Software Foundation.
-#
-# This program is distributed in the hope that it would be useful,
-# but WITHOUT ANY WARRANTY; without even the implied warranty of
-# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-# GNU General Public License for more details.
-#
-# You should have received a copy of the GNU General Public License
-# along with this program; if not, write the Free Software Foundation,
-# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
-#
-# 
-# Does several dbench runs with increasing numbers of client
-# 
-
-[ -z "$here" ] && here=`pwd`
-. $here/common.dbench
-
-if [ $# -gt 0 ]; then
-	_format_header_multipass 1 2 10 20 #50
-	exit 0
-fi
-tmpfile=/var/tmp/dbench.$$
-rm -f $tmpfile
-_run_dbench 1	>> $tmpfile
-_run_dbench 2	>> $tmpfile
-_run_dbench 10	>> $tmpfile
-_run_dbench 20	>> $tmpfile
-#_run_dbench 50	>> $tmpfile
-_filter_dbench_multipass < $tmpfile
-rm -f $tmpfile
diff --git a/run.io b/run.io
deleted file mode 100755
index 91e3b93..0000000
--- a/run.io
+++ /dev/null
@@ -1,61 +0,0 @@
-#!/bin/bash
-#
-# Copyright (c) 2005 Silicon Graphics, Inc.  All Rights Reserved.
-#
-# This program is free software; you can redistribute it and/or
-# modify it under the terms of the GNU General Public License as
-# published by the Free Software Foundation.
-#
-# This program is distributed in the hope that it would be useful,
-# but WITHOUT ANY WARRANTY; without even the implied warranty of
-# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-# GNU General Public License for more details.
-#
-# You should have received a copy of the GNU General Public License
-# along with this program; if not, write the Free Software Foundation,
-# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
-#
-#
-# (very) simple file IO tests.
-# TODO: make file size multiple of physmem.
-
-filesize=1g
-iosize=64k
-
-if [ $# -gt 0 ]; then
-	printf "%s,%s,%s,%s,%s\n" type bytes ops time bytes/sec ops/sec
-	exit 0
-fi
-
-# buffered write
-echo -n bwrite,
-xfs_io iofile	-Fft	-c "pwrite -C -b $iosize 0 $filesize"
-
-# direct write
-echo -n dwrite,
-xfs_io iofile	-Fftd	-c "pwrite -C -b $iosize 0 $filesize"
-
-# buffered re-write
-echo -n brwrite,
-xfs_io iofile	-F	-c "pwrite -C -b $iosize 0 $filesize"
-
-# direct re-write
-echo -n drwrite,
-xfs_io iofile	-Fd	-c "pwrite -C -b $iosize 0 $filesize"
-
-# buffered read
-echo -n bread,
-xfs_io iofile	-F	-c "pread -C -b $iosize 0 $filesize"
-
-# buffered re-read
-echo -n brread,
-xfs_io iofile	-F	-c "pread -C -b $iosize 0 $filesize"
-
-# direct read
-echo -n dread,
-xfs_io iofile	-Fd	-c "pread -C -b $iosize 0 $filesize"
-
-# direct re-read
-echo -n drread,
-xfs_io iofile	-Fd	-c "pread -C -b $iosize 0 $filesize"
-
diff --git a/run.metaperf_10i_1000n b/run.metaperf_10i_1000n
deleted file mode 100755
index a420696..0000000
--- a/run.metaperf_10i_1000n
+++ /dev/null
@@ -1,31 +0,0 @@
-#!/bin/bash
-#
-# Copyright (c) 2003 Silicon Graphics, Inc.  All Rights Reserved.
-#
-# This program is free software; you can redistribute it and/or
-# modify it under the terms of the GNU General Public License as
-# published by the Free Software Foundation.
-#
-# This program is distributed in the hope that it would be useful,
-# but WITHOUT ANY WARRANTY; without even the implied warranty of
-# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-# GNU General Public License for more details.
-#
-# You should have received a copy of the GNU General Public License
-# along with this program; if not, write the Free Software Foundation,
-# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
-#
-# 
-# Runs the metaperf metadata micro-benchmark.
-# Use 1000 files, 10 iterations.
-# 
-
-[ -z "$here" ] && here=`pwd`
-. $here/common.metaperf
-
-if [ $# -gt 0 ]; then
-    _format_header
-    exit 0
-fi
-
-$here/src/metaperf -d . -i 10 -n 1000 -l15 $allops | _format_metaperf
diff --git a/run.metaperf_10i_1n b/run.metaperf_10i_1n
deleted file mode 100755
index 296fd58..0000000
--- a/run.metaperf_10i_1n
+++ /dev/null
@@ -1,31 +0,0 @@
-#!/bin/bash
-#
-# Copyright (c) 2003 Silicon Graphics, Inc.  All Rights Reserved.
-#
-# This program is free software; you can redistribute it and/or
-# modify it under the terms of the GNU General Public License as
-# published by the Free Software Foundation.
-#
-# This program is distributed in the hope that it would be useful,
-# but WITHOUT ANY WARRANTY; without even the implied warranty of
-# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-# GNU General Public License for more details.
-#
-# You should have received a copy of the GNU General Public License
-# along with this program; if not, write the Free Software Foundation,
-# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
-#
-# 
-# Runs the metaperf metadata micro-benchmark.
-# Use 1 file, 10 iterations.
-# 
-
-[ -z "$here" ] && here=`pwd`
-. $here/common.metaperf
-
-if [ $# -gt 0 ]; then
-    _format_header
-    exit 0
-fi
-
-$here/src/metaperf -d . -i 10 -n 1 -l15 $allops | _format_metaperf
diff --git a/run.metaperf_1i_1n b/run.metaperf_1i_1n
deleted file mode 100755
index ef02852..0000000
--- a/run.metaperf_1i_1n
+++ /dev/null
@@ -1,30 +0,0 @@
-#!/bin/bash
-#
-# Copyright (c) 2003 Silicon Graphics, Inc.  All Rights Reserved.
-#
-# This program is free software; you can redistribute it and/or
-# modify it under the terms of the GNU General Public License as
-# published by the Free Software Foundation.
-#
-# This program is distributed in the hope that it would be useful,
-# but WITHOUT ANY WARRANTY; without even the implied warranty of
-# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-# GNU General Public License for more details.
-#
-# You should have received a copy of the GNU General Public License
-# along with this program; if not, write the Free Software Foundation,
-# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
-#
-# 
-# Runs the metaperf metadata micro-benchmark.
-# Use 1 file, 1 iteration. (worst case)
-# 
-
-. $here/common.metaperf
-
-if [ $# -gt 0 ]; then
-    _format_header
-    exit 0
-fi
-
-$here/src/metaperf -d . -i 1 -n 1 -l15 $allops | _format_metaperf
diff --git a/run.pio b/run.pio
deleted file mode 100755
index 1b67fbf..0000000
--- a/run.pio
+++ /dev/null
@@ -1,69 +0,0 @@
-#!/bin/bash
-#
-# Copyright (c) 2005 Silicon Graphics, Inc.  All Rights Reserved.
-#
-# This program is free software; you can redistribute it and/or
-# modify it under the terms of the GNU General Public License as
-# published by the Free Software Foundation.
-#
-# This program is distributed in the hope that it would be useful,
-# but WITHOUT ANY WARRANTY; without even the implied warranty of
-# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-# GNU General Public License for more details.
-#
-# You should have received a copy of the GNU General Public License
-# along with this program; if not, write the Free Software Foundation,
-# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
-#
-#
-# (very) simple parallel IO tests.
-# TODO: make file size multiple of physmem.
-
-filesize=1g
-iosize=64k
-
-if [ $# -gt 0 ]; then
-	printf "%s,%s,%s,%s,%s\n" type bytes ops time bytes/sec ops/sec
-	exit 0
-fi
-
-# buffered write
-echo -n bwrite,
-xfs_io iofile1	-Fft	-c "pwrite -C -b $iosize 0 $filesize" &
-xfs_io iofile2	-Fft	-c "pwrite -C -b $iosize 0 $filesize"
-
-# direct write
-echo -n dwrite,
-xfs_io iofile1	-Fftd	-c "pwrite -C -b $iosize 0 $filesize" &
-xfs_io iofile2	-Fftd	-c "pwrite -C -b $iosize 0 $filesize"
-
-# buffered re-write
-echo -n brwrite,
-xfs_io iofile1	-F	-c "pwrite -C -b $iosize 0 $filesize" &
-xfs_io iofile2	-F	-c "pwrite -C -b $iosize 0 $filesize"
-
-# direct re-write
-echo -n drwrite,
-xfs_io iofile1	-Fd	-c "pwrite -C -b $iosize 0 $filesize" &
-xfs_io iofile2	-Fd	-c "pwrite -C -b $iosize 0 $filesize"
-
-# buffered read
-echo -n bread,
-xfs_io iofile1	-F	-c "pread -C -b $iosize 0 $filesize" &
-xfs_io iofile2	-F	-c "pread -C -b $iosize 0 $filesize"
-
-# buffered re-read
-echo -n brread,
-xfs_io iofile1	-F	-c "pread -C -b $iosize 0 $filesize" &
-xfs_io iofile2	-F	-c "pread -C -b $iosize 0 $filesize"
-
-# direct read
-echo -n dread,
-xfs_io iofile1	-Fd	-c "pread -C -b $iosize 0 $filesize" &
-xfs_io iofile2	-Fd	-c "pread -C -b $iosize 0 $filesize"
-
-# direct re-read
-echo -n drread,
-xfs_io iofile1	-Fd	-c "pread -C -b $iosize 0 $filesize" &
-xfs_io iofile2	-Fd	-c "pread -C -b $iosize 0 $filesize"
-
diff --git a/run.rtio b/run.rtio
deleted file mode 100755
index 14aded6..0000000
--- a/run.rtio
+++ /dev/null
@@ -1,61 +0,0 @@
-#!/bin/bash
-#
-# Copyright (c) 2005 Silicon Graphics, Inc.  All Rights Reserved.
-#
-# This program is free software; you can redistribute it and/or
-# modify it under the terms of the GNU General Public License as
-# published by the Free Software Foundation.
-#
-# This program is distributed in the hope that it would be useful,
-# but WITHOUT ANY WARRANTY; without even the implied warranty of
-# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-# GNU General Public License for more details.
-#
-# You should have received a copy of the GNU General Public License
-# along with this program; if not, write the Free Software Foundation,
-# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
-#
-#
-# (very) simple file realtime IO tests.
-# TODO: make file size multiple of physmem.
-
-filesize=1g
-iosize=64k
-
-if [ $# -gt 0 ]; then
-	printf "%s,%s,%s,%s,%s\n" type bytes ops time bytes/sec ops/sec
-	exit 0
-fi
-
-# buffered write
-echo -n bwrite,
-xfs_io iofile	-Rft	-c "pwrite -C -b $iosize 0 $filesize"
-
-# direct write
-echo -n dwrite,
-xfs_io iofile	-Rftd	-c "pwrite -C -b $iosize 0 $filesize"
-
-# buffered re-write
-echo -n brwrite,
-xfs_io iofile	-R	-c "pwrite -C -b $iosize 0 $filesize"
-
-# direct re-write
-echo -n drwrite,
-xfs_io iofile	-Rd	-c "pwrite -C -b $iosize 0 $filesize"
-
-# buffered read
-echo -n bread,
-xfs_io iofile	-R	-c "pread -C -b $iosize 0 $filesize"
-
-# buffered re-read
-echo -n brread,
-xfs_io iofile	-R	-c "pread -C -b $iosize 0 $filesize"
-
-# direct read
-echo -n dread,
-xfs_io iofile	-Rd	-c "pread -C -b $iosize 0 $filesize"
-
-# direct re-read
-echo -n drread,
-xfs_io iofile	-Rd	-c "pread -C -b $iosize 0 $filesize"
-
diff --git a/run.tar b/run.tar
deleted file mode 100755
index 6e8afd3..0000000
--- a/run.tar
+++ /dev/null
@@ -1,40 +0,0 @@
-#!/bin/bash
-# 
-# Produces a .tar file (if one doesn't exist as $TARFILE), then
-# times how long it takes to untar it onto the current directory.
-# 
-TARFILE=${TARFILE:=/var/tmp/bench.tar.gz}
-
-barf()
-{
-	echo $@ >2
-	exit 1
-}
-
-new_tar()
-{
-	source="bin sbin lib"
-	if [ ! -f $TARFILE ]; then
-		( cd / && tar czf $TARFILE $source ) || barf "tar cz failed"
-	fi
-}
-
-run_tar()
-{
-	# %U=user %S=system %E=elapsed
-	mkdir ./tar || exit 1
-	size=`ls -Llh $TARFILE | awk '{print $5}'`
-	time=`/usr/bin/time -f '%U, %S, %E' tar xzf $TARFILE 2>&1`
-	status=$?
-	cd ..
-	rm -fr ./tar
-	[ $status -eq 0 ] || exit 1
-	printf "%6s, %s\n" "$size" "$time"
-}
-
-if [ $# -gt 0 ]; then
-	printf "%6s,%5s,%5s,%8s\n" sz usr sys real
-	exit 0
-fi
-new_tar
-run_tar
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
