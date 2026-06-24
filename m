Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4465036A372
	for <linux-xfs@vger.kernel.org>; Wed, 24 Jun 2026 17:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782321614; cv=none; b=TA+E+mdxdCwbIjzuQhYnSnJzRiqExAMIr6cEXeQ8BDM/AA+H4BTHELjizTYBG7N3dHPa4XgXJE9izyFHxFhIvotUVXK2k/2Kw/m149Xy+t3BlVrnGlAFZPo/5grQOxSPiAn/kfKqUo+Xupk0DeC+hV7zJJ/tHtIoLaja7zJTqrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782321614; c=relaxed/simple;
	bh=1JP+XO51/Isj2nYCmX/MPY+ysciXdpP/9nsPHWUylv0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IyaRRnmBgPhTW9En4kspeUBbjSSyDryJj327mb7N3x6s0Og1vL5lUG9kuyj9Ihmmh2+L1WxOsq5lPFPJbIp6jK4+3/LGvNOeEqrG3Ff0mrqRYklH0M5h2BCfyQSlcdXZzJQxTczVu+N2A1sIPbLeAtSxg+roD/swomI+yfkkFio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S3VFM8Vo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S3VFM8Vo"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D5E8B1F000E9;
	Wed, 24 Jun 2026 17:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782321612;
	bh=ANHF4UxYI1kRswBfERaKrq91VjMFpq06NNlmFPeFAPs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=S3VFM8VozZGhk+aakGkj9Purm/it/PFGIjTJn3isSulPbazRWMsnzjyFkwVTOSAgY
	 uzxmPO7MWFN+33ACyMYJA4mZwwzNAlD16NlDoi2kxav0TYY8R3WfN4dsxVrrJkuhtU
	 0POi7kot4Xx9TE6UQD6fvN9jq3VzEHq9nfYvAWl55/ZAfTyu+5fHUKyrCwfTuIk17x
	 4JDTreKoZ5HQTgExRXh83S/wD76x4uENpaRQo+uLhHjL8jIfkKFID8BaEVypM5YF9M
	 hqUYSy0dTOGqZLgPLOf+bkZRNwc6P8hpd6p+7dZKB6D7P9ZuinLxGVzr4v3vumL72g
	 m5VFeiM0Nhz7A==
Date: Wed, 24 Jun 2026 10:20:12 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: liuh <liuhuan01@kylinos.cn>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] fsr: preserve xfrog_bulkstat error codes
Message-ID: <20260624172012.GP6078@frogsfrogsfrogs>
References: <20260624081135.12390-1-liuhuan01@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260624081135.12390-1-liuhuan01@kylinos.cn>

On Wed, Jun 24, 2026 at 04:11:35PM +0800, liuh wrote:
> Fix the bulkstat loop condition in fsrfs() to assign the return
> value of xfrog_bulkstat() to ret before comparing it against zero.
> 
> Without the extra parentheses, operator precedence causes ret
> to receive only the result of the comparison (0 or 1), which
> discards the actual error code and breaks error reporting.
> 
> Signed-off-by: liuh <liuhuan01@kylinos.cn>
> ---
>  fsr/xfs_fsr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
> index e74180c1..68cc0ea4 100644
> --- a/fsr/xfs_fsr.c
> +++ b/fsr/xfs_fsr.c
> @@ -678,7 +678,7 @@ fsrfs(char *mntdir, xfs_ino_t startino, int targetrange)
>  		return -1;
>  	}
>  
> -	while ((ret = -xfrog_bulkstat(&fsxfd, breq) == 0)) {
> +	while ((ret = -xfrog_bulkstat(&fsxfd, breq)) == 0) {

Heh, oops.

Cc: <linux-xfs@vger.kernel.org> # v5.3.0
Fixes: e6542132dec3cd ("libfrog: convert bulkstat.c functions to negative error codes")

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

>  		struct xfs_bulkstat	*buf = breq->bulkstat;
>  		struct xfs_bulkstat	*p;
>  		struct xfs_bulkstat	*endp;
> -- 
> 2.43.0
> 
> 
