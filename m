Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BE333A9639;
	Fri,  4 Sep 2026 07:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788507544; cv=none; b=j8THlzDsBpPy/kAloeZAv1ZiKJjr7z8aEN06d0NPwYYUTIZtcxFVFmgFi7SwNkl7GANlAYwGdfoAukemPLZo85sk++GJ99HphbZY9Sx6wSmQoRWkvh5GfWXZ7rSp2cafdte+fR/pXyMiYx/C57zMFRbDZoZLj68kgORbaC9QWzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788507544; c=relaxed/simple;
	bh=PCMaI05ENfd/e2TBjwU70rsl8o5CBVI2fKuUMERlqzw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SSp84YSZj8zN+TmAWo0Vtz3PuFxABgkaFJe5LYPgTfEHkoq9l+z056tloPfyHZK8tGBonWNnPUCy45v0XwJObvr9QPFSCwctsNakAS4ASuO/VFT2vD2680ntb+32M05kQMEgVwZ4oXCqhTlqjSkUQ/jmxG3b+yN0u8u/YrgA29E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bcyPW5c8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bcyPW5c8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF8011F00A3D;
	Fri,  4 Sep 2026 07:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788507543;
	bh=n3gRiUkJ5gtjI+FJbIBQ4eTz7KjasJAA+q46DXBX+w8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bcyPW5c8HAa4YBr3xHf8CSno474jxM39D+DiEhK0eGn0IvXb8AAiXO3nOgjQO5yBU
	 L4T3NHQL8W0o2SAIbklWE1jhvTUF95XtKqvieu90KFppj6iOxXRiqjF4upDNc5IQhK
	 Wa6HfSNuRA/eGLb/TTrOwGjZiLtcWpOO6mKGxhJaP3DBHlpHrvcWvhHQBYgWnEqOm+
	 pt9HbVU2jdqYIIDz0IbFfrXhdcCTDuJxZNYQTy00WjqE2CAv7Ar8aqk/5DTwHEjfbJ
	 ysa6ay99+UMG/PxmrD2C+nkYpKIzskQimMvGFC74EAFLeL1CyVfjKdDxAZMBEk40MX
	 TjwIRGEuiiHNQ==
Date: Fri, 4 Sep 2026 09:38:59 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] xfs: bail out on bitmap errors in xrep_agfl_fill
Message-ID: <app1di2UlKdSwH8r@andromeda.toxiclabs.cc>
References: <178850312462.1198660.3332635535003842521.stgit@frogsfrogsfrogs>
 <178850312625.1198660.12540549019476735065.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178850312625.1198660.12540549019476735065.stgit@frogsfrogsfrogs>

On Thu, Sep 03, 2026 at 11:27:19PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM also points out that the xagb_bitmap_set call in xrep_agfl_fill
> can fail, but we don't check the result of xagb_bitmap_walk, so we
> silently drop the error and proceed with inconsistent incore data.
> That shouldn't be allowed.

Looks good.

> 
> While we're at it, fix leaking the used_extents bitmap if the disunion
> operation fails.

Smells this description belongs to the previous patch?

> 
> Cc: <stable@vger.kernel.org> # v6.6
> Fixes: 014ad53732d2ba ("xfs: use per-AG bitmaps to reap unused AG metadata blocks during repair")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> Assisted-by: LOLLM # finding obvious bugs
> ---
>  fs/xfs/scrub/agheader_repair.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
> index 46c95354ca6438..a66b611588c47f 100644
> --- a/fs/xfs/scrub/agheader_repair.c
> +++ b/fs/xfs/scrub/agheader_repair.c
> @@ -699,7 +699,9 @@ xrep_agfl_init_header(
>  	 */
>  	xagb_bitmap_init(&af.used_extents);
>  	af.agfl_bno = xfs_buf_to_agfl_bno(agfl_bp);
> -	xagb_bitmap_walk(agfl_extents, xrep_agfl_fill, &af);
> +	error = xagb_bitmap_walk(agfl_extents, xrep_agfl_fill, &af);
> +	if (error && error != -ECANCELED)
> +		goto err_undo;
>  	error = xagb_bitmap_disunion(agfl_extents, &af.used_extents);
>  	if (error)
>  		goto err_undo;
> 
> 
