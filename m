Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:48566 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753393AbeBLUrQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 12 Feb 2018 15:47:16 -0500
Subject: Re: [PATCH 1/7] xfs_scrub: log operational messages when interactive
References: <151787293446.3743.11110014829952400444.stgit@magnolia>
 <151787294062.3743.16150442240772340999.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <d32e8c99-5a56-6409-ec42-aea01220e2f7@sandeen.net>
Date: Mon, 12 Feb 2018 14:47:14 -0600
MIME-Version: 1.0
In-Reply-To: <151787294062.3743.16150442240772340999.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 2/5/18 5:22 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Record the output of an interactive session in the system log so that
> future support requests can get a better picture of what happened.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

I really want to log things, but I'm conflicted about spamming syslog.
I'm wondering if a generic /var/log/xfs.log would be good, and it could
eventually log all xfs-related administrative actions and outcomes with
a libfrog library helper... I don't know how non-syslog log files are
handled in general, does everybody just roll their own?

I'm inclined to leave this one out of 4.15 for now while I/we think
about the big picture here.

-Eric

> ---
>  scrub/common.c |   37 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 37 insertions(+)
> 
> 
> diff --git a/scrub/common.c b/scrub/common.c
> index 17c3699..672f286 100644
> --- a/scrub/common.c
> +++ b/scrub/common.c
> @@ -21,6 +21,7 @@
>  #include <pthread.h>
>  #include <stdbool.h>
>  #include <sys/statvfs.h>
> +#include <syslog.h>
>  #include "platform_defs.h"
>  #include "xfs.h"
>  #include "xfs_fs.h"
> @@ -29,6 +30,8 @@
>  #include "common.h"
>  #include "progress.h"
>  
> +extern char		*progname;
> +
>  /*
>   * Reporting Status to the Console
>   *
> @@ -64,6 +67,12 @@ static const char *err_str[] = {
>  	[S_PREEN]	= "Optimized",
>  };
>  
> +static int log_level[] = {
> +	[S_ERROR]	= LOG_ERR,
> +	[S_WARN]	= LOG_WARNING,
> +	[S_INFO]	= LOG_INFO,
> +};
> +
>  /* If stream is a tty, clear to end of line to clean up progress bar. */
>  static inline const char *stream_start(FILE *stream)
>  {
> @@ -73,6 +82,8 @@ static inline const char *stream_start(FILE *stream)
>  }
>  
>  /* Print a warning string and some warning text. */
> +#define LOG_BUFSZ	4096
> +#define LOGNAME_BUFSZ	256
>  void
>  __str_out(
>  	struct scrub_ctx	*ctx,
> @@ -110,6 +121,32 @@ __str_out(
>  		va_end(args);
>  	}
>  
> +	/* If we're running interactively, log the message to syslog too. */
> +	if (isatty(fileno(stdin)) && !debug) {
> +		char	logname[LOGNAME_BUFSZ];
> +
> +		snprintf(logname, LOGNAME_BUFSZ, "%s@%s", progname,
> +				ctx->mntpoint);
> +		openlog(logname, LOG_PID, LOG_DAEMON);
> +
> +		if (error) {
> +			syslog(LOG_ERR, "%s: %s: %s.",
> +					_(err_str[level]), descr,
> +					strerror_r(error, buf, DESCR_BUFSZ));
> +		} else {
> +			char	buf[LOG_BUFSZ];
> +			int	sz;
> +
> +			sz = snprintf(buf, LOG_BUFSZ, "%s: %s: ",
> +					_(err_str[level]), descr);
> +			va_start(args, format);
> +			vsnprintf(buf + sz, LOG_BUFSZ - sz, format, args);
> +			va_end(args);
> +			syslog(log_level[level], "%s", buf);
> +		}
> +		closelog();
> +	}
> +
>  	if (debug)
>  		fprintf(stream, _(" (%s line %d)"), file, line);
>  	fprintf(stream, "\n");
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
