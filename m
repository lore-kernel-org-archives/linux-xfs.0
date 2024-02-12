Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 585C751011
	for <linux-xfs@vger.kernel.org>; Mon, 12 Feb 2024 23:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707780556; cv=none; b=WqlkLFbqbPWEUFwgefwuo/U41Y8zNj3PuucnGdMbs+pHwe2pQQ62/RXMhKvZINgB/310IYZhIU3+vkw9Or4Z0v781G4+Gw8+LrPVJHcZRoVnmy6XH/pgdHyhLZOF56pEDFv68daNYSAPjwiDbpNbXGb+St3UOWDlhGLArKwuSFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707780556; c=relaxed/simple;
	bh=UOMRJcU4t+9kwK6IrGk2FOkQa8HDdaQEBF40LNXrsjw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HI3Z/PQvbdZP1Ihji7D19b10iGjzVaW9WOOHWGu93ZNNKLS4kQARVZ/OuPkDEQFwoj4ISG4kIpJHMWvfR2ptGqsnaDtUKSrEvorcR5+JNOg2IcmX/2J4mq/rq5Hx9Xr/gx1pCyGLNl9es5r02OxGihrsVucpsC98oHlnjoqpPL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sMS1SBCy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sMS1SBCy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69A06C433F1;
	Mon, 12 Feb 2024 23:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707780555;
	bh=UOMRJcU4t+9kwK6IrGk2FOkQa8HDdaQEBF40LNXrsjw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sMS1SBCyafS25cGBvPUVsHYK1qcMe7B0LRNirwTc4uIUMsVeVp9Nrw7EAiqQoPV02
	 wf+mM8akOTlPzUOeyso2Ae7O8at3cag/8ujEC2TcpP2mkNLsHYUE5Ner/paAqwlgfB
	 zZ6+P/e6Cn1jEDWUedb4gh5ZV5bjSX/X9X7QPCjQn9ih2J4pPgTYHL5vh+KspaKExF
	 nyJ3bRV3Aw4JHrYG65TU1zOH71redAEKdtNpORFD1Ud0nTHUY6XNfe/sjevMNI2FNx
	 ejbfM8jMXifNAmqDR1vVLgIfXTGMIpYEjX3KkprmC0BrIrW9oToDj1ZiG6TPvkma7L
	 EhVtKde6qG2gw==
Date: Mon, 12 Feb 2024 15:29:14 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Bastian Germann <bage@debian.org>
Cc: linux-xfs@vger.kernel.org, Emanuele Rocca <ema@debian.org>
Subject: Re: [PATCH] debian: Increase build verbosity, add terse support
Message-ID: <20240212232914.GT616564@frogsfrogsfrogs>
References: <Zco4xFPmGJQshw7n@ariel>
 <20240212230813.10122-1-bage@debian.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240212230813.10122-1-bage@debian.org>

On Tue, Feb 13, 2024 at 12:07:55AM +0100, Bastian Germann wrote:
> Section 4.9 of the Debian Policy reads:
> 
> "The package build should be as verbose as reasonably possible,
> except where the terse tag is included in DEB_BUILD_OPTIONS".
> 
> Implement such behavior for xfsprogs by passing V=1 to make by default.
> 
> Link: https://www.debian.org/doc/debian-policy/ch-source.html#main-building-script-debian-rules
> Link: https://bugs.debian.org/1063774
> Reported-by: Emanuele Rocca <ema@debian.org>
> Signed-off-by: Bastian Germann <bage@debian.org>

Sounds good to me!
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  debian/rules | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/debian/rules b/debian/rules
> index 57baad62..7e4b83e2 100755
> --- a/debian/rules
> +++ b/debian/rules
> @@ -7,6 +7,10 @@ ifneq (,$(filter parallel=%,$(DEB_BUILD_OPTIONS)))
>      PMAKEFLAGS += -j$(NUMJOBS)
>  endif
>  
> +ifeq (,$(filter terse,$(DEB_BUILD_OPTIONS)))
> +    PMAKEFLAGS += V=1
> +endif
> +
>  package = xfsprogs
>  develop = xfslibs-dev
>  bootpkg = xfsprogs-udeb
> -- 
> 2.43.0
> 
> 
