Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 76D757F52
	for <xfs@oss.sgi.com>; Wed,  7 May 2014 20:42:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DE973AC003
	for <xfs@oss.sgi.com>; Wed,  7 May 2014 18:42:47 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	oJ0aoy6wafP5wpEI for <xfs@oss.sgi.com>;
	Wed, 07 May 2014 18:42:45 -0700 (PDT)
Date: Thu, 8 May 2014 11:42:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs_repair: don't unlock prefetch tree to read discontig
	buffers
Message-ID: <20140508014215.GT5421@dastard>
References: <536AC1CB.8060601@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <536AC1CB.8060601@redhat.com>
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

On Wed, May 07, 2014 at 06:29:15PM -0500, Eric Sandeen wrote:
> The way discontiguous buffers are currently handled in
> prefetch is by unlocking the prefetch tree and reading
> them one at a time in pf_read_discontig(), inside the
> normal loop of searching for buffers to read in a more
> optimized fashion.
> 
> But by unlocking the tree, we allow other threads to come
> in and find buffers which we've already stashed locally
> on our bplist[].  If 2 threads think they own the same
> set of buffers, they may both try to delete them from
> the prefetch btree, and the second one to arrive will not
> find it, resulting in:
> 
> 	fatal error -- prefetch corruption
> 
> Fix this by maintaining 2 lists; the original bplist,
> and a new one containing only discontiguous buffers.
> 
> The original list can be seek-optimized as before,
> and the discontiguous list can be read one by one
> before we do the seek-optimized reads, after all of the
> tree manipulation has been completed.

Nice job finding the problem, Eric! It looks like your patch solves
the problem, but after considering this approach for a while I think
it's overkill. ;)

What the loop is trying to do is linearise all the IO and turn lots
of small IO into a single large IO, so if we grab all the discontig
buffers in the range, then do IO on them, then do the large IO, we
are effectively seeking all over that range, including backwards.
This is exactly the sort of problem the prefetch loop is trying to
avoid.

So what I think is best is that we simply abort the pulling of new
buffers off the list when we hit a discontiguous buffer. Leave the
discontig buffer as the last on the list, and process the list as
per normal. Remove all the remaining buffers from the btree, then
drop the lock and do the pread64 call.

Then, check the last buffer on the bplist - if it's the discontig
buffer (i.e. wasn't dropped during list processing), then issue the
discontig buffer IO. It should at least start as either sequential I
oor with a small forwards seek, so so shoul be as close to seek
optimised as we can get for such buffers. Then it can be removed
from the bplist, num decremented, the lock picked back up and the
large buffer read in via pread64() can be sliced and diced
appropriately...

i.e. much less code, no need for a separate list, and the seeks
shoul dbe minimised as much as possible....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
