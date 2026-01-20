Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 589BF39524B
	for <linux-xfs@vger.kernel.org>; Tue, 20 Jan 2026 17:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768929640; cv=none; b=sg6tVFkpBuBQYa+sZNmCuF4szJSJvSNjuvDSnWlnUmShFzMuF990bFl+10PN95dyZvwYE7s1nulqMdvBILPikBTqxypr+cx536mJ+5yes3Cn2/89So/KXa80elNutCFBx4sltHZSI9RGjg880WQk6rSL3jV6byRSLXzozdS4Wp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768929640; c=relaxed/simple;
	bh=1y0JRc2WEfCdzapfFWwd6TzDlVjewTabiy7Srr8RVkk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OPdkostm1m1KxEhLpVAKFmdeliczJn8PYS0tBXNdMeagAaS0Oyrt1p8uAkY1Jak798IUJVnuEfoZi2ClfGcoV3Ec5NqyCe6R50gROSwmNrnw2PaE0XLNyiDoaqPKMtv7yvw3X+RjX5sbbl/hqwQsMyvXEIi5JExVzge/Q8iBE7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=egD1d6zX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="egD1d6zX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 270D1C16AAE;
	Tue, 20 Jan 2026 17:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768929640;
	bh=1y0JRc2WEfCdzapfFWwd6TzDlVjewTabiy7Srr8RVkk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=egD1d6zXOE+PP/65ACQhFvSyetHVOjA17CYnELl8XwH5rurhWR+IZgk70SJEsDIqK
	 QqBcg9bmS3lzL23op0WY98u9OfIael0fkzgRN4t7+aqnZUy7CQ896mi4/l/L9CQhsd
	 1+w7GzOCe/cVdp04LATTiJWCB3p3ugqrecb/ysvJRCyRbpl8vlTz4wUfmDNnKY4I5A
	 xoEsmKSTim3fx6foOlRAESO18/DErhXA/UWU/gbrVk0GS0hgd2n0cNwpI1LIAOzSYZ
	 htHU3KxAtKhXpLOa/zxWeBFv2tuSCdi4Kq9FGjJ8M6eyzGUGrqn74WuV2xMsjAtDTn
	 4LiLpOd5aqU/w==
Date: Tue, 20 Jan 2026 09:20:39 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org
Cc: aalbersh@redhat.com, linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] libfrog: make xfrog_defragrange return a
 positive valued
Message-ID: <20260120172039.GO15551@frogsfrogsfrogs>
References: <20260119142724.284933-1-cem@kernel.org>
 <20260119142724.284933-2-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260119142724.284933-2-cem@kernel.org>

On Mon, Jan 19, 2026 at 03:26:50PM +0100, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 
> Currently, the only user for xfrog_defragrange is xfs_fsr's packfile(),
> which expects error to be a positive value.
> 
> Whenever xfrog_defragrange fails, the switch case always falls into the
> default clausule, making the error message pointless.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  libfrog/file_exchange.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/libfrog/file_exchange.c b/libfrog/file_exchange.c
> index e6c3f486b0ff..31bbc6da60c3 100644
> --- a/libfrog/file_exchange.c
> +++ b/libfrog/file_exchange.c
> @@ -232,7 +232,7 @@ xfrog_defragrange(
>  	if (ret) {
>  		if (errno == EOPNOTSUPP || errno != ENOTTY)
>  			goto legacy_fallback;
> -		return -errno;
> +		return errno;

Hrmm.  If you're going to change the polarity of the error numbers (e.g.
negative to positive) then please update the comments.

That said, I'd prefer to keep the errno polarity the same at least
within a .c file ... even though libfrog is a mess of different error
number return strategies.  What if the callsite changed to:

	/* Swap the extents */
	error = -xfrog_defragrange(...);

and

	/* Snapshot file_fd before we start copying data... */
	error = -xfrog_defragrange_prep(...);

(and I guess io/exchrange.c also needs a fix)

	/* Snapshot the original file metadata in anticipation... */
	ret = -xfrog_commitrange_prep(...);

Hrm?

--D

>  	}
>  
>  	return 0;
> @@ -240,7 +240,7 @@ xfrog_defragrange(
>  legacy_fallback:
>  	ret = xfrog_ioc_swapext(file2_fd, xdf);
>  	if (ret)
> -		return -errno;
> +		return errno;
>  
>  	return 0;
>  }
> -- 
> 2.52.0
> 
> 
