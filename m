Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E22337FB1
	for <xfs@oss.sgi.com>; Thu,  7 Mar 2013 04:24:10 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6D1A6AC003
	for <xfs@oss.sgi.com>; Thu,  7 Mar 2013 02:24:10 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id keRwvNkXs6vUxyVa for <xfs@oss.sgi.com>;
	Thu, 07 Mar 2013 02:24:08 -0800 (PST)
Date: Thu, 7 Mar 2013 11:24:06 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: Pathological allocation pattern with direct IO
Message-ID: <20130307102406.GA6723@quack.suse.cz>
References: <20130306202210.GA1318@quack.suse.cz>
	<20130307050325.GS23616@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130307050325.GS23616@dastard>
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

On Thu 07-03-13 16:03:25, Dave Chinner wrote:
> On Wed, Mar 06, 2013 at 09:22:10PM +0100, Jan Kara wrote:
> >   Hello,
> > 
> >   one of our customers has application that write large (tens of GB) files
> > using direct IO done in 16 MB chunks. They keep the fs around 80% full
> > deleting oldest files when they need to store new ones. Usually the file
> > can be stored in under 10 extents but from time to time a pathological case
> > is triggered and the file has few thousands extents (which naturally has
> > impact on performance). The customer actually uses 2.6.32-based kernel but
> > I reproduced the issue with 3.8.2 kernel as well.
> > 
> > I was analyzing why this happens and the filefrag for the file looks like:
> > Filesystem type is: 58465342
> > File size of /raw_data/ex.20130302T121135/ov.s1a1.wb is 186294206464
> > (45481984 blocks, blocksize 4096)
> >  ext logical physical expected length flags
> >    0       0       13          4550656
> >    1 4550656 188136807  4550668 12562432
> >    2 17113088 200699240 200699238 622592
> >    3 17735680 182046055 201321831   4096
> >    4 17739776 182041959 182050150   4096
> >    5 17743872 182037863 182046054   4096
> >    6 17747968 182033767 182041958   4096
> >    7 17752064 182029671 182037862   4096
> > ...
> > 6757 45400064 154381644 154389835   4096
> > 6758 45404160 154377548 154385739   4096
> > 6759 45408256 252951571 154381643  73728 eof
> > /raw_data/ex.20130302T121135/ov.s1a1.wb: 6760 extents found
> > 
> > So we see that at one moment, the allocator starts giving us 16 MB chunks
> > backwards. This seems to be caused by XFS_ALLOCTYPE_NEAR_BNO allocation. For
> > two cases I was able to track down the logic:
> > 
> > 1) We start allocating blocks for file. We want to allocate in the same AG
> > as the inode is. First we try exact allocation which fails so we try
> > XFS_ALLOCTYPE_NEAR_BNO allocation which finds large enough free extent
> > before the inode. So we start allocating 16 MB chunks from the end of that
> > free extent. From this moment on we are basically bound to continue
> > allocating backwards using XFS_ALLOCTYPE_NEAR_BNO allocation until we
> > exhaust the whole free extent.
> > 
> > 2) Similar situation happens when we cannot further grow current extent but
> > there is large free space somewhere before this extent in the AG.
> > 
> > So I was wondering is this known? Is XFS_ALLOCTYPE_NEAR_BNO so beneficial
> > it outweights pathological cases like the above? Or shouldn't it maybe be
> > disabled for larger files or for direct IO?
> 
> Well known issue, first diagnosed about 15 years ago, IIRC. Simple
> solution: use extent size hints.
  I thought someone must have hit it before. But I wasn't successful in
googling... I suggested using fallocate to the customer since they have a
good idea of the final file size in advance and in testing it gave better
results than extent size hints (plus it works for other filesystems as
well).

But really I was wondering about usefulness of XFS_ALLOCTYPE_NEAR_BNO
heuristic. Sure the seek time depends on the distance so if we are speaking
about allocating single extent then XFS_ALLOCTYPE_NEAR_BNO is useful but
once that strategy would allocate two or three consecutive extents you've
lost all the benefit and you would be better off if you started allocating
from the start of the free space. Obviously we don't know the future in
advance but this resembles a classical problem from approximations
algorithms theory (rent-or-buy problem where renting corresponds to
allocating from the end of free space and taking the smaller cost while
buying corresponds to allocation from the beginning, taking the higher
cost, but expecting you won't have to pay anything in future). And the
theory of approximation algorithms tells us that once we pay for renting as
much as buying will cost us, then at that moment it is advantageous to buy
and that gives you 2-approximation algorithm (you can do even better -
factor 1.58 approximation - if you use randomization but I don't think we
want to go that way). So from this I'd say that switching off
XFS_ALLOCTYPE_NEAR_BNO allocation once you've allocated 2-3 extents
backwards would work of better on average.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
