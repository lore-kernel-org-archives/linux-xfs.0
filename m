Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63F873DEADF
	for <linux-xfs@vger.kernel.org>; Tue, 31 Mar 2026 16:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774973378; cv=none; b=Rrr+k69dK6dfbbWzZI8R3QZev0isIDZRHHUTUIbGO6/dT9tQuMjbw3ecb8d0j43JizQu/ZQJZ5vhXg9o9nk7aLtP+ik7lpkEOQ2yVElisPS5xwzLHQKJkGMZxfOjdYMrNeflarwOabuhL77zITWQoLgBZs9xXfeR0+4e8OPt778=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774973378; c=relaxed/simple;
	bh=Zjsqwe39EfOy/PvONCnmgOpaEVjmAtJlPk9Grswo4AI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OU7Gzme2kLDAaJglN7GHoqRRXp8Eojs/URbc/jacHwPG8WCmICqMAciWg7YuHfp8KIWw0bz3OP9oNfOb9tqDmxZwtCCYtl5H6cA2CxZM/hrqo63l6S0Lnq2f/O+NLbAEx/0/w3oTI9XvgOD3Ccye5u+L2kF9OfE90MYlPhFAQU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PFBAvX63; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PFBAvX63"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08BA2C19423;
	Tue, 31 Mar 2026 16:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774973378;
	bh=Zjsqwe39EfOy/PvONCnmgOpaEVjmAtJlPk9Grswo4AI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PFBAvX63lb5XqginKa/uPOvgGmWgYELhAg9vkSdk1BLM7k8usFmJp8y0RqjqtdWjf
	 NmGVVfbX/81hAVHxpEkw1mvngTd5L63sR4Yfa7bDvSnCcZem/UT07SZlRZSQGYXHg+
	 ttomW2BRSw2z4wNfifZ7p9Uch5OlmDotExzWHecvWAQvTONC+blQccmZ+y9cA4YGR7
	 Vh00+nWPPg3ghK/qfPsnw/jPSxce9Cp4WZL2g68IXr7kSz8tuWd4o/fT97Ou1wsHyQ
	 jHAl+EoEradI9CPwtPY7yhSXyZAuPtwkY7N9CiAAh5wZOZZAQa76FYIAiJpdTRGN8y
	 OuWBgdeJJWgjw==
Date: Tue, 31 Mar 2026 09:09:37 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org
Cc: aalbersh@redhat.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 2/2] fsr: always print error messages from
 xfrog_defragrange()
Message-ID: <20260331160937.GE6223@frogsfrogsfrogs>
References: <20260331122639.100956-1-cem@kernel.org>
 <20260331122639.100956-3-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260331122639.100956-3-cem@kernel.org>

On Tue, Mar 31, 2026 at 02:26:31PM +0200, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 
> Error messages from xfrog_defragrange() are only printed when
> verbose/debug flags are used.
> 
> We had reports from users complaining it's hard to find out the error
> messages lost in the middle of dozens of other informational messages.
> 
> Change packfile() behavior to print errors independently of verbose or
> debug flags.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> 
> ---
> V3: Rebase on top of patch 1 changes
> V2: Update commit description
> 
>  fsr/xfs_fsr.c | 9 ++-------
>  1 file changed, 2 insertions(+), 7 deletions(-)
> 
> diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
> index 390f7c5276df..24617f55e329 100644
> --- a/fsr/xfs_fsr.c
> +++ b/fsr/xfs_fsr.c
> @@ -1464,19 +1464,14 @@ packfile(
>  		case 0:
>  			break;
>  	case ENOTSUP:
> -		if (vflag || dflag)
> -			fsrprintf(_("%s: file type not supported\n"), fname);

Err.. did you mean to delete the fsrprintf call here as well?

--D

>  		break;
>  	case EFAULT:
>  		/* The file has changed since we started the copy */
> -		if (vflag || dflag)
> -			fsrprintf(_("%s: file modified defrag aborted\n"),
> -					fname);
> +		fsrprintf(_("%s: file modified defrag aborted\n"), fname);
>  		break;
>  	case EBUSY:
>  		/* Timestamp has changed or mmap'ed file */
> -		if (vflag || dflag)
> -			fsrprintf(_("%s: file busy\n"), fname);
> +		fsrprintf(_("%s: file busy\n"), fname);
>  		break;
>  	default:
>  		fsrprintf(_("XFS_IOC_SWAPEXT failed: %s: %s\n"),
> -- 
> 2.53.0
> 
> 
