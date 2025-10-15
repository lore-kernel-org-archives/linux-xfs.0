Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FE252DC76E
	for <linux-xfs@vger.kernel.org>; Wed, 15 Oct 2025 21:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760563063; cv=none; b=NicFMmggY8FtbcFUQrGfql/dcgFB4r+i0oDtxHYCZE3SXKYT77hfM/4YqdIaorYFb2Fh5ENWir2g2zpo4xQlztC+5lJdp8XbLVSx/0FY73JASuKmuUofFLuH5LMGDXppJWxNDRXBpYCU3DMsYtzIVNQJMsFnhjbAKBUUmLpravY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760563063; c=relaxed/simple;
	bh=3FOusmopSmfJeFG2isNQR/uorxWkM6+ecz2yLgV0WhQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XpzOcK5pqWduLQSZ9M8Ti4B1DGgECW27DwZhoBzxrPaVluuJ5Gl+EYLB9JDQA/Qfs4Cnnn9OSBh0TV+XhGMqDxuEmQKj6aCfykCV4Z3ylgvDi3kCmBQEnSDleCKLC4TyXJ/PnEOtkQdpEhX16MQa8w9hSdFJCqdcveF9L6L4MkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Aw9SiR1Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Aw9SiR1Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB537C113D0;
	Wed, 15 Oct 2025 21:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760563062;
	bh=3FOusmopSmfJeFG2isNQR/uorxWkM6+ecz2yLgV0WhQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Aw9SiR1ZZkiiIfxvit0QEMww6tZusUCNI8MKEYBK9qhaA/pwe4DeGINeHr2y0VKjQ
	 2CNjx6m/WXGMf5IdDvv0HsqCZcqa9APgCbIP5SUpBpam4BIA4rLvpfBzYykhGvXI0e
	 Ch+jX/J+HuT5o0/NzEefkt5yNz+rS8emsHrGChlEoiRVKC8xHtf0M9IwzxRvctbJtO
	 ydncm5swpJNhX8Kil2PFWBDriM4PjurCBzF1aghLngqcGy2Q7/I2UcgK0N691VgUNk
	 6YQnO0X4ERZLuwp4HRdgoUKciJ3tijBR50PQDT6T8I6JYHfJCJr26tElgrqNqoyj8g
	 SqivOky/lWXTQ==
Date: Wed, 15 Oct 2025 14:17:41 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/17] xfs: remove q_qlock locking in xfs_qm_scall_setqlim
Message-ID: <20251015211741.GF2591640@frogsfrogsfrogs>
References: <20251013024851.4110053-1-hch@lst.de>
 <20251013024851.4110053-12-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251013024851.4110053-12-hch@lst.de>

On Mon, Oct 13, 2025 at 11:48:12AM +0900, Christoph Hellwig wrote:
> q_type can't change for an existing dquot, so there is no need for
> the locking here.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Right.
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_qm_syscalls.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index 6c8924780d7a..022e2179c06b 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -302,9 +302,7 @@ xfs_qm_scall_setqlim(
>  		return error;
>  	}
>  
> -	mutex_lock(&dqp->q_qlock);
>  	defq = xfs_get_defquota(q, xfs_dquot_type(dqp));
> -	mutex_unlock(&dqp->q_qlock);
>  
>  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_setqlim, 0, 0, 0, &tp);
>  	if (error)
> -- 
> 2.47.3
> 
> 
