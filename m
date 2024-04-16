Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B97144C6B
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 21:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713301239; cv=none; b=NkYzfbb+U/Im6gF+AsfXpmKZCt5NBUzwjklq1eVvOjuqO5w17a8roTuHFaXW5BY+bS6KDed3ADcKaNawPlhYLLxEIymgMWFkT9DcQRCI7hPPjY/VnkVzKOCkMKBWv5kAzCuYf8zm3F8ncu0q3Ums0ukEBtPsY0F6I5Kmu1+RvBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713301239; c=relaxed/simple;
	bh=bsRny1v3rD8RKKisIaejRd6VEq8oHTFWqvKxvhjSdXU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qgvjoMtewbKWN6EMlcOm2b2xPNZcS6JHHvQZfP16c/FP1OmeO4mkDqFXGrM1EKfpbWRd5+uaIHumfVOFmGyH/RiKfnk2FFb2CBrRyXJId2HJJvieG9LAtAS/cYfxc8pcnaDTzMo2OGk6O4f94uj0j0Ogig7Orgp8kZ0lFAYo39Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i0Xr/+cV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i0Xr/+cV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 876ADC3277B;
	Tue, 16 Apr 2024 21:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713301238;
	bh=bsRny1v3rD8RKKisIaejRd6VEq8oHTFWqvKxvhjSdXU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=i0Xr/+cVEpWD9/KNvNd/xMNdFXSpN04XvAaDIB1eRCDtb+u6ERvo7BicJEJOENpw3
	 Kl1KU6lmAqS03MrJ0Q9fI1xW/CvlKax5BlTWYCC0RftdLYiV5VZYjZIHf6OOoi4+Ng
	 C5jJ98Pktcq+N7nbcVJFrLQHC7MBS3Zxgk7jAvl+/0FWOxOFEukZf5ZqCtgqBL4NCW
	 5wJxR/9mcPk2sc3i1S9N9C36dfMJBePqOjl3CwHUeAne8JJWR+Fz/UvnDTlM2JsHL8
	 4eLnSKK3xRDv3wHNJo2E318iC+tywPjzd3nn3/z8C+5V9Ijjgnb2dLKfqr5C+G5Fow
	 3AOXicn3zhqPA==
Date: Tue, 16 Apr 2024 14:00:37 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 2/4] xfs_repair: make duration take time_t
Message-ID: <20240416210037.GG11948@frogsfrogsfrogs>
References: <20240416202402.724492-1-aalbersh@redhat.com>
 <20240416202402.724492-3-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240416202402.724492-3-aalbersh@redhat.com>

On Tue, Apr 16, 2024 at 10:24:00PM +0200, Andrey Albershteyn wrote:
> In most of the uses of duration() takes time_t instead of int.
> Convert the rest to use time_t and make duration() take time_t to
> not truncate it to int.
> 
> While at it remove unnecessary parentheses around 'elapsed'.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> ---
>  repair/globals.c    | 2 +-
>  repair/globals.h    | 2 +-
>  repair/progress.c   | 7 ++++---
>  repair/progress.h   | 2 +-
>  repair/xfs_repair.c | 2 +-
>  5 files changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/repair/globals.c b/repair/globals.c
> index c40849853b8f..7c819d70a0ab 100644
> --- a/repair/globals.c
> +++ b/repair/globals.c
> @@ -116,7 +116,7 @@ uint32_t	sb_width;
>  struct aglock	*ag_locks;
>  struct aglock	rt_lock;
>  
> -int		report_interval;
> +time_t		report_interval;
>  uint64_t	*prog_rpt_done;
>  
>  int		ag_stride;
> diff --git a/repair/globals.h b/repair/globals.h
> index 89f1b0e078f3..2d05c8b2c00f 100644
> --- a/repair/globals.h
> +++ b/repair/globals.h
> @@ -160,7 +160,7 @@ struct aglock {
>  extern struct aglock	*ag_locks;
>  extern struct aglock	rt_lock;
>  
> -extern int		report_interval;
> +extern time_t		report_interval;
>  extern uint64_t		*prog_rpt_done;
>  
>  extern int		ag_stride;
> diff --git a/repair/progress.c b/repair/progress.c
> index f6c4d988444e..5f80fb68ddfd 100644
> --- a/repair/progress.c
> +++ b/repair/progress.c
> @@ -268,12 +268,13 @@ progress_rpt_thread (void *p)
>  				_("\t- %02d:%02d:%02d: Phase %d: elapsed time %s - processed %d %s per minute\n"),
>  				tmp->tm_hour, tmp->tm_min, tmp->tm_sec,
>  				current_phase, duration(elapsed, msgbuf),
> -				(int) (60*sum/(elapsed)), *msgp->format->type);
> +				(int) (60*sum/elapsed), *msgp->format->type);
>  			do_log(
>  	_("\t- %02d:%02d:%02d: Phase %d: %" PRIu64 "%% done - estimated remaining time %s\n"),
>  				tmp->tm_hour, tmp->tm_min, tmp->tm_sec,
>  				current_phase, percent,
> -				duration((int) ((*msgp->total - sum) * (elapsed)/sum), msgbuf));
> +				duration((*msgp->total - sum) * elapsed/sum,
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

This also needs to clear and check errno to report errors.  However,
that should be a separate patch.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

>  			break;
>  		case 'e':
>  			report_corrected = true;
> -- 
> 2.42.0
> 
> 
