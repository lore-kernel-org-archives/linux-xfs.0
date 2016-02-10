Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 353157CA4
	for <xfs@oss.sgi.com>; Wed, 10 Feb 2016 07:18:23 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 098358F8033
	for <xfs@oss.sgi.com>; Wed, 10 Feb 2016 05:18:20 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id OhcCZvlfsyQVXMf4 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 10 Feb 2016 05:18:18 -0800 (PST)
Date: Wed, 10 Feb 2016 08:18:17 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 5/5] xfs: don't chain ioends during writepage submission
Message-ID: <20160210131816.GB48974@bfoster.bfoster>
References: <1454910258-7578-1-git-send-email-david@fromorbit.com>
	<1454910258-7578-6-git-send-email-david@fromorbit.com>
	<20160209142355.GB25829@bfoster.bfoster>
	<20160209215900.GH14668@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160209215900.GH14668@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Wed, Feb 10, 2016 at 08:59:00AM +1100, Dave Chinner wrote:
> On Tue, Feb 09, 2016 at 09:23:55AM -0500, Brian Foster wrote:
> > On Mon, Feb 08, 2016 at 04:44:18PM +1100, Dave Chinner wrote:
> > > @@ -738,29 +726,22 @@ xfs_writepage_submit(
> > >  	struct writeback_control *wbc,
> > >  	int			status)
> > >  {
> > > -	struct blk_plug		plug;
> > > -
> > > -	/* Reserve log space if we might write beyond the on-disk inode size. */
> > > -	if (!status && wpc->ioend && wpc->ioend->io_type != XFS_IO_UNWRITTEN &&
> > > -	    xfs_ioend_is_append(wpc->ioend))
> > > -		status = xfs_setfilesize_trans_alloc(wpc->ioend);
> > > -
> > > -	if (wpc->iohead) {
> > > -		blk_start_plug(&plug);
> > > -		xfs_submit_ioend(wbc, wpc->iohead, status);
> > > -		blk_finish_plug(&plug);
> > > -	}
> > 
> > We've dropped our plug here but I don't see anything added in
> > xfs_vm_writepages(). Shouldn't we have one there now that ioends are
> > submitted as we go? generic_writepages() uses one around its
> > write_cache_pages() call..
> 
> It's not really necessary, as we now have higher level plugging in
> the writeback go will get flushed on context switch, and if we don't
> have a high level plug (e.g. fsync triggered writeback), then we
> submit the IO immediately, just like flushing the plug here would do
> anyway....
> 

Ok, I'm digging around the wb code a bit and I see plugs in/around
wb_writeback(), so I assume that's what you're referring to in the first
case. I'm not quite following the fsync case though...

In the current upstream code, fsync() leads to the following call chain:

  filemap_write_and_wait_range()
    __filemap_fdatawrite_range()
      do_writepages()
        xfs_vm_writepages()
          generic_writepages()
            blk_start_plug()
            write_cache_pages()
            blk_finish_plug()

After this series, we have the following:

  filemap_write_and_wait_range()
    __filemap_fdatawrite_range()
      do_writepages()
        xfs_vm_writepages() 
          write_cache_pages()

... with no plug that I can see. What am I missing?
      
...
> > > -	else {
> > > +		while (ioend_to_submit) {
> > > +			struct xfs_ioend *next = ioend_to_submit->io_list;
> > > +
> > > +			ioend_to_submit->io_list = NULL;
> > > +			xfs_submit_ioend(wbc, ioend_to_submit, 0);
> > > +			ioend_to_submit = next;
> > > +		}
> > > +	} else {
> > >  		xfs_aops_discard_page(page);
> > >  		ClearPageUptodate(page);
> > >  		unlock_page(page);
> > 
> > If we have an error and count == 0, we know that ioend_to_submit is NULL
> > because that is only potentially set once the first buffer is added.
> > That said, this doesn't mean that we don't have an ioend waiting on the
> > wpc. If we do, we still return the error and the ioend is errored out.
> > 
> > I wonder if that is really necessary if we haven't added any buffers
> > from the page..? Could we submit the ioend properly in that case? OTOH,
> > that might complicate the error reporting and an error here might be
> > serious enough that it isn't worth it, as opposed to just making sure we
> > clean up everything appropriately.
> 
> The way I've done it is the same as the existing code - on error the
> entire ioend chain that has been built is errored out. I'd prefer to
> keep it that way right now to minimise the potential behavioural
> changes of the patch series. We can look to changing to partial
> submission in a separate patch set if it makes sense to do so.
> 

I noticed that the existing code is roughly equivalent, so that's fair I
think. Thanks.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
