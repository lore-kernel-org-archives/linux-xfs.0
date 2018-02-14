Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:42210 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754489AbeBNHuX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Feb 2018 02:50:23 -0500
Received: by mail-wr0-f193.google.com with SMTP id k9so7338831wre.9
        for <linux-xfs@vger.kernel.org>; Tue, 13 Feb 2018 23:50:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <151787294062.3743.16150442240772340999.stgit@magnolia>
References: <151787293446.3743.11110014829952400444.stgit@magnolia> <151787294062.3743.16150442240772340999.stgit@magnolia>
From: Jan Tulak <jtulak@redhat.com>
Date: Wed, 14 Feb 2018 08:50:01 +0100
Message-ID: <CACj3i72cabNaS-OMcmFitc792zPTyhUCgf1hZQELHr8V1uPezw@mail.gmail.com>
Subject: Re: [PATCH 1/7] xfs_scrub: log operational messages when interactive
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Tue, Feb 6, 2018 at 12:22 AM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
>
> Record the output of an interactive session in the system log so that
> future support requests can get a better picture of what happened.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Jan Tulak <jtulak@redhat.com>

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
> +extern char            *progname;
> +
>  /*
>   * Reporting Status to the Console
>   *
> @@ -64,6 +67,12 @@ static const char *err_str[] = {
>         [S_PREEN]       = "Optimized",
>  };
>
> +static int log_level[] = {
> +       [S_ERROR]       = LOG_ERR,
> +       [S_WARN]        = LOG_WARNING,
> +       [S_INFO]        = LOG_INFO,
> +};
> +
>  /* If stream is a tty, clear to end of line to clean up progress bar. */
>  static inline const char *stream_start(FILE *stream)
>  {
> @@ -73,6 +82,8 @@ static inline const char *stream_start(FILE *stream)
>  }
>
>  /* Print a warning string and some warning text. */
> +#define LOG_BUFSZ      4096
> +#define LOGNAME_BUFSZ  256
>  void
>  __str_out(
>         struct scrub_ctx        *ctx,
> @@ -110,6 +121,32 @@ __str_out(
>                 va_end(args);
>         }
>
> +       /* If we're running interactively, log the message to syslog too. */
> +       if (isatty(fileno(stdin)) && !debug) {
> +               char    logname[LOGNAME_BUFSZ];
> +
> +               snprintf(logname, LOGNAME_BUFSZ, "%s@%s", progname,
> +                               ctx->mntpoint);
> +               openlog(logname, LOG_PID, LOG_DAEMON);
> +
> +               if (error) {
> +                       syslog(LOG_ERR, "%s: %s: %s.",
> +                                       _(err_str[level]), descr,
> +                                       strerror_r(error, buf, DESCR_BUFSZ));
> +               } else {
> +                       char    buf[LOG_BUFSZ];
> +                       int     sz;
> +
> +                       sz = snprintf(buf, LOG_BUFSZ, "%s: %s: ",
> +                                       _(err_str[level]), descr);
> +                       va_start(args, format);
> +                       vsnprintf(buf + sz, LOG_BUFSZ - sz, format, args);
> +                       va_end(args);
> +                       syslog(log_level[level], "%s", buf);
> +               }
> +               closelog();
> +       }
> +
>         if (debug)
>                 fprintf(stream, _(" (%s line %d)"), file, line);
>         fprintf(stream, "\n");
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
