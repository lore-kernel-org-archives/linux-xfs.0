Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl6.internode.on.net ([150.101.137.136]:14769 "EHLO
        ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726236AbeJYINg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Oct 2018 04:13:36 -0400
Date: Thu, 25 Oct 2018 10:43:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs_repair: kick processing thread if ra_count is at
 limit
Message-ID: <20181024234326.GC19305@dastard>
References: <6e32c568-731b-4e19-5e54-5e44aa129f37@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e32c568-731b-4e19-5e54-5e44aa129f37@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Wed, Oct 24, 2018 at 06:11:46PM -0500, Eric Sandeen wrote:
> Zorro hit an xfs_repair hang on a 500T filesystem where
> all the prefetch threads were sleeping and nothing progressed.
> 
> The problem is that if every buffer we tried to read ahead in
> phase6 was already up to date, pf_start_io_workers has no effect;
> there is no io to do, and the sem_wait in pf_queuing_worker waits
> forever.
> 
> Kick the processing thread to avoid this situation.
> 
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=201173
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> My brains started leaking out debugging this, but it works,
> and it seems harmless. :D  Happy to have review from anyone who groks
> the prefetch thread management better than I do...
> 
> diff --git a/repair/prefetch.c b/repair/prefetch.c
> index 9571b24..1de0e2f 100644
> --- a/repair/prefetch.c
> +++ b/repair/prefetch.c
> @@ -768,8 +768,12 @@ pf_queuing_worker(
>  			 * might get stuck on a buffer that has been locked
>  			 * and added to the I/O queue but is waiting for
>  			 * the thread to be woken.
> +			 * Start processing as well, in case everything so
> +			 * far was already prefetched and the queue is empty.
>  			 */
> +			
>  			pf_start_io_workers(args);
> +			pf_start_processing(args);
>  			sem_wait(&args->ra_count);
>  		}

Looks reasonable. We've had other bugs like this in the prefetch
code, so I'm not surprised there are still some lurking.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
