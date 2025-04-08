Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3DE91D5142
	for <linux-xfs@vger.kernel.org>; Tue,  8 Apr 2025 14:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744121485; cv=none; b=HL/EhDiR5htdjy9Eb1KfZiqaJBlcOHCRpAaeAKRd6juxqZBw0lh6op5te2tj8KTAEscDP4lkvZDlt2eEUdGaAx8tppOU+Y+2narh7JaqRBgPQXhw9S7/m4pGmk109yLPJrz4DlERGnXu5YVVj9KY9FklNwoMuViDF6DYH4unTUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744121485; c=relaxed/simple;
	bh=MsJK1Tzpi/xAVGF3a/TjAhgk4NuISU0wUBvX0jhRNqc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kbIWUWul6pYjEQVKDas+rvQAyR+dQT9ZP49z3QDE3BJz4e5e50h2kbv11bQ2f/axjjx/QoGCLVt5vYuWuNjrnciAuK3Z4VB8AJ1ep+4AZy8H3afWJXDBH1qO1hwmryr95Vs8kedsTCNCQ7Adf7AhOxVxjS5y3y8yY5FO/ufaYG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=najSsoJz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="najSsoJz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 108F3C4CEE7;
	Tue,  8 Apr 2025 14:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744121485;
	bh=MsJK1Tzpi/xAVGF3a/TjAhgk4NuISU0wUBvX0jhRNqc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=najSsoJzpdo+RlnLJ2u4hyJDDBMw36GHs7YEyRHFXOVEYBAq2I0y8SHxPXPIp8a+F
	 IAcMITacs55A7WDgMRYedMsnIE4eBmsVdqjOvCmyZEd421scixhDalOKWZSLIKJZ0A
	 3NHJ6W6ZwC9jL9CBR8Nrx5YB/HxhW4y1diiMMgPdPIvvqvFREm6xC2EqdfPsY/X5hp
	 zt1Q1Tgft4vYTD2r4dd4e9NWPEmY/m5aK9oD1coeE00XaCOoSyoiCgoV9aSecnjkMI
	 8R8IhhUVlcDi8TGENS7TnmibV/R6b2rm9Q2YhkN2qHnjCKCl4MbvA67HFSwDt1eo8L
	 eLbYTzOT0j7Rw==
Date: Tue, 8 Apr 2025 07:11:24 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: linux-xfs@vger.kernel.org, Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [PATCH] gitignore: update gitignore with python scripts
Message-ID: <20250408141124.GE6283@frogsfrogsfrogs>
References: <20250408104839.449132-2-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250408104839.449132-2-aalbersh@kernel.org>

On Tue, Apr 08, 2025 at 12:48:40PM +0200, Andrey Albershteyn wrote:
> Now as these scripts are generated with gettext.py support they have
> .py extension. Add them to gitignore instead of old ones together
> with newly added gettext.py
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

Ooops, sorry I continually forget to fiddle with this. :(
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  .gitignore | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/.gitignore b/.gitignore
> index 5d971200d5bf..6867d669c93d 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -65,13 +65,13 @@ cscope.*
>  /mdrestore/xfs_mdrestore
>  /mkfs/fstyp
>  /mkfs/mkfs.xfs
> -/mkfs/xfs_protofile
> +/mkfs/xfs_protofile.py
>  /quota/xfs_quota
>  /repair/xfs_repair
>  /rtcp/xfs_rtcp
>  /spaceman/xfs_spaceman
>  /scrub/xfs_scrub
> -/scrub/xfs_scrub_all
> +/scrub/xfs_scrub_all.py
>  /scrub/xfs_scrub_all.timer
>  /scrub/xfs_scrub_fail
>  /scrub/*.cron
> @@ -81,6 +81,7 @@ cscope.*
>  /libfrog/crc32selftest
>  /libfrog/crc32table.h
>  /libfrog/gen_crc32table
> +/libfrog/gettext.py
>  
>  # docs
>  /man/man8/mkfs.xfs.8
> -- 
> 2.47.2
> 
> 
