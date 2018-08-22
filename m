Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:29367 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725722AbeHVEDm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Aug 2018 00:03:42 -0400
Date: Wed, 22 Aug 2018 10:41:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/6] xfs: verify extent size hint is valid in inode
 verifier
Message-ID: <20180822004113.GQ31495@dastard>
References: <20180605062423.4877-1-david@fromorbit.com>
 <20180605062423.4877-3-david@fromorbit.com>
 <6196d8ce-03b9-eaae-4a07-d307e35540ca@sandeen.net>
 <20180724164346.GU4813@magnolia>
 <20180820150603.GA9568@bfoster>
 <17c55fba-5615-35a4-65d6-665ea89d20c2@sandeen.net>
 <20180820153626.GB4334@magnolia>
 <20180820155918.GB9568@bfoster>
 <20180820221506.GG31495@dastard>
 <20180821105645.GA14228@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180821105645.GA14228@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org

On Tue, Aug 21, 2018 at 06:56:45AM -0400, Brian Foster wrote:
> On Tue, Aug 21, 2018 at 08:15:06AM +1000, Dave Chinner wrote:
> > We should clear them on free now, so that we can draw a line in the
> > sand for when we can have verifiers check it. e.g. when the next
> > feature bit gets introduced, filesystems with that feature bit set
> > can also verify the extent size hints are zero on freed inodes
> > because we know that kernels supporting that feature always zero
> > them on free....
> > 
> 
> That seems fine (and harmless) to me if the goal is ultimately to have
> this content clear on-disk. It keeps things consistent for verifiers,
> scrub, repair, etc. to not have some bits with required initialized
> values and others where we need to accommodate stale data.

*nod*

One of my original goals for all the online repair work was to
ensure that everything on disk was clean, sanitised and not
ambiguous in any way. The verifiers are a mechanism that helps us
identify things that aren't clean or sanitised, and working out how
to verify those things identifies ambiguities we need to fix. Such
as this one with freed inodes.

As I said to Eric on #xfs:

<dchinner_> We're well beyond the point where we trust a single field
	    in an on-disk structure to be the One True Source of Truth
<dchinner_> we want everything on disk to be correct and clean
<dchinner_> so we can make decisions like this correctly via
	    multi-field verifications


-- 
Dave Chinner
david@fromorbit.com
