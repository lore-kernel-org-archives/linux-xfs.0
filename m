Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6Q9SRqo006815 for <xfs@oss.sgi.com>; Thu, 26 Jul 2012 04:28:27 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	k7oZNS5oPy40rkTo for <xfs@oss.sgi.com>;
	Thu, 26 Jul 2012 02:28:26 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SuKMr-0001Az-7z
	for xfs@oss.sgi.com; Thu, 26 Jul 2012 19:28:25 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1SuKMh-0005VR-49
	for xfs@oss.sgi.com; Thu, 26 Jul 2012 19:28:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 07/18] xfstests: kill hangcheck stuff from check
Date: Thu, 26 Jul 2012 19:28:01 +1000
Message-Id: <1343294892-20991-8-git-send-email-david@fromorbit.com>
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

This is an old script from the auto-qa days back at SGI. It no
longer is in use or, AFAIK, ever been used for xfstests. If anyone
needs it, they can pull it back out of git, so lets remove it to
simplify check.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 check |   25 -------------------------
 1 file changed, 25 deletions(-)

diff --git a/check b/check
index df962ae..2012f17 100755
--- a/check
+++ b/check
@@ -269,12 +269,6 @@ fi
 
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
@@ -330,27 +324,11 @@ END	{ if (NR > 0) {
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
 
@@ -430,9 +408,6 @@ do
 	fi
 	rm -f core $seq.notrun
 
-	# for hangcheck ...
-	echo "$seq" >/tmp/check.sts
-
 	start=`_wallclock`
 	$timestamp && echo -n "	["`date "+%T"`"]"
 	[ ! -x $seq ] && chmod u+x $seq # ensure we can run it
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
