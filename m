Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 379011F927
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jan 2024 23:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F11Gw5sb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E5FAC433C7;
	Wed,  3 Jan 2024 23:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704326169;
	bh=7gY9azDXC9s5u4QlwSCz7zweBOkdXj1buGS+XsT4Zng=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=F11Gw5sbrV0JLSIqxUYLyApLxiQQN7NlooAvghxI/6N1JYwNDYo7X6TABP24qC41h
	 2FveKS4QuvHN9s/76KNBxFI4xc5umjaEliG9R39n86fBGlwxSCGIiefpqkCoFBwC6S
	 /7t6EpyzSV6TlaZlKC3RPCy45VltcOPXarWYPG6VZjKY9R6qf0aMMI71PLEHPc5OzJ
	 DgcP1482QdsvamB5ry2l2piTDGgvoL4tw6SWLqJKXnkgVIHZR4O24KQZLGJ8pvFcGo
	 blBQr13bNpC5ZXYs2xEQPjvCuOsgjCpogo7JdsC+VQjXijS3+bbUIakcoGpsiCyzsT
	 WiYvoZQ59JSSw==
Date: Wed, 3 Jan 2024 15:56:09 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 07/15] xfs: shmem_file_setup can't return NULL
Message-ID: <20240103235609.GA361584@frogsfrogsfrogs>
References: <20240103084126.513354-1-hch@lst.de>
 <20240103084126.513354-8-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240103084126.513354-8-hch@lst.de>

On Wed, Jan 03, 2024 at 08:41:18AM +0000, Christoph Hellwig wrote:
> shmem_file_setup always returns a struct file pointer or an ERR_PTR,
> so remove the code to check for a NULL return.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

I guess the bots will stop hassling me about this if I say
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/scrub/xfile.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/scrub/xfile.c b/fs/xfs/scrub/xfile.c
> index 46f4a06029cd4b..ec1be08937977a 100644
> --- a/fs/xfs/scrub/xfile.c
> +++ b/fs/xfs/scrub/xfile.c
> @@ -62,15 +62,13 @@ xfile_create(
>  {
>  	struct inode		*inode;
>  	struct xfile		*xf;
> -	int			error = -ENOMEM;
> +	int			error;
>  
>  	xf = kmalloc(sizeof(struct xfile), XCHK_GFP_FLAGS);
>  	if (!xf)
>  		return -ENOMEM;
>  
>  	xf->file = shmem_file_setup(description, isize, 0);
> -	if (!xf->file)
> -		goto out_xfile;
>  	if (IS_ERR(xf->file)) {
>  		error = PTR_ERR(xf->file);
>  		goto out_xfile;
> -- 
> 2.39.2
> 
> 
