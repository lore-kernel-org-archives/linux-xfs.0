Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6C3YGJC000512 for <xfs@oss.sgi.com>; Sun, 11 Jul 2010 22:34:17 -0500
Subject: Re: [PATCH] xfs: allow writeback from kswapd
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20100628143444.GB5473@infradead.org>
References: <20100628143444.GB5473@infradead.org>
Date: Sun, 11 Jul 2010 22:37:07 -0500
Message-ID: <1278905827.7456.20.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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

On Mon, 2010-06-28 at 10:34 -0400, Christoph Hellwig wrote:
> We only need disable I/O from direct or memcg reclaim.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>


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



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
