Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9IKE9Tc125208 for <xfs@oss.sgi.com>; Tue, 18 Oct 2011 15:14:09 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 84F2A1C964F2
	for <xfs@oss.sgi.com>; Tue, 18 Oct 2011 13:14:06 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	lSyzOQIsiFEHoqQt for <xfs@oss.sgi.com>;
	Tue, 18 Oct 2011 13:14:06 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RGG33-0007Fy-PT
	for xfs@oss.sgi.com; Tue, 18 Oct 2011 20:14:05 +0000
Message-Id: <20111018201405.736219363@bombadil.infradead.org>
Date: Tue, 18 Oct 2011 16:13:08 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 4/4] xfs: remove the unused dm_attrs structure
References: <20111018201304.279051318@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-remove-dm_attrs
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

.. and the just as dead bhv_desc forward declaration while we're at it.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_inode.h
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.h	2011-10-18 21:32:14.225353097 +0200
+++ xfs/fs/xfs/xfs_inode.h	2011-10-18 21:32:23.404480427 +0200
@@ -211,7 +211,6 @@ typedef struct xfs_icdinode {
 
 #ifdef __KERNEL__
 
-struct bhv_desc;
 struct xfs_buf;
 struct xfs_bmap_free;
 struct xfs_bmbt_irec;
@@ -220,12 +219,6 @@ struct xfs_mount;
 struct xfs_trans;
 struct xfs_dquot;
 
-typedef struct dm_attrs_s {
-	__uint32_t	da_dmevmask;	/* DMIG event mask */
-	__uint16_t	da_dmstate;	/* DMIG state info */
-	__uint16_t	da_pad;		/* DMIG extra padding */
-} dm_attrs_t;
-
 typedef struct xfs_inode {
 	/* Inode linking and identification information. */
 	struct xfs_mount	*i_mount;	/* fs mount struct ptr */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
