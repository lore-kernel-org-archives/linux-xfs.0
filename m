Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:13651 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750750AbeAQBBO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Jan 2018 20:01:14 -0500
Date: Wed, 17 Jan 2018 12:00:54 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 18/21] xfs: cross-reference the rmapbt data with the
 refcountbt
Message-ID: <20180117010053.GG6304@dastard>
References: <151398977028.18741.12031215574014508438.stgit@magnolia>
 <151398988306.18741.8223158735554937583.stgit@magnolia>
 <20180116232628.GC5602@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180116232628.GC5602@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jan 16, 2018 at 03:26:28PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Cross reference the refcount data with the rmap data to check that the
> number of rmaps for a given block match the refcount of that block, and
> that CoW blocks (which are owned entirely by the refcountbt) are tracked
> as well.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v3: fix indenting and standardize helper naming, refactor helpers per dave'sr
>     suggestion and add clarifying comments
> v2: streamline scrubber arguments, remove stack allocated objects
> ---
>  fs/xfs/scrub/refcount.c |  340 +++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 338 insertions(+), 2 deletions(-)

One minor thing:

> +	while (!list_empty(&refchk->fragments)) {
> +		/* Discard any fragments ending at rbno from the worklist. */
> +		nr = 0;
> +		next_rbno = NULLAGBLOCK;
> +		list_for_each_entry_safe(frag, n, &worklist, list) {
> +			bno = frag->rm.rm_startblock + frag->rm.rm_blockcount;
> +			if (bno != rbno) {
> +				if (bno < next_rbno)
> +					next_rbno = bno;
> +				continue;
> +			}
> +			list_del(&frag->list);
> +			kmem_free(frag);
> +			nr++;
> +		}
> +
> +		/* Empty list?  We're done. */
> +		if (list_empty(&refchk->fragments))
> +			break;

We haven't modified the &refchk->fragments list since the check at
the start of the loop, so this seems redundant and could be removed?

Other than that, I found this much easier to understand the second
time through. A bit of time for it to sink in and a few small
changes to logic and comments has done wonders :)

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
