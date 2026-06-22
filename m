Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F3DB372064
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jun 2026 10:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782124780; cv=none; b=KYdEw267qUbpk7f5mHO0KX2WtUPAX7t8XoaBI4rPDjmuYqrovUIGFwQi192w/IYBbmmbUo+m7pB2VvwzlqTZJp+NHN8QPEtEEEm9TEygICNxisvvmsGP5g8wC40LSwWGMQkRrt8IWBJdvulrUKpf0iZhJeFlg13uh11+YcFZUOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782124780; c=relaxed/simple;
	bh=uiEbiYKahMf6hnCe89UT4kje1hgmWwkwv05vH6ZWJhM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WpNqmW5YjcUzsScl2FpapVzEQH3cRJ9i8gqCeiSMDEGp2yt4Temw0M/R/eqoR47VghZInOgmQYZ8INFwGqlte77MM4BfzlbGKTzc7VkIeWxeX7451VRYiPBe7VbTIKZchKaasMVi/Ek1ZB6vxN1v6tgQRk/PQOqfpyNeVtoOdPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wz0uQRV7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wz0uQRV7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42C561F00A3A;
	Mon, 22 Jun 2026 10:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782124779;
	bh=iOccRgpEJeFhF3TDHXehCMSza7J9XhSh7D1nYAKp7sM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Wz0uQRV7DeuhYGpdGS9UbY8FuFx/bLyens2O4avC9lr3IrCxHzcr6G5XSIznqhIuh
	 x0Qu73YiWcf366rXQi/ZvquDEQAHawS4zJHX2YFIPF4IVsdxZ5NycGw0FL4GWcqQrm
	 Er1jYpXIqdUhEb4RRql2N82PMHQ1PRSMUuQf5i/YjmjtnokRZlNi1FPz9AgET2f9mr
	 XrxhzMZf6lkKMIczUm84Jf+pBDSDn+Gsl4OzrY2ONlrPwuvSCM3Fw+yUPccOMf33oy
	 delRPS3Jb+vMh2ulVrUUVIML2IIRbMtazeEYiYomsolBeczVcMKs4MuDqcYvfo5sPi
	 Qxh/tVdm6I8CQ==
Date: Mon, 22 Jun 2026 12:39:35 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Manognya Singuru <msinguru@redhat.com>
Cc: linux-xfs@vger.kernel.org, aalbersh@redhat.com
Subject: Re: [PATCH] mkfs: fix filesystem and log size units
Message-ID: <ajkQ3mLRYF2D2zf0@nidhogg.toxiclabs.cc>
References: <20260618144111.178311-1-msinguru@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260618144111.178311-1-msinguru@redhat.com>

On Thu, Jun 18, 2026 at 08:11:11PM +0530, Manognya Singuru wrote:
> The actual thresholds enforced by mkfs are in MiB and GiB but the
> error messages and documentation report the limits as MB and GB.
> 
> Update the filesystem and log size threshold messages, comments,
> and man page to use MiB and GiB.
> 
> Signed-off-by: Manognya Singuru <msinguru@redhat.com>

Looks fine by me.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  man/man8/mkfs.xfs.8.in |  6 +++---
>  mkfs/xfs_mkfs.c        | 14 +++++++-------
>  2 files changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
> index fbafc5c7..c4dee4fe 100644
> --- a/man/man8/mkfs.xfs.8.in
> +++ b/man/man8/mkfs.xfs.8.in
> @@ -463,7 +463,7 @@ is required if
>  is given. Otherwise, it is only needed if the filesystem should occupy
>  less space than the size of the special file.
>  
> -The data section must be at least 300MB in size.
> +The data section must be at least 300MiB in size.
>  .TP
>  .BI sunit= value
>  This is used to specify the stripe unit for a RAID device or a
> @@ -805,8 +805,8 @@ described above. The overriding minimum value for size is 512 blocks.
>  With some combinations of filesystem block size, inode size,
>  and directory block size, the minimum log size is larger than 512 blocks.
>  
> -The log must be at least 64MB in size.
> -The log cannot be more than 2GB in size.
> +The log must be at least 64MiB in size.
> +The log cannot be more than 2GiB in size.
>  .TP
>  .BI version= value
>  This specifies the version of the log. The current default is 2,
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index dd8a48c3..cbc703cc 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -25,10 +25,10 @@
>  #define MEGABLOCKS(count, blog)	((uint64_t)(count) << (20 - (blog)))
>  
>  /*
> - * Realistically, the log should never be smaller than 64MB.  Studies by the
> + * Realistically, the log should never be smaller than 64MiB.  Studies by the
>   * kernel maintainer in early 2022 have shown a dramatic reduction in long tail
>   * latency of the xlog grant head waitqueue when running a heavy metadata
> - * update workload when the log size is at least 64MB.
> + * update workload when the log size is at least 64MiB.
>   */
>  #define XFS_MIN_REALISTIC_LOG_BLOCKS(blog)	(MEGABLOCKS(64, (blog)))
>  
> @@ -3435,19 +3435,19 @@ validate_supported(
>  		return;
>  
>  	/*
> -	 * We don't support filesystems smaller than 300MB anymore.  Tiny
> +	 * We don't support filesystems smaller than 300MiB anymore.  Tiny
>  	 * filesystems have never been XFS' design target.  This limit has been
>  	 * carefully calculated to prevent formatting with a log smaller than
>  	 * the "realistic" size.
>  	 *
> -	 * If the realistic log size is 64MB, there are four AGs, and the log
> +	 * If the realistic log size is 64MiB, there are four AGs, and the log
>  	 * AG should be at least 1/8 free after formatting, this gives us:
>  	 *
> -	 * 64MB * (8 / 7) * 4 = 293MB
> +	 * 64MiB * (8 / 7) * 4 = 293MiB
>  	 */
>  	if (mp->m_sb.sb_dblocks < MEGABLOCKS(300, mp->m_sb.sb_blocklog)) {
>  		fprintf(stderr,
> - _("Filesystem must be larger than 300MB.\n"));
> + _("Filesystem must be larger than 300MiB.\n"));
>  		usage();
>  	}
>  
> @@ -3458,7 +3458,7 @@ validate_supported(
>  	if (mp->m_sb.sb_logblocks <
>  			XFS_MIN_REALISTIC_LOG_BLOCKS(mp->m_sb.sb_blocklog)) {
>  		fprintf(stderr,
> - _("Log size must be at least 64MB.\n"));
> + _("Log size must be at least 64MiB.\n"));
>  		usage();
>  	}
>  
> -- 
> 2.54.0
> 
> 
