Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A68DA1C280
	for <linux-xfs@vger.kernel.org>; Wed,  3 Apr 2024 03:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712116648; cv=none; b=se53EM4RjttIgtp6we70PEpeGnsW8tlWxDFb/ETTBMubEIW9MKSy0nZ052YA++DTX8fEOTbTCbPijmw02pfhDKjTQ8iqeWBkd17h49mWqOSRM+1L/UHuFqKJGbyLh6bDzTLg4VPhGjvFgmc+OAnvSRo1vNKk56uVlBbVuFEFdDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712116648; c=relaxed/simple;
	bh=Jr1baXMrY541pl+WZ6KbZu2FigJKzTtCqt8w4Zs65W0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HQVTc3FwK1BTufDDV3A9Am2J+YXdL/uEe66jBJ7eXF8FNC21JDoGxj/mJUBS5/ZEVr6PcgoPNsJ4C01E4wSsJXel1GR7lMr51IREScs+K37WW3Uh/pNozX/CE0DjG1k30kdTj/IyLbGX0BxqJf8CjA3NdYuBF5dU5AoFwXzkqFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hwun5vic; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hwun5vic"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B5BDC433C7;
	Wed,  3 Apr 2024 03:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712116648;
	bh=Jr1baXMrY541pl+WZ6KbZu2FigJKzTtCqt8w4Zs65W0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hwun5vicnalX40OL2EPlG544/ctsCkyWe3M82zilZ3MlaXuGHgVyXR3kV6pL3wodX
	 n/JOsxsnn4V7WupwFA891Z8Dgav3PqNqt1t5xqwe30KebTaC+7anPNtw3qGGZ0X7Qx
	 PbRfKJHrQwVkDWlIg5KGu9oN47fkZ8MlRUzS+8igL4IAU6pDDhbcNfj2mO241y+PVg
	 mZM0ZtUNsNNBe4q63pnJ5fw/KLWYD3KpslHlc5UzHyjhRKyc8VZjFIcOHx/iYMO41G
	 XXHtXwgJudKCYrWB3wfeOsPpqDX35dlkDLL4NhoQrZRdVOC/vWGlM9IKzHlnsBO7XK
	 JrZDXgVVVky7g==
Date: Tue, 2 Apr 2024 20:57:27 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs: silence sparse warning when checking version
 number
Message-ID: <20240403035727.GO6390@frogsfrogsfrogs>
References: <20240402213541.1199959-1-david@fromorbit.com>
 <20240402213541.1199959-4-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240402213541.1199959-4-david@fromorbit.com>

On Wed, Apr 03, 2024 at 08:28:30AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Scrub checks the superblock version number against the known good
> feature bits that can be set in the version mask. It calculates
> the version mask to compare like so:
> 
> 	vernum_mask = cpu_to_be16(~XFS_SB_VERSION_OKBITS |
>                                   XFS_SB_VERSION_NUMBITS |
>                                   XFS_SB_VERSION_ALIGNBIT |
>                                   XFS_SB_VERSION_DALIGNBIT |
>                                   XFS_SB_VERSION_SHAREDBIT |
>                                   XFS_SB_VERSION_LOGV2BIT |
>                                   XFS_SB_VERSION_SECTORBIT |
>                                   XFS_SB_VERSION_EXTFLGBIT |
>                                   XFS_SB_VERSION_DIRV2BIT);
> 
> This generates a sparse warning:
> 
> fs/xfs/scrub/agheader.c:168:23: warning: cast truncates bits from constant value (ffff3f8f becomes 3f8f)
> 
> This is because '~XFS_SB_VERSION_OKBITS' is considered a 32 bit
> constant, even though it's value is always under 16 bits.
> 
> This is a kinda silly thing to do, because:
> 
> /*
>  * Supported feature bit list is just all bits in the versionnum field because
>  * we've used them all up and understand them all. Except, of course, for the
>  * shared superblock bit, which nobody knows what it does and so is unsupported.
>  */
> #define XFS_SB_VERSION_OKBITS           \
>         ((XFS_SB_VERSION_NUMBITS | XFS_SB_VERSION_ALLFBITS) & \
>                 ~XFS_SB_VERSION_SHAREDBIT)
> 
> #define XFS_SB_VERSION_NUMBITS          0x000f
> #define XFS_SB_VERSION_ALLFBITS         0xfff0
> #define XFS_SB_VERSION_SHAREDBIT        0x0200
> 
> 
> XFS_SB_VERSION_OKBITS has a value of 0xfdff, and so
> ~XFS_SB_VERSION_OKBITS == XFS_SB_VERSION_SHAREDBIT.  The calculated
> mask already sets XFS_SB_VERSION_SHAREDBIT, so starting with
> ~XFS_SB_VERSION_OKBITS is completely redundant....
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

What a tongue twister!
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/scrub/agheader.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
> index e954f07679dd..d6a1a9fc63c9 100644
> --- a/fs/xfs/scrub/agheader.c
> +++ b/fs/xfs/scrub/agheader.c
> @@ -165,8 +165,7 @@ xchk_superblock(
>  		xchk_block_set_corrupt(sc, bp);
>  
>  	/* Check sb_versionnum bits that are set at mkfs time. */
> -	vernum_mask = cpu_to_be16(~XFS_SB_VERSION_OKBITS |
> -				  XFS_SB_VERSION_NUMBITS |
> +	vernum_mask = cpu_to_be16(XFS_SB_VERSION_NUMBITS |
>  				  XFS_SB_VERSION_ALIGNBIT |
>  				  XFS_SB_VERSION_DALIGNBIT |
>  				  XFS_SB_VERSION_SHAREDBIT |
> -- 
> 2.43.0
> 
> 
