Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41534 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751606AbeAPX5N (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 16 Jan 2018 18:57:13 -0500
Subject: Re: [PATCH 18/27] xfs_scrub: warn about normalized Unicode name
 collisions
References: <151520348769.2027.9860697266310422360.stgit@magnolia>
 <151520359869.2027.5097323049467056197.stgit@magnolia>
 <0f946ab6-9e41-ede0-d09a-6bcbe3325117@sandeen.net>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <b43018bd-bb80-ddf1-048e-b25dd09c002c@redhat.com>
Date: Tue, 16 Jan 2018 17:57:10 -0600
MIME-Version: 1.0
In-Reply-To: <0f946ab6-9e41-ede0-d09a-6bcbe3325117@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 1/16/18 5:52 PM, Eric Sandeen wrote:

...

> /* Print a warning string and some warning text. */
> void
> __str_out(
> 	struct scrub_ctx	*ctx,
> 	const char		*descr,
> 	int			level,
> 	int			error,
> 	const char		*file,
> 	int			line,
> 	const char		*format,
> 	...)
> {
> 	FILE			*stream = stderr;
> 	va_list			args;
> 	char                    buf[DESCR_BUFSZ];
> 
> 	/* print strerror or format of choice but not both */
> 	if (error && format)
> 		abort();
> 
> 	if (level >= S_INFO)
> 		stream = stdout;
> 
> 	pthread_mutex_lock(&ctx->lock);

oops this and every other "errno" below should be error, sorry:

> 	if (errno)
> 		fprintf(stream, _("%s%s: %s: %s."),
> 				str_start(stream), err_str[level], descr,
> 				strerror_r(errno, buf, DESCR_BUFSZ));

-Eric
