Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A21827CA2
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2016 14:24:45 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3D70AAC002
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2016 12:24:42 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	KaiCe3ypI68uOCcA for <xfs@oss.sgi.com>;
	Thu, 11 Feb 2016 12:24:39 -0800 (PST)
Date: Fri, 12 Feb 2016 07:21:48 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: block allocations for the refcount btree
Message-ID: <20160211202148.GH19486@dastard>
References: <20160210093011.GA19147@infradead.org>
	<20160210095010.GC23904@birch.djwong.org>
	<20160210190738.GA13051@infradead.org>
	<20160210214058.GN14668@dastard>
	<20160211140936.GB4156@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160211140936.GB4156@bfoster.bfoster>
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
Cc: Christoph Hellwig <hch@infradead.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, xfs@oss.sgi.com

On Thu, Feb 11, 2016 at 09:09:37AM -0500, Brian Foster wrote:
> On Thu, Feb 11, 2016 at 08:40:58AM +1100, Dave Chinner wrote:
> > On Wed, Feb 10, 2016 at 11:07:38AM -0800, Christoph Hellwig wrote:
> > > On Wed, Feb 10, 2016 at 01:50:10AM -0800, Darrick J. Wong wrote:
> > > > That's odd... I'd have thought that the AG reservation would always be able
> > > > to handle a refcount btree expansion, since it calculates how many blocks
> > > > are needed to handle the worst case of 1 record per extent.  There's also
> > > > a bug where we undercount the number of blocks already used, so it should
> > > > have an extra big reservation.
> > > > 
> > > > OTOH I've seen occasional ENOSPCs in generic/186 and generic/168 too, so I
> > > > guess something's going wrong.  Maybe the xfs_ag_resv* tracepoints can help?
> > > 
> > > I'm not seeing an ENOSPC, I run into:
> > > 
> > > [  640.924891] XFS: Assertion failed: tp->t_blk_res_used <= tp->t_blk_res, file: fs/xfs/xfs_trans.c, line: 315
> > 
> > I run into that from time to time (maybe once a month) on a vanilla
> > kernel.
> > 
> 
> Any idea which test reproduces? I see that generic/033 resulted from the
> discussion below on the rfc. I don't currently reproduce with that test,
> however. The test mentions it uses fzero because zero range doesn't do
> writeback (comments ftw :) and thus allows splitting of delalloc
> extents, but it looks like that might no longer be the case in the
> kernel (since zero range was simplified to reuse punch/alloc).

It's usually one of the fsstress tests that triggers it. For some
reason generic/233 sticks in my mind, but it's a pretty rare failure
these days...

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
> > 
> 
> I recall working on this, but not quite where it left off. If I dig back
> to my old tree from before the oss.sgi.com->vger switchover, I have a v1
> branch for this work that was posted here:
> 
> http://oss.sgi.com/archives/xfs/2014-10/msg00294.html
> 
> It looks like we just never got it reviewed and I since lost track of
> it. I can resurrect it if warranted. I would like to nail down a current
> reproducer though...

*nod*. Not sure what we can use to trigger it, though.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
