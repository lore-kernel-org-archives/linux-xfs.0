Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41110 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752975AbdEWLVd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 May 2017 07:21:33 -0400
Date: Tue, 23 May 2017 13:21:29 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 2/3 V2] xfs: Add infrastructure needed for error
 propagation during buffer IO failure
Message-ID: <20170523112129.5u36jympx7opw3g4@eorzea.usersys.redhat.com>
References: <20170522153220.25072-1-cmaiolino@redhat.com>
 <20170522153220.25072-3-cmaiolino@redhat.com>
 <20170522191322.GD17100@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170522191322.GD17100@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Mon, May 22, 2017 at 12:13:22PM -0700, Christoph Hellwig wrote:
> Need to read up on the history and background a bit more, but some
> cosmetic comments below:
> 
> > +	lip = bp->b_fspriv;
> > +	while (lip != NULL) {
> > +		next = lip->li_bio_list;
> > +
> > +		if (lip->li_ops->iop_error)
> > +			lip->li_ops->iop_error(lip, bflags);
> > +
> > +		lip = next;
> > +	}
> 
> 	for (lip = bp->b_fspriv; lip; lip = next) {
> 		next = lip->li_bio_list;
> 		if (lip->li_ops->iop_error)
> 			lip->li_ops->iop_error(lip, bflags);
> 	}
> 
> ?

Agree, looks much better.

> 
> > @@ -1101,6 +1119,7 @@ xfs_buf_iodone_callback_error(
> >  
> >  		xfs_buf_ioerror(bp, 0);
> >  		xfs_buf_submit(bp);
> > +
> >  		return true;
> >  	}
> 
> whitespace noise.


Fixed and queued for V3, thanks

-- 
Carlos
