Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:33776 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966349AbeF1N4T (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Jun 2018 09:56:19 -0400
Date: Thu, 28 Jun 2018 06:56:05 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH V2] xfs: Initialize variables in xfs_alloc_get_rec before
 using them
Message-ID: <20180628135605.GG5711@magnolia>
References: <20180628092835.25879-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180628092835.25879-1-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jun 28, 2018 at 11:28:35AM +0200, Carlos Maiolino wrote:
> Make sure we initialize *bno and *len, before jumping to out_bad_rec
> label, and risk calling xfs_warn() with uninitialized variables.
> 
> Coverity: 100898
> Coverity: 1437081
> Coverity: 1437129
> Coverity: 1437191
> Coverity: 1437201
> Coverity: 1437212
> Coverity: 1437341
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> This is based on Darrick's suggestion, although, I believe initializing *bno and
> *len before testing if *len is empty or not is a bit more clear than changing
> xfs_warn() to use rec->alloc.ar_startblock and rec->alloc.ar_blockcount
> directly.
> 
>  fs/xfs/libxfs/xfs_alloc.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index eef466260d43..75dbdc14c45f 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -223,12 +223,13 @@ xfs_alloc_get_rec(
>  	error = xfs_btree_get_rec(cur, &rec, stat);
>  	if (error || !(*stat))
>  		return error;
> -	if (rec->alloc.ar_blockcount == 0)
> -		goto out_bad_rec;
>  
>  	*bno = be32_to_cpu(rec->alloc.ar_startblock);
>  	*len = be32_to_cpu(rec->alloc.ar_blockcount);
>  
> +	if (*len == 0)
> +		goto out_bad_rec;
> +
>  	/* check for valid extent range, including overflow */
>  	if (!xfs_verify_agbno(mp, agno, *bno))
>  		goto out_bad_rec;
> -- 
> 2.14.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
