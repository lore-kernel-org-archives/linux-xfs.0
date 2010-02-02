Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1329SJo204045 for <xfs@oss.sgi.com>; Tue, 2 Feb 2010 20:09:28 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BEB811371D8C
	for <xfs@oss.sgi.com>; Tue,  2 Feb 2010 18:10:35 -0800 (PST)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	ONJ5AcT2DhvfFPtz for <xfs@oss.sgi.com>;
	Tue, 02 Feb 2010 18:10:35 -0800 (PST)
Received: from discord (unverified [121.44.103.80])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	12207801-1927428
	for <xfs@oss.sgi.com>; Wed, 03 Feb 2010 12:40:33 +1030 (CDT)
Received: from disturbed ([192.168.1.9]) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NcS7h-0003q0-LG
	for xfs@oss.sgi.com; Wed, 03 Feb 2010 10:25:33 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NcS7g-0006jB-Iq
	for xfs@oss.sgi.com; Wed, 03 Feb 2010 10:25:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 10/10] xfs: kill xfs_bawrite
Date: Wed,  3 Feb 2010 10:25:04 +1100
Message-Id: <1265153104-29680-11-git-send-email-david@fromorbit.com>
In-Reply-To: <1265153104-29680-1-git-send-email-david@fromorbit.com>
References: <1265153104-29680-1-git-send-email-david@fromorbit.com>
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

There are no more users of this function left in the XFS code
now that we've switched everything to delayed write flushing.
Remove it.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/linux-2.6/xfs_buf.c |   19 -------------------
 fs/xfs/linux-2.6/xfs_buf.h |    1 -
 2 files changed, 0 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index 4556a4c..d50df3a 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -1078,25 +1078,6 @@ xfs_bwrite(
 	return error;
 }
 
-int
-xfs_bawrite(
-	void			*mp,
-	struct xfs_buf		*bp)
-{
-	trace_xfs_buf_bawrite(bp, _RET_IP_);
-
-	ASSERT(bp->b_bn != XFS_BUF_DADDR_NULL);
-
-	xfs_buf_delwri_dequeue(bp);
-
-	bp->b_flags &= ~(XBF_READ | XBF_DELWRI | XBF_READ_AHEAD);
-	bp->b_flags |= (XBF_WRITE | XBF_ASYNC | _XBF_RUN_QUEUES);
-
-	bp->b_mount = mp;
-	bp->b_strat = xfs_bdstrat_cb;
-	return xfs_bdstrat_cb(bp);
-}
-
 void
 xfs_bdwrite(
 	void			*mp,
diff --git a/fs/xfs/linux-2.6/xfs_buf.h b/fs/xfs/linux-2.6/xfs_buf.h
index be45e8c..386e736 100644
--- a/fs/xfs/linux-2.6/xfs_buf.h
+++ b/fs/xfs/linux-2.6/xfs_buf.h
@@ -233,7 +233,6 @@ extern void xfs_buf_unlock(xfs_buf_t *);
 
 /* Buffer Read and Write Routines */
 extern int xfs_bwrite(struct xfs_mount *mp, struct xfs_buf *bp);
-extern int xfs_bawrite(void *mp, xfs_buf_t *bp);
 extern void xfs_bdwrite(void *mp, xfs_buf_t *bp);
 
 extern void xfsbdstrat(struct xfs_mount *, struct xfs_buf *);
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
