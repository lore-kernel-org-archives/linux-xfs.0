Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B392312C7E3
	for <linux-xfs@vger.kernel.org>; Fri, 14 Jun 2024 03:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718337249; cv=none; b=L05DSkMOxwwbgOdniy6k/cf0H67mwuQA7HemR4L8hfqfmYpJ4AS54wEz87XqYKQlvSbPPBPL4YHmIEU/vvy87V74n1vA0RKRcNc9gCDyUtYFi3C+78nbfndu4cqJ+ifOZ4MvESF1SMtpieugN9K5/NzlNpDWkoe6s63kpqjn55k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718337249; c=relaxed/simple;
	bh=XjSLf6rc2KiGX6nHiVJ0x6OtfBWyJvEQ7gEPM+FH6pM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N86QDo5HOh6MW8DcsQKv36cnsyxui3boL2Kqj2UewZTzWExN2ahERFUdhyqjqalVjZ/g0AYJeSesmZXeOyxNXH80adAYQcLON3zx+09EYZZP3VqJD2TGd+D6MGBcSm9QW9DK0KOrcqvthx4xBAj8bIFxyKkBMnSFwwvJOZAw7hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=siIzNu4K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="siIzNu4K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E871C2BD10;
	Fri, 14 Jun 2024 03:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718337249;
	bh=XjSLf6rc2KiGX6nHiVJ0x6OtfBWyJvEQ7gEPM+FH6pM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=siIzNu4K7nZC/BYrqCAjVGCNHXoIswmeUOHftP1ivmsg4P7I17iRueDyvgUbWphf/
	 SnXCtLVODP2K9hIwQ9+1a6IQGMEGF7552aEtyS1Z1UEkiG4OltCgiOTmdjv0XDmhof
	 iYJqM22JiJlsiPpNqD/URY+Bsg2M3P2epSxxs1zi8djl4yN2jYAgA10jUwNAVB4Z8l
	 zjRRCYEVA9qNZ6Ra6kIXpfAwv97hJoU/BRkEaeWZJXbIzw8hk/XQRMRCgKFLFRcXxZ
	 2ohwwpR2nJeShsf27fOU8mtUfP32Dss2h3eMSI1BMZoWEbU1zQD370IM1WJx5fOMAp
	 lgFm6Hw6hj4Yg==
Date: Thu, 13 Jun 2024 20:54:08 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Bill O'Donnell <bodonnel@redhat.com>
Cc: linux-xfs@vger.kernel.org, cmaiolino@redhat.com
Subject: Re: [PATCH v2 3/4] xfs_fsr: correct type in fsrprintf() call
Message-ID: <20240614035408.GD6125@frogsfrogsfrogs>
References: <20240613211933.1169581-1-bodonnel@redhat.com>
 <20240613211933.1169581-4-bodonnel@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240613211933.1169581-4-bodonnel@redhat.com>

On Thu, Jun 13, 2024 at 04:09:17PM -0500, Bill O'Donnell wrote:
> Use %ld instead of %d for howlong variable.
> 
> Coverity-id: 1596598
> 
> Signed-off-by: Bill O'Donnell <bodonnel@redhat.com>
> ---
>  fsr/xfs_fsr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
> index fdd37756..d204e3a4 100644
> --- a/fsr/xfs_fsr.c
> +++ b/fsr/xfs_fsr.c
> @@ -426,7 +426,7 @@ fsrallfs(char *mtab, time_t howlong, char *leftofffile)
>  	fsdesc_t *fsp;
>  	struct stat sb, sb2;
>  
> -	fsrprintf("xfs_fsr -m %s -t %d -f %s ...\n", mtab, howlong, leftofffile);
> +	fsrprintf("xfs_fsr -m %s -t %ld -f %s ...\n", mtab, howlong, leftofffile);

The exact definition of time_t varies by platform and architecture.
I'd paste that is, but in libc it's a twisty mess of indirection that
eventually ends at 'signed long int' or 'long long int'.

Either way, some linter is likely to balk at this, so you might as well
cast howlong to (long long) and use %lld here.

--D

>  
>  	endtime = starttime + howlong;
>  	fs = fsbase;
> -- 
> 2.45.2
> 
> 
