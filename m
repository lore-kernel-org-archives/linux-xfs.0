Return-Path: <SRS0=yuEF=YW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC9B8CA9EB9
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 04:41:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9BD3420862
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 04:41:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731729AbfJ2Eli (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Oct 2019 00:41:38 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:57015 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727294AbfJ2Eli (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Oct 2019 00:41:38 -0400
Received: from dread.disaster.area (pa49-180-67-183.pa.nsw.optusnet.com.au [49.180.67.183])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id B96077E98C6;
        Tue, 29 Oct 2019 15:41:34 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1iPJK1-0000Jo-Cs; Tue, 29 Oct 2019 15:41:33 +1100
Date:   Tue, 29 Oct 2019 15:41:33 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: properly serialise fallocate against AIO+DIO
Message-ID: <20191029044133.GN4614@dread.disaster.area>
References: <20191029034850.8212-1-david@fromorbit.com>
 <20191029041908.GB15222@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191029041908.GB15222@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=3wLbm4YUAFX2xaPZIabsgw==:117 a=3wLbm4YUAFX2xaPZIabsgw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=XobE76Q3jBoA:10
        a=7-415B0cAAAA:8 a=8VJdBDI6uDDErkn2tlAA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 28, 2019 at 09:19:08PM -0700, Darrick J. Wong wrote:
> On Tue, Oct 29, 2019 at 02:48:50PM +1100, Dave Chinner wrote:
> > --- a/fs/xfs/xfs_bmap_util.c
> > +++ b/fs/xfs/xfs_bmap_util.c
> > @@ -1040,6 +1040,7 @@ xfs_unmap_extent(
> >  	goto out_unlock;
> >  }
> >  
> > +/* Caller must first wait for the completion of any pending DIOs if required. */
> >  int
> >  xfs_flush_unmap_range(
> >  	struct xfs_inode	*ip,
> > @@ -1051,9 +1052,6 @@ xfs_flush_unmap_range(
> >  	xfs_off_t		rounding, start, end;
> >  	int			error;
> >  
> > -	/* wait for the completion of any pending DIOs */
> > -	inode_dio_wait(inode);
> 
> Does xfs_reflink_remap_prep still need this function to call inode_dio_wait
> before zapping the page cache prior to reflinking into an existing file?

No, because that is done in generic_remap_file_range_prep() after we
have locked the inodes and broken leases in
xfs_reflink_remap_prep().

> > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > index 525b29b99116..865543e41fb4 100644
> > --- a/fs/xfs/xfs_file.c
> > +++ b/fs/xfs/xfs_file.c
> > @@ -817,6 +817,36 @@ xfs_file_fallocate(
> >  	if (error)
> >  		goto out_unlock;
> >  
> > +	/*
> > +	 * Must wait for all AIO to complete before we continue as AIO can
> > +	 * change the file size on completion without holding any locks we
> > +	 * currently hold. We must do this first because AIO can update both
> > +	 * the on disk and in memory inode sizes, and the operations that follow
> > +	 * require the in-memory size to be fully up-to-date.
> > +	 */
> > +	inode_dio_wait(inode);
> > +
> > +	/*
> > +	 * Now AIO and DIO has drained we flush and (if necessary) invalidate
> > +	 * the cached range over the first operation we are about to run.
> > +	 *
> > +	 * We care about zero and collapse here because they both run a hole
> > +	 * punch over the range first. Because that can zero data, and the range
> > +	 * of invalidation for the shift operations is much larger, we still do
> > +	 * the required flush for collapse in xfs_prepare_shift().
> > +	 *
> > +	 * Insert has the same range requirements as collapse, and we extend the
> > +	 * file first which can zero data. Hence insert has the same
> > +	 * flush/invalidate requirements as collapse and so they are both
> > +	 * handled at the right time by xfs_prepare_shift().
> > +	 */
> > +	if (mode & (FALLOC_FL_PUNCH_HOLE | FALLOC_FL_ZERO_RANGE |
> > +		    FALLOC_FL_COLLAPSE_RANGE)) {
> 
> Er... "Insert has the same requirements as collapse", but we don't test
> for that here?  Also ... xfs_prepare_shift handles flushing for both
> collapse and insert range, but we still have to flush here for collapse?
>
> <confused but suspecting this has something to do with the fact that we
> only do insert range after updating the isize?>

Yes, exactly.

The flush for collapse here is for the hole punch part of collapse,
before we start shifting extents. insert does not hole punch, so it
doesn't need flushing here but it still needs flush/inval before
shifting. i.e.:

collapse				insert

flush_unmap(off, len)
punch hole(off, len)			extends EOF
  writes zeros around (off,len)		  writes zeros around EOF
collapse(off, len)			insert(off, len)
  flush_unmap(off, EOF)			  flush_unmap(off, EOF)
  shift extents down			  shift extents up

So once we start the actual extent shift operation (up or down)
the flush/unmap requirements are identical.

> I think the third paragraph of the comment is just confusing me more.
> Does the following describe what's going on?
> 
> "Insert range has the same range [should this be "page cache flushing"?]
> requirements as collapse.  Because we can zero data as part of extending
> the file size, we skip the flush here and let the flush in
> xfs_prepare_shift take care of invalidating the page cache." ?

It's a bit better - that's kinda what I was trying to describe - but
I'll try to reword it more clearly after I've let it settle in my
head for a little while....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
