Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C89097F54
	for <xfs@oss.sgi.com>; Sat, 26 Jan 2013 16:40:39 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5AD0EAC003
	for <xfs@oss.sgi.com>; Sat, 26 Jan 2013 14:40:39 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id sRiefl2Qbrw7K6Un for <xfs@oss.sgi.com>;
	Sat, 26 Jan 2013 14:40:34 -0800 (PST)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 7/8] xfs_fsr: fix attribute no_change_count logic
Date: Sat, 26 Jan 2013 16:40:31 -0600
Message-Id: <1359240032-11576-8-git-send-email-sandeen@redhat.com>
In-Reply-To: <1359240032-11576-1-git-send-email-sandeen@redhat.com>
References: <1359240032-11576-1-git-send-email-sandeen@redhat.com>
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
Cc: Eric Sandeen <sandeen@redhat.com>

As it stands today, if no_change_count++ isn't > 10,
we will reset it to 0.  There's no way to get above 1
(let alone 10) so this isn't working as intended.

If we see progress (last_forkoff != tbstat.bs_forkoff)
*then* we sould reset the no_change_count counter to 0.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fsr/xfs_fsr.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index b5aa3db..5eaabb5 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -1099,8 +1099,8 @@ fsr_setup_attr_fork(
 		if (last_forkoff == tbstat.bs_forkoff) {
 			if (no_change_cnt++ > 10)
 				break;
-		}
-		no_change_cnt = 0;
+		} else /* progress! */
+			no_change_cnt = 0;
 		last_forkoff = tbstat.bs_forkoff;
 
 		/* work out which way to grow the fork */
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
