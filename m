Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6Q9SchC006871 for <xfs@oss.sgi.com>; Thu, 26 Jul 2012 04:28:38 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	btPI8eHo7Vc5eTbJ for <xfs@oss.sgi.com>;
	Thu, 26 Jul 2012 02:28:36 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SuKMr-0001B0-8d
	for xfs@oss.sgi.com; Thu, 26 Jul 2012 19:28:25 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1SuKMh-0005Va-5g
	for xfs@oss.sgi.com; Thu, 26 Jul 2012 19:28:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 09/18] xfstests: remove undocumented TESTS_REMAINING_LOG
Date: Thu, 26 Jul 2012 19:28:03 +1000
Message-Id: <1343294892-20991-10-git-send-email-david@fromorbit.com>
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

Undocumented and unused, AFAICT. Kill it.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 check |    7 -------
 1 file changed, 7 deletions(-)

diff --git a/check b/check
index a56f6ed..d6dccb5 100755
--- a/check
+++ b/check
@@ -359,17 +359,10 @@ fi
 seq="check"
 _check_test_fs
 
-[ -n "$TESTS_REMAINING_LOG" ] && echo $list > $TESTS_REMAINING_LOG
-
 for seq in $list
 do
     err=false
     echo -n "$seq"
-    if [ -n "$TESTS_REMAINING_LOG" ] ; then
-        sed -e "s/$seq//" -e 's/  / /' -e 's/^ *//' $TESTS_REMAINING_LOG > $TESTS_REMAINING_LOG.tmp
-        mv $TESTS_REMAINING_LOG.tmp $TESTS_REMAINING_LOG
-        sync
-    fi
 
     if $showme
     then
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
