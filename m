Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7260712E7F
	for <linux-xfs@vger.kernel.org>; Sat, 22 Feb 2025 16:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740240980; cv=none; b=emGHzxRKK8dNQecuY5trrdo7nMJipRqvI42iNsaUKi8WfsdTi73mJutGfVVzC1F1eEp7xc24I3QGb2OO9XxqJu6eIlPJjcCEs6YOG8cNQhQAW+Tz6rq0BQMfS7vdGqW9ThEy1lOZ4IOTFmUXrKalXL5fnHuP63+MT1ghzwV15uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740240980; c=relaxed/simple;
	bh=xPBo9+xoXI5oEuCwgvLiqe04z/NXcM+K7V/ULVnV2mc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OCso3+gOoA7B/TvEPj4WqdBbXd+A75E+Ft1TINZs5R+VQnqz5wot3pcR8gQn+c9mpSjR7wApJX6LyYjWMQM6QuJHYZxga6aGiJotfk3TGSM8KwrokqKeQCMeqpC251jO8Csd7FRPJulVRlutuPk3mv3aXV342Y3FhcBoEygMVlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ym0+e50+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ym0+e50+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4E8FC4CED1;
	Sat, 22 Feb 2025 16:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740240978;
	bh=xPBo9+xoXI5oEuCwgvLiqe04z/NXcM+K7V/ULVnV2mc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ym0+e50+U8hcbtWJsLavf+lz9Z94m4Mk4yP3B9uz50XVY4TouGyoQV/lC4hecodty
	 zayROkqVp1YcgOs+mDA0YH5UP3+oSowvkSLdUu0pIObuJDE+PL/x3It8IFPMc0L+T+
	 3B37olbIvt+2OuU4liiKMpa2HFjWjklS50Ys3fgQKrE+m7pVokU1F5O20HPQ4DPHwM
	 ZqNG2MzX4y0NWPZwwO0n202y2MvdoMLYnQ9rjYRPwSSsjQz1mZjAOu1d8fmxhe+1PI
	 U0LdZ8ia72o3oDl2CInPwsKoTVmiKtZND6kgecxACwsLAGU6jhxHPPME5rF/fev/hv
	 Nrs9aKEfMsKgQ==
Date: Sat, 22 Feb 2025 08:16:18 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Anthony Iliopoulos <ailiop@suse.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs_io: don't fail FS_IOC_FSGETXATTR on filesystems that
 lack support
Message-ID: <20250222161618.GX21808@frogsfrogsfrogs>
References: <20250222150832.133343-1-ailiop@suse.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250222150832.133343-1-ailiop@suse.com>

On Sat, Feb 22, 2025 at 04:08:32PM +0100, Anthony Iliopoulos wrote:
> Not all filesystems implement the FS_IOC_FSGETXATTR ioctl, and in those
> cases -ENOTTY will be returned. There is no need to return with an error
> when this happens, so just silently return.
> 
> Without this fstest generic/169 fails on NFS that doesn't implement the
> fileattr_get inode operation.
> 
> Fixes: e6b48f451a5d ("xfs_io: allow foreign FSes to show FS_IOC_FSGETXATTR details")
> Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>

oops yeah
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  io/stat.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/io/stat.c b/io/stat.c
> index 3ce3308d0562..d27f916800c0 100644
> --- a/io/stat.c
> +++ b/io/stat.c
> @@ -104,8 +104,10 @@ print_extended_info(int verbose)
>  	struct fsxattr fsx = {}, fsxa = {};
>  
>  	if ((ioctl(file->fd, FS_IOC_FSGETXATTR, &fsx)) < 0) {
> -		perror("FS_IOC_GETXATTR");
> -		exitcode = 1;
> +		if (errno != ENOTTY) {
> +			perror("FS_IOC_FSGETXATTR");
> +			exitcode = 1;
> +		}
>  		return;
>  	}
>  
> -- 
> 2.47.0
> 
> 
