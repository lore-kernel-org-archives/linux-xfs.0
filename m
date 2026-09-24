Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F0163C1985
	for <linux-xfs@vger.kernel.org>; Thu, 24 Sep 2026 20:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790280893; cv=none; b=T0a+61Z1npZg3t39WEnU6Xo9IoOOD6BkRZZxD/3RyJaVLj3KQw1fXo1MFikmfc69tDgMUNBCDj2ZhwdxPzRf9vARKNfuHCEIrP6OmG4Jc/UjfTWbKye6Bbf70FLqGvYpIzPPhdQW0n5jHuy8bxb0mrJPA07xZn3Ta8F7tdbcJko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790280893; c=relaxed/simple;
	bh=MT1gHX7KCmn9TPvgE4vrBGuHH2fTQ9FkAuMWzN4mvJ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rqhd8Jfh0q0fSEXJsles47Qrx9NZcYlhhQqmiBp4JKpfsutl7XVahs7Ouvmq3k/aK8dxkFkGwSI0vPcwUmmZhsjYK9F7+5FwbkQMIJfI45sehQ+moxIwgzxNjM3/kr0GMj8AWW/Q9x9xxZvKhZozMZ+F0t5M48BApY6GdLjOu/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FCvwWnuE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FCvwWnuE"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id B61591F00893;
	Thu, 24 Sep 2026 20:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790280891;
	bh=MnGGLm7NzgJVgiXFEH5tLJ6I1wuYm25aUwu9dEcbK4A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FCvwWnuEkxlhKLyli0M0SKU/aiRj/8eixHVqmU+gHShZbPoeRvm49DXXWtLSAk4Jb
	 63T/dzBrpyZIcbbI3UxyP5fJ4VKnkrbaV5W9rmvAy0CQu849AZi+i1f3cYl67MdlMp
	 N18dJjiXFM1LgW2Iio1B0NrRbCLXvfdsgKdYO4jHF3DVlVn1JObfTbjVh//bemguXU
	 /OgA4YH4djdChS1V8rlg3pLERZ7cFsT5k7iQAOVSSo0JZb+RxykrU6F8bZkjQm4mCC
	 LppH3Zi1t2tPI6Ixo6ZXQE8uIXkSGpQNct/JeR9rVjO7xISYSe2b7vNt8UMz8lWL6Y
	 gwiTx+S2P6FYw==
Date: Thu, 24 Sep 2026 13:14:51 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/9] xfs: cleanup xfs_verify_media_error
Message-ID: <20260924201451.GT2705364@frogsfrogsfrogs>
References: <20260924095740.2732474-1-hch@lst.de>
 <20260924095740.2732474-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924095740.2732474-5-hch@lst.de>

On Thu, Sep 24, 2026 at 11:57:05AM +0200, Christoph Hellwig wrote:
> Move all the reporting logic into xfs_verify_report_losses, and pass the
> enum xfs_device instead of the group type to it.  This keeps all the
> reporting related conditions and translation confined to one place.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_verify_media.c | 46 +++++++++++++++++++--------------------
>  1 file changed, 23 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/xfs/xfs_verify_media.c b/fs/xfs/xfs_verify_media.c
> index 5ead3976d511..8ce3773aa875 100644
> --- a/fs/xfs/xfs_verify_media.c
> +++ b/fs/xfs/xfs_verify_media.c
> @@ -84,11 +84,14 @@ xfs_verify_report_data_lost(
>  	return 0;
>  }
>  
> -/* Walk reverse mappings to look for all file data loss */
> -static int
> +/*
> + * Report data loss on the physical sectors, and if possible, walk the reverse
> + * mappings to also report the loss to the files mapped to these sectors.
> + */
> +static void
>  xfs_verify_report_losses(
>  	struct xfs_mount	*mp,
> -	enum xfs_group_type	type,
> +	enum xfs_device		dev,
>  	xfs_daddr_t		daddr,
>  	u64			bblen)
>  {
> @@ -97,13 +100,25 @@ xfs_verify_report_losses(
>  	xfs_fsblock_t		start_bno, end_bno;
>  	uint32_t		start_gno, end_gno;
>  	int			error;
> +	enum xfs_group_type	type;
> +
> +	xfs_healthmon_report_media(mp, dev, daddr, bblen);
> +	if (!xfs_has_rmapbt(mp))
> +		return;
>  
> -	if (type == XG_TYPE_RTG) {
> +	switch (dev) {
> +	case XFS_DEV_RT:
>  		start_bno = xfs_daddr_to_rtb(mp, daddr);
>  		end_bno = xfs_daddr_to_rtb(mp, daddr + bblen - 1);
> -	} else {
> +		type = XG_TYPE_RTG;
> +		break;
> +	case XFS_DEV_DATA:
>  		start_bno = XFS_DADDR_TO_FSB(mp, daddr);
>  		end_bno = XFS_DADDR_TO_FSB(mp, daddr + bblen - 1);
> +		type = XG_TYPE_AG;
> +		break;
> +	default:
> +		return;
>  	}
>  
>  	tp = xfs_trans_alloc_empty(mp);
> @@ -164,7 +179,6 @@ xfs_verify_report_losses(
>  	}
>  
>  	xfs_trans_cancel(tp);
> -	return 0;
>  }
>  
>  /*
> @@ -236,25 +250,11 @@ xfs_verify_media_error(
>  	case BLK_STS_PROTECTION:
>  	case BLK_STS_IOERR:
>  	case BLK_STS_MEDIUM:
> +		if (me->me_flags & XFS_VERIFY_MEDIA_REPORT)
> +			xfs_verify_report_losses(mp, me->me_dev, daddr,
> +					bio_bbcount);
>  		break;
>  	default:
> -		return;
> -	}
> -
> -	if (!(me->me_flags & XFS_VERIFY_MEDIA_REPORT))
> -		return;
> -
> -	xfs_healthmon_report_media(mp, me->me_dev, daddr, bio_bbcount);
> -
> -	if (!xfs_has_rmapbt(mp))
> -		return;
> -
> -	switch (me->me_dev) {
> -	case XFS_DEV_DATA:
> -		xfs_verify_report_losses(mp, XG_TYPE_AG, daddr, bio_bbcount);
> -		break;
> -	case XFS_DEV_RT:
> -		xfs_verify_report_losses(mp, XG_TYPE_RTG, daddr, bio_bbcount);
>  		break;
>  	}
>  }
> -- 
> 2.53.0
> 
> 
