Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:58438 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727985AbeGYGVj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Jul 2018 02:21:39 -0400
Date: Tue, 24 Jul 2018 22:11:43 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 14/15] xfs: drop unnecessary xfs_defer_finish() dfops
 parameter
Message-ID: <20180725051143.GG5802@infradead.org>
References: <20180723130414.47980-1-bfoster@redhat.com>
 <20180723130414.47980-15-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180723130414.47980-15-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

> -int xfs_defer_finish(struct xfs_trans **tp, struct xfs_defer_ops *dop);
> -void xfs_defer_cancel(struct xfs_defer_ops *dop);
> +int xfs_defer_finish(struct xfs_trans **tp);
> +void __xfs_defer_cancel(struct xfs_defer_ops *dop);

> index dc79e3c1d3e8..5170e89bec02 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -214,6 +214,9 @@ xfs_trans_read_buf(
>  				      flags, bpp, ops);
>  }
>  
> +/* cancel dfops associated with a transaction */
> +void xfs_defer_cancel(struct xfs_trans *);

Is there any good reason not to keep xfs_defer_cancel in xfs_defer.[ch]?

Otherwise this looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
