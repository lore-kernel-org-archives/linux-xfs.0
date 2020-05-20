Return-Path: <SRS0=A2Vo=7C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD15EC433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 01:47:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC63F2075F
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 01:47:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbgETBrD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 May 2020 21:47:03 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:37486 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726348AbgETBrD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 May 2020 21:47:03 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 90EF63A36A1;
        Wed, 20 May 2020 11:46:57 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jbDot-0001ba-JG; Wed, 20 May 2020 11:46:55 +1000
Date:   Wed, 20 May 2020 11:46:55 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [XFS SUMMIT] SSD optimised allocation policy
Message-ID: <20200520014655.GT2040@dread.disaster.area>
References: <20200514103454.GL2040@dread.disaster.area>
 <20200519063204.GI17627@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200519063204.GI17627@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=kj9zAlcOel0A:10 a=sTwFKg_x9MkA:10 a=7-415B0cAAAA:8
        a=PT8yeHy-oPHSVA3NCx4A:9 a=7Zwj6sZBwVKJAoWSPKxL6X1jA+E=:19
        a=I8kSmkK-IfSnxc50:21 a=aNtP_1v68MyGdhs8:21 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 18, 2020 at 11:32:04PM -0700, Darrick J. Wong wrote:
> On Thu, May 14, 2020 at 08:34:54PM +1000, Dave Chinner wrote:
> > 
> > Topic:	SSD Optimised allocation policies
> > 
> > Scope:
> > 	Performance
> > 	Storage efficiency
> > 
> > Proposal:
> > 
> > Non-rotational storage is typically very fast. Our allocation
> > policies are all, fundamentally, based on very slow storage which
> > has extremely high latency between IO to different LBA regions. We
> > burn CPU to optimise for minimal seeks to minimise the expensive
> > physical movement of disk heads and platter rotation.
> > 
> > We know when the underlying storage is solid state - there's a
> > "non-rotational" field in the block device config that tells us the
> > storage doesn't need physical seek optimisation. We should make use
> > of that.
> > 
> > My proposal is that we look towards arranging the filesystem
> > allocation policies into CPU-optimised silos. We start by making
> > filesystems on SSDs with AG counts that are multiples of the CPU
> > count in the system (e.g. 4x the number of CPUs) to drive
> 
> I guess you and I have been doing this for years with seemingly few ill
> effects. ;)
> 
> That said, I did encounter a wackass system with 104 CPUs, a 1.4T RAID
> array of spinning disks, 229 AGs sized ~6.5GB each, and a 50M log.  The
> ~900 io writers were sinking thesystem, so clearly some people are still
> getting it wrong even with traditional storage. :(

Unfortunately, we can't prevent people from screwing things up by
not understanding what adverse impact twiddling mkfs knobs will
have. And, realistically, that's way outside the scope of this
topic...

> > parallelism at the allocation level, and then associate allocation
> > groups with specific CPUs in the system. Hence each CPU has a set of
> > allocation groups is selects between for the operations that are run
> > on it. Hence allocation is typically local to a specific CPU.
> > Optimisation proceeds from the basis of CPU locality optimisation,
> > not storage locality optimisation.
> 
> I wonder how hard it would be to compile a locality map for storage and
> CPUs from whatever numa and bus topology information the kernel already
> knows about?

We don't even need to do that. Just assigning specific AGs to
specific CPUs will give per-cpu locality. And the thing is that this
mapping can change from mount to mount without adversely impacting
performance, because storage locality is largely irrelevant to
performance.

> > What this allows is processes on different CPUs to never contend for
> > allocation resources. Locality of objects just doesn't matter for
> > solid state storage, so we gain nothing by trying to group inodes,
> > directories, their metadata and data physically close together. We
> > want writes that happen at the same time to be physically close
> > together so we aggregate them into larger IOs, but we really
> > don't care about optimising write locality for best read performance
> > (i.e. must be contiguous for sequential access) for this storage.
> > 
> > Further, we can look at faster allocation strategies - we don't need
> > to find the "nearest" if we don't have a contiguous free extent to
> > allocate into, we just want the one that costs the least CPU to
> > find. This is because solid state storage is so fast that filesystem
> > performance is CPU limited, not storage limited. Hence we need to
> > think about allocation policies differently and start optimising
> > them for minimum CPU expenditure rather than best layout.
> > 
> > Other things to discuss include:
> > 	- how do we convert metadata structures to write-once style
> > 	  behaviour rather than overwrite in place?
> 
> (Hm?)

So we don't have to overwrite metadata in place. Overwrite in place
is not nice to SSDs because they can't overwrite in place and this
leads to write amplification in the device.

e.g. I was wondering if there was ways we could look at changing the
individual btrees to use something like a log structured merge
tree...

> > 	- extremely large block sizes for metadata (e.g. 4MB) to
> > 	  align better with SSD erase block sizes
> 
> If we had metadata blocks that size, I'd advocate for studying how we
> could restructure the btree to log updates in the slack space and only
> checkpoint lower in the tree when necessary.

well, I was kinda thinking that the "write once style" algorithms go
fit much better with large blocks than update-in-place, especially
with the way we log buffers right now.

Blocks that large would allow storing deltas in the block, then when
the block is full rewriting the entire block with all the deltas
applied. And that's where write-once algorithms become interesting;
we compress a portion of the tree and the new index into the
block(s) and rewrite the root pointer...

> > 	- what parts of the allocation algorithms don't we need
> 
> Brian reworked part of the allocator a couple of cycles ago to reduce
> the long tail latency of chasing through one free space btree when the
> other one would have given it a quick answer; how beneficial has that
> been?  Could it be more aggressive?

Yeah, that's what I'm getting at. All the "near/exact/size" stuff
has a lot of overhead to find the best target. For SSDs "near"
doesn't matter, so if we want a specific size we can jsut take the
first fit. "exact" is only used to do contiguous allocation - that
still has benefit from a filesystem persepective (less extents in
data files) even if it doesn't improve IO performance, so I think
there's whole reams of selection logic we can completely ignore for
SSDs...

> > 	- are we better off with huge numbers of small AGs rather
> > 	  than fewer large AGs?
> 
> There's probably some point of dimininishing returns, but this seems
> likely.  Has anyone studied this recently?

Not beyond "I need 100+ AGs on this 400GB SSD for allocation
parallelism". i.e. I've typically just increased the number of AGs
until nothing blocks on AGI or AGF headers, and ignored everything
else.

We probably need to look at how to handle thousands of AGs
effectively. That is two-fold: a) managing the memory overhead of
having that many active AGs and b) how we select AGs to allocate
from.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
