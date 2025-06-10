Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95D1F28B7FB
	for <linux-xfs@vger.kernel.org>; Tue, 10 Jun 2025 09:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749547064; cv=none; b=bALS+2i7D/Vn2rADzoQXQjdJYji9q0qbrh/TRqbRNHmpiKXTn6G2ItqrXYB3YIyQhZw6E9ZKbwr0pNsjefiyE93b4hXQDoBYptXJP+qcVtFShuHlg8jbeaFg32aca0roabi8MHCO+6pfSASjuoXGmtH3BmEG7NOT8iFo7s4rWwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749547064; c=relaxed/simple;
	bh=l9rNBNNRu5mwg53v/r3keL8AUHzHN2n7ql4vG8P8Gpg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZXMUOwgtvq1HlmBO3kvusOPNSnlGNp7HsVJgp8nppuIptsgpbXyhqbRdeMuG1Nn37uYcgMdhXxgBg8AjzJqtHfun3DVVGRBTT6Z8pMfGma9GmPXgAnUwey00yNSGf5qaG2kftBQs/wpEBBLeCOMNE6OOX1ZM9lwzf8eFf+FuOQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ByBNyEMs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ByBNyEMs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67C41C4CEED;
	Tue, 10 Jun 2025 09:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749547064;
	bh=l9rNBNNRu5mwg53v/r3keL8AUHzHN2n7ql4vG8P8Gpg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ByBNyEMsX2XUPQVLXMAq2BN6+L761ClkZZaaiVFSunbzT55lvntVtw/faZH19nrTW
	 s02aELWPtOZGX829BWCF+7n3v1N8Njexf0JFrdVR9lXBkd25Rews8FgLEo9H8I4DRk
	 Wqf2bzPxqGtmiRTJVoWNg7uG7NFmzban98LphBKhBX+bV5+oX3///PPwY/CmhgWbus
	 WfgRKFnpVWBsWulhGktCQG4E0H87JSiL/6WX2PFfu4Al1WtOT8PwZujtwmwNv5/z1g
	 DM6Mu64cz2eJt/prHLks2wmbsfKhxXju4Bj45FC+kxJkYczYnN2tr2UfXAhLjol71A
	 JBh77dA07wKTA==
Date: Tue, 10 Jun 2025 11:17:40 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/17] xfs: don't use a xfs_log_iovec for attr_item names
 and values
Message-ID: <yxm7xmw4oyfk3udwnyvutvsbsbtmctmxxywiyb5xjfowuawqxa@gfxtmvfzpebv>
References: <20250610051644.2052814-1-hch@lst.de>
 <87zh7iMN3YQbqk4Sqd5jZSbgu2shMtWSZ6TxTx26lY6GhKClJ7tOdXNIBsmmu1VMu9bslTEhSPdgplacw1n0bw==@protonmail.internalid>
 <20250610051644.2052814-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250610051644.2052814-5-hch@lst.de>

On Tue, Jun 10, 2025 at 07:15:01AM +0200, Christoph Hellwig wrote:
> These buffers are not directly logged, just use a kvec and remove the
> xlog_copy_from_iovec helper only used here.

This looks correct, I'm not much sure if using a kvec here is ok, so I'll rely
on other reviewers regarding this. So take my review more related to code
correctness.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_attr_item.c | 111 +++++++++++++++++++++--------------------
>  fs/xfs/xfs_attr_item.h |   8 +--
>  fs/xfs/xfs_log.h       |   7 ---
>  3 files changed, 60 insertions(+), 66 deletions(-)
> 
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> index f683b7a9323f..2b3dde2eec9c 100644
> --- a/fs/xfs/xfs_attr_item.c
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -91,41 +91,37 @@ xfs_attri_log_nameval_alloc(
>  					name_len + new_name_len + value_len +
>  					new_value_len);
> 
> -	nv->name.i_addr = nv + 1;
> -	nv->name.i_len = name_len;
> -	nv->name.i_type = XLOG_REG_TYPE_ATTR_NAME;
> -	memcpy(nv->name.i_addr, name, name_len);
> +	nv->name.iov_base = nv + 1;
> +	nv->name.iov_len = name_len;
> +	memcpy(nv->name.iov_base, name, name_len);
> 
>  	if (new_name_len) {
> -		nv->new_name.i_addr = nv->name.i_addr + name_len;
> -		nv->new_name.i_len = new_name_len;
> -		memcpy(nv->new_name.i_addr, new_name, new_name_len);
> +		nv->new_name.iov_base = nv->name.iov_base + name_len;
> +		nv->new_name.iov_len = new_name_len;
> +		memcpy(nv->new_name.iov_base, new_name, new_name_len);
>  	} else {
> -		nv->new_name.i_addr = NULL;
> -		nv->new_name.i_len = 0;
> +		nv->new_name.iov_base = NULL;
> +		nv->new_name.iov_len = 0;
>  	}
> -	nv->new_name.i_type = XLOG_REG_TYPE_ATTR_NEWNAME;
> 
>  	if (value_len) {
> -		nv->value.i_addr = nv->name.i_addr + name_len + new_name_len;
> -		nv->value.i_len = value_len;
> -		memcpy(nv->value.i_addr, value, value_len);
> +		nv->value.iov_base = nv->name.iov_base + name_len + new_name_len;
> +		nv->value.iov_len = value_len;
> +		memcpy(nv->value.iov_base, value, value_len);
>  	} else {
> -		nv->value.i_addr = NULL;
> -		nv->value.i_len = 0;
> +		nv->value.iov_base = NULL;
> +		nv->value.iov_len = 0;
>  	}
> -	nv->value.i_type = XLOG_REG_TYPE_ATTR_VALUE;
> 
>  	if (new_value_len) {
> -		nv->new_value.i_addr = nv->name.i_addr + name_len +
> +		nv->new_value.iov_base = nv->name.iov_base + name_len +
>  						new_name_len + value_len;
> -		nv->new_value.i_len = new_value_len;
> -		memcpy(nv->new_value.i_addr, new_value, new_value_len);
> +		nv->new_value.iov_len = new_value_len;
> +		memcpy(nv->new_value.iov_base, new_value, new_value_len);
>  	} else {
> -		nv->new_value.i_addr = NULL;
> -		nv->new_value.i_len = 0;
> +		nv->new_value.iov_base = NULL;
> +		nv->new_value.iov_len = 0;
>  	}
> -	nv->new_value.i_type = XLOG_REG_TYPE_ATTR_NEWVALUE;
> 
>  	refcount_set(&nv->refcount, 1);
>  	return nv;
> @@ -170,21 +166,21 @@ xfs_attri_item_size(
> 
>  	*nvecs += 2;
>  	*nbytes += sizeof(struct xfs_attri_log_format) +
> -			xlog_calc_iovec_len(nv->name.i_len);
> +			xlog_calc_iovec_len(nv->name.iov_len);
> 
> -	if (nv->new_name.i_len) {
> +	if (nv->new_name.iov_len) {
>  		*nvecs += 1;
> -		*nbytes += xlog_calc_iovec_len(nv->new_name.i_len);
> +		*nbytes += xlog_calc_iovec_len(nv->new_name.iov_len);
>  	}
> 
> -	if (nv->value.i_len) {
> +	if (nv->value.iov_len) {
>  		*nvecs += 1;
> -		*nbytes += xlog_calc_iovec_len(nv->value.i_len);
> +		*nbytes += xlog_calc_iovec_len(nv->value.iov_len);
>  	}
> 
> -	if (nv->new_value.i_len) {
> +	if (nv->new_value.iov_len) {
>  		*nvecs += 1;
> -		*nbytes += xlog_calc_iovec_len(nv->new_value.i_len);
> +		*nbytes += xlog_calc_iovec_len(nv->new_value.iov_len);
>  	}
>  }
> 
> @@ -212,31 +208,36 @@ xfs_attri_item_format(
>  	 * the log recovery.
>  	 */
> 
> -	ASSERT(nv->name.i_len > 0);
> +	ASSERT(nv->name.iov_len > 0);
>  	attrip->attri_format.alfi_size++;
> 
> -	if (nv->new_name.i_len > 0)
> +	if (nv->new_name.iov_len > 0)
>  		attrip->attri_format.alfi_size++;
> 
> -	if (nv->value.i_len > 0)
> +	if (nv->value.iov_len > 0)
>  		attrip->attri_format.alfi_size++;
> 
> -	if (nv->new_value.i_len > 0)
> +	if (nv->new_value.iov_len > 0)
>  		attrip->attri_format.alfi_size++;
> 
>  	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTRI_FORMAT,
>  			&attrip->attri_format,
>  			sizeof(struct xfs_attri_log_format));
> -	xlog_copy_from_iovec(lv, &vecp, &nv->name);
> 
> -	if (nv->new_name.i_len > 0)
> -		xlog_copy_from_iovec(lv, &vecp, &nv->new_name);
> +	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTR_NAME, nv->name.iov_base,
> +			nv->name.iov_len);
> 
> -	if (nv->value.i_len > 0)
> -		xlog_copy_from_iovec(lv, &vecp, &nv->value);
> +	if (nv->new_name.iov_len > 0)
> +		xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTR_NEWNAME,
> +			nv->new_name.iov_base, nv->new_name.iov_len);
> 
> -	if (nv->new_value.i_len > 0)
> -		xlog_copy_from_iovec(lv, &vecp, &nv->new_value);
> +	if (nv->value.iov_len > 0)
> +		xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTR_VALUE,
> +			nv->value.iov_base, nv->value.iov_len);
> +
> +	if (nv->new_value.iov_len > 0)
> +		xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTR_NEWVALUE,
> +			nv->new_value.iov_base, nv->new_value.iov_len);
>  }
> 
>  /*
> @@ -383,22 +384,22 @@ xfs_attr_log_item(
>  	attrp->alfi_ino = args->dp->i_ino;
>  	ASSERT(!(attr->xattri_op_flags & ~XFS_ATTRI_OP_FLAGS_TYPE_MASK));
>  	attrp->alfi_op_flags = attr->xattri_op_flags;
> -	attrp->alfi_value_len = nv->value.i_len;
> +	attrp->alfi_value_len = nv->value.iov_len;
> 
>  	switch (xfs_attr_log_item_op(attrp)) {
>  	case XFS_ATTRI_OP_FLAGS_PPTR_REPLACE:
> -		ASSERT(nv->value.i_len == nv->new_value.i_len);
> +		ASSERT(nv->value.iov_len == nv->new_value.iov_len);
> 
>  		attrp->alfi_igen = VFS_I(args->dp)->i_generation;
> -		attrp->alfi_old_name_len = nv->name.i_len;
> -		attrp->alfi_new_name_len = nv->new_name.i_len;
> +		attrp->alfi_old_name_len = nv->name.iov_len;
> +		attrp->alfi_new_name_len = nv->new_name.iov_len;
>  		break;
>  	case XFS_ATTRI_OP_FLAGS_PPTR_REMOVE:
>  	case XFS_ATTRI_OP_FLAGS_PPTR_SET:
>  		attrp->alfi_igen = VFS_I(args->dp)->i_generation;
>  		fallthrough;
>  	default:
> -		attrp->alfi_name_len = nv->name.i_len;
> +		attrp->alfi_name_len = nv->name.iov_len;
>  		break;
>  	}
> 
> @@ -690,14 +691,14 @@ xfs_attri_recover_work(
>  	args->dp = ip;
>  	args->geo = mp->m_attr_geo;
>  	args->whichfork = XFS_ATTR_FORK;
> -	args->name = nv->name.i_addr;
> -	args->namelen = nv->name.i_len;
> -	args->new_name = nv->new_name.i_addr;
> -	args->new_namelen = nv->new_name.i_len;
> -	args->value = nv->value.i_addr;
> -	args->valuelen = nv->value.i_len;
> -	args->new_value = nv->new_value.i_addr;
> -	args->new_valuelen = nv->new_value.i_len;
> +	args->name = nv->name.iov_base;
> +	args->namelen = nv->name.iov_len;
> +	args->new_name = nv->new_name.iov_base;
> +	args->new_namelen = nv->new_name.iov_len;
> +	args->value = nv->value.iov_base;
> +	args->valuelen = nv->value.iov_len;
> +	args->new_value = nv->new_value.iov_base;
> +	args->new_valuelen = nv->new_value.iov_len;
>  	args->attr_filter = attrp->alfi_attr_filter & XFS_ATTRI_FILTER_MASK;
>  	args->op_flags = XFS_DA_OP_RECOVERY | XFS_DA_OP_OKNOENT |
>  			 XFS_DA_OP_LOGGED;
> @@ -754,8 +755,8 @@ xfs_attr_recover_work(
>  	 */
>  	attrp = &attrip->attri_format;
>  	if (!xfs_attri_validate(mp, attrp) ||
> -	    !xfs_attr_namecheck(attrp->alfi_attr_filter, nv->name.i_addr,
> -				nv->name.i_len))
> +	    !xfs_attr_namecheck(attrp->alfi_attr_filter, nv->name.iov_base,
> +				nv->name.iov_len))
>  		return -EFSCORRUPTED;
> 
>  	attr = xfs_attri_recover_work(mp, dfp, attrp, &ip, nv);
> diff --git a/fs/xfs/xfs_attr_item.h b/fs/xfs/xfs_attr_item.h
> index e74128cbb722..d108a11b55ae 100644
> --- a/fs/xfs/xfs_attr_item.h
> +++ b/fs/xfs/xfs_attr_item.h
> @@ -12,10 +12,10 @@ struct xfs_mount;
>  struct kmem_zone;
> 
>  struct xfs_attri_log_nameval {
> -	struct xfs_log_iovec	name;
> -	struct xfs_log_iovec	new_name;	/* PPTR_REPLACE only */
> -	struct xfs_log_iovec	value;
> -	struct xfs_log_iovec	new_value;	/* PPTR_REPLACE only */
> +	struct kvec		name;
> +	struct kvec		new_name;	/* PPTR_REPLACE only */
> +	struct kvec		value;
> +	struct kvec		new_value;	/* PPTR_REPLACE only */
>  	refcount_t		refcount;
> 
>  	/* name and value follow the end of this struct */
> diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
> index f239fce4f260..af6daf4f6792 100644
> --- a/fs/xfs/xfs_log.h
> +++ b/fs/xfs/xfs_log.h
> @@ -88,13 +88,6 @@ xlog_copy_iovec(struct xfs_log_vec *lv, struct xfs_log_iovec **vecp,
>  	return buf;
>  }
> 
> -static inline void *
> -xlog_copy_from_iovec(struct xfs_log_vec *lv, struct xfs_log_iovec **vecp,
> -		const struct xfs_log_iovec *src)
> -{
> -	return xlog_copy_iovec(lv, vecp, src->i_type, src->i_addr, src->i_len);
> -}
> -
>  /*
>   * By comparing each component, we don't have to worry about extra
>   * endian issues in treating two 32 bit numbers as one 64 bit number
> --
> 2.47.2
> 
