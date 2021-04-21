Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 933E8C433B4
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Apr 2021 01:45:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D2E261414
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Apr 2021 01:45:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234566AbhDUBqG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Apr 2021 21:46:06 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:44709 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233824AbhDUBqG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Apr 2021 21:46:06 -0400
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 6BCDA1AF245;
        Wed, 21 Apr 2021 11:45:31 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lZ1vi-00093N-EE; Wed, 21 Apr 2021 11:45:26 +1000
Date:   Wed, 21 Apr 2021 11:45:26 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>,
        Zorro Lang <zlang@redhat.com>,
        Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH v2 1/2] xfs: don't use in-core per-cpu fdblocks for
 !lazysbcount
Message-ID: <20210421014526.GY63242@dread.disaster.area>
References: <20210420110855.2961626-1-hsiangkao@redhat.com>
 <20210420212506.GW63242@dread.disaster.area>
 <20210420215443.GA3047037@xiangao.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210420215443.GA3047037@xiangao.remote.csb>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_f
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=kj9zAlcOel0A:10 a=3YhXtTcJ-WEA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=cPLtFq51bHYXcaQvEJcA:9 a=Gmkubsq3eDupCBqv:21 a=rfT0HIrgvV7QBYhg:21
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 21, 2021 at 05:54:43AM +0800, Gao Xiang wrote:
> Hi Dave,
> 
> On Wed, Apr 21, 2021 at 07:25:06AM +1000, Dave Chinner wrote:
> > On Tue, Apr 20, 2021 at 07:08:54PM +0800, Gao Xiang wrote:
> > > There are many paths which could trigger xfs_log_sb(), e.g.
> > >   xfs_bmap_add_attrfork()
> > >     -> xfs_log_sb()
> > > , which overrides on-disk fdblocks by in-core per-CPU fdblocks.
> > > 
> > > However, for !lazysbcount cases, on-disk fdblocks is actually updated
> > > by xfs_trans_apply_sb_deltas(), and generally it isn't equal to
> > > in-core per-CPU fdblocks due to xfs_reserve_blocks() or whatever,
> > > see the comment in xfs_unmountfs().
> > > 
> > > It could be observed by the following steps reported by Zorro:
> > > 
> > > 1. mkfs.xfs -f -l lazy-count=0 -m crc=0 $dev
> > > 2. mount $dev $mnt
> > > 3. fsstress -d $mnt -p 100 -n 1000 (maybe need more or less io load)
> > > 4. umount $mnt
> > > 5. xfs_repair -n $dev
> > > 
> > > yet due to commit f46e5a174655 ("xfs: fold sbcount quiesce logging
> > > into log covering"), xfs_sync_sb() will also be triggered if log
> > > covering is needed and !lazysbcount when xfs_unmountfs(), so hard
> > > to reproduce on kernel 5.12+ for clean unmount.
> > > 
> > > on-disk sb_icount and sb_ifree are also updated in
> > > xfs_trans_apply_sb_deltas() for !lazysbcount cases, however, which
> > > are always equal to per-CPU counters, so only fdblocks matters.
> > > 
> > > After this patch, I've seen no strange so far on older kernels
> > > for the testcase above without lazysbcount.
> > > 
> > > Reported-by: Zorro Lang <zlang@redhat.com>
> > > Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
> > > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > > ---
> > > changes since v1:
> > >  - update commit message.
> > > 
> > >  fs/xfs/libxfs/xfs_sb.c | 8 +++++++-
> > >  1 file changed, 7 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> > > index 60e6d255e5e2..423dada3f64c 100644
> > > --- a/fs/xfs/libxfs/xfs_sb.c
> > > +++ b/fs/xfs/libxfs/xfs_sb.c
> > > @@ -928,7 +928,13 @@ xfs_log_sb(
> > >  
> > >  	mp->m_sb.sb_icount = percpu_counter_sum(&mp->m_icount);
> > >  	mp->m_sb.sb_ifree = percpu_counter_sum(&mp->m_ifree);
> > > -	mp->m_sb.sb_fdblocks = percpu_counter_sum(&mp->m_fdblocks);
> > > +	if (!xfs_sb_version_haslazysbcount(&mp->m_sb)) {
> > > +		struct xfs_dsb	*dsb = bp->b_addr;
> > > +
> > > +		mp->m_sb.sb_fdblocks = be64_to_cpu(dsb->sb_fdblocks);
> > > +	} else {
> > > +		mp->m_sb.sb_fdblocks = percpu_counter_sum(&mp->m_fdblocks);
> > > +	}
> > 
> > THis really needs a comment explaining why this is done this way.
> > It's not obvious from reading the code why we pull the the fdblock
> > count off disk and then, in  xfs_sb_to_disk(), we write it straight
> > back to disk.
> > 
> > It's also not clear to me that summing the inode counters is correct
> > in the case of the !lazysbcount for the similar reasons - the percpu
> > counter is not guaranteed to be absolutely accurate here, yet the
> > values in the disk buffer are. Perhaps we should be updating the
> > m_sb values in xfs_trans_apply_sb_deltas() for the !lazycount case,
> > and only summing them here for the lazycount case...
> 
> But if updating m_sb values in xfs_trans_apply_sb_deltas(), we
> should also update on-disk sb counters in xfs_trans_apply_sb_deltas()
> and log sb for !lazysbcount (since for such cases, sb counter update
> should be considered immediately.)

I don't follow - xfs_trans_apply_sb_deltas() already logs the
changes to the superblock made in the transaction.

xfs_trans_unreserve_and_mod_sb() does the in-memory counter updates
after xfs_trans_apply_sb_deltas() applies them to the on-disk
superblock in the buffer and logs them.

But nowhere on a !lazysbcount setup are mp->m_sb.sb_fdcount/ifree/
icount values being updated, and hence they are not valid at any
time except for during log quiesce where all the in memory
reservations have been removed and the per-cpu counters are synced
to mp->m_sb.

I'm suggesting that xfs_trans_unreserve_and_mod_sb() also updates
the mp->m_sb.sb_fdcount/ifree/icount values for !lazysbcount, as we
currently do not do this and this will keep them uptodate for any
caller of xfs_sb_to_disk().

i.e. we have three choices:

1. avoid writing the counters in xfs_sb_to_disk() for !lazycount.
2. read them from the buffer before writing them back to the buffer.
3. keep them up to date correctly via xfs_trans_unreserve_and_mod_sb.

#1 is bad because there are cases where we want to write the
counters even for !lazysbcount filesystems (e.g. mkfs, repair, etc).

#2 is essentially a hack around the fact that mp->m_sb is not kept
up to date in the in-memory superblock for !lazysbcount filesystems.

#3 keeps the in-memory superblock up to date for !lazysbcount case
so they are coherent with the on-disk values and hence we only need
to update the in-memory superblock counts for lazysbcount
filesystems before calling xfs_sb_to_disk().

#3 is my preferred solution.

> That will indeed cause more modification, I'm not quite sure if it's
> quite ok honestly. But if you assume that's more clear, I could submit
> an alternative instead later.

I think the version you posted doesn't fix the entire problem. It
merely slaps a band-aid over the symptom that is being seen, and
doesn't address all the non-coherent data that can be written to the
superblock here.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
