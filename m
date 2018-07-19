Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:36636 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727465AbeGSUlc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Jul 2018 16:41:32 -0400
Date: Thu, 19 Jul 2018 12:56:53 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 08/14] xfs: support embedded dfops in transaction
Message-ID: <20180719195653.GI6558@infradead.org>
References: <20180719134919.29939-1-bfoster@redhat.com>
 <20180719134919.29939-9-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180719134919.29939-9-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

> +/*
> + * Move state from one xfs_defer_ops to another and reset the source to initial
> + * state. This is primarily used to carry state forward across transaction rolls
> + * with internal dfops.
> + */

> +void
> +xfs_defer_move(
> +	struct xfs_defer_ops	*dst,
> +	struct xfs_defer_ops	*src)
> +{
> +	int			i;
> +
> +	ASSERT(dst != src);
> +
> +	list_splice_init(&src->dop_intake, &dst->dop_intake);
> +	list_splice_init(&src->dop_pending, &dst->dop_pending);
> +
> +	for (i = 0; i < XFS_DEFER_OPS_NR_INODES; i++) {
> +		if (!src->dop_inodes[i])
> +			break;
> +		dst->dop_inodes[i] = src->dop_inodes[i];
> +	}
> +	for (i = 0; i< XFS_DEFER_OPS_NR_BUFS; i++) {
> +		if (!src->dop_bufs[i])
> +			break;
> +		dst->dop_bufs[i] = src->dop_bufs[i];
> +	}

I suspect simply memcpy()ing the state over would be faster..
