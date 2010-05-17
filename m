Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4HNMeZn014519 for <xfs@oss.sgi.com>; Mon, 17 May 2010 18:22:40 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B765E9C4D7F
	for <xfs@oss.sgi.com>; Mon, 17 May 2010 16:25:55 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	nZ1f6fWg3JifSLZC for <xfs@oss.sgi.com>;
	Mon, 17 May 2010 16:25:55 -0700 (PDT)
Received: from dastard (unverified [121.44.136.97])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	12987993-1927428
	for <xfs@oss.sgi.com>; Tue, 18 May 2010 08:54:55 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1OE9fw-00059p-56
	for xfs@oss.sgi.com; Tue, 18 May 2010 09:24:44 +1000
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1OE9fr-0000Ri-8e
	for xfs@oss.sgi.com; Tue, 18 May 2010 09:24:39 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 06/12] xfs: make the log ticket ID available outside the log
	infrastructure
Date: Tue, 18 May 2010 09:24:22 +1000
Message-Id: <1274138668-1662-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1274138668-1662-1-git-send-email-david@fromorbit.com>
References: <1274138668-1662-1-git-send-email-david@fromorbit.com>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c      |    7 +++++++
 fs/xfs/xfs_log.h      |    4 +++-
 fs/xfs/xfs_log_priv.h |    2 --
 fs/xfs/xfs_types.h    |    2 ++
 4 files changed, 12 insertions(+), 3 deletions(-)

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
index 229d1f3..05f205a 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -19,7 +19,6 @@
 #define __XFS_LOG_H__
 
 /* get lsn fields */
-
 #define CYCLE_LSN(lsn) ((uint)((lsn)>>32))
 #define BLOCK_LSN(lsn) ((uint)(lsn))
 
@@ -134,6 +133,7 @@ struct xlog_in_core;
 struct xlog_ticket;
 struct xfs_log_item;
 struct xfs_item_ops;
+struct xfs_trans;
 
 void	xfs_log_item_init(struct xfs_mount	*mp,
 			struct xfs_log_item	*item,
@@ -190,6 +190,8 @@ void	  xlog_iodone(struct xfs_buf *);
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
diff --git a/fs/xfs/xfs_types.h b/fs/xfs/xfs_types.h
index b099045..3207752 100644
--- a/fs/xfs/xfs_types.h
+++ b/fs/xfs/xfs_types.h
@@ -75,6 +75,8 @@ typedef	__uint32_t	xfs_dahash_t;	/* dir/attr hash value */
 
 typedef __uint16_t	xfs_prid_t;	/* prid_t truncated to 16bits in XFS */
 
+typedef __uint32_t	xlog_tid_t;	/* transaction ID type */
+
 /*
  * These types are 64 bits on disk but are either 32 or 64 bits in memory.
  * Disk based types:
-- 
1.5.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
