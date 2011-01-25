Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0P3x6Kn176154 for <xfs@oss.sgi.com>; Mon, 24 Jan 2011 21:59:06 -0600
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 10B1228D51F
	for <xfs@oss.sgi.com>; Mon, 24 Jan 2011 20:01:28 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	VzbwwbTL0l9HkeU7 for <xfs@oss.sgi.com>;
	Mon, 24 Jan 2011 20:01:28 -0800 (PST)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1Pha5j-0003Tr-9l
	for xfs@oss.sgi.com; Tue, 25 Jan 2011 15:01:15 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1Pha3Y-0005Nh-SM
	for xfs@oss.sgi.com; Tue, 25 Jan 2011 14:59:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/4] xfstests: make 016 work with delaylog
Date: Tue, 25 Jan 2011 14:58:56 +1100
Message-Id: <1295927937-20634-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1295927937-20634-1-git-send-email-david@fromorbit.com>
References: <1295927937-20634-1-git-send-email-david@fromorbit.com>
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

Test 016 fails with delaylog because it measures log traffic to disk
and delaylog writes almost nothing to the log for the given test. TO
make it work, add sync calls to the work loop to cause the log to be
flushed reliably for both delaylog and nodelaylog and hence contain
the same nuumber of log records.

As a result, the log space consumed by the test is not changed by
the delaylog option and the test passes. The test is not
significantly slowed down by the addition of the sync calls (takes
15s to run on a single SATA drive).

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 016 |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/016 b/016
index 980eb0b..32d8b19 100755
--- a/016
+++ b/016
@@ -101,7 +101,9 @@ _log_traffic()
     while [ $count -ge 0 ]
     do
         touch $out
+	sync
         rm $out
+	sync
         let "count = count - 1"
     done
 
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
