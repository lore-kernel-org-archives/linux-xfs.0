Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:36345 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752730AbdHKNJ5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Aug 2017 09:09:57 -0400
Date: Fri, 11 Aug 2017 06:09:57 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2 V7] xfs: Properly retry failed inode items in case of
 error during buffer writeback
Message-ID: <20170811130957.GB27121@infradead.org>
References: <20170724133431.11479-1-cmaiolino@redhat.com>
 <20170724133431.11479-3-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170724133431.11479-3-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: linux-xfs@vger.kernel.org

>  }
>  #endif
> +
> +static inline void
> +xfs_clear_li_failed(
> +	struct xfs_log_item	*lip)
> +{
> +	struct xfs_buf	*bp = lip->li_buf;
> +
> +	ASSERT(lip->li_flags & XFS_LI_IN_AIL);
> +	lockdep_assert_held(&lip->li_ailp->xa_lock);
> +
> +	if (lip->li_flags & XFS_LI_FAILED) {
> +		lip->li_flags &= ~XFS_LI_FAILED;
> +		lip->li_buf = NULL;
> +		xfs_buf_rele(bp);

This means we now nest pag->pag_buf_lock and bp->b_lock inside
ailp->xa_lock.  I couldn't find any place where we take
it in a different order, but it makes me feel a little nervous.

Also I think the set/clear failed helper might better be out of line
instead of bloating the callers.

Except for that the patch looks fine to me.
