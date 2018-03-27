Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:49416 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751901AbeC0Wfb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Mar 2018 18:35:31 -0400
Date: Tue, 27 Mar 2018 15:31:44 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/3 V2] xfs_scrub: synchronize error levels & logging
Message-ID: <20180327223144.GG4818@magnolia>
References: <f7ab3da2-618c-dc1c-6d95-3890cdac2b43@redhat.com>
 <3b8c1fd3-46bb-39ea-fca9-63d308cbe6b4@redhat.com>
 <5606e2aa-8978-290b-15f0-7042b5a4863c@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5606e2aa-8978-290b-15f0-7042b5a4863c@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Tue, Mar 27, 2018 at 05:27:04PM -0500, Eric Sandeen wrote:
> Having only a subset of the five error_levels present in
> the log_level[] array is asking for trouble when someone
> tries to __str_log(S_PREEN ...) and overruns the array.
> 
> Tie it all together in a single structure that's
> initialized together to make the mapping more obvious and
> idiot-proof.
> 
> Fixes-coverity-id: 1433618
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> V2: i8n, keep test for PREEN in __str_log
> 
> diff --git a/scrub/common.c b/scrub/common.c
> index 5a37a98..02c6c9d 100644
> --- a/scrub/common.c
> +++ b/scrub/common.c
> @@ -56,18 +56,15 @@ xfs_scrub_excessive_errors(
>  	return ret;
>  }
>  
> -static const char *err_str[] = {
> -	[S_ERROR]	= "Error",
> -	[S_WARN]	= "Warning",
> -	[S_REPAIR]	= "Repaired",
> -	[S_INFO]	= "Info",
> -	[S_PREEN]	= "Optimized",
> -};
> -
> -static int log_level[] = {
> -	[S_ERROR]	= LOG_ERR,
> -	[S_WARN]	= LOG_WARNING,
> -	[S_INFO]	= LOG_INFO,
> +static struct {
> +	const char *string;
> +	int loglevel;
> +} err_levels[] = {
> +	[S_ERROR]  = { .string = "Error",	.loglevel = LOG_ERR },
> +	[S_WARN]   = { .string = "Warning",	.loglevel = LOG_WARNING },
> +	[S_REPAIR] = { .string = "Repaired",	.loglevel = LOG_WARNING },
> +	[S_INFO]   = { .string = "Info",	.loglevel = LOG_INFO },
> +	[S_PREEN]  = { .string = "Optimized",	.loglevel = LOG_INFO }
>  };
>  
>  /* If stream is a tty, clear to end of line to clean up progress bar. */
> @@ -106,8 +103,8 @@ __str_out(
>  	if (level == S_PREEN && !debug && !verbose)
>  		goto out_record;
>  
> -	fprintf(stream, "%s%s: %s: ", stream_start(stream), _(err_str[level]),
> -			descr);
> +	fprintf(stream, "%s%s: %s: ", stream_start(stream),
> +			_(err_levels[level].string), descr);
>  	if (error) {
>  		fprintf(stream, _("%s."), strerror_r(error, buf, DESCR_BUFSZ));
>  	} else {
> @@ -168,11 +161,11 @@ __str_log(
>  	snprintf(logname, LOGNAME_BUFSZ, "%s@%s", progname, ctx->mntpoint);
>  	openlog(logname, LOG_PID, LOG_DAEMON);
>  
> -	sz = snprintf(buf, LOG_BUFSZ, "%s: ", _(err_str[level]));
> +	sz = snprintf(buf, LOG_BUFSZ, "%s: ", _(err_levels[level].string));
>  	va_start(args, format);
>  	vsnprintf(buf + sz, LOG_BUFSZ - sz, format, args);
>  	va_end(args);
> -	syslog(log_level[level], "%s", buf);
> +	syslog(err_levels[level].loglevel, "%s", buf);
>  
>  	closelog();
>  }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
