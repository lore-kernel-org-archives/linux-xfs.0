Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99D01C433FE
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Jan 2022 19:45:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234382AbiANTpR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 14 Jan 2022 14:45:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:34228 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239565AbiANTpP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Jan 2022 14:45:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642189515;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eyjSjjSANir6SkRS29KCWlHMsYZlzZpC8iEkvkPdVCw=;
        b=JxnEOFoATcrYct58dMNXACKTaGdg1r42uEmxn9W8XPnCCL6OTuGEGqupiQS/E+A6X7nmub
        Z0xeGvIcYXcmdCdOpTZPSVQWK37Os0FE9UHswP/IWq8D3ruUL1iV4yi3MErBn5PBgF6pK7
        niykNhgfK+7gFLgMLhVvSmgIGByRP10=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-201-C_qDqnhUPJK0dNnqiyFbiQ-1; Fri, 14 Jan 2022 14:45:13 -0500
X-MC-Unique: C_qDqnhUPJK0dNnqiyFbiQ-1
Received: by mail-qv1-f71.google.com with SMTP id f7-20020a056214076700b0041161d5b77bso9325477qvz.22
        for <linux-xfs@vger.kernel.org>; Fri, 14 Jan 2022 11:45:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eyjSjjSANir6SkRS29KCWlHMsYZlzZpC8iEkvkPdVCw=;
        b=gLAjJ8MlAyX5wx/rwtFBQvfgeQWBSqyBGC4vHtGFApr/A9Fs20PybnHPksaYqCNWib
         Zjo8u6oey0bY11u30P3iOJN/UZGdCAgKK76wqXU8yeUAQXFbd0WJJ1UyZrCjYLO0kKsi
         MmryE4pYnqwvGNRJEOlwZvsHx/dYuwIqcLQQPNF91bIyxb3nBYy9rYPUX3mIDu/DVurg
         lUBE2MkyjrDD1k5lESCEO2awyz+wneAI+3/KNVbjaNrE5TJYwz88gnAUVRx1V2mpzI4F
         FFfJ7YibQ0giE1crs3+XBVWzxc40psFzNi4IkhBMZlfoG5zFGaANkLvK43Xy4iOGN6ys
         /BXw==
X-Gm-Message-State: AOAM533SLJIm0V02RDkDyEYugzKFl/t7QZdPeLnSL5pWpufX58rKtpE3
        +BJ+zEx5v4lzef1lLt6V1ALrDn/LSkdokt8o8KMAkbic/NVzRPmTLoTpiOW3hxfPi2IHLejUe9t
        ZTuQ/HlO8CgXb+SsHKGYS
X-Received: by 2002:a05:6214:20e9:: with SMTP id 9mr9640413qvk.104.1642189513274;
        Fri, 14 Jan 2022 11:45:13 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx6tnl46uXAxsb5p6XvMJGR97fPkkc2zmFdISEbEsUOcprUlHJTuvD0UbQfouz06DGXZXEOKQ==
X-Received: by 2002:a05:6214:20e9:: with SMTP id 9mr9640377qvk.104.1642189512845;
        Fri, 14 Jan 2022 11:45:12 -0800 (PST)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id w14sm4490953qta.6.2022.01.14.11.45.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 11:45:12 -0800 (PST)
Date:   Fri, 14 Jan 2022 14:45:10 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: run blockgc on freeze to avoid iget stalls
 after reclaim
Message-ID: <YeHSxg3HrZipaLJg@bfoster>
References: <20220113133701.629593-1-bfoster@redhat.com>
 <20220113133701.629593-3-bfoster@redhat.com>
 <20220113223810.GG3290465@dread.disaster.area>
 <20220114173535.GA90423@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220114173535.GA90423@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jan 14, 2022 at 09:35:35AM -0800, Darrick J. Wong wrote:
> On Fri, Jan 14, 2022 at 09:38:10AM +1100, Dave Chinner wrote:
> > On Thu, Jan 13, 2022 at 08:37:01AM -0500, Brian Foster wrote:
> > > We've had reports on distro (pre-deferred inactivation) kernels that
> > > inode reclaim (i.e. via drop_caches) can deadlock on the s_umount
> > > lock when invoked on a frozen XFS fs. This occurs because
> > > drop_caches acquires the lock and then blocks in xfs_inactive() on
> > > transaction alloc for an inode that requires an eofb trim. unfreeze
> > > then blocks on the same lock and the fs is deadlocked.
> > > 
> > > With deferred inactivation, the deadlock problem is no longer
> > > present because ->destroy_inode() no longer blocks whether the fs is
> > > frozen or not. There is still unfortunate behavior in that lookups
> > > of a pending inactive inode spin loop waiting for the pending
> > > inactive state to clear, which won't happen until the fs is
> > > unfrozen. This was always possible to some degree, but is
> > > potentially amplified by the fact that reclaim no longer blocks on
> > > the first inode that requires inactivation work. Instead, we
> > > populate the inactivation queues indefinitely. The side effect can
> > > be observed easily by invoking drop_caches on a frozen fs previously
> > > populated with eofb and/or cowblocks inodes and then running
> > > anything that relies on inode lookup (i.e., ls).
> > > 
> > > To mitigate this behavior, invoke internal blockgc reclaim during
> > > the freeze sequence to guarantee that inode eviction doesn't lead to
> > > this state due to eofb or cowblocks inodes. This is similar to
> > > current behavior on read-only remount. Since the deadlock issue was
> > > present for such a long time, also document the subtle
> > > ->destroy_inode() constraint to avoid unintentional reintroduction
> > > of the deadlock problem in the future.
> > > 
> > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > ---
> > >  fs/xfs/xfs_super.c | 19 +++++++++++++++++--
> > >  1 file changed, 17 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > > index c7ac486ca5d3..1d0f87e47fa4 100644
> > > --- a/fs/xfs/xfs_super.c
> > > +++ b/fs/xfs/xfs_super.c
> > > @@ -623,8 +623,13 @@ xfs_fs_alloc_inode(
> > >  }
> > >  
> > >  /*
> > > - * Now that the generic code is guaranteed not to be accessing
> > > - * the linux inode, we can inactivate and reclaim the inode.
> > > + * Now that the generic code is guaranteed not to be accessing the inode, we can
> > > + * inactivate and reclaim it.
> > > + *
> > > + * NOTE: ->destroy_inode() can be called (with ->s_umount held) while the
> > > + * filesystem is frozen. Therefore it is generally unsafe to attempt transaction
> > > + * allocation in this context. A transaction alloc that blocks on frozen state
> > > + * from a context with ->s_umount held will deadlock with unfreeze.
> > >   */
> > >  STATIC void
> > >  xfs_fs_destroy_inode(
> > > @@ -764,6 +769,16 @@ xfs_fs_sync_fs(
> > >  	 * when the state is either SB_FREEZE_FS or SB_FREEZE_COMPLETE.
> > >  	 */
> > >  	if (sb->s_writers.frozen == SB_FREEZE_PAGEFAULT) {
> > > +		struct xfs_icwalk	icw = {0};
> > > +
> > > +		/*
> > > +		 * Clear out eofb and cowblocks inodes so eviction while frozen
> > > +		 * doesn't leave them sitting in the inactivation queue where
> > > +		 * they cannot be processed.
> > > +		 */
> > > +		icw.icw_flags = XFS_ICWALK_FLAG_SYNC;
> > > +		xfs_blockgc_free_space(mp, &icw);
> > 
> > Is a SYNC walk safe to run here? I know we run
> > xfs_blockgc_free_space() from XFS_IOC_FREE_EOFBLOCKS under
> > SB_FREEZE_WRITE protection, but here we have both frozen writes and
> > page faults we're running in a much more constrained freeze context
> > here.
> > 
> > i.e. the SYNC walk will keep busy looping if it can't get the
> > IOLOCK_EXCL on an inode that is in cache, so if we end up with an
> > inode locked and blocked on SB_FREEZE_WRITE or SB_FREEZE_PAGEFAULT
> > for whatever reason this will never return....
> 
> Are you referring to the case where one could be read()ing from a file
> into a buffer that's really a mmap'd page from another file while the
> underlying fs is being frozen?
> 

I thought this was generally safe as freeze protection sits outside of
the locks, but I'm not terribly sure about the read to a mapped buffer
case. If that allows an iolock holder to block on a pagefault due to
freeze, then SB_FREEZE_PAGEFAULT might be too late for a synchronous
scan (i.e. assuming nothing blocks this earlier or prefaults/pins the
target buffer)..?

> Also, I added this second patch and fstests runtime went up by 30%.
> ISTR Dave commenting that freeze time would go way up when I submitted a
> patch to clean out the cow blocks a few years ago.
> 

Do you have any more detailed data on this? I.e., is this an increase
across the board? A smaller set of tests doing many freezes with a
significant runtime increase?

I'm a little on the fence about this because personally, I'm not
terribly concerned about the performance of a single freeze call. At the
same time, I could see this adding up across hundreds of cycles or
whatever via a test or test suite, and that being potentially annoying
to devs/testers.

> Also also looking through the archives[1], Brian once commented that
> cleaning up all this stuff should be done /if/ one decides to mount the
> frozen-snapshot writable at some later point in time.
> 

That kind of sounds like the tradeoff of impacting the current/active fs
for the benefit of a snapshot that may or may not be used. If not, then
it's a waste of time. If so, it might be beneficial for the snap to more
accurately reflect the "eventual" state of the original. For cowblocks
perhaps it doesn't matter if the mount/recovery will scan and reclaim.
I'm not as sure for eofblocks, wouldn't the snap persist all that
"intended to be transient" speculative prealloc until/unless said files
are reopened/closed?

> Maybe this means we ought to find a way to remove inodes from the percpu
> inactivation lists?  iget used to be able to pry inodes out of deferred
> inactivation...
> 

Seems a reasonable option. Presumably that mitigates the lookup stalling
behavior without the need for any additional scanning work at freeze
time (and maybe eliminates the need for an inodegc flush too), but is
neutral wrt some of the other tradeoffs (like the above). I think the
former is the big question wrt to deferred inactivation whereas the
latter has been the case forever.

BTW, should we care at all about somebody dropping the entire cached
working set (worst case) onto these queues if the fs is frozen? Maybe
not if we have to cycle through all these inodes anyways for a full
working set eviction, and presumably a large evictor task (i.e.
drop_caches) will minimize the percpu queue distribution...

Brian

> [1] https://lore.kernel.org/linux-xfs/20190117181406.GF37591@bfoster/
> 
> --D
> 
> > Cheers,
> > 
> > Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com
> 

