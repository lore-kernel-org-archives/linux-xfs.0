Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5KFmVir099172 for <xfs@oss.sgi.com>; Wed, 20 Jun 2012 10:48:32 -0500
Date: Wed, 20 Jun 2012 10:48:45 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 2/9] xfs: convert internal buffer functions to pass maps
Message-ID: <20120620154845.GK2676@sgi.com>
References: <1339133914-11148-3-git-send-email-david@fromorbit.com>
	<20120618204325.GX4721@sgi.com> <20120618210713.GY4721@sgi.com>
	<20120619071552.GA23093@infradead.org>
	<20120619155946.GA2676@sgi.com>
	<20120619170304.GC7554@infradead.org>
	<20120619171153.GD2676@sgi.com> <20120620055619.GA30705@dastard>
	<20120620060400.GA5617@infradead.org>
	<20120620063508.GD30705@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120620063508.GD30705@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

Hey Dave,

On Wed, Jun 20, 2012 at 04:35:08PM +1000, Dave Chinner wrote:
> On Wed, Jun 20, 2012 at 02:04:00AM -0400, Christoph Hellwig wrote:
> > On Wed, Jun 20, 2012 at 03:56:19PM +1000, Dave Chinner wrote:
> > > > they are rebased not to require the inode allocator patchset.  I think that Jan
> > > > is also going to repost his 'Fix overallocation in xfs_buf_allocate_memory()'
> > > > based upon Dave's suggestions.  It's best not to depend upon that either.  What
> > > > do you say, Dave?
> > > 
> > > I reorder my local patch set and repost it after running it through
> > > some testing....
> > 
> > Sorry, I totally misunderstood the initial issue - I though Ben had my
> > series applied, and thus yours didn't apply.
> > 
> > I still think reordering is better - I'm quite busy and I'd rather get
> > your series reviewed first before redoing and retesting the inode
> > allocator changes.
> 
> I stand corrected - it doesn't need a rebase - all it needs is to be
> applied on top of Jan Kara's bug fix. Looking back, that's exactly
> what I said in patch 0 of the series....
> 
> So it should be good to go as Jan's fix needs to go to Linus before
> 3.5 is released...

Gulp!

When I brought this up I was certain that I couldn't get Dave's series to apply
without Christoph's.  Now it works just fine like so:

~/xfs # cat patches/series
# from christoph
xfs-implement-update_time.patch

# from dave  
xfs-fix-allocbt-cursor-leak-in-xfs_alloc_ag_vextent_near.patch

# Mark's patches
xfs-rename-log-structure-and-remove-xlog_t-typedef.patch
tmp.eUYwHqCBlD-2

# seek data seek hole with unwritten extents
xfs-probe-data-buffer-from-page-cache-for-unwritten-extents.patch

# from Alain
prefix-io_xx-flags-with-xfs_io_xx-to-avoid-namespace-colision.patch

# jan's patch is gonna get a new rev
xfs-fix-overallocation-in-xfs_buf_allocate_memory.patch
# dave's patches 
xfs-separate-buffer-indexing-from-block-map.patch
xfs-convert-internal-buffer-functions-to-pass-maps.patch
xfs-add-discontiguous-buffer-map-interface.patch
xfs-add-discontiguous-buffer-support-to-transactions.patch
xfs-struct-xfs_buf_log_format-isn-t-variable-sized.patch
xfs-support-discontiguous-buffers-in-the-xfs_buf_log_item.patch
xfs-use-multiple-irec-xfs-buf-support-in-dabuf.patch
xfs-remove-struct-xfs_dabuf-and-infrastructure.patch
xfs-factor-buffer-reading-from-xfs_dir2_leaf_getdents.patch

# christoph's patches
xfs-kill-xfs_ialloc_find_free
xfs-split-xfs_dialloc
xfs-simplify-xfs_dialloc
xfs-dialloc-shortcut-second-call
xfs-cleanup-xfs_ialloc_ag_select
xfs-dialloc-cleanup-ag-loop-2
xfs-dialloc-factor-ag_selection-2

# from Jan Englehardt
types.h-implement-intptr_t-and-uintptr_t.patch
xfs-use-standard-u-intptr_t-types.patch


So it appears there is no need to rebase Dave's series.  Apologies!  I got it
wrong, not sure how.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
