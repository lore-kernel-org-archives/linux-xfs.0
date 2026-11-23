Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795460959;
	b=UT1fTpX5EOnLMNYZSowQZtsjYeYBcyz4Sz6YW8kFQzONPfTmmEg4Cb/IGHZmdx9pbTTU
	 W2F7OyCO0k1yhi/VhWQV51aj/riqGk4cl1pw/EwM7Fd6FglN0MfA8T61Ke2Q9zU4ItC70
	 jOw+fLmAy515i5nlZ9UxmaqLlnuc9f7PiEnGImduwWvFpgFg5A1FHV77EpFvLNsmQCXuL
	 BiQEHeIUmsJBIfnRTIOsskIZXyLto5cnJ3acjiUnbFV1BJf4dGJWnk9ltKtaWoQX2YJAP
	 CXAxYn5YLIc373P6Glpk9Sh4Bn74Ph6uMlunUuDWs2ZVRj2oM7vbOWJ4TiG6AdDy7mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795460959;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 Mail-Followup-To:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=3Bu/vCbyCmVQQLhIexXQF1Q1/I5m6K6flPXyY7ZW/a8=;
	b=nxrI9nI0YrUNiAbdzW8YgQLsgPO8aiIOwLA3wsO7TzagNQ4d912NJRRJEFImtN3O25x5
	 06o4gIQM5NS5rGPNCfCqAvpRAu/58npw+lsPb0ww6tBy4Jn+JRVC+l48DRd3J0b4+i6zb
	 X5zrURO6zOp5eM8Y0vjTs+aeziGj7LTlQLfTH4i/l3xlcwK/Jacgord7FkfFiiwNe/a1U
	 ILXvCIyPoBROYy44pbk1AjMWhD36GpemOnOLEy7w+XKtDfHgp/DCE28GfNXqS6c7voY/g
	 0PUk6yoEu7cTfavNTQQnGGYVhw9iYXAFlmnvGxq7WKRaMWBM8SfsdSftZ0sO8NiV7hA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kQbty4Fc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4617A606A331;
	Mon, 23 Nov 2026 19:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kQbty4Fc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D9151F0093C;
	Mon, 23 Nov 2026 19:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795460958;
	bh=3Bu/vCbyCmVQQLhIexXQF1Q1/I5m6K6flPXyY7ZW/a8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kQbty4FcXmazFpUPBT79tt5WNfGnPLDNtPl8gEc0+l5pfnw3qF4LkrG5s9bsngtUT
	 vvMAhwxdZHvTQcnPdZ0UQLZL9fzua+NJsH/44ososrDEquZabHyb9p3D3LeQEq4PEm
	 KGesIvYB4YLbi/hzT8z2wrgaFeXUsWC5PaMocxdCmvQL4ALvKHKkFC8ipyMzaY/k8a
	 lrmTSFnyweASV8dnfoJ0oCP4p4byTw9HOBAbARP6odl6Xih8UhoJgA6mwkbFr/edB5
	 2IfN2exGEObBn4AAGILz/YH6y1GPVG9utxnLUxd21nzOlzBJYfXl85HaSbugj8QQTB
	 4sB9U7uMIlo/A==
Date: Tue, 24 Nov 2026 03:09:10 +0800
From: Zorro Lang <zlang@kernel.org>
To: Anand Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH 21/21] fstests: _create_loop_device_like_bdev() remove
 unused variable
Message-ID: <awSPT9iTEjkaJpD3@zlang-mailbox>
Mail-Followup-To: Anand Jain <asj@kernel.org>, fstests@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net
References: <cover.1791272793.git.asj@kernel.org>
 <caf98f05a61c028dc1af75c11785cece28d400da.1791272793.git.asj@kernel.org>
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
In-Reply-To: <caf98f05a61c028dc1af75c11785cece28d400da.1791272793.git.asj@kernel.org>

On Tue, Oct 06, 2026 at 04:55:47PM +0800, Anand Jain wrote:
> Remove unused local dev.
> 
> Signed-off-by: Anand Jain <asj@kernel.org>
> ---

Reviewed-by: Zorro Lang <zlang@kernel.org>

>  common/rc | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/common/rc b/common/rc
> index 58e4c234b0f4..5bc4c52bb8d0 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -4815,7 +4815,6 @@ _create_loop_device_like_bdev()
>  {
>  	local file=$1
>  	local bdev=$2
> -	local dev
>  	local blksize
>  
>  	test -b "$bdev" || \
> -- 
> 2.43.0
> 
