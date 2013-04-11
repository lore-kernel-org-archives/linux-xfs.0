Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 736637FD1
	for <xfs@oss.sgi.com>; Wed, 10 Apr 2013 22:29:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E6267AC001
	for <xfs@oss.sgi.com>; Wed, 10 Apr 2013 20:29:08 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	9tnUY128tt3Z7pHs for <xfs@oss.sgi.com>;
	Wed, 10 Apr 2013 20:29:03 -0700 (PDT)
Date: Thu, 11 Apr 2013 13:28:44 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: reserve fields in inode for parent ptr and alloc
	policy
Message-ID: <20130411032844.GG10481@dastard>
References: <20130410182438.268267840@sgi.com> <5165B5CB.2070203@sandeen.net>
	<5165BFF4.8020601@sgi.com> <5165CC39.2090108@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5165CC39.2090108@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Rich Johnston <rjohnston@sgi.com>, xfs@oss.sgi.com

On Wed, Apr 10, 2013 at 03:31:53PM -0500, Mark Tinguely wrote:
> On 04/10/13 14:39, Rich Johnston wrote:
> >On 04/10/2013 01:56 PM, Eric Sandeen wrote:
> >>On 4/10/13 1:24 PM, Mark Tinguely wrote:
> >>>The "di_allocpolicy" will be used to remember the allocation
> >>>policy associated with this inode.
> >>
> >>can you say more about this allocation policy?
> >>
> >>-Eric
> >
> >No its super secret information. ;)
> >
> >Its on my plate Eric, because Mark was making a change for parent ptrs,
> >I asked him to request space for allocation policies also.
> >
> >I don't have all the details yet but here is a very high level concept.

The on-disk format is a low level detail that falls out at the
bottom of the design/implementation/review cycle. It doesn't get
defined by high level concepts...

> >Identify allocation groups by names (or numbers -- preferably using names
> >in user-visible areas), allowing many different areas. Placing the
> >allocation
> >policy outside of user programs is necessary for this to be successful.
> >
> >Current thoughts on proposed a layered allocation policies:
> >
> >Policy for the entire filesystem
> >Policy attached to a directory (whose policy would be inherited by
> >subdirectories when subdirectories are created)
> >Policy for a single file
> >
> >The policy would define:
> >
> >where to place file data
> >where to place metadata for the files.
> >a prefered allocation group for placing file data (for directories).

Which is a summary of what this code:

> The allocation policies is based on work by Dave:
> 
> 	http://oss.sgi.com/archives/xfs/2009-02/msg00250.html

started with and was building on.

What I was trying to get to in that patch series was an arbitrarily
extensible allocation policy infrastructure, and that patch set was
proof-of-concept code I used to flesh out ideas.  Yes, it used 32
bits in the inode, but keep in mind that changed several times in
the patch set as I implemented new stuff and changed heirarchies,
definitions and concepts mid-patchset. But it isn't a reference
design - it was a research vehicle.....

Indeed, the patch set is an exact demonstration of the functionality
required by the on-disk format not being properly understood until
the functionality has at been fully implemented in a POC. And I
hadn't got anywhere near that with the above patch set.

As it is, I think that an extended attribute is be a better place
for allocation policy information. An xattr is far easier to modify
from userspace, and allows arbitrary allocator primitives being
exposed to policy control. That was the problem with the above patch
set - it didn't expose policy controls individually - it exposed
them as a defined set, and only the sets defined by the kernel were
possible.

As such, direct control of locality is simply not possible with the
above patch set. Having an attribute format that defines all the
different control parameters allows userspace to define complex
policies that match the specific storage topology of the system the
policy is designed for. This is impossible to express in a standard
kernel with the approach I was taking in the above patch set, and i
was already thinking about xattr based primitives to allow
fine-grained exposure of the allocation primitives I'd abstracted
out of the kernel code...

IOWs, We need to have agreement on design and implementation
direction of a feature before we consider what the on-disk
format is going to be, so reserving space on disk is extremely
premature at this point....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
