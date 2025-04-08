Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 515FF17332C;
	Tue,  8 Apr 2025 14:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744121847; cv=none; b=sM90RAq5NpfcZQ+U3jEfCGDrpoyEWoxXyTAEiA6EYcQcWXTZfAzJlHLbuc7kLxBx/wpzye5KbLZD8qUMXcIqbmUNxIMEVb7TVmIGoftZ+SW58oRrV/y5HTv8bzJ9+BwJVzd4ihuKXdNFDor8K3xBFuHGMKi9PkwWTJbk6M9B8/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744121847; c=relaxed/simple;
	bh=nZU5G0169c30cQjqGSlk97pVXNptAn7aB00fBv/8IEk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SPFuZMudNL/W0E5fIMil9cV7L6fnRDvHolq7lsAS0Qsl4zQvd9kZ7P8K/h/ukE4OKZ7um0z3LFRQ3PKXGW49S5aL+EMJ6BSLDJDQ28VpQOUmb9bcQ1ZeBgPxzLykLRgJzLaen1FACCoB2AWY/52InIzbS7zQxAWzJPPAS0OcUPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U0XdOq9s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U0XdOq9s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA7C5C4CEE5;
	Tue,  8 Apr 2025 14:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744121846;
	bh=nZU5G0169c30cQjqGSlk97pVXNptAn7aB00fBv/8IEk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=U0XdOq9sd8TMC44csx9zgGYBD3m4HKNFpYMGZFaAWE95Ljr2tEWSUWOJ9qQBNpIfh
	 LqW4AkUYBCHquXqF33VLUXcGUxh88L8/uHyc01vQsvQvDnGyIzED0q90YXrSGjLN0o
	 LhWTP84Dp1GIr3Qr5N8Rcr4HtAteiqcEjrdDhrPdwG+NwQ22VKlFN1bnMavs90x7Tt
	 v5PdUKXISf0fcMr1YZA5RDYyBEWQ/kitSVo81O2Xp719iitK7NeR5wf0XSKtoWWS4s
	 NWNncGgApfCXdvA0ZEsm7w345Z4fY3JldIUeacMChyhFYGIpalrKmis9Yx0FaAo1Eq
	 aXmpnoQAvJwqA==
Date: Tue, 8 Apr 2025 07:17:26 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: zlang@kernel.org, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH, resend] xfs: remove the post-EOF prealloc tests from the
 auto and quick groups
Message-ID: <20250408141726.GC6274@frogsfrogsfrogs>
References: <20250408065228.3212479-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250408065228.3212479-1-hch@lst.de>

On Tue, Apr 08, 2025 at 08:51:55AM +0200, Christoph Hellwig wrote:
> These fail for various non-default configs like DAX, alwayscow and
> small block sizes.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
> 
> Resend.  Last time Darrick said he's working on an autodetection, but that
> didn't get finished.

In the end it was much too tricky to autodetect because there are
various paths that never invoke prealloc at all, or on some configs
(e.g.  tiny fs) it can disappear by the time the critical checks in the
test run and *poof*.  For now this is probably fine, though for anyone
else running ./check -g all, the field is open for anyone to try to sort
things out.

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> 
>  tests/xfs/629 | 2 +-
>  tests/xfs/630 | 2 +-
>  tests/xfs/631 | 2 +-
>  tests/xfs/632 | 2 +-
>  4 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/tests/xfs/629 b/tests/xfs/629
> index a2f345571ca3..bb59e421e43a 100755
> --- a/tests/xfs/629
> +++ b/tests/xfs/629
> @@ -8,7 +8,7 @@
>  #
>  
>  . ./common/preamble
> -_begin_fstest auto quick prealloc rw
> +_begin_fstest prealloc rw
>  
>  . ./common/filter
>  
> diff --git a/tests/xfs/630 b/tests/xfs/630
> index 79dcb44bc066..0a3fce10c68f 100755
> --- a/tests/xfs/630
> +++ b/tests/xfs/630
> @@ -8,7 +8,7 @@
>  #
>  
>  . ./common/preamble
> -_begin_fstest auto quick prealloc rw
> +_begin_fstest prealloc rw
>  
>  . ./common/filter
>  
> diff --git a/tests/xfs/631 b/tests/xfs/631
> index 319995f816fe..ece491722557 100755
> --- a/tests/xfs/631
> +++ b/tests/xfs/631
> @@ -13,7 +13,7 @@
>  # from the extent size hint.
>  
>  . ./common/preamble
> -_begin_fstest auto quick prealloc rw unreliable_in_parallel
> +_begin_fstest prealloc rw unreliable_in_parallel
>  
>  . ./common/filter
>  
> diff --git a/tests/xfs/632 b/tests/xfs/632
> index 61041d45a706..3b1c61fdc129 100755
> --- a/tests/xfs/632
> +++ b/tests/xfs/632
> @@ -9,7 +9,7 @@
>  #
>  
>  . ./common/preamble
> -_begin_fstest auto prealloc rw
> +_begin_fstest prealloc rw
>  
>  . ./common/filter
>  
> -- 
> 2.47.2
> 
> 
