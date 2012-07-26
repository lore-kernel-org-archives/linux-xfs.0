Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6Q9SXjp006835 for <xfs@oss.sgi.com>; Thu, 26 Jul 2012 04:28:33 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	FQplAFIWRax7dsdb for <xfs@oss.sgi.com>;
	Thu, 26 Jul 2012 02:28:31 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SuKMw-0001Ak-FZ
	for xfs@oss.sgi.com; Thu, 26 Jul 2012 19:28:30 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1SuKMh-0005VW-4r
	for xfs@oss.sgi.com; Thu, 26 Jul 2012 19:28:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 08/18] xfstests: remove test expunge file support
Date: Thu, 26 Jul 2012 19:28:02 +1000
Message-Id: <1343294892-20991-9-git-send-email-david@fromorbit.com>
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

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 check |   18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/check b/check
index 2012f17..a56f6ed 100755
--- a/check
+++ b/check
@@ -30,7 +30,6 @@ notrun=""
 interrupt=true
 diff="diff -u"
 showme=false
-expunge=true
 have_test_arg=false
 randomize=false
 here=`pwd`
@@ -100,10 +99,6 @@ BEGIN	{ for (t='$start'; t<='$end'; t++) printf "%03d\n",t }' \
 		if grep -s "^$id " group >/dev/null ; then
 			# in group file ... OK
 			echo $id >>$tmp.list
-		elif [ -f expunged ] && $expunge && \
-				egrep "^$id([ 	]|\$)" expunged >/dev/null ; then
-			# expunged ... will be reported, but not run, later
-			echo $id >>$tmp.list
 		else
 			# oops
 			echo "$id - unknown test, ignored"
@@ -287,13 +282,6 @@ END	{ if (NR > 0) {
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
@@ -387,15 +375,9 @@ do
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
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
