Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o96IeLfb110134 for <xfs@oss.sgi.com>; Wed, 6 Oct 2010 13:40:21 -0500
Received: from canuck.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E7FC71C01DFE
	for <xfs@oss.sgi.com>; Wed,  6 Oct 2010 11:41:25 -0700 (PDT)
Received: from canuck.infradead.org (canuck.infradead.org [134.117.69.58]) by
	cuda.sgi.com with ESMTP id tpIkhGWvdJAx49Ar for
	<xfs@oss.sgi.com>; Wed, 06 Oct 2010 11:41:25 -0700 (PDT)
Received: from hch by canuck.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1P3Yvd-00018B-FS
	for xfs@oss.sgi.com; Wed, 06 Oct 2010 18:41:25 +0000
Message-Id: <20101006184125.327557835@localhost.localdomain>
Date: Wed, 06 Oct 2010 14:41:12 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/7] xfs: remove unused t_callback field in struct xfs_trans
References: <20101006184111.634126439@localhost.localdomain>
Content-Disposition: inline; filename=xfs-remove-t_callback
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

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_trans.c
===================================================================
--- xfs.orig/fs/xfs/xfs_trans.c	2010-10-05 10:57:50.793254343 +0200
+++ xfs/fs/xfs/xfs_trans.c	2010-10-06 11:10:13.774254205 +0200
@@ -1416,10 +1416,6 @@ xfs_trans_committed(
 {
 	struct xfs_log_item_desc *lidp, *next;
 
-	/* Call the transaction's completion callback if there is one. */
-	if (tp->t_callback != NULL)
-		tp->t_callback(tp, tp->t_callarg);
-
 	list_for_each_entry_safe(lidp, next, &tp->t_items, lid_trans) {
 		xfs_trans_item_committed(lidp->lid_item, tp->t_lsn, abortflag);
 		xfs_trans_free_item_desc(lidp);
Index: xfs/fs/xfs/xfs_trans.h
===================================================================
--- xfs.orig/fs/xfs/xfs_trans.h	2010-10-05 10:57:50.801254064 +0200
+++ xfs/fs/xfs/xfs_trans.h	2010-10-06 11:10:13.774254205 +0200
@@ -399,8 +399,6 @@ typedef struct xfs_trans {
 						 * transaction. */
 	struct xfs_mount	*t_mountp;	/* ptr to fs mount struct */
 	struct xfs_dquot_acct   *t_dqinfo;	/* acctg info for dquots */
-	xfs_trans_callback_t	t_callback;	/* transaction callback */
-	void			*t_callarg;	/* callback arg */
 	unsigned int		t_flags;	/* misc flags */
 	int64_t			t_icount_delta;	/* superblock icount change */
 	int64_t			t_ifree_delta;	/* superblock ifree change */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
