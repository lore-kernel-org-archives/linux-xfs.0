Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB82E132C38
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 16:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713284325; cv=none; b=eMKXG5DZEFZYguEO0OGEDRkIUHB+8fdPrhQNXuVgoT7ticbbRmb1qRTQZ4c052zsZJdc4IuBokzZLE+D+vke+BcV2gVZyHGelM5Pb3BxwGzXnfjk3wDIwkvtDERjfYxFmu1mpzBe3EaLZCf04XVjnk6qlCMAklgQYGLau9dcUXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713284325; c=relaxed/simple;
	bh=awPZlA5FACv5ZNBRV0dDH32ebMQg4xKkijSOnMZjM6E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CiODQwdU1mjCuVfKFO3JfPBE5Y27LwHpcT7w9iMMiaANkxRctbtgq5VwfeSwwwQ3SFBlz7TrBuKDkLN9NcXiyhwHZWYcfEueaHz+fSq0iM0YHtXxxzFMqJ9Xpg2th3xkQmWiip0lL9peDlETaU2LkRUahpzVL75vlpPT9uY3vJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lw4A4WIZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lw4A4WIZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ED3FC4AF0B;
	Tue, 16 Apr 2024 16:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713284325;
	bh=awPZlA5FACv5ZNBRV0dDH32ebMQg4xKkijSOnMZjM6E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Lw4A4WIZbosEgdKYHU8Yxf3N22zTp74LPzALv+wU3kKvF51wCwcBPXQ8q8IWj9vx9
	 kYDWvEXExeK/LXeuoM+dBildR11Cvif6MCg8Syf6Fq51GsGH3r1gIZOU7CPiRfBW0w
	 MEoKE7ir1n4d8njds56elkYwSKhnCsoWfmCCALc4fMWfT8aa2R8YBFUOlzdmhTuCIX
	 u5/ixqzVfGU7yL7sSC9juSuvtmLxW1Wfnoe6p/WHH/LYRrZkk2OgwIsmLSgBDDwm12
	 +pXjL+ocLCjI7aauLOUzrJt0B/Ch6JSYt2HpNjYkMv955P6I5QSIHvQMZdo55kBDxc
	 Ay3Fbu7QjPRfQ==
Date: Tue, 16 Apr 2024 09:18:44 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs_scrub: don't call phase_end if phase_rusage was
 not initialized
Message-ID: <20240416161844.GM11948@frogsfrogsfrogs>
References: <20240416123427.614899-1-aalbersh@redhat.com>
 <20240416123427.614899-5-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240416123427.614899-5-aalbersh@redhat.com>

On Tue, Apr 16, 2024 at 02:34:26PM +0200, Andrey Albershteyn wrote:
> If unicrash_load() fails, all_pi can be used uninitialized in
> phase_end(). Fix it by going to the unload: section if unicrash_load
> fails and just go with unicrash_unload() (the is_service won't be
> initialized here).
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> ---
>  scrub/xfs_scrub.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
> index 752180d646ba..d226721d1dd7 100644
> --- a/scrub/xfs_scrub.c
> +++ b/scrub/xfs_scrub.c
> @@ -631,7 +631,7 @@ main(
>  		fprintf(stderr,
>  	_("%s: couldn't initialize Unicode library.\n"),
>  				progname);
> -		goto out;
> +		goto unload;

Rename this label out_unicrash to describe what piece will be unloaded,
and you can add:
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

>  	}
>  
>  	pthread_mutex_init(&ctx.lock, NULL);
> @@ -828,6 +828,7 @@ out:
>  	phase_end(&all_pi, 0);
>  	if (progress_fp)
>  		fclose(progress_fp);
> +unload:
>  	unicrash_unload();
>  
>  	/*
> -- 
> 2.42.0
> 
> 
