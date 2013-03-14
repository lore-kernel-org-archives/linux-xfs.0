Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cthulhu.engr.sgi.com (cthulhu.engr.sgi.com [150.166.39.100])
	by oss.sgi.com (Postfix) with ESMTP id 2D8637F55
	for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 08:06:12 -0500 (CDT)
Received: from polaris-admin.engr.sgi.com (polaris-admin.engr.sgi.com
	[150.166.41.54])
	by cthulhu.engr.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id
	r2ED6Bx7007460 for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 06:06:11 -0700
Date: Thu, 14 Mar 2013 06:06:11 -0700
Subject: [PATCH 07/18] xfstests: Remove expunge capability for simplicity
MIME-Version: 1.0
Message-Id: <20130314130611.7A12553DEAEF@polaris-admin.engr.sgi.com>
From: pwhite@sgi.com (Philip White)
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Phil White <pwhite@sgi.com>


This is a rebasing & resubmit of a dchinner patch.  His comments on the
original:
-----------------
Check supports an expunge file for tests - a way of marking tests
not to run even if you specify it to run. Use is like this:

$ echo 002 > expunged
test-2:~/src/xfstests-dev$ sudo ./check 001-003
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 test-2 3.5.0-rc1-dgc+
MKFS_OPTIONS  -- -f -bsize=4096 /dev/vdb
MOUNT_OPTIONS -- /dev/vdb /mnt/scratch

001 4s ... 4s
002 - expunged
003 0s ... 0s
Ran: 001 002 003
Not run:1
Passed all 2 tests

This is arguably useful(*), but gets in the way of splitting up the
tests into multiple directories. Remove it for now, but such
functionality should be considered for re-implementation at a later
date.

(*) e.g. having a different "expunged" file for each distro release
you have to test to avoid the tests known to fail due to fixes or
features that will never be back ported to older releases....
-----------------

Signed-off-by: Phil White <pwhite@sgi.com>
---
 check  |   13 -------------
 common |    5 -----
 2 files changed, 0 insertions(+), 18 deletions(-)

diff --git a/check b/check
index e2c758b..06189c8 100755
--- a/check
+++ b/check
@@ -95,13 +95,6 @@ END	{ if (NR > 0) {
 	    mv $tmp.out check.time
 	fi
 
-	if [ -f $tmp.expunged ]
-	then
-	    notrun=`wc -l <$tmp.expunged | sed -e 's/  *//g'`
-	    n_try=`expr $n_try - $notrun`
-	    list=`echo "$list" | sed -f $tmp.expunged`
-	fi
-
 	echo "" >>check.log
 	date >>check.log
 	echo $list | fmt | sed -e 's/^/    /' >>check.log
@@ -195,15 +188,9 @@ do
     then
 	echo
 	continue
-    elif [ -f expunged ] && $expunge && egrep "^$seq([ 	]|\$)" expunged >/dev/null
-    then
-	echo " - expunged"
-	rm -f $seq.out.bad
-	echo "/^$seq\$/d" >>$tmp.expunged
     elif [ ! -f $seq ]
     then
 	echo " - no such test?"
-	echo "/^$seq\$/d" >>$tmp.expunged
     else
 	# really going to try and run this one
 	#
diff --git a/common b/common
index 2553fe9..821ea59 100644
--- a/common
+++ b/common
@@ -49,10 +49,6 @@ BEGIN  { for (t='$start'; t<='$end'; t++) printf "%03d\n",t }' \
 		if grep -s "^$id " group >/dev/null ; then
 			# in group file ... OK
 			echo $id >>$tmp.list
-		elif [ -f expunged ] && $expunge && \
-				egrep "^$id([   ]|\$)" expunged >/dev/null; then
-			# expunged ... will be reported, but not run, later
-			echo $id >>$tmp.list
 		else
 			# oops
 			echo "$id - unknown test, ignored"
@@ -81,7 +77,6 @@ group=false
 xgroup=false
 showme=false
 sortme=false
-expunge=true
 have_test_arg=false
 randomize=false
 timestamp=${TIMESTAMP:=false}
-- 
1.5.3.8

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
