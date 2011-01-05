Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p05MN1ZE239875 for <xfs@oss.sgi.com>; Wed, 5 Jan 2011 16:23:02 -0600
Subject: Re: [PATCH] repair: warn if running in low memory mode
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1294121563-17150-1-git-send-email-david@fromorbit.com>
References: <1294121563-17150-1-git-send-email-david@fromorbit.com>
Date: Wed, 05 Jan 2011 16:25:07 -0600
Message-ID: <1294266307.2312.87.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, 2011-01-04 at 17:12 +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When checking large filesystems, xfs_repair makes an estimate of how
> much RAM it will need to execute effectively. If the amount of RAM
> is less than this, it reduces the bhash size and turns of
> prefetching, which will substantially slow down the repair process.
> Add a warning that indicates this is happening, along with a
> recommendation of how much RAM repair calculates it needs to run
> with prefetching enabled.

This looks good.

If someone specifies a maximum memory amount using -m,
but that amount exceeds the memory available and/or the
process' address space rlimit, it is silently reduced
to the maximum possible.  That may then be followed by
the "...please increase it..." message, which might be
confusing and possibly annoying.  Maybe a single message
that was a bit more informative would suffice, whether
or not max_mem was specified.

Just a thought.  Your change looks fine.

Reviewed-by: Alex Elder <aelder@sgi.com>



> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  repair/xfs_repair.c |   10 +++++++++-
>  1 files changed, 9 insertions(+), 1 deletions(-)
> 
> diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> index e36eeae..eea1b34 100644
> --- a/repair/xfs_repair.c
> +++ b/repair/xfs_repair.c
> @@ -650,12 +650,20 @@ main(int argc, char **argv)
>  			 * Turn off prefetch and minimise libxfs cache if
>  			 * physical memory is deemed insufficient
>  			 */
> -			if (max_mem_specified)
> +			if (max_mem_specified) {
>  				do_abort(_("Required memory for repair is "
>  					"greater that the maximum specified "
>  					"with the -m option. Please increase "
>  					"it to at least %lu.\n"),
>  					mem_used / 1024);
> +			} else {
> +				do_warn(_("Not enough RAM available for repair "
> +					"to enable prefetching. This will be "
> +					"_slow_.\n"
> +					"You need at least %luMB RAM to run "
> +					"with prefetching enabled."),
> +					mem_used * 1280 / (1024 * 1024));
> +			}
>  			do_prefetch = 0;
>  			libxfs_bhash_size = 64;
>  		} else {



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
