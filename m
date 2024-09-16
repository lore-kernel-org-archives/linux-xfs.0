Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80F6B1DFE1
	for <linux-xfs@vger.kernel.org>; Mon, 16 Sep 2024 22:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726526114; cv=none; b=TFeSCbIeAURMuvb6ufbZjAckMgKPfGrYuSCLxNAJKjwjXzGiWK+PoREclOY5zta0xD3DFYno8T8iKpNHK3/4/tg8JAHxYAypmeeoYeqj/SG3EkqY+916HLVavFhzsv5NhWBhjr83S8NQacWXyNDIl+D4gBjgBs2lXRPjv3Cavjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726526114; c=relaxed/simple;
	bh=M+WalH6ARGShlruwkraTy7odJ1ntj4Bh9qJudDb2kbE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Stvk6QG11eg00uD7OwrchxoYKc0Hd6bNBMkb29h0lD+LY11FRaNMCTVjd4ZG7FRa3DTAgY72b6HyOKfUMUuwy1pj4VtIiwMsDm3zhER81e7ZIFxpwy5SF6Fsmv1T7bGnzi48hPG7HBweSq8vLaB7xa03hXkzdS9Jtiqy2CZZ7Go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R2JndRYS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R2JndRYS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 237DFC4CEC4;
	Mon, 16 Sep 2024 22:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726526114;
	bh=M+WalH6ARGShlruwkraTy7odJ1ntj4Bh9qJudDb2kbE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=R2JndRYSyTH6XOJUzqb0LZ4JnOUqCUZNT+gXCmv9IafPwtd3IypLhbH5Qr3XfViBV
	 +V/WbeYLDAqn2nl7NXEUEUxbbf3Gbk25FgiHZwLz5YSzogYahOhgIMh+ZhRIq8NKAe
	 7GVQNrbBfpfmXljdRavJDyWOO8XCaQY5K8YNEvp87o6tLAwFEqjBseKeRLCygR7wO2
	 WFKq3FtHztlePIIZZCQcY6HwNYdNgyo5xYwDtxQiITL3Wo8h+zCYez0oA1NNScEbsR
	 APs8JANCK06z6jbPqdjTBxEr6vKbtrgt+hOzVh1M8GzJo6lQqpwW3K/OrEOkzfBiws
	 CZ18UrTjScBbg==
Date: Mon, 16 Sep 2024 15:35:13 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Bastian Germann <bage@debian.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/6] debian: Add Build-Depends: systemd-dev
Message-ID: <20240916223513.GD182194@frogsfrogsfrogs>
References: <20240912072059.913-1-bage@debian.org>
 <20240912072059.913-5-bage@debian.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240912072059.913-5-bage@debian.org>

On Thu, Sep 12, 2024 at 09:20:51AM +0200, Bastian Germann wrote:
> Signed-off-by: Bastian Germann <bage@debian.org>
> ---
>  debian/control | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/debian/control b/debian/control
> index 369d11a4..c3c6b263 100644
> --- a/debian/control
> +++ b/debian/control
> @@ -3,7 +3,7 @@ Section: admin
>  Priority: optional
>  Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
>  Uploaders: Nathan Scott <nathans@debian.org>, Anibal Monsalve Salazar <anibal@debian.org>, Bastian Germann <bage@debian.org>
> -Build-Depends: libinih-dev (>= 53), uuid-dev, debhelper (>= 12), gettext, libtool, libedit-dev, libblkid-dev (>= 2.17), linux-libc-dev, libdevmapper-dev, libattr1-dev, libicu-dev, pkg-config, liburcu-dev
> +Build-Depends: libinih-dev (>= 53), uuid-dev, debhelper (>= 12), gettext, libtool, libedit-dev, libblkid-dev (>= 2.17), linux-libc-dev, libdevmapper-dev, libattr1-dev, libicu-dev, pkg-config, liburcu-dev, systemd-dev

/me notices that on a bookworm system, systemd-dev only exists in
bookworm-backports as version 254.16.  This is newer than the systemd
252.30 package, which causes a fair amount of mayhem here.

Is there a compelling reason to upgrade systemd on a stable debian
system?

I don't mind patching this back out for my own purposes, but thought I'd
make a note of this publicly.

--D

>  Standards-Version: 4.0.0
>  Homepage: https://xfs.wiki.kernel.org/
>  
> -- 
> 2.45.2
> 
> 
