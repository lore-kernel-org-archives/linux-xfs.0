Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 44C9F7CA4
	for <xfs@oss.sgi.com>; Wed, 13 Jul 2016 18:50:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EB3038F8033
	for <xfs@oss.sgi.com>; Wed, 13 Jul 2016 16:50:41 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	FcTm1euagFd0VbZ7 for <xfs@oss.sgi.com>;
	Wed, 13 Jul 2016 16:50:39 -0700 (PDT)
Date: Thu, 14 Jul 2016 09:50:36 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 031/119] xfs: rmap btree requires more reserved free space
Message-ID: <20160713235036.GP1922@dastard>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
	<146612647122.12839.13018596528662402580.stgit@birch.djwong.org>
	<20160708132154.GC59278@bfoster.bfoster>
	<20160713165008.GH13625@birch.djwong.org>
	<20160713183216.GD34396@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160713183216.GD34396@bfoster.bfoster>
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
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, xfs@oss.sgi.com, Dave Chinner <dchinner@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>

On Wed, Jul 13, 2016 at 02:32:17PM -0400, Brian Foster wrote:
> On Wed, Jul 13, 2016 at 09:50:08AM -0700, Darrick J. Wong wrote:
> > On Fri, Jul 08, 2016 at 09:21:55AM -0400, Brian Foster wrote:
> > > >  /*
> > > > + * In order to avoid ENOSPC-related deadlock caused by out-of-order locking of
> > > > + * AGF buffer (PV 947395), we place constraints on the relationship among
> > > > + * actual allocations for data blocks, freelist blocks, and potential file data
> > > > + * bmap btree blocks. However, these restrictions may result in no actual space
> > > > + * allocated for a delayed extent, for example, a data block in a certain AG is
> > > > + * allocated but there is no additional block for the additional bmap btree
> > > > + * block due to a split of the bmap btree of the file. The result of this may
> > > > + * lead to an infinite loop when the file gets flushed to disk and all delayed
> > > > + * extents need to be actually allocated. To get around this, we explicitly set
> > > > + * aside a few blocks which will not be reserved in delayed allocation.
> > > > + *
> > > > + * The minimum number of needed freelist blocks is 4 fsbs _per AG_ when we are
> > > > + * not using rmap btrees a potential split of file's bmap btree requires 1 fsb,
> > > > + * so we set the number of set-aside blocks to 4 + 4*agcount when not using
> > > > + * rmap btrees.
> > > > + *
> > > 
> > > That's a bit wordy.
> > 
> > Yikes, that whole thing is a single sentence!
> > 
> > One thing I'm not really sure about is how "a potential split of file's bmap
> > btree requires 1 fsb" seems to translate to 4 in the actual formula.  I'd
> > have thought it would be m_bm_maxlevels or something... not just 4.
> > 
> 
> I'm not sure about that either, tbh.

So, a trip down memory lane. 

<wavy line dissolve>

Back in 2006, I fixed a bug that changed XFS_ALLOC_SET_ASIDE from
a  fixed value of 8 blocks to 4 blocks + 4 AGFL blocks per AG in
commit 4be536de ("[XFS] Prevent free space
oversubscription and xfssyncd looping."). The original value of
8 was for 4 blocks for the bmbt split, and 4 blocks from the current
AG for the AGFL (commit message explains the reason this was a
problem (Yay for writing good commit messages 10 years ago!)). The
oringinal comment text was:

- * reserved in delayed allocation. Considering the minimum number of
- * needed freelist blocks is 4 fsbs, a potential split of file's bmap
- * btree requires 1 fsb, so we set the number of set-aside blocks to 8.
-*/

So we need to go back further. We have an obvious git log search
target in the comment (PV#947395), and that points to:

commit d210a28cd851082cec9b282443f8cc0e6fc09830
Author: Yingping Lu <yingping@sgi.com>
Date:   Fri Jun 9 14:55:18 2006 +1000

    [XFS] In actual allocation of file system blocks and freeing extents, the
    transaction within each such operation may involve multiple locking of AGF
    buffer. While the freeing extent function has sorted the extents based on
    AGF number before entering into transaction, however, when the file system
    space is very limited, the allocation of space would try every AGF to get
    space allocated, this could potentially cause out-of-order locking, thus
    deadlock could happen. This fix mitigates the scarce space for allocation
    by setting aside a few blocks without reservation, and avoid deadlock by
    maintaining ascending order of AGF locking.
    
    SGI-PV: 947395
    SGI-Modid: xfs-linux-melb:xfs-kern:210801a
    
    Signed-off-by: Yingping Lu <yingping@sgi.com>
    Signed-off-by: Nathan Scott <nathans@sgi.com>

Which tells us nothing about why 1 fsb for the bmbt split was
actually reserved as 4fsbs. IIRC, I ended up having to find and fix
the problem because Yingping left SGI soon after this fix was made,
and at the time nobody understood or could work out why that was
done. It worked, however, so we left it that way, and just fixed the
per-ag reservation problem this bug fix had.


> > /* 
> >  * When rmap is disabled, we need to reserve 4 fsbs _per AG_ for the freelist
> >  * and 4 more to handle a potential split of the file's bmap btree.

As such, I'm not sure that is any more correct than the original
comment.

Looking back on this now with 10 years more time working on XFS, my
suspicion is that a single level bmap btree split requires 1
block to be allocated, but that allocation will call
xfs_alloc_fix_freelist() to refill the freelist to the minimum
(which is 4 blocks), and so we need at least 4 blocks for the
allocation to succeed (4 blocks for the freelist fill, and if we are
at ENOSPC then the bmap btree block will be allocated from the
AGFL).

Whether the value of 4 is correct or not for this purpose is just a
guess based on the per-ag AGFL requirements, so my only comment
right now is: it's worked for 10 years, so let's not change it until
there's at least some evidence that is it wrong.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
