Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793605028;
	b=WtzIfNwDvTGelBQlkeDuc42TKmchLh3VNDUZsHgZQT8+JNgbem8nSgGklNTAEjy6lTy+
	 eBf9BQvtAvTAkSNCh1720tpPLmJ67VCi69qGGDMhRsMXKYuqCpD8i/KDhavVZ90uKjQI8
	 fsEyyAF9zz4IjNlJ6BhFopRCyhVGQY7/kKw5bAxFOjB5pw6m3Vb9RKBcyKzxk+p1UcCAX
	 AuX0vld2Fj2n1KjkMf46lDE0oPhBHwa9eipd3ZNeufXuLa5vBezn3Q2gQnYJIKYtb/9ti
	 7bnbP7YRiAwkJoAtSFkGNSNjXRhXBMhxAg/zzpcsTQusezjBtMYDW/WuQ0p9zKqRaDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793605028;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 Mail-Followup-To:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=GuieGMbyNSD13Qn2uxd14dcXP56/y9iy+bE6dEAYbbw=;
	b=aVD7b0bu2t8hTWFydVPuvPMS/sys6TT1K3NcL5lEN4GAZiIwjCNXYpgc6t1RtwYj6oLV
	 wKLviiRva2ghLfSit0UJUo4VH2dlIRrZgpvYuIl3nSCalxoBd67CSgF8g9bRLlEy+BeKp
	 7y/auhtcwUzCBlxC8C4YJJ4aMZf1U62OsMkAeNLrI9cXR+csgT1j4Fy+NFYOTF0Dg21BG
	 on9IA9WRc+r5DZKoIY2hf0+UzsMEveK2tD68HbrAvvuHsJuE3zcIaiaoDk7+Z/Rvz9m6m
	 Ql8x3RBoUHadEWmJZCLWERJqu70V+cmw42++s86cmfMWaRwAYtF3QZN4UqcCV3iP4tg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JGOdajgH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF69160A260A;
	Mon,  2 Nov 2026 07:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JGOdajgH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78E331F00A1A;
	Mon,  2 Nov 2026 07:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793605027;
	bh=GuieGMbyNSD13Qn2uxd14dcXP56/y9iy+bE6dEAYbbw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JGOdajgHk6a6gDnapdaHnQIFiPnu92ijaZvkOp0W1/85eTy+rCP3r194vLz3qr7Nb
	 CVtifjaphjaU84ILk/EJcWjFygIsxeGmclDWPAEFPeq0rvOwKjvgwCM1NyxfzmkOnY
	 290vImhV/ARO+lewI5+VjONLJTs2mOkXdDDd66JANLvyEqe/eg31Ax8eUEEgl/aIEo
	 UXkaUovX+7oTgAD2PLYl65jpkSR93MdYzJ9YJ2QjKKE7th0WI02avw0pEyWZq1EjZg
	 B+lxs2xmGGpWQ74vDrinP59RPehWD5JZF4fp0mhqZdaDE0419DdjqYU+X2L5uFBzPD
	 Wawaq0bRAukmw==
Date: Mon, 2 Nov 2026 15:37:02 +0800
From: Zorro Lang <zlang@kernel.org>
To: Lukas Herbolt <lukas@herbolt.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] lib/random.c fix undefined behavior on signed integer
 overflow.
Message-ID: <aug9g-osyv31_yQN@zlang-mailbox>
Mail-Followup-To: Lukas Herbolt <lukas@herbolt.com>, 
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
References: <20261016092111.296275-1-lukas@herbolt.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261016092111.296275-1-lukas@herbolt.com>

On Fri, Oct 16, 2026 at 11:21:11AM +0200, Lukas Herbolt wrote:
> The random.c now expects that signed integer to overflow and
> triggers the  ^MASK branch. But signed int overflow is undefined
> behavior and GCC can optimize this branch out with certain
> CFLAGS/LDFLAGS. And cleaning up the dead code.
> 
> Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
> ---

V2 looks good to me,

Reviewed-by: Zorro Lang <zlang@kernel.org>

>  lib/random.c | 34 +++++++---------------------------
>  1 file changed, 7 insertions(+), 27 deletions(-)
> 
> diff --git a/lib/random.c b/lib/random.c
> index d5c81be817c8..558da4e6888d 100644
> --- a/lib/random.c
> +++ b/lib/random.c
> @@ -162,38 +162,18 @@ static int32_t mt [128] =   {
>            69069
>  		};
>  
> -double 
> -_random (int32_t is [2])
> -{
> -	int32_t it, leh, nit;
> -
> -	it = is [0];
> -	leh = is [1];
> -	if (it <= 0)	
> -		it = (it + it) ^ MASK;
> -	else
> -		it = it + it;
> -	nit = it - 1;
> -/*	to ensure all-ones pattern omitted    */
> -	leh = leh * mt[nit & 127] + nit;
> -	is [0] = it;    is [1] = leh;
> -	if (leh < 0) leh = ~leh;
> -	return (SCALE * ((int32_t) (leh | 1)));
> -}
> -
> -
> -
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
> +/* 	evaluate on original value - no UB here */
> +	apply_mask = (it <= 0);
> +/*	double via unsigned shift - well-defined */
> +	it = (unsigned)it << 1;
> +	if (apply_mask) it ^= MASK;
>  	nit = it - 1;
>  /*	to ensure all-ones pattern omitted    */
>  	leh = leh * mt[nit & 127] + nit;
> -- 
> 2.56.0
> 
