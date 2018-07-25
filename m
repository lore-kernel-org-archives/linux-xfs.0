Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:60890 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728660AbeGYMVD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 25 Jul 2018 08:21:03 -0400
Date: Wed, 25 Jul 2018 07:09:51 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2 14/15] xfs: drop unnecessary xfs_defer_finish() dfops
 parameter
Message-ID: <20180725110950.GA57913@bfoster>
References: <20180723130414.47980-1-bfoster@redhat.com>
 <20180723130414.47980-15-bfoster@redhat.com>
 <20180725051143.GG5802@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180725051143.GG5802@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Tue, Jul 24, 2018 at 10:11:43PM -0700, Christoph Hellwig wrote:
> > -int xfs_defer_finish(struct xfs_trans **tp, struct xfs_defer_ops *dop);
> > -void xfs_defer_cancel(struct xfs_defer_ops *dop);
> > +int xfs_defer_finish(struct xfs_trans **tp);
> > +void __xfs_defer_cancel(struct xfs_defer_ops *dop);
> 
> > index dc79e3c1d3e8..5170e89bec02 100644
> > --- a/fs/xfs/xfs_trans.h
> > +++ b/fs/xfs/xfs_trans.h
> > @@ -214,6 +214,9 @@ xfs_trans_read_buf(
> >  				      flags, bpp, ops);
> >  }
> >  
> > +/* cancel dfops associated with a transaction */
> > +void xfs_defer_cancel(struct xfs_trans *);
> 
> Is there any good reason not to keep xfs_defer_cancel in xfs_defer.[ch]?
> 

Hmm, I originally had this as an inline in the header, so it was in
xfs_trans.h for similar reasons xfs_defer_ops was moved over there (the
function has to access tp->t_dfops).

I happened to change this over to a non-inline function in v2, but just
left it here for whatever reason. I could probably move it, but I don't
think it's worth it as I already have patches that kill this wrapper off
by updating the only __xfs_defer_cancel() caller (log recovery) to use
an empty container transaction instead of the external dfops. That will
be part of the next set of patches that reduce xfs_defer_ops to a single
list_head and subsequently eliminate the need for the structure...

Brian

> Otherwise this looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
