Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88FB41607A4
	for <linux-xfs@vger.kernel.org>; Fri,  7 Mar 2025 18:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741370853; cv=none; b=Ugpk9JWQUyvx4NADFaEtXXPiixrnh3zORABt6T1E6k6Zh2XKy/nWi7UPK64crGARaA5RxNy+EnbRwmt/xkzz1xlBpFX3qYDOzMIYXsDlw2JkaTWxtFByZw2hvoN1pKEiAuvubj+nJwPq9bJ0Lcn5X0gG+YAVr1aBdu+0oxyEYh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741370853; c=relaxed/simple;
	bh=fEkUqvo4QEq13xikZASkKJfqqX9pSzGxuEZW9b0lTMo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L12ZB1KLXnS/u5tVx1HAbToPcYet20cPk39Mzrcrny28cTSdQAiBsQrKbjx9czTZs220JVxFoDoxuRktA/KhvNMeXxtOGpZAUgK6HFXV/II5aAwU6yELhBZrAOkSnzNQMUUbR7U5rTiv0Qm6tHzvcSU66NL/eQ/KBJ/Tpw48VkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IE4T08vq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IE4T08vq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A650BC4CEEA;
	Fri,  7 Mar 2025 18:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741370853;
	bh=fEkUqvo4QEq13xikZASkKJfqqX9pSzGxuEZW9b0lTMo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IE4T08vqk3phUrs7VCPlk0CzpQIW5v/kBGAiky5thADUAh5n5LUQCv2WrsqrnrOcm
	 6z8xYQhjHIsGZsfZGqGSG/OfJYy0uT1WvRTehERd02c6XLtwVjFZ4CW18iRIrKQ6rE
	 lUVRnKYHsXB5bJkTaEjJL+7jjp+Ft5eGRTvhbBz8RX6oeiLu87xqCrM0hgABSniYtA
	 lOe9wLv52NEdVyYD0UmJNs+g0gl+7+KuSoYg/3rDuGJX8WZuMTRQcW2h4dXR9evXxL
	 k5705KOdgVuffc6EHV7XgZsOFoWBI4tKHFWTC2dA5rDUGR9nyQnhv90yUO0f7kWasO
	 52lGA+Kpg6KTw==
Date: Fri, 7 Mar 2025 19:07:27 +0100
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Kjetil Torgrim Homme <kjetilho@ifi.uio.no>, linux-xfs@vger.kernel.org, 
	Andrey Albershteyn <aalbersh@redhat.com>
Subject: Re: [PATCH] xfs_{admin,repair},man5: tell the user to mount with
 nouuid for snapshots
Message-ID: <ardyzk7y5vnhppepeth4kemallz7xkjaez4t2mf7fm2l2pyqys@fxna4sdl4vzt>
References: <02HUCQ14xn4UY-D7b1EK1t6blVFHGwHW9OukuueJzNNHz9t0vcBKRjDk10YiIkhGX4xaLN9TJfsOMolsfW4xCA==@protonmail.internalid>
 <20250307175501.GS2803749@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250307175501.GS2803749@frogsfrogsfrogs>

On Fri, Mar 07, 2025 at 09:55:01AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Augment the messaging in xfs_admin and xfs_repair to advise the user to
> replay a dirty log on a snapshotted filesystem by mounting with nouuid
> if the origin filesystem is still mounted.  A user accidentally zapped
> the log when trying to mount a backup snapshot because the instructions
> we gave them weren't sufficient.
> 
> Reported-by: Kjetil Torgrim Homme <kjetilho@ifi.uio.no>
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>


> ---
>  db/sb.c         |    9 +++++----
>  man/man5/xfs.5  |    5 +++++
>  repair/phase2.c |    9 +++++----
>  3 files changed, 15 insertions(+), 8 deletions(-)
> 
> diff --git a/db/sb.c b/db/sb.c
> index aa8fce6712e571..52ac48d45d5ae6 100644
> --- a/db/sb.c
> +++ b/db/sb.c
> @@ -266,10 +266,11 @@ sb_logcheck(void)
>  		dbprintf(_(
>  "ERROR: The filesystem has valuable metadata changes in a log which needs to\n"
>  "be replayed.  Mount the filesystem to replay the log, and unmount it before\n"
> -"re-running %s.  If you are unable to mount the filesystem, then use\n"
> -"the xfs_repair -L option to destroy the log and attempt a repair.\n"
> -"Note that destroying the log may cause corruption -- please attempt a mount\n"
> -"of the filesystem before doing this.\n"), progname);
> +"re-running %s.  If the filesystem is a snapshot of a mounted filesystem,\n"
> +"you may need to give mount the nouuid option.  If you are unable to mount\n"
> +"the filesystem, then use the xfs_repair -L option to destroy the log and\n"
> +"attempt a repair.  Note that destroying the log may cause corruption --\n"
> +"please attempt a mount of the filesystem before doing this.\n"), progname);
>  		return 0;
>  	}
>  	/* Log is clean */
> diff --git a/man/man5/xfs.5 b/man/man5/xfs.5
> index 0c1edc53e227ce..f9c046d4721a14 100644
> --- a/man/man5/xfs.5
> +++ b/man/man5/xfs.5
> @@ -91,6 +91,11 @@ .SH DESCRIPTION
>  and
>  .BR xfsrestore (8)
>  are recommended for making copies of XFS filesystems.
> +To mount a snapshot of an already-mounted filesystem, you may need to supply
> +the
> +.B nouuid
> +option to
> +.BR mount " (8)."
>  .SH OPERATIONS
>  Some functionality specific to the XFS filesystem is accessible to
>  applications through the
> diff --git a/repair/phase2.c b/repair/phase2.c
> index 29a406f69ca3a1..9a9733749266e5 100644
> --- a/repair/phase2.c
> +++ b/repair/phase2.c
> @@ -72,10 +72,11 @@ zero_log(
>  				do_warn(_(
>  "ERROR: The filesystem has valuable metadata changes in a log which needs to\n"
>  "be replayed.  Mount the filesystem to replay the log, and unmount it before\n"
> -"re-running xfs_repair.  If you are unable to mount the filesystem, then use\n"
> -"the -L option to destroy the log and attempt a repair.\n"
> -"Note that destroying the log may cause corruption -- please attempt a mount\n"
> -"of the filesystem before doing this.\n"));
> +"re-running xfs_repair.  If the filesystem is a snapshot of a mounted\n"
> +"filesystem, you may need to give mount the nouuid option.If you are unable\n"
> +"to mount the filesystem, then use the -L option to destroy the log and\n"
> +"attempt a repair.  Note that destroying the log may cause corruption --\n"
> +"please attempt a mount of the filesystem before doing this.\n"));
>  				exit(2);
>  			}
>  		}
