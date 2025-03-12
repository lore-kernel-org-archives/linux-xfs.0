Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C9A13D81;
	Wed, 12 Mar 2025 20:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741810826; cv=none; b=b5BYOMtPamPCBXTSTeJNE02/QNJvKKtP0wAeKcVAwdBMlDnDegKz1yCfbYSfan2LulXoaOhzxq1KkOoRhJ+TXL+2gcJnq+FI5txuTh91wFfcfQ2K7/SV2aCLa4GxVQBIuxa3UyxhiyNRQmgUEy0gZrlXg3WWrymeMox699PIde8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741810826; c=relaxed/simple;
	bh=+kbSi1e4e0MbGGQGxD1fm189DyZzGY5l3sWTfOXY36E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sc3ZA2Qz6y+ZnVL2tnOAfCxXmwLHYNHEV2FREGnSXPz+BrxZM4F0zcfNqbTyVJQsUiEVvqNT4BfWLaZOXCnm8nlwBk6kzZrXY4hYo32A6wV6mgVT8BNKO4eKscJTuMxJ10LyWus1lR1i4HyYF8PTdt45eo5H0xxKSzyYTr8sLDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ozAtfIf0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ozAtfIf0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9F99C4CEEB;
	Wed, 12 Mar 2025 20:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741810825;
	bh=+kbSi1e4e0MbGGQGxD1fm189DyZzGY5l3sWTfOXY36E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ozAtfIf0+boh0CCKZYybQUPx2pHfPQ1FgJHQ8Z2GPpShOEjM9iwttYOD/eHu49LWv
	 XfIrRyNULbTKyXr4Sc87O1F0JRc8qv4uRNo8HpBBZl7w5i8bxgZLA0yOazhZ8cdj9K
	 w9XqyUSJmWJs58QHx3DzRKXzKZyXJ4yHkTWWqSbpqI4pHYWQoXzQ+6IOjNY4dcFEIn
	 oyUGck+a8s9xAxw0SQdjZjYS9dCMavP8z44LXRSeBBxfxmEMTIQGDhkuyeTRWcfwtN
	 uec7kfi9ijwUvT4FFA+V6mmWJmVAA8EIuYH3IFVbv8xRFkO+VbFP9hpDQQcf4WgCSP
	 xm3J/ikxLSuvA==
Date: Wed, 12 Mar 2025 13:20:25 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 17/17] xfs/206: filter out the zoned line from mkfs output
Message-ID: <20250312202025.GK2803749@frogsfrogsfrogs>
References: <20250312064541.664334-1-hch@lst.de>
 <20250312064541.664334-18-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250312064541.664334-18-hch@lst.de>

On Wed, Mar 12, 2025 at 07:45:09AM +0100, Christoph Hellwig wrote:
> So that the test still passes with a zone enabled mkfs.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Same patch that I had!
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  tests/xfs/206 | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/tests/xfs/206 b/tests/xfs/206
> index 01531e1f08c3..bfd2dee939dd 100755
> --- a/tests/xfs/206
> +++ b/tests/xfs/206
> @@ -66,6 +66,7 @@ mkfs_filter()
>  	    -e '/metadir=.*/d' \
>  	    -e 's/, parent=[01]//' \
>  	    -e '/rgcount=/d' \
> +	    -e '/zoned=/d' \
>  	    -e "/^Default configuration/d"
>  }
>  
> -- 
> 2.45.2
> 
> 
