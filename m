Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59BD955C16
	for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 17:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710784414; cv=none; b=EV3emW87LVtNhyvRK1Ux0BQv3bUa6LqoB+hnPcXnJdk4FuF5HC8WCsEkwNCajKU7lc2EKfdWv4ltcRdirJExi1HQob7gz+8KYnJ5pr+myHtwdu7d3Q5SRAR0GABUOCaxtWHTHiRkTAtPhOD7wbgSuOgtRSpUNc+5zf+2ahr9gwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710784414; c=relaxed/simple;
	bh=nHCCJ8oZPuVSMcOyY978rJsUOKLNziW6XrpyCath8X0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s4alRXL+nM3H+9/wHHjg54MgHGXSwU9g6GFO6rKGFKn3Tt4C+fKphjkVcA9tXNwcRcPp65cvXnKfQoAT3efgLvCIP8ZWXS59Hg6L4fWERkDf1+kbL8Br/sTe9wEZc+4/02MBiEQq7vbDSdj+8zb86Jl92sT8Gvqk31a0zU1qzj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=it9qzusn; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="it9qzusn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710784411;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hTLQGA3ce6NqmPZ27ixtXcNcDBrXeiwKPfMM8J13wPA=;
	b=it9qzusnfbXQY4wbM8ELU+zM3e2jpV+jdPggqBBStwfr4KKSvE6ot9tFhdL+VmryBvaIEe
	1nYPXLteUmuIZy5u4SiEHkjQy8Y/BEffy3Yh/GBB27yNdTgojWH4IAYN0rIp1Wsmg0kb1I
	aRFlL9KcmAVUEWZTeD/zOX/2qcakhxs=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-472-qU5u5eTnM6i6Dwu_kh5Y4g-1; Mon, 18 Mar 2024 13:53:29 -0400
X-MC-Unique: qU5u5eTnM6i6Dwu_kh5Y4g-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-34172041676so717339f8f.1
        for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 10:53:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710784408; x=1711389208;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hTLQGA3ce6NqmPZ27ixtXcNcDBrXeiwKPfMM8J13wPA=;
        b=CCXu2BooWBeoGw6JOXgDIKucqGdDe0fy6HyLyYFtOVGmUXRe182Y+aQIuAt0SocCjF
         ib/fc2p0si1nfUlfjlzVSpFGhJB6gCqm059XvnTTZxLrqVeoPfaA/ithY4PjYwGe7AcR
         NiLKtm4oDDw8AHqNKQGT7QibPrS7dsXIY4FWFgDS7M+B3AqNXkkzJsZeYuU290fNr7Sd
         +Lc2uJTNYt6PjEThuaJii8EtX2vCntwmfMK+Q0SZ5uPTNsr1MCVbOQNVPThkBrqHgDjd
         WLEXA+7lXJhSdtFF2HDOytRu+fESQAnK7/cekE2XKSbT/h3WAdiy1dkdeRPINjg+wGPU
         tlCg==
X-Forwarded-Encrypted: i=1; AJvYcCVlpVbooeEWYyenlZn0v9DS5PjMmrA2NukxYH2WASwXzvoH/zQyB3JVlNZKO/mJ0ts/bGHzar8x6uOeXL3LjdPCPTfiMmnGPjVP
X-Gm-Message-State: AOJu0YwGD5vHWqKFuZNEQDU9yHe9gUN6cp32kT63KkqZQWuA5F2NnXDJ
	6dnGf0yIs/wr6bvR9i2YTTILeETAkGJoPZrpi7Y4qjpfX3o8WWBGdhYhmEyoJojFz0lZ89X5o5d
	nLuAqcM4BtBbEtm7UWx/ohB54gmStvKYGOTYI28SqSVoTxX7WRrmlonJj
X-Received: by 2002:adf:e0c4:0:b0:33e:aead:af07 with SMTP id m4-20020adfe0c4000000b0033eaeadaf07mr224615wri.27.1710784407967;
        Mon, 18 Mar 2024 10:53:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE6+9xAN+Z54GX2Nx2lx8orsnGgnShZlg5f0CZs3fxj5R/U8eBAYqqMj8u9Hck3IL5mnidI1Q==
X-Received: by 2002:adf:e0c4:0:b0:33e:aead:af07 with SMTP id m4-20020adfe0c4000000b0033eaeadaf07mr224601wri.27.1710784407406;
        Mon, 18 Mar 2024 10:53:27 -0700 (PDT)
Received: from thinky ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id n8-20020a5d6608000000b0033e45930f35sm10336986wru.6.2024.03.18.10.53.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Mar 2024 10:53:27 -0700 (PDT)
Date: Mon, 18 Mar 2024 18:53:26 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: ebiggers@kernel.org, linux-fsdevel@vger.kernel.org, 
	fsverity@lists.linux.dev, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 37/40] xfs: create separate name hash function for xattrs
Message-ID: <ebpjh7ix3ccqaym4cy5h66xu37777kcccsuqqrtq34efnj3oo3@xnmblpp4dngy>
References: <171069245829.2684506.10682056181611490828.stgit@frogsfrogsfrogs>
 <171069246501.2684506.2064171073014791566.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171069246501.2684506.2064171073014791566.stgit@frogsfrogsfrogs>

On 2024-03-17 09:33:02, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Create a new hashing function for extended attribute names.  The next
> patch needs this so it can modify the hash strategy for verity xattrs.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good to me:
Reviewed-by: Andrey Albershteyn <aalbersh@redhat.com>

> ---
>  fs/xfs/libxfs/xfs_attr.c      |   16 ++++++++++++++--
>  fs/xfs/libxfs/xfs_attr.h      |    3 +++
>  fs/xfs/libxfs/xfs_attr_leaf.c |    4 ++--
>  fs/xfs/scrub/attr.c           |    8 +++++---
>  fs/xfs/xfs_attr_item.c        |    3 ++-
>  fs/xfs/xfs_attr_list.c        |    3 ++-
>  6 files changed, 28 insertions(+), 9 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index b7aa1bc12fd1..b1fa45197eac 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -238,6 +238,16 @@ xfs_attr_get_ilocked(
>  	return xfs_attr_node_get(args);
>  }
>  
> +/* Compute hash for an extended attribute name. */
> +xfs_dahash_t
> +xfs_attr_hashname(
> +	unsigned int		attr_flags,
> +	const uint8_t		*name,
> +	unsigned int		namelen)
> +{
> +	return xfs_da_hashname(name, namelen);
> +}
> +
>  /*
>   * Retrieve an extended attribute by name, and its value if requested.
>   *
> @@ -268,7 +278,8 @@ xfs_attr_get(
>  
>  	args->geo = args->dp->i_mount->m_attr_geo;
>  	args->whichfork = XFS_ATTR_FORK;
> -	args->hashval = xfs_da_hashname(args->name, args->namelen);
> +	args->hashval = xfs_attr_hashname(args->attr_filter, args->name,
> +					  args->namelen);
>  
>  	/* Entirely possible to look up a name which doesn't exist */
>  	args->op_flags = XFS_DA_OP_OKNOENT;
> @@ -942,7 +953,8 @@ xfs_attr_set(
>  
>  	args->geo = mp->m_attr_geo;
>  	args->whichfork = XFS_ATTR_FORK;
> -	args->hashval = xfs_da_hashname(args->name, args->namelen);
> +	args->hashval = xfs_attr_hashname(args->attr_filter, args->name,
> +					  args->namelen);
>  
>  	/*
>  	 * We have no control over the attribute names that userspace passes us
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index 92711c8d2a9f..19db6c1cc71f 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -619,4 +619,7 @@ extern struct kmem_cache *xfs_attr_intent_cache;
>  int __init xfs_attr_intent_init_cache(void);
>  void xfs_attr_intent_destroy_cache(void);
>  
> +xfs_dahash_t xfs_attr_hashname(unsigned int attr_flags,
> +		const uint8_t *name_string, unsigned int name_length);
> +
>  #endif	/* __XFS_ATTR_H__ */
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index ac904cc1a97b..fcece25fd13e 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -911,8 +911,8 @@ xfs_attr_shortform_to_leaf(
>  		nargs.namelen = sfe->namelen;
>  		nargs.value = &sfe->nameval[nargs.namelen];
>  		nargs.valuelen = sfe->valuelen;
> -		nargs.hashval = xfs_da_hashname(sfe->nameval,
> -						sfe->namelen);
> +		nargs.hashval = xfs_attr_hashname(sfe->flags, sfe->nameval,
> +						  sfe->namelen);
>  		nargs.attr_filter = sfe->flags & XFS_ATTR_NSP_ONDISK_MASK;
>  		error = xfs_attr3_leaf_lookup_int(bp, &nargs); /* set a->index */
>  		ASSERT(error == -ENOATTR);
> diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
> index c69dee281984..e7d50589f72d 100644
> --- a/fs/xfs/scrub/attr.c
> +++ b/fs/xfs/scrub/attr.c
> @@ -253,7 +253,6 @@ xchk_xattr_listent(
>  		.dp			= context->dp,
>  		.name			= name,
>  		.namelen		= namelen,
> -		.hashval		= xfs_da_hashname(name, namelen),
>  		.trans			= context->tp,
>  		.valuelen		= valuelen,
>  	};
> @@ -263,6 +262,7 @@ xchk_xattr_listent(
>  
>  	sx = container_of(context, struct xchk_xattr, context);
>  	ab = sx->sc->buf;
> +	args.hashval = xfs_attr_hashname(flags, name, namelen);
>  
>  	if (xchk_should_terminate(sx->sc, &error)) {
>  		context->seen_enough = error;
> @@ -600,7 +600,8 @@ xchk_xattr_rec(
>  			xchk_da_set_corrupt(ds, level);
>  			goto out;
>  		}
> -		calc_hash = xfs_da_hashname(lentry->nameval, lentry->namelen);
> +		calc_hash = xfs_attr_hashname(ent->flags, lentry->nameval,
> +				lentry->namelen);
>  	} else {
>  		rentry = (struct xfs_attr_leaf_name_remote *)
>  				(((char *)bp->b_addr) + nameidx);
> @@ -608,7 +609,8 @@ xchk_xattr_rec(
>  			xchk_da_set_corrupt(ds, level);
>  			goto out;
>  		}
> -		calc_hash = xfs_da_hashname(rentry->name, rentry->namelen);
> +		calc_hash = xfs_attr_hashname(ent->flags, rentry->name,
> +				rentry->namelen);
>  	}
>  	if (calc_hash != hash)
>  		xchk_da_set_corrupt(ds, level);
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> index 703770cf1482..4d8264f0a537 100644
> --- a/fs/xfs/xfs_attr_item.c
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -536,7 +536,8 @@ xfs_attri_recover_work(
>  	args->whichfork = XFS_ATTR_FORK;
>  	args->name = nv->name.i_addr;
>  	args->namelen = nv->name.i_len;
> -	args->hashval = xfs_da_hashname(args->name, args->namelen);
> +	args->hashval = xfs_attr_hashname(attrp->alfi_attr_filter, args->name,
> +					  args->namelen);
>  	args->attr_filter = attrp->alfi_attr_filter & XFS_ATTRI_FILTER_MASK;
>  	args->op_flags = XFS_DA_OP_RECOVERY | XFS_DA_OP_OKNOENT |
>  			 XFS_DA_OP_LOGGED;
> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
> index fa74378577c5..96169474d023 100644
> --- a/fs/xfs/xfs_attr_list.c
> +++ b/fs/xfs/xfs_attr_list.c
> @@ -135,7 +135,8 @@ xfs_attr_shortform_list(
>  		}
>  
>  		sbp->entno = i;
> -		sbp->hash = xfs_da_hashname(sfe->nameval, sfe->namelen);
> +		sbp->hash = xfs_attr_hashname(sfe->flags, sfe->nameval,
> +					      sfe->namelen);
>  		sbp->name = sfe->nameval;
>  		sbp->namelen = sfe->namelen;
>  		/* These are bytes, and both on-disk, don't endian-flip */
> 

-- 
- Andrey

