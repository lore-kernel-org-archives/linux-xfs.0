Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0DLnh1R162907 for <xfs@oss.sgi.com>; Fri, 13 Jan 2012 15:49:43 -0600
Date: Fri, 13 Jan 2012 15:49:41 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 06/11] xfs: replace i_flock with a sleeping bitlock
Message-ID: <20120113214941.GA16386@sgi.com>
References: <20111218200003.557507716@bombadil.infradead.org>
	<20111218200131.745039484@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111218200131.745039484@bombadil.infradead.org>
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

On Sun, Dec 18, 2011 at 03:00:09PM -0500, Christoph Hellwig wrote:
> Index: xfs/fs/xfs/xfs_inode.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_inode.c	2011-12-18 08:05:01.469974560 -0800
> +++ xfs/fs/xfs/xfs_inode.c	2011-12-18 08:06:23.266640737 -0800

...

> -/*
>   * In-core inode flags.
>   */
> -#define XFS_IRECLAIM		0x0001  /* started reclaiming this inode */
> -#define XFS_ISTALE		0x0002	/* inode has been staled */
> -#define XFS_IRECLAIMABLE	0x0004	/* inode can be reclaimed */
> -#define XFS_INEW		0x0008	/* inode has just been allocated */
> -#define XFS_IFILESTREAM		0x0010	/* inode is in a filestream directory */
> -#define XFS_ITRUNCATED		0x0020	/* truncated down so flush-on-close */
> -#define XFS_IDIRTY_RELEASE	0x0040	/* dirty release already seen */
> +#define XFS_IRECLAIM		(1 << 0) /* started reclaiming this inode */
> +#define XFS_ISTALE		(1 << 1) /* inode has been staled */
> +#define XFS_IRECLAIMABLE	(1 << 2) /* inode can be reclaimed */
> +#define XFS_INEW		(1 << 3) /* inode has just been allocated */
> +#define XFS_IFILESTREAM		(1 << 4) /* inode is in a filestream dir. */
> +#define XFS_ITRUNCATED		(1 << 5) /* truncated down so flush-on-close */
> +#define XFS_IDIRTY_RELEASE	(1 << 6) /* dirty release already seen */
> +#define __XFS_IFLOCK_BIT	7	 /* inode is being flushed right now */
> +#define XFS_IFLOCK		(1 << __XFS_IFLOCK_BIT)

Nice.

> +static inline void xfs_iflock(struct xfs_inode *ip)
> +{
> +	if (!xfs_iflock_nowait(ip))
> +		__xfs_iflock(ip);
> +}

Going after the iflock nowait first seems a little silly, but I'm
guessing that you're trying to avoid touching the zone wait_table in
bit_waitqueue if you can avoid it, along with the rest of the overhead
related to seeting up the wait queue in __xfs_iflock.

> +
> +static inline void xfs_ifunlock(struct xfs_inode *ip)
> +{
> +	xfs_iflags_clear(ip, XFS_IFLOCK);
> +	wake_up_bit(&ip->i_flags, __XFS_IFLOCK_BIT);
> +}

I was going to suggest this:

	spin_lock(&ip->i_flags_lock); 
	ip->i_flags &= ~XFS_IFLOCK;
	wake_up_bit(... 
	spin_unlock(&ip->i_flags_lock);

After some study I believe what you have is ok:

Say this is process A.  If process B got the lock after A cleared IFLOCK
and before A wake_up_bit wakes process C.  C will just go back to sleep
in __xfs_iflock until B calls xfs_ifunlock to wake C again.  

Looks good.

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
