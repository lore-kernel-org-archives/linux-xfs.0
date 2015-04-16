Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8DCAF7F3F
	for <xfs@oss.sgi.com>; Thu, 16 Apr 2015 17:28:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 61BD78F8040
	for <xfs@oss.sgi.com>; Thu, 16 Apr 2015 15:28:35 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	H6qxmTm5SjQCzbFb for <xfs@oss.sgi.com>;
	Thu, 16 Apr 2015 15:28:31 -0700 (PDT)
Date: Fri, 17 Apr 2015 08:28:29 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs: extent size hints can round up extents past
	MAXEXTLEN
Message-ID: <20150416222829.GE21261@dastard>
References: <1429160450-4782-1-git-send-email-david@fromorbit.com>
	<20150416173238.GB39482@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150416173238.GB39482@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Thu, Apr 16, 2015 at 01:32:38PM -0400, Brian Foster wrote:
> On Thu, Apr 16, 2015 at 03:00:50PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > This results in BMBT corruption, as seen by this test:
> > 
> > # mkfs.xfs -f -d size=40051712b,agcount=4 /dev/vdc
> > ....
> > # mount /dev/vdc /mnt/scratch
> > # xfs_io -ft -c "extsize 16m" -c "falloc 0 30g" -c "bmap -vp" /mnt/scratch/foo
> > 
> > which results in this failure on a debug kernel:
> > 
> > XFS: Assertion failed: (blockcount & xfs_mask64hi(64-BMBT_BLOCKCOUNT_BITLEN)) == 0, file: fs/xfs/libxfs/xfs_bmap_btree.c, line: 211
> > ....
....
> 
> Looks fine from the perspective of applying pre-existing logic to a
> separate codepath, but...

That was my thought....

> > + * Calculate the maximum extent length we can ask to allocate after taking into
> > + * account the on-disk size limitations, the extent size hints and the size
> > + * being requested. We have to deal with the extent size hint here because the
> > + * allocation will attempt alignment and hence grow the length outwards by up to
> > + * @extsz on either side.
> > + */
> > +static inline xfs_extlen_t
> > +xfs_bmapi_max_extlen(
> > +	struct xfs_inode	*ip,
> > +	xfs_extlen_t		length)
> > +{
> > +	xfs_extlen_t		extsz = xfs_get_extsz_hint(ip);
> > +	xfs_extlen_t		max_length = MAXEXTLEN;
> > +
> > +	if (extsz)
> > +		max_length -= 2 * extsz - 1;
> 
> This can underflow or cause other issues if set to just the right value
> (with smaller block sizes such that length can be trimmed to 0):

But I assumed the existing code was correct for this context. My
bad. :/

> $ mkfs.xfs -f -bsize=1k <dev>
> $ mount <dev> /mnt
> $ xfs_io -f -c "extsize 1g" -c "pwrite 0 4k" -c fsync /mnt/file
> pwrite64: No space left on device

Yup, because it 2^21 = 2G, and extsize = 1g puts max_length < 0.

Ok. So, the problem is that it is overestimating the amount of space
that alignment will need, and that alignment cannot be guaranteed
for extsz hints of over (MAXEXTLEN / 2) in size.

i.e. given an alignment (A[0-2]) and an extent (E[01]):

   A0                  A1                  A2
   +-------------------+-------------------+
		     +ooo+
		     E0  E1

The problem is that the alignment done by xfs_bmap_extsize_align()
only extends outwards (i.e. increases extent size). Hence E0 gets
rounded down to A0-A2, and E1 gets extended to A2, which means we
are adding almost 2 entire extent size hints to the allocation.
That's where the reduction in length by two extsz values came from.

Now, for delayed allocation, this is just fine, because real
allocation will break this delalloc extent up into two separate
extents, and underflow wouldn't be noticed as delalloc extents are
not physically limited to MAXEXTLEN and so nothing would have
broken. Still, it's not the intended behaviour.

I'm not sure what the solution is yet - the fundamental problem here
is the outwards alignment of both ends of the extent, and this
MAXEXTLEN twiddling is just an encoding of that behaviour. I need to
spend some time looking at xfs_bmap_extsize_align() and determining
if there is something we can do differently here.

> (Both that and the original reproducer might make a good xfstests test,
> btw...)

Yeah, I think I mentioned that on IRC to sandeen when I wrote the
first fix.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
