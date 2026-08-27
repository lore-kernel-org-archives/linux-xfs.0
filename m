Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97636146A66
	for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2026 05:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787806881; cv=none; b=XHwtE2VmLZo/jIpyrmAvHIcqMYGJcccY13tVpnUdxMc7lhUPiswZRuUP/C44b/PMFyaGA+uvRILA3h6qgBHuwj/X+yQII6Yo+INMVfNZFfr9+KiFB3OfXvEpQ0I8B/WTIgvLmLlX6SaS8NSIDUl/r7DTL4KbWVRJWwny7e2awsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787806881; c=relaxed/simple;
	bh=SnZ7DhlZ1ilOY71Eqc4nncQrSJHzcu4PbOhE8zuzk9o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uieY6xdmmpaxWteXkMAMorXN+0eJ6lJiLbHcVBRh9A3uULTMy5pfYpt2vHtIB0HHOoYFxoUVZ3Lk1CxBsvoZZCLR0FsOzi0VOWrKn0MLVs4ing7L53H5cTDZeeofTBgx3CnQ1aMEPr76S1SgxaEm9Wfo/p/T3e7sd7XZ4RrzVAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q2zfi5Gj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q2zfi5Gj"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 6CEC91F000E9;
	Thu, 27 Aug 2026 05:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787806880;
	bh=hB6c4o5jTEn5WNmVUQtNyR6S5cR75EpQpx2xnO/M3vk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Q2zfi5GjoYRb2FobWz74c++T6FMZTsVj0CyL5rrhAkV7jmoxCeZtaqoQMg96h+snj
	 xBney/LwiofAhQFrerqLlEgzdEph7vNdccf6ohqBErl8mlMiylWrGhU7kxvgryTC+T
	 OCOkExibDxmdIiokUWomNrkzRDgqsd+isTOo+rR1z2X/6KJSGTRz9oo+dnyFL42Wce
	 zm3qQRlkWqR9cPLDCYnYSc5gtFLapuCQU65talUDG0DExomOIUoT/Y5cZLo3exO2Dv
	 otnkFrEKwiMyDrvcTNHl8zcUr+dhERwwyAL+0ouUPi2256N7CS3DT5Zs8xGd067BYe
	 lGh1Tn7RzID+Q==
Date: Wed, 26 Aug 2026 22:01:19 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2] mkfs: Emit a clearer message if too-small log is due
 to AG geometry
Message-ID: <20260827050119.GA6072@frogsfrogsfrogs>
References: <20260827034228.938740-1-sandeen@redhat.com>
 <a1864929-f3df-4c0a-ae47-019cda875c99@sandeen.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a1864929-f3df-4c0a-ae47-019cda875c99@sandeen.net>

On Wed, Aug 26, 2026 at 10:49:38PM -0500, Eric Sandeen wrote:
> There is a constraint in mkfs.xfs that logs must not be smaller than
> 64MiB. We can arrive at a too-small log without specifying its size,
> though, if we specify so many AGs (or such small AGs) that a single
> AG cannot hold the minimum-sized log. This leads to confusing output:
> 
> $ truncate --size=500m testfile
> $ mkfs.xfs -dagcount=10 testfile
> Log size must be at least 64MiB.
> Usage: mkfs.xfs
> ...
> 
> because the user did not specify the log size at all! If this error
> occurs due to the AG geometry specification, make that clear with a
> better error message.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>  mkfs/xfs_mkfs.c | 19 ++++++++++++++++++-
>  1 file changed, 18 insertions(+), 1 deletion(-)
> 
> V2: Ugh as soon as I sent this I realized I forgot to restrict this to internal
> logs. An external log may be too small all on its own, unrelated to AG size.
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index a4864c37..4f11c9de 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -3456,8 +3456,25 @@ validate_supported(
>  	 */
>  	if (mp->m_sb.sb_logblocks <
>  			XFS_MIN_REALISTIC_LOG_BLOCKS(mp->m_sb.sb_blocklog)) {
> -		fprintf(stderr,
> +		/*
> +		 * An internal log must fit within a single allocation group.
> +		 * If the user specified the AG geometry but didn't ask for a
> +		 * specific log size, the undersized log is due to allocation
> +		 * groups that are too small, not a log size the user chose.
> +		 */
> +		if (cli->loginternal &&
> +		    !cli_opt_set(&lopts, L_SIZE) &&
> +		    (cli_opt_set(&dopts, D_AGCOUNT) ||
> +		     cli_opt_set(&dopts, D_AGSIZE))) {
> +			fprintf(stderr,
> + _("Allocation group size (%lld MiB) is too small to hold the minimum 64MiB log.\n"
> +   "Specify fewer or larger allocation groups, or use a larger data device.\n"),

I like this!  With a couple of comments:

Can the warning message be more targeted to the option?  e.g.

	if (loginternal && !set(L_SIZE)) {
		if (set(D_AGCOUNT))
			fprintf("Specify fewer AGs or a larger data device...");
		else
			fprintf("Specify larger allocation groups...");
	}

Also, what do you think about not hardcoding 64MiB?

printf("Log size must be at least %uMiB\n",
		XFS_MIN_REALISTIC_LOG_BLOCKS(20));

(separate change obviously)

--D

> +				(long long)XFS_FSB_TO_B(mp,
> +					mp->m_sb.sb_agblocks) >> 20);
> +		} else {
> +			fprintf(stderr,
>   _("Log size must be at least 64MiB.\n"));
> +		}
>  		usage();
>  	}
>  
> -- 
> 2.55.0
> 
> 
