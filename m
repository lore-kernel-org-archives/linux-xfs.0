Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:50502 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725904AbeKUDCK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Nov 2018 22:02:10 -0500
Date: Tue, 20 Nov 2018 08:32:10 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 8/7] xfs: delalloc -> unwritten COW fork allocation can
 go wrong
Message-ID: <20181120163210.GA7805@infradead.org>
References: <20181119210459.8506-1-david@fromorbit.com>
 <20181120063605.GN19305@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181120063605.GN19305@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Nov 20, 2018 at 05:36:05PM +1100, Dave Chinner wrote:
> @@ -1694,10 +1694,13 @@ xfs_bmap_add_extent_delay_real(
>  	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING | BMAP_RIGHT_CONTIG:
>  		/*
>  		 * Filling in all of a previously delayed allocation extent.
> -		 * The right neighbor is contiguous, the left is not.
> +		 * The right neighbor is contiguous, the left is not. Take care
> +		 * with delay -> unwritten extent allocation here because the
> +		 * delalloc record we are overwriting is always written.
>  		 */
>  		PREV.br_startblock = new->br_startblock;
>  		PREV.br_blockcount += RIGHT.br_blockcount;
> +		PREV.br_state = new->br_state;
>  
>  		xfs_iext_next(ifp, &bma->icur);
>  		xfs_iext_remove(bma->ip, &bma->icur, state);

Looks good, this also fixes my always_cow generic/091 failures:

Reviewed-by: Christoph Hellwig <hch@lst.de>
