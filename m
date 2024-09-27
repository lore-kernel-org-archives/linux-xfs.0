Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF44B13AD1C
	for <linux-xfs@vger.kernel.org>; Fri, 27 Sep 2024 15:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727450436; cv=none; b=l8rRy+AKgnWXpyBLBSV9Fj2okU65wjz+Y9VRi02VL9H0uKVnY1qbGIx2M/EHjDjZOQmbfrjfPHzTjrkYqfiEfOSE7WcBoKgXpxVT1wJsbYoKNTuzEt/aBZIO+r8M87kdLpWT/99Jju0bIj5XqlY3vOcELHxKZs7bCa/oilzmhgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727450436; c=relaxed/simple;
	bh=RKDch64SXXu2k8D+St6jiXvN/5mr/5vDbPYIK/o+1R0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OENF7jt+3Y1ClWyqqsvdvn/Qh4q6b/8g8IPE05/ZHQ4qfs1ltNBLlsS02jeoBor5f9cGqP0X5LfKRwW1g+Sf2nRLEEQ64fFx/7DnqO3y2JSLGW1mmQW4nyiyoM52E/BO+vyRoLQdCr7HKXu8KqMoMomGeG7Qs3Fs0osU2IfcbXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GaKEp2EF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GaKEp2EF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39C95C4CEC4;
	Fri, 27 Sep 2024 15:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727450436;
	bh=RKDch64SXXu2k8D+St6jiXvN/5mr/5vDbPYIK/o+1R0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GaKEp2EFeZL/gzIJsKGDExkS5tJqu+F2thQtFY/2HiCW8tbsxKLWXwFv7senTHWi2
	 rWLyybC2v+LV2CcZ83l33VCK9/2wnLHXNoUSJbC0K9gQM4zhp3iIT1Mdfh+YXr3a4T
	 92QRGvVPzpXM0uBkPRtfwMc3SJTpI9EDeugI6UH01IA3RCkpDr4jgSTxTt08r7Aki5
	 p/HOmCpuy8LpJ1yPm/SdXpz7hOtm5D7QHd3PDQSkhlT7AtXWq5o8F19Br81NayLzvb
	 5GDn9Lx3M5icnmeewB8fTTkvAZguBXIgTKL+oxNn9WZIlmHltZeGv6gSGrflWr3YWK
	 kYtUnfwGx2ovg==
Date: Fri, 27 Sep 2024 08:20:35 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: linux-xfs@vger.kernel.org, aalbersh@kernel.org
Subject: Re: [PATCH 2/2] xfsprogs: update gitignore
Message-ID: <20240927152035.GL21853@frogsfrogsfrogs>
References: <20240927134142.200642-2-aalbersh@redhat.com>
 <20240927134142.200642-4-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240927134142.200642-4-aalbersh@redhat.com>

On Fri, Sep 27, 2024 at 03:41:43PM +0200, Andrey Albershteyn wrote:
> Building xfsprogs seems to produce many build artifacts which are
> not tracked by git. Ignore them.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> ---
>  .gitignore | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/.gitignore b/.gitignore
> index fd131b6fde52..26a7339add42 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -33,6 +33,7 @@
>  /config.status
>  /config.sub
>  /configure
> +/configure~
>  
>  # libtool
>  /libtool
> @@ -73,9 +74,20 @@ cscope.*
>  /scrub/xfs_scrub_all
>  /scrub/xfs_scrub_all.cron
>  /scrub/xfs_scrub_all.service
> +/scrub/xfs_scrub_all_fail.service
> +/scrub/xfs_scrub_fail
>  /scrub/xfs_scrub_fail@.service
> +/scrub/xfs_scrub_media@.service
> +/scrub/xfs_scrub_media_fail@.service

/me wonders if *.service/*.cron should be a wildcard to match
scrub/Makefile's LDIRT definition.

>  # generated crc files
> +/libxfs/crc32selftest
> +/libxfs/crc32table.h
> +/libxfs/gen_crc32table

This all moved to libfrog in 2018, how is it still building in libxfs?

>  /libfrog/crc32selftest
>  /libfrog/crc32table.h
>  /libfrog/gen_crc32table
> +
> +# docs
> +/man/man8/mkfs.xfs.8
> +/man/man8/xfs_scrub_all.8

Looks good.

--D

> -- 
> 2.44.1
> 
> 
