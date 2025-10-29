Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9035834BA56
	for <linux-xfs@vger.kernel.org>; Wed, 29 Oct 2025 15:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761752476; cv=none; b=hav09ps0N+VPnFfjuZ4veQIPVkMTp1pYL9MnD92qglIvmu7dAV6vZXdEIxfhuFTL54H/4qIZyDHO1jVP4xmgZ96KDPsec9rtdbl1HqOScsaACCaFRm+Gxh099Up5Ls6lR9bAQQ9Vm/HQ4ZMC2eJcCz7FnSAWEpRCRcwWzB7wwqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761752476; c=relaxed/simple;
	bh=AP19EyAHEArxoMjxCZcTeQbXAkT3pp7UlJMsbgRb1gw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SUQINogRhU0XapxLzkleFUTlxb6WKPdmfeAMnw3xnu/e/mfcehzumeXwZ2y7Y3hXEl6KeYn6Eyji0YDou55OabGjvpG3tzpwp3UyHWBn4uBN1D8jSnpjdtvcZD4wuIWIrHI96jO23FUIv3B5HXU1ECMjs78CsXtoq3JRI4v19sI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rqJNlIHM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rqJNlIHM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F5F5C4CEF7;
	Wed, 29 Oct 2025 15:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761752476;
	bh=AP19EyAHEArxoMjxCZcTeQbXAkT3pp7UlJMsbgRb1gw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rqJNlIHM4IOwwKZOfXyd+cCmMZtNeflvB7I/7c+YJAud76bcxDoG301Vw3em3BC8X
	 Sph8v7Kr4Z0Dgrzyau1q6Wlc/nAfQ/dJS62BYW1DiqH71b7V8qLIO3O24mWo6QzUMQ
	 AotKXRCsEimOK7+w4DrZhLLn8TKh8YIMVgZVs0iybLH0cc2oHNbGIKjXsEyn4Cb31K
	 UjBDHM8MfHGBzJo0rGxOafhyIc+uYTM6zIJd1t/bEqmjVBDvxsKrsCpm/xQCC+xrpt
	 lHXOJEzUzIOOLfu66fDFnKXciREPPncLP6UdqrY0Yrd30vu0cftX+Ro2t7PZR+QHcZ
	 P1iEsoyYz+uAg==
Date: Wed, 29 Oct 2025 08:41:15 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cmaiolino@redhat.com, linux-xfs@vger.kernel.org,
	Hans Holmberg <hans.holmberg@wdc.com>
Subject: Re: [PATCH, resend] xfs: remove the unused bv field in struct
 xfs_gc_bio
Message-ID: <20251029154115.GB3356773@frogsfrogsfrogs>
References: <20251027070154.727014-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251027070154.727014-1-hch@lst.de>

On Mon, Oct 27, 2025 at 08:01:50AM +0100, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
> Reviewed-by: Hans Holmberg <hans.holmberg@wdc.com>

Looks good to me too,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_zone_gc.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
> index efcb52796d05..09830696b5f9 100644
> --- a/fs/xfs/xfs_zone_gc.c
> +++ b/fs/xfs/xfs_zone_gc.c
> @@ -117,7 +117,6 @@ struct xfs_gc_bio {
>  	struct xfs_rtgroup		*victim_rtg;
>  
>  	/* Bio used for reads and writes, including the bvec used by it */
> -	struct bio_vec			bv;
>  	struct bio			bio;	/* must be last */
>  };
>  
> -- 
> 2.47.3
> 
> 
