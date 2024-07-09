Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A62A01B86DD
	for <linux-xfs@vger.kernel.org>; Tue,  9 Jul 2024 20:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720557967; cv=none; b=i7Lnd43YHg5dEaFMwwIaJF3BOyssHNUYSnhr7TMEgzjhH3NvITNmb64S6GZU7WjY+PwVyGYL7kX1POKwFZAHEA/sxHCrFtyreiYryGZCKTJ2j1lE57rQ8Fo3B8+nWymMynuiUuRZCC0FeBmda78Zv5LS9KTZ8oVfRD1gUURwezQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720557967; c=relaxed/simple;
	bh=iWKZ5OceOd5uCU/vbIrx6qaP8s6L64KahvT3ByyJk0U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gIobxpQKls1bFL+D7KRbT27R9v2jghudR3FR1iTzshTGB8Kz0HA6K11upDcUX6o+fKkYF7H5Ii6OjG9iqJfBMVA/HC8LPHJs568Jm1I5JihP7/n7YG0tYI4lZ5xZixYUOdJ9CAgb60ii2HSaNcjEDIxgwqO54tQAf3c384RFMko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G0TPYLlW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G0TPYLlW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C503C3277B;
	Tue,  9 Jul 2024 20:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720557967;
	bh=iWKZ5OceOd5uCU/vbIrx6qaP8s6L64KahvT3ByyJk0U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=G0TPYLlWORaZfhRrUq3iZ+snDDk2qgIpqesWAjqgy9FhgDx54FVm8PZyR8GVYanaI
	 sW9kYaeD5TquQflxqomsqAGuOBMHAf/2dc6DDrrekvn8ldoXXtyEUGCbPiBGeniZ8d
	 yZ6UjyyzcO9DuC0nAZ+PUZqVhoXhG1HRpFM68I2f0JDSDtG8MC+Ikg9+YlHWECidnY
	 bDIcJyU0CdREZyIPl3Sf4ieSusTZ8sF+PRkfT7EpmbvQuj+lndUfkl1BYNiqe5UaGF
	 vwp7e8e0JFWNoxhxykzNJPQ2S1oxZamcDVvf9AnOGJYSGWdXK1hc00wWJ7/0658jEw
	 Ha9tDz9qqU1LA==
Date: Tue, 9 Jul 2024 13:46:06 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Wengang Wang <wen.gang.wang@oracle.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/9] spaceman/defrag: sleeps between segments
Message-ID: <20240709204606.GU612460@frogsfrogsfrogs>
References: <20240709191028.2329-1-wen.gang.wang@oracle.com>
 <20240709191028.2329-8-wen.gang.wang@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240709191028.2329-8-wen.gang.wang@oracle.com>

On Tue, Jul 09, 2024 at 12:10:26PM -0700, Wengang Wang wrote:
> Let user contol the time to sleep between segments (file unlocked) to
> balance defrag performance and file IO servicing time.
> 
> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
> ---
>  spaceman/defrag.c | 26 ++++++++++++++++++++++++--
>  1 file changed, 24 insertions(+), 2 deletions(-)
> 
> diff --git a/spaceman/defrag.c b/spaceman/defrag.c
> index b5c5b187..415fe9c2 100644
> --- a/spaceman/defrag.c
> +++ b/spaceman/defrag.c
> @@ -311,6 +311,9 @@ void defrag_sigint_handler(int dummy)
>   */
>  static long	g_limit_free_bytes = 1024 * 1024 * 1024;
>  
> +/* sleep time in us between segments, overwritten by paramter */
> +static int		g_idle_time = 250 * 1000;
> +
>  /*
>   * check if the free space in the FS is less than the _limit_
>   * return true if so, false otherwise
> @@ -487,6 +490,7 @@ defrag_xfs_defrag(char *file_path) {
>  	int	scratch_fd = -1, defrag_fd = -1;
>  	char	tmp_file_path[PATH_MAX+1];
>  	struct file_clone_range clone;
> +	int	sleep_time_us = 0;
>  	char	*defrag_dir;
>  	struct fsxattr	fsx;
>  	int	ret = 0;
> @@ -574,6 +578,9 @@ defrag_xfs_defrag(char *file_path) {
>  
>  		/* checks for EoF and fix up clone */
>  		stop = defrag_clone_eof(&clone);
> +		if (sleep_time_us > 0)
> +			usleep(sleep_time_us);
> +
>  		gettimeofday(&t_clone, NULL);
>  		ret = ioctl(scratch_fd, FICLONERANGE, &clone);
>  		if (ret != 0) {
> @@ -587,6 +594,10 @@ defrag_xfs_defrag(char *file_path) {
>  		if (time_delta > max_clone_us)
>  			max_clone_us = time_delta;
>  
> +		/* sleeps if clone cost more than 500ms, slow FS */

Why half a second?  I sense that what you're getting at is that you want
to limit file io latency spikes in other programs by relaxing the defrag
program, right?  But the help screen doesn't say anything about "only if
the clone lasts more than 500ms".

> +		if (time_delta >= 500000 && g_idle_time > 0)
> +			usleep(g_idle_time);

These days, I wonder if it makes more sense to provide a CPU utilization
target and let the kernel figure out how much sleeping that is:

$ systemd-run -p 'CPUQuota=60%' xfs_spaceman -c 'defrag' /path/to/file

The tradeoff here is that we as application writers no longer have to
implement these clunky sleeps ourselves, but then one has to turn on cpu
accounting in systemd (if there even /is/ a systemd).  Also I suppose we
don't want this program getting throttled while it's holding a file
lock.

--D

> +
>  		/* for defrag stats */
>  		nr_ext_defrag += segment.ds_nr;
>  
> @@ -641,6 +652,12 @@ defrag_xfs_defrag(char *file_path) {
>  
>  		if (stop || usedKilled)
>  			break;
> +
> +		/*
> +		 * no lock on target file when punching hole from scratch file,
> +		 * so minus the time used for punching hole
> +		 */
> +		sleep_time_us = g_idle_time - time_delta;
>  	} while (true);
>  out:
>  	if (scratch_fd != -1) {
> @@ -678,6 +695,7 @@ static void defrag_help(void)
>  " -f free_space      -- specify shrethod of the XFS free space in MiB, when\n"
>  "                       XFS free space is lower than that, shared segments \n"
>  "                       are excluded from defragmentation, 1024 by default\n"
> +" -i idle_time       -- time in ms to be idle between segments, 250ms by default\n"
>  " -n                 -- disable the \"share first extent\" featue, it's\n"
>  "                       enabled by default to speed up\n"
>  	));
> @@ -691,7 +709,7 @@ defrag_f(int argc, char **argv)
>  	int	i;
>  	int	c;
>  
> -	while ((c = getopt(argc, argv, "s:f:n")) != EOF) {
> +	while ((c = getopt(argc, argv, "s:f:ni")) != EOF) {
>  		switch(c) {
>  		case 's':
>  			g_segment_size_lmt = atoi(optarg) * 1024 * 1024 / 512;
> @@ -709,6 +727,10 @@ defrag_f(int argc, char **argv)
>  			g_enable_first_ext_share = false;
>  			break;
>  
> +		case 'i':
> +			g_idle_time = atoi(optarg) * 1000;

Should we complain if optarg is non-integer garbage?  Or if g_idle_time
is larger than 1s?

--D

> +			break;
> +
>  		default:
>  			command_usage(&defrag_cmd);
>  			return 1;
> @@ -726,7 +748,7 @@ void defrag_init(void)
>  	defrag_cmd.cfunc	= defrag_f;
>  	defrag_cmd.argmin	= 0;
>  	defrag_cmd.argmax	= 4;
> -	defrag_cmd.args		= "[-s segment_size] [-f free_space] [-n]";
> +	defrag_cmd.args		= "[-s segment_size] [-f free_space] [-i idle_time] [-n]";
>  	defrag_cmd.flags	= CMD_FLAG_ONESHOT;
>  	defrag_cmd.oneline	= _("Defragment XFS files");
>  	defrag_cmd.help		= defrag_help;
> -- 
> 2.39.3 (Apple Git-146)
> 
> 
