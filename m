Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o96IeN81110159 for <xfs@oss.sgi.com>; Wed, 6 Oct 2010 13:40:23 -0500
Received: from canuck.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D66ED12EDC67
	for <xfs@oss.sgi.com>; Wed,  6 Oct 2010 11:55:12 -0700 (PDT)
Received: from canuck.infradead.org (canuck.infradead.org [134.117.69.58]) by
	cuda.sgi.com with ESMTP id ND5G9wdheYQtgJVT for
	<xfs@oss.sgi.com>; Wed, 06 Oct 2010 11:55:12 -0700 (PDT)
Received: from hch by canuck.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1P3Yvd-00018h-Oo
	for xfs@oss.sgi.com; Wed, 06 Oct 2010 18:41:25 +0000
Message-Id: <20101006184125.617230666@localhost.localdomain>
Date: Wed, 06 Oct 2010 14:41:13 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/7] xfs: fix the xfs_trans_committed
References: <20101006184111.634126439@localhost.localdomain>
Content-Disposition: inline; filename=xfs-fix-cb_func_prototype
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

Use the correct prototype for xfs_trans_committed instead of casting it.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_trans.c
===================================================================
--- xfs.orig/fs/xfs/xfs_trans.c	2010-10-06 11:10:13.774254205 +0200
+++ xfs/fs/xfs/xfs_trans.c	2010-10-06 11:13:16.145254205 +0200
@@ -1411,9 +1411,10 @@ xfs_trans_item_committed(
  */
 STATIC void
 xfs_trans_committed(
-	struct xfs_trans	*tp,
+	void			*arg,
 	int			abortflag)
 {
+	struct xfs_trans	*tp = arg;
 	struct xfs_log_item_desc *lidp, *next;
 
 	list_for_each_entry_safe(lidp, next, &tp->t_items, lid_trans) {
@@ -1543,7 +1544,7 @@ xfs_trans_commit_iclog(
 	 * running in simulation mode (the log is explicitly turned
 	 * off).
 	 */
-	tp->t_logcb.cb_func = (void(*)(void*, int))xfs_trans_committed;
+	tp->t_logcb.cb_func = xfs_trans_committed;
 	tp->t_logcb.cb_arg = tp;
 
 	/*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
