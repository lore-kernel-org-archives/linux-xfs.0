Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABEDB1BD9FB;
	Mon, 18 Nov 2024 22:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731968775; cv=none; b=MFjmBcukAr4gfUZOc22gIBsn0uJatTdsloEBCW7q2w/H4jPlNaIJqYpNCUiG2LbRQGbjFUwL+t6+39lDkZWOkt9rod9W+ePVSugW0xrDrOsrAR/B2Fg15Sx2u+F3tZ2BIokyUMYcDnQFu7eGbyEi4hONdUWx2T9UKt64HZq0CD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731968775; c=relaxed/simple;
	bh=fti2gY+FUqL7fV7UxbvaOU0Gugbiw2I7qy9Uar+PeU0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n5EAwYVuWZy6eULi0+z8q+pFGpZCSQsBEQ9svsfS4i6AMhsPXYm2xMBSbP5XqhWGSueNPDbn0vJb02uJegPX/i38c1xRn1kwzgrDaisdqTq4lLGAx1IVKCfSvy5Y8J74DgG0tYBj50TxLRuad+sNVsy+S/lcd5LZOKJ5y2SMUNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J35WpPzc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J35WpPzc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45F12C4CECC;
	Mon, 18 Nov 2024 22:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731968775;
	bh=fti2gY+FUqL7fV7UxbvaOU0Gugbiw2I7qy9Uar+PeU0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=J35WpPzcZUA7ndbi/nqVikiWxG7SWcpVq2tkqtILMZLrEc5A1AC9jYKt1xeqX1knI
	 kF7xDEGVISVEZI9UHe0/aeKqEvN7kSqtOnezwyQlesymn/pdWD4bE9sPfbpvZnvkJe
	 9/5ts0ICGNqIORkrt1UX63FPliOBR9mpfIQ+XzEF+1bd8i5+ATYepjNv8cCANYDG4M
	 aUpG14pITnUPG0OO0FiVJM3AMM92PRl8y875XllreN7RkTJLXJRktY9Y/ltIASBOrB
	 A7UZOeHv+Xf7enZCRYfOdapQgnr5DSZTgS/BnELUUL5C5WiptcmAXnvAxzskSf30l/
	 ZaMfrReT2XJqA==
Date: Mon, 18 Nov 2024 14:26:14 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@kernel.org>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs/157: do not drop necessary mkfs options
Message-ID: <20241118222614.GK9425@frogsfrogsfrogs>
References: <20241116190800.1870975-1-zlang@kernel.org>
 <20241116190800.1870975-3-zlang@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241116190800.1870975-3-zlang@kernel.org>

On Sun, Nov 17, 2024 at 03:08:00AM +0800, Zorro Lang wrote:
> To give the test option "-L oldlabel" to _scratch_mkfs_sized, xfs/157
> does:
> 
>   MKFS_OPTIONS="-L oldlabel $MKFS_OPTIONS" _scratch_mkfs_sized $fs_size
> 
> but the _scratch_mkfs_sized trys to keep the $fs_size, when mkfs
> fails with incompatible $MKFS_OPTIONS options, likes this:
> 
>   ** mkfs failed with extra mkfs options added to "-L oldlabel -m rmapbt=1" by test 157 **
>   ** attempting to mkfs using only test 157 options: -d size=524288000 -b size=4096 **
> 
> but the "-L oldlabel" is necessary, we shouldn't drop it. To avoid
> that, we give the "-L oldlabel" to _scratch_mkfs_sized through
> function parameters, not through global MKFS_OPTIONS.
> 
> Signed-off-by: Zorro Lang <zlang@kernel.org>
> ---
>  tests/xfs/157 | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/tests/xfs/157 b/tests/xfs/157
> index 9b5badbae..f8f102d78 100755
> --- a/tests/xfs/157
> +++ b/tests/xfs/157
> @@ -66,8 +66,7 @@ scenario() {
>  }
>  
>  check_label() {
> -	MKFS_OPTIONS="-L oldlabel $MKFS_OPTIONS" _scratch_mkfs_sized $fs_size \
> -		>> $seqres.full
> +	_scratch_mkfs_sized "$fs_size" "" "-L oldlabel" >> $seqres.full 2>&1

Don't quote the "-L" and "oldlabel" within the same string unless you
want them passed as a single string to _scratch_mkfs.  Right now that
works because although you have _scratch_mkfs_sized using "$@"
(doublequote-dollarsign-atsign-doublequote) to pass its arguments intact
to _scratch_mkfs, it turns out that _scratch_mkfs just brazely passes $*
(with no quoting) to the actual MKFS_PROG which results in any space in
any single argument being treated as an argument separator and the
string is broken into multiple arguments.

This is why you *can't* do _scratch_mkfs -L "moo cow".

This is also part of why everyone hates bash.

--D

>  	_scratch_xfs_db -c label
>  	_scratch_xfs_admin -L newlabel "$@" >> $seqres.full
>  	_scratch_xfs_db -c label
> -- 
> 2.45.2
> 
> 
