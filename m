Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA20bI6s065012 for <xfs@oss.sgi.com>; Thu, 1 Nov 2012 19:37:18 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	j6vN1BQmnBMnbO6D for <xfs@oss.sgi.com>;
	Thu, 01 Nov 2012 17:39:09 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1TU5Hl-0004WX-Ek
	for xfs@oss.sgi.com; Fri, 02 Nov 2012 11:38:57 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1TU5Hl-0000nd-B7
	for xfs@oss.sgi.com; Fri, 02 Nov 2012 11:38:57 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 6/6] xfs: fix reading of wrapped log data
Date: Fri,  2 Nov 2012 11:38:44 +1100
Message-Id: <1351816724-3000-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1351816724-3000-1-git-send-email-david@fromorbit.com>
References: <1351816724-3000-1-git-send-email-david@fromorbit.com>
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

Commit 4439647 ("xfs: reset buffer pointers before freeing them") in
3.0-rc1 introduced a regression when recovering log buffers that
wrapped around the end of log. The second part of the log buffer at
the start of the physical log was being read into the header buffer
rather than the data buffer, and hence recovery was seeing garbage
in the data buffer when it got to the region of the log buffer that
was incorrectly read.

Cc: <stable@vger.kernel.org> # 3.0.x, 3.2.x, 3.4.x 3.6.x
Reported-by: Torsten Kaiser <just.for.lkml@googlemail.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log_recover.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 651c988..3e06333 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3542,7 +3542,7 @@ xlog_do_recovery_pass(
 				 *   - order is important.
 				 */
 				error = xlog_bread_offset(log, 0,
-						bblks - split_bblks, hbp,
+						bblks - split_bblks, dbp,
 						offset + BBTOB(split_bblks));
 				if (error)
 					goto bread_err2;
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
