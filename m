Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0D23C64E7A
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 21:16:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4AABB20705
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 21:16:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbgLAVQj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Dec 2020 16:16:39 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:55481 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725967AbgLAVQj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Dec 2020 16:16:39 -0500
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id EFCBD3C3BB7;
        Wed,  2 Dec 2020 08:15:57 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kkD09-00H5CR-2a; Wed, 02 Dec 2020 08:15:57 +1100
Date:   Wed, 2 Dec 2020 08:15:57 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] [RFC] spaceman: physically move a regular inode
Message-ID: <20201201211557.GL2842436@dread.disaster.area>
References: <20201110225924.4031404-1-david@fromorbit.com>
 <20201201140742.GA1205666@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201201140742.GA1205666@bfoster>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=kj9zAlcOel0A:10 a=zTNgK-yGK50A:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=TEcymXPbirOkWcXyjcoA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 01, 2020 at 09:07:42AM -0500, Brian Foster wrote:
> On Wed, Nov 11, 2020 at 09:59:24AM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > To be able to shrink a filesystem, we need to be able to physically
> > move an inode and all it's data and metadata from it's current
> > location to a new AG.  Add a command to spaceman to allow an inode
> > to be moved to a new AG.
> > 
> > This new command is not intended to be a perfect solution. I am not
> > trying to handle atomic movement of open files - this is intended to
> > be run as a maintenance operation on idle filesystem. If root
> > filesystems are the target, then this should be run via a rescue
> > environment that is not executing directly on the root fs. With
> > those caveats in place, we can do the entire inode move as a set of
> > non-destructive operations finalised by an atomic inode swap
> > without any needing special kernel support.
> > 
> > To ensure we move metadata such as BMBT blocks even if we don't need
> > to move data, we clone the data to a new inode that we've allocated
> > in the destination AG. This will result in new bmbt blocks being
> > allocated in the new location even though the data is not copied.
> > Attributes need to be copied one at a time from the original inode.
> > 
> > If data needs to be moved, then we use fallocate(UNSHARE) to create
> > a private copy of the range of data that needs to be moved in the
> > new inode. This will be allocated in the destination AG by normal
> > allocation policy.
> > 
> > Once the new inode has been finalised, use RENAME_EXCHANGE to swap
> > it into place and unlink the original inode to free up all the
> > resources it still pins.
> > 
> > There are many optimisations still possible to speed this up, but
> > the goal here is "functional" rather than "optimal". Performance can
> > be optimised once all the parts for a "empty the tail of the
> > filesystem before shrink" operation are implemented and solidly
> > tested.
> > 
> 
> Neat idea. With respect to the shrink use case, what's the reasoning
> behind userspace selecting the target AG? There's no harm in having the
> target AG option in the utility of course, but ISTM that shrink might
> care more about moving some set of inodes from a particular AG as
> opposed to a specific target AG.

Oh, that's just a mechanism right now to avoid needing kernel
allocator policy support for relocating things. Say for example, we
plan to empty the top six AGs - we don't want the allocator to chose
any of them for relocation, and in the absence of kernel side policy
the only way we can direct that is to select an AG outside that
range manually with a target directory location (as per xfs_fsr).

IOWs, I'm just trying to implement the move mechanisms without
having to introduce new kernel API dependencies because I kinda want
shrink to be possible with minimal kernel requirements. It's also
not meant to be an optimal implementation at this point, merely a
generic one. Adding policy hooks for controlling AG allocation can
be done once we know exactly what the data movement process needs
for optimal behaviour.

> For example, might it make sense to implement a policy where move_inode
> simply moves an inode to the first AG the tempdir lands in that is < the
> AG of the source inode? We'd probably want to be careful to make sure
> that we don't attempt to dump the entire set of moved files into the
> same AG, but I assume the temp dir creation logic would effectively
> rotor across the remaining set of AGs we do want to allow.. Thoughts?

Yes, we could. But I simply decided that a basic, robust shrink to
the minimum possible size will have to fill the filesystem from AG 0
up, and not move to AG 1 until AG 0 is full.  I also know that the
kernel allocation policies will skip to the next AG if there is lock
contention, space or other allocation setup issues, hence I wanted
to be able to direct movement to the lowest possible AGs first...

THere's enough complexity in an optimal shrink implementation that
it will keep someone busy full time for a couple of years. I want to
provide the basic functionality userspace needs only spending a
couple of days a week for a couple of months on it. If we want it
fast and deployable on existing systems, compromises will need to be
made...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
