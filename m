Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7588937AA9E;
	Mon, 12 Oct 2026 13:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791812660; cv=none; b=s8SsQNQ5EubHssjQVcH9AWaNvMT/zwqzGkQD75mKvJCAUmF94fO2BEMIa5am0CL2Vu+K2kDeONWcl8ZBNgkU7Q7yJu5XbnUpt9fl6FZe6uN/1mmx8jkj08A3ZpofLXSzOBz3rs2W8eSsrbSXZrsRiaTgQd93ifsryguv1yJiPWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791812660; c=relaxed/simple;
	bh=g4MZXVR3FEA/8z+JZMSZqixlnJHos4pcAIoeJyIe6sE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mpgCLlxmFnxA7KqPcahcowpxZhtPiMig5S6PCuXBwcO5SAfJ0jNolPRFQgQMS3kx4tndq2WClibiezlo8CYrYqUEgO4lQ+4nr0l9kx0MWO5xWUmpWvrLGoPjTRF8MpXd2nw5bpeE/ZaOt7MXiGor73g0nO95GcANwOcwGxDwhlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UdE2PuBM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UdE2PuBM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8E621F0089B;
	Mon, 12 Oct 2026 13:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791812659;
	bh=ce6nZVUTHyykrOWLfcGsm6KIkVAYHGUMkqU81cO8UHE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UdE2PuBMKgN5ubF2snf+e8M2gkkSaNoO46pn+f/bcfsav9F9WzRfNB12IPtXTnXJT
	 02oqI/JqkBzbhVfnkTh63bw6C60Wad6IC95XGbh7JlBFej6jSYpnere92ZU7FWBOqC
	 +s/yE0E8P+r2UoVKluyrU2OSUF/akZ0ufyPAwBIB0ECAfln2WCcyTbWnjj18FQ1MUs
	 0/kAi2Uc/tKrMTv7L+fTJ2wcjnppEIdPra+YQuOknBovXWG/FKSr+8LJfU8L036V2O
	 Zzfcojfrf7lXb8PbK3GXVkETshNA6xWuDGYanllcy2uv8pR9SfsYsj7H4kHBpRy9i1
	 oZDcJu8HfPwWg==
Date: Mon, 12 Oct 2026 21:44:12 +0800
From: Zorro Lang <zlang@kernel.org>
To: Lukas Herbolt <lukas@herbolt.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org
Subject: Re: [PATCH 1/1] lib/random.c fix undefined behavior on signed
 integer overflow.
Message-ID: <asziOW5xK-ALJC2T@zlang-mailbox>
Mail-Followup-To: Lukas Herbolt <lukas@herbolt.com>, 
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org
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

I'll explicitly change it to unsigned int when applying the patch.

Reviewed-by: Zorro Lang <zlang@kernel.org>

> +	if (apply_mask) it ^= MASK;

Ahaha, this .c program is quite legacy. I'm not sure it's worth pulling in
<stdint.h> and <stdbool.h> just to use *bool apply_mask* and *(uint32_t)*.

>  	nit = it - 1;
>  /*	to ensure all-ones pattern omitted    */
>  	leh = leh * mt[nit & 127] + nit;
> -- 
> 2.55.0
> 
