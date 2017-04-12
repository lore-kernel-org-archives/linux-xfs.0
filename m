Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:45082 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752246AbdDLIdJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Apr 2017 04:33:09 -0400
Date: Wed, 12 Apr 2017 01:33:08 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/9] Use RWF_* flags for AIO operations
Message-ID: <20170412083308.GA22363@infradead.org>
References: <20170411142619.27205-1-rgoldwyn@suse.de>
 <20170411142619.27205-2-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170411142619.27205-2-rgoldwyn@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-fsdevel@vger.kernel.org, jack@suse.com, hch@infradead.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, sagi@grimberg.me, avi@scylladb.com, axboe@kernel.dk, linux-api@vger.kernel.org, willy@infradead.org, tom.leiming@gmail.com, Goldwyn Rodrigues <rgoldwyn@suse.com>

>  
> +	if (unlikely(iocb->aio_rw_flags & ~(RWF_HIPRI | RWF_DSYNC | RWF_SYNC))) {
> +		pr_debug("EINVAL: aio_rw_flags set with incompatible flags\n");
> +		return -EINVAL;
> +	}

> +	if (iocb->aio_rw_flags & RWF_HIPRI)
> +		req->common.ki_flags |= IOCB_HIPRI;
> +	if (iocb->aio_rw_flags & RWF_DSYNC)
> +		req->common.ki_flags |= IOCB_DSYNC;
> +	if (iocb->aio_rw_flags & RWF_SYNC)
> +		req->common.ki_flags |= (IOCB_DSYNC | IOCB_SYNC);

Pleae introduce a common helper to share this code between the
synchronous and the aio path

