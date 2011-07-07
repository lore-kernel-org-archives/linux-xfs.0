Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p67B6hCa159871 for <xfs@oss.sgi.com>; Thu, 7 Jul 2011 06:06:43 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4724852E32
	for <xfs@oss.sgi.com>; Thu,  7 Jul 2011 04:06:43 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	QHz7EDilWPmiR6SX for <xfs@oss.sgi.com>;
	Thu, 07 Jul 2011 04:06:43 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1QemPq-0003uq-Ni
	for xfs@oss.sgi.com; Thu, 07 Jul 2011 11:06:42 +0000
Message-Id: <20110707110642.697024790@bombadil.infradead.org>
Date: Thu, 07 Jul 2011 07:05:46 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 11/28] xfs: kill the unused struct xfs_sync_work
References: <20110707110535.205001532@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-kill-xfs_sync_work
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
Reviewed-by: Alex Elder <aelder@sgi.com>

Index: xfs/fs/xfs/linux-2.6/xfs_sync.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_sync.h	2011-06-30 15:47:30.203125879 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_sync.h	2011-06-30 15:47:39.093125768 +0200
@@ -21,14 +21,6 @@
 struct xfs_mount;
 struct xfs_perag;
 
-typedef struct xfs_sync_work {
-	struct list_head	w_list;
-	struct xfs_mount	*w_mount;
-	void			*w_data;	/* syncer routine argument */
-	void			(*w_syncer)(struct xfs_mount *, void *);
-	struct completion	*w_completion;
-} xfs_sync_work_t;
-
 #define SYNC_WAIT		0x0001	/* wait for i/o to complete */
 #define SYNC_TRYLOCK		0x0002  /* only try to lock inodes */
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
