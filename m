Return-Path: <SRS0=rMVI=7Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF41FC433DF
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Jun 2020 21:21:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9011206E6
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Jun 2020 21:21:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbgFCVVY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Jun 2020 17:21:24 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:44315 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725985AbgFCVVY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Jun 2020 17:21:24 -0400
Received: from dread.disaster.area (pa49-180-124-177.pa.nsw.optusnet.com.au [49.180.124.177])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 3CCF83A419F;
        Thu,  4 Jun 2020 07:21:19 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jgap1-0000UB-Q6; Thu, 04 Jun 2020 07:21:15 +1000
Date:   Thu, 4 Jun 2020 07:21:15 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/30] xfs: mark inode buffers in cache
Message-ID: <20200603212115.GN2040@dread.disaster.area>
References: <20200601214251.4167140-1-david@fromorbit.com>
 <20200601214251.4167140-5-david@fromorbit.com>
 <20200602164535.GD7967@bfoster>
 <20200602212918.GF2040@dread.disaster.area>
 <20200603145749.GA12332@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200603145749.GA12332@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=k3aV/LVJup6ZGWgigO6cSA==:117 a=k3aV/LVJup6ZGWgigO6cSA==:17
        a=kj9zAlcOel0A:10 a=nTHF0DUjJn0A:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=vSxsiXHG5LpH2W-VAnAA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 03, 2020 at 10:57:49AM -0400, Brian Foster wrote:
> On Wed, Jun 03, 2020 at 07:29:18AM +1000, Dave Chinner wrote:
> > On Tue, Jun 02, 2020 at 12:45:35PM -0400, Brian Foster wrote:
> > > On Tue, Jun 02, 2020 at 07:42:25AM +1000, Dave Chinner wrote:
> > > > From: Dave Chinner <dchinner@redhat.com>
> > > > 
> > > > Inode buffers always have write IO callbacks, so by marking them
> > > > directly we can avoid needing to attach ->b_iodone functions to
> > > > them. This avoids an indirect call, and makes future modifications
> > > > much simpler.
> > > > 
> > > > This is largely a rearrangement of the code at this point - no IO
> > > > completion functionality changes at this point, just how the
> > > > code is run is modified.
> > > > 
> > > 
> > > Ok, I was initially thinking this patch looked incomplete in that we
> > > continue to set ->b_iodone() on inode buffers even though we'd never
> > > call it. Looking ahead, I see that the next few patches continue to
> > > clean that up to eventually remove ->b_iodone(), so that addresses that.
> > > 
> > > My only other curiosity is that while there may not be any functional
> > > difference, this technically changes callback behavior in that we set
> > > the new flag in some contexts that don't currently attach anything to
> > > the buffer, right? E.g., xfs_trans_inode_alloc_buf() sets the flag on
> > > inode chunk init, which means we can write out an inode buffer without
> > > any attached/flushed inodes.
> > 
> > Yes, it can happen, and it happens before this patch, too, because
> > the AIL can push the buffer log item directly and that does not
> > flush dirty inodes to the buffer before it writes back(*).
> > 
> 
> I was thinking more about cases where there are actually no inodes
> attached.
> 
> > As it is, xfs_buf_inode_iodone() on a buffer with no inode attached
> > if functionally identical to the existing xfs_buf_iodone() callback
> > that would otherwise be done. i.e. it just runs the buffer log item
> > completion callback. Hence the change here rearranges code, but it
> > does not change behaviour at all.
> > 
> 
> Right. That's indicative from the code, but doesn't help me understand
> why the change is made. That's all I'm asking for...
> 
> > (*) this is a double-write bug that this patch set does not address.
> > i.e. buffer log item flushes the buffer without flushing inodes, IO
> > compeletes, then inode flush to the buffer and we do another IO to
> > clean them.  This is addressed by a follow-on patchset that tracks
> > dirty inodes via ordered cluster buffers, such that pushing the
> > buffer always triggers xfs_iflush_cluster() on buffers tagged
> > _XBF_INODES...
> > 
> 
> Ok, interesting (but seems beyond the scope of this series).

It is used in this series in the ail buffer resubmit code to clear
the LI_FAILED state appropriately, because inode items are treated
differently to dquot items once they track the cluster buffer...

> > > Is the intent of that to support future
> > > changes? If so, a note about that in the commit log would be helpful.
> > 
> > That's part of it, as you can see from the (*) above. But the commit
> > log already says "..., and makes future modifications much simpler."
> > Was that insufficient to indicate that it will be used later on?
> > 
> 
> That's a rather vague hint. ;P I was more hoping for something like:
> "While this is largely a refactor of existing functionality, broaden the
> scope of the flag to beyond where inodes are explicitly attached because
> <some actual reason>. This has the effect of possibly invoking the
> callback in cases where it wouldn't have been previously, but this is
> not a functional change because the callback is effectively a no-op when
> inodes are not attached."

Ok.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
