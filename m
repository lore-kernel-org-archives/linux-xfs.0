Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42390131746
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 16:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713284131; cv=none; b=hSTVTdQ7/kHEtk75zoU6fWIKU03hCCo6aTs/Z3kuhSF+gtGvhvnQ6VZ92XK9P4ifZjK57KcXqdvGqG/pEkoAkZaubk5JmIumJhdbz5dvjXgwshx2lJpxXVSxdPIun0prey8TTAsIpH46Z0KxiZ/zWK06OmF1qjdO+dZLn00xNU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713284131; c=relaxed/simple;
	bh=rZIF2fcvFmysFI9vPSfqs2zOJaV9eD+aOpP9PmfZLjw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kMXtF4PFYv/djiHjCIlm4hmmW+QposwcpgQ25rGeZJJu+dNXRBnXJyskqqWGR6VzRboZ9Q33KVlj74hIZWag5Q9a9kr92d1zS5WFzu6NXrwgPtF6jvPNOqN7rRRRvDU30eIHWObmUTO+v7kgxcdNjcgum6YDPxPBvebzqVFzxT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qe/7H8rf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qe/7H8rf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C04B4C113CE;
	Tue, 16 Apr 2024 16:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713284130;
	bh=rZIF2fcvFmysFI9vPSfqs2zOJaV9eD+aOpP9PmfZLjw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qe/7H8rfto5i5stoKWw3tq29wg72asr2bKfaED9g10iVVJquQ7TN1BfyqUq+LEuY4
	 pSDAt9qn/a9RpRzsv4zSt5b9B+s3NL//Y/SpbwGiprNAti69atA0e7QB4/kICWFpnJ
	 z7eCxvDToSSTcq9BXCZxuoL0yOPRRTTnncG5j1UcDg9DbcKMBQyQHmqf37xEcUvgoL
	 YDQF8iKV6yOz+rEfGchzJmptGVD0nqpcpJtWV1WgOh4nQZIw44uICjm0lOVf0tj7OL
	 7vqW1Ve/xCRzaysJmuiIu0NYKfdn1ui414LvcM6K8wwML3DmieTaGigax4Jjbl16fE
	 czBZ07j9Ob5xw==
Date: Tue, 16 Apr 2024 09:15:30 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs_io: init count to stop loop from execution
Message-ID: <20240416161530.GL11948@frogsfrogsfrogs>
References: <20240416123427.614899-1-aalbersh@redhat.com>
 <20240416123427.614899-4-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240416123427.614899-4-aalbersh@redhat.com>

On Tue, Apr 16, 2024 at 02:34:25PM +0200, Andrey Albershteyn wrote:
> jdm_parentpaths() doesn't initialize count. If count happens to be
> non-zero, following loop can result in access overflow.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> ---
>  io/parent.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/io/parent.c b/io/parent.c
> index 8f63607ffec2..5750d98a3b75 100644
> --- a/io/parent.c
> +++ b/io/parent.c
> @@ -112,7 +112,7 @@ check_parents(parent_t *parentbuf, size_t *parentbuf_size,

check_parents is an artifact of the old sgi parent pointers code and
(apparently) its need to check parent pointer correctness via xfs_io
commands.  The Linux parent pointers patchset fixed all those
referential integrity problems (thanks, Allison!) and will blow this
away, so I think we should ignore this report:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git/commit/io/parent.c?h=pptrs&id=c0854b85c1e8c90ea3eea930a20d1323e61ddb40

--D

>  	     jdm_fshandle_t *fshandlep, struct xfs_bstat *statp)
>  {
>  	int error, i;
> -	__u32 count;
> +	__u32 count = 0;
>  	parent_t *entryp;
>  
>  	do {
> -- 
> 2.42.0
> 
> 
