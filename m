Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4BF7Esf128069 for <xfs@oss.sgi.com>; Wed, 11 May 2011 10:07:14 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B16B214CA3BA
	for <xfs@oss.sgi.com>; Wed, 11 May 2011 08:07:13 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id J0cHR3hMFwsXjET5 for
	<xfs@oss.sgi.com>; Wed, 11 May 2011 08:07:13 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1QKB0L-0005hc-2k
	for xfs@oss.sgi.com; Wed, 11 May 2011 15:07:13 +0000
Message-Id: <20110511150713.039506186@bombadil.infradead.org>
Date: Wed, 11 May 2011 11:04:11 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 9/9] xfs: check for valid indices in xfs_iext_get_ext and
	xfs_iext_idx_to_irec
References: <20110511150402.258164661@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-iext-asserts-1
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

Based on an earlier patch from Lachlan McIlroy.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_inode.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.c	2011-05-11 12:05:12.943735034 +0200
+++ xfs/fs/xfs/xfs_inode.c	2011-05-11 12:05:28.327733646 +0200
@@ -3108,6 +3108,8 @@ xfs_iext_get_ext(
 	xfs_extnum_t	idx)		/* index of target extent */
 {
 	ASSERT(idx >= 0);
+	ASSERT(idx < ifp->if_bytes / sizeof(xfs_bmbt_rec_t));
+
 	if ((ifp->if_flags & XFS_IFEXTIREC) && (idx == 0)) {
 		return ifp->if_u1.if_ext_irec->er_extbuf;
 	} else if (ifp->if_flags & XFS_IFEXTIREC) {
@@ -3881,8 +3883,10 @@ xfs_iext_idx_to_irec(
 	xfs_extnum_t	page_idx = *idxp; /* extent index in target list */
 
 	ASSERT(ifp->if_flags & XFS_IFEXTIREC);
-	ASSERT(page_idx >= 0 && page_idx <=
-		ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t));
+	ASSERT(page_idx >= 0);
+	ASSERT(page_idx <= ifp->if_bytes / sizeof(xfs_bmbt_rec_t));
+	ASSERT(page_idx < ifp->if_bytes / sizeof(xfs_bmbt_rec_t) || realloc);
+
 	nlists = ifp->if_real_bytes / XFS_IEXT_BUFSZ;
 	erp_idx = 0;
 	low = 0;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
