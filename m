Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4531C433DB
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Mar 2021 01:35:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE92264E6B
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Mar 2021 01:35:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbhCSBey (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Mar 2021 21:34:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:49714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230049AbhCSBee (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 18 Mar 2021 21:34:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8161A64E45;
        Fri, 19 Mar 2021 01:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616117674;
        bh=fxd5cPLKXMijFoty7ns+2iZQRnp4ElyuPcRkia0eK8w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=u38dTFU5CS6p7E7+uA6XC0BxYrKqBktxaE6aiGI7OM2uKprEwDNe5fvXlnYsloi0/
         To7TpfClaDKCQ00BUUjdj73aizsZjsTPZsKlFpjoSwz3b9wj3bFCKu5NOrrl2L0Czq
         vF7e7PKgkrJOyTLQqPFqWBWqwlu9WUFxknArAvLQPkwrZJNbZ4mVsK1KAGztE+p/a7
         ySLk1gZfMSDPgZeZkfZ6yUInl3RE4DLpkQRet3sjtbpVBFQDJ1RQY6tG0WK06uwlAC
         bd0JfC5m9LehmXdw+yGqVkZOEVhEoQSawgHXLxFhuYGjbK44nU0OYvHdx8tbGwlzVB
         HYNQxSdxi/jVA==
Date:   Thu, 18 Mar 2021 18:34:30 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 1/2] xfs: set a mount flag when perag reservation is
 active
Message-ID: <20210319013430.GO22100@magnolia>
References: <20210318161707.723742-1-bfoster@redhat.com>
 <20210318161707.723742-2-bfoster@redhat.com>
 <20210318205536.GO63242@dread.disaster.area>
 <20210318221901.GN22100@magnolia>
 <20210319010506.GP63242@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210319010506.GP63242@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 19, 2021 at 12:05:06PM +1100, Dave Chinner wrote:
> On Thu, Mar 18, 2021 at 03:19:01PM -0700, Darrick J. Wong wrote:
> > On Fri, Mar 19, 2021 at 07:55:36AM +1100, Dave Chinner wrote:
> > > On Thu, Mar 18, 2021 at 12:17:06PM -0400, Brian Foster wrote:
> > > > perag reservation is enabled at mount time on a per AG basis. The
> > > > upcoming in-core allocation btree accounting mechanism needs to know
> > > > when reservation is enabled and that all perag AGF contexts are
> > > > initialized. As a preparation step, set a flag in the mount
> > > > structure and unconditionally initialize the pagf on all mounts
> > > > where at least one reservation is active.
> > > 
> > > I'm not sure this is a good idea. AFAICT, this means just about any
> > > filesystem with finobt, reflink and/or rmap will now typically read
> > > every AGF header in the filesystem at mount time. That means pretty
> > > much every v5 filesystem in production...
> > 
> > They already do that, because the AG headers are where we store the
> > btree block counts.
> 
> Oh, we're brute forcing AG reservation space? I thought we were
> doing something smarter than that, because I'm sure this isn't the
> first time I've mentioned this problem....

Probably not... :)

> > > We've always tried to avoid needing to reading all AG headers at
> > > mount time because that does not scale when we have really large
> > > filesystems (I'm talking petabytes here). We should only read AG
> > > headers if there is something not fully recovered during the mount
> > > (i.e. slow path) and not on every mount.
> > > 
> > > Needing to do a few thousand synchonous read IOs during mount makes
> > > mount very slow, and as such we always try to do dynamic
> > > instantiation of AG headers...  Testing I've done with exabyte scale
> > > filesystems (>10^6 AGs) show that it can take minutes for mount to
> > > run when each AG header needs to be read, and that's on SSDs where
> > > the individual read latency is only a couple of hundred
> > > microseconds. On spinning disks that can do 200 IOPS, we're
> > > potentially talking hours just to mount really large filesystems...
> > 
> > Is that with reflink enabled?  Reflink always scans the right edge of
> > the refcount btree at mount to clean out stale COW staging extents,
> 
> Aren't they cleaned up at unmount when the inode is inactivated?

Yes.  Or when the blockgc timeout expires, or when ENOSPC pushes
blockgc...

> i.e. isn't this something that should only be done on a unclean
> mount?

Years ago (back when reflink was experimental) we left it that way so
that if there were any serious implementation bugs we wouldn't leak
blocks everywhere.  I think we forgot to take it out.

> > and
> > (prior to the introduction of the inode btree counts feature last year)
> > we also ahad to walk the entire finobt to find out how big it is.
> 
> ugh, I forgot about the fact we had to add that wart because we
> screwed up the space reservations for finobt operations...

Yeah.

> As for large scale testing, I suspect I turned everything optional
> off when I last did this testing, because mkfs currently requires a
> lot of per-AG IO to initialise structures. On an SSD, mkfs.xfs
> -K -f -d agcount=10000 ... takes
> 
> 		mkfs time	mount time
> -m crc=0	15s		1s
> -m rmapbt=1	25s		6s
> 
> Multiply those times by at another 1000 to get to an 8EB
> filesystem and the difference is several hours of mkfs time and
> a couple of hours of mount time....
> 
> So from the numbers, it is pretty likely I didn't test anything that
> actually required iterating 8 million AGs at mount time....
> 
> > TBH I think the COW recovery and the AG block reservation pieces are
> > prime candidates for throwing at an xfs_pwork workqueue so we can
> > perform those scans in parallel.

[This didn't turn out to be difficult at all.]

> As I mentioned on #xfs, I think we only need to do the AG read if we
> are near enospc. i.e. we can take the entire reservation at mount
> time (which is fixed per-ag) and only take away the used from the
> reservation (i.e. return to the free space pool) when we actually
> access the AGF/AGI the first time. Or when we get a ENOSPC
> event, which might occur when we try to take the fixed reservation
> at mount time...

<nod> That's probably not hard.  Compute the theoretical maximum size of
the finobt/rmapbt/refcountbt, multiply that by the number of AGs, try to
reserve that much, and if we get it, we can trivially initialise the
per-AG reservation structure.  If that fails, we fall back to the
scanning thing we do now:

When we set pag[if]_init in the per-AG structure, we can back off the
space reservation by the number of blocks in the trees tracked by that
AG header, which will add that quantity to fdblocks.  We can handle the
ENOSPC case by modifying the per-AG blockgc worker to load the AGF/AGI
if they aren't already.

> > > Hence I don't think that any algorithm that requires reading every
> > > AGF header in the filesystem at mount time on every v5 filesystem
> > > already out there in production (because finobt triggers this) is a
> > > particularly good idea...
> > 
> > Perhaps not, but the horse bolted 5 years ago. :/
> 
> Let's go catch it :P

FWIW I previously fixed the rmapbt/reflink transaction reservations
being unnecessarily large, so (provided deferred inode inactivation gets
reviewed this cycle) I can try to put all these reflink cleanups
together for the next cycle.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
