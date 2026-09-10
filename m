Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B2EB3B582F;
	Thu, 10 Sep 2026 05:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789019194; cv=none; b=EwcpqHdDPjHe4j1fPovrZc5lzy9X//SDIpTgsV5OVWdzex6cC0XeOe7Jn+6F9rh42oKFka7jVw4meT2VKFhqltOtEuKl4vStt85Zu6Iu8anQha5GZ/2QELEC2jjrN0ACJlOLL3BK61p8+Cfq+0J6Rv3gy/YThMTMJXMINSTMz7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789019194; c=relaxed/simple;
	bh=7FAgVZxgl3mZTR+P/tvzuyZUCLYHEuAXS0VnA862fb4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HPk1M03w8EznIcFkkr4ApTLLPJ8NuHzHFPaw8LzNSslbJ0OF6R4BK/KobWFQkBTzifDb7mkiYrpS6hTtMkg8/sMVrHR/aTFW5veoJOWyP5haDULHbFnnGkC99TsRWhrDkiLhX+pnA85Cbj6wXv1ex+KPOKymA0uLoAy29UDIXCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m0PTRaL+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m0PTRaL+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C301B1F000FF;
	Thu, 10 Sep 2026 05:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789019193;
	bh=D4Kq2DEWPkAlN4tD+L54y2YtVxo4qDMi6lkxTkSjmfw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=m0PTRaL+YzoDEgcPyEm3RCHWA+bbUndPM710NExhU5uFqqDe9mNAGXXME4zGpM4Z1
	 qRC9vXvpRuNb3XHadu+sJm83NmVhsZQ371g1EmvdTohdiKOJYUzQCFsxDu/wllCUx+
	 4Tpi3zfNcTb3j7c5HPpd46fupZSbTzR7a7Y76oWQBH4TG8MCc5yoUwO3mYWfVFJ3Tg
	 CGOVjO5raYM17hwLikNJz1VxF3MUDBzRieekxHTQ+rYMGX07MdV4AqTsZlystkfqM2
	 EmuCAswNNSZHipux2HCmm97pxQ1sqHv1vRR5S59aP3pIxIAB/1HRMekeCz75Vp5hKc
	 c9j5zfko/FTMA==
Date: Thu, 10 Sep 2026 07:46:28 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/7] xfs: fix rtrmap cross-referencing elision logic
Message-ID: <aqJELYQawrOVlWCz@andromeda.toxiclabs.cc>
References: <178892936573.4057962.16225191041041958394.stgit@frogsfrogsfrogs>
 <178892936685.4057962.15653638717743353287.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178892936685.4057962.15653638717743353287.stgit@frogsfrogsfrogs>

On Tue, Sep 08, 2026 at 11:05:06PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM points out that xchk_bmap_xref_rmap_cow skips the cross-reference
> if the data-section rmapbt cursor is not present.  However, this is
> broken for realtime file data fork scanning, because they will have an
> rtrmapbt cursor and not an rmapbt cursor.  Fix the behavior by removing
> the cursor checks because xchk_bmap_get_rmap already accounts for that.
> 
> Cc: <stable@vger.kernel.org> # v6.14
> Fixes: 037a44d8277adf ("xfs: cross-reference the realtime rmapbt")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> Assisted-by: LOLLM # finding obvious bugs
> ---

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

>  fs/xfs/scrub/bmap.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
> index 401c278725d216..3b0f1dbd9147ac 100644
> --- a/fs/xfs/scrub/bmap.c
> +++ b/fs/xfs/scrub/bmap.c
> @@ -274,7 +274,7 @@ xchk_bmap_xref_rmap_cow(
>  	unsigned long long	rmap_end;
>  	uint64_t		owner = XFS_RMAP_OWN_COW;
>  
> -	if (!info->sc->sa.rmap_cur || xchk_skip_xref(info->sc->sm))
> +	if (xchk_skip_xref(info->sc->sm))
>  		return;
>  
>  	/* Find the rmap record for this irec. */
> 
> 
