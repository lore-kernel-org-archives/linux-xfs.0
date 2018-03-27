Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:50398 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750897AbeC0S2t (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Mar 2018 14:28:49 -0400
Subject: Re: [PATCH] xfs_io: fix operation time reporting
References: <20180327072640.10213-1-david@fromorbit.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <fc042a0e-ee58-c290-f5a1-1985108f1517@sandeen.net>
Date: Tue, 27 Mar 2018 13:28:48 -0500
MIME-Version: 1.0
In-Reply-To: <20180327072640.10213-1-david@fromorbit.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org

On 3/27/18 2:26 AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Currently the 100th/sec units always report zero, such as:
> 
> 32 MiB, 8192 ops; 0:00:21.00 (1.476 MiB/sec and 377.9260 ops/sec)
>                           ^^
> This is incorrect.
> 
> Fix it by reporting milliseconds to be consistent with other
> time recording utilities. This means we can just use simple
> integer divsion to implement this and remove all the confusion
> around calculating non-standard units of time.
> 
> Also fix the non-verbose, sub-second time output printed 4
> significant digits but only calculated the time to hundreths of a
> second. Again, just use milliseconds for it.
> 
> Signed-Off-By: Dave Chinner <dchinner@redhat.com>

Thanks for the update.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  libxcmd/input.c | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/libxcmd/input.c b/libxcmd/input.c
> index 441bb2fbbf34..4830494eb173 100644
> --- a/libxcmd/input.c
> +++ b/libxcmd/input.c
> @@ -154,9 +154,10 @@ tdiv(double value, struct timeval tv)
>  	return value / ((double)tv.tv_sec + ((double)tv.tv_usec / 1000000.0));
>  }
>  
> -#define HOURS(sec)	((sec) / (60 * 60))
> -#define MINUTES(sec)	(((sec) % (60 * 60)) / 60)
> -#define SECONDS(sec)	((sec) % 60)
> +#define HOURS(sec)		((sec) / (60 * 60))
> +#define MINUTES(sec)		(((sec) % (60 * 60)) / 60)
> +#define SECONDS(sec)		((sec) % 60)
> +#define MILLISECONDS(usec)	((usec) / 1000)
>  
>  void
>  timestr(
> @@ -165,27 +166,26 @@ timestr(
>  	size_t		size,
>  	int		format)
>  {
> -	double		usec = (double)tv->tv_usec / 1000000.0;
> -
>  	if (format & TERSE_FIXED_TIME) {
>  		if (!HOURS(tv->tv_sec)) {
> -			snprintf(ts, size, "%u:%02u.%02u",
> +			snprintf(ts, size, "%u:%02u.%03u",
>  				(unsigned int) MINUTES(tv->tv_sec),
>  				(unsigned int) SECONDS(tv->tv_sec),
> -				(unsigned int) usec * 100);
> +				(unsigned int) MILLISECONDS(tv->tv_usec));
>  			return;
>  		}
>  		format |= VERBOSE_FIXED_TIME;	/* fallback if hours needed */
>  	}
>  
>  	if ((format & VERBOSE_FIXED_TIME) || tv->tv_sec) {
> -		snprintf(ts, size, "%u:%02u:%02u.%02u",
> +		snprintf(ts, size, "%u:%02u:%02u.%03u",
>  			(unsigned int) HOURS(tv->tv_sec),
>  			(unsigned int) MINUTES(tv->tv_sec),
>  			(unsigned int) SECONDS(tv->tv_sec),
> -			(unsigned int) usec * 100);
> +			(unsigned int) MILLISECONDS(tv->tv_usec));
>  	} else {
> -		snprintf(ts, size, "0.%04u sec", (unsigned int) usec * 10000);
> +		snprintf(ts, size, "0.%03u sec",
> +			(unsigned int) MILLISECONDS(tv->tv_usec));
>  	}
>  }
>  
> 
