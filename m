Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40480 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751411AbcLEREL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Dec 2016 12:04:11 -0500
Date: Mon, 5 Dec 2016 09:04:11 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3] xfs: use rhashtable to track buffer cache
Message-ID: <20161205170411.GA14091@infradead.org>
References: <20161201103052.28453-1-david@fromorbit.com>
 <20161201103052.28453-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161201103052.28453-3-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

> +static int
> +_xfs_buf_cmp(
> +	struct rhashtable_compare_arg *arg,
> +	const void *obj)
> +{
> +	const struct xfs_buf_map *map = arg->key;
> +	const struct xfs_buf *bp = obj;

How about aligning the parameter / variable names here like we
normally do in XFS?

> +static const struct rhashtable_params xfs_buf_hash_params = {
> +	.min_size = 32,		/* empty/unused AGs have minimal footprint */
> +	.nelem_hint = 16,
> +	.key_len = sizeof(xfs_daddr_t),
> +	.key_offset = offsetof(struct xfs_buf, b_bn),
> +	.head_offset = offsetof(struct xfs_buf, b_rhash_head),
> +	.automatic_shrinking = true,
> +	.obj_cmpfn = _xfs_buf_cmp,

Some tab alignments before the equal signs here?

Also please name the compare function so that it fits the field name,
as that makes grepping so much easier..

	.obj_cmpfn	= xfs_buf_obj_cmpfn,


Otherwise this looks fine to me and seems to survive testing so far:

Reviewed-by: Christoph Hellwig <hch@lst.de>
