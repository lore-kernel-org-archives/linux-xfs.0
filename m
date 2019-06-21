Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:50530 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726058AbfFUX7Z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jun 2019 19:59:25 -0400
Date: Fri, 21 Jun 2019 16:59:06 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 04/11] xfs: always update params on small allocation
Message-ID: <20190621235906.GC5387@magnolia>
References: <20190522180546.17063-1-bfoster@redhat.com>
 <20190522180546.17063-5-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190522180546.17063-5-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Wed, May 22, 2019 at 02:05:39PM -0400, Brian Foster wrote:
> xfs_alloc_ag_vextent_small() doesn't update the output parameters in
> the event of an AGFL allocation. Instead, it updates the
> xfs_alloc_arg structure directly to complete the allocation.
> 
> Update both args and the output params to provide consistent
> behavior for future callers.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_alloc.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 436f8eb0bc4c..e2fa58f4d477 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -759,8 +759,8 @@ xfs_alloc_ag_vextent_small(
>  		}
>  		xfs_trans_binval(args->tp, bp);
>  	}
> -	args->len = 1;
> -	args->agbno = fbno;
> +	*fbnop = args->agbno = fbno;
> +	*flenp = args->len = 1;
>  	XFS_WANT_CORRUPTED_GOTO(args->mp,
>  		fbno < be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_length),
>  		error);
> -- 
> 2.17.2
> 
