Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:12557 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726905AbfAQV1B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Jan 2019 16:27:01 -0500
Date: Fri, 18 Jan 2019 08:26:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] iomap: fix a use after free in iomap_dio_rw
Message-ID: <20190117212658.GD6173@dastard>
References: <20190117075707.8640-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190117075707.8640-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Chandan Rajendra <chandan@linux.ibm.com>, "Darrick J . Wong" <darrick.wong@oracle.com>

On Thu, Jan 17, 2019 at 08:57:07AM +0100, Christoph Hellwig wrote:
> Introduce a local wait_for_completion variable to avoid an access to the
> potentially freed dio struture after dropping the last reference count.
> 
> Also use the chance to document the completion behavior to make the
> refcounting clear to the reader of the code.
> 
> Fixes: ff6a9292e6 ("iomap: implement direct I/O")
> Reported-by: Chandan Rajendra <chandan@linux.ibm.com>
> Reported-by: Darrick J. Wong <darrick.wong@oracle.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Tested-by: Chandan Rajendra <chandan@linux.ibm.com>
> Tested-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/iomap.c | 28 +++++++++++++++++++++-------
>  1 file changed, 21 insertions(+), 7 deletions(-)

Looks good, minor comment cleanup needed, though. maybe Darrick can
do it on commit?

Reviewed-by: Dave Chinner <dchinner@redhat.com>

> @@ -1925,8 +1925,24 @@ iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
>  	if (dio->flags & IOMAP_DIO_WRITE_FUA)
>  		dio->flags &= ~IOMAP_DIO_NEED_SYNC;
>  
> +	/*
> +	 * We are about to drop our additional submission reference, which
> +	 * might be the last reference to the dio.  There are three three
> +	 * different ways we can progress here:
> +	 *
> +	 *  (a) If this is the last reference we will always complete and free
> +	 *	the dio ourselves. right here.

s/ right here.//

-Dave.
-- 
Dave Chinner
david@fromorbit.com
