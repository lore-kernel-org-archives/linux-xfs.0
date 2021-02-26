Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40757C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Feb 2021 03:03:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E252F64EE2
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Feb 2021 03:03:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbhBZDDI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Feb 2021 22:03:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:50830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229556AbhBZDDI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Feb 2021 22:03:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D57164EE4;
        Fri, 26 Feb 2021 03:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614308547;
        bh=3t7XcB8D/4OR7STeykaKAyp/PdbDgdV6iYYuRKPgPNM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HDnjUtDHZ2ZlGZSc3KYe7Q8KB6JP8nKe1mvbS8tShF2493U6cM+3O5/X5PyGvrC7l
         lvoWKs6KBf9Bm3WjTPUGEN9dpxTaw0J7V7cRdUkXZcHoqS5pCPV0y3TSFDGpmZ+oHb
         srTCcz04TbPf9w9TS168npfwVu02+taV8EruGnUtTbXeiqOePq3N+UiSJmwpjQZ6qu
         BqgkSAGnxoxB1p5jSTPrDI+UYmPOQSDEAsbxgGdjvkrK+Ee67qpsML6bESlIgY+HXD
         Fx51p8lj5Ak8JYtBsQGq+noQ+YgEOPWyWLOJghUiwDia0+2jWqVH0JohmcOLvpGJ7D
         4NVMSCDcPq6OA==
Date:   Thu, 25 Feb 2021 19:02:27 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v15 03/22] xfs: Hoist transaction handling in
 xfs_attr_node_remove_step
Message-ID: <20210226030227.GQ7272@magnolia>
References: <20210218165348.4754-1-allison.henderson@oracle.com>
 <20210218165348.4754-4-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210218165348.4754-4-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 18, 2021 at 09:53:29AM -0700, Allison Henderson wrote:
> This patch hoists transaction handling in xfs_attr_node_removename to
> xfs_attr_node_remove_step.  This will help keep transaction handling in
> higher level functions instead of buried in subfunctions when we
> introduce delay attributes
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>

Looks ok,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c | 45 ++++++++++++++++++++++-----------------------
>  1 file changed, 22 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 4e6c89d..3cf76e2 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -1251,9 +1251,7 @@ xfs_attr_node_remove_step(
>  	struct xfs_da_args	*args,
>  	struct xfs_da_state	*state)
>  {
> -	int			retval, error;
> -	struct xfs_inode	*dp = args->dp;
> -
> +	int			error = 0;
>  
>  	/*
>  	 * If there is an out-of-line value, de-allocate the blocks.
> @@ -1265,25 +1263,6 @@ xfs_attr_node_remove_step(
>  		if (error)
>  			return error;
>  	}
> -	retval = xfs_attr_node_remove_cleanup(args, state);
> -
> -	/*
> -	 * Check to see if the tree needs to be collapsed.
> -	 */
> -	if (retval && (state->path.active > 1)) {
> -		error = xfs_da3_join(state);
> -		if (error)
> -			return error;
> -		error = xfs_defer_finish(&args->trans);
> -		if (error)
> -			return error;
> -		/*
> -		 * Commit the Btree join operation and start a new trans.
> -		 */
> -		error = xfs_trans_roll_inode(&args->trans, dp);
> -		if (error)
> -			return error;
> -	}
>  
>  	return error;
>  }
> @@ -1299,7 +1278,7 @@ xfs_attr_node_removename(
>  	struct xfs_da_args	*args)
>  {
>  	struct xfs_da_state	*state = NULL;
> -	int			error;
> +	int			retval, error;
>  	struct xfs_inode	*dp = args->dp;
>  
>  	trace_xfs_attr_node_removename(args);
> @@ -1312,6 +1291,26 @@ xfs_attr_node_removename(
>  	if (error)
>  		goto out;
>  
> +	retval = xfs_attr_node_remove_cleanup(args, state);
> +
> +	/*
> +	 * Check to see if the tree needs to be collapsed.
> +	 */
> +	if (retval && (state->path.active > 1)) {
> +		error = xfs_da3_join(state);
> +		if (error)
> +			goto out;
> +		error = xfs_defer_finish(&args->trans);
> +		if (error)
> +			goto out;
> +		/*
> +		 * Commit the Btree join operation and start a new trans.
> +		 */
> +		error = xfs_trans_roll_inode(&args->trans, dp);
> +		if (error)
> +			goto out;
> +	}
> +
>  	/*
>  	 * If the result is small enough, push it all into the inode.
>  	 */
> -- 
> 2.7.4
> 
