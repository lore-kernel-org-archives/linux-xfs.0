Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:60028 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752156AbdGYQcY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 Jul 2017 12:32:24 -0400
Subject: Re: [PATCH] xfs_db: fix metadump redirection (again)
References: <20170725162740.GP4352@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <917a7bd4-fe2d-3839-f20e-ec44b8291044@sandeen.net>
Date: Tue, 25 Jul 2017 11:32:23 -0500
MIME-Version: 1.0
In-Reply-To: <20170725162740.GP4352@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>, anarchy@gentoo.org

On 07/25/2017 11:27 AM, Darrick J. Wong wrote:
> In patch 4944defad4 ("xfs_db: redirect printfs when metadumping to
> stdout"), we solved the problem of xfs_db printfs ending up in the
> metadump stream by reassigning stdout for the duration of a stdout
> metadump.  Unfortunately, musl doesn't allow stdout to be reassigned (in
> their view "extern FILE *stdout" means "extern FILE * const stdout"), so
> we abandon the old approach in favor of playing games with dup() to
> switch the raw file descriptors.
> 
> While we're at it, fix a regression where an unconverted outf test
> allows progress info to end up in the metadump stream.

"while we're at it" usually indicates the need for a separate patch ;)

So what if we just converted dbprintf to do fprintf, with the destination
held in some global variable that metadump can change?   Seems like that
might be less tricksy, and xfs_db is no stranger to globals.

there are about 5 bare printfs in xfs_db, but none should be encountered
during a metadump (well ... maybe the one in set_cur).

-eric

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  db/metadump.c |   47 ++++++++++++++++++++++++++++++++++++-----------
>  1 file changed, 36 insertions(+), 11 deletions(-)
> 
> diff --git a/db/metadump.c b/db/metadump.c
> index b58acef..8cdcb37 100644
> --- a/db/metadump.c
> +++ b/db/metadump.c
> @@ -78,6 +78,7 @@ static int		obfuscate = 1;
>  static int		zero_stale_data = 1;
>  static int		show_warnings = 0;
>  static int		progress_since_warning = 0;
> +static bool		stdout_metadump;
>  
>  void
>  metadump_init(void)
> @@ -137,7 +138,7 @@ print_progress(const char *fmt, ...)
>  	va_end(ap);
>  	buf[sizeof(buf)-1] = '\0';
>  
> -	f = (outf == stdout) ? stderr : stdout;
> +	f = stdout_metadump ? stderr : stdout;
>  	fprintf(f, "\r%-59s", buf);
>  	fflush(f);
>  	progress_since_warning = 1;
> @@ -2874,7 +2875,8 @@ metadump_f(
>  	xfs_agnumber_t	agno;
>  	int		c;
>  	int		start_iocur_sp;
> -	bool		stdout_metadump = false;
> +	int		outfd = -1;
> +	int		ret;
>  	char		*p;
>  
>  	exitcode = 1;
> @@ -2994,16 +2996,35 @@ metadump_f(
>  		 * metadump operation so that dbprintf and other messages
>  		 * are sent to the console instead of polluting the
>  		 * metadump stream.
> +		 *
> +		 * We get to do this the hard way because musl doesn't
> +		 * allow reassignment of stdout.
>  		 */
> -		outf = stdout;
> -		stdout = stderr;
> +		fflush(stdout);
> +		outfd = dup(STDOUT_FILENO);
> +		if (outfd < 0) {
> +			perror("opening dump stream");
> +			goto out;
> +		}
> +		ret = dup2(STDERR_FILENO, STDOUT_FILENO);
> +		if (ret < 0) {
> +			perror("redirecting stdout");
> +			close(outfd);
> +			goto out;
> +		}
> +		outf = fdopen(outfd, "a");
> +		if (outf == NULL) {
> +			fprintf(stderr, "cannot create dump stream\n");
> +			dup2(outfd, 1);
> +			close(outfd);
> +			goto out;
> +		}
>  		stdout_metadump = true;
>  	} else {
>  		outf = fopen(argv[optind], "wb");
>  		if (outf == NULL) {
>  			print_warning("cannot create dump file");
> -			free(metablock);
> -			return 0;
> +			goto out;
>  		}
>  	}
>  
> @@ -3031,15 +3052,19 @@ metadump_f(
>  	if (progress_since_warning)
>  		fputc('\n', stdout_metadump ? stderr : stdout);
>  
> -	if (stdout_metadump)
> -		stdout = outf;
> -	else
> -		fclose(outf);
> +	if (stdout_metadump) {
> +		fflush(outf);
> +		fflush(stdout);
> +		ret = dup2(outfd, STDOUT_FILENO);
> +		if (ret < 0)
> +			perror("un-redirecting stdout");
> +	}
> +	fclose(outf);
>  
>  	/* cleanup iocur stack */
>  	while (iocur_sp > start_iocur_sp)
>  		pop_cur();
> -
> +out:
>  	free(metablock);
>  
>  	return 0;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
