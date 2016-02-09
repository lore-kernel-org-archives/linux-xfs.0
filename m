Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D3F5C29DF6
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2016 15:59:04 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C36618F804B
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2016 13:59:04 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	gJocx9nEvIaERWXX for <xfs@oss.sgi.com>;
	Tue, 09 Feb 2016 13:59:02 -0800 (PST)
Date: Wed, 10 Feb 2016 08:59:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/5] xfs: don't chain ioends during writepage submission
Message-ID: <20160209215900.GH14668@dastard>
References: <1454910258-7578-1-git-send-email-david@fromorbit.com>
	<1454910258-7578-6-git-send-email-david@fromorbit.com>
	<20160209142355.GB25829@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160209142355.GB25829@bfoster.bfoster>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, Feb 09, 2016 at 09:23:55AM -0500, Brian Foster wrote:
> On Mon, Feb 08, 2016 at 04:44:18PM +1100, Dave Chinner wrote:
> > @@ -738,29 +726,22 @@ xfs_writepage_submit(
> >  	struct writeback_control *wbc,
> >  	int			status)
> >  {
> > -	struct blk_plug		plug;
> > -
> > -	/* Reserve log space if we might write beyond the on-disk inode size. */
> > -	if (!status && wpc->ioend && wpc->ioend->io_type != XFS_IO_UNWRITTEN &&
> > -	    xfs_ioend_is_append(wpc->ioend))
> > -		status = xfs_setfilesize_trans_alloc(wpc->ioend);
> > -
> > -	if (wpc->iohead) {
> > -		blk_start_plug(&plug);
> > -		xfs_submit_ioend(wbc, wpc->iohead, status);
> > -		blk_finish_plug(&plug);
> > -	}
> 
> We've dropped our plug here but I don't see anything added in
> xfs_vm_writepages(). Shouldn't we have one there now that ioends are
> submitted as we go? generic_writepages() uses one around its
> write_cache_pages() call..

It's not really necessary, as we now have higher level plugging in
the writeback go will get flushed on context switch, and if we don't
have a high level plug (e.g. fsync triggered writeback), then we
submit the IO immediately, just like flushing the plug here would do
anyway....

> > @@ -827,23 +808,37 @@ xfs_writepage_map(
> >  							 offset);
> >  		}
> >  		if (wpc->imap_valid) {
> > +			struct xfs_ioend *ioend;
> > +
> >  			lock_buffer(bh);
> >  			if (wpc->io_type != XFS_IO_OVERWRITE)
> >  				xfs_map_at_offset(inode, bh, &wpc->imap, offset);
> > -			xfs_add_to_ioend(inode, bh, offset, wpc);
> 
> "Big picture" comment here please, i.e. something along the lines of
> (feel free to rewrite/fix/enhance):
> 
> "This implements an immediate ioend submission policy. If a new ioend is
> required, the old ioend is returned and slated for submission on
> function exit. The purpose of this policy is to avoid creating and
> holding large chains of ioend objects in memory. While ioends are
> submitted immediately after they are completed, block plugging helps
> provide batching."

I can add something like that to the function.

> > -	else {
> > +		while (ioend_to_submit) {
> > +			struct xfs_ioend *next = ioend_to_submit->io_list;
> > +
> > +			ioend_to_submit->io_list = NULL;
> > +			xfs_submit_ioend(wbc, ioend_to_submit, 0);
> > +			ioend_to_submit = next;
> > +		}
> > +	} else {
> >  		xfs_aops_discard_page(page);
> >  		ClearPageUptodate(page);
> >  		unlock_page(page);
> 
> If we have an error and count == 0, we know that ioend_to_submit is NULL
> because that is only potentially set once the first buffer is added.
> That said, this doesn't mean that we don't have an ioend waiting on the
> wpc. If we do, we still return the error and the ioend is errored out.
> 
> I wonder if that is really necessary if we haven't added any buffers
> from the page..? Could we submit the ioend properly in that case? OTOH,
> that might complicate the error reporting and an error here might be
> serious enough that it isn't worth it, as opposed to just making sure we
> clean up everything appropriately.

The way I've done it is the same as the existing code - on error the
entire ioend chain that has been built is errored out. I'd prefer to
keep it that way right now to minimise the potential behavioural
changes of the patch series. We can look to changing to partial
submission in a separate patch set if it makes sense to do so.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
