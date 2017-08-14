Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f169.google.com ([209.85.128.169]:35166 "EHLO
        mail-wr0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753270AbdHNNEq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Aug 2017 09:04:46 -0400
Received: by mail-wr0-f169.google.com with SMTP id k71so34292912wrc.2
        for <linux-xfs@vger.kernel.org>; Mon, 14 Aug 2017 06:04:45 -0700 (PDT)
Date: Mon, 14 Aug 2017 15:04:42 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 2/2 V7] xfs: Properly retry failed inode items in case of
 error during buffer writeback
Message-ID: <20170814130442.6wynqooddmedbbtt@hades.localdomain>
References: <20170724133431.11479-1-cmaiolino@redhat.com>
 <20170724133431.11479-3-cmaiolino@redhat.com>
 <20170811130957.GB27121@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170811130957.GB27121@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

Hi Christoph,

On Fri, Aug 11, 2017 at 06:09:57AM -0700, Christoph Hellwig wrote:
> >  }
> >  #endif
> > +
> > +static inline void
> > +xfs_clear_li_failed(
> > +	struct xfs_log_item	*lip)
> > +{
> > +	struct xfs_buf	*bp = lip->li_buf;
> > +
> > +	ASSERT(lip->li_flags & XFS_LI_IN_AIL);
> > +	lockdep_assert_held(&lip->li_ailp->xa_lock);
> > +
> > +	if (lip->li_flags & XFS_LI_FAILED) {
> > +		lip->li_flags &= ~XFS_LI_FAILED;
> > +		lip->li_buf = NULL;
> > +		xfs_buf_rele(bp);
> 
> This means we now nest pag->pag_buf_lock and bp->b_lock inside
> ailp->xa_lock.  I couldn't find any place where we take
> it in a different order, but it makes me feel a little nervous.
> 

If it makes you feel less nervous, I plan to remove the xa_lock there, and use
atomic operations instead, to set/clear the lip->li_flags, as discussed in
previous versions.

> Also I think the set/clear failed helper might better be out of line
> instead of bloating the callers.
> 

Sure, I have no problem in making it a not inline function, My goal in making it
inlined was to not add another call in the stack just to remove the flags, but,
maybe a stupid question, but, what would be the benefit in making it a regular
function instead of inline?


> Except for that the patch looks fine to me.

Thanks for the review.

Cheers

-- 
Carlos
