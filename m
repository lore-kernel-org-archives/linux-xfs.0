Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:52686 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727178AbeHaLgo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 31 Aug 2018 07:36:44 -0400
Date: Fri, 31 Aug 2018 00:30:38 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 3/3] xfs: refactor xfs_buf_log_item reference count
 handling
Message-ID: <20180831073038.GB7079@infradead.org>
References: <20180829172634.57981-1-bfoster@redhat.com>
 <20180829172634.57981-4-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180829172634.57981-4-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

> +bool
> +xfs_buf_item_put(
> +	struct xfs_buf_log_item	*bip)

Any reason to not have this above the caller?  Also a little
top of function comment explaining this helper might be nice.

> +	/*
> +	 * We dropped the last ref and must free the item if clean or aborted.
> +	 * If the bli is dirty and non-aborted, the buffer was clean in the
> +	 * transaction but still awaiting writeback from previous changes. In
> +	 * that case, the bli is freed on buffer writeback completion.
> +	 */
> +	aborted = test_bit(XFS_LI_ABORTED, &lip->li_flags) ||
> +		  XFS_FORCED_SHUTDOWN(lip->li_mountp);
> +	dirty = bip->bli_flags & XFS_BLI_DIRTY;
> +	if (dirty && !aborted)
> +		return false;
> +
> +	/*
> +	 * The bli is aborted or clean. An aborted item may be in the AIL
> +	 * regardless of dirty state.  For example, consider an aborted
> +	 * transaction that invalidated a dirty bli and cleared the dirty
> +	 * state.
> +	 */
> +	if (aborted)
> +		xfs_trans_ail_remove(lip, SHUTDOWN_LOG_IO_ERROR);

Hmm, why not:

	if (test_bit(XFS_LI_ABORTED, &lip->li_flags) ||
	    XFS_FORCED_SHUTDOWN(lip->li_mountp))
		xfs_trans_ail_remove(lip, SHUTDOWN_LOG_IO_ERROR);
	else if (dirty)
		return false;
