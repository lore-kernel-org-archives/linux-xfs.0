Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33550 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752590AbdEWKfj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 May 2017 06:35:39 -0400
Date: Tue, 23 May 2017 12:35:35 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 1/3] xfs: use atomic operations to handle xfs_log_item
 flags
Message-ID: <20170523103535.6fmghatkarvblqbu@eorzea.usersys.redhat.com>
References: <20170522153220.25072-1-cmaiolino@redhat.com>
 <20170522153220.25072-2-cmaiolino@redhat.com>
 <20170522191111.GC17100@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170522191111.GC17100@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

Hi,

On Mon, May 22, 2017 at 12:11:11PM -0700, Christoph Hellwig wrote:
> > --- a/fs/xfs/xfs_buf_item.c
> > +++ b/fs/xfs/xfs_buf_item.c
> > @@ -587,7 +587,7 @@ xfs_buf_item_unlock(
> >  	 * (cancelled) buffers at unpin time, but we'll never go through the
> >  	 * pin/unpin cycle if we abort inside commit.
> >  	 */
> > -	aborted = (lip->li_flags & XFS_LI_ABORTED) ? true : false;
> > +	aborted = (test_bit(XFS_LI_ABORTED, &lip->li_flags)) ? true : false;
> 
> 	aborted = test_bit(XFS_LI_ABORTED, &lip->li_flags);
> 
> does the same job in a slightly simpler way.
> 
> > +	ASSERT(!(test_bit(XFS_LI_IN_AIL, &bip->bli_item.li_flags)));
> 
> no need for the inner braces.
> 
> > +		ASSERT(!(test_bit(XFS_LI_IN_AIL, &ip->i_itemp->ili_item.li_flags)));
> 
> Same here.  Also please don't break lines after 80 characters.
> 
> > +	       !(test_bit(XFS_LI_IN_AIL, &dqp->q_logitem.qli_item.li_flags)));
> 
> Also no need for the braces around test_bit here.
> 
> > +	if (!(test_bit(XFS_LI_IN_AIL, &lip->li_flags))) {
> 
> .. again
> 
> > +		ASSERT(!(test_bit(XFS_LI_IN_AIL, &bip->bli_item.li_flags)));
> 
> .. again
> 
> Also last but not least the arguments to the *_bit functions are
> bit indices, so they should be renumber to 0 and 1 (and the tracing
> helpers will need some updates as well).

Thanks for the review of this series, I'll queue these changes for V3.


-- 
Carlos
