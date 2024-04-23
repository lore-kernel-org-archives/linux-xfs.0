Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4020355E45
	for <linux-xfs@vger.kernel.org>; Tue, 23 Apr 2024 12:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713873965; cv=none; b=lLedQPpQ7HyNGOOtrsY7M6RvaACeYUP6VoG5YcI9YZkeppHWrNVuuZIzFT95mhP8+J2xxis7wzmnYvd8/jlRSE5OeJzp/nYb02qGNoBiHHlNINjXkrGRG24elwkCIgp1DqCBmhgzKJc14KjJn+cmPLFRXzBt9i3CeTzRe5AENt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713873965; c=relaxed/simple;
	bh=2285hlKkSfxBlSG0KJ/mHcPKsFy7jjYGVUB9e5mfny8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WCJkxTyQCuIp/mtlC+Mwt/mffzWVCB++Kn9dve5Vh82Axk4CVAjAGbMFeJDeixd4eICsdIF7ONmXgajPb1OvYD5U4rp/IyUwJheiVCABFTIGOxjiTkdDzbUUP4rGQhA8nftSvcpokVr/TJP4MoAFUvryANctYMtmxU5lNUTlzSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k/vE8gJB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k/vE8gJB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76902C116B1;
	Tue, 23 Apr 2024 12:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713873964;
	bh=2285hlKkSfxBlSG0KJ/mHcPKsFy7jjYGVUB9e5mfny8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=k/vE8gJB0lKIF9wlf/JaS7yR6mF95qDmhMlzIwHmQRlW18Eu4WbBl5zj/dCtf/Npl
	 xHCrU0/vXIzLBu4Psuv8as0dmZwmukM13fXeUXwABdRD2xwLc9Ll9fLQ8AGH7673qJ
	 lC8jWmmSRxGW8N9kKUsZv9Xg7JZSUNSrTTRfgeU3jHtgkHl+sjhOS9sDTblS8VHggD
	 2g2UNuRHgiM+8e5JAXVlqqFo/iPQAPoQpkxTLMok3IOZUrAk8idPBhtqWU7NpCkZc8
	 rryg9gVhGoYh8XLGepcMRWp/yuDLFa4VGGHDJlS3Vzm9nA0ErT5Pk7bzb+dbW4tQ95
	 yl7CrS2YfCE+w==
Date: Tue, 23 Apr 2024 14:06:00 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org, hch@infradead.org
Subject: Re: [PATCH v4 2/4] xfs_repair: make duration take time_t
Message-ID: <ztbcnzbz3ff56jb6dlndh2c4nd5o6q6a6ku6l24z5ow7urkg6w@l4bwypdpdtaz>
References: <20240417161646.963612-1-aalbersh@redhat.com>
 <AldvXwG-630177p4GQIDSBX7_XzAQg-kSjfvizJvnaJDI4qAZLZc_PEhvqKniJsAO7moz1Fyn9WGP2OuFu4KbA==@protonmail.internalid>
 <20240417161646.963612-3-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240417161646.963612-3-aalbersh@redhat.com>

>  extern int		ag_stride;
> diff --git a/repair/progress.c b/repair/progress.c
> index f6c4d988444e..71042fbbfa4c 100644
> --- a/repair/progress.c
> +++ b/repair/progress.c
> @@ -268,12 +268,13 @@ progress_rpt_thread (void *p)
>  				_("\t- %02d:%02d:%02d: Phase %d: elapsed time %s - processed %d %s per minute\n"),
>  				tmp->tm_hour, tmp->tm_min, tmp->tm_sec,
>  				current_phase, duration(elapsed, msgbuf),
> -				(int) (60*sum/(elapsed)), *msgp->format->type);
> +				60 * sum / elapsed, *msgp->format->type);

				^ Type differs from print format.

Carlos

>  			do_log(
>  	_("\t- %02d:%02d:%02d: Phase %d: %" PRIu64 "%% done - estimated remaining time %s\n"),
>  				tmp->tm_hour, tmp->tm_min, tmp->tm_sec,
>  				current_phase, percent,
> -				duration((int) ((*msgp->total - sum) * (elapsed)/sum), msgbuf));
> +				duration((*msgp->total - sum) * elapsed / sum,
> +					msgbuf));
>  		}
> 
>  		if (pthread_mutex_unlock(&msgp->mutex) != 0) {
> @@ -420,7 +421,7 @@ timestamp(int end, int phase, char *buf)
>  }
> 
>  char *
> -duration(int length, char *buf)
> +duration(time_t length, char *buf)
>  {
>  	int sum;
>  	int weeks;
> diff --git a/repair/progress.h b/repair/progress.h
> index 2c1690db1b17..9575df164aa0 100644
> --- a/repair/progress.h
> +++ b/repair/progress.h
> @@ -38,7 +38,7 @@ extern void summary_report(void);
>  extern int  set_progress_msg(int report, uint64_t total);
>  extern uint64_t print_final_rpt(void);
>  extern char *timestamp(int end, int phase, char *buf);
> -extern char *duration(int val, char *buf);
> +extern char *duration(time_t val, char *buf);
>  extern int do_parallel;
> 
>  #define	PROG_RPT_INC(a,b) if (ag_stride && prog_rpt_done) (a) += (b)
> diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> index ba9d28330d82..2ceea87dc57d 100644
> --- a/repair/xfs_repair.c
> +++ b/repair/xfs_repair.c
> @@ -377,7 +377,7 @@ process_args(int argc, char **argv)
>  			do_prefetch = 0;
>  			break;
>  		case 't':
> -			report_interval = (int)strtol(optarg, NULL, 0);
> +			report_interval = strtol(optarg, NULL, 0);
>  			break;
>  		case 'e':
>  			report_corrected = true;
> --
> 2.42.0
> 
> 
