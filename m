Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 179753B83E8
	for <linux-xfs@vger.kernel.org>; Mon, 13 Jul 2026 22:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783983147; cv=none; b=P3vOgDPlhYqWfbovMYpTYYWaXxtY8odtJlmtsdUzHwH9pJcBrzTdC4JTKl9fw0Ia88/4mFP18jOD/+6qCsFrG8+UEMskVEvC13zemTahwSm2b34jMUzXVDqIC989IespXjeLg30xcbquDxEnoan1eGrx6j/CxwdjE2CjKg/YiJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783983147; c=relaxed/simple;
	bh=dSHlskzE+GDGqjne8z+h8WJ3IwKgpG4Kbue4opZG9bg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gylenq8wMrCk/0CmJCS7domBhLf1LCsZ27eN/+JJIOaSr5DIGkmdTlj/rUlluPAbe2WvgF0WTxaGLyzQasQRolvRPfXQQVHbnYTnC2Je1KYxOyj/AbKKF5cLAQ6zj6cQqSGS6d+yecTReic3jry3Ed+vx4kpkWIY6Rb27qeu4uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f0/2atGY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f0/2atGY"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9F8A81F000E9;
	Mon, 13 Jul 2026 22:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783983145;
	bh=CWbM++ZnK979WFr3rUU2I53CjEqbP7yyHdrMT/t3m6w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=f0/2atGY4D8Poh6D3stls7vJ1bD9Q2lQUbSToLYCwyee70eGUmupdMYMea1fOjPW5
	 +R3463UNDuIDSe2Vi4UmU0A3X6xm9QAmBsNfXwUMXegRJL3bADhSwtWB+7w1uqARZb
	 iY/TTjQOC305/pPyDuTye6ySqnXP5UlmEfmTJGY+c0KGTcDa22JxEy+5FsFwllqqyV
	 psJ87czzHcVSW7nzV9M+nsVtH/yhsJihW6d4365ifME51Gn0Hw7Q13exUWyu0c8VRS
	 jMn57p4Jif1j1ZP7NQWkVSypILk0Cwlf74o5NPr4exE+vJIREx7nszi9xy604l8vHB
	 URs9q9Hb6WpPQ==
Date: Mon, 13 Jul 2026 15:52:25 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: Re: [PATCH v2 2/4] xfs: create quota metadir inodes using
 xfs_metadir_create_file
Message-ID: <20260713225225.GJ7195@frogsfrogsfrogs>
References: <20260713124250.3978-1-johannes.thumshirn@wdc.com>
 <20260713124250.3978-3-johannes.thumshirn@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713124250.3978-3-johannes.thumshirn@wdc.com>

On Mon, Jul 13, 2026 at 02:42:48PM +0200, Johannes Thumshirn wrote:
> Now that we have xfs_metadir_create_file() use it in
> xfs_dqinode_metadir_create().
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

Looks good to me,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_dquot_buf.c | 39 ++++++++++-------------------------
>  1 file changed, 11 insertions(+), 28 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
> index bbada0d3cc08..f960474bed3d 100644
> --- a/fs/xfs/libxfs/xfs_dquot_buf.c
> +++ b/fs/xfs/libxfs/xfs_dquot_buf.c
> @@ -416,6 +416,15 @@ xfs_dqinode_load(
>  	return 0;
>  }
>  
> +static int
> +xfs_dqinode_init(
> +	struct xfs_metadir_update	*upd,
> +	void				*priv)
> +{
> +	xfs_trans_log_inode(upd->tp, upd->ip, XFS_ILOG_CORE);
> +	return 0;
> +}
> +
>  /* Create a metadata directory quota inode. */
>  int
>  xfs_dqinode_metadir_create(
> @@ -428,35 +437,9 @@ xfs_dqinode_metadir_create(
>  		.metafile_type		= xfs_dqinode_metafile_type(type),
>  		.path			= xfs_dqinode_path(type),
>  	};
> -	int				error;
>  
> -	error = xfs_metadir_start_create(&upd);
> -	if (error)
> -		return error;
> -
> -	error = xfs_metadir_create(&upd, S_IFREG);
> -	if (error)
> -		goto out_cancel;
> -
> -	xfs_trans_log_inode(upd.tp, upd.ip, XFS_ILOG_CORE);
> -
> -	error = xfs_metadir_commit(&upd);
> -	if (error)
> -		goto out_irele;
> -
> -	xfs_finish_inode_setup(upd.ip);
> -	*ipp = upd.ip;
> -	return 0;
> -
> -out_cancel:
> -	xfs_metadir_cancel(&upd, error);
> -out_irele:
> -	/* Have to finish setting up the inode to ensure it's deleted. */
> -	if (upd.ip) {
> -		xfs_finish_inode_setup(upd.ip);
> -		xfs_irele(upd.ip);
> -	}
> -	return error;
> +	return xfs_metadir_create_file(&upd, S_IFREG, xfs_dqinode_init, NULL,
> +			ipp);
>  }
>  
>  #ifndef __KERNEL__
> -- 
> 2.54.0
> 
> 
