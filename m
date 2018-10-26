Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:33932 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbeJZSVw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Oct 2018 14:21:52 -0400
Date: Fri, 26 Oct 2018 02:45:29 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/5] xfs: factor data block addition from
 xfs_dir2_node_addname_int()
Message-ID: <20181026094529.GA29302@infradead.org>
References: <20181024225716.19459-1-david@fromorbit.com>
 <20181024225716.19459-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181024225716.19459-3-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

> +	} else {
> +found_block:

This jumping into branch is a little ugly, but given that the next
patch cleans it up it is probably ok.

> +		/* suppress gcc maybe-used-initialised warning */
> +		bests = dp->d_ops->free_bests_p(free);

> -	 * If the freespace entry is now wrong, update it.
> -	 */
> -	bests = dp->d_ops->free_bests_p(free); /* gcc is so stupid */

So this moves bests from the common path of execution into the
branch, where it duplicates one in the other branch just for later
patches to move it back to almost where it was.  If it isn't to
painful to redo the patch I'd suggest to just keep it in the common
path here.

Otherwise this looks fine to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>
