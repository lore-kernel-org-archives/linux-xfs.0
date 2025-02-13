Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E890A23F417
	for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 13:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739453194; cv=none; b=FG6HI3hc/0q7ChUtN0JNUPSEYIRFkSmLZ6ChbQDqgvb1JyA9q4mi4eT+y6GKp4i7RssMnDADtNPEM02rcwuZmJKtU2mxGZb70BW7zY1FFfZqJwoWhmkorUZGtY31Wp+j8Xkb14GA6A9j+nmT5gVPfoYXRg5REC96VjaaFblCbuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739453194; c=relaxed/simple;
	bh=IjRccD/emF8aqmGEs2aZG/bFO9qEo24ncTKS4/whEx4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DBz9coj/BzY98K1k9FomEQ2pSu36F1CWox3fApdR1JmXf6Uy0nE17WLl6yMfx9ojZr8PuIgvO5K4NDsxuk6+XbIU3z9dfJlvBnSXhiRepVLfLItHTUPU0UORq8NkJBbAyQU+x2T1n0zABFr3mT6xXPZQVcfE/UMyeUKbG6TXAf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M++sAU5/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M++sAU5/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739453191;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=er4XJvYaD2W4GuCw/rgE2GLLg+4fBnG82NMV1rfPN7Y=;
	b=M++sAU5/Gp+gwrUP6nrv+EJPz1PzrRhIIbu+ZbKxCP4NYkMoUocFEoRNLPcM8sz8Q9H7L3
	xzPMV4CGVDd2mQj9BUXxFwxvePI7lmTptyD62P6rkkibTdouUwd6b6SSYg5N7bnPPtzMQu
	9m/KQT1P+J8Y2SfYjef8hw80iyaNNIw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-116-wp9HhDZEOJKYPJLeb6zK9w-1; Thu, 13 Feb 2025 08:26:30 -0500
X-MC-Unique: wp9HhDZEOJKYPJLeb6zK9w-1
X-Mimecast-MFC-AGG-ID: wp9HhDZEOJKYPJLeb6zK9w_1739453189
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4395ff90167so4637735e9.2
        for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 05:26:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739453188; x=1740057988;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=er4XJvYaD2W4GuCw/rgE2GLLg+4fBnG82NMV1rfPN7Y=;
        b=bqABbTHoybn23fr2r3QlGrobm0cqmdXW5Rpa8dM/8jr6DROLHSOH8YfN8ri91OaGuC
         8qt2A6F4AMpe++zP7R2qa39Mqo2d79dVm/we4vvERxF6EF1wHV5+5SZYrkgu+xkhqnRW
         ZxFk/SgjFqNj6tDcjf2tHnWb+bDpX01LDWJa+PpKb0A7n64/CQy8nMOgvsIMGE/v08EP
         khmrlznTSesuRgJWpVzoKWa4UgVmOwrjmCQSHDVio4T6hg7wa1EotshKCcC5dcfKBC0v
         1AXZpEt1jJSH8REJwPgFVA8dDu5mvCQ+/DwmyIfgptlnvgZpPSl7GIFOuOpGpa3eo3/s
         rtAQ==
X-Forwarded-Encrypted: i=1; AJvYcCWLeKda62YpGvcpGZac/WgNa0vJrUZMzu5GG10dAwlrprnfAXr3VnVk41Oaswd+jNSlINBDrcREoIg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy201UfmO/AGfq40V191gUzuCzYTOJLHC5iBM+A/OHXc3PtyF2H
	JjmXVaGUpfOabvdOyeUzWk7rupRgf7UyvbScjGvcJRLK4ApgROQwwdjD+7UzSYf0tZVTPGwTsVj
	I0uW35YwrPQR+xD/nkbLAgCUOd2jhfdH8ZruKoR6inE3BSq7iv2188ddy7U7gJO+H
X-Gm-Gg: ASbGnct/cTLySXcrNuf7JTSCN7UUi73Xn1lmaW8Bz2ZFnjgUfihVPLMtIw0ddsNVgmC
	DhGqZLI9WtVFCP5JQ18ZWUEYUNorhqTv1W+UN723kcKP8zpvBU99uVbGlwZlBMpJVAQwZ3z+vAj
	A9b0fojkmVPJuJCj5cUptjs0cug4D8lhMfJQE/6ey7uWfdQ+yJ8DmXaWEYzbkRaVrypvLsOspKy
	/hd6hFNB5zIugJJBTl+Lskl/B4RZhuvhOKJGYbA8OHOTLrwus22atqq7YLXFDL/FqVUjCCC405r
	UM/+KzYTKvdAw16dkCIh6soA
X-Received: by 2002:a05:600c:ad5:b0:439:5f1e:bd6b with SMTP id 5b1f17b1804b1-4395f1ebe9cmr48152735e9.23.1739453188271;
        Thu, 13 Feb 2025 05:26:28 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHx0/j7GB3ZZi/ILrTYKABiajGYpyvj6p12tOV4nBOFbWDw7Xb86RMSadp3T+imj5xLrXYE8A==
X-Received: by 2002:a05:600c:ad5:b0:439:5f1e:bd6b with SMTP id 5b1f17b1804b1-4395f1ebe9cmr48152405e9.23.1739453187859;
        Thu, 13 Feb 2025 05:26:27 -0800 (PST)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4395a1aa7e8sm49287835e9.26.2025.02.13.05.26.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2025 05:26:27 -0800 (PST)
Date: Thu, 13 Feb 2025 14:26:25 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs_db: use an empty transaction to try to prevent
 livelocks in path_navigate
Message-ID: <63q2fqotzw4ampswtx6gl6ybdsrh7deikfnxyslwpnu6xpkfe5@z7prbdd2eopx>
References: <173888089597.2742734.4600497543125166516.stgit@frogsfrogsfrogs>
 <173888089633.2742734.3613652081068410996.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173888089633.2742734.3613652081068410996.stgit@frogsfrogsfrogs>

On 2025-02-06 15:03:01, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> A couple of patches from now we're going to reuse the path_walk code in
> a new xfs_db subcommand that tries to recover directory trees from
> old/damaged filesystems.  Let's pass around an empty transaction to try
> too avoid livelocks on malicious/broken metadata.  This is not
> completely foolproof, but it's quick enough for most purposes.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

Looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>
> ---
>  db/namei.c |   23 +++++++++++++++--------
>  1 file changed, 15 insertions(+), 8 deletions(-)
> 
> 
> diff --git a/db/namei.c b/db/namei.c
> index 00610a54af527e..22eae50f219fd0 100644
> --- a/db/namei.c
> +++ b/db/namei.c
> @@ -87,15 +87,20 @@ path_navigate(
>  	xfs_ino_t		rootino,
>  	struct dirpath		*dirpath)
>  {
> +	struct xfs_trans	*tp;
>  	struct xfs_inode	*dp;
>  	xfs_ino_t		ino = rootino;
>  	unsigned int		i;
>  	int			error;
>  
> -	error = -libxfs_iget(mp, NULL, ino, 0, &dp);
> +	error = -libxfs_trans_alloc_empty(mp, &tp);
>  	if (error)
>  		return error;
>  
> +	error = -libxfs_iget(mp, tp, ino, 0, &dp);
> +	if (error)
> +		goto out_trans;
> +
>  	for (i = 0; i < dirpath->depth; i++) {
>  		struct xfs_name	xname = {
>  			.name	= (unsigned char *)dirpath->path[i],
> @@ -104,35 +109,37 @@ path_navigate(
>  
>  		if (!S_ISDIR(VFS_I(dp)->i_mode)) {
>  			error = ENOTDIR;
> -			goto rele;
> +			goto out_rele;
>  		}
>  
> -		error = -libxfs_dir_lookup(NULL, dp, &xname, &ino, NULL);
> +		error = -libxfs_dir_lookup(tp, dp, &xname, &ino, NULL);
>  		if (error)
> -			goto rele;
> +			goto out_rele;
>  		if (!xfs_verify_ino(mp, ino)) {
>  			error = EFSCORRUPTED;
> -			goto rele;
> +			goto out_rele;
>  		}
>  
>  		libxfs_irele(dp);
>  		dp = NULL;
>  
> -		error = -libxfs_iget(mp, NULL, ino, 0, &dp);
> +		error = -libxfs_iget(mp, tp, ino, 0, &dp);
>  		switch (error) {
>  		case EFSCORRUPTED:
>  		case EFSBADCRC:
>  		case 0:
>  			break;
>  		default:
> -			return error;
> +			goto out_trans;
>  		}
>  	}
>  
>  	set_cur_inode(ino);
> -rele:
> +out_rele:
>  	if (dp)
>  		libxfs_irele(dp);
> +out_trans:
> +	libxfs_trans_cancel(tp);
>  	return error;
>  }
>  
> 

-- 
- Andrey

