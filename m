Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p619k5Ia056028 for <xfs@oss.sgi.com>; Fri, 1 Jul 2011 04:46:05 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3F189466A2
	for <xfs@oss.sgi.com>; Fri,  1 Jul 2011 02:46:05 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	RF6A8BiNq6UIIOFq for <xfs@oss.sgi.com>;
	Fri, 01 Jul 2011 02:46:05 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1QcaIW-0001vB-Kp
	for xfs@oss.sgi.com; Fri, 01 Jul 2011 09:46:04 +0000
Message-Id: <20110701094604.608829837@bombadil.infradead.org>
Date: Fri, 01 Jul 2011 05:43:32 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 11/27] xfs: kill the unused struct xfs_sync_work
References: <20110701094321.936534538@bombadil.infradead.org>
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
