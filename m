Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04D1130DD3C;
	Thu, 19 Feb 2026 21:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771535228; cv=none; b=X+0aG5YyGE06dDW3kf0yYEf8oN99TKbSdXx72uHcQVGC/dngqxoEUJBL5gQB7e3TUzUrx2phonEYyOSN5Xw5ToeNUaG5E6D8M7TeYt4ahND3oW+2BG9v9XLSMdI07d9uyoUHl8goOmbv6AxfVswh0DHImBtUPZqVHXDF54u7qNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771535228; c=relaxed/simple;
	bh=kbPGLw5tyUAB31exC6lWSQacjTwqSUR7zdOBsZzzGRs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HWkfm+XzVuuvxci6UNePAQMY3ZRXNGyiFkvEaeQLooQ7hDOykJ8EPuGz1ff2Ae15ac2XX3b0k0CC7qkIJYV+uc/50anKJ0+H/zWggCXUajEUEmKcveSgVCbBgczmR16wiFGX77Dr9u+9TjlYLKI2gUS+6gViW5R7jOKhaUXeBx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DxCeWYTD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DxCeWYTD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70970C4CEF7;
	Thu, 19 Feb 2026 21:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771535227;
	bh=kbPGLw5tyUAB31exC6lWSQacjTwqSUR7zdOBsZzzGRs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DxCeWYTDQ/GuyvTSE+sQ0CVBfhg+ZlqLXav5CCRI2wK/YR2A07kNlpM7+Owmpe2b9
	 ImLigW5t6UQLf7vfw9TPAGbu+EMnQLqClKm+od0Cq6qLXc1Z8qjoPLWx40wr+4J3QS
	 k9hObMi/Nf5UsszPBFPI6vRDxy1yANOiTbEOb/92oN7uGN27z9wSu3c9u1pvxkeilT
	 MWo465UhkyRMvXwfSLiinRka22YmHLNyiw96MGmf9gdBX+T3JIJIVs9LfH/4aroT4X
	 9DTZGfrPSevybm4fJ9mZbQHnY35KFp90tytazXVfOA0MWJak4I1l17fdWWYQPHoP9U
	 4KW2PKuoUIg/w==
Date: Thu, 19 Feb 2026 13:07:06 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Ethan Tidmore <ethantidmore06@gmail.com>
Cc: cem@kernel.org, nirjhar.roy.lists@gmail.com, neil@brown.name,
	brauner@kernel.org, jlayton@kernel.org, amir73il@gmail.com,
	jack@suse.cz, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3] xfs: Fix error pointer dereference
Message-ID: <20260219210706.GC6503@frogsfrogsfrogs>
References: <20260219200715.785849-1-ethantidmore06@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260219200715.785849-1-ethantidmore06@gmail.com>

On Thu, Feb 19, 2026 at 02:07:15PM -0600, Ethan Tidmore wrote:
> The function try_lookup_noperm() can return an error pointer and is not
> checked for one.
> 
> Add checks for error pointer in xrep_adoption_check_dcache() and
> xrep_adoption_zap_dcache().
> 
> Detected by Smatch:
> fs/xfs/scrub/orphanage.c:449 xrep_adoption_check_dcache() error:
> 'd_child' dereferencing possible ERR_PTR()
> 
> fs/xfs/scrub/orphanage.c:485 xrep_adoption_zap_dcache() error:
> 'd_child' dereferencing possible ERR_PTR()
> 
> Fixes: 73597e3e42b4 ("xfs: ensure dentry consistency when the orphanage adopts a file")
> Cc: <stable@vger.kernel.org> # v6.16
> Signed-off-by: Ethan Tidmore <ethantidmore06@gmail.com>
> ---
> v3:
> - Add dput(d_orphanage) before returning error code in 
>   xrep_adoption_check_dcache().
> - Revert xrep_adoption_zap_dcache() change back to v1 version.
> - Include function names where error pointer checks were added.
> v2:
> - Propagate the error back in xrep_adoption_check_dcache().
> - Add Cc to stable.
> - Add correct Fixes tag.
> 
>  fs/xfs/scrub/orphanage.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/scrub/orphanage.c b/fs/xfs/scrub/orphanage.c
> index 52a108f6d5f4..682af1bcf131 100644
> --- a/fs/xfs/scrub/orphanage.c
> +++ b/fs/xfs/scrub/orphanage.c
> @@ -442,6 +442,10 @@ xrep_adoption_check_dcache(
>  		return 0;
>  
>  	d_child = try_lookup_noperm(&qname, d_orphanage);
> +	if (IS_ERR(d_child)) {
> +		dput(d_orphanage);
> +		return PTR_ERR(d_child);
> +	}

Nit: blank link after the closing brace.

Other than me nitpicking this looks ok to me so
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

Thanks for fixing this!

--D


>  	if (d_child) {
>  		trace_xrep_adoption_check_child(sc->mp, d_child);
>  
> @@ -479,7 +483,7 @@ xrep_adoption_zap_dcache(
>  		return;
>  
>  	d_child = try_lookup_noperm(&qname, d_orphanage);
> -	while (d_child != NULL) {
> +	while (!IS_ERR_OR_NULL(d_child)) {
>  		trace_xrep_adoption_invalidate_child(sc->mp, d_child);
>  
>  		ASSERT(d_is_negative(d_child));
> -- 
> 2.53.0
> 
