Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:59386 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750978AbeBAFUW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Feb 2018 00:20:22 -0500
Date: Thu, 1 Feb 2018 16:21:03 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [LSF/MM TOPIC] Virtual block address space mapping
Message-ID: <20180201052103.v6vpeg2ndfm2diti@destitution>
References: <20180129100834.rhpgnz5572zxmqep@destitution>
 <20180201022332.GD3814@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180201022332.GD3814@fieldses.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: lsf-pc@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org

On Wed, Jan 31, 2018 at 09:23:32PM -0500, J. Bruce Fields wrote:
> On Mon, Jan 29, 2018 at 09:08:34PM +1100, Dave Chinner wrote:
> > I've implemented both sides on XFS to provide the capability for an
> > XFS filesystem to host XFS subvolumes. however, this is an abstract
> > interface and so if someone modifies ext4 to use a virtual block
> > address space, then XFS will be able to host cloneable ext4
> > subvolumes, too. :P
> 
> This sounds really interesting.
> 
> Would it be possible to write up a brief summary of your current
> interface?  Even if it's not completely correct it might be a useful
> starting point.

I almost did this, but decided i wouldn't because I haven't finished
data IO path remapping suuport for XFS yet. But, seeing as you
asked, I've attached the header that contains the API as it stands
below. It's intermingled with bits of the XFs implementation, and it
still has the original name I gave it when I first started ("block
space").

The difference between the "map" and "allocate" ops are that "map"
does a read only mapping and may return holes. "allocate" is a write
mapping and will fill holes and requires to have reserved space held
in a blkspc cookie...

i.e. use "map" for a read IO, "allocate w\ cookie" for a write IO.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com


/* SPDX-License-Identifier: GPL-2.0 */
/* Copyright (c) 2017 Red Hat, Inc. All rights reserved. */

#ifndef __XFS_REMAP_H
#define __XFS_REMAP_H	1

struct xfs_buf;
struct xfs_inode;
struct iomap;
struct blkspsc_ops;

struct blkspc_host {
	void			*priv;	/* host private data */
	struct block_device	*bdev;	/* target device */
	const struct blkspc_ops	*ops;
};

struct blkspc_cookie {
	refcount_t	ref;
	bool		cancelled;		/* no longer usable */
	struct blkspc_host *host;		/* backpointer to owner */
	void		*priv;			/* blkdev private data */
};

struct blkspc_ops {
	struct blkspc_cookie * (*reserve)(struct blkspc_host *bsh,
					  u32 alloc_count, u32 block_size);
	int	(*unreserve)(struct blkspc_cookie *bsc);
	int	(*allocate)(struct blkspc_cookie *bsc, loff_t offset, loff_t count,
			    struct iomap *iomap);
	int	(*commit)(struct blkspc_cookie *bsc, loff_t offset,
			  loff_t count, int type);
	int	(*map)(struct blkspc_host *bsh, loff_t offset, loff_t count,
			    struct iomap *iomap);
};

enum {
	BS_TYPE_COW,
	BS_TYPE_UNWRITTEN,
};

static inline struct blkspc_cookie *
blkspc_cookie_get(
	struct blkspc_cookie	*bsc)
{
	trace_printk("blkspc_cookie_get %p %d", bsc, refcount_read(&bsc->ref));
	if (bsc->cancelled)
		return NULL;
	if (!refcount_inc_not_zero(&bsc->ref))
		return NULL;
	return bsc;
}

static inline void
blkspc_cookie_put(
	struct blkspc_cookie	*bsc)
{
	trace_printk("blkspc_cookie_put %p %d", bsc, refcount_read(&bsc->ref));
	if (!refcount_dec_and_test(&bsc->ref))
		return;
	/* last ref, return unused reservation */
	bsc->host->ops->unreserve(bsc);
	kmem_free(bsc);
}

static inline void
blkspc_cookie_cancel(
	struct blkspc_cookie	*bsc)
{
	bsc->cancelled = true;
}

/*
 * XXX: need a generic init function
 */
struct blkspc_host *
	xfs_blkspc_init(struct xfs_inode *host_ip, struct block_device *bdev);
void	xfs_blkspc_destroy(struct blkspc_host *bsh);

int	xfs_buf_remap_iodone(struct xfs_buf *bp);
int	xfs_buf_remap(struct xfs_buf *bp, struct blkspc_cookie *bsc);

#endif /* __XFS_REMAP_H */
