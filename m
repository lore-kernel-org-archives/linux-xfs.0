Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:33116 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726409AbeJFR17 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 6 Oct 2018 13:27:59 -0400
Date: Sat, 6 Oct 2018 03:25:14 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3] xfs: always assign buffer verifiers when one is
 provided
Message-ID: <20181006102514.GA14903@infradead.org>
References: <153870045847.29695.10286947858219936840.stgit@magnolia>
 <153870047100.29695.14645106534029933489.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153870047100.29695.14645106534029933489.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

> @@ -385,4 +385,7 @@ extern int xfs_setsize_buftarg(xfs_buftarg_t *, unsigned int);
>  #define xfs_getsize_buftarg(buftarg)	block_size((buftarg)->bt_bdev)
>  #define xfs_readonly_buftarg(buftarg)	bdev_read_only((buftarg)->bt_bdev)
>  
> +extern int xfs_buf_ensure_ops(struct xfs_buf *bp,
> +		const struct xfs_buf_ops *ops);

While we are nitpicking: no need to have an extern in function
prototypes ever.

Modulo that and the nitpicks from Brian this looks fine to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>
