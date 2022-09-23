Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4A21C04A95
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Sep 2022 18:53:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbiIWSx3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Sep 2022 14:53:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiIWSx3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Sep 2022 14:53:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D5D512113D
        for <linux-xfs@vger.kernel.org>; Fri, 23 Sep 2022 11:53:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F2E37B819FE
        for <linux-xfs@vger.kernel.org>; Fri, 23 Sep 2022 18:53:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 898F8C433D6;
        Fri, 23 Sep 2022 18:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663959204;
        bh=kus+GgGoQffPGA/pMW+kE1NBkghvQVPb8n4Vaw5NjOU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OVAzigs0DhkbKbhaedl/L91rLUDVcpw53fwfer8jeVuyUoR7ka+pYnIPoM/i9hUGn
         TmR86pkvu7U58UtMDMM92p7qfJiFSdjqshx09/W8qSCKoGmfxDGxZlMzbFy3OoF1kE
         JqqAeb99KOj1g1TSSWFHrMWARgjiyMyZqIZmm+j6xJhkB1zRgdRKSKk2m6cUBct8Ct
         Mg74Sea1EsSlJTPUgHl591uX+mQivPtibs3mqHoizfM8dL80YHIuQ+G0GMmecQbrmW
         RSmPedCthK18C9aMZfphEGfaBY5KmXhXgfIXt9eFhlM1OKgQ7l3pKMcor1gj/NnRpU
         1k44GJwA/aJqg==
Date:   Fri, 23 Sep 2022 11:53:24 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     allison.henderson@oracle.com
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 01/26] xfs: Add new name to attri/d
Message-ID: <Yy4ApOh1RuUbC8gW@magnolia>
References: <20220922054458.40826-1-allison.henderson@oracle.com>
 <20220922054458.40826-2-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220922054458.40826-2-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 21, 2022 at 10:44:33PM -0700, allison.henderson@oracle.com wrote:
> From: Allison Henderson <allison.henderson@oracle.com>
> 
> This patch adds two new fields to the atti/d.  They are nname and
> nnamelen.  This will be used for parent pointer updates since a
> rename operation may cause the parent pointer to update both the
> name and value.  So we need to carry both the new name as well as
> the target name in the attri/d.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c       |  12 +++-
>  fs/xfs/libxfs/xfs_attr.h       |   4 +-
>  fs/xfs/libxfs/xfs_da_btree.h   |   2 +
>  fs/xfs/libxfs/xfs_log_format.h |   6 +-
>  fs/xfs/xfs_attr_item.c         | 108 ++++++++++++++++++++++++++++-----
>  fs/xfs/xfs_attr_item.h         |   1 +
>  6 files changed, 113 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index e28d93d232de..b1dbed7655e8 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -423,6 +423,12 @@ xfs_attr_complete_op(
>  	args->op_flags &= ~XFS_DA_OP_REPLACE;
>  	if (do_replace) {
>  		args->attr_filter &= ~XFS_ATTR_INCOMPLETE;
> +		if (args->new_namelen > 0) {
> +			args->name = args->new_name;
> +			args->namelen = args->new_namelen;

/me wonders, do we need to null out new_name and new_namelen here?

I /think/ the answer is that the current codebase doesn't care since
we're now doing XFS_DA_OP_ADDNAME, and addname looks only at
name/namelen and has no idea that new_name/new_namelen even exist?

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
> +		  XFS_ATTRI_OP_FLAGS_NVREPLACE;
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
> index ffa3df5b2893..a4b29827603f 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.h
> +++ b/fs/xfs/libxfs/xfs_da_btree.h
> @@ -55,7 +55,9 @@ enum xfs_dacmp {
>  typedef struct xfs_da_args {
>  	struct xfs_da_geometry *geo;	/* da block geometry */
>  	const uint8_t		*name;		/* string (maybe not NULL terminated) */
> +	const uint8_t	*new_name;	/* new attr name */
>  	int		namelen;	/* length of string (maybe no NULL) */
> +	int		new_namelen;	/* new attr name len */
>  	uint8_t		filetype;	/* filetype of inode for directories */
>  	void		*value;		/* set of bytes (maybe contain NULLs) */
>  	int		valuelen;	/* length of value */

/me starts to wonder if the two name len fields and the value len field
ought to be u8/u16 to conserve space in xfs_da_args, but that's an
optimization question for after this patchset.

> diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
> index b351b9dc6561..62f40e6353c2 100644
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
> +#define XFS_ATTRI_OP_FLAGS_NVREPLACE	4	/* Replace attr name and val */
>  #define XFS_ATTRI_OP_FLAGS_TYPE_MASK	0xFF	/* Flags type mask */
>  
>  /*
> @@ -926,7 +928,7 @@ struct xfs_icreate_log {
>  struct xfs_attri_log_format {
>  	uint16_t	alfi_type;	/* attri log item type */
>  	uint16_t	alfi_size;	/* size of this item */
> -	uint32_t	__pad;		/* pad to 64 bit aligned */
> +	uint32_t	alfi_nname_len;	/* attr new name length */
>  	uint64_t	alfi_id;	/* attri identifier */
>  	uint64_t	alfi_ino;	/* the inode for this attr operation */
>  	uint32_t	alfi_op_flags;	/* marks the op as a set or remove */
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> index cf5ce607dc05..9414ee94829c 100644
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
> @@ -85,15 +87,25 @@ xfs_attri_log_nameval_alloc(
>  	 * this. But kvmalloc() utterly sucks, so we use our own version.
>  	 */
>  	nv = xlog_kvmalloc(sizeof(struct xfs_attri_log_nameval) +
> -					name_len + value_len);
> +					name_len + nname_len + value_len);
>  
>  	nv->name.i_addr = nv + 1;
>  	nv->name.i_len = name_len;
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
> @@ -147,11 +159,15 @@ xfs_attri_item_size(
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
> @@ -181,6 +197,9 @@ xfs_attri_item_format(
>  	ASSERT(nv->name.i_len > 0);
>  	attrip->attri_format.alfi_size++;
>  
> +	if (nv->nname.i_len > 0)
> +		attrip->attri_format.alfi_size++;
> +
>  	if (nv->value.i_len > 0)
>  		attrip->attri_format.alfi_size++;
>  
> @@ -188,6 +207,10 @@ xfs_attri_item_format(
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
> @@ -396,6 +419,7 @@ xfs_attr_log_item(
>  	attrp->alfi_op_flags = attr->xattri_op_flags;
>  	attrp->alfi_value_len = attr->xattri_nameval->value.i_len;
>  	attrp->alfi_name_len = attr->xattri_nameval->name.i_len;
> +	attrp->alfi_nname_len = attr->xattri_nameval->nname.i_len;
>  	ASSERT(!(attr->xattri_da_args->attr_filter & ~XFS_ATTRI_FILTER_MASK));
>  	attrp->alfi_attr_filter = attr->xattri_da_args->attr_filter;
>  }
> @@ -437,7 +461,8 @@ xfs_attr_create_intent(
>  		 * deferred work state structure.
>  		 */
>  		attr->xattri_nameval = xfs_attri_log_nameval_alloc(args->name,
> -				args->namelen, args->value, args->valuelen);
> +				args->namelen, args->new_name,
> +				args->new_namelen, args->value, args->valuelen);
>  	}
>  
>  	attrip = xfs_attri_init(mp, attr->xattri_nameval);
> @@ -525,9 +550,6 @@ xfs_attri_validate(
>  	unsigned int			op = attrp->alfi_op_flags &
>  					     XFS_ATTRI_OP_FLAGS_TYPE_MASK;
>  
> -	if (attrp->__pad != 0)
> -		return false;

I don't think it's correct to remove this check entirely -- NVREPLACE is
the only operation that uses nname/nname_len, right?  Shouldn't this be:

	if (op_flags != XFS_ATTRI_OP_FLAGS_NVREPLACE &&
	    attrp->alfi_nname_len != 0)
		return false;

> -
>  	if (attrp->alfi_op_flags & ~XFS_ATTRI_OP_FLAGS_TYPE_MASK)
>  		return false;
>  
> @@ -539,6 +561,7 @@ xfs_attri_validate(
>  	case XFS_ATTRI_OP_FLAGS_SET:
>  	case XFS_ATTRI_OP_FLAGS_REPLACE:
>  	case XFS_ATTRI_OP_FLAGS_REMOVE:
> +	case XFS_ATTRI_OP_FLAGS_NVREPLACE:
>  		break;
>  	default:
>  		return false;
> @@ -548,9 +571,14 @@ xfs_attri_validate(
>  		return false;
>  
>  	if ((attrp->alfi_name_len > XATTR_NAME_MAX) ||
> +	    (attrp->alfi_nname_len > XATTR_NAME_MAX) ||
>  	    (attrp->alfi_name_len == 0))
>  		return false;
>  
> +	if (op == XFS_ATTRI_OP_FLAGS_REMOVE &&
> +	    attrp->alfi_value_len != 0)
> +		return false;

This change fixes a validation flaw in existing code, right?

If so, it ought to be a separate patc... you know what?  26 patches is
enough, I'll let this one slide since LARP is still experimental.

--D

> +
>  	return xfs_verify_ino(mp, attrp->alfi_ino);
>  }
>  
> @@ -611,6 +639,8 @@ xfs_attri_item_recover(
>  	args->whichfork = XFS_ATTR_FORK;
>  	args->name = nv->name.i_addr;
>  	args->namelen = nv->name.i_len;
> +	args->new_name = nv->nname.i_addr;
> +	args->new_namelen = nv->nname.i_len;
>  	args->hashval = xfs_da_hashname(args->name, args->namelen);
>  	args->attr_filter = attrp->alfi_attr_filter & XFS_ATTRI_FILTER_MASK;
>  	args->op_flags = XFS_DA_OP_RECOVERY | XFS_DA_OP_OKNOENT |
> @@ -621,6 +651,7 @@ xfs_attri_item_recover(
>  	switch (attr->xattri_op_flags) {
>  	case XFS_ATTRI_OP_FLAGS_SET:
>  	case XFS_ATTRI_OP_FLAGS_REPLACE:
> +	case XFS_ATTRI_OP_FLAGS_NVREPLACE:
>  		args->value = nv->value.i_addr;
>  		args->valuelen = nv->value.i_len;
>  		args->total = xfs_attr_calc_size(args, &local);
> @@ -710,6 +741,7 @@ xfs_attri_item_relog(
>  	new_attrp->alfi_op_flags = old_attrp->alfi_op_flags;
>  	new_attrp->alfi_value_len = old_attrp->alfi_value_len;
>  	new_attrp->alfi_name_len = old_attrp->alfi_name_len;
> +	new_attrp->alfi_nname_len = old_attrp->alfi_nname_len;
>  	new_attrp->alfi_attr_filter = old_attrp->alfi_attr_filter;
>  
>  	xfs_trans_add_item(tp, &new_attrip->attri_item);
> @@ -731,10 +763,41 @@ xlog_recover_attri_commit_pass2(
>  	struct xfs_attri_log_nameval	*nv;
>  	const void			*attr_value = NULL;
>  	const void			*attr_name;
> -	int                             error;
> +	const void			*attr_nname = NULL;
> +	int				i = 0;
> +	int                             op, error = 0;
>  
> -	attri_formatp = item->ri_buf[0].i_addr;
> -	attr_name = item->ri_buf[1].i_addr;
> +	if (item->ri_total == 0) {
> +		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
> +		return -EFSCORRUPTED;
> +	}
> +
> +	attri_formatp = item->ri_buf[i].i_addr;
> +	i++;
> +
> +	op = attri_formatp->alfi_op_flags & XFS_ATTRI_OP_FLAGS_TYPE_MASK;
> +	switch (op) {
> +	case XFS_ATTRI_OP_FLAGS_SET:
> +	case XFS_ATTRI_OP_FLAGS_REPLACE:
> +		if (item->ri_total != 3)
> +			error = -EFSCORRUPTED;
> +		break;
> +	case XFS_ATTRI_OP_FLAGS_REMOVE:
> +		if (item->ri_total != 2)
> +			error = -EFSCORRUPTED;
> +		break;
> +	case XFS_ATTRI_OP_FLAGS_NVREPLACE:
> +		if (item->ri_total != 4)
> +			error = -EFSCORRUPTED;
> +		break;
> +	default:
> +		error = -EFSCORRUPTED;
> +	}
> +
> +	if (error) {
> +		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
> +		return error;
> +	}
>  
>  	/* Validate xfs_attri_log_format before the large memory allocation */
>  	if (!xfs_attri_validate(mp, attri_formatp)) {
> @@ -742,13 +805,27 @@ xlog_recover_attri_commit_pass2(
>  		return -EFSCORRUPTED;
>  	}
>  
> +	attr_name = item->ri_buf[i].i_addr;
> +	i++;
> +
>  	if (!xfs_attr_namecheck(attr_name, attri_formatp->alfi_name_len)) {
>  		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
>  		return -EFSCORRUPTED;
>  	}
>  
> +	if (attri_formatp->alfi_nname_len) {
> +		attr_nname = item->ri_buf[i].i_addr;
> +		i++;
> +
> +		if (!xfs_attr_namecheck(attr_nname,
> +				attri_formatp->alfi_nname_len)) {
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
> @@ -756,7 +833,8 @@ xlog_recover_attri_commit_pass2(
>  	 * reference.
>  	 */
>  	nv = xfs_attri_log_nameval_alloc(attr_name,
> -			attri_formatp->alfi_name_len, attr_value,
> +			attri_formatp->alfi_name_len, attr_nname,
> +			attri_formatp->alfi_nname_len, attr_value,
>  			attri_formatp->alfi_value_len);
>  
>  	attrip = xfs_attri_init(mp, nv);
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
> -- 
> 2.25.1
> 
