Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36865 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751012AbdGOAhm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 14 Jul 2017 20:37:42 -0400
Subject: Re: [PATCH] xfs_db: redirect printfs when metadumping to stdout
References: <20170714233032.GC4224@magnolia>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <5f68282e-8eb6-8bc8-ecc1-e38a51c842a6@redhat.com>
Date: Fri, 14 Jul 2017 19:37:41 -0500
MIME-Version: 1.0
In-Reply-To: <20170714233032.GC4224@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>, David Shaw <dshaw@jabberwocky.com>

On 07/14/2017 06:30 PM, Darrick J. Wong wrote:
> If we're metadumping to stdout, we don't want xfs_db's various dbprintf
> statements dumping to stdout because that'll corrupt the metadump.
> Therefore, let outf point to the existing stdout and redirect stdout to
> stderr for the duration of the dump operation.
> 
> Reported-by: David Shaw <dshaw@jabberwocky.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  db/metadump.c |    9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/db/metadump.c b/db/metadump.c
> index e046f60..e6e153d 100644
> --- a/db/metadump.c
> +++ b/db/metadump.c
> @@ -2874,6 +2874,7 @@ metadump_f(
>  	xfs_agnumber_t	agno;
>  	int		c;
>  	int		start_iocur_sp;
> +	bool		stdout_metadump = false;
>  	char		*p;
>  
>  	exitcode = 1;
> @@ -2989,6 +2990,8 @@ metadump_f(
>  			return 0;
>  		}
>  		outf = stdout;
> +		stdout = stderr;
> +		stdout_metadump = true;

Ok, I ... guess?  xfs_metadump already takes pains to
print to stderr as appropriate; see print_warning(), and comments
about where "wornings" should go.

But in this case I guess it's the guts of db / dbprintf that caused the
problems, right?  ... yup you said that in the commit message.

I suppose a comment:

/* Move stdout to stderr so thta xfs_db warnings don't pollute metadump stream */

or something would help the future reader know why you had to do this.

it feels a little hacky but I don't really see a particularly better way I guess.

-Eric

>  	} else {
>  		outf = fopen(argv[optind], "wb");
>  		if (outf == NULL) {
> @@ -3020,9 +3023,11 @@ metadump_f(
>  		exitcode = write_index() < 0;
>  
>  	if (progress_since_warning)
> -		fputc('\n', (outf == stdout) ? stderr : stdout);
> +		fputc('\n', stdout_metadump ? stderr : stdout);
>  
> -	if (outf != stdout)
> +	if (stdout_metadump)
> +		stdout = outf;
> +	else
>  		fclose(outf);
>  
>  	/* cleanup iocur stack */
> 

