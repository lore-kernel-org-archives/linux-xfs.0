Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9A3A13175E
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 16:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713283951; cv=none; b=dRFkVYzropuqaRxQpw8XQHs5V3j99U1kBSN8pD8T7rBdvlmMRV3gpTOQHIfhEaUjEXwjPI6lx9rgXTuFD7EB9+9g9TJxRQrdLCkkEZU+0lX2DXohB4MbGFj12SYobw+vQ0FPlK5sDO54RVq0HR0CCD42kyJgfOjPed7poVzQtSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713283951; c=relaxed/simple;
	bh=gA1FLW9VR5Z7vSF1pdI6M7Nzgb9k0beng7EH7eI+dEM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pQHkvf/7mlUYJxIe2e52rxen9owz13KVOh8/NNFcwpZE2ptk9g5Ddyo/zROGpmC9m1zKNpfuBdyfFV2UJnalPo6/9J7WElZLiaZ18NLnB0D75+/9Ey4ZDQ/cuAgdMfOK6gYiFapA7z5glcFV2pUGQc5U76Wie6Bf3ytGc3eyCS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pH0TlPCM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pH0TlPCM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89869C32783;
	Tue, 16 Apr 2024 16:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713283951;
	bh=gA1FLW9VR5Z7vSF1pdI6M7Nzgb9k0beng7EH7eI+dEM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pH0TlPCMVHsL4tPpxGp+wraw5Z4S8qVGK97I3sctmXK7opgARXccYZyuMir1OeK39
	 9eFWDgMh23maNSm32f8uxHOxIhtBhpDe3FgtYdDlwDRN5+hmeTf5LyaGWT4iH2iumi
	 RgORqicB1ifANizZMgOiisVFkHjMCVTVrOZDFLQwx7cC4FJuEhHuGb0yUDbcOHy+FW
	 CceLtnIfvTsagQZtPnw0Kw1xqmWIPin/6nsVBsRpb2NqDSt+iKX40CGRqRF8VpLeiI
	 bmLKy6ZX6Un//6Xxw3ZLT2ojIjTyTDB/MoOv39SpUmxAyoKNxfqZQZqagfM6xoGSXl
	 xBtClC8BSLQog==
Date: Tue, 16 Apr 2024 09:12:30 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs_repair: make duration take time_t
Message-ID: <20240416161230.GK11948@frogsfrogsfrogs>
References: <20240416123427.614899-1-aalbersh@redhat.com>
 <20240416123427.614899-3-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240416123427.614899-3-aalbersh@redhat.com>

On Tue, Apr 16, 2024 at 02:34:24PM +0200, Andrey Albershteyn wrote:
> In most of the uses of duration() takes time_t instead of int.
> Convert the rest to use time_t and make duration() take time_t to
> not truncate it to int.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> ---
>  repair/progress.c   | 4 ++--
>  repair/progress.h   | 2 +-
>  repair/xfs_repair.c | 2 +-
>  3 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/repair/progress.c b/repair/progress.c
> index f6c4d988444e..c2af1387eb14 100644
> --- a/repair/progress.c
> +++ b/repair/progress.c
> @@ -273,7 +273,7 @@ progress_rpt_thread (void *p)
>  	_("\t- %02d:%02d:%02d: Phase %d: %" PRIu64 "%% done - estimated remaining time %s\n"),
>  				tmp->tm_hour, tmp->tm_min, tmp->tm_sec,
>  				current_phase, percent,
> -				duration((int) ((*msgp->total - sum) * (elapsed)/sum), msgbuf));
> +				duration((time_t) ((*msgp->total - sum) * (elapsed)/sum), msgbuf));

I'm not in love with how this expression mixes uint64_t and time_t, but
I guess it's all the same now that we forced time_t to 64 bits.

You might remove the pointless parentheses around elapsed.

>  		}
>  
>  		if (pthread_mutex_unlock(&msgp->mutex) != 0) {
> @@ -420,7 +420,7 @@ timestamp(int end, int phase, char *buf)
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
> index ba9d28330d82..78a7205f0054 100644
> --- a/repair/xfs_repair.c
> +++ b/repair/xfs_repair.c
> @@ -377,7 +377,7 @@ process_args(int argc, char **argv)
>  			do_prefetch = 0;
>  			break;
>  		case 't':
> -			report_interval = (int)strtol(optarg, NULL, 0);
> +			report_interval = (time_t)strtol(optarg, NULL, 0);

report_interval is declared as an int and this patch doesn't change
that.  <confused>

--D

>  			break;
>  		case 'e':
>  			report_corrected = true;
> -- 
> 2.42.0
> 
> 
