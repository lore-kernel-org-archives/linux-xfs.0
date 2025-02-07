Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 539FE194A67
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 04:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738902558; cv=none; b=lrlv9HF5c/XAYo0BjhhBF6hUV7RvHaj4W8pLVcm/5A1XY2zJt4ZgU/jjCvE4eXEob6SgzVh54tQ6Y4NKTLghBiWBhJYCEIpPjpFPDSPO+GnYC/RDs4ythZTTo6Q0E6rba+jgyoZo+zAEVpSHA420DA2CMLJO/KA7/7ZwpQC9v+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738902558; c=relaxed/simple;
	bh=A8VNinSv4tnK5XCvG5pM7sjbgbbLa6G54LGLfQzeM1M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GFTsmrXTMjsKH1lT9hsX9mX46wva0HFJ4l2xHKX985ZFWZ+W6V5CdOgoWp9N1hnFrYPa3LjFg7cvKbSxk2xoBlTY/3CTIybE+M844XCKq7pKsh7R0MzoRJedVvWKMEWC3CAXTQacDOjMXSx1zn7WuklMlwhjxqF64IPqlxbrBRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MozKGc3C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MozKGc3C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD34BC4CED1;
	Fri,  7 Feb 2025 04:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738902556;
	bh=A8VNinSv4tnK5XCvG5pM7sjbgbbLa6G54LGLfQzeM1M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MozKGc3Cw2xhYMqaloB76YqCPn/Kv4hfqqRdbjVsmlu+nBTBAvt17rNOBt0OqNcqS
	 YV6EBwASiI1eK7y8f1e9Zqzm6ryEPhBWhWjlNK+S3ZBwqNBIz2BXbf2U1uBBEy114N
	 +sHiItrZUcb7+8wbRMAnOZy4a+i8MeXM7xx/GdH8ijxrUmJy1DQ/k2RU46oNqDRx6U
	 iBSNxZ1bLxSd4BrmgKUiWohQrJUldy7Ier4mY4jmHgR+lA0Dt+Ywd8TYfylWc5qM+Y
	 6Js/fdCNtpWx10zpCeF6ONLeRJVfzRjnwdSm4VuWo5z9lshxOsuPw43Y4MOjfyuRPP
	 rSZC3AyVc9gLg==
Date: Thu, 6 Feb 2025 20:29:16 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 38/43] xfs: add a max_open_zones mount option
Message-ID: <20250207042916.GL21808@frogsfrogsfrogs>
References: <20250206064511.2323878-1-hch@lst.de>
 <20250206064511.2323878-39-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250206064511.2323878-39-hch@lst.de>

On Thu, Feb 06, 2025 at 07:44:54AM +0100, Christoph Hellwig wrote:
> Allow limiting the number of open zones used below that exported by the
> device.  This is required to tune the number of write streams when zoned
> RT devices are used on conventional devices, and can be useful on zoned
> devices that support a very large number of open zones.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Seems pretty straightforward to me...
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

>  fs/xfs/xfs_super.c | 17 ++++++++++++++++-
>  1 file changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index ceb1a855453e..b59d7349dbd2 100644
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
> @@ -1081,6 +1085,14 @@ xfs_finish_flags(
>  		return -EINVAL;
>  	}
>  
> +	if (!xfs_has_zoned(mp)) {
> +		if (mp->m_max_open_zones) {
> +			xfs_warn(mp,
> +"max_open_zones mount option only supported on zoned file systems.");
> +			return -EINVAL;
> +		}
> +	}
> +
>  	return 0;
>  }
>  
> @@ -1462,6 +1474,9 @@ xfs_fs_parse_param(
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
