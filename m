Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8P0tJ9v239345 for <xfs@oss.sgi.com>; Mon, 24 Sep 2012 19:55:19 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	C8cyYKbc5ACUbGBc for <xfs@oss.sgi.com>;
	Mon, 24 Sep 2012 17:56:34 -0700 (PDT)
Date: Tue, 25 Sep 2012 10:56:32 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/3] xfs: allocation worker causes freelist buffer lock
	hang
Message-ID: <20120925005632.GB23520@dastard>
References: <20120924171159.GG1140@sgi.com>
	<201209241809.q8OI94s3003323@eagdhcp-232-125.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201209241809.q8OI94s3003323@eagdhcp-232-125.americas.sgi.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Mark Tinguely <tinguely@eagdhcp-232-125.americas.sgi.com>
Cc: bpm@sgi.com, tinguely@sgi.com, xfs@oss.sgi.com

On Mon, Sep 24, 2012 at 01:09:04PM -0500, Mark Tinguely wrote:
> > From bpm@sgi.com Mon Sep 24 12:11:59 2012
> > Date: Mon, 24 Sep 2012 12:11:59 -0500
> > From: Ben Myers <bpm@sgi.com>
> > To: <tinguely@sgi.com>
> > Subject: Re: [PATCH 0/3] xfs: allocation worker causes freelist buffer lock
> > 	hang
> > Cc: <xfs@oss.sgi.com>
> >
> > Hi Mark,
> >
> > On Wed, Sep 19, 2012 at 11:31:33AM -0500, tinguely@sgi.com wrote:
> > ...
> > > I traced the callers of xfs_alloc_vextent(), noting transaction creation,
> > > commits and cancels; I noted loops in the callers and which were marked
> > > as metadata/userdata. I can send this document to reviewers.
> >
> > I'd like to see the doc of xfs_alloc_vextent callers and which of them loop.
> > Can you post your doc to the list?
> >
> > Regards,
> > 	Ben
> 
> 
> Here are the Linux 3.6.x callers of xfs_alloc_vextent() stopping at the
> transaction commit/cancel level.
> 
> XFS_BMAPI_METADATA *not* being set implies user data.
> 
> Userdata being set is the community designated indication that an allocate
> worker is needed to prevent the overflow of the kernel stack.
> 
> Calling xfs_alloc_vextent() several times with the same transaction can cause
> a dead lock if a new allocation worker can not be allocated. I noted where the
> loops occur. xfs_alloc_vextent() can call itself, those calls must be in the
> same allocation worker. 
> 
> As a bonus, consolidating the loops into one worker actually gives a slight
> performance advantage.

Can you quantify it?


> Sorry this is wider than 80 characters wide.
> 		---
> xfs_bmap_btalloc(xfs_bmalloca_t)
> ! xfs_bmap_alloc(xfs_bmalloca_t)
> ! ! xfs_bmapi_allocate(xfs_bmalloca_t, ...)
> ! ! ! xfs_bmapi_write(xfs_trans_t ...)  loops over above
> ! ! ! ! xfs_attr_rmtval_set(xfs_da_args_t) loops over bmapi_write (xfs_attr_set_int) **XFS_BMAPI_METADATA**
> ! ! ! ! xfs_da_grow_inode_int(xfs_da_args_t) loops over bmapi_write **XFS_BMAPI_METADATA**
> ! ! ! ! xfs_qm_dqalloc(xfs_trans_t ...) does a xfs_bmap_finish/cancel **XFS_BMAPI_METADATA**
> ! ! ! ! xfs_iomap_write_direct(...) alloc trans, xfs_trans_commit/cancel
> ! ! ! ! xfs_iomap_write_allocate(...) alloc trans, xfs_trans_commit/cancel safe loop
> ! ! ! ! xfs_iomap_write_unwritten(..) alloc trans, xfs_trans_commit/cancel safe loop
> ! ! ! ! xfs_growfs_rt_alloc(..) alloc trans, xfs_trans_commit/cancel safe loop
> ! ! ! ! xfs_symlink(...) allocates trans does a xfs_trans_commit/cancel
> ! ! ! ! xfs_alloc_file_space(...) alloc trans, xfs_trans_commit/cancel safe loop

So the only data path callers though here are
xfs_iomap_write_direct(), xfs_iomap_write_allocate() and
xfs_iomap_write_unwritten() and xfs_alloc_file_space(). Everything
else is metadata, so won't use 

> xfs_bmap_extents_to_btree(xfs_trans_t ...) <- set userdata to 0 (patch 3)
> ! xfs_bmap_add_attrfork_extents(xfs_trans_t ...)
> ! ! xfs_bmap_add_attrfork(...) allocates trans does a xfs_trans_commit/cancel
> ! xfs_bmap_add_extent_delay_real(fs_bmalloca)
> ! ! xfs_bmapi_allocate(xfs_bmalloca_t, ...)
> ! ! ! <see above>
> ! xfs_bmap_add_extent_unwritten_real(xfs_trans_t ...)
> ! ! xfs_bmapi_convert_unwritten(xfs_bmalloca ...)
> ! ! ! xfs_bmapi_write(xfs_trans ...) calls xfs_bmapi_convert_unwritten in loop XFS_BMAPI_METADATA
> ! ! ! ! ... <see above>
.....
> ! xfs_bmap_add_extent_hole_real(xfs_bmalloca ...)
> ! ! xfs_bmapi_allocate(xfs_bmalloca_t, ...)
> ! ! ! ... <see above>

So it's bmbt modification that looks to be the problem here, right?

> xfs_bmap_local_to_extents(xfs_trans_t ...)     <- set userdata to 0 (patch 3)
> ! xfs_bmap_add_attrfork_local(xfs_trans_t ..)
> ! ! xfs_bmap_add_attrfork(...) trans alloc, bmap_finish trans_commit/cancel
> ! xfs_bmapi_write(xfs_trans_t ...) XFS_BMAPI_METADATA
> ! ! ... <see above>

Same here.

That's all I can see as problematic - maybe I read the output wrong
and there's others?

i.e. all other xfs_alloc_vextent() callers are either in metadata
context (so don't use the workqueue) or commit the transaction
directly after xfs_bmapi_write returns so will unlock the AGF buffer
before calling into xfs_bmapi_write a second time.

If these are the only loops, then patch 3 is all that is
necessary to avoid the problem of blocking on workqueue resource
while we are already on the workqueue, right? i.e. bmbt allocation
is a metadata allocation, even though the context is a data
allocation, and ensuring it is metadata means that the current
transaction won't get blocked waiting for workqueue resources...

What am I missing?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
