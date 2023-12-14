Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66AE360B99
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 17:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lRMqV827"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9F3CC433C7;
	Thu, 14 Dec 2023 17:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702573779;
	bh=pNKRlTYc5GQ+Lr6cn5bk+MrTIv3MY1ujMwIUPnIGEso=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lRMqV827xOxvYOPzasEO8nbcraMYfaWErfvGo+yOEIbRMg2nTtryzZ8WXEFfog8LP
	 AFeFaW9ftpu2MWRAcjtM1IG5cZylUmZXW/p1c03UfJKwy9RdPvUnJIckQGAi0kG9ZM
	 tGLLG6rpXvPCUHgWMnUvGUtC4HC6k/14Pdv/RW9kNgV0LJGLYgXL0RoSLiWgzrGtIC
	 IHx8z/OnCj2A6Y4ocidGI90m/5Gu+kPBVH9Cb4zg31CvsczTlg+9waw5Atr/ssBykG
	 rhSE//pAGGOgFxLfpuRvhmBzJFwyWrcYhaJhmxGsL4KiocZQixPhKEFEqYAlm89UYn
	 bpsvmRVEELvEQ==
Date: Thu, 14 Dec 2023 09:09:38 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Pavel Reichl <preichl@redhat.com>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH] xfsdump: Fix memory leak
Message-ID: <20231214170938.GN361584@frogsfrogsfrogs>
References: <20231214121715.562273-1-preichl@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231214121715.562273-1-preichl@redhat.com>

On Thu, Dec 14, 2023 at 01:17:15PM +0100, Pavel Reichl wrote:
> Fix memory leak found by coverity.
> 
> >>>     CID 1554295:  Resource leaks  (RESOURCE_LEAK)
> >>>     Failing to save or free storage allocated by strdup(path) leaks it.
> 
> Signed-off-by: Pavel Reichl <preichl@redhat.com>
> ---
>  restore/tree.c | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/restore/tree.c b/restore/tree.c
> index 6f3180f..66dd9df 100644
> --- a/restore/tree.c
> +++ b/restore/tree.c
> @@ -4977,9 +4977,22 @@ static int
>  mkdir_r(char *path)
>  {
>  	struct stat sbuf;
> +	char *path_copy;
> +	int ret;
>  
>  	if (stat(path, &sbuf) < 0) {
> -		if (mkdir_r(dirname(strdup(path))) < 0)
> +		path_copy = strdup(path);
> +		if (!path_copy) {
> +			mlog(MLOG_TRACE | MLOG_ERROR | MLOG_TREE, _(
> +				"unable to allocate memory for a path\n"));

Nit: the _( should be on the same line as the format string, right?

With that fixed,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D


> +			mlog_exit(EXIT_ERROR, RV_ERROR);
> +			exit(1);
> +		}
> +
> +		ret = mkdir_r(dirname(path_copy));
> +		free(path_copy);
> +
> +		if (ret < 0)
>  			return -1;
>  		return mkdir(path, 0755);
>  	}
> -- 
> 2.43.0
> 
> 
