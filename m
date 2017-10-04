Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:11426 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751250AbdJDAxV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Oct 2017 20:53:21 -0400
Date: Wed, 4 Oct 2017 11:46:03 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 08/25] xfs: create helpers to scan an allocation group
Message-ID: <20171004004603.GU3666@dastard>
References: <150706324963.19351.17715069858921948692.stgit@magnolia>
 <150706330006.19351.11655503679984316123.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150706330006.19351.11655503679984316123.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Oct 03, 2017 at 01:41:40PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add some helpers to enable us to lock an AG's headers, create btree
> cursors for all btrees in that allocation group, and clean up
> afterwards.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/scrub/common.c |  173 +++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/scrub/common.h |   10 +++
>  fs/xfs/scrub/scrub.c  |    4 +
>  fs/xfs/scrub/scrub.h  |   21 ++++++
>  4 files changed, 208 insertions(+)
> 
> 
> diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
> index a84ba19..b056c9d 100644
> --- a/fs/xfs/scrub/common.c
> +++ b/fs/xfs/scrub/common.c
> @@ -44,6 +44,7 @@
>  #include "scrub/scrub.h"
>  #include "scrub/common.h"
>  #include "scrub/trace.h"
> +#include "scrub/btree.h"
>  
>  /* Common code for the metadata scrubbers. */
>  
> @@ -298,6 +299,178 @@ xfs_scrub_set_incomplete(
>  	trace_xfs_scrub_incomplete(sc, __return_address);
>  }
>  
> +/*
> + * AG scrubbing
> + *
> + * These helpers facilitate locking an allocation group's header
> + * buffers, setting up cursors for all btrees that are present, and
> + * cleaning everything up once we're through.
> + */
> +
> +/* Grab all the headers for an AG. */
> +int
> +xfs_scrub_ag_read_headers(
> +	struct xfs_scrub_context	*sc,
> +	xfs_agnumber_t			agno,
> +	struct xfs_buf			**agi,
> +	struct xfs_buf			**agf,
> +	struct xfs_buf			**agfl)
> +{
> +	struct xfs_mount		*mp = sc->mp;
> +	int				error;
> +
> +	error = xfs_ialloc_read_agi(mp, sc->tp, agno, agi);
> +	if (error)
> +		goto out;
> +
> +	error = xfs_alloc_read_agf(mp, sc->tp, agno, 0, agf);
> +	if (error)
> +		goto out;
> +	if (!*agf) {
> +		error = -ENOMEM;
> +		goto out;
> +	}
> +
> +	error = xfs_alloc_read_agfl(mp, sc->tp, agno, agfl);
> +	if (error)
> +		goto out;
> +
> +out:
> +	return error;
> +}

It's not immediately obvious what releases the buffers on error.
Maybe add a comment to say cleanup/release on error is unconditional
through xfs_scrub_ag_free()?

Hmmm - now there's a question - is the reference we get here freed
through cancelling the fake transaction, or via the manual
xfs_trans_brelse() call in the free function? which one happens
first? add that to the comment?

And given this locks out the AG from allocation for an arbitrary
length of time, I'm wondering if we should add a flag into the pag
somewhere to say "being scrubbed" so the extent and inode allocation
code can skip over this AG and no block trying to lock it...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
