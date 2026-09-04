Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 505B23BF69A;
	Fri,  4 Sep 2026 06:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788504486; cv=none; b=FNINSntme+5qGdufp3xwwJ/qqk0qWCLSp25AYHV6lxyXfyxSrhN8DW5eK9Q1DEZoyeLekcmBoyBnDBGsbGN8ZdR4KCQayFYOWzLpyZA5u6Qjr5fEGWO+ObXQbRuSjupSQviZZ1JH0qY89rr4rl1FWi883PJZRizrAaSDDuRE0LY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788504486; c=relaxed/simple;
	bh=MMpSm4b29PBaem8EwvLH74n0nZXBoLuwFnaGUXjBEmI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G0JOsQXsHOVF7KK9Wo0sirnByzFzSFG7egsMRhK6BlfeK8CRSpza4fjXBU+0NUHjVTWOjBBo/BvClMxxm3NbJA2Ry9QqxvGbL+SsbOHv6pn5k0X/OugDA0/nB2zjm5pEMXSApmaP4JmZ7mPIkRbn6bPz2g0OHYhzC+M7KKeD/58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BUjlw7ss; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BUjlw7ss"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D03CF1F00A3D;
	Fri,  4 Sep 2026 06:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788504484;
	bh=oTP8X09q1k9zd8uYTIdNMNT5ok6k+mt99wukreFq0PM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BUjlw7ssoKZxfiVRDBeqFNHTsSdmMFgvx1lP8WnO+7Zlc6w5WXB/ajhew5R1d6TEZ
	 i1iX1D6/CYjJATSz7wluZgn1ZYFEkiXzvCeibJ0fdQwhllo/zVghAGeYAwwd6wqpWK
	 ba6ZAYOcGLVFQMlvQWlGix+pj8q18uo+LUlQfgZfZhXs+tnMd72cZHl+qw3a04dl49
	 Lq163r+dDd011GGRoFT3mbq+YYmrcifmPXgnaWvj09BLS9awzyOWy3iOO7IZoo/I26
	 zEkYcN+Welx7lFJGU07BDMIzWRbEVERIkthDjk7F76CyUDRDBchTAipxSntHesBT47
	 37z5vPt4IOd7A==
Date: Fri, 4 Sep 2026 08:48:00 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: snapshot scrub stats when rendering them
Message-ID: <apppmoGnOMa9QVyZ@andromeda.toxiclabs.cc>
References: <178850312462.1198660.3332635535003842521.stgit@frogsfrogsfrogs>
 <178850312518.1198660.12930219318866018921.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178850312518.1198660.12930219318866018921.stgit@frogsfrogsfrogs>

On Thu, Sep 03, 2026 at 11:26:02PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM complains about concurrency problems in the scrub stats code
> because xchk_stats_format doesn't synchronize in any way with updates.
> These stats are only reported through debugfs so I don't think it really
> matters, but I guess I exist to make bots happy now.
> 
> Cc: <stable@vger.kernel.org> # v6.6
> Fixes: d7a74cad8f4513 ("xfs: track usage statistics of online fsck")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> Assisted-by: LOLLM # finding obvious bugs
> ---
>  fs/xfs/scrub/stats.c |   32 +++++++++++++++++++-------------
>  1 file changed, 19 insertions(+), 13 deletions(-)
> 

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> 
> diff --git a/fs/xfs/scrub/stats.c b/fs/xfs/scrub/stats.c
> index 76f2515188d1b1..f3f1fbfb6d9955 100644
> --- a/fs/xfs/scrub/stats.c
> +++ b/fs/xfs/scrub/stats.c
> @@ -99,25 +99,31 @@ xchk_stats_format(
>  	int			ret = 0;
>  
>  	for (i = 0; i < XFS_SCRUB_TYPE_NR; i++, css++) {
> +		struct xchk_scrub_stats	fss;
> +
>  		if (!name_map[i])
>  			continue;
>  
> +		spin_lock(&css->css_lock);
> +		memcpy(&fss, css, offsetof(struct xchk_scrub_stats, css_lock));
> +		spin_unlock(&css->css_lock);
> +
>  		ret = scnprintf(buf, remaining,
>   "%s %u %u %u %u %u %u %u %u %u %llu %u %u %llu\n",
>  				name_map[i],
> -				(unsigned int)css->invocations,
> -				(unsigned int)css->clean,
> -				(unsigned int)css->corrupt,
> -				(unsigned int)css->preen,
> -				(unsigned int)css->xfail,
> -				(unsigned int)css->xcorrupt,
> -				(unsigned int)css->incomplete,
> -				(unsigned int)css->warning,
> -				(unsigned int)css->retries,
> -				(unsigned long long)css->checktime_us,
> -				(unsigned int)css->repair_invocations,
> -				(unsigned int)css->repair_success,
> -				(unsigned long long)css->repairtime_us);
> +				(unsigned int)fss.invocations,
> +				(unsigned int)fss.clean,
> +				(unsigned int)fss.corrupt,
> +				(unsigned int)fss.preen,
> +				(unsigned int)fss.xfail,
> +				(unsigned int)fss.xcorrupt,
> +				(unsigned int)fss.incomplete,
> +				(unsigned int)fss.warning,
> +				(unsigned int)fss.retries,
> +				(unsigned long long)fss.checktime_us,
> +				(unsigned int)fss.repair_invocations,
> +				(unsigned int)fss.repair_success,
> +				(unsigned long long)fss.repairtime_us);
>  		if (ret <= 0)
>  			break;
>  
> 
> 
