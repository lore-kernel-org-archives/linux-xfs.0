Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6Q9SUnq006826 for <xfs@oss.sgi.com>; Thu, 26 Jul 2012 04:28:30 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	OthYY8S58RmpAide for <xfs@oss.sgi.com>;
	Thu, 26 Jul 2012 02:28:27 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SuKMh-0001Ae-5Z
	for xfs@oss.sgi.com; Thu, 26 Jul 2012 19:28:15 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1SuKMh-0005VH-2O
	for xfs@oss.sgi.com; Thu, 26 Jul 2012 19:28:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 05/18] xfstests: fold common into check
Date: Thu, 26 Jul 2012 19:27:59 +1000
Message-Id: <1343294892-20991-6-git-send-email-david@fromorbit.com>
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

There is only one user of the common file now - check. Fold the two
into one file as the split of functionality is not necessary
anymore.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 check  |  313 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 common |  334 ----------------------------------------------------------------
 2 files changed, 311 insertions(+), 336 deletions(-)
 delete mode 100644 common

diff --git a/check b/check
index a4af0f6..bccdc08 100755
--- a/check
+++ b/check
@@ -44,9 +44,318 @@ then
     exit 1
 fi
 
-# we need common
-. ./common
+# argument parsing first - currently very messy, needs cleanup.
+_setenvironment()
+{
+    MSGVERB="text:action"
+    export MSGVERB
+}
+
+usage()
+{
+    echo "Usage: $0 [options] [testlist]"'
+
+common options
+    -v			verbose
+
+check options
+    -xfs                test XFS (default)
+    -udf                test UDF
+    -nfs                test NFS
+    -l			line mode diff
+    -xdiff		graphical mode diff
+    -udiff		show unified diff (default)
+    -n			show me, do not run tests
+    -q			quick [deprecated]
+    -T			output timestamps
+    -r			randomize test order
+    --large-fs		optimise scratch device for large filesystems
+
+testlist options
+    -g group[,group...]	include tests from these groups
+    -x group[,group...]	exclude tests from these groups
+    NNN			include test NNN
+    NNN-NNN		include test range (eg. 012-021)
+'
+	    exit 0
+}
+
+here=`pwd`
+rm -f $here/$iam.out
+_setenvironment
+
+check=${check-true}
+
+diff="diff -u"
+verbose=false
+group=false
+xgroup=false
+showme=false
+sortme=false
+expunge=true
+have_test_arg=false
+randomize=false
+rm -f $tmp.list $tmp.tmp $tmp.sed
+
+# Autodetect fs type based on what's on $TEST_DEV
+if [ "$HOSTOS" == "Linux" ]
+then
+    export FSTYP=`blkid -c /dev/null -s TYPE -o value $TEST_DEV`
+else
+    export FSTYP=xfs
+fi
+
+for r
+do
+
+    if $group
+    then
+	# arg after -g
+       group_list=$(sed -n < group \
+                       -e 's/#.*//' \
+                       -e 's/$/ /' \
+                       -e "/^[0-9][0-9][0-9].* $r /"'{ s/ .*//p }')
+	if [ -z "$group_list" ]
+	then
+	    echo "Group \"$r\" is empty or not defined?"
+	    exit 1
+	fi
+	[ ! -s $tmp.list ] && touch $tmp.list
+	for t in $group_list
+	do
+	    if grep -s "^$t\$" $tmp.list >/dev/null
+	    then
+		:
+	    else
+		echo "$t" >>$tmp.list
+	    fi
+	done
+	group=false
+	continue
+
+    elif $xgroup
+    then
+	# arg after -x
+	[ ! -s $tmp.list ] && ls [0-9][0-9][0-9] [0-9][0-9][0-9][0-9] >$tmp.list 2>/dev/null
+	group_list=`sed -n <group -e 's/$/ /' -e "/^[0-9][0-9][0-9].* $r /"'{
+s/ .*//p
+}'`
+	if [ -z "$group_list" ]
+	then
+	    echo "Group \"$r\" is empty or not defined?"
+	    exit 1
+	fi
+	numsed=0
+	rm -f $tmp.sed
+	for t in $group_list
+	do
+	    if [ $numsed -gt 100 ]
+	    then
+		sed -f $tmp.sed <$tmp.list >$tmp.tmp
+		mv $tmp.tmp $tmp.list
+		numsed=0
+		rm -f $tmp.sed
+	    fi
+	    echo "/^$t\$/d" >>$tmp.sed
+	    numsed=`expr $numsed + 1`
+	done
+	sed -f $tmp.sed <$tmp.list >$tmp.tmp
+	mv $tmp.tmp $tmp.list
+	xgroup=false
+	continue
+    fi
+
+    xpand=true
+    case "$r"
+    in
+
+	-\? | -h | --help)	# usage
+	    usage
+	    ;;
+
+	-udf)	# -udf ... set FSTYP to udf
+	    FSTYP=udf
+	    xpand=false
+	    ;;
+
+	-xfs)	# -xfs ... set FSTYP to xfs
+	    FSTYP=xfs
+	    xpand=false
+	    ;;
+
+	-nfs)	# -nfs ... set FSTYP to nfs
+	    FSTYP=nfs
+	    xpand=false
+	    ;;
+
+	-g)	# -g group ... pick from group file
+	    group=true
+	    xpand=false
+	    ;;
+
+	-l)	# line mode for diff, was default before
+	    diff="diff"
+	    xpand=false
+	    ;;
+
+	-xdiff)	# graphical diff mode
+	    xpand=false
+
+	    if [ ! -z "$DISPLAY" ]
+	    then
+		which xdiff >/dev/null 2>&1 && diff=xdiff
+		which gdiff >/dev/null 2>&1 && diff=gdiff
+		which tkdiff >/dev/null 2>&1 && diff=tkdiff
+		which xxdiff >/dev/null 2>&1 && diff=xxdiff
+	    fi
+	    ;;
+
+	-udiff) # show a unified diff, default now, keep for backward compat
+	    xpand=false
+	    diff="$diff -u"
+	    ;;
+
+	-q)	# "quick", no longer used - always quick :-)
+	    xpand=false
+	    ;;
+
+	-n)	# show me, don't do it
+	    showme=true
+	    xpand=false
+	    ;;
+        -r)	# randomize test order
+	    randomize=true
+	    xpand=false
+	    ;;
+
+	-T)	# turn on timestamp output
+	    timestamp=true
+	    xpand=false
+	    ;;
+
+	-v)
+	    verbose=true
+	    xpand=false
+	    ;;
+	-x)	# -x group ... exclude from group file
+	    xgroup=true
+	    xpand=false
+	    ;;
+	'[0-9][0-9][0-9] [0-9][0-9][0-9][0-9]')
+	    echo "No tests?"
+	    status=1
+	    exit $status
+	    ;;
+
+	[0-9]*-[0-9]*)
+	    eval `echo $r | sed -e 's/^/start=/' -e 's/-/ end=/'`
+	    ;;
+
+	[0-9]*-)
+	    eval `echo $r | sed -e 's/^/start=/' -e 's/-//'`
+	    end=`echo [0-9][0-9][0-9] [0-9][0-9][0-9][0-9] | sed -e 's/\[0-9]//g' -e 's/  *$//' -e 's/.* //'`
+	    if [ -z "$end" ]
+	    then
+		echo "No tests in range \"$r\"?"
+		status=1
+		exit $status
+	    fi
+	    ;;
+
+	--large-fs)
+	    export LARGE_SCRATCH_DEV=yes
+	    xpand=false
+	    ;;
+
+	-*)
+	    usage
+	    ;;
+
+	--extra-space=*)
+	    export SCRATCH_DEV_EMPTY_SPACE=${r#*=}
+	    xpand=false
+	    ;;
+
+	*)
+	    start=$r
+	    end=$r
+	    ;;
+
+    esac
+
+    # get rid of leading 0s as can be interpreted as octal
+    start=`echo $start | sed 's/^0*//'`
+    end=`echo $end | sed 's/^0*//'`
+
+    if $xpand
+    then
+	have_test_arg=true
+	$AWK_PROG </dev/null '
+BEGIN	{ for (t='$start'; t<='$end'; t++) printf "%03d\n",t }' \
+	| while read id
+	do
+	    if grep -s "^$id " group >/dev/null
+	    then
+		# in group file ... OK
+		echo $id >>$tmp.list
+	    else
+		if [ -f expunged ] && $expunge && egrep "^$id([ 	]|\$)" expunged >/dev/null
+		then
+		    # expunged ... will be reported, but not run, later
+		    echo $id >>$tmp.list
+		else
+		    # oops
+		    echo "$id - unknown test, ignored"
+		fi
+	    fi
+	done
+    fi
+
+done
+
+if [ -s $tmp.list ]
+then
+    # found some valid test numbers ... this is good
+    :
+else
+    if $have_test_arg
+    then
+	# had test numbers, but none in group file ... do nothing
+	touch $tmp.list
+    else
+	# no test numbers, do everything from group file
+	sed -n -e '/^[0-9][0-9][0-9]*/s/[ 	].*//p' <group >$tmp.list
+    fi
+fi
+
+# should be sort -n, but this did not work for Linux when this
+# was ported from IRIX
+#
+list=`sort $tmp.list`
+rm -f $tmp.list $tmp.tmp $tmp.sed
+
+if $randomize
+then
+    list=`echo $list | awk -f randomize.awk`
+fi
 
+case "$FSTYP" in
+    xfs)
+	 [ "$XFS_LOGPRINT_PROG" = "" ] && _fatal "xfs_logprint not found"
+	 [ "$XFS_REPAIR_PROG" = "" ] && _fatal "xfs_repair not found"
+	 [ "$XFS_CHECK_PROG" = "" ] && _fatal "xfs_check not found"
+	 [ "$XFS_DB_PROG" = "" ] && _fatal "xfs_db not found"
+	 [ "$MKFS_XFS_PROG" = "" ] && _fatal "mkfs_xfs not found" 
+	 ;;
+    udf)
+	 [ "$MKFS_UDF_PROG" = "" ] && _fatal "mkfs_udf/mkudffs not found"
+	 ;;
+    btrfs)
+	 [ "$MKFS_BTRFS_PROG" = "" ] && _fatal "mkfs.btrfs not found"
+	 ;;
+    nfs)
+	 ;;
+esac
 
 # we need common.rc
 if ! . ./common.rc
diff --git a/common b/common
deleted file mode 100644
index 78ac654..0000000
--- a/common
+++ /dev/null
@@ -1,334 +0,0 @@
-##/bin/bash 
-#
-# Copyright (c) 2000-2005 Silicon Graphics, Inc.  All Rights Reserved.
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
-# common procedures for QA scripts
-#
-# $Header: /disk7/depot/linux/pcp/dev/qa/RCS/common,v 2.52 2000/04/05 18:24:51 kenmcd Exp $
-#
-
-_setenvironment()
-{
-    MSGVERB="text:action"
-    export MSGVERB
-}
-
-usage()
-{
-    echo "Usage: $0 [options] [testlist]"'
-
-common options
-    -v			verbose
-
-check options
-    -xfs                test XFS (default)
-    -udf                test UDF
-    -nfs                test NFS
-    -l			line mode diff
-    -xdiff		graphical mode diff
-    -udiff		show unified diff (default)
-    -n			show me, do not run tests
-    -q			quick [deprecated]
-    -T			output timestamps
-    -r			randomize test order
-    --large-fs		optimise scratch device for large filesystems
-
-testlist options
-    -g group[,group...]	include tests from these groups
-    -x group[,group...]	exclude tests from these groups
-    NNN			include test NNN
-    NNN-NNN		include test range (eg. 012-021)
-'
-	    exit 0
-}
-
-here=`pwd`
-rm -f $here/$iam.out
-_setenvironment
-
-check=${check-true}
-
-diff="diff -u"
-verbose=false
-group=false
-xgroup=false
-showme=false
-sortme=false
-expunge=true
-have_test_arg=false
-randomize=false
-rm -f $tmp.list $tmp.tmp $tmp.sed
-
-# Autodetect fs type based on what's on $TEST_DEV
-if [ "$HOSTOS" == "Linux" ]
-then
-    export FSTYP=`blkid -c /dev/null -s TYPE -o value $TEST_DEV`
-else
-    export FSTYP=xfs
-fi
-
-for r
-do
-
-    if $group
-    then
-	# arg after -g
-       group_list=$(sed -n < group \
-                       -e 's/#.*//' \
-                       -e 's/$/ /' \
-                       -e "/^[0-9][0-9][0-9].* $r /"'{ s/ .*//p }')
-	if [ -z "$group_list" ]
-	then
-	    echo "Group \"$r\" is empty or not defined?"
-	    exit 1
-	fi
-	[ ! -s $tmp.list ] && touch $tmp.list
-	for t in $group_list
-	do
-	    if grep -s "^$t\$" $tmp.list >/dev/null
-	    then
-		:
-	    else
-		echo "$t" >>$tmp.list
-	    fi
-	done
-	group=false
-	continue
-
-    elif $xgroup
-    then
-	# arg after -x
-	[ ! -s $tmp.list ] && ls [0-9][0-9][0-9] [0-9][0-9][0-9][0-9] >$tmp.list 2>/dev/null
-	group_list=`sed -n <group -e 's/$/ /' -e "/^[0-9][0-9][0-9].* $r /"'{
-s/ .*//p
-}'`
-	if [ -z "$group_list" ]
-	then
-	    echo "Group \"$r\" is empty or not defined?"
-	    exit 1
-	fi
-	numsed=0
-	rm -f $tmp.sed
-	for t in $group_list
-	do
-	    if [ $numsed -gt 100 ]
-	    then
-		sed -f $tmp.sed <$tmp.list >$tmp.tmp
-		mv $tmp.tmp $tmp.list
-		numsed=0
-		rm -f $tmp.sed
-	    fi
-	    echo "/^$t\$/d" >>$tmp.sed
-	    numsed=`expr $numsed + 1`
-	done
-	sed -f $tmp.sed <$tmp.list >$tmp.tmp
-	mv $tmp.tmp $tmp.list
-	xgroup=false
-	continue
-    fi
-
-    xpand=true
-    case "$r"
-    in
-
-	-\? | -h | --help)	# usage
-	    usage
-	    ;;
-
-	-udf)	# -udf ... set FSTYP to udf
-	    FSTYP=udf
-	    xpand=false
-	    ;;
-
-	-xfs)	# -xfs ... set FSTYP to xfs
-	    FSTYP=xfs
-	    xpand=false
-	    ;;
-
-	-nfs)	# -nfs ... set FSTYP to nfs
-	    FSTYP=nfs
-	    xpand=false
-	    ;;
-
-	-g)	# -g group ... pick from group file
-	    group=true
-	    xpand=false
-	    ;;
-
-	-l)	# line mode for diff, was default before
-	    diff="diff"
-	    xpand=false
-	    ;;
-
-	-xdiff)	# graphical diff mode
-	    xpand=false
-
-	    if [ ! -z "$DISPLAY" ]
-	    then
-		which xdiff >/dev/null 2>&1 && diff=xdiff
-		which gdiff >/dev/null 2>&1 && diff=gdiff
-		which tkdiff >/dev/null 2>&1 && diff=tkdiff
-		which xxdiff >/dev/null 2>&1 && diff=xxdiff
-	    fi
-	    ;;
-
-	-udiff) # show a unified diff, default now, keep for backward compat
-	    xpand=false
-	    diff="$diff -u"
-	    ;;
-
-	-q)	# "quick", no longer used - always quick :-)
-	    xpand=false
-	    ;;
-
-	-n)	# show me, don't do it
-	    showme=true
-	    xpand=false
-	    ;;
-        -r)	# randomize test order
-	    randomize=true
-	    xpand=false
-	    ;;
-
-	-T)	# turn on timestamp output
-	    timestamp=true
-	    xpand=false
-	    ;;
-
-	-v)
-	    verbose=true
-	    xpand=false
-	    ;;
-	-x)	# -x group ... exclude from group file
-	    xgroup=true
-	    xpand=false
-	    ;;
-	'[0-9][0-9][0-9] [0-9][0-9][0-9][0-9]')
-	    echo "No tests?"
-	    status=1
-	    exit $status
-	    ;;
-
-	[0-9]*-[0-9]*)
-	    eval `echo $r | sed -e 's/^/start=/' -e 's/-/ end=/'`
-	    ;;
-
-	[0-9]*-)
-	    eval `echo $r | sed -e 's/^/start=/' -e 's/-//'`
-	    end=`echo [0-9][0-9][0-9] [0-9][0-9][0-9][0-9] | sed -e 's/\[0-9]//g' -e 's/  *$//' -e 's/.* //'`
-	    if [ -z "$end" ]
-	    then
-		echo "No tests in range \"$r\"?"
-		status=1
-		exit $status
-	    fi
-	    ;;
-
-	--large-fs)
-	    export LARGE_SCRATCH_DEV=yes
-	    xpand=false
-	    ;;
-
-	-*)
-	    usage
-	    ;;
-
-	--extra-space=*)
-	    export SCRATCH_DEV_EMPTY_SPACE=${r#*=}
-	    xpand=false
-	    ;;
-
-	*)
-	    start=$r
-	    end=$r
-	    ;;
-
-    esac
-
-    # get rid of leading 0s as can be interpreted as octal
-    start=`echo $start | sed 's/^0*//'`
-    end=`echo $end | sed 's/^0*//'`
-
-    if $xpand
-    then
-	have_test_arg=true
-	$AWK_PROG </dev/null '
-BEGIN	{ for (t='$start'; t<='$end'; t++) printf "%03d\n",t }' \
-	| while read id
-	do
-	    if grep -s "^$id " group >/dev/null
-	    then
-		# in group file ... OK
-		echo $id >>$tmp.list
-	    else
-		if [ -f expunged ] && $expunge && egrep "^$id([ 	]|\$)" expunged >/dev/null
-		then
-		    # expunged ... will be reported, but not run, later
-		    echo $id >>$tmp.list
-		else
-		    # oops
-		    echo "$id - unknown test, ignored"
-		fi
-	    fi
-	done
-    fi
-
-done
-
-if [ -s $tmp.list ]
-then
-    # found some valid test numbers ... this is good
-    :
-else
-    if $have_test_arg
-    then
-	# had test numbers, but none in group file ... do nothing
-	touch $tmp.list
-    else
-	# no test numbers, do everything from group file
-	sed -n -e '/^[0-9][0-9][0-9]*/s/[ 	].*//p' <group >$tmp.list
-    fi
-fi
-
-# should be sort -n, but this did not work for Linux when this
-# was ported from IRIX
-#
-list=`sort $tmp.list`
-rm -f $tmp.list $tmp.tmp $tmp.sed
-
-if $randomize
-then
-    list=`echo $list | awk -f randomize.awk`
-fi
-
-case "$FSTYP" in
-    xfs)
-	 [ "$XFS_LOGPRINT_PROG" = "" ] && _fatal "xfs_logprint not found"
-	 [ "$XFS_REPAIR_PROG" = "" ] && _fatal "xfs_repair not found"
-	 [ "$XFS_CHECK_PROG" = "" ] && _fatal "xfs_check not found"
-	 [ "$XFS_DB_PROG" = "" ] && _fatal "xfs_db not found"
-	 [ "$MKFS_XFS_PROG" = "" ] && _fatal "mkfs_xfs not found" 
-	 ;;
-    udf)
-	 [ "$MKFS_UDF_PROG" = "" ] && _fatal "mkfs_udf/mkudffs not found"
-	 ;;
-    btrfs)
-	 [ "$MKFS_BTRFS_PROG" = "" ] && _fatal "mkfs.btrfs not found"
-	 ;;
-    nfs)
-	 ;;
-esac
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
