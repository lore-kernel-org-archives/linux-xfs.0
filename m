Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:23711 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725831AbeIGFAj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Sep 2018 01:00:39 -0400
Date: Fri, 7 Sep 2018 10:21:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/4] mkfs: introduce new delayed write buffer list
Message-ID: <20180907002141.GJ27618@dastard>
References: <20180905081932.27478-1-david@fromorbit.com>
 <20180905081932.27478-4-david@fromorbit.com>
 <20180906133214.GC3311@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180906133214.GC3311@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Sep 06, 2018 at 09:32:15AM -0400, Brian Foster wrote:
> On Wed, Sep 05, 2018 at 06:19:31PM +1000, Dave Chinner wrote:
> > diff --git a/libxfs/trans.c b/libxfs/trans.c
> > index 2bb0d3b8e2d1..c3da46479efa 100644
> > --- a/libxfs/trans.c
> > +++ b/libxfs/trans.c
> > @@ -728,10 +728,11 @@ inode_item_done(
> >  
> >  static void
> >  buf_item_done(
> > -	xfs_buf_log_item_t	*bip)
> > +	struct xfs_buf_log_item	*bip,
> > +	struct list_head	*delwri_list)
> >  {
> > -	xfs_buf_t		*bp;
> > -	int			hold;
> > +	struct xfs_buf		*bp;
> > +	bool			hold;
> >  	extern kmem_zone_t	*xfs_buf_item_zone;
> >  
> >  	bp = bip->bli_buf;
> > @@ -745,7 +746,13 @@ buf_item_done(
> >  		fprintf(stderr, "flushing/staling buffer %p (hold=%d)\n",
> >  			bp, hold);
> >  #endif
> > -		libxfs_writebuf_int(bp, 0);
> > +		if (delwri_list) {
> > +			/* delwri list needs to hold on to the buffer here */
> > +			libxfs_buf_delwri_add(bp, 0, delwri_list);
> > +			hold = true;
> 
> This seems a bit flakey.

Yup, it's a nasty hack to avoid having to put proper reference
counting into the userspace xfs_bufs.

> IIUC, the hold is set here because the delwri
> queue either needs the reference until after I/O completion (or it
> dropped the callers reference already if the buffer were already present
> on the queue). If BLI_HOLD is set in this case, however, haven't we
> basically stolen the caller's reference?

Yes, that's precisely why it's a nasty hack.

> I'm guessing this probably doesn't ever happen in the limited scope of
> mkfs, so consider that an interface design nit for now.

Right, that's how I got away with it here. :P

> I suppose a more
> robust mechanism might more closely resemble the kernel approach where
> the delwri_queue() acquires its own reference on the buf (somehow or
> another as applied to the xfsprogs buffer management system, I don't
> have it all paged in atm).

The right approach is to port the kernel buffer cache implementation
to libxfs and implement bio_submit() and the bio completion
callbacks via an AIO engine. Then we can add an AIL and convert all
the open coded libxfs_write() calls in this mkfs code to transaction
joins as ordered buffers. That way we don't need the delwri list
hack into xfs_trans_commit() - we just push the AIL every so
often...

That's a lot more work than this proof of concept, though.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
