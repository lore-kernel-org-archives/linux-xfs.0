Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B266A286D60
	for <linux-xfs@vger.kernel.org>; Tue, 17 Mar 2026 22:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773785565; cv=none; b=cB5QPbC10SEJlHq59YvlnIjU+Ct7ZYdWUlyl4k0pofbIbV9FEeVaAkNNi52AzPV7WYDeia6xHwTjNY4+zFqfi6B0pJXVpHMY3J+xjGMx7E6+g9Nw9FLIgLkDBG9i2qG+e/anJXoJWPjPuZ9uy4YJBsgSMhAeNyzBMgS1XfgbVvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773785565; c=relaxed/simple;
	bh=WOeh4Huo3ueBlLJ4iJF4lN+oQRolDhHTVEjZrwt0/L0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SA8fHZ6lzBMsXaLEl+kf0bb+QLTWRBTVmox+U1Iu4hVw1Vh+stfZcKLRWJlJCEaRMSESqbEvUgQ5tK4HHRw+Eu71b+fh2bHZIbxSn8vZzQlb5fn6KYkUjagIkD1V04uBCXEHIqEtRAg1v/SPtCHG3/dzxArbM98JCPVfZOD6gtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iKKK4bz5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iKKK4bz5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E654C4CEF7;
	Tue, 17 Mar 2026 22:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773785565;
	bh=WOeh4Huo3ueBlLJ4iJF4lN+oQRolDhHTVEjZrwt0/L0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iKKK4bz55YW5TcpqQe7IZJCQ9aKfVKNhJDYr/Tln9YIRxUyTm3CwerXKk/Pnv9dj7
	 oCMoMFa1mcB+ozcrU3DaFPFWTJGMELsDMW4gsPmQ9un/NR7jmOfcXtUGNm9IQs10Sb
	 8fdKG9Fm9QmT+BLiPph7hEf7RlSLPTPfSFwxns3j2pF993LhzHH+N0IT+lsXRekuY6
	 H2dZMez4DxIOuiS/DLgcu8jWMtBT67KxUmS8HM4Er1c4j47O5nxi9MPst3X9qEik8r
	 qEqu2honSPmaMPoMSE39NSReCpj5esLwTk2KWBHg+tSMGDjGZ1lKv3w3QbdpvsPIPO
	 Q0iYDlWD1Qvgw==
Date: Tue, 17 Mar 2026 15:12:44 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org
Cc: aalbersh@redhat.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 2/2] fsr: always print error messages from
 xfrog_defragrange()
Message-ID: <20260317221244.GM1770774@frogsfrogsfrogs>
References: <20260317160750.186873-1-cem@kernel.org>
 <20260317160750.186873-3-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317160750.186873-3-cem@kernel.org>

On Tue, Mar 17, 2026 at 05:07:40PM +0100, cem@kernel.org wrote:
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

Still
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

https://lore.kernel.org/linux-xfs/20260120172355.GP15551@frogsfrogsfrogs/

--D

> ---
> V2: Update commit description
> 
>  fsr/xfs_fsr.c | 10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
> index aa2a10839314..151f8ba42380 100644
> --- a/fsr/xfs_fsr.c
> +++ b/fsr/xfs_fsr.c
> @@ -1464,19 +1464,15 @@ packfile(
>  		case 0:
>  			break;
>  	case -ENOTSUP:
> -		if (vflag || dflag)
> -			fsrprintf(_("%s: file type not supported\n"), fname);
> +		fsrprintf(_("%s: file type not supported\n"), fname);
>  		break;
>  	case -EFAULT:
>  		/* The file has changed since we started the copy */
> -		if (vflag || dflag)
> -			fsrprintf(_("%s: file modified defrag aborted\n"),
> -					fname);
> +		fsrprintf(_("%s: file modified defrag aborted\n"), fname);
>  		break;
>  	case -EBUSY:
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
