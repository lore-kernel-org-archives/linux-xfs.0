Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 513777CA2
	for <xfs@oss.sgi.com>; Fri, 15 Apr 2016 11:08:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 22E948F8035
	for <xfs@oss.sgi.com>; Fri, 15 Apr 2016 09:08:42 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id b8gbm7Ns2BxzgLze (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 15 Apr 2016 09:08:41 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 33D2AD2ED6
	for <xfs@oss.sgi.com>; Fri, 15 Apr 2016 16:08:41 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-148.bos.redhat.com [10.18.41.148])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u3FG8eiO025126
	for <xfs@oss.sgi.com>; Fri, 15 Apr 2016 12:08:41 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs: buffer ->bi_end_io function requires irq-safe lock
Date: Fri, 15 Apr 2016 12:08:39 -0400
Message-Id: <1460736519-39428-1-git-send-email-bfoster@redhat.com>
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

Reports have surfaced of a lockdep splat complaining about an irq-safe
-> irq-unsafe locking order in the xfs_buf_bio_end_io() bio completion
handler. This only occurs when I/O errors are present because bp->b_lock
is only acquired in this context to protect setting an error on the
buffer. The problem is that this lock can be acquired with the
(request_queue) q->queue_lock held. See scsi_end_request() or
ata_qc_schedule_eh(), for example.

Replace bp->b_lock with a new irq-safe lock for use in bio completion.
This avoids the bad lock ordering and should be otherwise low impact as
the lock is only acquired on I/O error.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

Hi all,

I'm not totally sure this is a real issue, but the fix seemed simple
enough...

Brian

 fs/xfs/xfs_buf.c | 10 ++++++----
 fs/xfs/xfs_buf.h |  1 +
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 9a2191b..aa0ce4a 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -174,6 +174,7 @@ _xfs_buf_alloc(
 	RB_CLEAR_NODE(&bp->b_rbnode);
 	sema_init(&bp->b_sema, 0); /* held, no waiters */
 	spin_lock_init(&bp->b_lock);
+	spin_lock_init(&bp->b_error_lock);
 	XB_SET_OWNER(bp);
 	bp->b_target = target;
 	bp->b_flags = flags;
@@ -1100,21 +1101,22 @@ xfs_bwrite(
 	return error;
 }
 
-STATIC void
+static void
 xfs_buf_bio_end_io(
 	struct bio		*bio)
 {
-	xfs_buf_t		*bp = (xfs_buf_t *)bio->bi_private;
+	struct xfs_buf		*bp = (struct xfs_buf *)bio->bi_private;
+	unsigned long		flags;
 
 	/*
 	 * don't overwrite existing errors - otherwise we can lose errors on
 	 * buffers that require multiple bios to complete.
 	 */
 	if (bio->bi_error) {
-		spin_lock(&bp->b_lock);
+		spin_lock_irqsave(&bp->b_error_lock, flags);
 		if (!bp->b_io_error)
 			bp->b_io_error = bio->bi_error;
-		spin_unlock(&bp->b_lock);
+		spin_unlock_irqrestore(&bp->b_error_lock, flags);
 	}
 
 	if (!bp->b_error && xfs_buf_is_vmapped(bp) && (bp->b_flags & XBF_READ))
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 4eb89bd..c84529c 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -161,6 +161,7 @@ typedef struct xfs_buf {
 	spinlock_t		b_lock;		/* internal state lock */
 	unsigned int		b_state;	/* internal state flags */
 	int			b_io_error;	/* internal IO error state */
+	spinlock_t		b_error_lock;	/* irq-safe IO error lock */
 	wait_queue_head_t	b_waiters;	/* unpin waiters */
 	struct list_head	b_list;
 	struct xfs_perag	*b_pag;		/* contains rbtree root */
-- 
2.4.11

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
