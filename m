Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:51646 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750790AbeAPXwL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 16 Jan 2018 18:52:11 -0500
Subject: Re: [PATCH 18/27] xfs_scrub: warn about normalized Unicode name
 collisions
References: <151520348769.2027.9860697266310422360.stgit@magnolia>
 <151520359869.2027.5097323049467056197.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <0f946ab6-9e41-ede0-d09a-6bcbe3325117@sandeen.net>
Date: Tue, 16 Jan 2018 17:52:10 -0600
MIME-Version: 1.0
In-Reply-To: <151520359869.2027.5097323049467056197.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org


> +/* Print a warning string and whatever error is stored in errno. */
> +void
> +__str_errno_warn(
> +	struct scrub_ctx	*ctx,
> +	const char		*descr,
> +	const char		*file,
> +	int			line)
> +{
> +	char			buf[DESCR_BUFSZ];
> +
> +	pthread_mutex_lock(&ctx->lock);
> +	fprintf(stderr, _("Warning: %s: %s."), descr,
> +			strerror_r(errno, buf, DESCR_BUFSZ));
> +	if (debug)
> +		fprintf(stderr, _(" (%s line %d)"), file, line);
> +	fprintf(stderr, "\n");
> +	ctx->warnings_found++;
> +	pthread_mutex_unlock(&ctx->lock);
> +}
> +

Oh hello, unused-new-6th-printing-variant!  ;)

It took a lot of careful peering at, and scrolling around, to figure
out what all these different __str_ variants do.

Can we collapse all these str_foo_bar things down into a function
that makes logical choices based on what's passed in?  Here's what
I was playing with, see if it actually implements what you want
and if it's any better, and yeah, long lines sorry.

common.h:

void __str_out(struct scrub_ctx *, const char *descr, int level, int error,
		const char *file, int line, const char *format, ...);

#define S_ERROR	0
#define S_WARN	1
#define S_INFO	2

#define str_errno(ctx, str)		__str_out(ctx, str, S_ERROR, errno, __FILE__, __LINE__, NULL)
#define str_error(ctx, str, ...)	__str_out(ctx, str, S_ERROR, 0,     __FILE__, __LINE__, __VA_ARGS__)
#define str_errno_warn(ctx, str)	__str_out(ctx, str, S_WARN,  errno, __FILE__, __LINE__, NULL)
#define str_warn(ctx, str, ...)		__str_out(ctx, str, S_WARN,  0,     __FILE__, __LINE__, __VA_ARGS__)
#define str_info(ctx, str, ...)		__str_out(ctx, str, S_INFO,  0,     __FILE__, __LINE__, __VA_ARGS__)

/* note, could rationalize those names a bit, maybe must str_errno -> str_errno_error? */

common.c:

/* If stdout/stderr is a tty, clear to end of line to clean up progress bar. */
static inline const char *str_start(FILE *stream)
{
	if (stream == stderr)
		return stderr_isatty ? CLEAR_EOL : "";
	else
		return stdout_isatty ? CLEAR_EOL : "";
}

static const char *err_str[] = {
        "Error",
        "Warning",
        "Info",
};

/* Print a warning string and some warning text. */
void
__str_out(
	struct scrub_ctx	*ctx,
	const char		*descr,
	int			level,
	int			error,
	const char		*file,
	int			line,
	const char		*format,
	...)
{
	FILE			*stream = stderr;
	va_list			args;
	char                    buf[DESCR_BUFSZ];

	/* print strerror or format of choice but not both */
	if (error && format)
		abort();

	if (level >= S_INFO)
		stream = stdout;

	pthread_mutex_lock(&ctx->lock);
	if (errno)
		fprintf(stream, _("%s%s: %s: %s."),
				str_start(stream), err_str[level], descr,
				strerror_r(errno, buf, DESCR_BUFSZ));
	else {
		fprintf(stream, _("%s%s: %s: "),
				str_start(stream), err_str[level], descr);

		va_start(args, format);
		vfprintf(stream, format, args);
		va_end(args);
	}

	if (debug)
		fprintf(stream, _(" (%s line %d)"), file, line);
	fprintf(stream, "\n");
	if (stream == stdout)
		fflush(stream);

	if (errno)	/* A syscall failed */
		ctx->runtime_errors++;
	else if (level == S_ERROR)
		ctx->errors_found++;
	else if (level == S_WARN)
		ctx->warnings_found++;

	pthread_mutex_unlock(&ctx->lock);
}
