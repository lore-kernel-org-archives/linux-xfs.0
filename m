Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 189014D178F;
	Wed,  7 Oct 2026 17:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791392461; cv=none; b=JgiR3KHtLuq8hii1oLrdFxe//e3quIWdot+MK/ZbI5adMUVdMkztjK6GyhdOdJTyKTzRiNrhcNY1pWcVRg04hDeRYPJUo7jVWvKmfMzqcMpltKV36NB3zBI/YepwYq3ZxiOF6xi4eCBsII9nXoCDXyk5deAO4MyxND5dtjrEC10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791392461; c=relaxed/simple;
	bh=ysdp/YAjXwce2l3rf2BeyKaCrmU6N6BSjtcFvOuK1uc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kL7bNcGgSic7WeIasrOrH58qzqDkSwPOAS90nsSnJZmraB7GKhcs/TEHTpzAlfDWAkI+ABcW35K9b0pqUSdORVXWzMgacF/+/YnOHBjp38qHOUuHlacPmPsz1dzxmgtbajVexNBZ3NpDeRNvzWfZHmV18PhowxjfW8g7dlIcpjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dk0p+Kz+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dk0p+Kz+"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 711491F000FF;
	Wed,  7 Oct 2026 17:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791392459;
	bh=sOS6Jzi+xYwvZBAytpXLpG9ZmIAM+53nk1zQPrHjDb4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dk0p+Kz+LUbU25BVIwXDExoRtoz8GBvKrjTsX8NSub1pvnacEzdxKYrL6K76T2JQW
	 GMo0Sxv78lkT4QiY4uVGYa1wTLq2PE/bSwhsSmq+pDPRT5odUWH3bC20qGBEBVTVUZ
	 Ec3N3USpgbywfcXz33YoyR4m7RPXWzBHdNc0QUosdseEzB+5JPNHVWlD6DD+BfIng1
	 oqhRMNpSWgApQ1RzviFDNkk2dVR4IFt+QnpisndhkIKQPIn4iqX/51Dxb2ASijlqBE
	 Zh3aB5uGgG7ca7k3IJqFRS9fQoxe6TtyP05E2aWFlF3G0eSoqzs5gJIxCFKcUovLD6
	 sPRqOYhsud2Ww==
Date: Wed, 7 Oct 2026 10:00:58 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Lukas Herbolt <lukas@herbolt.com>
Cc: zlang@kernel.org, fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-ext4@vger.kernel.org
Subject: Re: [PATCH 1/1] lib/random.c fix undefined behavior on signed
 integer overflow.
Message-ID: <20261007170058.GG2705364@frogsfrogsfrogs>
References: <20261006135205.400485-1-lukas@herbolt.com>
 <20261006135205.400485-2-lukas@herbolt.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261006135205.400485-2-lukas@herbolt.com>

On Tue, Oct 06, 2026 at 03:51:52PM +0200, Lukas Herbolt wrote:
> The random.c now expects that signed integer to overflow and
> triggers the  ^MASK branch. But signed int overflow is undefined
> behavior and GCC can optimize this branch out with certain
> CFLAGS/LDFLAGS.
> 
> Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
> ---
>  lib/random.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/lib/random.c b/lib/random.c
> index d5c81be817c8..f767ed1d1337 100644
> --- a/lib/random.c
> +++ b/lib/random.c
> @@ -186,14 +186,15 @@ _random (int32_t is [2])
>  int32_t 
>  _irandm (int32_t is [2])
>  {
> -	int32_t it, leh, nit;
> -
> +	int32_t it, leh, nit, apply_mask;
>  	it = is [0];
>  	leh = is [1];
> -	if (it <= 0)	
> -		it = (it + it) ^ MASK;
> -	else
> -		it = it + it;
> +
> +/* 	evaluate on original value — no UB here */
> +	apply_mask = (it <= 0);
> +/*	double via unsigned shift — well-defined */
> +	it = (unsigned)it << 1;
> +	if (apply_mask) it ^= MASK;

Doesn't _random suffer the same flaw?

Oh.  It's dead code, maybe it should go away?

Also, what about converting all the variables to unsigned?

--D

>  	nit = it - 1;
>  /*	to ensure all-ones pattern omitted    */
>  	leh = leh * mt[nit & 127] + nit;
> -- 
> 2.55.0
> 
> 
