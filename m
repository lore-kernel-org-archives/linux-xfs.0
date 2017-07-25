Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl6.internode.on.net ([150.101.137.136]:18659 "EHLO
        ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752458AbdGYDc3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jul 2017 23:32:29 -0400
Date: Tue, 25 Jul 2017 13:32:03 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 05/22] xfs: scrub in-memory metadata buffers
Message-ID: <20170725033203.GH17762@dastard>
References: <150061190859.14732.17040548800470377701.stgit@magnolia>
 <150061194082.14732.17289613506653968866.stgit@magnolia>
 <20170724014327.GC17762@dastard>
 <20170724223654.GK4352@magnolia>
 <20170724233813.GG17762@dastard>
 <20170725001433.GL4352@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170725001433.GL4352@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Jul 24, 2017 at 05:14:33PM -0700, Darrick J. Wong wrote:
> On Tue, Jul 25, 2017 at 09:38:13AM +1000, Dave Chinner wrote:
> > On Mon, Jul 24, 2017 at 03:36:54PM -0700, Darrick J. Wong wrote:
> > > On Mon, Jul 24, 2017 at 11:43:27AM +1000, Dave Chinner wrote:
> > > > On Thu, Jul 20, 2017 at 09:39:00PM -0700, Darrick J. Wong wrote:
> > > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > > 
> > > > > Call the verifier function for all in-memory metadata buffers, looking
> > > > > for memory corruption either due to bad memory or coding bugs.
> > > > 
> > > > How does this fit into the bigger picture? We can't do an exhaustive
> > > > search of the in memory buffer cache, because access is racy w.r.t.
> > > > the life cycle of in memory buffers.
> > > > 
> > > > Also, if we are doing a full scrub, we're going to hit and then
> > > > check the cached in-memory buffers anyway, so I'm missing the
> > > > context that explains why this code is necessary.
> > > 
> > > Before we start scanning the filesystem (which could lead to clean
> > > buffers being pushed out of memory and later reread), we want to check
> > > the buffers that have been sitting around in memory to see if they've
> > > mutated since the last time the verifiers ran.
> > 
> > I'm not sure we need a special cache walk to do this.
> > 
> > My thinking is that if the buffers get pushed out of memory, the
> > verifier will be run at that time, so we don't need to run the
> > verifier before a scrub to avoid problems here.
> 
> Agreed.
> 
> > Further, if we read the buffer as part of the scrub and it's found
> > in cache, then if the scrub finds a corruption we'll know it
> > happened between the last verifier invocation and the scrub.
> 
> Hm.  Prior to the introduction of the metabufs scanner a few weeks ago, 
> I had thought it sufficient to assume that memory won't get corrupt, so
> as long as the read verifier ran at /some/ point in the past we didn't
> need to recheck now.
> 
> What if we scrap the metabufs scanner and adapt the read verifier
> function pointer to allow scrub to bypass the crc check and return the
> _THIS_IP_ from any failing structural test?  Then scrubbers can call the
> read verifier directly and extract failure info directly.

Yeah, that would work - rather than adapting the .read_verify op
we currently have, maybe a new op .read_verify_nocrc could be added?
THat would mostly just be a different wrapper around the existing
verify functions that are shared between the read and write
verifiers...

> > If the buffer is not in cache and scrub reads the metadata from
> > disk, then the verifier should fire on read if the item is corrupt
> > coming off disk. If the verifier doesn't find corruption in this
> > case but scrub does, then we've got to think about whether the
> > verifier has sufficient coverage.
> 
> Scrub has more comprehensive checks (or it will when xref comes along)
> so this is likely to happen, fyi.

Yup, I expect it will. :) I also expect this to point out where the
verifiers can be improved, because I'm sure we haven't caught all
the "obviously wrong" cases in the verifiers yet...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
