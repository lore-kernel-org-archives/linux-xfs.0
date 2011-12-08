Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB8FxJCO150194 for <xfs@oss.sgi.com>; Thu, 8 Dec 2011 09:59:19 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D78732A8A06
	for <xfs@oss.sgi.com>; Thu,  8 Dec 2011 07:59:18 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	g8CaBTbh4B0v6jZk for <xfs@oss.sgi.com>;
	Thu, 08 Dec 2011 07:59:18 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RYgNS-0006oC-1J
	for xfs@oss.sgi.com; Thu, 08 Dec 2011 15:59:18 +0000
Message-Id: <20111208155917.995886067@bombadil.infradead.org>
Date: Thu, 08 Dec 2011 10:57:58 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 03/11] xfs: remove the unused dm_attrs structure
References: <20111208155755.323930705@bombadil.infradead.org>
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
Reviewed-by: Alex Elder <aelder@sgi.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>

---
 fs/xfs/xfs_inode.h |    7 -------
 1 file changed, 7 deletions(-)

Index: xfs/fs/xfs/xfs_inode.h
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.h	2011-11-30 10:56:57.396098395 +0100
+++ xfs/fs/xfs/xfs_inode.h	2011-11-30 10:57:46.375833051 +0100
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
