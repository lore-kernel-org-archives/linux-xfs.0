Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2C11C19F2D
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Aug 2022 16:59:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245156AbiHIQ7I (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Aug 2022 12:59:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243719AbiHIQ7G (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Aug 2022 12:59:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABC8F23BEF
        for <linux-xfs@vger.kernel.org>; Tue,  9 Aug 2022 09:59:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 607DFB8165D
        for <linux-xfs@vger.kernel.org>; Tue,  9 Aug 2022 16:59:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21A46C433C1;
        Tue,  9 Aug 2022 16:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660064343;
        bh=AgV/MTdKW6LsIiUj4ejuVUx9QrOI1CnrPRwEUmMH018=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=spPci7YXFl+QomBLON3Dkzp82yry0iZtS5MmFY76N//jVriITWdthWND/3IjDplZk
         Hv1yagQPryg3R5TWSZKffqiH5c3sidH3zenctMkMwI23AA9fUaGDCRReUNlBTYOJ8P
         qYCyZFfotygt0xBkV51Atk9sOShVlPxBC4AK8poMzMwfGyJt+0GZr7No/8Ff5I1Z1f
         ALqOTNF0cverdZsOpTGAuYTix8IAiLA9H5mTsW94+XEcWZKPFByuf2HoKQm+3RJZdo
         pC4wJhMhI45B08vriCb+GO3TCOgteIzItHzQxb5Alm7Gf1xdMYHaBtzQ2696JaPRod
         Ms2HelN8l03rw==
Date:   Tue, 9 Aug 2022 09:59:02 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH RESEND v2 10/18] xfs: Add xfs_verify_pptr
Message-ID: <YvKSVtUDDaHVX4AV@magnolia>
References: <20220804194013.99237-1-allison.henderson@oracle.com>
 <20220804194013.99237-11-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220804194013.99237-11-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 04, 2022 at 12:40:05PM -0700, Allison Henderson wrote:
> Attribute names of parent pointers are not strings.  So we need to modify
> attr_namecheck to verify parent pointer records when the XFS_ATTR_PARENT flag is
> set.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 43 +++++++++++++++++++++++++++++++++++++---
>  fs/xfs/libxfs/xfs_attr.h |  3 ++-
>  fs/xfs/scrub/attr.c      |  2 +-
>  fs/xfs/xfs_attr_item.c   |  6 ++++--
>  fs/xfs/xfs_attr_list.c   | 17 +++++++++++-----
>  5 files changed, 59 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 8df80d91399b..2ef3262f21e8 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -1567,9 +1567,29 @@ xfs_attr_node_get(
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

I guess I should complain about the indentation here...

STATIC bool
xfs_verify_pptr(
	struct xfs_mount		*mp,
	struct xfs_parent_name_rec	*rec)
{
	xfs_ino_t			p_ino;
	xfs_dir2_dataptr_t		p_diroffset;

	p_ino = be64_to_cpu(rec->p_ino);
	p_diroffset = be32_to_cpu(rec->p_diroffset);

(You can keep the RVB tag if you clean this up for the next revision.)

--D

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
> @@ -1584,6 +1604,23 @@ xfs_attr_namecheck(
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
> index 81be9b3e4004..af92cc57e7d8 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -547,7 +547,8 @@ int xfs_attr_get(struct xfs_da_args *args);
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
> index c13d724a3e13..69856814c066 100644
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
> @@ -727,7 +728,8 @@ xlog_recover_attri_commit_pass2(
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
> index 99bbbe1a0e44..a51f7f13a352 100644
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
>  	sf = (struct xfs_attr_shortform *)dp->i_af.if_u1.if_data;
>  	ASSERT(sf != NULL);
>  	if (!sf->hdr.count)
> @@ -82,8 +86,9 @@ xfs_attr_shortform_list(
>  	     (dp->i_af.if_bytes + sf->hdr.count * 16) < context->bufsize)) {
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
> @@ -174,8 +179,9 @@ xfs_attr_shortform_list(
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
> @@ -465,7 +471,8 @@ xfs_attr3_leaf_list_int(
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
