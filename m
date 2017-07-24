Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl6.internode.on.net ([150.101.137.136]:4277 "EHLO
        ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751782AbdGXBna (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Jul 2017 21:43:30 -0400
Date: Mon, 24 Jul 2017 11:43:27 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 05/22] xfs: scrub in-memory metadata buffers
Message-ID: <20170724014327.GC17762@dastard>
References: <150061190859.14732.17040548800470377701.stgit@magnolia>
 <150061194082.14732.17289613506653968866.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150061194082.14732.17289613506653968866.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jul 20, 2017 at 09:39:00PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Call the verifier function for all in-memory metadata buffers, looking
> for memory corruption either due to bad memory or coding bugs.

How does this fit into the bigger picture? We can't do an exhaustive
search of the in memory buffer cache, because access is racy w.r.t.
the life cycle of in memory buffers.

Also, if we are doing a full scrub, we're going to hit and then
check the cached in-memory buffers anyway, so I'm missing the
context that explains why this code is necessary.

>  #endif	/* __XFS_REPAIR_COMMON_H__ */
> diff --git a/fs/xfs/scrub/metabufs.c b/fs/xfs/scrub/metabufs.c
> new file mode 100644
> index 0000000..63faaa6
> --- /dev/null
> +++ b/fs/xfs/scrub/metabufs.c
> @@ -0,0 +1,177 @@
> +/*
> + * Copyright (C) 2017 Oracle.  All Rights Reserved.
> + *
> + * Author: Darrick J. Wong <darrick.wong@oracle.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version 2
> + * of the License, or (at your option) any later version.
> + *
> + * This program is distributed in the hope that it would be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write the Free Software Foundation,
> + * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
> + */
> +#include "xfs.h"
> +#include "xfs_fs.h"
> +#include "xfs_shared.h"
> +#include "xfs_format.h"
> +#include "xfs_trans_resv.h"
> +#include "xfs_mount.h"
> +#include "xfs_defer.h"
> +#include "xfs_btree.h"
> +#include "xfs_bit.h"
> +#include "xfs_log_format.h"
> +#include "xfs_trans.h"
> +#include "xfs_trace.h"
> +#include "xfs_sb.h"
> +#include "scrub/common.h"
> +
> +/* We only iterate buffers one by one, so we don't need any setup. */
> +int
> +xfs_scrub_setup_metabufs(
> +	struct xfs_scrub_context	*sc,
> +	struct xfs_inode		*ip)
> +{
> +	return 0;
> +}
> +
> +#define XFS_SCRUB_METABUFS_TOO_MANY_RETRIES	10
> +struct xfs_scrub_metabufs_info {
> +	struct xfs_scrub_context	*sc;
> +	unsigned int			retries;
> +};

So do we get 10 retries per buffer, or 10 retries across an entire
scan?

> +/* In-memory buffer corruption. */
> +
> +#define XFS_SCRUB_BUF_OP_ERROR_GOTO(label) \
> +	XFS_SCRUB_OP_ERROR_GOTO(smi->sc, \
> +			xfs_daddr_to_agno(smi->sc->mp, bp->b_bn), \
> +			xfs_daddr_to_agbno(smi->sc->mp, bp->b_bn), "buf", \
> +			&error, label)

Nested macros - yuck!

> +STATIC int
> +xfs_scrub_metabufs_scrub_buf(
> +	struct xfs_scrub_metabufs_info	*smi,
> +	struct xfs_buf			*bp)
> +{
> +	int				olderror;
> +	int				error = 0;
> +
> +	/*
> +	 * We hold the rcu lock during the rhashtable walk, so we can't risk
> +	 * having the log forced due to a stale buffer by xfs_buf_lock.
> +	 */
> +	if (bp->b_flags & XBF_STALE)
> +		return 0;
> +
> +	atomic_inc(&bp->b_hold);

This looks wrong. I think it can race with reclaim because we don't
hold the pag->pag_buf_lock. i.e.  xfs_buf_rele() does this:

	release = atomic_dec_and_lock(&bp->b_hold, &pag->pag_buf_lock);

to prevent lookups - which are done under the pag->pag_buf_lock -
from finding the buffer while it has a zero hold count and may be
removed from the cache and freed.

Further, if we are going to iterate the cache, I'd much prefer the
iteration code to be in fs/xfs/xfs_buf.c - nothing outside that file
should be touching core buffer cache structures....

FWIW, the LRU walks already handle this problem by the fact the LRU
owns a hold count on the buffer. So it may be better to do this via
a LRU walk rather than a hashtable walk....

[snip]

> +	olderror = bp->b_error;
> +	if (bp->b_fspriv)
> +		bp->b_ops->verify_write(bp);

Should we be recalculating the CRC on buffers we aren't about to 
be writing to disk? Should we be verifying a buffer that has a
non-zero error value on it?

> +	else
> +		bp->b_ops->verify_read(bp);
> +	error = bp->b_error;
> +	bp->b_error = olderror;
> +
> +	/* Mark any corruption errors we might find. */
> +	XFS_SCRUB_BUF_OP_ERROR_GOTO(out_unlock);

Ah, what? Why does this need a goto? And why doesn't it report the
error that was found? (bloody macros!).

> +out_unlock:
> +	xfs_buf_unlock(bp);
> +out_dec:
> +	atomic_dec(&bp->b_hold);
> +	return error;
> +}
> +#undef XFS_SCRUB_BUF_OP_ERROR_GOTO

Oh, that's the macro defined above the function. Which I paid little
attention to other than it called another macro. Now I realise that
it (ab)uses local variables without them being passed into the
macro. Yup, another reason we need to get rid of the macros from
this code....

> +	struct xfs_scrub_metabufs_info	*smi,
> +	struct rhashtable_iter		*iter)
> +{
> +	struct xfs_buf			*bp;
> +	int				error = 0;
> +
> +	do {
> +		if (xfs_scrub_should_terminate(&error))
> +			break;
> +
> +		bp = rhashtable_walk_next(iter);
> +		if (IS_ERR(bp))
> +			return PTR_ERR(bp);
> +		else if (bp == NULL)
> +			return 0;
> +
> +		error = xfs_scrub_metabufs_scrub_buf(smi, bp);
> +	} while (error != 0);
> +
> +	return error;
> +}
> +
> +/* Try to walk the buffers in this AG in order to scrub them. */
> +int
> +xfs_scrub_metabufs(

Ah, please put an "_ag_" in this so it's clear it's only scrubbing a
single AG. This is hidden deep inside the scrub context, so it took
me a little bit of back tracking to understand that this wasn't a
global scan....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
