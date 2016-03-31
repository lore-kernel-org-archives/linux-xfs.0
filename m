Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E45187CA1
	for <xfs@oss.sgi.com>; Thu, 31 Mar 2016 15:25:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9C6908F804C
	for <xfs@oss.sgi.com>; Thu, 31 Mar 2016 13:25:40 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id XqbAAHqghFMU3HFa for <xfs@oss.sgi.com>;
	Thu, 31 Mar 2016 13:25:33 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 445FE56B
	for <xfs@oss.sgi.com>; Thu, 31 Mar 2016 15:25:33 -0500 (CDT)
Subject: Re: [PATCH 01/19] xfsprogs: use common code for multi-disk detection
References: <1458818136-56043-1-git-send-email-jtulak@redhat.com>
	<1458818136-56043-2-git-send-email-jtulak@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56FD87BC.5070805@sandeen.net>
Date: Thu, 31 Mar 2016 15:25:32 -0500
MIME-Version: 1.0
In-Reply-To: <1458818136-56043-2-git-send-email-jtulak@redhat.com>
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
To: xfs@oss.sgi.com

On 3/24/16 6:15 AM, jtulak@redhat.com wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> CHANGELOG:
> o Remove nonexistent headers from LIBHFILES in include/Makefile
> o Remove a useless assignment which was immediately overwritten
>   on the next line.
> o Rename include/xfs_mkfs.h global header to include/xfs_multidisk.h,
>   because we need it just for multidisk configuration
> o Fix AG count for size thresholds to keep consistency
> 
> Both xfs_repair and mkfs.xfs need to agree on what is a "multidisk:
> configuration - mkfs for determining the AG count of the filesystem,
> repair for determining how to automatically parallelise it's
> execution. This requires a bunch of common defines that both mkfs
> and reapir need to share.
> 
> In fact, most of the defines in xfs_mkfs.h could be shared with
> other programs (i.e. all the defaults mkfs uses) and so it is
> simplest to move xfs_mkfs.h to the shared include directory and add
> the new defines to it directly.

Minor comment stuff below, otherwise seems ok.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

and feel free to add that if you make the suggested changes, too.

> diff --git a/include/xfs_multidisk.h b/include/xfs_multidisk.h
> new file mode 100644
> index 0000000..4006a01
> --- /dev/null
> +++ b/include/xfs_multidisk.h


<big snip this is mostly just a file rename, but...>

> +/*
> + * These values define what we consider a "multi-disk" filesystem. That is, a
> + * filesystem that is likely to be made up of multiple devices, and hence have
> + * some level of parallelism avoid to it at the IO level.

"avoid to it?"  Maybe "available to it?"

...

> @@ -664,43 +664,45 @@ calc_default_ag_geometry(
>  	}
>  
>  	/*
> -	 * For the remainder we choose an AG size based on the
> -	 * number of data blocks available, trying to keep the
> -	 * number of AGs relatively small (especially compared
> -	 * to the original algorithm).  AG count is calculated
> -	 * based on the preferred AG size, not vice-versa - the
> -	 * count can be increased by growfs, so prefer to use
> -	 * smaller counts at mkfs time.
> -	 *
> -	 * For a single underlying storage device between 128MB
> -	 * and 4TB in size, just use 4 AGs, otherwise scale up
> -	 * smoothly between min/max AG sizes.
> +	 * For a single underlying storage device between 128MB and 4TB in size
> +	 * just use 4 AGs and scale up smoothly between min/max AG sizes.

I guess a comment about the *first* >= 4T case might make this more
clear; it's a little odd to document only 1 of the 2 cases below.

Maybe:

+	 * For a single underlying storage device over 4TB in size
+	 * use the maximum AG size.  Between 128MB and 4TB, just use
+	 * 4 AGs and scale up smoothly between min/max AG sizes.

>  	 */
> -
> -	if (!multidisk && dblocks >= MEGABYTES(128, blocklog)) {
> +	if (!multidisk) {
>  		if (dblocks >= TERABYTES(4, blocklog)) {
>  			blocks = XFS_AG_MAX_BLOCKS(blocklog);
>  			goto done;
> +		} else if (dblocks >= MEGABYTES(128, blocklog)) {
> +			shift = XFS_NOMULTIDISK_AGLOG;
> +			goto calc_blocks;
>  		}
> -		shift = 2;
> -	} else if (dblocks > GIGABYTES(512, blocklog))
> -		shift = 5;
> -	else if (dblocks > GIGABYTES(8, blocklog))
> -		shift = 4;
> -	else if (dblocks >= MEGABYTES(128, blocklog))
> -		shift = 3;
> -	else if (dblocks >= MEGABYTES(64, blocklog))
> -		shift = 2;
> -	else if (dblocks >= MEGABYTES(32, blocklog))
> -		shift = 1;
> -	else
> -		shift = 0;
> +	}
> +
> +	/*
> +	 * For the multidisk configs we choose an AG count based on the number
> +	 * of data blocks available, trying to keep the number of AGs higher
> +	 * than the single disk configurations. This makes the assumption that
> +	 * larger filesystems have more parallelism available to them.
> +	 */
> +	shift = XFS_MULTIDISK_AGLOG;
> +	if (dblocks <= GIGABYTES(512, blocklog))
> +		shift--;
> +	if (dblocks <= GIGABYTES(8, blocklog))
> +		shift--;
> +	if (dblocks < MEGABYTES(128, blocklog))
> +		shift--;
> +	if (dblocks < MEGABYTES(64, blocklog))
> +		shift--;
> +	if (dblocks < MEGABYTES(32, blocklog))
> +		shift--;
> +
>  	/*
>  	 * If dblocks is not evenly divisible by the number of
>  	 * desired AGs, round "blocks" up so we don't lose the
>  	 * last bit of the filesystem. The same principle applies
>  	 * to the AG count, so we don't lose the last AG!
>  	 */
> +calc_blocks:
> +	ASSERT(shift >= 0 && shift <= XFS_MULTIDISK_AGLOG);
>  	blocks = dblocks >> shift;
>  	if (dblocks & xfs_mask32lo(shift)) {
>  		if (blocks < XFS_AG_MAX_BLOCKS(blocklog))


> diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> index 5d5f3aa..9d91f2d 100644
> --- a/repair/xfs_repair.c
> +++ b/repair/xfs_repair.c
> @@ -19,6 +19,7 @@
>  #include "libxfs.h"
>  #include "libxlog.h"
>  #include <sys/resource.h>
> +#include "xfs_multidisk.h"
>  #include "avl.h"
>  #include "avl64.h"
>  #include "globals.h"
> @@ -589,6 +590,33 @@ format_log_max_lsn(
>  			 XLOG_FMT, new_cycle, true);
>  }
>  
> +/*
> + * mkfs increases the AG count for "multidisk" configurations, we want
> + * to target these for an increase in thread count. Hence check the superlock
> + * geometry information to determine if mkfs considered this a multidisk
> + * configuration.
> + */
> +static bool
> +is_multidisk_filesystem(
> +	struct xfs_mount	*mp)
> +{
> +	struct xfs_sb		*sbp = &mp->m_sb;
> +
> +	/* High agcount filesystems are always considered "multidisk" */
> +	if (sbp->sb_agcount >= XFS_MULTIDISK_AGCOUNT)
> +		return true;
> +
> +	/*
> +	 * If it doesn't have a sunit/swidth, mkfs didn't consider it a
> +	 * multi-disk array, so we don't either.
> +	 */
> +	if (!sbp->sb_unit)
> +		return false;
> +
> +	ASSERT(sbp->sb_width);
> +	return true;
> +}
> +
>  int
>  main(int argc, char **argv)
>  {
> @@ -729,9 +757,21 @@ main(int argc, char **argv)
>  	 * threads/CPU as this is enough threads to saturate a CPU on fast
>  	 * devices, yet few enough that it will saturate but won't overload slow
>  	 * devices.
> +	 *
> +	 * Multidisk filesystems can handle more IO parallelism so we should try
> +	 * to process multiple AGs at a time in such a configuration to try to
> +	 * saturate the underlying storage and speed the repair process. Only do
> +	 * this if prefetching is enabled.
>  	 */
> -	if (!ag_stride && glob_agcount >= 16 && do_prefetch)
> -		ag_stride = 15;
> +	if (!ag_stride && do_prefetch && is_multidisk_filesystem(mp)) {
> +		/*
> +		 * For small agcount multidisk systems, just double the
> +		 * parallelism. For larger AG count filesystems (32 and above)
> +		 * use more parallelism, and linearly increase the parallelism
> +		 * with the number of AGs.
> +		 */
> +		ag_stride = min(glob_agcount, XFS_MULTIDISK_AGCOUNT / 2) - 1;
> +	}
>  
>  	if (ag_stride) {
>  		int max_threads = platform_nproc() * 8;
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
