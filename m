Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAB3DC47082
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Jun 2021 16:26:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE597613BE
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Jun 2021 16:26:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233811AbhFGQ2s (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Jun 2021 12:28:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:33386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234260AbhFGQZh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 7 Jun 2021 12:25:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96E206140D;
        Mon,  7 Jun 2021 16:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082825;
        bh=LY5pl6UfsPx8hs2oLH65+YNVjb4vDo9dojXnaZoi3JQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UkGrZ0jcdhG0UD/cPmMPgI5AWr7RsmxCgFHiF0cblpKeh/hSUkfPw4AGfYCgshJ/N
         SEEhVLfGlDEIYUs6qCF2VssprVtIN/0j/cSU0PcJSLiNzUyXf/qK/ggGOIFC6dVjXR
         icXLSk+NC7nyxshT9xCCjvzRJddlhW7R7CPtPHiTGuQVSlcxQqOENqr8q6huhNGr/V
         wz2uApNRx9Rz/RpMZYErp57/VqaxYK5Py3LzPyjZVCYu02pmQ2YowZKEk9SPBgtSyO
         vWvgi9lSyeCSxkjy6KCsoGXAPXlovnX5ofNtRBC/Ntf1/YketBwI0oTtHSIpM+rImf
         aq8T6V/L9UqqQ==
Date:   Mon, 7 Jun 2021 09:20:25 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v20 14/14] xfs: Make attr name schemes consistent
Message-ID: <20210607162025.GL2945738@locust>
References: <20210607052747.31422-1-allison.henderson@oracle.com>
 <20210607052747.31422-5-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210607052747.31422-5-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jun 06, 2021 at 10:27:47PM -0700, Allison Henderson wrote:
> This patch renames the following functions to make the nameing scheme more consistent:
> xfs_attr_shortform_remove -> xfs_attr_sf_removename
> xfs_attr_node_remove_name -> xfs_attr_node_removename
> xfs_attr_set_fmt -> xfs_attr_sf_addname
> 
> Suggested-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c      | 18 +++++++++---------
>  fs/xfs/libxfs/xfs_attr_leaf.c |  2 +-
>  fs/xfs/libxfs/xfs_attr_leaf.h |  2 +-
>  3 files changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index a0edebc..611dc67 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -63,8 +63,8 @@ STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
>  STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
>  STATIC int xfs_attr_set_iter(struct xfs_delattr_context *dac,
>  			     struct xfs_buf **leaf_bp);
> -STATIC int xfs_attr_node_remove_name(struct xfs_da_args *args,
> -				     struct xfs_da_state *state);
> +STATIC int xfs_attr_node_removename(struct xfs_da_args *args,
> +				    struct xfs_da_state *state);
>  
>  int
>  xfs_inode_hasattr(
> @@ -298,7 +298,7 @@ xfs_attr_set_args(
>  }
>  
>  STATIC int
> -xfs_attr_set_fmt(
> +xfs_attr_sf_addname(
>  	struct xfs_delattr_context	*dac,
>  	struct xfs_buf			**leaf_bp)
>  {
> @@ -367,7 +367,7 @@ xfs_attr_set_iter(
>  		 * release the hold once we return with a clean transaction.
>  		 */
>  		if (xfs_attr_is_shortform(dp))
> -			return xfs_attr_set_fmt(dac, leaf_bp);
> +			return xfs_attr_sf_addname(dac, leaf_bp);
>  		if (*leaf_bp != NULL) {
>  			xfs_trans_bhold_release(args->trans, *leaf_bp);
>  			*leaf_bp = NULL;
> @@ -840,7 +840,7 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
>  	if (retval == -EEXIST) {
>  		if (args->attr_flags & XATTR_CREATE)
>  			return retval;
> -		retval = xfs_attr_shortform_remove(args);
> +		retval = xfs_attr_sf_removename(args);
>  		if (retval)
>  			return retval;
>  		/*
> @@ -1223,7 +1223,7 @@ xfs_attr_node_addname_clear_incomplete(
>  	if (error)
>  		goto out;
>  
> -	error = xfs_attr_node_remove_name(args, state);
> +	error = xfs_attr_node_removename(args, state);
>  
>  	/*
>  	 * Check to see if the tree needs to be collapsed.
> @@ -1339,7 +1339,7 @@ int xfs_attr_node_removename_setup(
>  }
>  
>  STATIC int
> -xfs_attr_node_remove_name(
> +xfs_attr_node_removename(
>  	struct xfs_da_args	*args,
>  	struct xfs_da_state	*state)
>  {
> @@ -1390,7 +1390,7 @@ xfs_attr_remove_iter(
>  		 * thus state transitions. Call the right helper and return.
>  		 */
>  		if (dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL)
> -			return xfs_attr_shortform_remove(args);
> +			return xfs_attr_sf_removename(args);
>  
>  		if (xfs_attr_is_leaf(dp))
>  			return xfs_attr_leaf_removename(args);
> @@ -1453,7 +1453,7 @@ xfs_attr_remove_iter(
>  				goto out;
>  		}
>  
> -		retval = xfs_attr_node_remove_name(args, state);
> +		retval = xfs_attr_node_removename(args, state);
>  
>  		/*
>  		 * Check to see if the tree needs to be collapsed. If so, roll
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index d97de20..5a3d261 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -773,7 +773,7 @@ xfs_attr_fork_remove(
>   * Remove an attribute from the shortform attribute list structure.
>   */
>  int
> -xfs_attr_shortform_remove(
> +xfs_attr_sf_removename(
>  	struct xfs_da_args		*args)
>  {
>  	struct xfs_attr_shortform	*sf;
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
> index 9b1c59f..efa757f 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.h
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.h
> @@ -51,7 +51,7 @@ int	xfs_attr_shortform_lookup(struct xfs_da_args *args);
>  int	xfs_attr_shortform_getvalue(struct xfs_da_args *args);
>  int	xfs_attr_shortform_to_leaf(struct xfs_da_args *args,
>  			struct xfs_buf **leaf_bp);
> -int	xfs_attr_shortform_remove(struct xfs_da_args *args);
> +int	xfs_attr_sf_removename(struct xfs_da_args *args);
>  int	xfs_attr_sf_findname(struct xfs_da_args *args,
>  			     struct xfs_attr_sf_entry **sfep,
>  			     unsigned int *basep);
> -- 
> 2.7.4
> 
