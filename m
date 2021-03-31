Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8473DC43461
	for <linux-xfs@archiver.kernel.org>; Wed, 31 Mar 2021 12:34:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8B20619AE
	for <linux-xfs@archiver.kernel.org>; Wed, 31 Mar 2021 12:27:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235399AbhCaM1J (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 31 Mar 2021 08:27:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37675 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235314AbhCaM0w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Mar 2021 08:26:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617193611;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PtXSU1/cPq+5Bk6pXm1kTgyhepDDn+jHjQ5GDsJHlWo=;
        b=G1VZTa5dqTycvaA1svBt1ei4ZJNM92ZWQnM4sO28qt2N77aibkBtsuwNfZcaLdVqczuMVS
        oJ+wulRIxtcMimpDEoiBk7jGLPdcKeQ030uoFetJXIdU+wWUs23XqRkZyDxNwoyDRf/0ol
        Oz4L7ivWIXpM6SpA/4HR9gSM7uoyM5Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-139-EIuAxYg_OgWAw01GGr6ttg-1; Wed, 31 Mar 2021 08:26:49 -0400
X-MC-Unique: EIuAxYg_OgWAw01GGr6ttg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1569183DD21;
        Wed, 31 Mar 2021 12:26:48 +0000 (UTC)
Received: from bfoster (ovpn-112-117.rdu2.redhat.com [10.10.112.117])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7F59D6A902;
        Wed, 31 Mar 2021 12:26:47 +0000 (UTC)
Date:   Wed, 31 Mar 2021 08:26:45 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Subject: Re: xfs ioend batching log reservation deadlock
Message-ID: <YGRqhXB9cGoxwdLE@bfoster>
References: <YF4AOto30pC/0FYW@bfoster>
 <20210326173244.GY4090233@magnolia>
 <20210329022826.GO63242@dread.disaster.area>
 <YGIWqX4pmfsv9LPk@bfoster>
 <20210329235142.GR63242@dread.disaster.area>
 <YGM46ABWNVO5FKld@bfoster>
 <20210330235722.GX63242@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210330235722.GX63242@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 31, 2021 at 10:57:22AM +1100, Dave Chinner wrote:
> On Tue, Mar 30, 2021 at 10:42:48AM -0400, Brian Foster wrote:
> > On Tue, Mar 30, 2021 at 10:51:42AM +1100, Dave Chinner wrote:
> > > On Mon, Mar 29, 2021 at 02:04:25PM -0400, Brian Foster wrote:
> > > > On Mon, Mar 29, 2021 at 01:28:26PM +1100, Dave Chinner wrote:
> > ...
> > > 
> > > > @@ -182,12 +185,10 @@ xfs_end_ioend(
> > > >  		error = xfs_reflink_end_cow(ip, offset, size);
> > > >  	else if (ioend->io_type == IOMAP_UNWRITTEN)
> > > >  		error = xfs_iomap_write_unwritten(ip, offset, size, false);
> > > > -	else
> > > > -		ASSERT(!xfs_ioend_is_append(ioend) || ioend->io_private);
> > > >  
> > > >  done:
> > > > -	if (ioend->io_private)
> > > > -		error = xfs_setfilesize_ioend(ioend, error);
> > > > +	if (ioend->io_flags & IOMAP_F_APPEND)
> > > > +		error = xfs_setfilesize(ip, offset, size);
> > > >  	iomap_finish_ioends(ioend, error);
> > > >  	memalloc_nofs_restore(nofs_flag);
> > > >  }
> > > > @@ -221,16 +222,28 @@ xfs_end_io(
> > > >  	struct iomap_ioend	*ioend;
> > > >  	struct list_head	tmp;
> > > >  	unsigned long		flags;
> > > > +	xfs_off_t		maxendoff;
> > > >  
> > > >  	spin_lock_irqsave(&ip->i_ioend_lock, flags);
> > > >  	list_replace_init(&ip->i_ioend_list, &tmp);
> > > >  	spin_unlock_irqrestore(&ip->i_ioend_lock, flags);
> > > >  
> > > >  	iomap_sort_ioends(&tmp);
> > > > +
> > > > +	/* XXX: track max endoff manually? */
> > > > +	ioend = list_last_entry(&tmp, struct iomap_ioend, io_list);
> > > > +	if (((ioend->io_flags & IOMAP_F_SHARED) ||
> > > > +	     (ioend->io_type != IOMAP_UNWRITTEN)) &&
> > > > +	    xfs_ioend_is_append(ioend)) {
> > > > +		ioend->io_flags |= IOMAP_F_APPEND;
> > > > +		maxendoff = ioend->io_offset + ioend->io_size;
> > > > +	}
> > > > +
> > > >  	while ((ioend = list_first_entry_or_null(&tmp, struct iomap_ioend,
> > > >  			io_list))) {
> > > >  		list_del_init(&ioend->io_list);
> > > >  		iomap_ioend_try_merge(ioend, &tmp, xfs_ioend_merge_private);
> > > > +		ASSERT(ioend->io_offset + ioend->io_size <= maxendoff);
> > > >  		xfs_end_ioend(ioend);
> > > >  	}
> > > >  }
> > > 
> > > So now when I run a workload that is untarring a large tarball full
> > > of small files, we have as many transaction reserve operations
> > > runnning concurrently as there are IO completions queued.
> > > 
> > 
> > This patch has pretty much no effect on a typical untar workload because
> > it is dominated by delalloc -> unwritten extent conversions that already
> > require completion time transaction reservations. Indeed, a quick test
> > to untar a kernel source tree produces no setfilesize events at all.
> 
> Great, so it's not the obvious case because of the previous
> delalloc->unwritten change. What you need to do now is find
> out what workload it is that is generating so many setfilesize
> completions despite delalloc->unwritten so we can understand what
> workloads this will actually impact.
> 

I think the discrepancy here is just that the original problem occurred
on a downstream kernel where per-inode ioend batching exists but the
delalloc -> unwritten change does not. The latter was a relatively more
recent upstream change. The log reservation deadlock vector still exists
regardless (i.e., if there's another source of reservation pressure),
but that probably explains why the append ioends might be more
predominant in the user kernel (and in general why this might be more
likely between upstream v5.2 and v5.9) but less of a concern on current
upstream.

In any event, I think this clarifies that there's no longer much need
for submission side append reservation in current kernels. I'll look
into that change and deal with the downstream kernel separately.

Brian

> > I'm not sure we have many situations upstream where append transactions
> > are used outside of perhaps cow completions (which already have a
> > completion time transaction allocation for fork remaps) or intra-block
> > file extending writes (that thus produce an inode size change within a
> > mapped, already converted block). Otherwise a truncate down should
> > always remove post-eof blocks and speculative prealloc originates from
> > delalloc, so afaict those should follow the same general sequence. Eh?
> > 
> > As it is, I think the performance concern is overstated but I'm happy to
> > run any tests to confirm or deny that if you want to make more concrete
> > suggestions.
> 
> As I said: I'm happy to change the code as long as we understand
> what workloads it will impact and by how much. We don't know what
> workload is generating so many setfilesize transactions yet, so we
> can't actually make educated guesses on the wider impact that this
> change will have. We also don't have numbers from typical workloads,
> just one data point, so nobody actually knows what the impact is.
> 
> > This patch is easy to test and pretty much survived an
> > overnight regression run (outside of one or two things I have to look
> > into..). I'm happy to adjust the approach from there, but I also think
> > if it proves necessary there are fallback options (based around the
> > original suggestion in my first mail) to preserve current submission
> > time (serial) append transaction reservation that don't require to
> > categorize/split or partially process the pending ioend list.
> 
> IO path behaviour changes require more than functional regression
> tests. There is an amount of documented performance regression
> testing that is required, too. The argument being made here is that
> "this won't affect performance", so all I'm asking for is to be
> provided with the evidence that shows this assertion to be true.
> 
> This is part of the reason I suggested breaking this up into
> separate bug fix and removal patches - a pure bug fix doesn't need
> performance regression testing to be done. Further, having the bug
> fix separate to changing the behaviour of the code mitigates the
> risk of finding an unexpected performance regression from changing
> behaviour. Combining the bug fix with a significant change of
> behaviour doesn't provide us with a simple method of addressing such
> a regression...
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

