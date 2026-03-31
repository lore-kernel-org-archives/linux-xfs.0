Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D893363C47
	for <linux-xfs@vger.kernel.org>; Tue, 31 Mar 2026 16:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774973334; cv=none; b=c07YvW4FBOTBXZ/sbGKU1ic7QHEDFcZdvRg8DD9d9VWFPrtwDeTk8qj7E7eiPJ2/OHj+jp2t02DZk0AXgrKaXkIW5ZjIKSPJmm011UnEjtENUUsYKL/BgFzn4HDWWnrma+mDMVWPXS/gMTbZQqjzpWHRQO9RQ0TPJpm5jefYbBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774973334; c=relaxed/simple;
	bh=99GjkHfyT0UryUP/Jm/BL1Kq6nZddZVBSiV6xbBazSc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pxwRR7yEs0u7XAI1f/5Rfvid0I3OZ6P/kS5N+bjZuCzLbgGDiO+rWWycaPlDogoEROHNPem3E4Qs/DwaZ7dGs5pFeL0NLILt1R6zGsW5GB55P8p2oKrApkSo13rcflX5fHhzuqkk6l9/v7I3Y1HNTLKOyU3C9TEBMrR+QBcNgcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DvfZ+q2C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DvfZ+q2C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AF5EC19423;
	Tue, 31 Mar 2026 16:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774973334;
	bh=99GjkHfyT0UryUP/Jm/BL1Kq6nZddZVBSiV6xbBazSc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DvfZ+q2Ck6LDcDowfWMYhdL4hXwmhI88FupyVUzz9XEFpM9S9tyIuYnKj/v++oNaZ
	 CoioKtPI9k9hi5+pKD7rtODvDsMU5iVx2y0YH5Xbr2dcQOE/ASeUb9hoAhU1NcnoO1
	 Hia2laFF4A4Cq/8JCl5Gsyb6Vw9DwNzak6iahbjc/0FU2Y3aPXQdjFopJJILF40//B
	 UQGNIuaDwVLFlSGg8d4ILh5PFpLJAD0wOONiCA5RpabdtCCURpz4ZFMWMubLGXpmqJ
	 Pv3+RPgaqdrAeirkGdtuJHI3KQY6/rZh2hCsAnbFRrQHrGIYlJy5mTWVQwXO9tGc6U
	 Tw3LBo6YJ3WYg==
Date: Tue, 31 Mar 2026 09:08:53 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org
Cc: aalbersh@redhat.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 1/2] fsr: package function should check for negative
 errors
Message-ID: <20260331160853.GD6223@frogsfrogsfrogs>
References: <20260331122639.100956-1-cem@kernel.org>
 <20260331122639.100956-2-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260331122639.100956-2-cem@kernel.org>

On Tue, Mar 31, 2026 at 02:26:30PM +0200, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 
> xfrog_defragrange as most other functions from libfrog return
> a negative error value, while xfs_fsr's packfile(), expects
> a positive error value.
> 
> Whenever xfrog_defragrange fails, the switch case always falls into the
> default clausule, making the error message pointless.
> Fix this by inverting xfrog_defragrange() return value call.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> 
> ---
> V3:
> 	Just change xfrog_defragrange() return signal.

Looks good to me, thanks for fixing this :)
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> 
> V2:
> 	Change packfile() to check for negative error values
> 	instead of changing the return sign from xfrog_defragrange().
> 
>  fsr/xfs_fsr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
> index 8845ff172fcb..390f7c5276df 100644
> --- a/fsr/xfs_fsr.c
> +++ b/fsr/xfs_fsr.c
> @@ -1459,7 +1459,7 @@ packfile(
>          }
>  
>  	/* Swap the extents */
> -	error = xfrog_defragrange(file_fd->fd, &xdf);
> +	error = -xfrog_defragrange(file_fd->fd, &xdf);
>  	switch (error) {
>  		case 0:
>  			break;
> -- 
> 2.53.0
> 
> 
