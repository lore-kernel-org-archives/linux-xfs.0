Return-Path: <SRS0=0MSb=2C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67D9BC43603
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Dec 2019 20:48:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3FF8A22527
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Dec 2019 20:48:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730749AbfLLUsz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Dec 2019 15:48:55 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:57489 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730908AbfLLUsz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Dec 2019 15:48:55 -0500
Received: from dread.disaster.area (pa49-195-139-249.pa.nsw.optusnet.com.au [49.195.139.249])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id BDE6A3A1D8C;
        Fri, 13 Dec 2019 07:48:52 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ifVOF-0005Kj-2n; Fri, 13 Dec 2019 07:48:51 +1100
Date:   Fri, 13 Dec 2019 07:48:51 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: stabilize insert range start boundary to avoid COW
 writeback race
Message-ID: <20191212204851.GF19256@dread.disaster.area>
References: <20191210132340.11330-1-bfoster@redhat.com>
 <20191210214100.GB19256@dread.disaster.area>
 <20191211124712.GB16095@bfoster>
 <20191211205230.GD19256@dread.disaster.area>
 <20191212141634.GA36655@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191212141634.GA36655@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=KoypXv6BqLCQNZUs2nCMWg==:117 a=KoypXv6BqLCQNZUs2nCMWg==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=pxVhFHJ0LMsA:10
        a=7-415B0cAAAA:8 a=3mweZ8v1Rb9KxByxwc4A:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Dec 12, 2019 at 09:16:34AM -0500, Brian Foster wrote:
> On Thu, Dec 12, 2019 at 07:52:30AM +1100, Dave Chinner wrote:
> > On Wed, Dec 11, 2019 at 07:47:12AM -0500, Brian Foster wrote:
> > > On Wed, Dec 11, 2019 at 08:41:00AM +1100, Dave Chinner wrote:
> > > > On Tue, Dec 10, 2019 at 08:23:40AM -0500, Brian Foster wrote:
> > > > I think insert/collapse need to be converted to work like a
> > > > truncate operation instead of a series on individual write
> > > > operations. That is, they are a permanent transaction that locks the
> > > > inode once and is rolled repeatedly until the entire extent listi
> > > > modification is done and then the inode is unlocked.
> > > > 
> > > 
> > > Note that I don't think it's sufficient to hold the inode locked only
> > > across the shift. For the insert case, I think we'd need to grab it
> > > before the extent split at the target offset and roll from there.
> > > Otherwise the same problem could be reintroduced if we eventually
> > > replaced the xfs_prepare_shift() tweak made by this patch. Of course,
> > > that doesn't look like a big problem. The locking is already elevated
> > > and split and shift even use the same transaction type, so it's mostly a
> > > refactor from a complexity standpoint. 
> > 
> > *nod*
> > 
> > > For the collapse case, we do have a per-shift quota reservation for some
> > > reason. If that is required, we'd have to somehow replace it with a
> > > worst case calculation. That said, it's not clear to me why that
> > > reservation even exists.
> > 
> > I'm not 100% sure, either, but....
> > 
> > > The pre-shift hole punch is already a separate
> > > transaction with its own such reservation. The shift can merge extents
> > > after that point (though most likely only on the first shift), but that
> > > would only ever remove extent records. Any thoughts or objections if I
> > > just killed that off?
> > 
> > Yeah, I suspect that it is the xfs_bmse_merge() case freeing blocks
> > the reservation is for, and I agree that it should only happen on
> > the first shift because all the others that are moved are identical
> > in size and shape and would have otherwise been merged at creation.
> > 
> > Hence I think we can probably kill the xfs_bmse_merge() case,
> > though it might be wrth checking first how often it gets called...
> > 
> 
> Ok, but do we need an up-front quota reservation for freeing blocks out
> of the bmapbt? ISTM the reservation could be removed regardless of the
> merging behavior. This is what my current patch does, at least, so we'll
> see if anything explodes. :P

xfs_itruncate_extents() doesn't require an up front block
reservation for quotas or transaction allocation, so I don't really
see how the collapse would require it, even in the merge case...

> I agree on the xfs_bmse_merge() bit. I was planning to leave that as is
> however because IIRC, even though it is quite rare, I thought we had a
> few corner cases where it was possible for physically and logically
> contiguous extents to track separately in a mapping tree. Max sized
> extents that are subsequently punched out or truncated might be one
> example. I thought we had others, but I can't quite put my finger on it
> atm..

True, but is it common enough that we really need to care about it?
If it's bad, just run xfs_fsr on the file/filesystem....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
