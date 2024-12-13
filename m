Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBC3019992C
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 22:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734130632; cv=none; b=Fq9Tx+rWOd1z/ogMNuxl0BjdYANGs7F+ZjGSDsDMO7z9xFeD6iAfNy+JJmRMrEsjRIOYgi/DtDV211S/9ny9pQz9b1Hxv7B7s12IH+8Imsf/KWtTuighqvsvfRn1Svl4YSx9Kaxwuk1aFEjYd6L/9cN4nX2d9W/BhKtQRXvvijw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734130632; c=relaxed/simple;
	bh=/zlyfRDIhMKK8//jsjmRa1Xv9A7elR7BXf4pHbNpvzI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dMr9P3KtNMWFR50tAqdhpPjtBgvOkzfW3DEOTrLqy3MYzOCmEoPFHfzlbyWFAB1OefD1lcMydooQMSquoYTcSpbqJh7fVtSZ7d7seJ6CR0lZoVMqEexOiMGx3tTnN7Lu14ekwfd5+4Qsg/3Is/F0UY4UBJCbEs+iG7whn3M9rQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RImQ/t/c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RImQ/t/c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1CC6C4CED0;
	Fri, 13 Dec 2024 22:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734130631;
	bh=/zlyfRDIhMKK8//jsjmRa1Xv9A7elR7BXf4pHbNpvzI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RImQ/t/cKHcu9ljLv1NDnIkXPcmL1p73Trnb2G0Cg43OgFneMuIwdftiNGVwfzpNj
	 qOEIs6MrzSKglk67D0ML7UzJEHC5H52x67zFeTrA1IK9V6BNHfc0mmVk27BLhdud7h
	 JQcaXascirC6Th1oWmeq65qfIm1jo/n13scmB6PDc/52ExfcyVqoDX9pVERWeCpt63
	 0r/f6t/IysA18SRkt+L4kAzhy1j1ZhWKVqnL9W+e1NmY7xpdTOdGJiVUCXku1A1MEe
	 g6fahhnyOSvWXudezZZ5SAOh0l5RqsOVUCk3QdwWf9y/zQwhQuqfT9CBycQJtBItiu
	 ypowNmg3edWeg==
Date: Fri, 13 Dec 2024 14:57:11 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 40/43] xfs: add a max_open_zones mount option
Message-ID: <20241213225711.GA6678@frogsfrogsfrogs>
References: <20241211085636.1380516-1-hch@lst.de>
 <20241211085636.1380516-41-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241211085636.1380516-41-hch@lst.de>

On Wed, Dec 11, 2024 at 09:55:05AM +0100, Christoph Hellwig wrote:
> Allow limiting the number of open zones used below that exported by the
> device.  This is required to tune the number of write streams when zoned
> RT devices are used on conventional devices, and can be useful on zoned
> devices that support a very large number of open zones.

Can this be changed during a remount operation?  Do we have to
revalidate the value?

--D

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_super.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 690bb068a23a..e24f6a608b91 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -110,7 +110,7 @@ enum {
>  	Opt_filestreams, Opt_quota, Opt_noquota, Opt_usrquota, Opt_grpquota,
>  	Opt_prjquota, Opt_uquota, Opt_gquota, Opt_pquota,
>  	Opt_uqnoenforce, Opt_gqnoenforce, Opt_pqnoenforce, Opt_qnoenforce,
> -	Opt_discard, Opt_nodiscard, Opt_dax, Opt_dax_enum,
> +	Opt_discard, Opt_nodiscard, Opt_dax, Opt_dax_enum, Opt_max_open_zones,
>  };
>  
>  static const struct fs_parameter_spec xfs_fs_parameters[] = {
> @@ -155,6 +155,7 @@ static const struct fs_parameter_spec xfs_fs_parameters[] = {
>  	fsparam_flag("nodiscard",	Opt_nodiscard),
>  	fsparam_flag("dax",		Opt_dax),
>  	fsparam_enum("dax",		Opt_dax_enum, dax_param_enums),
> +	fsparam_u32("max_open_zones",	Opt_max_open_zones),
>  	{}
>  };
>  
> @@ -234,6 +235,9 @@ xfs_fs_show_options(
>  	if (!(mp->m_qflags & XFS_ALL_QUOTA_ACCT))
>  		seq_puts(m, ",noquota");
>  
> +	if (mp->m_max_open_zones)
> +		seq_printf(m, ",max_open_zones=%u", mp->m_max_open_zones);
> +
>  	return 0;
>  }
>  
> @@ -1456,6 +1460,9 @@ xfs_fs_parse_param(
>  		xfs_fs_warn_deprecated(fc, param, XFS_FEAT_NOATTR2, true);
>  		parsing_mp->m_features |= XFS_FEAT_NOATTR2;
>  		return 0;
> +	case Opt_max_open_zones:
> +		parsing_mp->m_max_open_zones = result.uint_32;
> +		return 0;
>  	default:
>  		xfs_warn(parsing_mp, "unknown mount option [%s].", param->key);
>  		return -EINVAL;
> -- 
> 2.45.2
> 
> 
