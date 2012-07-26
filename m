Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6Q8ZBl3000674 for <xfs@oss.sgi.com>; Thu, 26 Jul 2012 03:35:11 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	RK5usRvRQzxJ2TsQ for <xfs@oss.sgi.com>;
	Thu, 26 Jul 2012 01:35:10 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SuJXI-00012Y-M6
	for xfs@oss.sgi.com; Thu, 26 Jul 2012 18:35:08 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1SuJXI-0003sk-IF
	for xfs@oss.sgi.com; Thu, 26 Jul 2012 18:35:08 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/4] xfstests: test 110 sometimes fails to unmount scratch dev
Date: Thu, 26 Jul 2012 18:35:03 +1000
Message-Id: <1343291706-14882-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1343291706-14882-1-git-send-email-david@fromorbit.com>
References: <1343291706-14882-1-git-send-email-david@fromorbit.com>
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

It runs a bunch of rm processes in the background, then immediately
calls _check_scratch_fs without waiting for them to complete, hence
the unmount can fail with a busy filesystem error.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 110 |    1 +
 1 file changed, 1 insertion(+)

diff --git a/110 b/110
index aad5835..c58e6c9 100755
--- a/110
+++ b/110
@@ -69,6 +69,7 @@ do
     let I=$I+1
     [ $[$I % 1000] -eq 0 ] && echo "Created $I/$E"
 done
+wait
 
 sync
 
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
