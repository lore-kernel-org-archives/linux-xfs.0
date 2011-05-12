Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4C7Qr1L163950 for <xfs@oss.sgi.com>; Thu, 12 May 2011 02:26:53 -0500
Received: from mx4-phx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0206C449581
	for <xfs@oss.sgi.com>; Thu, 12 May 2011 00:26:52 -0700 (PDT)
Received: from mx4-phx2.redhat.com (mx4-phx2.redhat.com [209.132.183.25]) by
	cuda.sgi.com with ESMTP id 5BIFLWAOzoR0foaF for
	<xfs@oss.sgi.com>; Thu, 12 May 2011 00:26:52 -0700 (PDT)
Date: Thu, 12 May 2011 03:26:48 -0400 (EDT)
From: Lachlan McIlroy <lmcilroy@redhat.com>
Message-ID: <805441546.471537.1305185208927.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
In-Reply-To: <20110511150713.039506186@bombadil.infradead.org>
Subject: Re: [PATCH 9/9] xfs: check for valid indices in xfs_iext_get_ext
	and	xfs_iext_idx_to_irec
MIME-Version: 1.0
Reply-To: Lachlan McIlroy <lmcilroy@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Looks good too.

Christoph, thanks for following up on these fixes - I didn't know they
didn't make it in.

----- Original Message -----
> Based on an earlier patch from Lachlan McIlroy.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfs/fs/xfs/xfs_inode.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_inode.c 2011-05-11 12:05:12.943735034 +0200
> +++ xfs/fs/xfs/xfs_inode.c 2011-05-11 12:05:28.327733646 +0200
> @@ -3108,6 +3108,8 @@ xfs_iext_get_ext(
> xfs_extnum_t idx) /* index of target extent */
> {
> ASSERT(idx >= 0);
> + ASSERT(idx < ifp->if_bytes / sizeof(xfs_bmbt_rec_t));
> +
> if ((ifp->if_flags & XFS_IFEXTIREC) && (idx == 0)) {
> return ifp->if_u1.if_ext_irec->er_extbuf;
> } else if (ifp->if_flags & XFS_IFEXTIREC) {
> @@ -3881,8 +3883,10 @@ xfs_iext_idx_to_irec(
> xfs_extnum_t page_idx = *idxp; /* extent index in target list */
> 
> ASSERT(ifp->if_flags & XFS_IFEXTIREC);
> - ASSERT(page_idx >= 0 && page_idx <=
> - ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t));
> + ASSERT(page_idx >= 0);
> + ASSERT(page_idx <= ifp->if_bytes / sizeof(xfs_bmbt_rec_t));
> + ASSERT(page_idx < ifp->if_bytes / sizeof(xfs_bmbt_rec_t) ||
> realloc);
> +
> nlists = ifp->if_real_bytes / XFS_IEXT_BUFSZ;
> erp_idx = 0;
> low = 0;
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
