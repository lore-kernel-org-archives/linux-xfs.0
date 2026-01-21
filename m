Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99E4A3793B1
	for <linux-xfs@vger.kernel.org>; Wed, 21 Jan 2026 10:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768990031; cv=none; b=LrO/C9E8tMyw7W2Rh2R2f6EHeuheaxUG1tkF114sGjUh8anSQ8kBA/WUp39Vz3Uw/f8r5iEhWgy/+37qYcqF4e2RFoIFObO5shndd16M1PC5OpMn1AirXgS5qi+emrHxhFPnkXydl+6DBYetmYv/lQk2o9A4fS48v5FptY5RbQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768990031; c=relaxed/simple;
	bh=CFCaS4yllxcjYaLAc19AYAp1cKqaNUNo16qOIOXKY7U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JSgut65cfCLD2ESIHrTTb/dTnP9VlzbzVxMiV6sEOdPIvABAFNO6DI4PL945lfAHvkru41q0mFtWbOsYkUMhPXR0o2qmRv2TUBv6jszwKsntU02oymKEdSxOe6U7xmEPXR3YBrP0ri7tDMI8v83v6FDdOstuwN8D8YnmHdsbARU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lJuGAoPF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lJuGAoPF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4057EC116D0;
	Wed, 21 Jan 2026 10:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768990031;
	bh=CFCaS4yllxcjYaLAc19AYAp1cKqaNUNo16qOIOXKY7U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lJuGAoPFIAcLUdVaJqANFMYIdoe7kJUjuAyUuUpPUnNP5eWC98WPuLRHOcdYM9srL
	 jzGWvIm+Z++NrSK1RHbCJg9zV3UYrtjMpMd4Xab42qeO9RXnCq/VIjFhiRnbUvIGvS
	 keV1RZ6NBqh4+N894jDcld4oiiCpds8FVSrkfw+FJs/M5JkgTUGdxQRyd8vINpgZGs
	 lPzAVzEc3YsJ/B6g/9UFuT7uPOetI6/eABrPCFCWYv7pLwSMq5RMUoXUd5OwIhLHIu
	 xqsXp2o8ILvxe9cKrQ965QW7/bSMmOVt7FDdf8dewikWPluhcPRpKVlvxNMkHfMjBd
	 58MrbVXgddUcg==
Date: Wed, 21 Jan 2026 11:07:04 +0100
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: promote metadata directories and large block support
Message-ID: <fbrzrkzqvwua64imzt2ii67uwre2fyqj47mogqj2gsrnlgk4my@k62y3yxnqm53>
References: <a-5vQeWw6LnfGOvRdoGMbRxWS78ETAGa-UfYR5B0xb2DUlK_XJ43X9QV2mRZtYr-x9XokBbT2TNzi1NxvqD7vQ==@protonmail.internalid>
 <20260121064540.GA5945@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260121064540.GA5945@frogsfrogsfrogs>

On Tue, Jan 20, 2026 at 10:45:40PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Large block support was merged upstream in 6.12 (Dec 2024) and metadata
> directories was merged in 6.13 (Jan 2025).  We've not received any
> serious complaints about the ondisk formats of these two features in the
> past year, so let's remove the experimental warnings.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  fs/xfs/xfs_message.h |    2 --
>  fs/xfs/xfs_message.c |    8 --------
>  fs/xfs/xfs_super.c   |    4 ----
>  3 files changed, 14 deletions(-)

Looks good to me too.
Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

> 
> diff --git a/fs/xfs/xfs_message.h b/fs/xfs/xfs_message.h
> index d68e72379f9dd5..49b0ef40d299de 100644
> --- a/fs/xfs/xfs_message.h
> +++ b/fs/xfs/xfs_message.h
> @@ -93,8 +93,6 @@ void xfs_buf_alert_ratelimited(struct xfs_buf *bp, const char *rlmsg,
>  enum xfs_experimental_feat {
>  	XFS_EXPERIMENTAL_SHRINK,
>  	XFS_EXPERIMENTAL_LARP,
> -	XFS_EXPERIMENTAL_LBS,
> -	XFS_EXPERIMENTAL_METADIR,
>  	XFS_EXPERIMENTAL_ZONED,
> 
>  	XFS_EXPERIMENTAL_MAX,
> diff --git a/fs/xfs/xfs_message.c b/fs/xfs/xfs_message.c
> index 19aba2c3d52544..5ac0ac3d4f39f9 100644
> --- a/fs/xfs/xfs_message.c
> +++ b/fs/xfs/xfs_message.c
> @@ -149,14 +149,6 @@ xfs_warn_experimental(
>  			.opstate	= XFS_OPSTATE_WARNED_LARP,
>  			.name		= "logged extended attributes",
>  		},
> -		[XFS_EXPERIMENTAL_LBS] = {
> -			.opstate	= XFS_OPSTATE_WARNED_LBS,
> -			.name		= "large block size",
> -		},
> -		[XFS_EXPERIMENTAL_METADIR] = {
> -			.opstate	= XFS_OPSTATE_WARNED_METADIR,
> -			.name		= "metadata directory tree",
> -		},
>  		[XFS_EXPERIMENTAL_ZONED] = {
>  			.opstate	= XFS_OPSTATE_WARNED_ZONED,
>  			.name		= "zoned RT device",
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index bc71aa9dcee8d6..1f432d6645898e 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1835,8 +1835,6 @@ xfs_fs_fill_super(
>  			error = -ENOSYS;
>  			goto out_free_sb;
>  		}
> -
> -		xfs_warn_experimental(mp, XFS_EXPERIMENTAL_LBS);
>  	}
> 
>  	/* Ensure this filesystem fits in the page cache limits */
> @@ -1922,8 +1920,6 @@ xfs_fs_fill_super(
>  			goto out_filestream_unmount;
>  		}
>  		xfs_warn_experimental(mp, XFS_EXPERIMENTAL_ZONED);
> -	} else if (xfs_has_metadir(mp)) {
> -		xfs_warn_experimental(mp, XFS_EXPERIMENTAL_METADIR);
>  	}
> 
>  	if (xfs_has_reflink(mp)) {
> 
