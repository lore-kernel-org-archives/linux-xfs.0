Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1K2ma34042611 for <xfs@oss.sgi.com>; Sun, 19 Feb 2012 20:48:36 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	QGuLTaScugX9VvKa (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 19 Feb 2012 18:31:53 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RzJ2f-0005fz-96
	for xfs@oss.sgi.com; Mon, 20 Feb 2012 02:31:53 +0000
Message-Id: <20120220023153.234034678@bombadil.infradead.org>
Date: Sun, 19 Feb 2012 21:31:26 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 07/12] xfs: add xlog_grant_head_init
References: <20120220023119.435889631@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-add-xlog_grant_head_init
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

Reviewed-by: Ben Myers <bpm@sgi.com>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_log.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

Index: xfs/fs/xfs/xfs_log.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log.c	2011-12-11 21:24:39.502740565 +0100
+++ xfs/fs/xfs/xfs_log.c	2011-12-11 21:28:15.334904636 +0100
@@ -150,6 +150,15 @@ xlog_grant_add_space(
 	} while (head_val != old);
 }
 
+STATIC void
+xlog_grant_head_init(
+	struct xlog_grant_head	*head)
+{
+	xlog_assign_grant_head(&head->grant, 1, 0);
+	INIT_LIST_HEAD(&head->waiters);
+	spin_lock_init(&head->lock);
+}
+
 STATIC bool
 xlog_reserveq_wake(
 	struct log		*log,
@@ -1070,12 +1079,9 @@ xlog_alloc_log(xfs_mount_t	*mp,
 	xlog_assign_atomic_lsn(&log->l_tail_lsn, 1, 0);
 	xlog_assign_atomic_lsn(&log->l_last_sync_lsn, 1, 0);
 	log->l_curr_cycle  = 1;	    /* 0 is bad since this is initial value */
-	xlog_assign_grant_head(&log->l_reserve_head.grant, 1, 0);
-	xlog_assign_grant_head(&log->l_write_head.grant, 1, 0);
-	INIT_LIST_HEAD(&log->l_reserve_head.waiters);
-	INIT_LIST_HEAD(&log->l_write_head.waiters);
-	spin_lock_init(&log->l_reserve_head.lock);
-	spin_lock_init(&log->l_write_head.lock);
+
+	xlog_grant_head_init(&log->l_reserve_head);
+	xlog_grant_head_init(&log->l_write_head);
 
 	error = EFSCORRUPTED;
 	if (xfs_sb_version_hassector(&mp->m_sb)) {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
