Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:59458 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727453AbfEJRbK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 May 2019 13:31:10 -0400
Date: Fri, 10 May 2019 10:31:10 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/6] xfs: use locality optimized cntbt lookups for near
 mode allocations
Message-ID: <20190510173110.GC18992@infradead.org>
References: <20190509165839.44329-1-bfoster@redhat.com>
 <20190509165839.44329-4-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190509165839.44329-4-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

Still digesting the algorithmic changes, but a few nitpicks below:

>  /*
> + * BLock allocation algorithm and data structures.

I think the upper case L is a typo.

> +struct xfs_alloc_btree_cur {
> +	struct xfs_btree_cur	*cur;		/* cursor */
> +	bool			active;		/* cursor active flag */
> +};

Can't we move the active flag inside the btree_cur, more specically
into enum xfs_btree_cur_private?

Or maybe we should byte the bullet and make xfs_btree_cur a structure
embedded into the type specific structures and use container_of.
But I certainly don't want to burden that on you and this series..
