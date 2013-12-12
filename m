Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0502329E25
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 12:59:39 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B3ABD8F8052
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 10:59:38 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ns81b1qJ3GXpMaH1 for
	<xfs@oss.sgi.com>; Thu, 12 Dec 2013 10:59:32 -0800 (PST)
Message-ID: <52AA0792.6090606@redhat.com>
Date: Thu, 12 Dec 2013 13:59:30 -0500
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH 5/5] repair: limit auto-striding concurrency apprpriately
References: <1386832945-19763-1-git-send-email-david@fromorbit.com>
	<1386832945-19763-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1386832945-19763-6-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com

On 12/12/2013 02:22 AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> It's possible to have filesystems with hundreds of AGs on systems
> with little concurrency and resources. In this case, we can easily
> exhaust memory and fail to create threads and have all sorts of
> interesting problems.
> 
> xfs/250 can cause this to occur, with failures like:
> 
>         - agno = 707
>         - agno = 692
> fatal error -- cannot create worker threads, error = [11] Resource temporarily unavailable
> 
> And this:
> 
>         - agno = 484
>         - agno = 782
> failed to create prefetch thread: Resource temporarily unavailable
> 
> Because it's trying to create more threads than a poor little 512MB
> single CPU ia32 box can handle.
> 
> So, limit concurrency to a maximum of numcpus * 8 to prevent this.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  include/libxfs.h    |  1 +
>  libxfs/init.h       |  1 -
>  repair/xfs_repair.c | 18 +++++++++++++++++-
>  3 files changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/include/libxfs.h b/include/libxfs.h
> index 4bf331c..39e3d85 100644
> --- a/include/libxfs.h
> +++ b/include/libxfs.h
> @@ -144,6 +144,7 @@ extern void	libxfs_device_close (dev_t);
>  extern int	libxfs_device_alignment (void);
>  extern void	libxfs_report(FILE *);
>  extern void	platform_findsizes(char *path, int fd, long long *sz, int *bsz);
> +extern int	platform_nproc(void);
>  
>  /* check or write log footer: specify device, log size in blocks & uuid */
>  typedef xfs_caddr_t (libxfs_get_block_t)(xfs_caddr_t, int, void *);
> diff --git a/libxfs/init.h b/libxfs/init.h
> index f0b8cb6..112febb 100644
> --- a/libxfs/init.h
> +++ b/libxfs/init.h
> @@ -31,7 +31,6 @@ extern char *platform_findrawpath (char *path);
>  extern char *platform_findblockpath (char *path);
>  extern int platform_direct_blockdev (void);
>  extern int platform_align_blockdev (void);
> -extern int platform_nproc(void);
>  extern unsigned long platform_physmem(void);	/* in kilobytes */
>  extern int platform_has_uuid;
>  
> diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> index 7beffcb..0d006ae 100644
> --- a/repair/xfs_repair.c
> +++ b/repair/xfs_repair.c
> @@ -627,13 +627,29 @@ main(int argc, char **argv)
>  	 * to target these for an increase in thread count. Hence a stride value
>  	 * of 15 is chosen to ensure we get at least 2 AGs being scanned at once
>  	 * on such filesystems.
> +	 *
> +	 * Limit the maximum thread count based on the available CPU power that
> +	 * is available. If we use too many threads, we might run out of memory
> +	 * and CPU power before we run out of IO concurrency.
>  	 */
>  	if (!ag_stride && glob_agcount >= 16 && do_prefetch)
>  		ag_stride = 15;
>  
>  	if (ag_stride) {
> +		int max_threads = platform_nproc() * 8;
> +
>  		thread_count = (glob_agcount + ag_stride - 1) / ag_stride;
> -		thread_init();
> +		while (thread_count > max_threads) {
> +			ag_stride *= 2;
> +			thread_count = (glob_agcount + ag_stride - 1) /
> +								ag_stride;
> +		}
> +		if (thread_count > 0)
> +			thread_init();
> +		else {
> +			thread_count = 1;
> +			ag_stride = 0;
> +		}
>  	}
>  
>  	if (ag_stride && report_interval) {
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
