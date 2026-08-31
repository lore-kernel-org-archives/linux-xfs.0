Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E93ED3806D8;
	Mon, 31 Aug 2026 18:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788199298; cv=none; b=p2j3LRnCCUdzPHlRar258+4J83pBZBoINOyhEKxC5cQ6FNdghiM2Z8kJvGI7iVC61r0kgCK23UuMxfcae38s6DU5UM4lcFFzhbcZCXwt70btycAeFpwuG96voiGjTsheICJBQ7H6VENA2H57zwR5pfDmkOrablh7dx9Cddd7C0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788199298; c=relaxed/simple;
	bh=mBzLGaz53Y0J4cE5F8BfsoILEa9Y+Ne88bZcKp16zxY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tZqRYW/tqaREWj6/psy3ExGZf4xgHgg2xV8+YAOocpnvTFQ4fZ2LMy+Vh6ijBp++SUiATp5h+LUq1cAB7jpsgjOL6sSzlNGuAm2DxDW8LLRCcxMNq6qC2MFDPIIoz9iKaky5t4XK23nq6rXOrZK8ok5MwY8AD1X5aAJLCOjgnLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FFJrkBWb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FFJrkBWb"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 7F8FA1F000E9;
	Mon, 31 Aug 2026 18:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788199296;
	bh=OGJJKZgoD6NS6/qIWt4GoB9kaQXOxh4gAkPB/HkafZo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FFJrkBWb6f+RVG4fu067YyGqSLArVr66IQ8KGnO5Jf3VtyGzIiJrhNOB/nCY6Q91K
	 ivcFj7i64QSTlI2O55oy8p0iwnYveAzC7LX5aOr3JtiQepSHFFGMz8KCNlE7RyDWTc
	 5O9ZYANgoFKDZDel9t251cd6UwyCiVlPG0Nl0GOp1C34fmZz3168v0DDIBbPfsSx2Z
	 LvvNuqafU46maJK2KAlHTZKk9v9aALYRKZFhghx6rBZeWQreFv+dM9kjpKISUnreix
	 DYn1SY65pjABwsuwu5EZ6kwnrykOR+G56qfZzDX3sYEjDN+O8sWaL833x903DGyeWW
	 xJOmRMoJcRHXg==
Date: Mon, 31 Aug 2026 11:01:36 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Tal Zussman <tz2294@columbia.edu>,
	Anuj Gupta <anuj20.g@samsung.com>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 02/17] block: warn on too larger integrity allocations
Message-ID: <20260831180136.GI1933798@frogsfrogsfrogs>
References: <20260831064010.2574896-1-hch@lst.de>
 <20260831064010.2574896-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831064010.2574896-3-hch@lst.de>

On Mon, Aug 31, 2026 at 09:39:50AM +0300, Christoph Hellwig wrote:
> Catch cases where upper layer bugs create larger I/Os than the
> mempool would return even without dipping into the mempool.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/bio-integrity.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/block/bio-integrity.c b/block/bio-integrity.c
> index b23e2434d80c..d3df726e0f08 100644
> --- a/block/bio-integrity.c
> +++ b/block/bio-integrity.c
> @@ -72,6 +72,7 @@ void bio_integrity_alloc_buf(struct bio *bio, gfp_t gfp, bool zero_buffer)
>  	unsigned int len = bio_integrity_bytes(bi, bio_sectors(bio));
>  	void *buf;
>  
> +	WARN_ON_ONCE(len > BLK_INTEGRITY_MAX_SIZE);

Should it fail the bio after complaining, then?

--D

>  	buf = kmalloc(len, gfp | __GFP_NOWARN | (zero_buffer ? __GFP_ZERO : 0));
>  	if (unlikely(!buf)) {
>  		struct page *page;
> -- 
> 2.53.0
> 
> 
