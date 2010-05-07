Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o475d5dd148834 for <xfs@oss.sgi.com>; Fri, 7 May 2010 00:39:05 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 032AD9638FB
	for <xfs@oss.sgi.com>; Thu,  6 May 2010 22:41:15 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	fcJANYZrLqe88Tc8 for <xfs@oss.sgi.com>;
	Thu, 06 May 2010 22:41:15 -0700 (PDT)
Received: from dastard (unverified [121.45.169.108])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	23442150-1927428
	for <xfs@oss.sgi.com>; Fri, 07 May 2010 15:11:13 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1OAGJ4-0006rJ-EI
	for xfs@oss.sgi.com; Fri, 07 May 2010 15:41:02 +1000
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1OAGJ2-00066U-VI
	for xfs@oss.sgi.com; Fri, 07 May 2010 15:41:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 06/12] xfs: make the log ticket ID available outside the log
	infrastructure
Date: Fri,  7 May 2010 15:40:54 +1000
Message-Id: <1273210860-23414-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1273210860-23414-1-git-send-email-david@fromorbit.com>
References: <1273210860-23414-1-git-send-email-david@fromorbit.com>
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

The ticket ID is needed to uniquely identify transactions when doing busy
extent matching. Delayed logging changes the lifecycle of busy extents with
respect to the transaction structure lifecycle. Hence we can no longer use
the transaction structure as a means of determining the owner of the busy
extent as it may be freed and reused while the busy extent is still active.

This commit provides the infrastructure to access the xlog_tid_t held in the
ticket from a transaction handle. This avoids the need for callers to peek
into the transaction and log structures to find this out.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c      |    7 +++++++
 fs/xfs/xfs_log.h      |    7 ++++++-
 fs/xfs/xfs_log_priv.h |    2 --
 3 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 1efb303..19d0c5f 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -3312,6 +3312,13 @@ xfs_log_ticket_get(
 	return ticket;
 }
 
+xlog_tid_t
+xfs_log_get_trans_ident(
+	struct xfs_trans	*tp)
+{
+	return tp->t_ticket->t_tid;
+}
+
 /*
  * Allocate and initialise a new log ticket.
  */
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index 229d1f3..38af110 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -18,8 +18,10 @@
 #ifndef	__XFS_LOG_H__
 #define __XFS_LOG_H__
 
-/* get lsn fields */
+/* transaction ID type */
+typedef __uint32_t xlog_tid_t;
 
+/* get lsn fields */
 #define CYCLE_LSN(lsn) ((uint)((lsn)>>32))
 #define BLOCK_LSN(lsn) ((uint)(lsn))
 
@@ -134,6 +136,7 @@ struct xlog_in_core;
 struct xlog_ticket;
 struct xfs_log_item;
 struct xfs_item_ops;
+struct xfs_trans;
 
 void	xfs_log_item_init(struct xfs_mount	*mp,
 			struct xfs_log_item	*item,
@@ -190,6 +193,8 @@ void	  xlog_iodone(struct xfs_buf *);
 struct xlog_ticket * xfs_log_ticket_get(struct xlog_ticket *ticket);
 void	  xfs_log_ticket_put(struct xlog_ticket *ticket);
 
+xlog_tid_t xfs_log_get_trans_ident(struct xfs_trans *tp);
+
 #endif
 
 
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 9cf6951..ac97bdd 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -152,8 +152,6 @@ static inline uint xlog_get_client_id(__be32 i)
 #define	XLOG_RECOVERY_NEEDED	0x4	/* log was recovered */
 #define XLOG_IO_ERROR		0x8	/* log hit an I/O error, and being
 					   shutdown */
-typedef __uint32_t xlog_tid_t;
-
 
 #ifdef __KERNEL__
 /*
-- 
1.5.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
