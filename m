Return-Path: <SRS0=lEGq=6I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2CCAC2BA19
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Apr 2020 01:39:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BAD5920736
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Apr 2020 01:39:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbgDXBjw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Apr 2020 21:39:52 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:60569 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726050AbgDXBjw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Apr 2020 21:39:52 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 401713A2C87;
        Fri, 24 Apr 2020 11:39:49 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jRnJk-0001Pg-HH; Fri, 24 Apr 2020 11:39:48 +1000
Date:   Fri, 24 Apr 2020 11:39:48 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Wengang Wang <wen.gang.wang@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: don't change to infinate lock to avoid dead lock
Message-ID: <20200424013948.GA2040@dread.disaster.area>
References: <20200423172325.8595-1-wen.gang.wang@oracle.com>
 <20200423230515.GZ27860@dread.disaster.area>
 <ed040889-5f79-e4f5-a203-b7ad8aa701d4@oracle.com>
 <bca65738-3deb-ef43-6dde-1c2402942032@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bca65738-3deb-ef43-6dde-1c2402942032@oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=kj9zAlcOel0A:10 a=cl8xLZFz6L8A:10 a=7-415B0cAAAA:8
        a=j8cJmkS9vZKIg36VjacA:9 a=OjJQibJGqstAk6eR:21 a=WwawbXzgeaWrzpGV:21
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 23, 2020 at 04:19:52PM -0700, Wengang Wang wrote:
> 
> On 4/23/20 4:14 PM, Wengang Wang wrote:
> > 
> > On 4/23/20 4:05 PM, Dave Chinner wrote:
> > > On Thu, Apr 23, 2020 at 10:23:25AM -0700, Wengang Wang wrote:
> > > > xfs_reclaim_inodes_ag() do infinate locking on
> > > > pag_ici_reclaim_lock at the
> > > > 2nd round of walking of all AGs when SYNC_TRYLOCK is set
> > > > (conditionally).
> > > > That causes dead lock in a special situation:
> > > > 
> > > > 1) In a heavy memory load environment, process A is doing direct memory
> > > > reclaiming waiting for xfs_inode.i_pincount to be cleared while holding
> > > > mutex lock pag_ici_reclaim_lock.
> > > > 
> > > > 2) i_pincount is increased by adding the xfs_inode to journal
> > > > transection,
> > > > and it's expected to be decreased when the transection related
> > > > IO is done.
> > > > Step 1) happens after i_pincount is increased and before
> > > > truansection IO is
> > > > issued.
> > > > 
> > > > 3) Now the transection IO is issued by process B. In the IO path
> > > > (IO could
> > > > be more complex than you think), memory allocation and memory direct
> > > > reclaiming happened too.
> > > Sure, but IO path allocations are done under GFP_NOIO context, which
> > > means IO path allocations can't recurse back into filesystem reclaim
> > > via direct reclaim. Hence there should be no way for an IO path
> > > allocation to block on XFS inode reclaim and hence there's no
> > > possible deadlock here...
> > > 
> > > IOWs, I don't think this is the deadlock you are looking for. Do you
> > > have a lockdep report or some other set of stack traces that lead
> > > you to this point?
> > 
> > As I mentioned, the IO path can be more complex than you think.

I don't think the IO path is complex. I *know* the IO path is
complex. I also know how we manage that complexity to prevent things
like stacked devices and filesystems from deadlocking, but I also
know that there are bugs and other architectural deficiencies that
may be playing a part here.

The problem is, your description of the problem tells me nothing
about where the problem might lie. You are telling me what you think
the problem is, rather than explaining the way the problem comes
about, what storage stack configuration and IO behaviour triggers
it, etc. Hence I cannot determine what the problem you are seeing
actually is, and hence I cannot evaluate whether your patch is
correct.

> > The real case I hit is that the process A is waiting for inode unpin on
> > XFS A which is a loop device backed mount.
> 
> And actually, there is a dm-thin on top of the loop device..

Makes no difference, really, because it's still the loop device
that is doing the IO to the underlying filesystem...

> > And the backing file is from a different (X)FS B mount. So the IO is
> > going through loop device, (direct) writes to (X)FS B.
> > 
> > The (direct) writes to (X)FS B do memory allocations and then memory
> > direct reclaims...

THe loop device issues IO to the lower filesystem in
memalloc_noio_save() context, which means all memory allocations in
it's IO path are done with GFP_NOIO context. Hence those allocations
will not recurse into reclaim on -any filesystem- and hence will not
deadlock on filesystem reclaim. So what I said originally is correct
even when we take filesystems stacked via loop devices into account.

Hence I'll ask again: do you have stack traces of the deadlock or a
lockdep report? If not, can you please describe the storage setup
from top to bottom and lay out exactly where in what layers trigger
this deadlock?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
