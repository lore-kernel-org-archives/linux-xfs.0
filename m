Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:45394 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726719AbfCODJX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Mar 2019 23:09:23 -0400
Subject: Re: [PATCH 12/36] xfs_scrub: rename the global nr_threads
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
 <155259750338.31886.12656336161988116486.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <bf047248-04ef-37ee-1399-b45373278e1f@sandeen.net>
Date: Thu, 14 Mar 2019 22:09:21 -0500
MIME-Version: 1.0
In-Reply-To: <155259750338.31886.12656336161988116486.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 3/14/19 4:05 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Various functions have nr_threads local variables that shadow the global
> one.  Since the global one forces the number of threads we use, change
> its name to remove this ambiguity and reflect what it really does.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  scrub/common.c    |    4 ++--
>  scrub/disk.c      |    4 ++--
>  scrub/xfs_scrub.c |    6 +++---
>  scrub/xfs_scrub.h |    2 +-
>  4 files changed, 8 insertions(+), 8 deletions(-)
> 
> 
> diff --git a/scrub/common.c b/scrub/common.c
> index 78afc4bf..c877c7c8 100644
> --- a/scrub/common.c
> +++ b/scrub/common.c
> @@ -231,8 +231,8 @@ unsigned int
>  scrub_nproc(
>  	struct scrub_ctx	*ctx)
>  {
> -	if (nr_threads)
> -		return nr_threads;
> +	if (force_nr_threads)
> +		return force_nr_threads;
>  	return ctx->nr_io_threads;
>  }
>  
> diff --git a/scrub/disk.c b/scrub/disk.c
> index 7daa508e..dd109533 100644
> --- a/scrub/disk.c
> +++ b/scrub/disk.c
> @@ -75,8 +75,8 @@ unsigned int
>  disk_heads(
>  	struct disk		*disk)
>  {
> -	if (nr_threads)
> -		return nr_threads;
> +	if (force_nr_threads)
> +		return force_nr_threads;
>  	return __disk_heads(disk);
>  }
>  
> diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
> index b8138000..71fc274f 100644
> --- a/scrub/xfs_scrub.c
> +++ b/scrub/xfs_scrub.c
> @@ -133,7 +133,7 @@ unsigned int			bg_mode;
>  int				nproc;
>  
>  /* Number of threads we're allowed to use. */
> -unsigned int			nr_threads;
> +unsigned int			force_nr_threads;
>  
>  /* Verbosity; higher values print more information. */
>  bool				verbose;
> @@ -589,7 +589,7 @@ main(
>  			}
>  			break;
>  		case 'b':
> -			nr_threads = 1;
> +			force_nr_threads = 1;
>  			bg_mode++;
>  			break;
>  		case 'C':
> @@ -659,7 +659,7 @@ main(
>  			perror("nr_threads");
>  			usage();
>  		}
> -		nr_threads = x;
> +		force_nr_threads = x;
>  	}
>  
>  	if (optind != argc - 1)
> diff --git a/scrub/xfs_scrub.h b/scrub/xfs_scrub.h
> index a961d8fd..a459e4b5 100644
> --- a/scrub/xfs_scrub.h
> +++ b/scrub/xfs_scrub.h
> @@ -10,7 +10,7 @@ extern char *progname;
>  
>  #define _PATH_PROC_MOUNTS	"/proc/mounts"
>  
> -extern unsigned int		nr_threads;
> +extern unsigned int		force_nr_threads;
>  extern unsigned int		bg_mode;
>  extern unsigned int		debug;
>  extern int			nproc;
> 
