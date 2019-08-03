Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:53818 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387950AbfHCQe6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 3 Aug 2019 12:34:58 -0400
Date: Sat, 3 Aug 2019 09:34:39 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] iomap: Fix trivial typo
Message-ID: <20190803163439.GL7138@magnolia>
References: <20190803135502.19572-1-agruenba@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190803135502.19572-1-agruenba@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Sat, Aug 03, 2019 at 03:55:02PM +0200, Andreas Gruenbacher wrote:
> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/iomap/buffered-io.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index ba0511131868..4ab1ec0a282f 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -1258,7 +1258,7 @@ static void iomap_writepage_end_bio(struct bio *bio)
>   * all bios have been submitted and the ioend is really done.
>   *
>   * If @error is non-zero, it means that we have a situation where some part of
> - * the submission process has failed after we have marked paged for writeback
> + * the submission process has failed after we have marked pages for writeback
>   * and unlocked them. In this situation, we need to fail the bio and ioend
>   * rather than submit it to IO. This typically only happens on a filesystem
>   * shutdown.
> -- 
> 2.20.1
> 
