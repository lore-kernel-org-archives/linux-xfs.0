Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E68BDC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jun 2022 18:35:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbiF2SfI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 14:35:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbiF2SfH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 14:35:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD835393C9
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 11:35:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A8B061F5B
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 18:35:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0811C34114;
        Wed, 29 Jun 2022 18:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656527702;
        bh=l1WEbvG/tlOeFKXTElIv57lC7vAGWQE80En+KV/31ws=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=O3yy7WylBZ7nZmwPX4SX80b2hHgeS3C7iTkKtOf2xPMh0czJAEr0l+TzsC4Z5yRv6
         AA3L4MghOpnHciuk0l3WWyez69FMY8SQIJuBLowJRDFEw4a7B+qHefz8PUomDhmkhW
         aRHNP3lTfUIxeWF4oFWafPeAHTTpSQXCrOOr38vydY2lQc7UeUWHdEaw0xQhIex+La
         7BQx/gwFRS+zK3hHp4Jkid/rLUBeKNmRKazHkAVH23IRI5uIw5Dg+9IOQkoB6ZvBNt
         +BzbdMeCeaEsIXS3qRsYgmHj+Tbvs/U0hCCJRYaOfLEQUi8Hq81e7CWd3Lks0AdLOs
         h8TA8DpBAqKhw==
Date:   Wed, 29 Jun 2022 11:35:02 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v1 08/17] xfs: Add xfs_verify_pptr
Message-ID: <YrybVkIAaBBtNR4w@magnolia>
References: <20220611094200.129502-1-allison.henderson@oracle.com>
 <20220611094200.129502-9-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220611094200.129502-9-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jun 11, 2022 at 02:41:51AM -0700, Allison Henderson wrote:
> Attribute names of parent pointers are not strings.  So we need to modify
> attr_namecheck to verify parent pointer records when the XFS_ATTR_PARENT flag is
> set.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>

Looks good,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c | 43 +++++++++++++++++++++++++++++++++++++---
>  fs/xfs/libxfs/xfs_attr.h |  3 ++-
>  fs/xfs/scrub/attr.c      |  2 +-
>  fs/xfs/xfs_attr_item.c   |  6 ++++--
>  fs/xfs/xfs_attr_list.c   | 17 +++++++++++-----
>  5 files changed, 59 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index ee5dfebcf163..30c8d9e9c2f1 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -1606,9 +1606,29 @@ xfs_attr_node_get(
>  	return error;
>  }
>  
> -/* Returns true if the attribute entry name is valid. */
> -bool
> -xfs_attr_namecheck(
> +/*
> + * Verify parent pointer attribute is valid.
> + * Return true on success or false on failure
> + */
> +STATIC bool
> +xfs_verify_pptr(struct xfs_mount *mp, struct xfs_parent_name_rec *rec)
> +{
> +	xfs_ino_t p_ino = (xfs_ino_t)be64_to_cpu(rec->p_ino);
> +	xfs_dir2_dataptr_t p_diroffset =
> +		(xfs_dir2_dataptr_t)be32_to_cpu(rec->p_diroffset);
> +
> +	if (!xfs_verify_ino(mp, p_ino))
> +		return false;
> +
> +	if (p_diroffset > XFS_DIR2_MAX_DATAPTR)
> +		return false;
> +
> +	return true;
> +}
> +
> +/* Returns true if the string attribute entry name is valid. */
> +static bool
> +xfs_str_attr_namecheck(
>  	const void	*name,
>  	size_t		length)
>  {
> @@ -1623,6 +1643,23 @@ xfs_attr_namecheck(
>  	return !memchr(name, 0, length);
>  }
>  
> +/* Returns true if the attribute entry name is valid. */
> +bool
> +xfs_attr_namecheck(
> +	struct xfs_mount	*mp,
> +	const void		*name,
> +	size_t			length,
> +	int			flags)
> +{
> +	if (flags & XFS_ATTR_PARENT) {
> +		if (length != sizeof(struct xfs_parent_name_rec))
> +			return false;
> +		return xfs_verify_pptr(mp, (struct xfs_parent_name_rec *)name);
> +	}
> +
> +	return xfs_str_attr_namecheck(name, length);
> +}
> +
>  int __init
>  xfs_attr_intent_init_cache(void)
>  {
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index 7600eac74db7..a87bc503976b 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -562,7 +562,8 @@ int xfs_attr_get(struct xfs_da_args *args);
>  int xfs_attr_set(struct xfs_da_args *args);
>  int xfs_attr_set_iter(struct xfs_attr_intent *attr);
>  int xfs_attr_remove_iter(struct xfs_attr_intent *attr);
> -bool xfs_attr_namecheck(const void *name, size_t length);
> +bool xfs_attr_namecheck(struct xfs_mount *mp, const void *name, size_t length,
> +			int flags);
>  int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
>  void xfs_init_attr_trans(struct xfs_da_args *args, struct xfs_trans_res *tres,
>  			 unsigned int *total);
> diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
> index b6f0c9f3f124..d3e75c077fab 100644
> --- a/fs/xfs/scrub/attr.c
> +++ b/fs/xfs/scrub/attr.c
> @@ -128,7 +128,7 @@ xchk_xattr_listent(
>  	}
>  
>  	/* Does this name make sense? */
> -	if (!xfs_attr_namecheck(name, namelen)) {
> +	if (!xfs_attr_namecheck(sx->sc->mp, name, namelen, flags)) {
>  		xchk_fblock_set_corrupt(sx->sc, XFS_ATTR_FORK, args.blkno);
>  		return;
>  	}
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> index f524dbbb42d3..60fee5814655 100644
> --- a/fs/xfs/xfs_attr_item.c
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -587,7 +587,8 @@ xfs_attri_item_recover(
>  	 */
>  	attrp = &attrip->attri_format;
>  	if (!xfs_attri_validate(mp, attrp) ||
> -	    !xfs_attr_namecheck(nv->name.i_addr, nv->name.i_len))
> +	    !xfs_attr_namecheck(mp, nv->name.i_addr, nv->name.i_len,
> +				attrp->alfi_attr_filter))
>  		return -EFSCORRUPTED;
>  
>  	error = xlog_recover_iget(mp,  attrp->alfi_ino, &ip);
> @@ -742,7 +743,8 @@ xlog_recover_attri_commit_pass2(
>  		return -EFSCORRUPTED;
>  	}
>  
> -	if (!xfs_attr_namecheck(attr_name, attri_formatp->alfi_name_len)) {
> +	if (!xfs_attr_namecheck(mp, attr_name, attri_formatp->alfi_name_len,
> +				attri_formatp->alfi_attr_filter)) {
>  		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
>  		return -EFSCORRUPTED;
>  	}
> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
> index 90a14e85e76d..3bac0647a927 100644
> --- a/fs/xfs/xfs_attr_list.c
> +++ b/fs/xfs/xfs_attr_list.c
> @@ -58,9 +58,13 @@ xfs_attr_shortform_list(
>  	struct xfs_attr_sf_sort		*sbuf, *sbp;
>  	struct xfs_attr_shortform	*sf;
>  	struct xfs_attr_sf_entry	*sfe;
> +	struct xfs_mount		*mp;
>  	int				sbsize, nsbuf, count, i;
>  	int				error = 0;
>  
> +	ASSERT(context != NULL);
> +	ASSERT(dp != NULL);
> +	mp = dp->i_mount;
>  	ASSERT(dp->i_afp != NULL);
>  	sf = (struct xfs_attr_shortform *)dp->i_afp->if_u1.if_data;
>  	ASSERT(sf != NULL);
> @@ -83,8 +87,9 @@ xfs_attr_shortform_list(
>  	     (dp->i_afp->if_bytes + sf->hdr.count * 16) < context->bufsize)) {
>  		for (i = 0, sfe = &sf->list[0]; i < sf->hdr.count; i++) {
>  			if (XFS_IS_CORRUPT(context->dp->i_mount,
> -					   !xfs_attr_namecheck(sfe->nameval,
> -							       sfe->namelen)))
> +					   !xfs_attr_namecheck(mp, sfe->nameval,
> +							       sfe->namelen,
> +							       sfe->flags)))
>  				return -EFSCORRUPTED;
>  			context->put_listent(context,
>  					     sfe->flags,
> @@ -175,8 +180,9 @@ xfs_attr_shortform_list(
>  			cursor->offset = 0;
>  		}
>  		if (XFS_IS_CORRUPT(context->dp->i_mount,
> -				   !xfs_attr_namecheck(sbp->name,
> -						       sbp->namelen))) {
> +				   !xfs_attr_namecheck(mp, sbp->name,
> +						       sbp->namelen,
> +						       sbp->flags))) {
>  			error = -EFSCORRUPTED;
>  			goto out;
>  		}
> @@ -466,7 +472,8 @@ xfs_attr3_leaf_list_int(
>  		}
>  
>  		if (XFS_IS_CORRUPT(context->dp->i_mount,
> -				   !xfs_attr_namecheck(name, namelen)))
> +				   !xfs_attr_namecheck(mp, name, namelen,
> +						       entry->flags)))
>  			return -EFSCORRUPTED;
>  		context->put_listent(context, entry->flags,
>  					      name, namelen, valuelen);
> -- 
> 2.25.1
> 
