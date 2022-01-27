Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C8BFC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Jan 2022 05:26:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236140AbiA0F0O (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Jan 2022 00:26:14 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:54576 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232519AbiA0F0O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jan 2022 00:26:14 -0500
Received: from dread.disaster.area (pa49-179-45-11.pa.nsw.optusnet.com.au [49.179.45.11])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 23FF610C3A3C;
        Thu, 27 Jan 2022 16:26:10 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nCxIP-004iFi-2x; Thu, 27 Jan 2022 16:26:09 +1100
Date:   Thu, 27 Jan 2022 16:26:09 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        Ian Kent <raven@themaw.net>, rcu@vger.kernel.org
Subject: Re: [PATCH] xfs: require an rcu grace period before inode recycle
Message-ID: <20220127052609.GR59729@dread.disaster.area>
References: <20220121142454.1994916-1-bfoster@redhat.com>
 <Ye6/g+XMSyp9vYvY@bfoster>
 <20220124220853.GN59729@dread.disaster.area>
 <Ye82TgBY0VmtTjMc@bfoster>
 <20220125003120.GO59729@dread.disaster.area>
 <YfBBzHascwVnefYY@bfoster>
 <20220125224551.GQ59729@dread.disaster.area>
 <YfIdVq6R6xEWxy0K@zeniv-ca.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YfIdVq6R6xEWxy0K@zeniv-ca.linux.org.uk>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=61f22cf4
        a=Eslsx4mF8WGvnV49LKizaA==:117 a=Eslsx4mF8WGvnV49LKizaA==:17
        a=kj9zAlcOel0A:10 a=DghFqjY3_ZEA:10 a=7-415B0cAAAA:8
        a=nZltufVJPc1T6_cCs24A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 27, 2022 at 04:19:34AM +0000, Al Viro wrote:
> On Wed, Jan 26, 2022 at 09:45:51AM +1100, Dave Chinner wrote:
> 
> > Right, background inactivation does not improve performance - it's
> > necessary to get the transactions out of the evict() path. All we
> > wanted was to ensure that there were no performance degradations as
> > a result of background inactivation, not that it was faster.
> > 
> > If you want to confirm that there is an increase in cold cache
> > access when the batch size is increased, cpu profiles with 'perf
> > top'/'perf record/report' and CPU cache performance metric reporting
> > via 'perf stat -dddd' are your friend. See elsewhere in the thread
> > where I mention those things to Paul.
> 
> Dave, do you see a plausible way to eventually drop Ian's bandaid?
> I'm not asking for that to happen this cycle and for backports Ian's
> patch is obviously fine.

Yes, but not in the near term.

> What I really want to avoid is the situation when we are stuck with
> keeping that bandaid in fs/namei.c, since all ways to avoid seeing
> reused inodes would hurt XFS too badly.  And the benchmarks in this
> thread do look like that.

The simplest way I think is to have the XFS inode allocation track
"busy inodes" in the same way we track "busy extents". A busy extent
is an extent that has been freed by the user, but is not yet marked
free in the journal/on disk. If we try to reallocate that busy
extent, we either select a different free extent to allocate, or if
we can't find any we force the journal to disk, wait for it to
complete (hence unbusying the extents) and retry the allocation
again.

We can do something similar for inode allocation - it's actually a
lockless tag lookup on the radix tree entry for the candidate inode
number. If we find the reclaimable radix tree tag set, the we select
a different inode. If we can't allocate a new inode, then we kick
synchronize_rcu() and retry the allocation, allowing inodes to be
recycled this time.

> Are there any realistic prospects of having xfs_iget() deal with
> reuse case by allocating new in-core inode and flipping whatever
> references you've got in XFS journalling data structures to the
> new copy?  If I understood what you said on IRC correctly, that is...

That's ... much harder.

One of the problems is that once an inode has a log item attached to
it, it assumes that it can be accessed without specific locking,
etc. see xfs_inode_clean(), for example. So there's some life-cycle
stuff that needs to be taken care of in XFS first, and the inode <->
log item relationship is tangled.

I've been working towards removing that tangle - but taht stuff is
quite a distance down my logging rework patch queue. THat queue has
been stuck now for a year trying to get the first handful of rework
and scalability modifications reviewed and merged, so I'm not
holding my breathe as to how long a more substantial rework of
internal logging code will take to review and merge.

Really, though, we need the inactivation stuff to be done as part of
the VFS inode lifecycle. I have some ideas on what to do here, but I
suspect we'll need some changes to iput_final()/evict() to allow us
to process final unlinks in the bakground and then call evict()
ourselves when the unlink completes. That way ->destroy_inode() can
just call xfs_reclaim_inode() to free it directly, which also helps
us get rid of background inode freeing and hence inode recycling
from XFS altogether. I think we _might_ be able to do this without
needing to change any of the logging code in XFS, but I haven't
looked any further than this into it as yet.

> Again, I'm not asking if it can be done this cycle; having a
> realistic path to doing that eventually would be fine by me.

We're talking a year at least, probably two, before we get there...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
