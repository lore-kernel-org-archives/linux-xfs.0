Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:59986 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727292AbeHaR2t (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 31 Aug 2018 13:28:49 -0400
Date: Fri, 31 Aug 2018 09:21:19 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v3 1/3] xfs: don't unlock invalidated buf on aborted tx
 commit
Message-ID: <20180831132119.GB39825@bfoster>
References: <20180829172634.57981-1-bfoster@redhat.com>
 <20180829172634.57981-2-bfoster@redhat.com>
 <20180831072437.GA7079@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180831072437.GA7079@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Fri, Aug 31, 2018 at 12:24:37AM -0700, Christoph Hellwig wrote:
> > -	}
> > -
> >  	trace_xfs_buf_item_unlock(bip);
> 
> Can we keep an empty line between the variable declarations and the
> trace call?
> 

Sure.

> > +	freed = atomic_dec_and_test(&bip->bli_refcount);
> > +	if (freed) {
> > +		ASSERT(!aborted || XFS_FORCED_SHUTDOWN(lip->li_mountp));
> > +		/*
> > +		 * An aborted item may be in the AIL regardless of dirty state.
> > +		 * For example, consider an aborted transaction that invalidated
> > +		 * a dirty bli and cleared the dirty state.
> > +		 */
> > +		if (aborted)
> >  			xfs_trans_ail_remove(lip, SHUTDOWN_LOG_IO_ERROR);
> > +		if (aborted || !dirty)
> >  			xfs_buf_item_relse(bp);
> > +	} else if (stale) {
> > +		/*
> > +		 * Stale buffers remain locked until final unpin unless the bli
> > +		 * was freed in the branch above. A freed stale bli implies an
> > +		 * abort because buffer invalidation dirties the bli and
> > +		 * transaction.
> > +		 */
> > +		ASSERT(!freed);
> 
> This assert doesn't make sense as we're already in the else statement
> of the 'if (freed) check.
> 

It was intended to be defensive. I actually considered 'else if (freed
&& stale)' so the code was more clear, but settled on this (which is
eventually replaced).

> > +		return;
> >  	}
> > +	ASSERT(!stale || (aborted && freed));
> 
> This assert still look a little odd to me because it duplicates so
> much of the above logic.  Why not:
> 

Just optimizing out the freed variable doesn't eliminate the need for
the assert. freed is defined because I wanted an assert to check the
expected state where we consider an unlock. I wanted the assert because
the situation is non-trivial with regard to handling unlocks of stale
buffers in this path. To simplify this is partly the purpose of the
following patches, which also tweak this assert and replace the rest of
the code you've changed.

Brian

> 	if (atomic_dec_and_test(&bip->bli_refcount)) {
> 		/*
> 		 * An aborted item may be in the AIL regardless of dirty state.
> 		 * For example, consider an aborted transaction that invalidated
> 		 * a dirty bli and cleared the dirty state.
> 		 */
> 		if (aborted) {
> 			ASSERT(XFS_FORCED_SHUTDOWN(lip->li_mountp));
>   			xfs_trans_ail_remove(lip, SHUTDOWN_LOG_IO_ERROR);
>  			xfs_buf_item_relse(bp);
> 		} else {
> 			ASSERT(!stale);
> 			if (!dirty)
>  				xfs_buf_item_relse(bp);
> 		}
> 	} else if (stale) {
> 		/*
> 		 * Stale buffers remain locked until final unpin unless the bli
> 		 * was freed in the branch above. A freed stale bli implies an
> 		 * abort because buffer invalidation dirties the bli and
> 		 * transaction.
> 		 */
> 		return;
> 	}
