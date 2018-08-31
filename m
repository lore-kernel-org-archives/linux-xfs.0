Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:48350 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727295AbeHaLam (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 31 Aug 2018 07:30:42 -0400
Date: Fri, 31 Aug 2018 00:24:37 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 1/3] xfs: don't unlock invalidated buf on aborted tx
 commit
Message-ID: <20180831072437.GA7079@infradead.org>
References: <20180829172634.57981-1-bfoster@redhat.com>
 <20180829172634.57981-2-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180829172634.57981-2-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

> -	}
> -
>  	trace_xfs_buf_item_unlock(bip);

Can we keep an empty line between the variable declarations and the
trace call?

> +	freed = atomic_dec_and_test(&bip->bli_refcount);
> +	if (freed) {
> +		ASSERT(!aborted || XFS_FORCED_SHUTDOWN(lip->li_mountp));
> +		/*
> +		 * An aborted item may be in the AIL regardless of dirty state.
> +		 * For example, consider an aborted transaction that invalidated
> +		 * a dirty bli and cleared the dirty state.
> +		 */
> +		if (aborted)
>  			xfs_trans_ail_remove(lip, SHUTDOWN_LOG_IO_ERROR);
> +		if (aborted || !dirty)
>  			xfs_buf_item_relse(bp);
> +	} else if (stale) {
> +		/*
> +		 * Stale buffers remain locked until final unpin unless the bli
> +		 * was freed in the branch above. A freed stale bli implies an
> +		 * abort because buffer invalidation dirties the bli and
> +		 * transaction.
> +		 */
> +		ASSERT(!freed);

This assert doesn't make sense as we're already in the else statement
of the 'if (freed) check.

> +		return;
>  	}
> +	ASSERT(!stale || (aborted && freed));

This assert still look a little odd to me because it duplicates so
much of the above logic.  Why not:

	if (atomic_dec_and_test(&bip->bli_refcount)) {
		/*
		 * An aborted item may be in the AIL regardless of dirty state.
		 * For example, consider an aborted transaction that invalidated
		 * a dirty bli and cleared the dirty state.
		 */
		if (aborted) {
			ASSERT(XFS_FORCED_SHUTDOWN(lip->li_mountp));
  			xfs_trans_ail_remove(lip, SHUTDOWN_LOG_IO_ERROR);
 			xfs_buf_item_relse(bp);
		} else {
			ASSERT(!stale);
			if (!dirty)
 				xfs_buf_item_relse(bp);
		}
	} else if (stale) {
		/*
		 * Stale buffers remain locked until final unpin unless the bli
		 * was freed in the branch above. A freed stale bli implies an
		 * abort because buffer invalidation dirties the bli and
		 * transaction.
		 */
		return;
	}
