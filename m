Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1419127727;
	Wed, 30 Sep 2026 00:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790726520; cv=none; b=F7r7jAQhTGMHxzfTgZq7oL1x7unRNrRqixh8M7nbOKypXbuhF+ww0t6mr3ET+Q/Co9Iy4WKkG4+QuT0e4eUkFKmi81RfL7yLU7NrHJENU34j1bKoFmzg7cFGxaa3yNce+CwYnOLZAIC9hhhXUaXXZXXkGhCoghGrR7/MpntGUmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790726520; c=relaxed/simple;
	bh=qKPg+jvrKWpgp+6ziU5zc9pxIdSVqSGcJxhrx+HJPjA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B+FDgwZa320g/KAKCbb0HM8Dtn00boJpkxnd8yQQW/A2TmETCcmHA6Fd4CJFXZ1jEbgaQ94LgdOx8f+bnUtVwqlzFuj3yVZ8nO5my0E6ynVECFFm0xL6/WOU6z6AGOVtFBYDCSa1BeC5qihE5VYFu+/kyV0dtwIqw6bqSjnxzEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N51sUlzU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N51sUlzU"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9EC8B1F000FF;
	Wed, 30 Sep 2026 00:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790726518;
	bh=1F+eUmoa3dfyE7TZhDB8Z/II1IvauvBHEaaRqaIQINw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=N51sUlzUaC1xcsu/oVm77rTlEoLc7hgqQISofp/pGWBLLdVQoMpEIHUqUldo2gH3a
	 2A5AYliPjnABoufKkbf/oxNUVi3TRA7RydgxgSBUXkJz+q69ewAmtcwV1w2YdzMYqS
	 +efm2l3uoxak2q4goeIb+rfh+B1yYlHiAKdsj0Dk8j5wXYh/VIwSKaxNYEx9+IZqhF
	 DxO5nE2rv8fXvM1dZ90WjSzt/zaLZctsuSWj0yOmiuWqNkb+t1TW9dU2nacZrIe5td
	 R2LoLDENpl52qNVZ6RR0XchL/FjnLCkyeBlPdDC7852x9aQRDdnKcW1Sd3rPuw26H+
	 KHvAizd5i2nFw==
Date: Tue, 29 Sep 2026 17:01:58 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] xfs: validate rc_domain in xchk_rtrefcount_mergeable
Message-ID: <20260930000158.GU2705364@frogsfrogsfrogs>
References: <20260929231305.1368713-1-sandeen@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260929231305.1368713-1-sandeen@redhat.com>

On Tue, Sep 29, 2026 at 06:13:05PM -0500, Eric Sandeen wrote:
> xchk_refcount_mergeable validates that the domains match, but this
> was omitted from the realtime version of the check; fix it.
> 
> Fixes: c27929670de144 ("xfs: scrub the realtime refcount btree")
> Cc: stable@vger.kernel.org # v6.14
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Nice catch!
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/scrub/rtrefcount.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/xfs/scrub/rtrefcount.c b/fs/xfs/scrub/rtrefcount.c
> index 3d916d71a135..460e3f094adf 100644
> --- a/fs/xfs/scrub/rtrefcount.c
> +++ b/fs/xfs/scrub/rtrefcount.c
> @@ -379,6 +379,8 @@ xchk_rtrefcount_mergeable(
>  	if (r1->rc_blockcount == 0)
>  		return false;
>  
> +	if (r1->rc_domain != r2->rc_domain)
> +		return false;
>  	if (r1->rc_startblock + r1->rc_blockcount != r2->rc_startblock)
>  		return false;
>  	if (r1->rc_refcount != r2->rc_refcount)
> -- 
> 2.55.0
> 
> 
