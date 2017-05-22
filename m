Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:42777 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753262AbdEVTNW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 May 2017 15:13:22 -0400
Date: Mon, 22 May 2017 12:13:22 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3 V2] xfs: Add infrastructure needed for error
 propagation during buffer IO failure
Message-ID: <20170522191322.GD17100@infradead.org>
References: <20170522153220.25072-1-cmaiolino@redhat.com>
 <20170522153220.25072-3-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170522153220.25072-3-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: linux-xfs@vger.kernel.org

Need to read up on the history and background a bit more, but some
cosmetic comments below:

> +	lip = bp->b_fspriv;
> +	while (lip != NULL) {
> +		next = lip->li_bio_list;
> +
> +		if (lip->li_ops->iop_error)
> +			lip->li_ops->iop_error(lip, bflags);
> +
> +		lip = next;
> +	}

	for (lip = bp->b_fspriv; lip; lip = next) {
		next = lip->li_bio_list;
		if (lip->li_ops->iop_error)
			lip->li_ops->iop_error(lip, bflags);
	}

?

> @@ -1101,6 +1119,7 @@ xfs_buf_iodone_callback_error(
>  
>  		xfs_buf_ioerror(bp, 0);
>  		xfs_buf_submit(bp);
> +
>  		return true;
>  	}

whitespace noise.
