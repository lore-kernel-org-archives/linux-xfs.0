Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD72C383
	for <linux-xfs@vger.kernel.org>; Fri, 14 Jun 2024 17:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718385884; cv=none; b=FUavAt5bgC85qHpAfsCsX2nljwx4yARrHz759UHzu3ZRAP4CVZ2we+FqlZO0HCd9mk2o8h7bCVpkW0e4SZhvGQxQe/LxihwJx7/Rst95Sf4BO3Ab4Yxy34vQWBYY+YHRRNdFs2Or4L/t9ZQ8uVCN2t0CZLh5HD6gACZuiITYvlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718385884; c=relaxed/simple;
	bh=rGjTJbSeCG/iiy01WBlQsIc1PIiox/HIRzoJSWH+nAo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NCZGI4oenBkIsG/+qT86A4Kgm/SqL4kJuBhOoGgI328V6z7s4W+aoo1AX3McxtA8q0EuSsvirCjVkAi+GDX3aPyervcmbiew/VM456l9x2eQit1rj7C6o+0r8pZF61CoDVjxEOPf3ZxD4/4vm44qk8iuRgbYDQ4GW/V7WBybgg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uzr9RdGB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uzr9RdGB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67111C2BD10;
	Fri, 14 Jun 2024 17:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718385883;
	bh=rGjTJbSeCG/iiy01WBlQsIc1PIiox/HIRzoJSWH+nAo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uzr9RdGBJSoM7mFB5LOU180hCtliAVg7MqBjlFBAZFKspT133Cv73qXJRhxuQy5NA
	 pdnrSRHp+Yp/ZAHTWzGx6AR2044kJwBfWliNOG7loyiq4HxJLcwgEIEqc8q5gcKVaI
	 UdzF298vprR/90XPYXZ5plhBd6YifUwI2nxN6YKDTWq948+2gq5GXlyUyNGa4v7/P0
	 OkpXdxlsZTdN7Tssup654rz8OJjryM1RI7TfDMcBm1JcGdlcLpRCdAzqX/L4YczmzR
	 s+4aH5Pwaxrnen4vCA8yqeiETEzpiRYpsxcuPJB0CqfpYr3xqpJywppJJoUhTng0gJ
	 WppZB7YWKJeIQ==
Date: Fri, 14 Jun 2024 10:24:42 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Bill O'Donnell <bodonnel@redhat.com>
Cc: linux-xfs@vger.kernel.org, cmaiolino@redhat.com
Subject: Re: [PATCH v3 3/4] xfs_fsr: correct type in fsrprintf() call
Message-ID: <20240614172442.GH6125@frogsfrogsfrogs>
References: <20240614160643.1879156-1-bodonnel@redhat.com>
 <20240614160643.1879156-4-bodonnel@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240614160643.1879156-4-bodonnel@redhat.com>

On Fri, Jun 14, 2024 at 11:00:15AM -0500, Bill O'Donnell wrote:
> Use %lld instead of %d for howlong variable.
> 
> Coverity-id: 1596598
> 
> Signed-off-by: Bill O'Donnell <bodonnel@redhat.com>

Looks good now,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fsr/xfs_fsr.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
> index fdd37756..06cc0552 100644
> --- a/fsr/xfs_fsr.c
> +++ b/fsr/xfs_fsr.c
> @@ -426,7 +426,8 @@ fsrallfs(char *mtab, time_t howlong, char *leftofffile)
>  	fsdesc_t *fsp;
>  	struct stat sb, sb2;
>  
> -	fsrprintf("xfs_fsr -m %s -t %d -f %s ...\n", mtab, howlong, leftofffile);
> +	fsrprintf("xfs_fsr -m %s -t %lld -f %s ...\n", mtab,
> +		  (long long)howlong, leftofffile);
>  
>  	endtime = starttime + howlong;
>  	fs = fsbase;
> -- 
> 2.45.2
> 
> 
