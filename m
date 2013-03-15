Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C7A8E804B
	for <xfs@oss.sgi.com>; Fri, 15 Mar 2013 07:29:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 52C19AC001
	for <xfs@oss.sgi.com>; Fri, 15 Mar 2013 05:29:05 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	vD2V5zt7JVHR92Bp for <xfs@oss.sgi.com>;
	Fri, 15 Mar 2013 05:29:03 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UGTkT-0001aT-4N
	for xfs@oss.sgi.com; Fri, 15 Mar 2013 23:28:37 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UGTkS-0005sI-SL
	for xfs@oss.sgi.com; Fri, 15 Mar 2013 23:28:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 25/25] xfstests: use _notrun for tape checks
Date: Fri, 15 Mar 2013 23:28:09 +1100
Message-Id: <1363350489-22257-26-git-send-email-david@fromorbit.com>
In-Reply-To: <1363350489-22257-1-git-send-email-david@fromorbit.com>
References: <1363350489-22257-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

_require_tape is failing tests when no TAPE_DEV is specified. It
should be using _notrun for these cases rather than trying to open
code the $seqres.notrun magic file manipulations.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 common/dump |   13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/common/dump b/common/dump
index 3df6191..5d4d2ae 100644
--- a/common/dump
+++ b/common/dump
@@ -139,9 +139,7 @@ _check_onl()
 	echo "ERROR: mt -f $dumptape failed"
 	cat $tmp.status
 
-	echo "mt -f $dumptape failed" >$seq.notrun
-	status=$NOTRUNSTS
-	exit
+	_notrun "mt -f $dumptape failed"
     fi
 
 
@@ -151,9 +149,7 @@ _check_onl()
 	echo "ERROR: $dumptape is not online"
 	cat $tmp.status
 
-	echo "dumptape, $dumptape, is not online" >$seq.notrun
-	status=$NOTRUNSTS
-	exit
+	_notrun "dumptape, $dumptape, is not online"
     fi
 }
 
@@ -229,10 +225,7 @@ _require_tape()
     dumptape=$1
 
     if [ -z "$dumptape" -o "@" == "$dumptape" ]; then
-        echo "This test requires a dump tape - none was specified"
-	echo "No dump tape specified" >$seqres.notrun
-	status=$NOTRUNSTS
-	exit
+	_notrun "No dump tape specified"
     fi
 
     _check_onl
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
