Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3722C433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 23:58:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7528619D0
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 23:58:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232419AbhC3X5a (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Mar 2021 19:57:30 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:50502 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232101AbhC3X5Z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Mar 2021 19:57:25 -0400
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 201AE104251C;
        Wed, 31 Mar 2021 10:57:23 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lROEc-008fD1-Cu; Wed, 31 Mar 2021 10:57:22 +1100
Date:   Wed, 31 Mar 2021 10:57:22 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Subject: Re: xfs ioend batching log reservation deadlock
Message-ID: <20210330235722.GX63242@dread.disaster.area>
References: <YF4AOto30pC/0FYW@bfoster>
 <20210326173244.GY4090233@magnolia>
 <20210329022826.GO63242@dread.disaster.area>
 <YGIWqX4pmfsv9LPk@bfoster>
 <20210329235142.GR63242@dread.disaster.area>
 <YGM46ABWNVO5FKld@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YGM46ABWNVO5FKld@bfoster>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0 cx=a_idp_x
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=kj9zAlcOel0A:10 a=dESyimp9J3IA:10 a=7-415B0cAAAA:8
        a=VW1m62v1yprszewnqg4A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 30, 2021 at 10:42:48AM -0400, Brian Foster wrote:
> On Tue, Mar 30, 2021 at 10:51:42AM +1100, Dave Chinner wrote:
> > On Mon, Mar 29, 2021 at 02:04:25PM -0400, Brian Foster wrote:
> > > On Mon, Mar 29, 2021 at 01:28:26PM +1100, Dave Chinner wrote:
> ...
> > 
> > > @@ -182,12 +185,10 @@ xfs_end_ioend(
> > >  		error = xfs_reflink_end_cow(ip, offset, size);
> > >  	else if (ioend->io_type == IOMAP_UNWRITTEN)
> > >  		error = xfs_iomap_write_unwritten(ip, offset, size, false);
> > > -	else
> > > -		ASSERT(!xfs_ioend_is_append(ioend) || ioend->io_private);
> > >  
> > >  done:
> > > -	if (ioend->io_private)
> > > -		error = xfs_setfilesize_ioend(ioend, error);
> > > +	if (ioend->io_flags & IOMAP_F_APPEND)
> > > +		error = xfs_setfilesize(ip, offset, size);
> > >  	iomap_finish_ioends(ioend, error);
> > >  	memalloc_nofs_restore(nofs_flag);
> > >  }
> > > @@ -221,16 +222,28 @@ xfs_end_io(
> > >  	struct iomap_ioend	*ioend;
> > >  	struct list_head	tmp;
> > >  	unsigned long		flags;
> > > +	xfs_off_t		maxendoff;
> > >  
> > >  	spin_lock_irqsave(&ip->i_ioend_lock, flags);
> > >  	list_replace_init(&ip->i_ioend_list, &tmp);
> > >  	spin_unlock_irqrestore(&ip->i_ioend_lock, flags);
> > >  
> > >  	iomap_sort_ioends(&tmp);
> > > +
> > > +	/* XXX: track max endoff manually? */
> > > +	ioend = list_last_entry(&tmp, struct iomap_ioend, io_list);
> > > +	if (((ioend->io_flags & IOMAP_F_SHARED) ||
> > > +	     (ioend->io_type != IOMAP_UNWRITTEN)) &&
> > > +	    xfs_ioend_is_append(ioend)) {
> > > +		ioend->io_flags |= IOMAP_F_APPEND;
> > > +		maxendoff = ioend->io_offset + ioend->io_size;
> > > +	}
> > > +
> > >  	while ((ioend = list_first_entry_or_null(&tmp, struct iomap_ioend,
> > >  			io_list))) {
> > >  		list_del_init(&ioend->io_list);
> > >  		iomap_ioend_try_merge(ioend, &tmp, xfs_ioend_merge_private);
> > > +		ASSERT(ioend->io_offset + ioend->io_size <= maxendoff);
> > >  		xfs_end_ioend(ioend);
> > >  	}
> > >  }
> > 
> > So now when I run a workload that is untarring a large tarball full
> > of small files, we have as many transaction reserve operations
> > runnning concurrently as there are IO completions queued.
> > 
> 
> This patch has pretty much no effect on a typical untar workload because
> it is dominated by delalloc -> unwritten extent conversions that already
> require completion time transaction reservations. Indeed, a quick test
> to untar a kernel source tree produces no setfilesize events at all.

Great, so it's not the obvious case because of the previous
delalloc->unwritten change. What you need to do now is find
out what workload it is that is generating so many setfilesize
completions despite delalloc->unwritten so we can understand what
workloads this will actually impact.

> I'm not sure we have many situations upstream where append transactions
> are used outside of perhaps cow completions (which already have a
> completion time transaction allocation for fork remaps) or intra-block
> file extending writes (that thus produce an inode size change within a
> mapped, already converted block). Otherwise a truncate down should
> always remove post-eof blocks and speculative prealloc originates from
> delalloc, so afaict those should follow the same general sequence. Eh?
> 
> As it is, I think the performance concern is overstated but I'm happy to
> run any tests to confirm or deny that if you want to make more concrete
> suggestions.

As I said: I'm happy to change the code as long as we understand
what workloads it will impact and by how much. We don't know what
workload is generating so many setfilesize transactions yet, so we
can't actually make educated guesses on the wider impact that this
change will have. We also don't have numbers from typical workloads,
just one data point, so nobody actually knows what the impact is.

> This patch is easy to test and pretty much survived an
> overnight regression run (outside of one or two things I have to look
> into..). I'm happy to adjust the approach from there, but I also think
> if it proves necessary there are fallback options (based around the
> original suggestion in my first mail) to preserve current submission
> time (serial) append transaction reservation that don't require to
> categorize/split or partially process the pending ioend list.

IO path behaviour changes require more than functional regression
tests. There is an amount of documented performance regression
testing that is required, too. The argument being made here is that
"this won't affect performance", so all I'm asking for is to be
provided with the evidence that shows this assertion to be true.

This is part of the reason I suggested breaking this up into
separate bug fix and removal patches - a pure bug fix doesn't need
performance regression testing to be done. Further, having the bug
fix separate to changing the behaviour of the code mitigates the
risk of finding an unexpected performance regression from changing
behaviour. Combining the bug fix with a significant change of
behaviour doesn't provide us with a simple method of addressing such
a regression...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
