Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02307C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Mar 2021 01:06:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1E7264DE1
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Mar 2021 01:05:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231512AbhCSBF1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Mar 2021 21:05:27 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:35830 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232139AbhCSBFK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Mar 2021 21:05:10 -0400
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id BFDAE10425AE;
        Fri, 19 Mar 2021 12:05:07 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lN3Za-0048Kp-5a; Fri, 19 Mar 2021 12:05:06 +1100
Date:   Fri, 19 Mar 2021 12:05:06 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 1/2] xfs: set a mount flag when perag reservation is
 active
Message-ID: <20210319010506.GP63242@dread.disaster.area>
References: <20210318161707.723742-1-bfoster@redhat.com>
 <20210318161707.723742-2-bfoster@redhat.com>
 <20210318205536.GO63242@dread.disaster.area>
 <20210318221901.GN22100@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210318221901.GN22100@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=kj9zAlcOel0A:10 a=dESyimp9J3IA:10 a=7-415B0cAAAA:8
        a=Ufu4mrYEM0lq-filU0EA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 18, 2021 at 03:19:01PM -0700, Darrick J. Wong wrote:
> On Fri, Mar 19, 2021 at 07:55:36AM +1100, Dave Chinner wrote:
> > On Thu, Mar 18, 2021 at 12:17:06PM -0400, Brian Foster wrote:
> > > perag reservation is enabled at mount time on a per AG basis. The
> > > upcoming in-core allocation btree accounting mechanism needs to know
> > > when reservation is enabled and that all perag AGF contexts are
> > > initialized. As a preparation step, set a flag in the mount
> > > structure and unconditionally initialize the pagf on all mounts
> > > where at least one reservation is active.
> > 
> > I'm not sure this is a good idea. AFAICT, this means just about any
> > filesystem with finobt, reflink and/or rmap will now typically read
> > every AGF header in the filesystem at mount time. That means pretty
> > much every v5 filesystem in production...
> 
> They already do that, because the AG headers are where we store the
> btree block counts.

Oh, we're brute forcing AG reservation space? I thought we were
doing something smarter than that, because I'm sure this isn't the
first time I've mentioned this problem....

> > We've always tried to avoid needing to reading all AG headers at
> > mount time because that does not scale when we have really large
> > filesystems (I'm talking petabytes here). We should only read AG
> > headers if there is something not fully recovered during the mount
> > (i.e. slow path) and not on every mount.
> > 
> > Needing to do a few thousand synchonous read IOs during mount makes
> > mount very slow, and as such we always try to do dynamic
> > instantiation of AG headers...  Testing I've done with exabyte scale
> > filesystems (>10^6 AGs) show that it can take minutes for mount to
> > run when each AG header needs to be read, and that's on SSDs where
> > the individual read latency is only a couple of hundred
> > microseconds. On spinning disks that can do 200 IOPS, we're
> > potentially talking hours just to mount really large filesystems...
> 
> Is that with reflink enabled?  Reflink always scans the right edge of
> the refcount btree at mount to clean out stale COW staging extents,

Aren't they cleaned up at unmount when the inode is inactivated?
i.e. isn't this something that should only be done on a unclean
mount?

> and
> (prior to the introduction of the inode btree counts feature last year)
> we also ahad to walk the entire finobt to find out how big it is.

ugh, I forgot about the fact we had to add that wart because we
screwed up the space reservations for finobt operations...

As for large scale testing, I suspect I turned everything optional
off when I last did this testing, because mkfs currently requires a
lot of per-AG IO to initialise structures. On an SSD, mkfs.xfs
-K -f -d agcount=10000 ... takes

		mkfs time	mount time
-m crc=0	15s		1s
-m rmapbt=1	25s		6s

Multiply those times by at another 1000 to get to an 8EB
filesystem and the difference is several hours of mkfs time and
a couple of hours of mount time....

So from the numbers, it is pretty likely I didn't test anything that
actually required iterating 8 million AGs at mount time....

> TBH I think the COW recovery and the AG block reservation pieces are
> prime candidates for throwing at an xfs_pwork workqueue so we can
> perform those scans in parallel.

As I mentioned on #xfs, I think we only need to do the AG read if we
are near enospc. i.e. we can take the entire reservation at mount
time (which is fixed per-ag) and only take away the used from the
reservation (i.e. return to the free space pool) when we actually
access the AGF/AGI the first time. Or when we get a ENOSPC
event, which might occur when we try to take the fixed reservation
at mount time...

> > Hence I don't think that any algorithm that requires reading every
> > AGF header in the filesystem at mount time on every v5 filesystem
> > already out there in production (because finobt triggers this) is a
> > particularly good idea...
> 
> Perhaps not, but the horse bolted 5 years ago. :/

Let's go catch it :P

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
