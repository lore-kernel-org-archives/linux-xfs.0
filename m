Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5C9937CBB
	for <xfs@oss.sgi.com>; Tue,  1 Mar 2016 12:18:51 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1C14A304032
	for <xfs@oss.sgi.com>; Tue,  1 Mar 2016 10:18:48 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id eLBTPNa9iJJAmXwC (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 01 Mar 2016 10:18:45 -0800 (PST)
Date: Tue, 1 Mar 2016 10:18:09 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: block allocations for the refcount btree
Message-ID: <20160301181809.GC27973@birch.djwong.org>
References: <20160210093011.GA19147@infradead.org>
	<20160210095010.GC23904@birch.djwong.org>
	<20160210190738.GA13051@infradead.org>
	<20160210214058.GN14668@dastard>
	<20160212191046.GA28421@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160212191046.GA28421@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Fri, Feb 12, 2016 at 11:10:46AM -0800, Christoph Hellwig wrote:
> On Thu, Feb 11, 2016 at 08:40:58AM +1100, Dave Chinner wrote:
> > I run into that from time to time (maybe once a month) on a vanilla
> > kernel.
> > 
> > IIRC, the problem is the delayed allocation extent split runs out of
> > it's reserved block count if you split it enough times. The case
> > I've seen is that  the indlen calculated in xfs_bmap_worst_indlen()
> > ends up too small for a subsequent allocation after we've called
> > xfs_bmap_del_extent() to delete the middle of a delalloc extent too
> > many times.
> > 
> > Brian had some patches that attempted to solve it - we may have
> > simply dropped the ball on this (again).
> > 
> > http://oss.sgi.com/archives/xfs/2014-09/msg00337.html
> 
> I'm pretty sure that is a separate issue.  With the refcount btree we may
> allocate an extent (or rather just a single block) in xfs_alloc_ag_vextent
> as called from xfs_refcountbt_alloc_block.  The reservation helps us to
> ensure this block is always available, but we still need to account for
> that in xfs_trans_reserve(), which we currently don't do for itruncate
> transactions.  

One side effect of the per-ag block reservation code is that it reserves all
the blocks that the refcountbt will ever need at mount time, which includes
decreasing the incore fdblocks counter at mount and putting it back at unmount
time.  This /should/ eliminate the need for reserving blocks in truncate
transactions, though clearly this isn't being done correctly.  The AGresv code
as of a couple weeks ago tried to monkey with the transaction block reservation
counts after the allocator does its usual accounting, which as you observe,
doesn't work.

Dave suggested that I embed the AGresv structures directly into xfs_perag, and
I realized that we'll only ever need two of these things -- one to feed the
AGFL (rmapbt) and another to feed the higher level btrees (refcountbt).  At the
same time, I decided that because the AGresv code ultimately knows whether an
allocation request was satisfied from a reservation or from the free space
btree, it should also have a hand in deciding whether or not to update the
transaction's block reservation.

So what I'm saying is that I think this problem was with the AGresv code not
doing accounting correctly, and that I've fixed it in a subsequent rewrite of
the AGresv code.  I'll post it later, after I figure out why generic/333
regresses with the new code.

However, there's one thing to be aware of -- if the AGresv uses up all the
blocks that were preallocated at mount time, the allocator will grab any free
blocks available and charge the blocks to the transaction, just like before.
If this ever happens (in theory we reserve enough blocks so that we can have a
refcount record for every block in the AG) then we'll still have this problem.

The most cautious thing to do, I think, is to combine the AGresv fixes with
this patch that adds a block reservation to truncate transactions in case the
AGresv can't supply a block to the refcount btree.  The problem here is that
for most cases we'll have both the AGresv and the transaction reserving blocks
for the same purpose, which seems excessive.  Moreover, it introduces the
possibility of userspace seeing ENOSPC while truncating files even if there's
actually sufficient space to handle a refcountbt split.

<shrug> What does everyone else think?

--D

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
