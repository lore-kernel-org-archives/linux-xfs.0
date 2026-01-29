Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E23852DA756
	for <linux-xfs@vger.kernel.org>; Thu, 29 Jan 2026 08:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769676728; cv=none; b=mEZNCJWD/bo4K0ocHfkmg1qZHpfjqj+ToJZ0GZM1sosBqzk1WE/0Vb0+s2dQTYdEpKgy6WCl6o92zMofdd4QlJ+xw4C2pg0pMlFsZE/GCBbM7+p3i9wpaP8zGf3ukuXrC7HwW+elC+C8Jih1yM45ybRC0jos0VzdehjJWWN90j4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769676728; c=relaxed/simple;
	bh=/DhtnD1OPf3W54jyYezZ6e+BRE3tUASt9AhjWUrMFCk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CAp5IYmLoAtDh5WEZVCG5smWDHHnU+vaUHLIsp2yR0VmHIpJEo3uddE44B6YZvhfokO3ELn1wkdrflheRNn3MLbzyQuFV9pl0KbIww5t2RS5Yoa6+5n+sMbHNwh7Q/jaBYzTpRwL+vDzbMjIlmHq7YlIoV4pwGRL5iUKC90k0mQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kD3GEsk1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kD3GEsk1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 827DCC116D0;
	Thu, 29 Jan 2026 08:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769676727;
	bh=/DhtnD1OPf3W54jyYezZ6e+BRE3tUASt9AhjWUrMFCk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kD3GEsk1/ckpFXHtfz3ohcWYSiELgWrFpQCB922tRbCDHqC2euzspt8L7FlbWGt12
	 h4EIY5Q/QaleqXDRpGoeoCod4ATbWmR74KOiHb+VcvZfgwxNLkwSCnJaxqHcWKlXY0
	 SNfBbvhVRAwmPXXPOlgn0GDtD0b0xgRg0t0b6AB7iWjfDGIQ59xNJtt6sHwv0/YXF4
	 HjPRZwocR56NY2rQNSIjDN5wVU4RwkOzQwtAKm4OxkolUTqG52vhLXelMEK3QvUxUy
	 Sl6+uOhjy95w2m35c3CKIqFcpyq9+Nt8F7XivXMLlfh6alDXx58Llf+okRztl7PkOs
	 cSKC3wt6N3pJw==
Date: Thu, 29 Jan 2026 09:52:02 +0100
From: Carlos Maiolino <cem@kernel.org>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: linux-xfs@vger.kernel.org, ritesh.list@gmail.com, 
	ojaswin@linux.ibm.com, djwong@kernel.org, hch@infradead.org
Subject: Re: [PATCH v2 1/2] xfs: Move ASSERTion location in
 xfs_rtcopy_summary()
Message-ID: <aXse1lm9J66RTvwZ@nidhogg.toxiclabs.cc>
References: <cover.1769625536.git.nirjhar.roy.lists@gmail.com>
 <e9f8457440db64b07ab448bd7d426d3eb9d457d6.1769625536.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9f8457440db64b07ab448bd7d426d3eb9d457d6.1769625536.git.nirjhar.roy.lists@gmail.com>

On Thu, Jan 29, 2026 at 12:14:41AM +0530, Nirjhar Roy (IBM) wrote:
> We should ASSERT on a variable before using it, so that we
> don't end up using an illegal value.
> 
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
> ---
>  fs/xfs/xfs_rtalloc.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index a12ffed12391..9fb975171bf8 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -112,6 +112,11 @@ xfs_rtcopy_summary(
>  			error = xfs_rtget_summary(oargs, log, bbno, &sum);
>  			if (error)
>  				goto out;
> +			if (sum < 0) {
> +				ASSERT(sum >= 0);
> +				error = -EFSCORRUPTED;
> +				goto out;
> +			}

What am I missing here? This looks weird...
We execute the block if sum is lower than 0, and then we assert it's
greater or equal than zero? This looks the assert will never fire as it
will only be checked when sum is always negative.

What am I missing from this patch?

>  			if (sum == 0)
>  				continue;
>  			error = xfs_rtmodify_summary(oargs, log, bbno, -sum);
> @@ -120,7 +125,6 @@ xfs_rtcopy_summary(
>  			error = xfs_rtmodify_summary(nargs, log, bbno, sum);
>  			if (error)
>  				goto out;
> -			ASSERT(sum > 0);
>  		}
>  	}
>  	error = 0;
> -- 
> 2.43.5
> 
> 
