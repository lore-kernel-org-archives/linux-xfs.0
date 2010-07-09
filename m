Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o69GAaRg122114 for <xfs@oss.sgi.com>; Fri, 9 Jul 2010 11:10:36 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B26F115A4544
	for <xfs@oss.sgi.com>; Fri,  9 Jul 2010 09:13:29 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id k7sAIijNEjYJamuQ for
	<xfs@oss.sgi.com>; Fri, 09 Jul 2010 09:13:29 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1OXGCf-00076u-DX
	for xfs@oss.sgi.com; Fri, 09 Jul 2010 16:13:29 +0000
Date: Fri, 9 Jul 2010 12:13:29 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: allow writeback from kswapd
Message-ID: <20100709161329.GC26302@infradead.org>
References: <20100628143444.GB5473@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100628143444.GB5473@infradead.org>
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
To: xfs@oss.sgi.com

ping?

On Mon, Jun 28, 2010 at 10:34:44AM -0400, Christoph Hellwig wrote:
> We only need disable I/O from direct or memcg reclaim.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfs-dev/fs/xfs/linux-2.6/xfs_aops.c
> ===================================================================
> --- xfs-dev.orig/fs/xfs/linux-2.6/xfs_aops.c	2010-06-28 11:57:06.652261386 +0200
> +++ xfs-dev/fs/xfs/linux-2.6/xfs_aops.c	2010-06-28 11:59:17.846068204 +0200
> @@ -1049,16 +1049,15 @@ xfs_vm_writepage(
>  	/*
>  	 * Refuse to write the page out if we are called from reclaim context.
>  	 *
> -	 * This is primarily to avoid stack overflows when called from deep
> -	 * used stacks in random callers for direct reclaim, but disabling
> -	 * reclaim for kswap is a nice side-effect as kswapd causes rather
> -	 * suboptimal I/O patters, too.
> +	 * This avoids stack overflows when called from deeply used stacks in
> +	 * random callers for direct reclaim or memcg reclaim.  We explicitly
> +	 * allow reclaim from kswapd as the stack usage there is relatively low.
>  	 *
>  	 * This should really be done by the core VM, but until that happens
>  	 * filesystems like XFS, btrfs and ext4 have to take care of this
>  	 * by themselves.
>  	 */
> -	if (current->flags & PF_MEMALLOC)
> +	if ((current->flags & (PF_MEMALLOC|PF_KSWAPD)) == PF_MEMALLOC)
>  		goto out_fail;
>  
>  	/*
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
---end quoted text---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
