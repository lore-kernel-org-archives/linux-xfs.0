Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D55C4C32772
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Aug 2022 17:40:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbiHWRkO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Aug 2022 13:40:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231891AbiHWRjf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Aug 2022 13:39:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4645A74F3
        for <linux-xfs@vger.kernel.org>; Tue, 23 Aug 2022 08:27:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2730AB81CED
        for <linux-xfs@vger.kernel.org>; Tue, 23 Aug 2022 15:27:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D42F0C433C1;
        Tue, 23 Aug 2022 15:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661268474;
        bh=XP0JVQXwewdDxmbDSSAGbc3hiY/0e4ksFdKmFLLOr+E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aekHKuYbwDJII8RycAT9hn+UTMAmKCEx/lgSz4sTa/K9ibo9OKUj5w0isld6Qieha
         KO4fRwIEaKaCA5kTtwvZRyJstb9auT9Y1jKqFdjhcsgZhvvHSGqPyojChSx1CwXvuT
         cUXhjTUhfIUXoY4wmCd9scrqYmoSczshicMpuQCdW38c9250Wy0Vj3N9KTK26du1rf
         OtHMEPK+tgmC9kloCmXdFFMwvr6izm8+FyAP9+rbUlHzTb262VABG4F+1bOLWEDETp
         hb4eJw/O7aphIksE5VWH1wA10aCYF/KTDjntLHV5vmJss5hrEHuDgPz+kdsj2Rx/rd
         pm5N/i+NYz9Cw==
Date:   Tue, 23 Aug 2022 08:27:54 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: Add new name to attri/d
Message-ID: <YwTx+k8G4IijFDRA@magnolia>
References: <20220816173506.113779-1-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220816173506.113779-1-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 16, 2022 at 10:35:06AM -0700, Allison Henderson wrote:
> This patch adds two new fields to the atti/d.  They are nname and
> nnamelen.  This will be used for parent pointer updates since a
> rename operation may cause the parent pointer to update both the
> name and value.  So we need to carry both the new name as well as
> the target name in the attri/d.
> 
> As discussed in the reviews, I've added a new XFS_ATTRI_OP_FLAGS*
> type: XFS_ATTRI_OP_FLAGS_NRENAME.  However, I do not think it is

How about "NVREPLACE", since we're replacing the name and value?

> needed, since args->new_namelen is always available.  I've left the
> new type in for people to discuss, but unless we find a use for it
> int the reviews, my recommendation would be to remove it and use
> the existing XFS_ATTRI_OP_FLAGS_RENAME with a check for
> args->new_namelen > 0.

I think it's worth the extra bit of redundancy to encode both a new op
flag and a nonzero new_namelen.  xfs_attri_validate probably ought to
check that alfi_value_len==0 if op == XFS_ATTRI_OP_FLAGS_REMOVE.

Also -- should xlog_recover_attri_commit_pass2 be checking that
@item->ri_total is 2 for a REMOVE, 3 for a SET or REPLACE, or 4 for an
NRENAME operation to make sure that the number of log iovec items
matches what the log item says should be there?

I /think/ the log recovery code already sets item->ri_total to
alfi_size, and won't recover the item if it doesn't find that number of
iovecs?

> Feedback appreciated.  Thanks all!
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c       | 12 +++++-
>  fs/xfs/libxfs/xfs_attr.h       |  4 +-
>  fs/xfs/libxfs/xfs_da_btree.h   |  2 +
>  fs/xfs/libxfs/xfs_log_format.h |  5 ++-
>  fs/xfs/xfs_attr_item.c         | 71 ++++++++++++++++++++++++++++------
>  fs/xfs/xfs_attr_item.h         |  1 +
>  fs/xfs/xfs_ondisk.h            |  2 +-
>  7 files changed, 81 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index e28d93d232de..9f2fb4903b71 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -423,6 +423,12 @@ xfs_attr_complete_op(
>  	args->op_flags &= ~XFS_DA_OP_REPLACE;
>  	if (do_replace) {
>  		args->attr_filter &= ~XFS_ATTR_INCOMPLETE;
> +		if (args->new_namelen > 0) {
> +			args->name = args->new_name;
> +			args->namelen = args->new_namelen;
> +			args->hashval = xfs_da_hashname(args->name,
> +							args->namelen);
> +		}
>  		return replace_state;
>  	}
>  	return XFS_DAS_DONE;
> @@ -922,9 +928,13 @@ xfs_attr_defer_replace(
>  	struct xfs_da_args	*args)
>  {
>  	struct xfs_attr_intent	*new;
> +	int			op_flag;
>  	int			error = 0;
>  
> -	error = xfs_attr_intent_init(args, XFS_ATTRI_OP_FLAGS_REPLACE, &new);
> +	op_flag = args->new_namelen == 0 ? XFS_ATTRI_OP_FLAGS_REPLACE :
> +		  XFS_ATTRI_OP_FLAGS_NREPLACE;
> +
> +	error = xfs_attr_intent_init(args, op_flag, &new);
>  	if (error)
>  		return error;
>  
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index 81be9b3e4004..3e81f3f48560 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -510,8 +510,8 @@ struct xfs_attr_intent {
>  	struct xfs_da_args		*xattri_da_args;
>  
>  	/*
> -	 * Shared buffer containing the attr name and value so that the logging
> -	 * code can share large memory buffers between log items.
> +	 * Shared buffer containing the attr name, new name, and value so that
> +	 * the logging code can share large memory buffers between log items.
>  	 */
>  	struct xfs_attri_log_nameval	*xattri_nameval;
>  
> diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
> index ffa3df5b2893..e9fb801844f2 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.h
> +++ b/fs/xfs/libxfs/xfs_da_btree.h
> @@ -56,6 +56,8 @@ typedef struct xfs_da_args {
>  	struct xfs_da_geometry *geo;	/* da block geometry */
>  	const uint8_t		*name;		/* string (maybe not NULL terminated) */
>  	int		namelen;	/* length of string (maybe no NULL) */
> +	const uint8_t	*new_name;	/* new attr name */
> +	int		new_namelen;	/* new attr name len */

I think the pointers and ints should go together to compact this
structure, and possibly that the da_args should get its own slab for
faster allocation.  Neither of those cleanups should be in this patch.

>  	uint8_t		filetype;	/* filetype of inode for directories */
>  	void		*value;		/* set of bytes (maybe contain NULLs) */
>  	int		valuelen;	/* length of value */
> diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
> index b351b9dc6561..8a22f315532c 100644
> --- a/fs/xfs/libxfs/xfs_log_format.h
> +++ b/fs/xfs/libxfs/xfs_log_format.h
> @@ -117,7 +117,8 @@ struct xfs_unmount_log_format {
>  #define XLOG_REG_TYPE_ATTRD_FORMAT	28
>  #define XLOG_REG_TYPE_ATTR_NAME	29
>  #define XLOG_REG_TYPE_ATTR_VALUE	30
> -#define XLOG_REG_TYPE_MAX		30
> +#define XLOG_REG_TYPE_ATTR_NNAME	31
> +#define XLOG_REG_TYPE_MAX		31
>  
>  
>  /*
> @@ -909,6 +910,7 @@ struct xfs_icreate_log {
>  #define XFS_ATTRI_OP_FLAGS_SET		1	/* Set the attribute */
>  #define XFS_ATTRI_OP_FLAGS_REMOVE	2	/* Remove the attribute */
>  #define XFS_ATTRI_OP_FLAGS_REPLACE	3	/* Replace the attribute */
> +#define XFS_ATTRI_OP_FLAGS_NREPLACE	4	/* Replace attr name and val */
>  #define XFS_ATTRI_OP_FLAGS_TYPE_MASK	0xFF	/* Flags type mask */
>  
>  /*
> @@ -931,6 +933,7 @@ struct xfs_attri_log_format {
>  	uint64_t	alfi_ino;	/* the inode for this attr operation */
>  	uint32_t	alfi_op_flags;	/* marks the op as a set or remove */
>  	uint32_t	alfi_name_len;	/* attr name length */
> +	uint32_t	alfi_nname_len;	/* attr new name length */

As I said in the other thread, this new field should replace alfi_pad,
for no net gain to the structure size.

>  	uint32_t	alfi_value_len;	/* attr value length */
>  	uint32_t	alfi_attr_filter;/* attr filter flags */
>  };
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> index 5077a7ad5646..40cbc95bf9b5 100644
> --- a/fs/xfs/xfs_attr_item.c
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -75,6 +75,8 @@ static inline struct xfs_attri_log_nameval *
>  xfs_attri_log_nameval_alloc(
>  	const void			*name,
>  	unsigned int			name_len,
> +	const void			*nname,
> +	unsigned int			nname_len,
>  	const void			*value,
>  	unsigned int			value_len)
>  {
> @@ -85,7 +87,7 @@ xfs_attri_log_nameval_alloc(
>  	 * this. But kvmalloc() utterly sucks, so we use our own version.
>  	 */
>  	nv = xlog_kvmalloc(sizeof(struct xfs_attri_log_nameval) +
> -					name_len + value_len);
> +					name_len + nname_len + value_len);
>  	if (!nv)
>  		return nv;
>  
> @@ -94,8 +96,18 @@ xfs_attri_log_nameval_alloc(
>  	nv->name.i_type = XLOG_REG_TYPE_ATTR_NAME;
>  	memcpy(nv->name.i_addr, name, name_len);
>  
> +	if (nname_len) {
> +		nv->nname.i_addr = nv->name.i_addr + name_len;
> +		nv->nname.i_len = nname_len;
> +		memcpy(nv->nname.i_addr, nname, nname_len);
> +	} else {
> +		nv->nname.i_addr = NULL;
> +		nv->nname.i_len = 0;
> +	}
> +	nv->nname.i_type = XLOG_REG_TYPE_ATTR_NNAME;
> +
>  	if (value_len) {
> -		nv->value.i_addr = nv->name.i_addr + name_len;
> +		nv->value.i_addr = nv->name.i_addr + nname_len + name_len;
>  		nv->value.i_len = value_len;
>  		memcpy(nv->value.i_addr, value, value_len);
>  	} else {
> @@ -149,11 +161,15 @@ xfs_attri_item_size(
>  	*nbytes += sizeof(struct xfs_attri_log_format) +
>  			xlog_calc_iovec_len(nv->name.i_len);
>  
> -	if (!nv->value.i_len)
> -		return;
> +	if (nv->nname.i_len) {
> +		*nvecs += 1;
> +		*nbytes += xlog_calc_iovec_len(nv->nname.i_len);
> +	}
>  
> -	*nvecs += 1;
> -	*nbytes += xlog_calc_iovec_len(nv->value.i_len);
> +	if (nv->value.i_len) {
> +		*nvecs += 1;
> +		*nbytes += xlog_calc_iovec_len(nv->value.i_len);
> +	}
>  }
>  
>  /*
> @@ -183,6 +199,9 @@ xfs_attri_item_format(
>  	ASSERT(nv->name.i_len > 0);
>  	attrip->attri_format.alfi_size++;
>  
> +	if (nv->nname.i_len > 0)
> +		attrip->attri_format.alfi_size++;
> +
>  	if (nv->value.i_len > 0)
>  		attrip->attri_format.alfi_size++;
>  
> @@ -190,6 +209,10 @@ xfs_attri_item_format(
>  			&attrip->attri_format,
>  			sizeof(struct xfs_attri_log_format));
>  	xlog_copy_from_iovec(lv, &vecp, &nv->name);
> +
> +	if (nv->nname.i_len > 0)
> +		xlog_copy_from_iovec(lv, &vecp, &nv->nname);
> +
>  	if (nv->value.i_len > 0)
>  		xlog_copy_from_iovec(lv, &vecp, &nv->value);
>  }
> @@ -398,6 +421,7 @@ xfs_attr_log_item(
>  	attrp->alfi_op_flags = attr->xattri_op_flags;
>  	attrp->alfi_value_len = attr->xattri_nameval->value.i_len;
>  	attrp->alfi_name_len = attr->xattri_nameval->name.i_len;
> +	attrp->alfi_nname_len = attr->xattri_nameval->nname.i_len;
>  	ASSERT(!(attr->xattri_da_args->attr_filter & ~XFS_ATTRI_FILTER_MASK));
>  	attrp->alfi_attr_filter = attr->xattri_da_args->attr_filter;
>  }
> @@ -439,7 +463,8 @@ xfs_attr_create_intent(
>  		 * deferred work state structure.
>  		 */
>  		attr->xattri_nameval = xfs_attri_log_nameval_alloc(args->name,
> -				args->namelen, args->value, args->valuelen);
> +				args->namelen, args->new_name,
> +				args->new_namelen, args->value, args->valuelen);
>  	}
>  	if (!attr->xattri_nameval)
>  		return ERR_PTR(-ENOMEM);
> @@ -543,6 +568,7 @@ xfs_attri_validate(
>  	case XFS_ATTRI_OP_FLAGS_SET:
>  	case XFS_ATTRI_OP_FLAGS_REPLACE:
>  	case XFS_ATTRI_OP_FLAGS_REMOVE:
> +	case XFS_ATTRI_OP_FLAGS_NREPLACE:
>  		break;
>  	default:
>  		return false;
> @@ -552,6 +578,7 @@ xfs_attri_validate(
>  		return false;
>  
>  	if ((attrp->alfi_name_len > XATTR_NAME_MAX) ||
> +	    (attrp->alfi_nname_len > XATTR_NAME_MAX) ||
>  	    (attrp->alfi_name_len == 0))
>  		return false;
>  
> @@ -615,6 +642,8 @@ xfs_attri_item_recover(
>  	args->whichfork = XFS_ATTR_FORK;
>  	args->name = nv->name.i_addr;
>  	args->namelen = nv->name.i_len;
> +	args->new_name = nv->nname.i_addr;
> +	args->new_namelen = nv->nname.i_len;
>  	args->hashval = xfs_da_hashname(args->name, args->namelen);
>  	args->attr_filter = attrp->alfi_attr_filter & XFS_ATTRI_FILTER_MASK;
>  	args->op_flags = XFS_DA_OP_RECOVERY | XFS_DA_OP_OKNOENT |
> @@ -625,6 +654,7 @@ xfs_attri_item_recover(
>  	switch (attr->xattri_op_flags) {
>  	case XFS_ATTRI_OP_FLAGS_SET:
>  	case XFS_ATTRI_OP_FLAGS_REPLACE:
> +	case XFS_ATTRI_OP_FLAGS_NREPLACE:
>  		args->value = nv->value.i_addr;
>  		args->valuelen = nv->value.i_len;
>  		args->total = xfs_attr_calc_size(args, &local);
> @@ -714,6 +744,7 @@ xfs_attri_item_relog(
>  	new_attrp->alfi_op_flags = old_attrp->alfi_op_flags;
>  	new_attrp->alfi_value_len = old_attrp->alfi_value_len;
>  	new_attrp->alfi_name_len = old_attrp->alfi_name_len;
> +	new_attrp->alfi_nname_len = old_attrp->alfi_nname_len;
>  	new_attrp->alfi_attr_filter = old_attrp->alfi_attr_filter;
>  
>  	xfs_trans_add_item(tp, &new_attrip->attri_item);
> @@ -735,10 +766,15 @@ xlog_recover_attri_commit_pass2(
>  	struct xfs_attri_log_nameval	*nv;
>  	const void			*attr_value = NULL;
>  	const void			*attr_name;
> +	const void			*attr_nname = NULL;
> +	int				i = 0;
>  	int                             error;
>  
> -	attri_formatp = item->ri_buf[0].i_addr;
> -	attr_name = item->ri_buf[1].i_addr;
> +	attri_formatp = item->ri_buf[i].i_addr;
> +	i++;
> +
> +	attr_name = item->ri_buf[i].i_addr;
> +	i++;
>  
>  	/* Validate xfs_attri_log_format before the large memory allocation */
>  	if (!xfs_attri_validate(mp, attri_formatp)) {
> @@ -751,8 +787,20 @@ xlog_recover_attri_commit_pass2(
>  		return -EFSCORRUPTED;
>  	}
>  
> +	if (attri_formatp->alfi_nname_len) {
> +		attr_nname = item->ri_buf[i].i_addr;
> +		i++;

/me wonders if the recovery function should check item->ri_buf[i].i_type
to ensure that nobody's switched the order on us, but can't confirm that
the i_type ever gets used anywhere.  I don't see it in the ondisk format
documentation, so this might just be a wild goose chase.

Sorry it took me a week to get to this. :/

--D

> +
> +		if (!xfs_attr_namecheck(mp, attr_nname,
> +				attri_formatp->alfi_nname_len,
> +				attri_formatp->alfi_attr_filter)) {
> +			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
> +			return -EFSCORRUPTED;
> +		}
> +	}
> +
>  	if (attri_formatp->alfi_value_len)
> -		attr_value = item->ri_buf[2].i_addr;
> +		attr_value = item->ri_buf[i].i_addr;
>  
>  	/*
>  	 * Memory alloc failure will cause replay to abort.  We attach the
> @@ -760,7 +808,8 @@ xlog_recover_attri_commit_pass2(
>  	 * reference.
>  	 */
>  	nv = xfs_attri_log_nameval_alloc(attr_name,
> -			attri_formatp->alfi_name_len, attr_value,
> +			attri_formatp->alfi_name_len, attr_nname,
> +			attri_formatp->alfi_nname_len, attr_value,
>  			attri_formatp->alfi_value_len);
>  	if (!nv)
>  		return -ENOMEM;
> diff --git a/fs/xfs/xfs_attr_item.h b/fs/xfs/xfs_attr_item.h
> index 3280a7930287..24d4968dd6cc 100644
> --- a/fs/xfs/xfs_attr_item.h
> +++ b/fs/xfs/xfs_attr_item.h
> @@ -13,6 +13,7 @@ struct kmem_zone;
>  
>  struct xfs_attri_log_nameval {
>  	struct xfs_log_iovec	name;
> +	struct xfs_log_iovec	nname;
>  	struct xfs_log_iovec	value;
>  	refcount_t		refcount;
>  
> diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
> index 758702b9495f..97d4ebedcf40 100644
> --- a/fs/xfs/xfs_ondisk.h
> +++ b/fs/xfs/xfs_ondisk.h
> @@ -132,7 +132,7 @@ xfs_check_ondisk_structs(void)
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_inode_log_format,	56);
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_qoff_logformat,	20);
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_trans_header,		16);
> -	XFS_CHECK_STRUCT_SIZE(struct xfs_attri_log_format,	40);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_attri_log_format,	48);
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_attrd_log_format,	16);
>  
>  	/*
> -- 
> 2.25.1
> 
