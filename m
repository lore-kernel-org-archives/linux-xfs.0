Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 587BEC4332F
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Feb 2022 22:56:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbiB1W4j (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Feb 2022 17:56:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230102AbiB1W4i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Feb 2022 17:56:38 -0500
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C478E8CD8B
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 14:55:58 -0800 (PST)
Received: from dread.disaster.area (pa49-186-17-0.pa.vic.optusnet.com.au [49.186.17.0])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id A231552E772;
        Tue,  1 Mar 2022 09:55:57 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nOovs-0000iW-Gh; Tue, 01 Mar 2022 09:55:56 +1100
Date:   Tue, 1 Mar 2022 09:55:56 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH RFC 3/4] xfs: crude chunk allocation retry mechanism
Message-ID: <20220228225556.GS59715@dread.disaster.area>
References: <20220217172518.3842951-1-bfoster@redhat.com>
 <20220217172518.3842951-4-bfoster@redhat.com>
 <20220217232033.GD59715@dread.disaster.area>
 <Yg+rdFRpvra8U25D@bfoster>
 <20220218225440.GE59715@dread.disaster.area>
 <YhKM6u3yuF1Ek4/w@bfoster>
 <20220223070058.GK59715@dread.disaster.area>
 <Yh1CjRONamUG0k1C@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yh1CjRONamUG0k1C@bfoster>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=621d52fe
        a=+dVDrTVfsjPpH/ci3UuFng==:117 a=+dVDrTVfsjPpH/ci3UuFng==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=7-415B0cAAAA:8
        a=naSMNv7LkI1SZfMQRSoA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 28, 2022 at 04:45:49PM -0500, Brian Foster wrote:
> On Wed, Feb 23, 2022 at 06:00:58PM +1100, Dave Chinner wrote:
> > i.e. as long as we track whether we've allocated a new inode chunk
> > or not, we can bound the finobt search to a single retry. If we
> > allocated a new chunk before entering the finobt search, then all we
> > need is a log force because the busy inodes, by definition, are
> > XFS_ISTALE at this point and waiting for a CIL push before they can
> > be reclaimed. At this point an retry of the finobt scan will find
> > those inodes that were busy now available for allocation.
> 
> Remind me what aspect of the prospective VFS changes prevents inode
> allocation from seeing a free inode with not-yet-elapsed RCU grace
> period..? Will this delay freeing (or evicting) the inode until a grace
> period elapses from when the last reference was dropped?

It will delay it until the inode has been reclaimed, in which case
reallocating it will result in a new struct xfs_inode being
allocated from slab, and we're all good. Any lookup that finds the
old inode will see either I_WILL_FREE, I_FREEING, I_CLEAR,
XFS_NEED_INACTIVE, XFS_IRECLAIM or ip->i_ino == 0 depending on what
point the lookup occurs. Hence the lookup will be unable to take a
new reference to the unlinked inode, and the lookup retry should
then get the newly allocated xfs_inode once it has been inserted
into the radix tree...

IOWs, it gets rid of recycling altogether, and that's how we avoid
the RCU grace period issues with recycled inodes.

> > > Perhaps a simple enough short term option is to use the existing block
> > > alloc min/max range mechanisms (as mentioned on IRC). For example:
> > > 
> > > - Use the existing min/max_agbno allocation arg input values to attempt
> > >   one or two chunk allocs outside of the known range of busy inodes for
> > >   the AG (i.e., allocate blocks higher than the max busy agino or lower
> > >   than the min busy agino).
> > > - If success, then we know we've got a chunk w/o busy inodes.
> > > - If failure, fall back to the existing chunk alloc calls, take whatever
> > >   we get and retry the finobt scan (perhaps more aggressively checking
> > >   each record) hoping we got a usable new record.
> > > - If that still fails, then fall back to synchronize_rcu() as a last
> > >   resort and grab one of the previously busy inodes.
> > > 
> > > I couldn't say for sure if that would be effective enough without
> > > playing with it a bit, but that would sort of emulate an algorithm that
> > > filtered chunk block allocations with at least one busy inode without
> > > having to modify block allocation code. If it avoids an RCU sync in the
> > > majority of cases it might be effective enough as a stopgap until
> > > background freeing exists. Thoughts?
> > 
> > It might work, but I'm not a fan of how many hoops we are considering
> > jumping through to avoid getting tangled up in the RCU requirements
> > for VFS inode life cycles. I'd much prefer just being able to say
> > "all inodes busy, log force, try again" like we do with busy extent
> > limited block allocation...
> > 
> 
> Well presumably that works fine for your implementation of busy inodes,
> but not so much for the variant intended to work around the RCU inode
> reuse problem. ISTM this all just depends on the goals and plan here,
> and I'm not seeing clear enough reasoning to grok what that is. A
> summary of the options discussed so far:
> 
> - deferred inode freeing - ideal but too involved, want something sooner
>   and more simple
> - hinted non-busy chunk allocation - simple but jumping through too many
>   RCU requirement hoops
> - sync RCU and retry - most analogous to longer term busy inode
>   allocation handling (i.e. just replace rcu sync w/ log force and
>   retry), but RCU sync is too performance costly as a direct fallback
> 
> ISTM the options here range from simple and slow, to moderately simple
> and effective (TBD), to complex and ideal. So what is the goal for this
> series?

To find out if we can do something fast and effective (and without
hacks that might bite us unexepectedly) with RCU grace periods that
is less intrusive than changing inode life cycles. If it turns out
that we can change the inode life cycle faster than we can come up
with a RCU grace period based solution, then we should just go with
inode life cycle changes and forget about the interim RCU grace
period detection changes...

> My understanding to this point is that VFS changes are a ways
> out, so the first step was busy inodes == inodes with pending grace
> periods and a rework of the busy inode definition comes later with the
> associated VFS changes. That essentially means this series gets fixed up
> and posted as a mergeable component in the meantime, albeit with a
> "general direction" that is compatible with longer term changes.

It seems to me that the RCU detection code is also a ways out,
so I'm trying to keep our options open and not have us duplicate
work unnecessarily.

> However, every RCU requirement/characteristic that this series has to
> deal with is never going to be 100% perfectly aligned with the longer
> term busy inode requirements because the implementations/definitions
> will differ, particularly if the RCU handling is pushed up into the VFS.
> So if we're concerned about that, the alternative approach is to skip
> incrementally addressing the RCU inode reuse problem and just fold
> whatever bits of useful logic from here into your inode lifecycle work
> as needed and drop this as a mergeable component.

*nod*

The signs are pointing somewhat that way, but I'm still finding
the occasional unexpected gotcha in the code that I have to work
around. I think I've got them all, but until I've got it working it
pays to keep our options open....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
