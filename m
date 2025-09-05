Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97CDE30AAAF
	for <linux-xfs@vger.kernel.org>; Fri,  5 Sep 2025 08:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757061009; cv=none; b=Vqkne0FMJkciOfZG98DFywiU2MgxQncchWoeZUPbgMtx/d6mXbQUe+zAMSe5O6LfC9DK88CNe/5ycTQ00+Yqy+kiPRAk2fROwWNX0mF0dp52z5Hy3M1tyajYVwKTcje1D2c/29HEhoPMe4KGkjeI8PZIUDJV9gqiuza/9BXRaTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757061009; c=relaxed/simple;
	bh=ScIGaurB/5+TX/A0fSC1mPU09UW2utZg3k+lNtvzHBU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qBDZGjVsSTu/Kb179f2hxqiDCrpI8qBPDJys2rq92ljkH8mc/Fla2ojbO402a8OOQbF81WPqInWhpL6WLYWYB4sO1j/4IfLlWLiH0FWwHKQB8xZhaPa5vBxFQ7bS/PrC6uSbY9zeYVMu6Mr1hIKvgbfkp1UXNbqcNWwsoHR2Mrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iDT/rwbo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iDT/rwbo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17AA8C4CEF1;
	Fri,  5 Sep 2025 08:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757061009;
	bh=ScIGaurB/5+TX/A0fSC1mPU09UW2utZg3k+lNtvzHBU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iDT/rwbo0m18aImX4vT1OFCXz8R881WXJ+JNg+qSQMbZUIA5WNfzWdrorof9wRJ5G
	 BNxKewl+LxTzHpOwCNK09xBpxlHbUFQICfI6DfCiSw+157nB74unuJgh0ga3Se9LXu
	 lo6VLHayc+x4SCYe0E82McANOsWdvadL79OV/BPpNYzq8nsfaz6zn7rtNAzKmV0Td4
	 DZZ+LE6XeBO7M1rf0va1y6lw06ICy5RSlRUvSk4NZHab8Wb+qrA0FyD3mp2CIJPrGA
	 gYPnTOrUTsvzFloq+LwQyrbmiEpFAVwiU+GDPG9WJ4XMHi/Oto5ue7kitt3FgyBPXQ
	 q0JIzmU8IY4cA==
Date: Fri, 5 Sep 2025 10:30:04 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: disable deprecated features by default in
 Kconfig
Message-ID: <p2p6tmwmrtsgjabci667xb6v2vizojenwlrrs7sripa7ci665c@zr2akabb36sq>
References: <175691147603.1206750.9285060179974032092.stgit@frogsfrogsfrogs>
 <aCgan0cBfIupPPB1tJAmrbPMFoYjFz1-jE56h7Urg7oXLn99y_9X3L45fU6MyNA7qcs2pGf6-Dkiql5P_X2dXA==@protonmail.internalid>
 <175691147647.1206750.9321056429845916872.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <175691147647.1206750.9321056429845916872.stgit@frogsfrogsfrogs>

On Wed, Sep 03, 2025 at 07:59:52AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> We promised to turn off these old features by default in September 2025.
> Do so now.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  Documentation/admin-guide/xfs.rst |    5 ++---
>  fs/xfs/Kconfig                    |    8 ++++----
>  2 files changed, 6 insertions(+), 7 deletions(-)
> 
> 
> diff --git a/Documentation/admin-guide/xfs.rst b/Documentation/admin-guide/xfs.rst
> index a18328a5fb93be..693b09ca62922f 100644
> --- a/Documentation/admin-guide/xfs.rst
> +++ b/Documentation/admin-guide/xfs.rst
> @@ -253,9 +253,8 @@ latest version and try again.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> 
>  The deprecation will take place in two parts.  Support for mounting V4
>  filesystems can now be disabled at kernel build time via Kconfig option.
> -The option will default to yes until September 2025, at which time it
> -will be changed to default to no.  In September 2030, support will be
> -removed from the codebase entirely.
> +These options were changed to default to no in September 2025.  In
> +September 2030, support will be removed from the codebase entirely.
> 
>  Note: Distributors may choose to withdraw V4 format support earlier than
>  the dates listed above.
> diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
> index 065953475cf5eb..ecebd3ebab1342 100644
> --- a/fs/xfs/Kconfig
> +++ b/fs/xfs/Kconfig
> @@ -25,7 +25,7 @@ config XFS_FS
>  config XFS_SUPPORT_V4
>  	bool "Support deprecated V4 (crc=0) format"
>  	depends on XFS_FS
> -	default y
> +	default n
>  	help
>  	  The V4 filesystem format lacks certain features that are supported
>  	  by the V5 format, such as metadata checksumming, strengthened
> @@ -40,7 +40,7 @@ config XFS_SUPPORT_V4
>  	  filesystem is a V4 filesystem.  If no such string is found, please
>  	  upgrade xfsprogs to the latest version and try again.
> 
> -	  This option will become default N in September 2025.  Support for the
> +	  This option became default N in September 2025.  Support for the
>  	  V4 format will be removed entirely in September 2030.  Distributors
>  	  can say N here to withdraw support earlier.
> 
> @@ -50,7 +50,7 @@ config XFS_SUPPORT_V4
>  config XFS_SUPPORT_ASCII_CI
>  	bool "Support deprecated case-insensitive ascii (ascii-ci=1) format"
>  	depends on XFS_FS
> -	default y
> +	default n
>  	help
>  	  The ASCII case insensitivity filesystem feature only works correctly
>  	  on systems that have been coerced into using ISO 8859-1, and it does
> @@ -67,7 +67,7 @@ config XFS_SUPPORT_ASCII_CI
>  	  filesystem is a case-insensitive filesystem.  If no such string is
>  	  found, please upgrade xfsprogs to the latest version and try again.
> 
> -	  This option will become default N in September 2025.  Support for the
> +	  This option became default N in September 2025.  Support for the
>  	  feature will be removed entirely in September 2030.  Distributors
>  	  can say N here to withdraw support earlier.
> 
> 
