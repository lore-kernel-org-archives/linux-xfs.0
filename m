Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:40928 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932118AbeF1LmN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Jun 2018 07:42:13 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EB41540131AB
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jun 2018 11:42:12 +0000 (UTC)
Date: Thu, 28 Jun 2018 07:42:09 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH V2] xfs: Initialize variables in xfs_alloc_get_rec before
 using them
Message-ID: <20180628114209.GA50785@bfoster>
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
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

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
