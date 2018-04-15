Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:45590 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751072AbeDOHoB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 15 Apr 2018 03:44:01 -0400
Date: Sun, 15 Apr 2018 00:44:00 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/7] xfs: allow attach of dfops to transaction
Message-ID: <20180415074400.GB5226@infradead.org>
References: <20180410174631.4915-1-bfoster@redhat.com>
 <20180410174631.4915-3-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180410174631.4915-3-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index 087fea02c389..f3aef54257d1 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -525,6 +525,7 @@ xfs_defer_init_op_type(
>  /* Initialize a deferred operation. */
>  void
>  xfs_defer_init(
> +	struct xfs_trans		*tp,
>  	struct xfs_defer_ops		*dop,
>  	xfs_fsblock_t			*fbp)
>  {
> @@ -532,5 +533,7 @@ xfs_defer_init(
>  	*fbp = NULLFSBLOCK;
>  	INIT_LIST_HEAD(&dop->dop_intake);
>  	INIT_LIST_HEAD(&dop->dop_pending);
> -	trace_xfs_defer_init(NULL, dop);
> +	if (tp)
> +		tp->t_dfops = dop;
> +	trace_xfs_defer_init(tp ? tp->t_mountp : NULL, dop);

there is really no oint un doing this massive change of prototypes
everywhere just to move an assignment into xfs_defer_init.  Just keep
that assignment in the caller.


But in general I'm really concerned about making the dops in the
transaction conditional behavior.  This is just going down the rathole
of inconsistent behavior where some callers expect it in the transaction
vs other explcitit and every time something really to defered ops is
touched it will need a deep code audit.  I'd rather switch everything
over in a go and be done with it.
