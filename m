Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id ABF6B7F67
	for <xfs@oss.sgi.com>; Tue, 12 Mar 2013 06:01:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 992118F804B
	for <xfs@oss.sgi.com>; Tue, 12 Mar 2013 04:01:04 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id oT9WEu2QmJ3p8vAY for <xfs@oss.sgi.com>;
	Tue, 12 Mar 2013 04:01:02 -0700 (PDT)
Date: Tue, 12 Mar 2013 12:01:00 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: Pathological allocation pattern with direct IO
Message-ID: <20130312110100.GC13152@quack.suse.cz>
References: <20130306202210.GA1318@quack.suse.cz>
	<20130307050325.GS23616@dastard>
	<20130307102406.GA6723@quack.suse.cz>
	<20130308013525.GZ23616@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130308013525.GZ23616@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

On Fri 08-03-13 12:35:25, Dave Chinner wrote:
> On Thu, Mar 07, 2013 at 11:24:06AM +0100, Jan Kara wrote:
> > But really I was wondering about usefulness of XFS_ALLOCTYPE_NEAR_BNO
> > heuristic. Sure the seek time depends on the distance so if we are speaking
> > about allocating single extent then XFS_ALLOCTYPE_NEAR_BNO is useful but
> > once that strategy would allocate two or three consecutive extents you've
> > lost all the benefit and you would be better off if you started allocating
> > from the start of the free space.
  <snip>
> Hence repeated backwards allocation is, in many cases, desirable
> behaviour, and in others it doesn't make any difference. And with it
> being easy to work around for the few cases where it is tripped over
> on aging filesystems, there hasn't been a great deal of need to
> change the behaviour.
  Thanks for explanation!

> > Obviously we don't know the future in
> > advance but this resembles a classical problem from approximations
> > algorithms theory (rent-or-buy problem where renting corresponds to
> > allocating from the end of free space and taking the smaller cost while
> > buying corresponds to allocation from the beginning, taking the higher
> > cost, but expecting you won't have to pay anything in future). And the
> > theory of approximation algorithms tells us that once we pay for renting as
> > much as buying will cost us, then at that moment it is advantageous to buy
> > and that gives you 2-approximation algorithm (you can do even better -
> > factor 1.58 approximation - if you use randomization but I don't think we
> > want to go that way).
> 
> Way too mathematical for me, because...
> 
> > So from this I'd say that switching off
> > XFS_ALLOCTYPE_NEAR_BNO allocation once you've allocated 2-3 extents
> > backwards would work of better on average.
> 
> .... common sense says that this is true.
> 
> I haven't looked to solve this problem in the past 5 years because
> extent size hints are such a simple way of mitigating the problem.
> However, given that I know how this allocation code works whole lot
> better than I did 5 years ago, I think I can see an easy way to
> avoid this repeated backwards allocation pattern when extending
> files.
> 
> What we have right now is this used space/free space layout
> with the allocation context prev/want when extending the file:
> 
> 
>             free extent				  free extent
> 	+-----------------+ prev         ...... +--------------+
> 	                  +------+
> 			         +------+
> 				   want
> 
> This is what we'll ask for as a XFS_ALLOCTYPE_THIS_BNO allocation,
> but that is going to fail because there is no free space at wantbno.
> This then falls back to XFS_ALLOCTYPE_NEAR_BNO with the same wantbno
> target, and it selects the free extent before prev.
> 
> If we then we look at what is happening xfs_alloc_compute_diff(), we
> have wantbno > freebno, and wantbno > freeend, so we end up in
> either of these two cases:
> 
>         } else if (alignment > 1) {
>                 newbno1 = roundup(freeend - wantlen, alignment);
>                 if (newbno1 > freeend - wantlen &&
>                     newbno1 - alignment >= freebno)
>                         newbno1 -= alignment;
>                 else if (newbno1 >= freeend)
>                         newbno1 = NULLAGBLOCK;
>         } else
>                 newbno1 = freeend - wantlen;
> 
> 
> Either way, the resultant extent that is cut out of the free extent
> is this:
> 
>             free extent
> 	+-----------------+ prev
> 	                  +------+
> 			         +------+
>                    +------+	   want
> 		     got
> 
> And hence we end up in a backwards allocation pattern. After
> repeated iterations of this, we end up this a pattern like this:
> 
>             free extent
> 	+-----------------+ prev  prev-1 prev-2
> 	                  +------+------+------+
> 			         +------+
>                    +------+	   want
> 		     got
> 
> and so is likely to lead to an extended run of backwards allocation
> for sequential ascending offsets. So, we would need to detect this
  Yup, that's what I understood in the code and saw in my experiments...

> pattern in xfs_bmap_adjacent, where the wantbno is determined for
> EOF allocation. That's a bit complex - we'll need to do extent tree
> lookups because we need more information than we've got from the
> initial lookup.
> 
> I do not want to get this information from the initial lookup and
> pass it up to xfs_bmap_adjacent() because we are already using lots
> of stack through this path and adding another 70-odd bytes for
> another couple of extent maps is not going to fly. So to detect
> backwards allocation, we'd have to take the CPU hit of doing another
> lookup and then analysing the results for backwards allocation. That
> can be done, but I'm wondering if we even need to detect this
> case...
> 
> I suspect we don't even need to detect the backwards allocation
> pattern at all - if we are falling back from an
> XFS_ALLOCTYPE_THIS_BNO allocation, we know that the target cannot be
> allocated and so we *might* end up doing a backwards allocation.
> Hence I don't think it will not hurt at all to simply say "select
> the start of the next candidate free extent" for a file data
> allocations in this case. That would completely avoid needing to
> detect repeated backwards allocations and ensure that subsequent
> allocations after the backwards jump to the start of the large free
> extent then go forwards as intended...
  Yes, I was wondering about whether this strategy won't be good enough as
well. But there's one case I'm afraid of: Suppose you have a small file so
that it gets written out in one request and fits in a single extent of
blocks. Then it is somewhat advantageous to allocate from the end of the
free extent because that is closer to the inode and thus reduces
inode-to-data seek time. That's why I was suggesting maybe we could use
this logic only for larger files or something like that. Hum, maybe if we
didn't use this strategy for initial file extent, it would be enough.
That's already handled specially in the allocator so it shouldn't be a
problem to detect. What do you think?

> And because we only do XFS_ALLOCTYPE_THIS_BNO allocations on data
> allocations when extending file, adding such a flag won't affect
> random write or metadata allocation patterns....
> 
> So, once we've decided that backward allocation is possible, all we
> need to do is inform XFS_ALLOCTYPE_NEAR_BNO/xfs_alloc_compute_diff()
> to select the start of the free extent it finds rather than select
> the tail of it. That will mean that rather than consume the entire
> free extent in small chunks via backwards allocation, we'll do one
> large backwards step and then consume the free extent in the
> forwards direction instead.
  Yes, this would work great for me.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
