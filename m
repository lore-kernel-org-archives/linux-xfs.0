Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B30F128A704;
	Fri, 14 Nov 2025 17:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763139984; cv=none; b=ermlmsDubykM8AnByIoytutxE9T47W8oZlBtAaH/BRSCsJ4R4LDuo1YxFeKWAQ5nqBzBWHVi6nvCHgvcINHxVdLuWggRPEYCHVn1vvnZGX7xNUXL4m7AyVb4BIpyQDHUR1j7vdikjuKUuzLzNPF/F2F33osbnm2gVXBphMJfw2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763139984; c=relaxed/simple;
	bh=w0i96fXKDhKHkWWpLUUlwu2DiFVVK8gVhYnMkhFa980=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c9wVMMRpjyvgFz6BmOmFpM88kC32NBw9Ld0gxyjvFCQdxNQ21/tl8l9V4Orhajqjx+KKaF5aXkk8gaBBarJ7Dmlfa0X9qrklzpxDC5FlTsA2gdeiDCjfqPPX7GRKdUgyuWAJzonZn8UxRbOM7nbpLNVfPiY0sXvOvJ3dLIqW794=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q0NgKSpT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q0NgKSpT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3979CC19422;
	Fri, 14 Nov 2025 17:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763139984;
	bh=w0i96fXKDhKHkWWpLUUlwu2DiFVVK8gVhYnMkhFa980=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=q0NgKSpTUyKqfws8Yhd80qAAEXnYwmT2GR+fKiAEBmMFuOOBprxld9WiqlG1U+W5U
	 9fgZCF4gTWnZ/Rys7WS+g1oFk5nKimyFfbJV/nj0F1T6YrfVZIlRXHMA8NFm8G9m0M
	 TkhwG0gcFgMecbNxryj0Zn7S/OVzN+VbZNWIPped5nzvgqNb1AuRk6+7n9crbNumUW
	 3B8SsHPgbekZqMObCVcLHPvzB4InUc8e7KKQk+eZwhkM3bEVHXIjcMVwey8q9wztHI
	 OH3uFgI8xlo3Sf/OpNUrCS7yCvdouRzLsoGfHLdEnZv/DuLgnVIKWwljEY8ur8tkMu
	 B44HgobcRq03Q==
Date: Fri, 14 Nov 2025 09:06:23 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
	Chris Li <sparse@chrisli.org>, linux-sparse@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: work around sparse context tracking in
 xfs_qm_dquot_isolate
Message-ID: <20251114170623.GK196370@frogsfrogsfrogs>
References: <20251114055249.1517520-1-hch@lst.de>
 <20251114055249.1517520-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251114055249.1517520-4-hch@lst.de>

On Fri, Nov 14, 2025 at 06:52:25AM +0100, Christoph Hellwig wrote:
> sparse gets confused by the goto after spin_trylock:
> 
> fs/xfs/xfs_qm.c:486:33: warning: context imbalance in 'xfs_qm_dquot_isolate' - different lock contexts for basic block
> 
> work around this by duplicating the trivial amount of code after the
> label.

Might want to leave a code comment about shutting up sparse so that
someone doesn't revert this change to optimize LOC.  That said ...
what is the differing lock context?  Does sparse not understand the
spin_trylock?

> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_qm.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 95be67ac6eb4..66d25ac9600b 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -422,8 +422,11 @@ xfs_qm_dquot_isolate(
>  	struct xfs_qm_isolate	*isol = arg;
>  	enum lru_status		ret = LRU_SKIP;
>  
> -	if (!spin_trylock(&dqp->q_lockref.lock))
> -		goto out_miss_busy;
> +	if (!spin_trylock(&dqp->q_lockref.lock)) {
> +		trace_xfs_dqreclaim_busy(dqp);
> +		XFS_STATS_INC(dqp->q_mount, xs_qm_dqreclaim_misses);
> +		return LRU_SKIP;
> +	}
>  
>  	/*
>  	 * If something else is freeing this dquot and hasn't yet removed it
> @@ -482,7 +485,6 @@ xfs_qm_dquot_isolate(
>  
>  out_miss_unlock:
>  	spin_unlock(&dqp->q_lockref.lock);
> -out_miss_busy:
>  	trace_xfs_dqreclaim_busy(dqp);
>  	XFS_STATS_INC(dqp->q_mount, xs_qm_dqreclaim_misses);
>  	return ret;
> -- 
> 2.47.3
> 
> 
