Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:43658 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726525AbfEUTSo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 21 May 2019 15:18:44 -0400
Subject: Re: [PATCH 09/12] xfs_scrub: fix background-mode sleep throttling
References: <155839420081.68606.4573219764134939943.stgit@magnolia>
 <155839425742.68606.18377767804648563349.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <cd4cdc09-8cb2-e6dc-ec5b-95894a4faeb7@sandeen.net>
Date: Tue, 21 May 2019 14:18:43 -0500
MIME-Version: 1.0
In-Reply-To: <155839425742.68606.18377767804648563349.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org


On 5/20/19 6:17 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The comment preceding background_sleep() is wrong -- the function sleeps
> 100us, not 100ms, for every '-b' passed in after the first one.  This is
> really not obvious from the magic numbers, so fix the comment and use
> symbolic constants for easier reading.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Ok, looks like man page was already correct.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  scrub/common.c |   12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> 
> diff --git a/scrub/common.c b/scrub/common.c
> index c877c7c8..1cd2b7ba 100644
> --- a/scrub/common.c
> +++ b/scrub/common.c
> @@ -253,21 +253,23 @@ scrub_nproc_workqueue(
>  }
>  
>  /*
> - * Sleep for 100ms * however many -b we got past the initial one.
> + * Sleep for 100us * however many -b we got past the initial one.
>   * This is an (albeit clumsy) way to throttle scrub activity.
>   */
> +#define NSEC_PER_SEC	1000000000ULL
> +#define NSEC_PER_USEC	1000ULL
>  void
>  background_sleep(void)
>  {
> -	unsigned long long	time;
> +	unsigned long long	time_ns;
>  	struct timespec		tv;
>  
>  	if (bg_mode < 2)
>  		return;
>  
> -	time = 100000ULL * (bg_mode - 1);
> -	tv.tv_sec = time / 1000000;
> -	tv.tv_nsec = time % 1000000;
> +	time_ns =  100 * NSEC_PER_USEC * (bg_mode - 1);
> +	tv.tv_sec = time_ns / NSEC_PER_SEC;
> +	tv.tv_nsec = time_ns % NSEC_PER_SEC;
>  	nanosleep(&tv, NULL);
>  }
>  
> 
