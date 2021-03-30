Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5371C433C1
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 14:43:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFB49619C2
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 14:43:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230243AbhC3OnD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Mar 2021 10:43:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25614 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232143AbhC3Om6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Mar 2021 10:42:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617115377;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=u9B+gK+bgIVrTe4AfXqgx77Wued1VkAvra1gTReajPA=;
        b=dZziyfCuTL6OGX+3aolyCMRODYkhmIDG9iHDhUVkbwngJKn/Gs7CoVyShwvkTOedj/DbVn
        BSh5cuf7ouTwy9H/Xju156fjyLtMCZaWAMYpXUryQfNpgpKSRfyTEYk4pkIYJSiED3K0Nx
        432gDKV0VxsKuf6ai8Z26Vj8UxBf74M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-211-FMR9rPTdP9aZrMip5Uojaw-1; Tue, 30 Mar 2021 10:42:53 -0400
X-MC-Unique: FMR9rPTdP9aZrMip5Uojaw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 62D8F881278;
        Tue, 30 Mar 2021 14:42:52 +0000 (UTC)
Received: from bfoster (ovpn-112-117.rdu2.redhat.com [10.10.112.117])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A46D572190;
        Tue, 30 Mar 2021 14:42:50 +0000 (UTC)
Date:   Tue, 30 Mar 2021 10:42:48 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Subject: Re: xfs ioend batching log reservation deadlock
Message-ID: <YGM46ABWNVO5FKld@bfoster>
References: <YF4AOto30pC/0FYW@bfoster>
 <20210326173244.GY4090233@magnolia>
 <20210329022826.GO63242@dread.disaster.area>
 <YGIWqX4pmfsv9LPk@bfoster>
 <20210329235142.GR63242@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210329235142.GR63242@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 30, 2021 at 10:51:42AM +1100, Dave Chinner wrote:
> On Mon, Mar 29, 2021 at 02:04:25PM -0400, Brian Foster wrote:
> > On Mon, Mar 29, 2021 at 01:28:26PM +1100, Dave Chinner wrote:
...
> 
> > @@ -182,12 +185,10 @@ xfs_end_ioend(
> >  		error = xfs_reflink_end_cow(ip, offset, size);
> >  	else if (ioend->io_type == IOMAP_UNWRITTEN)
> >  		error = xfs_iomap_write_unwritten(ip, offset, size, false);
> > -	else
> > -		ASSERT(!xfs_ioend_is_append(ioend) || ioend->io_private);
> >  
> >  done:
> > -	if (ioend->io_private)
> > -		error = xfs_setfilesize_ioend(ioend, error);
> > +	if (ioend->io_flags & IOMAP_F_APPEND)
> > +		error = xfs_setfilesize(ip, offset, size);
> >  	iomap_finish_ioends(ioend, error);
> >  	memalloc_nofs_restore(nofs_flag);
> >  }
> > @@ -221,16 +222,28 @@ xfs_end_io(
> >  	struct iomap_ioend	*ioend;
> >  	struct list_head	tmp;
> >  	unsigned long		flags;
> > +	xfs_off_t		maxendoff;
> >  
> >  	spin_lock_irqsave(&ip->i_ioend_lock, flags);
> >  	list_replace_init(&ip->i_ioend_list, &tmp);
> >  	spin_unlock_irqrestore(&ip->i_ioend_lock, flags);
> >  
> >  	iomap_sort_ioends(&tmp);
> > +
> > +	/* XXX: track max endoff manually? */
> > +	ioend = list_last_entry(&tmp, struct iomap_ioend, io_list);
> > +	if (((ioend->io_flags & IOMAP_F_SHARED) ||
> > +	     (ioend->io_type != IOMAP_UNWRITTEN)) &&
> > +	    xfs_ioend_is_append(ioend)) {
> > +		ioend->io_flags |= IOMAP_F_APPEND;
> > +		maxendoff = ioend->io_offset + ioend->io_size;
> > +	}
> > +
> >  	while ((ioend = list_first_entry_or_null(&tmp, struct iomap_ioend,
> >  			io_list))) {
> >  		list_del_init(&ioend->io_list);
> >  		iomap_ioend_try_merge(ioend, &tmp, xfs_ioend_merge_private);
> > +		ASSERT(ioend->io_offset + ioend->io_size <= maxendoff);
> >  		xfs_end_ioend(ioend);
> >  	}
> >  }
> 
> So now when I run a workload that is untarring a large tarball full
> of small files, we have as many transaction reserve operations
> runnning concurrently as there are IO completions queued.
> 

This patch has pretty much no effect on a typical untar workload because
it is dominated by delalloc -> unwritten extent conversions that already
require completion time transaction reservations. Indeed, a quick test
to untar a kernel source tree produces no setfilesize events at all.

I'm not sure we have many situations upstream where append transactions
are used outside of perhaps cow completions (which already have a
completion time transaction allocation for fork remaps) or intra-block
file extending writes (that thus produce an inode size change within a
mapped, already converted block). Otherwise a truncate down should
always remove post-eof blocks and speculative prealloc originates from
delalloc, so afaict those should follow the same general sequence. Eh?

As it is, I think the performance concern is overstated but I'm happy to
run any tests to confirm or deny that if you want to make more concrete
suggestions. This patch is easy to test and pretty much survived an
overnight regression run (outside of one or two things I have to look
into..). I'm happy to adjust the approach from there, but I also think
if it proves necessary there are fallback options (based around the
original suggestion in my first mail) to preserve current submission
time (serial) append transaction reservation that don't require to
categorize/split or partially process the pending ioend list.

Brian

> Right now, we the single threaded writeback (bdi-flusher) runs
> reservations serially, so we are introducing a large amount of
> concurrency to reservations here. IOWs, instead of throttling active
> reservations before we submit the IO we end up with attempted
> reservations only being bounded by the number of kworkers the
> completion workqueue can throw at the system.  Then we might have
> tens of active filesystems doing the same thing, each with their own
> set of workqueues and kworkers...
> 
> Yes, we can make "lots of IO to a single inode" have less overhead,
> but we do not want to do that at the expense of bad behaviour when
> we have "single IOs to lots of inodes". That's the concern I have
> here, and that's going to take a fair amount of work to characterise
> and measure the impact, especially on large machines with slow
> disks...
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

