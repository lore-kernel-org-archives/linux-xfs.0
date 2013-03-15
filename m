Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5ED918000
	for <xfs@oss.sgi.com>; Fri, 15 Mar 2013 07:28:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E1C2BAC001
	for <xfs@oss.sgi.com>; Fri, 15 Mar 2013 05:28:43 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	W69DwrxjFTCCOAod for <xfs@oss.sgi.com>;
	Fri, 15 Mar 2013 05:28:42 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UGTkS-0001Zi-70
	for xfs@oss.sgi.com; Fri, 15 Mar 2013 23:28:36 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UGTkI-0005qw-3C
	for xfs@oss.sgi.com; Fri, 15 Mar 2013 23:28:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 09/25] xfstests: remove undocumented TESTS_REMAINING_LOG
Date: Fri, 15 Mar 2013 23:27:53 +1100
Message-Id: <1363350489-22257-10-git-send-email-david@fromorbit.com>
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

Undocumented and unused, AFAICT. Kill it.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 check |    7 -------
 1 file changed, 7 deletions(-)

diff --git a/check b/check
index 8a998c4..b93316a 100755
--- a/check
+++ b/check
@@ -365,17 +365,10 @@ fi
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
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
