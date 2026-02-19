Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D964C1862A;
	Thu, 19 Feb 2026 05:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771480469; cv=none; b=rIohUuByDqKLh7hrNDRBURGsSxTcunonT5AIJ/WalUFpeIU53EKN2zaeDrRQ2aeJU58mQ+ySQc6ptdQQd7Vz5VKPfkMS2zFT8mhs9GU6/Vf/n0u0/ZCRMdprJPblShkENmxI5nJmYgKkhWXz7N7xRjq2ESemsNidL4V+T1Rk894=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771480469; c=relaxed/simple;
	bh=BMIjC6jT4M62jGG9gNl8/VROU39Iz/nogY1g63NbRmQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DQ5Ur0Hh6ruhVZpkIcubiwmLn3RiUvyESBr2a2TGZZEsJ6pgYJRd3/rVXPl1z7nLmL8RjXYFupSF3bNtnvo61qq1eSPo1z7ja2O17gh6Jr7hQsF+L2ynGFQ+wYPSelBWG4n76+a/Cd2y0QW0CK83sD7/FpzVn2la58AIsdFwyY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cpozRfWJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cpozRfWJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BF7AC4CEF7;
	Thu, 19 Feb 2026 05:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771480469;
	bh=BMIjC6jT4M62jGG9gNl8/VROU39Iz/nogY1g63NbRmQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cpozRfWJeTXgaAG09JwH3OLx4vZJT99vkw11hXPXdzvRN0KoHE44BMcc7xBFWqvTF
	 4yUdccbKGAPeshOg83u9DJmJKUS3MG/U48oLSANKfcit0jdJaYR6p7oqqGRWQggD22
	 NChHYpC9TZ749YAF+7ojiZIWITFdr10l0g0MCw5Cy9EocCwyWZVKt5f1t0km1vpQNa
	 MemQxBKtis1w5YtKWcyib2qsF/tkX+7ba6K7WzqAQxjlu2rVfzzfLHhmhgR1mr908r
	 v3fbUGOtEbACgq+OgTujcSkb3u26VXtuHKBQV4XolzVXoN21tT1plrPMd69XazwNyA
	 fkpJun1DlZ0kA==
Date: Wed, 18 Feb 2026 21:54:28 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Ethan Tidmore <ethantidmore06@gmail.com>
Cc: Carlos Maiolino <cem@kernel.org>, NeilBrown <neil@brown.name>,
	Christian Brauner <brauner@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] xfs: Fix error pointer dereference
Message-ID: <20260219055428.GB6503@frogsfrogsfrogs>
References: <20260219051841.60999-1-ethantidmore06@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260219051841.60999-1-ethantidmore06@gmail.com>

On Wed, Feb 18, 2026 at 11:18:41PM -0600, Ethan Tidmore wrote:
> The function try_lookup_noperm() can return an error pointer and is not
> checked for one. Add checks for error pointer and propagate it.
> 
> Fixes: 73597e3e42b4 ("xfs: ensure dentry consistency when the orphanage adopts a file")
> Cc: <stable@vger.kernel.org> # v6.16
> Signed-off-by: Ethan Tidmore <ethantidmore06@gmail.com>
> ---
>  fs/xfs/scrub/orphanage.c | 17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/scrub/orphanage.c b/fs/xfs/scrub/orphanage.c
> index 52a108f6d5f4..3269a0646e19 100644
> --- a/fs/xfs/scrub/orphanage.c
> +++ b/fs/xfs/scrub/orphanage.c
> @@ -442,6 +442,9 @@ xrep_adoption_check_dcache(
>  		return 0;
>  
>  	d_child = try_lookup_noperm(&qname, d_orphanage);
> +	if (IS_ERR(d_child))
> +		return PTR_ERR(d_child);

I think you still need to dput(d_orphanage) below if you're returning an
error code.

>  	if (d_child) {
>  		trace_xrep_adoption_check_child(sc->mp, d_child);
>  
> @@ -464,7 +467,7 @@ xrep_adoption_check_dcache(
>   * There should not be any positive entries for the name, since we've
>   * maintained our lock on the orphanage directory.
>   */
> -static void
> +static int
>  xrep_adoption_zap_dcache(
>  	struct xrep_adoption	*adopt)
>  {
> @@ -476,9 +479,12 @@ xrep_adoption_zap_dcache(
>  	/* Invalidate all dentries for the adoption name */
>  	d_orphanage = d_find_alias(VFS_I(sc->orphanage));
>  	if (!d_orphanage)
> -		return;
> +		return 0;
>  
>  	d_child = try_lookup_noperm(&qname, d_orphanage);
> +	if (IS_ERR(d_child))
> +		return PTR_ERR(d_child);

Don't we still want to perform the d_find_alias loop below?

The changes you made to xrep_adoption_zap_dcache in the first version
seemed reasonable to me since it only tried to invalidate a bunch of
dcache entries.  Also I think if this call to try_lookup_noperm()
returns an ERR_PTR, then the call in _check_dcache would have gotten the
same ERR_PTR return value and ended the entire repair attempt.

--D

> +
>  	while (d_child != NULL) {
>  		trace_xrep_adoption_invalidate_child(sc->mp, d_child);
>  
> @@ -497,6 +503,8 @@ xrep_adoption_zap_dcache(
>  		d_invalidate(d_child);
>  		dput(d_child);
>  	}
> +
> +	return 0;
>  }
>  
>  /*
> @@ -592,7 +600,10 @@ xrep_adoption_move(
>  	xfs_dir_update_hook(sc->orphanage, sc->ip, 1, adopt->xname);
>  
>  	/* Remove negative dentries from the lost+found's dcache */
> -	xrep_adoption_zap_dcache(adopt);
> +	error = xrep_adoption_zap_dcache(adopt);
> +	if (error)
> +		return error;
> +
>  	return 0;
>  }
>  
> -- 
> 2.53.0
> 
