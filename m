Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F9223F417
	for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 13:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739453167; cv=none; b=mvrUSwm7Z2zSdFXfcBb62eAS80z5Y7SmQeNI1SIo2aRjfBhitfYY705Z383LIALIagHmdIZHs3fQKPKJ9royeN8sf8MFNr9tmnsfgvv0lrY+MFrRs6LQH5+AVUXo1NaAtnFSIxKO3l/+m9jPagwYs+z8eyU+cQlqPMjHkO/Rkbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739453167; c=relaxed/simple;
	bh=1cKbAL+pRemKsO8BfN4eaxy+n2OiuYTUvAdWu1ZC+bU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZtFQ2uMaNWPVtFGQxqe9ky6EIdSHORHlnx6k9CfUQYA/AjXjyEAVlLsbtAELxSIdrrADZuvN4bJMYyEXERVqbyFU1oT7Q/kLo1uj+tdkYVsEpT3nbK/Y5SCISuNy9RI0oly1xX3Rja0jCi13u7HvcGbALxMcHRBWlAJLirdUFIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ikTpu+wH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ikTpu+wH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739453164;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7P/vF05X+jUNWDS7tUkIg4FlX9VKaKdtV4PDHbOAEdw=;
	b=ikTpu+wHK2VcgL+p0hT75UqI3Z5HXdEh9MHwQv7g6PRRxPUT/7z8Z16zEPhVIsZLp6TZs3
	FrNYQ9ZSdphTMATXIUo9n9fwnLZaoHUKNAsTPQVdsBME2nAOxaj6ZY8F298dExZ1C/JZ6d
	TWhNbY0QEFEDmRUMXLp7+LyZwGqIfBE=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-486-RkqSbtI5NyC7UwtXMinVtw-1; Thu, 13 Feb 2025 08:26:03 -0500
X-MC-Unique: RkqSbtI5NyC7UwtXMinVtw-1
X-Mimecast-MFC-AGG-ID: RkqSbtI5NyC7UwtXMinVtw
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-5de573292e7so1031367a12.1
        for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 05:26:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739453162; x=1740057962;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7P/vF05X+jUNWDS7tUkIg4FlX9VKaKdtV4PDHbOAEdw=;
        b=MZO1BrwJPAiLBdXbf7E7VKYRdWTdXfKMUqgwnGu+Xq3fsSDdGArmP3seTRQV5jPeSe
         nfEVv9KjBD+8dN3dVbUNEyZ1knvh9InkPecduxcIkhmcMy5ZovomZtqbN+CdC6wX2qEq
         1eCT7avOtBPOsPpKHWm5V8x6LRF4LohdVYNWzAuc7/b0PNlfIR2HbYpf2RjWu0xBsJA7
         21nHLZjvvyDrzZA88t2TaOzJGQTyajfyTNSAWzFWfY28Wg8fV9T646TqoNDe90mlvYNL
         w39/g3MPvzc+wZZkFuPTT/0kyQKcY1kQrD5Q2Qcw1UkxzMO9Q1gb4GmrlHt3btSqHD5i
         sRFA==
X-Forwarded-Encrypted: i=1; AJvYcCXOU9G9b6a4Qc3Z01TYRXs0Oaz8pBObi97OLK7qFjEnVGdCf+dWJOpJMbn7zdfRIr9KJtWTpFlLfGo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4fdQtDCzv6DiWzvrwMVMHShYpnaUnAAwV2RPS3UJn8X836+y+
	k0hmQy0kp9E+yDsXXzporTtIL3AaKjWwDOaT7+TYZZ9S1WJhxrL7FzT/OjuWkIJWqOFnfvedrzS
	q7sPI8b0QP5mB/VJrZGu69A17GnpqwSPRnPILNMCaycX4l2/oBbHqYe3M
X-Gm-Gg: ASbGnctNvx1KOziEQYC26wdROjp0eUUSnWLmLqE67RhTNj9IWfO8rgyuhU0/enVFsmf
	bF6MyOrS+Y+q/GcLTJaLeLnj+u9H6nJR+TVXJEcMg0UmgT4LLn3l4wVxiO5LzjRo7eId3stKQ9Y
	B/L9N4MT+7LE2VXSm7hlWgr8t6Lk0BForP2o0MAvXineEuz1/dsDHOUqfAcfyCZd+NtO3c/8zkw
	zEoJs3eq4hIWsXw1yZTRxkFSwv2kZqReQBoyOYJGK9tW+VaHu2MSkfp6EiGm71sKtERwSdSzSjs
	pLUetCBd7lU/0Smsp9kPsfCj
X-Received: by 2002:a17:907:1c26:b0:ab7:be81:894a with SMTP id a640c23a62f3a-ab7f334aa97mr710035966b.8.1739453162350;
        Thu, 13 Feb 2025 05:26:02 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEim1S7yr0llsQujenW0mFrCMz4aDkh5dWg4bd619Mofp4Niqw5E0/KSfyt9FrSjL7cHzGS/g==
X-Received: by 2002:a17:907:1c26:b0:ab7:be81:894a with SMTP id a640c23a62f3a-ab7f334aa97mr710032466b.8.1739453161787;
        Thu, 13 Feb 2025 05:26:01 -0800 (PST)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aba53232275sm133147066b.31.2025.02.13.05.26.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2025 05:26:01 -0800 (PST)
Date: Thu, 13 Feb 2025 14:26:00 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs_db: make listdir more generally useful
Message-ID: <yqdazztco56skiirhco7nr5mgp2saccvzixtwldwav6u74dbx2@uamw6hs32wbq>
References: <173888089597.2742734.4600497543125166516.stgit@frogsfrogsfrogs>
 <173888089649.2742734.4268130787597232707.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173888089649.2742734.4268130787597232707.stgit@frogsfrogsfrogs>

On 2025-02-06 15:03:17, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Enhance the current directory entry iteration code in xfs_db to be more
> generally useful by allowing callers to pass around a transaction, a
> callback function, and a private pointer.  This will be used in the next
> patch to iterate directories when we want to copy their contents out of
> the filesystem into a directory.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

Looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

> ---
>  db/namei.c |   83 +++++++++++++++++++++++++++++++++++++++++-------------------
>  1 file changed, 57 insertions(+), 26 deletions(-)
> 
> 
> diff --git a/db/namei.c b/db/namei.c
> index 22eae50f219fd0..6f277a65ed91ac 100644
> --- a/db/namei.c
> +++ b/db/namei.c
> @@ -266,15 +266,18 @@ get_dstr(
>  	return filetype_strings[filetype];
>  }
>  
> -static void
> -dir_emit(
> -	struct xfs_mount	*mp,
> +static int
> +print_dirent(
> +	struct xfs_trans	*tp,
> +	struct xfs_inode	*dp,
>  	xfs_dir2_dataptr_t	off,
>  	char			*name,
>  	ssize_t			namelen,
>  	xfs_ino_t		ino,
> -	uint8_t			dtype)
> +	uint8_t			dtype,
> +	void			*private)
>  {
> +	struct xfs_mount	*mp = dp->i_mount;
>  	char			*display_name;
>  	struct xfs_name		xname = { .name = (unsigned char *)name };
>  	const char		*dstr = get_dstr(mp, dtype);
> @@ -306,11 +309,14 @@ dir_emit(
>  
>  	if (display_name != name)
>  		free(display_name);
> +	return 0;
>  }
>  
>  static int
>  list_sfdir(
> -	struct xfs_da_args		*args)
> +	struct xfs_da_args		*args,
> +	dir_emit_t			dir_emit,
> +	void				*private)
>  {
>  	struct xfs_inode		*dp = args->dp;
>  	struct xfs_mount		*mp = dp->i_mount;
> @@ -321,17 +327,24 @@ list_sfdir(
>  	xfs_dir2_dataptr_t		off;
>  	unsigned int			i;
>  	uint8_t				filetype;
> +	int				error;
>  
>  	/* . and .. entries */
>  	off = xfs_dir2_db_off_to_dataptr(geo, geo->datablk,
>  			geo->data_entry_offset);
> -	dir_emit(args->dp->i_mount, off, ".", -1, dp->i_ino, XFS_DIR3_FT_DIR);
> +	error = dir_emit(args->trans, args->dp, off, ".", -1, dp->i_ino,
> +			XFS_DIR3_FT_DIR, private);
> +	if (error)
> +		return error;
>  
>  	ino = libxfs_dir2_sf_get_parent_ino(sfp);
>  	off = xfs_dir2_db_off_to_dataptr(geo, geo->datablk,
>  			geo->data_entry_offset +
>  			libxfs_dir2_data_entsize(mp, sizeof(".") - 1));
> -	dir_emit(args->dp->i_mount, off, "..", -1, ino, XFS_DIR3_FT_DIR);
> +	error = dir_emit(args->trans, args->dp, off, "..", -1, ino,
> +			XFS_DIR3_FT_DIR, private);
> +	if (error)
> +		return error;
>  
>  	/* Walk everything else. */
>  	sfep = xfs_dir2_sf_firstentry(sfp);
> @@ -341,8 +354,11 @@ list_sfdir(
>  		off = xfs_dir2_db_off_to_dataptr(geo, geo->datablk,
>  				xfs_dir2_sf_get_offset(sfep));
>  
> -		dir_emit(args->dp->i_mount, off, (char *)sfep->name,
> -				sfep->namelen, ino, filetype);
> +		error = dir_emit(args->trans, args->dp, off,
> +				(char *)sfep->name, sfep->namelen, ino,
> +				filetype, private);
> +		if (error)
> +			return error;
>  		sfep = libxfs_dir2_sf_nextentry(mp, sfp, sfep);
>  	}
>  
> @@ -352,7 +368,9 @@ list_sfdir(
>  /* List entries in block format directory. */
>  static int
>  list_blockdir(
> -	struct xfs_da_args	*args)
> +	struct xfs_da_args	*args,
> +	dir_emit_t		dir_emit,
> +	void			*private)
>  {
>  	struct xfs_inode	*dp = args->dp;
>  	struct xfs_mount	*mp = dp->i_mount;
> @@ -363,7 +381,7 @@ list_blockdir(
>  	unsigned int		end;
>  	int			error;
>  
> -	error = xfs_dir3_block_read(NULL, dp, args->owner, &bp);
> +	error = xfs_dir3_block_read(args->trans, dp, args->owner, &bp);
>  	if (error)
>  		return error;
>  
> @@ -383,8 +401,11 @@ list_blockdir(
>  		diroff = xfs_dir2_db_off_to_dataptr(geo, geo->datablk, offset);
>  		offset += libxfs_dir2_data_entsize(mp, dep->namelen);
>  		filetype = libxfs_dir2_data_get_ftype(dp->i_mount, dep);
> -		dir_emit(mp, diroff, (char *)dep->name, dep->namelen,
> -				be64_to_cpu(dep->inumber), filetype);
> +		error = dir_emit(args->trans, args->dp, diroff,
> +				(char *)dep->name, dep->namelen,
> +				be64_to_cpu(dep->inumber), filetype, private);
> +		if (error)
> +			break;
>  	}
>  
>  	libxfs_trans_brelse(args->trans, bp);
> @@ -394,7 +415,9 @@ list_blockdir(
>  /* List entries in leaf format directory. */
>  static int
>  list_leafdir(
> -	struct xfs_da_args	*args)
> +	struct xfs_da_args	*args,
> +	dir_emit_t		dir_emit,
> +	void			*private)
>  {
>  	struct xfs_bmbt_irec	map;
>  	struct xfs_iext_cursor	icur;
> @@ -408,7 +431,7 @@ list_leafdir(
>  	int			error = 0;
>  
>  	/* Read extent map. */
> -	error = -libxfs_iread_extents(NULL, dp, XFS_DATA_FORK);
> +	error = -libxfs_iread_extents(args->trans, dp, XFS_DATA_FORK);
>  	if (error)
>  		return error;
>  
> @@ -424,7 +447,7 @@ list_leafdir(
>  		libxfs_trim_extent(&map, dabno, geo->leafblk - dabno);
>  
>  		/* Read the directory block of that first mapping. */
> -		error = xfs_dir3_data_read(NULL, dp, args->owner,
> +		error = xfs_dir3_data_read(args->trans, dp, args->owner,
>  				map.br_startoff, 0, &bp);
>  		if (error)
>  			break;
> @@ -449,18 +472,22 @@ list_leafdir(
>  			offset += libxfs_dir2_data_entsize(mp, dep->namelen);
>  			filetype = libxfs_dir2_data_get_ftype(mp, dep);
>  
> -			dir_emit(mp, xfs_dir2_byte_to_dataptr(dirboff + offset),
> +			error = dir_emit(args->trans, args->dp,
> +					xfs_dir2_byte_to_dataptr(dirboff + offset),
>  					(char *)dep->name, dep->namelen,
> -					be64_to_cpu(dep->inumber), filetype);
> +					be64_to_cpu(dep->inumber), filetype,
> +					private);
> +			if (error)
> +				break;
>  		}
>  
>  		dabno += XFS_DADDR_TO_FSB(mp, bp->b_length);
> -		libxfs_buf_relse(bp);
> +		libxfs_trans_brelse(args->trans, bp);
>  		bp = NULL;
>  	}
>  
>  	if (bp)
> -		libxfs_buf_relse(bp);
> +		libxfs_trans_brelse(args->trans, bp);
>  
>  	return error;
>  }
> @@ -468,9 +495,13 @@ list_leafdir(
>  /* Read the directory, display contents. */
>  static int
>  listdir(
> -	struct xfs_inode	*dp)
> +	struct xfs_trans	*tp,
> +	struct xfs_inode	*dp,
> +	dir_emit_t		dir_emit,
> +	void			*private)
>  {
>  	struct xfs_da_args	args = {
> +		.trans		= tp,
>  		.dp		= dp,
>  		.geo		= dp->i_mount->m_dir_geo,
>  		.owner		= dp->i_ino,
> @@ -479,14 +510,14 @@ listdir(
>  
>  	switch (libxfs_dir2_format(&args, &error)) {
>  	case XFS_DIR2_FMT_SF:
> -		return list_sfdir(&args);
> +		return list_sfdir(&args, dir_emit, private);
>  	case XFS_DIR2_FMT_BLOCK:
> -		return list_blockdir(&args);
> +		return list_blockdir(&args, dir_emit, private);
>  	case XFS_DIR2_FMT_LEAF:
>  	case XFS_DIR2_FMT_NODE:
> -		return list_leafdir(&args);
> +		return list_leafdir(&args, dir_emit, private);
>  	default:
> -		return error;
> +		return EFSCORRUPTED;
>  	}
>  }
>  
> @@ -526,7 +557,7 @@ ls_cur(
>  	if (tag)
>  		dbprintf(_("%s:\n"), tag);
>  
> -	error = listdir(dp);
> +	error = listdir(NULL, dp, print_dirent, NULL);
>  	if (error)
>  		goto rele;
>  
> 

-- 
- Andrey

