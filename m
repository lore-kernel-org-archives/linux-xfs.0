Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:51168 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933305AbeEIG13 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 May 2018 02:27:29 -0400
Date: Tue, 8 May 2018 23:27:28 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 9/9] xfs: get rid of the log item descriptor
Message-ID: <20180509062728.GB25104@infradead.org>
References: <20180508034202.10136-1-david@fromorbit.com>
 <20180508034202.10136-10-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180508034202.10136-10-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

>  	/* Chase down all the log items to see if the bp is there */
> -	list_for_each_entry(lidp, &cur->bc_tp->t_items, lid_trans) {
> -		struct xfs_buf_log_item	*bip;
> -		bip = (struct xfs_buf_log_item *)lidp->lid_item;
> +	list_for_each_entry(lip, &cur->bc_tp->t_items, li_trans) {
> +		struct xfs_buf_log_item	*bip = (struct xfs_buf_log_item *)lip;
> +
>  		if (bip->bli_item.li_type == XFS_LI_BUF &&

This isn't really new in this patch, but I think this code needs to
be fixed to respect typing.  That is:

  - do the li_type check on the original log item we iterate over
  - use containe_of to get at the buf_log_item
  - possible move this code into a helper function in xfs_buf_item.c,
    where it logically belongs and can use the BUF_ITEM() helper.

but that can be done in a separate fixup patch.

Otherwise looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
