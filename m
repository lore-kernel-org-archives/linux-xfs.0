Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDCBE26463A
	for <linux-xfs@vger.kernel.org>; Thu, 26 Mar 2026 13:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774530263; cv=none; b=AWoouIR6aDliXMfffxuMO34hPB3FMlEip4EWCKcnDevq07Fai+E3woFyE1/EOR+AHO+L62wT2EBQg2JpAn9CmnCJ2tY/ME92p7C3F1sFjDN/hhj7bCle3K/mwpta4aDvZ2Ahngxx82M18QQNmz5ODDSyoVSvMdm5Dt/jeYl1FSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774530263; c=relaxed/simple;
	bh=DhWQjBRQMtCJrfTe3oozsXIcr/DzUsEMHkkCqN+z1mI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZR2tVBeHxalifQeceDvGzUpBD/mQu7S4oCeni/Mkd7HnK/Ae6FSdnm5+VA1orBAF8v2+8Yydb6R4UMjDyblnRJXmpm42nqq9K1+E8o7L/RXvn2b7VdMf2hRQIcFIIUHN1wjbxucQZK52rKMY6YXEyBj6T6AAl/BmwLX1X7mSGlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bH4OGBJz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bH4OGBJz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 497AAC116C6;
	Thu, 26 Mar 2026 13:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774530263;
	bh=DhWQjBRQMtCJrfTe3oozsXIcr/DzUsEMHkkCqN+z1mI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bH4OGBJzSa+EPKRWpd2jofqQ9eLzO0LY/7GybB+Q9YIkMa7PS2W1mCnRgpHO42FhB
	 wDMPFkNQrfNiPOsCLQ1CWYIDrtKAZFKYmqj+b0sLLBfI2s4A3Msqj/wplBCYH/FdQ0
	 iTOfbBZRYIZGG9JwmkRTTKwAj/DLETerGbXZi3F0uLFlj6Y+5x0wfPB22DhtjcMbVq
	 G9041FVtWdqUmABuwGK2++mzG1wIoCgzsGcatWZZ45A0/O19kMdprNOK2MSKeKlfn+
	 PqtmaCTtcDrGudIREtOqcMYzkW3z4mufTR7sk7rQAyhRKd1kO60Xd3E8woRB0WSJWF
	 kPCiJMAz75oUg==
Date: Thu, 26 Mar 2026 14:04:19 +0100
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Long Li <leo.lilong@huawei.com>, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 2/3] xfs: don't expose stale pointers to callers of
 xlog_recover_iget
Message-ID: <acUrniYmDuw6k71m@nidhogg.toxiclabs.cc>
References: <20260323210157.GM6223@frogsfrogsfrogs>
 <20260323210351.GN6223@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260323210351.GN6223@frogsfrogsfrogs>

On Mon, Mar 23, 2026 at 02:03:51PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Fix this function to avoid exposing a stale pointer to the caller when
> returning an error code after dqattach fails.
> 
> Cc: <stable@vger.kernel.org> # v5.15
> Fixes: 4bc619833f738f ("xfs: refactor xfs_iget calls from log intent recovery")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Long Li <leo.lilong@huawei.com>
> ---

Hi.


>  fs/xfs/xfs_log_recover.c |   12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 09e6678ca4878e..0e91a62348eb79 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -1745,21 +1745,23 @@ xlog_recover_iget(
>  	xfs_ino_t		ino,
>  	struct xfs_inode	**ipp)
>  {
> +	struct xfs_inode	*ip;
>  	int			error;
>  
> -	error = xfs_iget(mp, NULL, ino, 0, 0, ipp);
> +	error = xfs_iget(mp, NULL, ino, 0, 0, &ip);
>  	if (error)
>  		return error;
>  
> -	error = xfs_qm_dqattach(*ipp);
> +	error = xfs_qm_dqattach(ip);
>  	if (error) {
> -		xfs_irele(*ipp);
> +		xfs_irele(ip);
>  		return error;
>  	}
>  
> -	if (VFS_I(*ipp)->i_nlink == 0)
> -		xfs_iflags_set(*ipp, XFS_IRECOVERY);
> +	if (VFS_I(ip)->i_nlink == 0)
> +		xfs_iflags_set(ip, XFS_IRECOVERY);
>  
> +	*ipp = ip;
>  	return 0;

Honestly I tend to agree with Christoph here. I don't really understand
what bug, real or theoretical, this is trying to fix, other than
somebody not aborting whatever operation is being done if an error
is returned.

I don't see any issue with an extra inode pointer being passed on the
stack here, but I don't see any benefit for this either.

Did you fall into this somehow? Have you seen this into the wild? I'll
pull the other patches meanwhile, but I think this one deserves more
discussion.
