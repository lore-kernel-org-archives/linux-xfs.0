Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD70B1E9B1C
	for <linux-xfs@vger.kernel.org>; Mon, 15 Sep 2025 19:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757963418; cv=none; b=Z3SFpXrN3/UyVKPqfClPuXvxbJ6ufxnBYNGkP0TBG6sE6yOaT6klcmBoFuudY0B6Y0cwAXXyecGJNB42PbnX1doz/SFB0NEzI28JSHgIhUrHmI4zEiwCyQ/uzsYpc6EpwVRHoY4mjBvhyW5GIxH9+Tr8wGsFAWDsyhNb+jHckDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757963418; c=relaxed/simple;
	bh=XLDH3SdlWiHpHg7lSrTWDyPgrGF11tqSQvfN3+5w+JI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=luGo/pamBOj29nvYLPmA3CulaowHmXApeqiiYF37/TYCyPUR+CbH6rpat0/l0GW2gNPNZSjhFTTUdt/N7pnbbYv/1Orfb+WbQIzghtaD3JMVf0Hvb7fk23mLOhFLo++dkcUZaRVFKYCB7Fjb0uLh29JLBbi+p/7CEwxllKo3Huc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aXgCgez+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aXgCgez+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B335C4CEF1;
	Mon, 15 Sep 2025 19:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757963418;
	bh=XLDH3SdlWiHpHg7lSrTWDyPgrGF11tqSQvfN3+5w+JI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aXgCgez+qL94xVZZgvevg0l1Hr5T4xO7zWb0T6ReO/XFv3EJOXWspWEkuCqbyPKYP
	 tEm8F1rhBsKY7fnOKh1Bd72w5Me9SvQjFHGdSVBNDwUMu7j7GYN4uRjMHHUIoLI/wD
	 pdpmTkwsddyjpzy/8ITkVK/ZWJntzb5hL0uFESSG6lmA+JDF485ek+CyRnnZOG9Cml
	 Eqby9sydxc836HTvSBrtktpRy8zwfEKSurWC0k9b3vzUpTEv9KN64X1Rvh4d5TOCVY
	 KnMl4sJWm4c2PqXdl0boeVu2YA/lC5jNn3LaDuQv+CSbnVzXO7S1qgT4VwdNr6I4yq
	 npe3lW4uEbEDw==
Date: Mon, 15 Sep 2025 12:10:17 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] xfs: constify xfs_errortag_random_default
Message-ID: <20250915191017.GY8096@frogsfrogsfrogs>
References: <20250915133104.161037-1-hch@lst.de>
 <20250915133104.161037-7-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250915133104.161037-7-hch@lst.de>

On Mon, Sep 15, 2025 at 06:30:42AM -0700, Christoph Hellwig wrote:
> This table is never modified, so mark it const.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Woot.
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_error.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> index ac895cd2bc0a..39830b252ac8 100644
> --- a/fs/xfs/xfs_error.c
> +++ b/fs/xfs/xfs_error.c
> @@ -19,7 +19,7 @@
>  #define XFS_ERRTAG(_tag, _name, _default) \
>  	[XFS_ERRTAG_##_tag]	= (_default),
>  #include "xfs_errortag.h"
> -static unsigned int xfs_errortag_random_default[] = { XFS_ERRTAGS };
> +static const unsigned int xfs_errortag_random_default[] = { XFS_ERRTAGS };
>  #undef XFS_ERRTAG
>  
>  struct xfs_errortag_attr {
> -- 
> 2.47.2
> 
> 
