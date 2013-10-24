Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 286537F4E
	for <xfs@oss.sgi.com>; Thu, 24 Oct 2013 05:40:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 92B11AC002
	for <xfs@oss.sgi.com>; Thu, 24 Oct 2013 03:40:46 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	Ruqo6cCDJ8VNXA8K for <xfs@oss.sgi.com>;
	Thu, 24 Oct 2013 03:40:44 -0700 (PDT)
Date: Thu, 24 Oct 2013 21:40:42 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: src/feature.c: print a number of online CPUs
Message-ID: <20131024104042.GT2797@dastard>
References: <20131023213152.GP2797@dastard>
	<1382604998-11037-1-git-send-email-stanislav.kholmanskikh@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1382604998-11037-1-git-send-email-stanislav.kholmanskikh@oracle.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Stanislav Kholmanskikh <stanislav.kholmanskikh@oracle.com>
Cc: vasily.isaenko@oracle.com, xfs@oss.sgi.com

On Thu, Oct 24, 2013 at 12:56:38PM +0400, Stanislav Kholmanskikh wrote:
> For this purpose we use sysconf() as it is the
> preferred platform neutral interface for getting this
> sort of information.
> 
> Based on Dave Chinner proposal.
> 
> Signed-off-by: Stanislav Kholmanskikh <stanislav.kholmanskikh@oracle.com>
> ---
>  src/feature.c |   31 ++++++++++++++++++++++++++++---
>  1 files changed, 28 insertions(+), 3 deletions(-)
> 
> diff --git a/src/feature.c b/src/feature.c
> index 2619ca5..a3ce9b8 100644
> --- a/src/feature.c
> +++ b/src/feature.c
> @@ -30,6 +30,7 @@
>   * Return code: 0 is true, anything else is error/not supported
>   *
>   * Test for machine features
> + *   -o  report a number of online cpus
>   *   -s  report pagesize
>   *   -w  report bits per long
>   */
> @@ -39,6 +40,7 @@
>  #include <sys/quota.h>
>  #include <sys/resource.h>
>  #include <signal.h>
> +#include <unistd.h>
>  
>  #ifdef HAVE_XFS_XQM_H
>  #include <xfs/xqm.h>
> @@ -64,7 +66,7 @@ usage(void)
>  	fprintf(stderr, "Usage: feature [-v] -<q|u|g|p|U|G|P> <filesystem>\n");
>  	fprintf(stderr, "       feature [-v] -c <file>\n");
>  	fprintf(stderr, "       feature [-v] -t <file>\n");
> -	fprintf(stderr, "       feature -s | -w\n");
> +	fprintf(stderr, "       feature -o | -s | -w\n");
>  	exit(1);
>  }
>  
> @@ -212,9 +214,10 @@ main(int argc, char **argv)
>  	int	uflag = 0;
>  	int	Uflag = 0;
>  	int	wflag = 0;
> +	int	oflag = 0;
>  	char	*fs = NULL;
>  
> -	while ((c = getopt(argc, argv, "ctgGpPqsuUvw")) != EOF) {
> +	while ((c = getopt(argc, argv, "ctgGopPqsuUvw")) != EOF) {
>  		switch (c) {
>  		case 'c':
>  			cflag++;
> @@ -228,6 +231,9 @@ main(int argc, char **argv)
>  		case 'G':
>  			Gflag++;
>  			break;
> +		case 'o':
> +			oflag++;
> +			break;
>  		case 'p':
>  			pflag++;
>  			break;
> @@ -262,7 +268,7 @@ main(int argc, char **argv)
>  		if (optind != argc-1)	/* need a device */
>  			usage();
>  		fs = argv[argc-1];
> -	} else if (wflag || sflag) {
> +	} else if (wflag || sflag || oflag) {
>  		if (optind != argc)
>  			usage();
>  	} else 
> @@ -306,6 +312,25 @@ bozo!
>  #endif
>  		exit(0);
>  	}
> +	if (oflag) {
> +		long ncpus;
> +
> +#if defined(_SC_NPROCESSORS_ONLN)
> +		/* Linux */
> +		ncpus = sysconf(_SC_NPROCESSORS_ONLN);
> +#elif defined(_SC_NPROC_ONLN)
> +		/* IRIX */
> +		ncpus = sysconf(_SC_NPROC_ONLN);
> +#else
> +		ncpus = 0;
> +#endif
> +		if (ncpus == -1)
> +			ncpus = 0;
> +
> +		printf("%ld\n", ncpus);

Actually, I'd say we shoul default to 1 cpu if we can't get the
number of CPUs. Clearly we have at least one if we can run this
code. :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
