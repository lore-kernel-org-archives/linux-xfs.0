Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB6LwstE003880 for <xfs@oss.sgi.com>; Tue, 6 Dec 2011 15:58:54 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B95AE1F45BFD
	for <xfs@oss.sgi.com>; Tue,  6 Dec 2011 13:58:53 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	RZLczxx4oFdGUjnr for <xfs@oss.sgi.com>;
	Tue, 06 Dec 2011 13:58:53 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RY32L-0006MS-4p
	for xfs@oss.sgi.com; Tue, 06 Dec 2011 21:58:53 +0000
Message-Id: <20111206215853.103470363@bombadil.infradead.org>
Date: Tue, 06 Dec 2011 16:58:09 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [patch 03/19] xfs: remove the lid_size field in struct log_item_desc
References: <20111206215806.844405397@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-kill-lid_size
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

Outside the now removed nodelaylog code this field is only used for
asserts and can be safely removed now.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>

---
 fs/xfs/xfs_dquot_item.c |    1 -
 fs/xfs/xfs_inode_item.c |    2 --
 fs/xfs/xfs_log_cil.c    |    9 +++++----
 fs/xfs/xfs_trans.c      |    1 -
 fs/xfs/xfs_trans.h      |    3 +--
 5 files changed, 6 insertions(+), 10 deletions(-)

Index: xfs/fs/xfs/xfs_dquot_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dquot_item.c	2011-12-06 15:26:35.140334173 +0100
+++ xfs/fs/xfs/xfs_dquot_item.c	2011-12-06 15:36:07.963678127 +0100
@@ -73,7 +73,6 @@ xfs_qm_dquot_logitem_format(
 	logvec->i_len  = sizeof(xfs_disk_dquot_t);
 	logvec->i_type = XLOG_REG_TYPE_DQUOT;
 
-	ASSERT(2 == lip->li_desc->lid_size);
 	qlip->qli_format.qlf_size = 2;
 
 }
Index: xfs/fs/xfs/xfs_inode_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode_item.c	2011-12-06 15:26:35.150334172 +0100
+++ xfs/fs/xfs/xfs_inode_item.c	2011-12-06 15:36:07.963678127 +0100
@@ -437,7 +437,6 @@ xfs_inode_item_format(
 	 * Assert that no attribute-related log flags are set.
 	 */
 	if (!XFS_IFORK_Q(ip)) {
-		ASSERT(nvecs == lip->li_desc->lid_size);
 		iip->ili_format.ilf_size = nvecs;
 		ASSERT(!(iip->ili_format.ilf_fields &
 			 (XFS_ILOG_ADATA | XFS_ILOG_ABROOT | XFS_ILOG_AEXT)));
@@ -521,7 +520,6 @@ xfs_inode_item_format(
 		break;
 	}
 
-	ASSERT(nvecs == lip->li_desc->lid_size);
 	iip->ili_format.ilf_size = nvecs;
 }
 
Index: xfs/fs/xfs/xfs_log_cil.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log_cil.c	2011-12-06 15:35:47.567011083 +0100
+++ xfs/fs/xfs/xfs_log_cil.c	2011-12-06 15:36:07.977011461 +0100
@@ -182,23 +182,24 @@ xlog_cil_prepare_log_vecs(
 		void	*ptr;
 		int	index;
 		int	len = 0;
+		uint	niovecs;
 
 		/* Skip items which aren't dirty in this transaction. */
 		if (!(lidp->lid_flags & XFS_LID_DIRTY))
 			continue;
 
 		/* Skip items that do not have any vectors for writing */
-		lidp->lid_size = IOP_SIZE(lidp->lid_item);
-		if (!lidp->lid_size)
+		niovecs = IOP_SIZE(lidp->lid_item);
+		if (!niovecs)
 			continue;
 
 		new_lv = kmem_zalloc(sizeof(*new_lv) +
-				lidp->lid_size * sizeof(struct xfs_log_iovec),
+				niovecs * sizeof(struct xfs_log_iovec),
 				KM_SLEEP);
 
 		/* The allocated iovec region lies beyond the log vector. */
 		new_lv->lv_iovecp = (struct xfs_log_iovec *)&new_lv[1];
-		new_lv->lv_niovecs = lidp->lid_size;
+		new_lv->lv_niovecs = niovecs;
 		new_lv->lv_item = lidp->lid_item;
 
 		/* build the vector array and calculate it's length */
Index: xfs/fs/xfs/xfs_trans.c
===================================================================
--- xfs.orig/fs/xfs/xfs_trans.c	2011-12-06 15:35:24.383677320 +0100
+++ xfs/fs/xfs/xfs_trans.c	2011-12-06 15:36:07.977011461 +0100
@@ -1158,7 +1158,6 @@ xfs_trans_add_item(
 
 	lidp->lid_item = lip;
 	lidp->lid_flags = 0;
-	lidp->lid_size = 0;
 	list_add_tail(&lidp->lid_trans, &tp->t_items);
 
 	lip->li_desc = lidp;
Index: xfs/fs/xfs/xfs_trans.h
===================================================================
--- xfs.orig/fs/xfs/xfs_trans.h	2011-12-06 15:26:35.190334174 +0100
+++ xfs/fs/xfs/xfs_trans.h	2011-12-06 15:36:07.977011461 +0100
@@ -163,9 +163,8 @@ typedef struct xfs_trans_header {
  */
 struct xfs_log_item_desc {
 	struct xfs_log_item	*lid_item;
-	ushort			lid_size;
-	unsigned char		lid_flags;
 	struct list_head	lid_trans;
+	unsigned char		lid_flags;
 };
 
 #define XFS_LID_DIRTY		0x1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
