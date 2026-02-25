Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 864AE3921F2;
	Wed, 25 Feb 2026 12:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772024257; cv=none; b=Yl7i3k/BTuhAJRJaR8DXWQY/mGgLnWlXT8aejrimqEV5k7nEQHELmJs36KhchtYHaTFfMeyYEuMwNEU7w+A7BnJWw3cyxZ+yPalP7wQXG9GIO817InxcXUbp3ZMxTUloMX6f3/WMc9w6/SwQFI/FHzbe4KQwvfHi9/wM9opzMAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772024257; c=relaxed/simple;
	bh=WEy/q3CypdQpDik13GhYoQJexm3cqGsoLeXusxa5/Xk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WXpC9X3nbi5kNm0KItwPu+HTtMliSiFoR8b0zigGhL8w3rXuWPwOkzaestsDIafovkK5rcNhvCOeX6HtGarNUFNA72/LHwacXKzT8iV8Ik4zDSXWwoF6r+7Qpy1SaVOWzmDGETGgzT9rukyF++ojpLloupcuu8eG598XHLj0RRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SCDdPZ0U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SCDdPZ0U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3B33C116D0;
	Wed, 25 Feb 2026 12:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772024257;
	bh=WEy/q3CypdQpDik13GhYoQJexm3cqGsoLeXusxa5/Xk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SCDdPZ0UMCNy0ydCEhWSvqmSKwrDyrLOH+xMaSJi62PN0uKrEolhV7P+7FFKwI94t
	 4+rs7Zbi+KQFRnq9vFuDEjaVuModaFNE/t6J72lkE1DYfcuZNOWmuVItYP9HCHAiIa
	 AWqeIW/O6uzH/aCocUWIOMKWBfyHB7lAee5lc5ui+ezV7ClnKQHCgWA+2Hzg/8K4cY
	 fRF++Cc1Z6mFrpg3D+oSoLr9V1FRTRNcTV2A3fdC3mx7NrdlqmJIe5zOX7Fuz6YqQS
	 pE+vSvVX+hkjGXrhwVX/7Lw7AXExSlMJ807Ga1aoXqKk28PN3ZxQVeSZs8qyIxT7Zd
	 rMBY5Cl8125YA==
Date: Wed, 25 Feb 2026 13:57:32 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Mark Brown <broonie@kernel.org>
Cc: David Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: Missing signoff in the xfs tree
Message-ID: <aZ7wTqG8WfuBWn0A@nidhogg.toxiclabs.cc>
References: <aZ7axQdS829sxNtl@sirena.org.uk>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZ7axQdS829sxNtl@sirena.org.uk>

On Wed, Feb 25, 2026 at 11:19:33AM +0000, Mark Brown wrote:
> Commits
> 
>   d412c65646d37 ("xfs: don't report half-built inodes to fserror")
>   d33f104ea40e7 ("xfs: don't report metadata inodes to fserror")
>   253b1a2ac9db6 ("xfs: fix potential pointer access race in xfs_healthmon_get")
>   fd992a409aef6 ("xfs: fix xfs_group release bug in xfs_dax_notify_dev_failure")
>   61a02d38303fa ("xfs: fix xfs_group release bug in xfs_verify_report_losses")
>   9ee0cb71de74b ("xfs: fix copy-paste error in previous fix")
> 
> are missing a Signed-off-by from their committers

Oh, thanks... Those belong to a pull request, but as I rebased the
branch, the merge went away. I'll fix it.
