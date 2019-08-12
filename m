Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:56340 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726610AbfHLQG7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Aug 2019 12:06:59 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CG42uH127740
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:06:58 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2u9nbt8nqf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:06:57 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CG2fss189060
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:06:57 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2u9n9h1epb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:06:57 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7CG6uW7010182
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:06:56 GMT
Date: Mon, 12 Aug 2019 09:06:55 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 08/18] xfs: Factor out xfs_attr_leaf_addname helper
Message-ID: <20190812160655.GW7138@magnolia>
References: <20190809213726.32336-1-allison.henderson@oracle.com>
 <20190809213726.32336-9-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190809213726.32336-9-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Collins <allison.henderson@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Aug 09, 2019 at 02:37:16PM -0700, Allison Collins wrote:
> Factor out new helper function xfs_attr_leaf_try_add.
> Because new delayed attribute routines cannot roll
> transactions, we carve off the parts of
> xfs_attr_leaf_addname that we can use.  This will help
> to reduce repetitive code later when we introduce
> delayed attributes.
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 43 +++++++++++++++++++++++++++++--------------
>  1 file changed, 29 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index f36c792..f9d5e28 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -635,19 +635,12 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
>   * External routines when attribute list is one block
>   *========================================================================*/
>  
> -/*
> - * Add a name to the leaf attribute list structure
> - *
> - * This leaf block cannot have a "remote" value, we only call this routine
> - * if bmap_one_block() says there is only one block (ie: no remote blks).
> - */
>  STATIC int
> -xfs_attr_leaf_addname(
> -	struct xfs_da_args	*args)
> +xfs_attr_leaf_try_add(
> +	struct xfs_da_args	*args,
> +	struct xfs_buf		*bp)
>  {
> -	struct xfs_buf		*bp;
> -	int			retval, error, forkoff;
> -	struct xfs_inode	*dp = args->dp;
> +	int			retval, error;
>  
>  	trace_xfs_attr_leaf_addname(args);
>  
> @@ -692,13 +685,35 @@ xfs_attr_leaf_addname(
>  	retval = xfs_attr3_leaf_add(bp, args);
>  	if (retval == -ENOSPC) {
>  		/*
> -		 * Promote the attribute list to the Btree format, then
> -		 * Commit that transaction so that the node_addname() call
> -		 * can manage its own transactions.
> +		 * Promote the attribute list to the Btree format,

Why does the sentence end with a comma?

>  		 */
>  		error = xfs_attr3_leaf_to_node(args);
>  		if (error)
>  			return error;
> +	}
> +	return retval;
> +}
> +
> +
> +/*
> + * Add a name to the leaf attribute list structure
> + *
> + * This leaf block cannot have a "remote" value, we only call this routine
> + * if bmap_one_block() says there is only one block (ie: no remote blks).
> + */
> +STATIC int
> +xfs_attr_leaf_addname(struct xfs_da_args	*args)
> +{
> +	int retval, error, forkoff;

Indentation problem here.

--D

> +	struct xfs_buf		*bp = NULL;
> +	struct xfs_inode	*dp = args->dp;
> +
> +	retval = xfs_attr_leaf_try_add(args, bp);
> +	if (retval == -ENOSPC) {
> +		/*
> +		 * Commit that transaction so that the node_addname() call
> +		 * can manage its own transactions.
> +		 */
>  		error = xfs_defer_finish(&args->trans);
>  		if (error)
>  			return error;
> -- 
> 2.7.4
> 
