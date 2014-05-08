Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B397B7F52
	for <xfs@oss.sgi.com>; Thu,  8 May 2014 00:43:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B1D70304051
	for <xfs@oss.sgi.com>; Wed,  7 May 2014 22:43:41 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	Fy8FHOVAuXLGEBpE for <xfs@oss.sgi.com>;
	Wed, 07 May 2014 22:43:36 -0700 (PDT)
Date: Thu, 8 May 2014 15:42:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs_repair: don't unlock prefetch tree to read discontig
	buffers
Message-ID: <20140508054247.GU5421@dastard>
References: <536AC1CB.8060601@redhat.com> <20140508014215.GT5421@dastard>
	<536AE4CE.2030201@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <536AE4CE.2030201@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Wed, May 07, 2014 at 08:58:38PM -0500, Eric Sandeen wrote:
> On 5/7/14, 8:42 PM, Dave Chinner wrote:
> > On Wed, May 07, 2014 at 06:29:15PM -0500, Eric Sandeen wrote:
> >> The way discontiguous buffers are currently handled in
> >> prefetch is by unlocking the prefetch tree and reading
> >> them one at a time in pf_read_discontig(), inside the
> >> normal loop of searching for buffers to read in a more
> >> optimized fashion.
> >>
> >> But by unlocking the tree, we allow other threads to come
> >> in and find buffers which we've already stashed locally
> >> on our bplist[].  If 2 threads think they own the same
> >> set of buffers, they may both try to delete them from
> >> the prefetch btree, and the second one to arrive will not
> >> find it, resulting in:
> >>
> >> 	fatal error -- prefetch corruption
> >>
> >> Fix this by maintaining 2 lists; the original bplist,
> >> and a new one containing only discontiguous buffers.
> >>
> >> The original list can be seek-optimized as before,
> >> and the discontiguous list can be read one by one
> >> before we do the seek-optimized reads, after all of the
> >> tree manipulation has been completed.
> > 
> > Nice job finding the problem, Eric! It looks like your patch solves
> > the problem, but after considering this approach for a while I think
> > it's overkill. ;)
> 
> Well, that's how it goes.  :)
> 
> > What the loop is trying to do is linearise all the IO and turn lots
> > of small IO into a single large IO, so if we grab all the discontig
> > buffers in the range, then do IO on them, then do the large IO, we
> > are effectively seeking all over that range, including backwards.
> > This is exactly the sort of problem the prefetch loop is trying to
> > avoid.
> 
> mmmhm... OTOH, discontig buffers are ... fairly rare?  And they do
> have to be read sometime.
> 
> > So what I think is best is that we simply abort the pulling of new
> > buffers off the list when we hit a discontiguous buffer. Leave the
> > discontig buffer as the last on the list, and process the list as
> > per normal. Remove all the remaining buffers from the btree, then
> > drop the lock and do the pread64 call.
> 
> I kind of half considered something like that, but the optimizing
> trims back num based on a few criteria, some involving the last
> buffer in the bplist.  So it's going to require a bit more awareness
> I think.

You can ignore it, though, because if we trim the discontig buffer
out, we don't read it in that loop, and another prefetch thread
will deal with it. If we don't trim it out, it makes no difference to
the large read...

i.e. you can completely ignore the discontig buffer until after te
pread64...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
