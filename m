Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBD4tHP4160414 for <xfs@oss.sgi.com>; Sun, 12 Dec 2010 22:55:17 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CAA6EA3B5B
	for <xfs@oss.sgi.com>; Sun, 12 Dec 2010 20:46:36 -0800 (PST)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	moTJPNaII5JbtmA5 for <xfs@oss.sgi.com>;
	Sun, 12 Dec 2010 20:46:36 -0800 (PST)
Received: from dastard (unverified [121.44.88.148])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	49126858-1927428
	for <xfs@oss.sgi.com>; Mon, 13 Dec 2010 15:16:35 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PS0Iz-00022k-Kl
	for xfs@oss.sgi.com; Mon, 13 Dec 2010 15:46:33 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PS0HV-0004mg-Fv
	for xfs@oss.sgi.com; Mon, 13 Dec 2010 15:45:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 09/12] xfs: convert log grant heads to atomic variables
Date: Mon, 13 Dec 2010 15:44:40 +1100
Message-Id: <1292215483-18224-10-git-send-email-david@fromorbit.com>
In-Reply-To: <1292215483-18224-1-git-send-email-david@fromorbit.com>
References: <1292215483-18224-1-git-send-email-david@fromorbit.com>
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

Convert the log grant heads to atomic64_t types in preparation for
converting the accounting algorithms to atomic operations. his patch
just converts the variables; the algorithmic changes are in a
separate patch for clarity.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c      |    8 ++++----
 fs/xfs/xfs_log_priv.h |   12 ++++++------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 57bd143..cddfc6b 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -47,7 +47,7 @@ STATIC xlog_t *  xlog_alloc_log(xfs_mount_t	*mp,
 				xfs_buftarg_t	*log_target,
 				xfs_daddr_t	blk_offset,
 				int		num_bblks);
-STATIC int	 xlog_space_left(struct log *log, int64_t *head);
+STATIC int	 xlog_space_left(struct log *log, atomic64_t *head);
 STATIC int	 xlog_sync(xlog_t *log, xlog_in_core_t *iclog);
 STATIC void	 xlog_dealloc_log(xlog_t *log);
 
@@ -100,7 +100,7 @@ STATIC int	xlog_iclogs_empty(xlog_t *log);
 static void
 xlog_grant_sub_space(
 	struct log	*log,
-	int64_t		*head,
+	atomic64_t	*head,
 	int		bytes)
 {
 	int		cycle, space;
@@ -119,7 +119,7 @@ xlog_grant_sub_space(
 static void
 xlog_grant_add_space(
 	struct log	*log,
-	int64_t		*head,
+	atomic64_t	*head,
 	int		bytes)
 {
 	int		tmp;
@@ -816,7 +816,7 @@ xlog_assign_tail_lsn(
 STATIC int
 xlog_space_left(
 	struct log	*log,
-	int64_t		*head)
+	atomic64_t	*head)
 {
 	int		free_bytes;
 	int		tail_bytes;
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 100a410..24f510f 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -515,8 +515,8 @@ typedef struct log {
 	spinlock_t		l_grant_lock ____cacheline_aligned_in_smp;
 	struct list_head	l_reserveq;
 	struct list_head	l_writeq;
-	int64_t			l_grant_reserve_head;
-	int64_t			l_grant_write_head;
+	atomic64_t			l_grant_reserve_head;
+	atomic64_t			l_grant_write_head;
 
 	/*
 	 * l_last_sync_lsn and l_tail_lsn are atomics so they can be set and
@@ -594,18 +594,18 @@ xlog_assign_atomic_lsn(atomic64_t *lsn, uint cycle, uint block)
  * will always get consistent component values to work from.
  */
 static inline void
-xlog_crack_grant_head(int64_t *head, int *cycle, int *space)
+xlog_crack_grant_head(atomic64_t *head, int *cycle, int *space)
 {
-	int64_t	val = *head;
+	int64_t	val = atomic64_read(head);
 
 	*cycle = val >> 32;
 	*space = val & 0xffffffff;
 }
 
 static inline void
-xlog_assign_grant_head(int64_t *head, int cycle, int space)
+xlog_assign_grant_head(atomic64_t *head, int cycle, int space)
 {
-	*head = ((int64_t)cycle << 32) | space;
+	atomic64_set(head, ((int64_t)cycle << 32) | space);
 }
 
 /*
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
