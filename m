Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA88srKY089523 for <xfs@oss.sgi.com>; Mon, 8 Nov 2010 02:54:53 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E582A1398EE1
	for <xfs@oss.sgi.com>; Mon,  8 Nov 2010 00:56:18 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	PHR4SZtcVdjTO0QU for <xfs@oss.sgi.com>;
	Mon, 08 Nov 2010 00:56:18 -0800 (PST)
Received: from dastard (unverified [121.44.100.105])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	45901293-1927428
	for <xfs@oss.sgi.com>; Mon, 08 Nov 2010 19:26:17 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1PFNWI-0001CT-FT
	for xfs@oss.sgi.com; Mon, 08 Nov 2010 19:56:06 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PFNVa-0004nL-KW
	for xfs@oss.sgi.com; Mon, 08 Nov 2010 19:55:22 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 02/16] xfs: move delayed write buffer trace
Date: Mon,  8 Nov 2010 19:55:05 +1100
Message-Id: <1289206519-18377-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1289206519-18377-1-git-send-email-david@fromorbit.com>
References: <1289206519-18377-1-git-send-email-david@fromorbit.com>
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

The delayed write buffer split trace currently issues a trace for
every buffer it scans. These buffers are not necessarily queued for
delayed write. Indeed, when buffers are pinned, there can be
thousands of traces of buffers that aren't actually queued for
delayed write and the ones that are are lost in the noise. Move the
trace point to record only buffers that are split out for IO to be
issued on.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_buf.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index 63fd2c0..aa1d353 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -1781,7 +1781,6 @@ xfs_buf_delwri_split(
 	INIT_LIST_HEAD(list);
 	spin_lock(dwlk);
 	list_for_each_entry_safe(bp, n, dwq, b_list) {
-		trace_xfs_buf_delwri_split(bp, _RET_IP_);
 		ASSERT(bp->b_flags & XBF_DELWRI);
 
 		if (!XFS_BUF_ISPINNED(bp) && !xfs_buf_cond_lock(bp)) {
@@ -1795,6 +1794,7 @@ xfs_buf_delwri_split(
 					 _XBF_RUN_QUEUES);
 			bp->b_flags |= XBF_WRITE;
 			list_move_tail(&bp->b_list, list);
+			trace_xfs_buf_delwri_split(bp, _RET_IP_);
 		} else
 			skipped++;
 	}
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
