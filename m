Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:33800 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754489AbeBNHsb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Feb 2018 02:48:31 -0500
Received: by mail-wr0-f196.google.com with SMTP id m5so9070951wrg.1
        for <linux-xfs@vger.kernel.org>; Tue, 13 Feb 2018 23:48:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180214003928.GG5217@magnolia>
References: <151787293446.3743.11110014829952400444.stgit@magnolia>
 <151787294062.3743.16150442240772340999.stgit@magnolia> <d32e8c99-5a56-6409-ec42-aea01220e2f7@sandeen.net>
 <20180214003928.GG5217@magnolia>
From: Jan Tulak <jtulak@redhat.com>
Date: Wed, 14 Feb 2018 08:48:09 +0100
Message-ID: <CACj3i738kNViGQz34BG69=FjwQYZkD1Aubg--WC4zTEdn8wt3g@mail.gmail.com>
Subject: Re: [PATCH 1/7] xfs_scrub: log operational messages when interactive
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Wed, Feb 14, 2018 at 1:39 AM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> On Mon, Feb 12, 2018 at 02:47:14PM -0600, Eric Sandeen wrote:
>> On 2/5/18 5:22 PM, Darrick J. Wong wrote:
>> > From: Darrick J. Wong <darrick.wong@oracle.com>
>> >
>> > Record the output of an interactive session in the system log so that
>> > future support requests can get a better picture of what happened.
>> >
>> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
>>
>> I really want to log things, but I'm conflicted about spamming syslog.
>> I'm wondering if a generic /var/log/xfs.log would be good, and it could
>> eventually log all xfs-related administrative actions and outcomes with
>> a libfrog library helper... I don't know how non-syslog log files are
>> handled in general, does everybody just roll their own?
>
> Evidently rsyslog actually can filter things out to a separate file.
> For example, /etc/rsyslog.d/20-ufw.conf:
>
> # Log kernel generated UFW log messages to file
> :msg,contains,"[UFW " /var/log/ufw.log
>
> # Uncomment the following to stop logging anything that matches the last
> # rule.  Doing this will stop logging kernel generated UFW log messages
> # to the file normally containing kern.* messages (eg,
> # /var/log/kern.log)
> #& stop
>
> Therefore, it looks as though we actually /can/ use the regular syslog
> calls from various xfs utilities and (if rsyslog is up) forward the
> output to a place where support can capture it later.
>

I wanted to join Eric in this, but I didn't know about the filter
rules, thanks for something new to learn. With such a rule, I'm all
for syslog, and I'm attaching my first humble reviewed-by. :-)

Cheers,
Jan

> --D
>
>>
>> I'm inclined to leave this one out of 4.15 for now while I/we think
>> about the big picture here.
>>
>> -Eric
>>
>> > ---
>> >  scrub/common.c |   37 +++++++++++++++++++++++++++++++++++++
>> >  1 file changed, 37 insertions(+)
>> >
>> >
>> > diff --git a/scrub/common.c b/scrub/common.c
>> > index 17c3699..672f286 100644
>> > --- a/scrub/common.c
>> > +++ b/scrub/common.c
>> > @@ -21,6 +21,7 @@
>> >  #include <pthread.h>
>> >  #include <stdbool.h>
>> >  #include <sys/statvfs.h>
>> > +#include <syslog.h>
>> >  #include "platform_defs.h"
>> >  #include "xfs.h"
>> >  #include "xfs_fs.h"
>> > @@ -29,6 +30,8 @@
>> >  #include "common.h"
>> >  #include "progress.h"
>> >
>> > +extern char                *progname;
>> > +
>> >  /*
>> >   * Reporting Status to the Console
>> >   *
>> > @@ -64,6 +67,12 @@ static const char *err_str[] = {
>> >     [S_PREEN]       = "Optimized",
>> >  };
>> >
>> > +static int log_level[] = {
>> > +   [S_ERROR]       = LOG_ERR,
>> > +   [S_WARN]        = LOG_WARNING,
>> > +   [S_INFO]        = LOG_INFO,
>> > +};
>> > +
>> >  /* If stream is a tty, clear to end of line to clean up progress bar. */
>> >  static inline const char *stream_start(FILE *stream)
>> >  {
>> > @@ -73,6 +82,8 @@ static inline const char *stream_start(FILE *stream)
>> >  }
>> >
>> >  /* Print a warning string and some warning text. */
>> > +#define LOG_BUFSZ  4096
>> > +#define LOGNAME_BUFSZ      256
>> >  void
>> >  __str_out(
>> >     struct scrub_ctx        *ctx,
>> > @@ -110,6 +121,32 @@ __str_out(
>> >             va_end(args);
>> >     }
>> >
>> > +   /* If we're running interactively, log the message to syslog too. */
>> > +   if (isatty(fileno(stdin)) && !debug) {
>> > +           char    logname[LOGNAME_BUFSZ];
>> > +
>> > +           snprintf(logname, LOGNAME_BUFSZ, "%s@%s", progname,
>> > +                           ctx->mntpoint);
>> > +           openlog(logname, LOG_PID, LOG_DAEMON);
>> > +
>> > +           if (error) {
>> > +                   syslog(LOG_ERR, "%s: %s: %s.",
>> > +                                   _(err_str[level]), descr,
>> > +                                   strerror_r(error, buf, DESCR_BUFSZ));
>> > +           } else {
>> > +                   char    buf[LOG_BUFSZ];
>> > +                   int     sz;
>> > +
>> > +                   sz = snprintf(buf, LOG_BUFSZ, "%s: %s: ",
>> > +                                   _(err_str[level]), descr);
>> > +                   va_start(args, format);
>> > +                   vsnprintf(buf + sz, LOG_BUFSZ - sz, format, args);
>> > +                   va_end(args);
>> > +                   syslog(log_level[level], "%s", buf);
>> > +           }
>> > +           closelog();
>> > +   }
>> > +
>> >     if (debug)
>> >             fprintf(stream, _(" (%s line %d)"), file, line);
>> >     fprintf(stream, "\n");
>> >
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> >
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
