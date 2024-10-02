Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8BA084A36
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 22:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727909696; cv=none; b=NAN0vgpQhXDsF0VWLz2464N2cQi2JMeovF83jsZ6b47Z28LGsTPtFp5vwKjENs2+7mHAE3Hi4DeDeo0bRlNmz7UhfLlKZGvfb6sfK26bbn0O6JkbCCrGlANyswGaqVphYU2I4knQCY+vfoy5kcp5HxRBsGl4oKlXHOGc8m3DRhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727909696; c=relaxed/simple;
	bh=4IchS0sfWs4/INrPby2Ujn6yW54gjfoy6AuD+H+voeE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xz0FQwATK2RpqKhUtmXgrTxRz8s7Plyd66OKtdLD38CAMzIUEvJYwbd5Pk9vg7t0gERHRI4+WKjYh3UtyVmKoWrNM9cvfNstV+2no/Xr5SN0V9mfW/X96/KtuWLDQbcqnDX2VKYXzxAs01QdpIaHZ3qjZ7vOK6AJqt6sjBc3pxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GJjPX2cV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GJjPX2cV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7707AC4CEC2;
	Wed,  2 Oct 2024 22:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727909695;
	bh=4IchS0sfWs4/INrPby2Ujn6yW54gjfoy6AuD+H+voeE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GJjPX2cVrk9Fox6V1NmI3G7zSaZL/YfbqwcUXpD5UAsgVPVpLHCR5TM8UTDMz9r0E
	 hlMaUU9nRdCNBHmZkvyGJd8oxh2A7JfZNidffG6z62n2UdbIAuw77x1ElCLzcCngDL
	 YxRxhL69gq0gpOXp5axqMjedHsp6dtS11trEBzIGsWcbr7E9xdUm6dBUU6kcJKt/YE
	 zfc4GcdXTc1T+IbrBymWUEBIQFO0CfiRTH6VAum1BdXPxEN7lUQVvgPszu9nTfJXD9
	 Sr/vINXuO/3w8Tn4B1qQoNdS+QDefv+1IWbvo9jDTpswAVhU76Ot6AKY9+AFNs0mXg
	 rjfQNkALOKlcA==
Date: Wed, 2 Oct 2024 15:54:55 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: linux-xfs@vger.kernel.org, aalbersh@kernel.org
Subject: Re: [PATCH v3 2/2] xfsprogs: update gitignore
Message-ID: <20241002225455.GK21853@frogsfrogsfrogs>
References: <20241002103624.1323492-1-aalbersh@redhat.com>
 <20241002103624.1323492-3-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241002103624.1323492-3-aalbersh@redhat.com>

On Wed, Oct 02, 2024 at 12:36:24PM +0200, Andrey Albershteyn wrote:
> Building xfsprogs seems to produce many build artifacts which are
> not tracked by git. Ignore them.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> ---
> 
> Notes:
>     Replace ./configure~ with wildcard ./*~ to remove all backup files
>     which autoconf (or any other tool) can create

Seems fine to me...
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> 
>  .gitignore | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/.gitignore b/.gitignore
> index fd131b6fde52..756867124a02 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -33,6 +33,7 @@
>  /config.status
>  /config.sub
>  /configure
> +/*~
>  
>  # libtool
>  /libtool
> @@ -69,13 +70,16 @@ cscope.*
>  /rtcp/xfs_rtcp
>  /spaceman/xfs_spaceman
>  /scrub/xfs_scrub
> -/scrub/xfs_scrub@.service
>  /scrub/xfs_scrub_all
> -/scrub/xfs_scrub_all.cron
> -/scrub/xfs_scrub_all.service
> -/scrub/xfs_scrub_fail@.service
> +/scrub/xfs_scrub_fail
> +/scrub/*.cron
> +/scrub/*.service
>  
>  # generated crc files
>  /libfrog/crc32selftest
>  /libfrog/crc32table.h
>  /libfrog/gen_crc32table
> +
> +# docs
> +/man/man8/mkfs.xfs.8
> +/man/man8/xfs_scrub_all.8
> -- 
> 2.44.1
> 
> 
