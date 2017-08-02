Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49538 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752432AbdHBJRz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 2 Aug 2017 05:17:55 -0400
Date: Wed, 2 Aug 2017 11:17:49 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH v2 3/7] xfs_db: fix metadump redirection (again)
Message-ID: <20170802091749.rjjdktkcuqqwcxas@hades.localdomain>
References: <150153520589.26081.8786864874176090813.stgit@magnolia>
 <150153522749.26081.13898276114157159134.stgit@magnolia>
 <20170801162333.GI4477@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170801162333.GI4477@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Tue, Aug 01, 2017 at 09:23:33AM -0700, Darrick J. Wong wrote:
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
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v2: fix STDOUT_FILENO usage

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  db/metadump.c |   47 ++++++++++++++++++++++++++++++++++++-----------
>  1 file changed, 36 insertions(+), 11 deletions(-)
> 
> diff --git a/db/metadump.c b/db/metadump.c
> index be2e712..6a23d58 100644
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
> @@ -2750,7 +2751,8 @@ metadump_f(
>  	xfs_agnumber_t	agno;
>  	int		c;
>  	int		start_iocur_sp;
> -	bool		stdout_metadump = false;
> +	int		outfd = -1;
> +	int		ret;
>  	char		*p;
>  
>  	exitcode = 1;
> @@ -2870,16 +2872,35 @@ metadump_f(
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
> +			dup2(outfd, STDOUT_FILENO);
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
> @@ -2907,15 +2928,19 @@ metadump_f(
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

-- 
Carlos
