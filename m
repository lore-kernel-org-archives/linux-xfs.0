Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:58684 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727279AbeGaJuG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Jul 2018 05:50:06 -0400
Date: Tue, 31 Jul 2018 01:10:56 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 01/15] xfs: refactor internal dfops initialization
Message-ID: <20180731081056.GB16028@infradead.org>
References: <20180730164520.36882-1-bfoster@redhat.com>
 <20180730164520.36882-2-bfoster@redhat.com>
 <20180730193048.GB30972@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180730193048.GB30972@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On Mon, Jul 30, 2018 at 12:30:48PM -0700, Darrick J. Wong wrote:
> >  	trace_xfs_trans_commit(tp, _RET_IP_);
> >  
> >  	/* finish deferred items on final commit */
> > -	if (!regrant && tp->t_dfops) {
> > +	if (!regrant && (tp->t_flags & XFS_TRANS_PERM_LOG_RES)) {
> 
> The usage model of deferred ops is that one has to create a transaction
> with a permanent reservation, and only then start attaching deferred ops
> to the dfops inside the transaction.  It's a programming error if a
> caller tries to finish deferred ops using a non-permanent transaction,
> and prior to this patch t_dfops would be NULL and we'd blow up
> immediately in xfs_defer_add(..., tp->t_dfops, ...);
> 
> However, now that we initialize t_dfops unconditionally, won't this
> cause the above programming mistake to leak silently any incorrectly
> queued defer ops?

I guess we'll just need an assert for a perment reservation in
xfs_defer_add, although that'll have to wait for the patch that
actually passes a transaction to it.

Except for that this patch looks fine to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>
