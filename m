Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 275781C9B7B
	for <linux-xfs@vger.kernel.org>; Tue, 22 Oct 2024 17:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729619969; cv=none; b=B1EtHany7d6wuKBX8ETC2KIlyYqbnrCvnuHZSnxVDbDiFxaWps7kB2rBzTtvFvxdbQTbfmlTSrhBpRDg8+W1+2i3+HtlA7Cm8aTfuJ171Q3EluLa4IEBMlge5K4uy7GspOCQg7krf8SA+BD6GhdxPf+F1xWgw+zRrLVMxG4sQKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729619969; c=relaxed/simple;
	bh=1w8bRlaExqtU4C3dtaCMRpPH2yoOoAsw5hOXPSLxi4Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LWvT3Pt6xSgEDxeAuWSjqluW28Pt2AUiLtej2hPzvkdAeFq3yeu2tjTMi78L5njY/IqdYteCjWi6jAVrD7Ilc8R7c4Xzoft3yBavc/BlA3jsSyzLY9f+cwKjxHQPo9oO7D4nfde+mACEsa6GQM1XHC0Qdi2OCWjfShcATHeXk6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bZkUlBax; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bZkUlBax"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9349FC4CEC3;
	Tue, 22 Oct 2024 17:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729619968;
	bh=1w8bRlaExqtU4C3dtaCMRpPH2yoOoAsw5hOXPSLxi4Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bZkUlBaxF5xtuUM5G8iFKtNd5o4n5obttbxDts5f5f/UBIXIa/uPVQ1NlAC1WogDR
	 n99JtBhunvAP1Lz9FqFs6Fgu55gVosI7ax+NrX1+hBYIOHCDLMenz/Uv59odGT7gqo
	 SGzsdbtIC1THnhU0QQk2dr2u5FRvc+2B05FbZ3KBWtRPLtqEUk46AOkri+ZjrNOWfz
	 LgL5LLaRuCFCOqEexGPghbLaJwuRmQrdPGDriIRrEveJ86dFI3aVGcdVTL57TSfkeG
	 99cdqvLn6nD/Dl0rF3oMSvmM6OMyIJgXd5i3TKbeKNjUO3Z2alKMf8i/WpLI2OxpZc
	 ugebEXrEQchZA==
Date: Tue, 22 Oct 2024 10:59:28 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	syzbot+4125a3c514e3436a02e6@syzkaller.appspotmail.com
Subject: Re: [PATCH 2/2] xfs: fix finding a last resort AG in
 xfs_filestream_pick_ag
Message-ID: <20241022175928.GE21853@frogsfrogsfrogs>
References: <20241022121355.261836-1-hch@lst.de>
 <20241022121355.261836-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241022121355.261836-3-hch@lst.de>

On Tue, Oct 22, 2024 at 02:13:38PM +0200, Christoph Hellwig wrote:
> When the main loop in xfs_filestream_pick_ag fails to find a suitable
> AG it tries to just pick the online AG.  But the loop for that uses
> args->pag as loop iterator while the later code expects pag to be
> set.  Fix this by reusing the max_pag case for this last resort, and
> also add a check for impossible case of no AG just to make sure that
> the uninitialized pag doesn't even escape in theory.
> 
> Reported-by: syzbot+4125a3c514e3436a02e6@syzkaller.appspotmail.com
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Tested-by: syzbot+4125a3c514e3436a02e6@syzkaller.appspotmail.com

Well, that bug was pretty subtle. :(
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Nit: should trace_xfs_filestream_pick() lose its third argument?

--D

> ---
>  fs/xfs/xfs_filestream.c | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
> index f523027cc32586..ecf8a0f6c1362e 100644
> --- a/fs/xfs/xfs_filestream.c
> +++ b/fs/xfs/xfs_filestream.c
> @@ -64,7 +64,7 @@ xfs_filestream_pick_ag(
>  	struct xfs_perag	*pag;
>  	struct xfs_perag	*max_pag = NULL;
>  	xfs_extlen_t		minlen = *longest;
> -	xfs_extlen_t		free = 0, minfree, maxfree = 0;
> +	xfs_extlen_t		minfree, maxfree = 0;
>  	xfs_agnumber_t		agno;
>  	bool			first_pass = true;
>  
> @@ -113,7 +113,6 @@ xfs_filestream_pick_ag(
>  			     !(flags & XFS_PICK_USERDATA) ||
>  			     (flags & XFS_PICK_LOWSPACE))) {
>  				/* Break out, retaining the reference on the AG. */
> -				free = pag->pagf_freeblks;
>  				if (max_pag)
>  					xfs_perag_rele(max_pag);
>  				goto done;
> @@ -149,18 +148,19 @@ xfs_filestream_pick_ag(
>  	 * filestream. It none suit, just use whatever AG we can grab.
>  	 */
>  	if (!max_pag) {
> -		for_each_perag_wrap(args->mp, 0, start_agno, args->pag)
> +		for_each_perag_wrap(args->mp, 0, start_agno, pag) {
> +			max_pag = pag;
>  			break;
> -		atomic_inc(&args->pag->pagf_fstrms);
> -		*longest = 0;
> -	} else {
> -		pag = max_pag;
> -		free = maxfree;
> -		atomic_inc(&pag->pagf_fstrms);
> +		}
> +		/* Bail if there are no AGs at all to select from. */
> +		if (!max_pag)
> +			return -ENOSPC;
>  	}
>  
> +	pag = max_pag;
> +	atomic_inc(&pag->pagf_fstrms);
>  done:
> -	trace_xfs_filestream_pick(pag, pino, free);
> +	trace_xfs_filestream_pick(pag, pino, pag->pagf_freeblks);
>  	args->pag = pag;
>  	return 0;
>  
> -- 
> 2.45.2
> 
> 
