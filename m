Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E46E31332B0
	for <linux-xfs@vger.kernel.org>; Tue, 23 Apr 2024 13:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713877486; cv=none; b=BrnVpVR6SZt+HKsihJGzRvSNQKMm7j8NW5TaO4O551cNQvb2L6vpTY+BCn1Bn9NoH2OaKbEpS2zCh+mxy6akFGq7vl1DyKlUg5NvwOoOCIQJjpRTXSunwuDKRXWlCyN7iD49/d04LQWkL/CmXz7O+Zw55myWNdmLZQejZ53nKnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713877486; c=relaxed/simple;
	bh=ZDCizKsTrQPFKBXkfkysyD/8c1MEH+p+DzTul5PSU0E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IQLZJGHmqubG8H4UzP8l9XQ+HevHnJHyOTZPhOuPuc81Hs2Qb9pONlfHEGv8rUjvxCepX+a2RftSb8mV6os+vnv/6t5cjzQwHXtfa216OowIXJ9FcimxrAHO02YWn93qmgLOq1VuxoBOI8NSTmFHyUvclm4oxD+QcBrhlsqe+zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KRm7rDdx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KRm7rDdx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 431F9C2BD11;
	Tue, 23 Apr 2024 13:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713877485;
	bh=ZDCizKsTrQPFKBXkfkysyD/8c1MEH+p+DzTul5PSU0E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KRm7rDdx1EMBjuwpV8l66Foy41wUBBJoq765MV7fzZxfqi2I4WDuMykmNBfCaZcr4
	 wScw4X27wthmKt2oYSDGxsOv76xYoHZXx7jyrPT/UCo1NgbWB9LBTM++Da7umjxTs4
	 zQwCTCqBKSqovxEjffVtN8e0pmjQYdiMtK8/BufHaPEywnh9iFP2U/M91Jq3pO3/gv
	 zZ1Ymd9Mea8Mu9f1IWEAYFf10KaOkLyBmCubhZRwXjGmC8kY9/JOF7TyTWBE4pmjBX
	 ViO7JiYj3/62n+BM+eXAJvCokLZLhWX7veCQhF3nenFti7+7VgA0sOhT41OT5W26Fr
	 iAlBPjwPF5W8A==
Date: Tue, 23 Apr 2024 15:04:41 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>, 
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v5 2/4] xfs_repair: make duration take time_t
Message-ID: <swzk5i4mgfuer3mojudy4l75fbmtykaialqt2w6e674yzngqww@cvyrwri7s6n6>
References: <20240423123616.2629570-2-aalbersh@redhat.com>
 <RVcADEjKMR8UX0VYmlUuReCTNdSNtAiaEcwBfnjJlqxP2i0opGh1nVzGdBsL8e2qvSxWvKDzasmztuU0JiQ6ew==@protonmail.internalid>
 <20240423123616.2629570-4-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240423123616.2629570-4-aalbersh@redhat.com>

>  extern int		ag_stride;
> diff --git a/repair/progress.c b/repair/progress.c
> index f6c4d988444e..2ce36cef0449 100644
> --- a/repair/progress.c
> +++ b/repair/progress.c
> @@ -265,15 +265,16 @@ progress_rpt_thread (void *p)
>  			 (current_phase == 7))) {
>  			/* for inode phase report % complete */
>  			do_log(
> -				_("\t- %02d:%02d:%02d: Phase %d: elapsed time %s - processed %d %s per minute\n"),
> +				_("\t- %02d:%02d:%02d: Phase %d: elapsed time %s - processed %ld %s per minute\n"),
>  				tmp->tm_hour, tmp->tm_min, tmp->tm_sec,
>  				current_phase, duration(elapsed, msgbuf),
> -				(int) (60*sum/(elapsed)), *msgp->format->type);
> +				60 * sum / elapsed, *msgp->format->type);

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

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
