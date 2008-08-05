Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 04 Aug 2008 19:06:54 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7526qdK028074
	for <xfs@oss.sgi.com>; Mon, 4 Aug 2008 19:06:52 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CBE6735C369
	for <xfs@oss.sgi.com>; Mon,  4 Aug 2008 19:08:05 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id hyoqI3gnJGSx1xQS for <xfs@oss.sgi.com>; Mon, 04 Aug 2008 19:08:05 -0700 (PDT)
Date: Tue, 5 Aug 2008 12:06:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 26/26] add rec_len and key_len fields to struct
	xfs_btree_ops
Message-ID: <20080805020651.GQ6119@disturbed>
References: <20080804013608.GA8819@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080804013608.GA8819@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Mon, Aug 04, 2008 at 03:36:08AM +0200, Christoph Hellwig wrote:
> XXX: add detailed patch explanation here

heh ;)

.....

> Index: linux-2.6-xfs/fs/xfs/xfs_btree.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_btree.c	2008-08-04 01:48:35.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/xfs_btree.c	2008-08-04 01:49:13.000000000 +0200
> @@ -1037,6 +1037,82 @@ xfs_btree_read_buf_block(
>  	return error;
>  }
>  
> +static inline size_t xfs_btree_block_len(struct xfs_btree_cur *cur)
> +{
> +	return (cur->bc_flags & XFS_BTREE_LONG_PTRS) ?
> +		sizeof(struct xfs_btree_lblock) :
> +		sizeof(struct xfs_btree_sblock);
> +}

That's really the block header length, not the block length.
Can you change the name to reflect that?

> +
> +static inline size_t xfs_btree_ptr_len(struct xfs_btree_cur *cur)
> +{
> +	return (cur->bc_flags & XFS_BTREE_LONG_PTRS) ?
> +		sizeof(__be64) : sizeof(__be32);
> +}
> +
> +static size_t
> +xfs_btree_ptr_offset(
> +	struct xfs_btree_cur	*cur,
> +	int			index,
> +	int			level)
> +{
> +	return xfs_btree_block_len(cur) +
> +		cur->bc_ops->get_maxrecs(cur, level) * cur->bc_ops->key_len +
> +		(index - 1) * xfs_btree_ptr_len(cur);
> +}

I'd suggest a comment here just reminding the reader about the
key/ptr block structure. i.e. key space is at the start of the
block, ptr space is after the key space.

Also a comment here reminding that btree indexes are 1-numbered,
not 0-numbered and hence the need for 'index - 1' in the
offset calculations.

>  STATIC void
> +xfs_btree_set_key(
> +	struct xfs_btree_cur	*cur,
> +	union xfs_btree_key	*key_addr,
> +	int			index,
> +	union xfs_btree_key	*newkey)
> +{
> +	char			*kp;
> +
> +	kp = (char *)key_addr + (index * cur->bc_ops->key_len);
> +
> +	memcpy(kp, newkey, cur->bc_ops->key_len);
> +}

And then for these set functions, the index has already been
converted from 1-numbered to 0-numbered by the caller, hence the
direct use of 'index' without correction.

> @@ -1079,6 +1183,44 @@ xfs_btree_move_ptrs(
>  }
>  
>  STATIC void
> +xfs_btree_move_keys(
> +	struct xfs_btree_cur	*cur,
> +	union xfs_btree_key	*key,
> +	int			from,
> +	int			to,
> +	int			numkeys)
> +{
> +	char			*base = (char *)key;
> +
> +	ASSERT(from >= 0);
> +	ASSERT(to >= 0);
> +	ASSERT(numkeys >= 0);
> +
> +	memmove(base + (to * cur->bc_ops->key_len),
> +		base + (from * cur->bc_ops->key_len),
> +		numkeys * cur->bc_ops->key_len);
> +}

Comment about from and to being logical offsets from the base,
not byte counts.

Hmmm - seeing how frequently the functions like xfs_btree_key_addr()
are called, should we prevent them from being inlined automatically
by the compiler (i.e. make them STATIC or explictly noinline)?

Otherwise seems sane to me.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
