Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 822E741F5F3
	for <linux-xfs@vger.kernel.org>; Fri,  4 Sep 2026 06:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788505150; cv=none; b=pVguMqMVqUbL+8Qzf/JHaa6xxgwZauZZYsHk2TF2iovgImjfw8kBbXFycmZQ0jexdVHyF3vnL4L8ZLqoDmnhMaz0TetrMCeUfCfQSDmDEHzMVdFS3N2XUU2/EiYt0xqsv3aVO+O0tyjz98HrQP1zUQf5snQedyYDGnmJDCzL0yY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788505150; c=relaxed/simple;
	bh=hhVAXM4s7Nhq2UYSMEw6b+rJlbi+EX2tzpZ4hPsRX0o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f1UmCpEny6sk08Aw22ZoBj6u2OPz5pIGPgzWnT9uT5YwIt3eqn+NQUbtVDijeRC9efBrmH1gTbI0hbrWwndfPG9sLGLdEgxIpOhIJtvQpFKd5gk8ThxZez+EffNEWzsHIRJ22WYDHItd0hX8pjB8RjSiQiQcUfrHlRrDpMPkXCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P86KV/20; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P86KV/20"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD1241F00A3D;
	Fri,  4 Sep 2026 06:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788505147;
	bh=YdHshHW2bRrYPe7/0Doc/uwDIF2I6K4pVZZm+q2d+Pk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=P86KV/20unYH50abD0fYZK0F9nBF334ae3kT5C46tK3k3Ic7OUT88Gk7XAjN4g7X9
	 LiDGDnijkd830savvENIuOOWJQl1T1P3L3K2gIgAKDjB7KZ1Zv+s/VdU+JhOtgRDKO
	 svZA+FCeuirZUiitTxFsDmA4iz2a72jpqWq0lqmZDUM4A6xePeRKS54zAg6y7rDurH
	 lssAD6kdsQsfIfFYlKlXr5sRPe2oRqFahiGiOcOnXb6nAW0wjXLqIxf+l6xnVmJGdN
	 odYDpbQ19BXwMQyEIbYtUWHGWViLKTNReHhfTMoo3a+cZRUR/L5O+CZrr+Tyc2OIuf
	 goIfvDMOrp5vw==
Date: Fri, 4 Sep 2026 08:59:03 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: report runtime failures in scrub
Message-ID: <appr6-zfHZzEB9sC@andromeda.toxiclabs.cc>
References: <178850312462.1198660.3332635535003842521.stgit@frogsfrogsfrogs>
 <178850312561.1198660.15558855470989904766.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178850312561.1198660.15558855470989904766.stgit@frogsfrogsfrogs>

On Thu, Sep 03, 2026 at 11:26:33PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Add a new counter so that we can track the number of runtime failures
> encountered during scrubs.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  fs/xfs/scrub/stats.c |   14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> 
> 
> diff --git a/fs/xfs/scrub/stats.c b/fs/xfs/scrub/stats.c
> index da0c05ffe5cd0b..3339cae4b39d14 100644
> --- a/fs/xfs/scrub/stats.c
> +++ b/fs/xfs/scrub/stats.c
> @@ -29,6 +29,7 @@ struct xchk_scrub_stats {
>  	uint32_t		incomplete;
>  	uint32_t		warning;
>  	uint32_t		retries;
> +	uint32_t		runtime_errors;
>  
>  	/* repair stats */
>  	uint32_t		repair_invocations;
> @@ -110,7 +111,7 @@ xchk_stats_format(
>  		spin_unlock(&css->css_lock);
>  
>  		ret = scnprintf(buf, remaining,
> - "%s %u %u %u %u %u %u %u %u %u %llu %u %u %llu\n",
> + "%s %u %u %u %u %u %u %u %u %u %llu %u %u %llu %u\n",
>  				name_map[i],
>  				(unsigned int)fss.invocations,
>  				(unsigned int)fss.clean,
> @@ -124,7 +125,8 @@ xchk_stats_format(
>  				(unsigned long long)fss.checktime_us,
>  				(unsigned int)fss.repair_invocations,
>  				(unsigned int)fss.repair_success,
> -				(unsigned long long)fss.repairtime_us);
> +				(unsigned long long)fss.repairtime_us,
> +				(unsigned int)fss.runtime_errors);
>  		if (ret <= 0)
>  			break;
>  
> @@ -207,13 +209,17 @@ xchk_stats_merge_one(
>  	}
>  
>  	/* caller applies this same transformation after we return */
> -	if (error == -EFSCORRUPTED || error == -EFSBADCRC)
> +	if (error == -EFSCORRUPTED || error == -EFSBADCRC) {
>  		sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
> +		error = 0;
> +	}
>  
>  	css = &cs->cs_stats[sm->sm_type];
>  	spin_lock(&css->css_lock);
>  	css->invocations++;
> -	if (!(sm_flags & XFS_SCRUB_OFLAG_UNCLEAN))
> +	if (error)
> +		css->runtime_errors++;
> +	else if (!(sm_flags & XFS_SCRUB_OFLAG_UNCLEAN))
>  		css->clean++;
>  	if (sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
>  		css->corrupt++;
> 
> 
