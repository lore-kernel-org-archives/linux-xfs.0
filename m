Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63B70342CA7
	for <linux-xfs@vger.kernel.org>; Tue, 17 Mar 2026 22:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773785536; cv=none; b=oCW6XcRk3E6v12cno99jvey4DjQsLS2Jcs6kvzQxuddBrhODIKX3xFIosBkoLlBTSxqtz2U5rq7qhp3mnNGkxnc0MmAj/aGm9j94zCjAA37IluE4Gj5x3wL76K0Gvy64qdqdQWFLSz3ueGokWbU1lCKMQV1juADg/vKHCdS37ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773785536; c=relaxed/simple;
	bh=s7mp39kDAs/KwQTY0lfvXY/9nrHh0RYNv2ihmgIJLKA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t+BC7R+fBNqqdPLOvF7b10ZfDAl/HNmMr3KTtWKYjrvqJsLH9DTzAPVw1JsY9yGV4X7s7Jq0HgBDJV7AcP0PL9q0c3zUpqvqx168cGJhRbD3nz9M6P6HiS/sOrbMnDfSWiJFfkBmHSzIN1Tg628XUhlyAZOKOA6wru5drICeUcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GuGd/gI9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GuGd/gI9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 028EFC2BC9E;
	Tue, 17 Mar 2026 22:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773785536;
	bh=s7mp39kDAs/KwQTY0lfvXY/9nrHh0RYNv2ihmgIJLKA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GuGd/gI9opriqKtf9dqkFDy91g+Gqcy7YPoBD9FfezRKBRJfmxLA1S9oiWscMrLVw
	 Ssvz5ru7z1Ri0a8S83fZZSCt83F4Ez4xZN9ABRdaic2MpInNf7ukXf4Cont5ibm0ZV
	 fIY/w8mopW/gz9usXL9gixPOAEXAAi0ZB6Ps/R2CSE/EfNzhd/4Jc12BaoLrA+TqIC
	 4qQ+LeHYDvaDK11QEoqC+GBnoi/wsgvmiedXJlTscYqza13LZtf6NcmApMDxOVtTZ1
	 UhWSrJ6N4nRMzpIpTvTCVlBmnpKMrzbTn/ZDW6dVkVRNny9XMHKM489Z8IQDGWq3RV
	 jHbSk8QsJapRw==
Date: Tue, 17 Mar 2026 15:12:15 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org
Cc: aalbersh@redhat.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 1/2] fsr: package function should check for negative
 errors
Message-ID: <20260317221215.GL1770774@frogsfrogsfrogs>
References: <20260317160750.186873-1-cem@kernel.org>
 <20260317160750.186873-2-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317160750.186873-2-cem@kernel.org>

On Tue, Mar 17, 2026 at 05:07:39PM +0100, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 
> xfrog_defragrange as most other functions from libfrog return
> a negative error value, while xfs_fsr's packfile(), expects
> a positive error value.
> 
> Whenever xfrog_defragrange fails, the switch case always falls into the
> default clausule, making the error message pointless.
> 
> Update packfile() to switch between negative errors.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
> V2:
> 	Change packfile() to check for negative error values
> 	instead of changing the return sign from xfrog_defragrange().
> 
>  fsr/xfs_fsr.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
> index 8845ff172fcb..aa2a10839314 100644
> --- a/fsr/xfs_fsr.c
> +++ b/fsr/xfs_fsr.c
> @@ -1463,17 +1463,17 @@ packfile(
>  	switch (error) {
>  		case 0:
>  			break;
> -	case ENOTSUP:
> +	case -ENOTSUP:

I would have just made the call site invert the sign:

	error = -xfrog_defragrange(...);

because you wouldn't have to change the case statements, and...

>  		if (vflag || dflag)
>  			fsrprintf(_("%s: file type not supported\n"), fname);
>  		break;
> -	case EFAULT:
> +	case -EFAULT:
>  		/* The file has changed since we started the copy */
>  		if (vflag || dflag)
>  			fsrprintf(_("%s: file modified defrag aborted\n"),
>  					fname);
>  		break;
> -	case EBUSY:
> +	case -EBUSY:
>  		/* Timestamp has changed or mmap'ed file */
>  		if (vflag || dflag)
>  			fsrprintf(_("%s: file busy\n"), fname);

...the default case below is still broken due to the strerror() call:

	default:
		fsrprintf(_("XFS_IOC_SWAPEXT failed: %s: %s\n"),
			  fname, strerror(error));

https://lore.kernel.org/linux-xfs/20260120172039.GO15551@frogsfrogsfrogs/

--D
