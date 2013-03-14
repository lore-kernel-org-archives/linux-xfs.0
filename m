Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cthulhu.engr.sgi.com (cthulhu.engr.sgi.com [150.166.39.100])
	by oss.sgi.com (Postfix) with ESMTP id 28B297F54
	for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 08:06:12 -0500 (CDT)
Received: from polaris-admin.engr.sgi.com (polaris-admin.engr.sgi.com
	[150.166.41.54])
	by cthulhu.engr.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id
	r2ED6Bx7007459 for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 06:06:11 -0700
Date: Thu, 14 Mar 2013 06:06:11 -0700
Subject: [PATCH 06/18] xfstests: Remove hangcheck code
MIME-Version: 1.0
Message-Id: <20130314130611.6F39153DEAF4@polaris-admin.engr.sgi.com>
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
This is an old script from the auto-qa days back at SGI. It no
longer is in use or, AFAIK, ever been used for xfstests. If anyone
needs it, they can pull it back out of git, so lets remove it to
simplify check.
-----------------

Signed-off-by: Phil White <pwhite@sgi.com>
---
 check |   27 +--------------------------
 1 files changed, 1 insertions(+), 26 deletions(-)

diff --git a/check b/check
index bad2e4d..e2c758b 100755
--- a/check
+++ b/check
@@ -77,19 +77,13 @@ testlist options
 
 _wrapup()
 {
-    # for hangcheck ...
-    # remove files that were used by hangcheck
-    #
-    [ -f /tmp/check.pid ] && rm -rf /tmp/check.pid
-    [ -f /tmp/check.sts ] && rm -rf /tmp/check.sts
-
     if $showme
     then
 	:
     elif $needwrap
     then
-	if [ -f check.time -a -f $tmp.time ]
 	then
+	if [ -f check.time -a -f $tmp.time ]
 	    cat check.time $tmp.time \
 	    | $AWK_PROG '
 	{ t[$1] = $2 }
@@ -138,27 +132,11 @@ END	{ if (NR > 0) {
     fi
 
     rm -f /tmp/*.rawout /tmp/*.out /tmp/*.err /tmp/*.time
-    rm -f /tmp/check.pid /tmp/check.sts
     rm -f $tmp.*
 }
 
 trap "_wrapup; exit \$status" 0 1 2 3 15
 
-# for hangcheck ...
-# Save pid of check in a well known place, so that hangcheck can be sure it
-# has the right pid (getting the pid from ps output is not reliable enough).
-#
-rm -rf /tmp/check.pid
-echo $$ >/tmp/check.pid
-
-# for hangcheck ...
-# Save the status of check in a well known place, so that hangcheck can be
-# sure to know where check is up to (getting test number from ps output is
-# not reliable enough since the trace stuff has been introduced).
-#
-rm -rf /tmp/check.sts
-echo "preamble" >/tmp/check.sts
-
 # don't leave old full output behind on a clean run
 rm -f check.full
 
@@ -238,9 +216,6 @@ do
 	fi
 	rm -f core $seq.notrun
 
-	# for hangcheck ...
-	echo "$seq" >/tmp/check.sts
-
 	start=`_wallclock`
 	$timestamp && echo -n "	["`date "+%T"`"]"
 	[ ! -x $seq ] && chmod u+x $seq # ensure we can run it
-- 
1.5.3.8

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
