Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 829A87F77
	for <xfs@oss.sgi.com>; Thu,  7 Mar 2013 19:35:34 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 434D7304032
	for <xfs@oss.sgi.com>; Thu,  7 Mar 2013 17:35:31 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	guMWy5A8P1MThgkx for <xfs@oss.sgi.com>;
	Thu, 07 Mar 2013 17:35:29 -0800 (PST)
Date: Fri, 8 Mar 2013 12:35:25 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Pathological allocation pattern with direct IO
Message-ID: <20130308013525.GZ23616@dastard>
References: <20130306202210.GA1318@quack.suse.cz>
	<20130307050325.GS23616@dastard>
	<20130307102406.GA6723@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130307102406.GA6723@quack.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: xfs@oss.sgi.com

On Thu, Mar 07, 2013 at 11:24:06AM +0100, Jan Kara wrote:
> On Thu 07-03-13 16:03:25, Dave Chinner wrote:
> > On Wed, Mar 06, 2013 at 09:22:10PM +0100, Jan Kara wrote:
> > >   Hello,
> > > 
> > >   one of our customers has application that write large (tens of GB) files
> > > using direct IO done in 16 MB chunks. They keep the fs around 80% full
> > > deleting oldest files when they need to store new ones. Usually the file
> > > can be stored in under 10 extents but from time to time a pathological case
> > > is triggered and the file has few thousands extents (which naturally has
> > > impact on performance). The customer actually uses 2.6.32-based kernel but
> > > I reproduced the issue with 3.8.2 kernel as well.
.....
> > > 1) We start allocating blocks for file. We want to allocate in the same AG
> > > as the inode is. First we try exact allocation which fails so we try
> > > XFS_ALLOCTYPE_NEAR_BNO allocation which finds large enough free extent
> > > before the inode. So we start allocating 16 MB chunks from the end of that
> > > free extent. From this moment on we are basically bound to continue
> > > allocating backwards using XFS_ALLOCTYPE_NEAR_BNO allocation until we
> > > exhaust the whole free extent.
> > > 
> > > 2) Similar situation happens when we cannot further grow current extent but
> > > there is large free space somewhere before this extent in the AG.
> > > 
> > > So I was wondering is this known? Is XFS_ALLOCTYPE_NEAR_BNO so beneficial
> > > it outweights pathological cases like the above? Or shouldn't it maybe be
> > > disabled for larger files or for direct IO?
> > 
> > Well known issue, first diagnosed about 15 years ago, IIRC. Simple
> > solution: use extent size hints.
>   I thought someone must have hit it before. But I wasn't successful in
> googling... I suggested using fallocate to the customer since they have a
> good idea of the final file size in advance and in testing it gave better
> results than extent size hints (plus it works for other filesystems as
> well).

Extent size hints have the advantage of being effective when the
file size is not known ahead of time, or the application cannot be
modified to do preallocation. And they can be applied immediately to
any existing filesystem without needing downtime or code changes, so
the problem can be mitigated immediately without impacting ongoing
production....

> But really I was wondering about usefulness of XFS_ALLOCTYPE_NEAR_BNO
> heuristic. Sure the seek time depends on the distance so if we are speaking
> about allocating single extent then XFS_ALLOCTYPE_NEAR_BNO is useful but
> once that strategy would allocate two or three consecutive extents you've
> lost all the benefit and you would be better off if you started allocating
> from the start of the free space.

Sorry, I gave quick answer because I didn't have time yesterday to
answer in depth.

The thing is, this backwards allocation is a low level allocator
primitive, and it's behaviour is supposed to find the nearest free
extent to a target block number. What you are seeing is exactly the
expected beahviour of XFS_ALLOCTYPE_NEAR_BNO. An because it is a low
level primitive, it is not designed to take into account high level
allocation requirements or do pattern detection. It just finds the
nearest free extent to the target block number, and that happens to
be at the end of a free extent when it is at a lower block number
than the target being asked for.

This allocator behaviour is desirable for metadata in btree format,
because it means that the btree clusters locally around both sides
of the parent object rather than spreading out over an entire AG
with blocks getting further and further apart as free space on the
ascending side of the inode gets used up.

In this case, it's far better to keep seek distances short by
maintaining locality to the parent object by allocating on the
descending side of the object.  And backwards seeks are handled
pretty well by the XFS metadata code - it uses readahead in the
btree/dirent traversals to allow the elevator to optimise the
resultant IO when walking the metadata, and hence backwards seeks
are not really a problem at all.

For data, random write workloads into sparse files really want this
behaviour as well as it results in physical locality of extents. The
backwards allocation simply doesn't matter because the extents are
being randomly accessed anyway, because physical locality ultimately
determines random IO performance.

Further, high end storage arrays are capable of detecting backwards
read patterns and issue readahead for them, so this backwards
allocation doesn't always result in measurable performance
problems...

Hence repeated backwards allocation is, in many cases, desirable
behaviour, and in others it doesn't make any difference. And with it
being easy to work around for the few cases where it is tripped over
on aging filesystems, there hasn't been a great deal of need to
change the behaviour.

> Obviously we don't know the future in
> advance but this resembles a classical problem from approximations
> algorithms theory (rent-or-buy problem where renting corresponds to
> allocating from the end of free space and taking the smaller cost while
> buying corresponds to allocation from the beginning, taking the higher
> cost, but expecting you won't have to pay anything in future). And the
> theory of approximation algorithms tells us that once we pay for renting as
> much as buying will cost us, then at that moment it is advantageous to buy
> and that gives you 2-approximation algorithm (you can do even better -
> factor 1.58 approximation - if you use randomization but I don't think we
> want to go that way).

Way too mathematical for me, because...

> So from this I'd say that switching off
> XFS_ALLOCTYPE_NEAR_BNO allocation once you've allocated 2-3 extents
> backwards would work of better on average.

.... common sense says that this is true.

I haven't looked to solve this problem in the past 5 years because
extent size hints are such a simple way of mitigating the problem.
However, given that I know how this allocation code works whole lot
better than I did 5 years ago, I think I can see an easy way to
avoid this repeated backwards allocation pattern when extending
files.

What we have right now is this used space/free space layout
with the allocation context prev/want when extending the file:


            free extent				  free extent
	+-----------------+ prev         ...... +--------------+
	                  +------+
			         +------+
				   want

This is what we'll ask for as a XFS_ALLOCTYPE_THIS_BNO allocation,
but that is going to fail because there is no free space at wantbno.
This then falls back to XFS_ALLOCTYPE_NEAR_BNO with the same wantbno
target, and it selects the free extent before prev.

If we then we look at what is happening xfs_alloc_compute_diff(), we
have wantbno > freebno, and wantbno > freeend, so we end up in
either of these two cases:

        } else if (alignment > 1) {
                newbno1 = roundup(freeend - wantlen, alignment);
                if (newbno1 > freeend - wantlen &&
                    newbno1 - alignment >= freebno)
                        newbno1 -= alignment;
                else if (newbno1 >= freeend)
                        newbno1 = NULLAGBLOCK;
        } else
                newbno1 = freeend - wantlen;


Either way, the resultant extent that is cut out of the free extent
is this:

            free extent
	+-----------------+ prev
	                  +------+
			         +------+
                   +------+	   want
		     got

And hence we end up in a backwards allocation pattern. After
repeated iterations of this, we end up this a pattern like this:

            free extent
	+-----------------+ prev  prev-1 prev-2
	                  +------+------+------+
			         +------+
                   +------+	   want
		     got

and so is likely to lead to an extended run of backwards allocation
for sequential ascending offsets. So, we would need to detect this
pattern in xfs_bmap_adjacent, where the wantbno is determined for
EOF allocation. That's a bit complex - we'll need to do extent tree
lookups because we need more information than we've got from the
initial lookup.

I do not want to get this information from the initial lookup and
pass it up to xfs_bmap_adjacent() because we are already using lots
of stack through this path and adding another 70-odd bytes for
another couple of extent maps is not going to fly. So to detect
backwards allocation, we'd have to take the CPU hit of doing another
lookup and then analysing the results for backwards allocation. That
can be done, but I'm wondering if we even need to detect this
case...

I suspect we don't even need to detect the backwards allocation
pattern at all - if we are falling back from an
XFS_ALLOCTYPE_THIS_BNO allocation, we know that the target cannot be
allocated and so we *might* end up doing a backwards allocation.
Hence I don't think it will not hurt at all to simply say "select
the start of the next candidate free extent" for a file data
allocations in this case. That would completely avoid needing to
detect repeated backwards allocations and ensure that subsequent
allocations after the backwards jump to the start of the large free
extent then go forwards as intended...

And because we only do XFS_ALLOCTYPE_THIS_BNO allocations on data
allocations when extending file, adding such a flag won't affect
random write or metadata allocation patterns....

So, once we've decided that backward allocation is possible, all we
need to do is inform XFS_ALLOCTYPE_NEAR_BNO/xfs_alloc_compute_diff()
to select the start of the free extent it finds rather than select
the tail of it. That will mean that rather than consume the entire
free extent in small chunks via backwards allocation, we'll do one
large backwards step and then consume the free extent in the
forwards direction instead.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
