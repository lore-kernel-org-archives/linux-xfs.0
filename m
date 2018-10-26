Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:36612 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726367AbeJZSY3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Oct 2018 14:24:29 -0400
Date: Fri, 26 Oct 2018 02:48:05 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/5] xfs: factor free block index lookup from
 xfs_dir2_node_addname_int()
Message-ID: <20181026094805.GB29302@infradead.org>
References: <20181024225716.19459-1-david@fromorbit.com>
 <20181024225716.19459-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181024225716.19459-4-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

> +/*
> + * Add the data entry for a node-format directory name addition.
> + * The leaf entry is added in xfs_dir2_leafn_add.
> + * We may enter with a freespace block that the lookup found.
> + */
> +static int					/* error */
> +xfs_dir2_node_addname_int(
> +	xfs_da_args_t		*args,		/* operation arguments */
> +	xfs_da_state_blk_t	*fblk)		/* optional freespace block */
> +{
> +	xfs_dir2_data_hdr_t	*hdr;		/* data block header */
> +	xfs_dir2_db_t		dbno;		/* data block number */
> +	struct xfs_buf		*dbp;		/* data block buffer */
> +	xfs_dir2_data_entry_t	*dep;		/* data entry pointer */
> +	xfs_inode_t		*dp;		/* incore directory inode */
> +	xfs_dir2_data_unused_t	*dup;		/* data unused entry pointer */
> +	int			error;		/* error return value */
> +	struct xfs_buf		*fbp;		/* freespace buffer */
> +	int			findex;		/* freespace entry index */
> +	xfs_dir2_free_t		*free=NULL;	/* freespace block structure */
> +	int			length;		/* length of the new entry */
> +	int			logfree = 0;	/* need to log free entry */
> +	int			needlog = 0;	/* need to log data header */
> +	int			needscan = 0;	/* need to rescan data frees */
> +	__be16			*tagp;		/* data entry tag pointer */
> +	xfs_trans_t		*tp;		/* transaction pointer */
> +	__be16			*bests;
> +	struct xfs_dir2_data_free *bf;
> +	xfs_dir2_data_aoff_t	aoff;
> +
> +	dp = args->dp;
> +	tp = args->trans;
> +	length = dp->d_ops->data_entsize(args->namelen);

Can you remove the use of typedefs and move the trivial initializers
to the declaration like you've done for the new helpers here?

Otherwise this looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
