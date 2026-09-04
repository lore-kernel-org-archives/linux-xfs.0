Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC19B426427;
	Fri,  4 Sep 2026 06:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788504517; cv=none; b=jkQopccTBZTNTKY1q4zfYsUtUvo+pXmncF0QKrdZNMwgq68KSrdttxAHgIwTzEGQBuzmZ6rgg6AJ3bj1Z9v5phWDmPgwgJZZkwXSUC1ay+FEwMMJfvUijVyYfZWgl+wdXYpodIN6OJOfv9QDijjL0YnkxcWdjqM1LN9tOuvSex8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788504517; c=relaxed/simple;
	bh=eu3xD2AtPk7lHTXga+u+riO1S4WqA9s6YWYa1iIBzn0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tyXIA9/uv0ekqoHQfSmtbTt6EVp0ICKLF/7QU4FYe0zu3BeCvG8HQjJjmGhgd1Ueh3b5y1kq3Q5tYA/oKNfc/PtKvY2E1Ne5MStxGCzdCECiSAaET5qzKAPOwa3Ruw4TXRlJjBj2LRBA1UJmw//Xpj73JLcVrEnn63hO3EbAup4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oA9v89rt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oA9v89rt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0E381F00A3D;
	Fri,  4 Sep 2026 06:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788504514;
	bh=iWEddyI4n6UlY8pswLlcD+pdFtR1cK328zM5A2qYJrc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oA9v89rt85bQ+uyCOxnUf2nBgxdhMu5PGIZLCiYyuj4EqcfOq/0D2mboqRXdvtrlI
	 1bpaA64xBa0NI7Ctvy4aKRfwGeF4zvc/IJwWhTRr71JMh63XhNcdluiBiU81p17OcX
	 T33CqGcaxF5hUM2jvl2Fbo+bRX6hwngQbYzlEVzl+aNSRTdEqTi6alg7C7dMOAzrT4
	 6FWgk+ojXhco+TFujf+dUgCUwBFtiFIuhL+tABmJauZE28ZA1TREEV7tdFNOiOKCGc
	 DgYyTIfq6Jy+4ph3Pejns+LoACUox2pdSlZlcJDXByA5y5jwvNXwPko8i5vuxEhQpH
	 TTDtYkjb2KyqQ==
Date: Fri, 4 Sep 2026 08:48:30 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/6] xfs: report healthy filesystem events in scrub stats
Message-ID: <appptaSxBjNe17JM@andromeda.toxiclabs.cc>
References: <178850312462.1198660.3332635535003842521.stgit@frogsfrogsfrogs>
 <178850312540.1198660.5374727427398156944.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178850312540.1198660.5374727427398156944.stgit@frogsfrogsfrogs>

On Thu, Sep 03, 2026 at 11:26:17PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM also notices that I forgot to expose the "clean bill of health"
> scrub stats.  Fix that.
> 
> Cc: <stable@vger.kernel.org> # v6.9
> Fixes: a1f3e0cca41036 ("xfs: update health status if we get a clean bill of health")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> Assisted-by: LOLLM # finding obvious bugs
> ---
>  fs/xfs/scrub/stats.c |    1 +
>  1 file changed, 1 insertion(+)

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> 
> 
> diff --git a/fs/xfs/scrub/stats.c b/fs/xfs/scrub/stats.c
> index f3f1fbfb6d9955..da0c05ffe5cd0b 100644
> --- a/fs/xfs/scrub/stats.c
> +++ b/fs/xfs/scrub/stats.c
> @@ -84,6 +84,7 @@ static const char *name_map[XFS_SCRUB_TYPE_NR] = {
>  	[XFS_SCRUB_TYPE_RGSUPER]	= "rgsuper",
>  	[XFS_SCRUB_TYPE_RTRMAPBT]	= "rtrmapbt",
>  	[XFS_SCRUB_TYPE_RTREFCBT]	= "rtrefcountbt",
> +	[XFS_SCRUB_TYPE_HEALTHY]	= "healthy",
>  };
>  
>  /* Format the scrub stats into a text buffer, similar to pcp style. */
> 
> 
