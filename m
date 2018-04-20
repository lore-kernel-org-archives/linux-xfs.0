Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:49061 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753817AbeDTAJv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Apr 2018 20:09:51 -0400
Date: Fri, 20 Apr 2018 10:07:16 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 07/11] xfs: superblock scrub should use uncached buffers
Message-ID: <20180420000716.GT23861@dastard>
References: <152401916729.11465.4212188839231900136.stgit@magnolia>
 <152401922015.11465.14941366292853283272.stgit@magnolia>
 <20180419125546.GA25844@bfoster.bfoster>
 <20180419172548.GY24738@magnolia>
 <20180419185723.GA26938@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180419185723.GA26938@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Thu, Apr 19, 2018 at 02:57:23PM -0400, Brian Foster wrote:
> On Thu, Apr 19, 2018 at 10:25:48AM -0700, Darrick J. Wong wrote:
> > On Thu, Apr 19, 2018 at 08:55:47AM -0400, Brian Foster wrote:
> > > On Tue, Apr 17, 2018 at 07:40:20PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > 
> > > > We've never cached buffers when reading or writing superblocks, so we
> > > > need to change scrub to do likewise or risk screwing up the uncached sb
> > > > buffer usage everywhere else.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > ---
> > > 
> > > Hmm, so this goes back to this[1] thread, right?
> > 
> > Yep.
> > 
> > > IIRC, we wanted to end up with an lru-bypassing uncached buffer lookup
> > > mechanism to provide uncached behavior for resource-saving purposes
> > > but without introducing serialization issues between multiple users of
> > > uncached buffers.
> > 
> > Right.
> > 
> > > On a quick look back, growfs currently uses cached buffers for secondary
> > > superblocks and the associated patch was looking to change that to
> > > something like the above. Don't we have the same requirement here (since
> > > growfs currently still uses cached buffers)?
> > 
> > Correct, this patch is contingent on landing Dave's "tableise growfs"
> > series that converts growfs to use uncached buffers for writing out the
> > new secondary supers.  If I manage to land Dave's growfs thing before
> > repair then I'll keep this; if repair goes first I'll defer it to that
> > series.
> > 
> 
> Ok, though I'm not sure I see the need for the higher level series
> dependency. Don't one of these patches just need to fold in a helper[1]
> to set the lru reference appropriately and start to use it?

Yes, that would work. :P

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
