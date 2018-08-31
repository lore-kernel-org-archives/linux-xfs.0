Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:60034 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727292AbeHaRaJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 31 Aug 2018 13:30:09 -0400
Date: Fri, 31 Aug 2018 09:22:39 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v3 3/3] xfs: refactor xfs_buf_log_item reference count
 handling
Message-ID: <20180831132239.GC39825@bfoster>
References: <20180829172634.57981-1-bfoster@redhat.com>
 <20180829172634.57981-4-bfoster@redhat.com>
 <20180831073038.GB7079@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180831073038.GB7079@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Fri, Aug 31, 2018 at 12:30:38AM -0700, Christoph Hellwig wrote:
> > +bool
> > +xfs_buf_item_put(
> > +	struct xfs_buf_log_item	*bip)
> 
> Any reason to not have this above the caller?  Also a little
> top of function comment explaining this helper might be nice.
> 

Ok, I can move it and add a comment.

> > +	/*
> > +	 * We dropped the last ref and must free the item if clean or aborted.
> > +	 * If the bli is dirty and non-aborted, the buffer was clean in the
> > +	 * transaction but still awaiting writeback from previous changes. In
> > +	 * that case, the bli is freed on buffer writeback completion.
> > +	 */
> > +	aborted = test_bit(XFS_LI_ABORTED, &lip->li_flags) ||
> > +		  XFS_FORCED_SHUTDOWN(lip->li_mountp);
> > +	dirty = bip->bli_flags & XFS_BLI_DIRTY;
> > +	if (dirty && !aborted)
> > +		return false;
> > +
> > +	/*
> > +	 * The bli is aborted or clean. An aborted item may be in the AIL
> > +	 * regardless of dirty state.  For example, consider an aborted
> > +	 * transaction that invalidated a dirty bli and cleared the dirty
> > +	 * state.
> > +	 */
> > +	if (aborted)
> > +		xfs_trans_ail_remove(lip, SHUTDOWN_LOG_IO_ERROR);
> 
> Hmm, why not:
> 
> 	if (test_bit(XFS_LI_ABORTED, &lip->li_flags) ||
> 	    XFS_FORCED_SHUTDOWN(lip->li_mountp))
> 		xfs_trans_ail_remove(lip, SHUTDOWN_LOG_IO_ERROR);
> 	else if (dirty)
> 		return false;

Because 1.) I wanted to separate the logic and comments for when we must
free the item from when we don't and 2.) I don't want to look at this
function and see the aborted logic first and then try to grok the more
common case in an 'else' branch. I want to see the common case logic
front and center and consider the aborted case as the outlier.

IOW, the aborted state shouldn't really drive the logical flow of this
function:

- if the bli is still referenced, return
- if the bli is unreferenced but is going to be written back, return
- otherwise we're the last user, free the item appropriately

Brian
