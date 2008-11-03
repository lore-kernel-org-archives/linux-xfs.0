Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 02 Nov 2008 17:51:21 -0800 (PST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id mA31p8WR022155
	for <xfs@oss.sgi.com>; Sun, 2 Nov 2008 17:51:08 -0800
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7EE461BDB7D3
	for <xfs@oss.sgi.com>; Sun,  2 Nov 2008 17:51:09 -0800 (PST)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id dv8w3QHi4OPm69PS for <xfs@oss.sgi.com>; Sun, 02 Nov 2008 17:51:09 -0800 (PST)
Date: Mon, 3 Nov 2008 12:50:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/6] move inode allocation out xfs_iread
Message-ID: <20081103015058.GR19509@disturbed>
References: <20081027134130.GG3183@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081027134130.GG3183@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, Oct 27, 2008 at 09:41:30AM -0400, Christoph Hellwig wrote:
> Allocate the inode in xfs_iget_cache_miss and pass it into xfs_iread.  This
> simplifies the error handling and allows xfs_iread to be shared with userspace
> which already uses these semantics.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: linux-2.6-xfs/fs/xfs/xfs_iget.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_iget.c	2008-10-25 13:45:30.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/xfs_iget.c	2008-10-25 13:46:29.000000000 +0200
> @@ -40,6 +40,82 @@
>  #include "xfs_utils.h"
>  #include "xfs_trans_priv.h"
>  #include "xfs_inode_item.h"
> +#include "xfs_bmap.h"
> +#include "xfs_btree_trace.h"
> +#include "xfs_dir2_trace.h"
> +
> +
> +/*
> + * Allocate and initialise an xfs_inode.
> + */
> +STATIC struct xfs_inode *
> +xfs_inode_alloc(
> +	struct xfs_mount	*mp,
> +	xfs_ino_t		ino)
> +{
> +	struct xfs_inode	*ip;
> +
> +	/*
> +	 * if this didn't occur in transactions, we could use
> +	 * KM_MAYFAIL and return NULL here on ENOMEM. Set the
> +	 * code up to do this anyway.
> +	 */
> +	ip = kmem_zone_alloc(xfs_inode_zone, KM_SLEEP);
> +	if (!ip)
> +		return NULL;
> +
> +	ASSERT(atomic_read(&ip->i_iocount) == 0);
> +	ASSERT(atomic_read(&ip->i_pincount) == 0);
> +	ASSERT(!spin_is_locked(&ip->i_flags_lock));
> +	ASSERT(completion_done(&ip->i_flush));
> +
> +	/*
> +	 * initialise the VFS inode here to get failures
> +	 * out of the way early.
> +	 */
> +	if (!inode_init_always(mp->m_super, VFS_I(ip))) {
> +		kmem_zone_free(xfs_inode_zone, ip);
> +		return NULL;
> +	}
> +
> +	/* initialise the xfs inode */
> +	ip->i_ino = ino;
> +	ip->i_mount = mp;

Hmmmm - what happened to the patch I sent that moved this till
after ip->i_mount() was initialised? Hmmm - looks like it
went missing. Ah - christoph's fix for the security inode
leak was taken, so the patch I had that included this change
was dropped. Looks like we still need that part of my patch.

I'll have to resend it, and it needs to go in ASAP as
inode_init_always() can call ->destroy_inode, so the above is a
double free or a panic in xfs_ireclaim(). This patch will then need
to be rediffed on top of it.

Otherwise the patch makes sense.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
