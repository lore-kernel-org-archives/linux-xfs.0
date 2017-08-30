Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44192 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751323AbdH3JMI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 30 Aug 2017 05:12:08 -0400
Date: Wed, 30 Aug 2017 17:12:06 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] xfs: skip free eofblocks if inode is under written back
Message-ID: <20170830091206.GB27835@eguan.usersys.redhat.com>
References: <20170830042628.5592-1-eguan@redhat.com>
 <20170830072950.GJ10621@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170830072950.GJ10621@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Aug 30, 2017 at 05:29:50PM +1000, Dave Chinner wrote:
> On Wed, Aug 30, 2017 at 12:26:28PM +0800, Eryu Guan wrote:
> > xfs_vm_writepages() saves a cached imap in a writeback context
> > structure and passes it to xfs_do_writepage() for every page in this
> > writeback, so xfs_writepage_map() (called by xfs_do_writepage())
> > doesn't have to lookup & recalculate the mapping for every buffer it
> > writes if the cached imap is considered as valid.
> > 
> > But there's a chance that the cached imap becomes stale (doesn't
> > match the real extent entry) due to the removing of speculative
> > preallocated blocks, in this case xfs_imap_valid() still reports
> > imap as valid, because the buffer it's writing is still within the
> > cached imap range. This could result in fs corruption and data
> > corruption (data written to wrong block).
> > 
> > For example, the following sequences make it possible (assuming 4k
> > block size XFS):
> > 
> >   1. delalloc write 1072 blocks, with speculative preallocation,
> >   2032 blocks got allocated
> > 
> >   2. started a WB_SYNC_NONE writeback (so it wrote all
> >   PAGECACHE_TAG_DIRTY pages, additional dirty page from step 4 can
> >   be picked up, this could be a background writeback, or a bare
> >   SYNC_FILE_RANGE_WRITE sync_file_range() call) on this inode,
> >   filled in br_startblock, converted delayed allocation to real
> >   allocation, but br_blockcount was unchanged, still 2032, and this
> >   imap got cached in writeback context structure for writing
> >   subsequent pages
> 
> Excellent work in tracking this down, Eryu! This has been a
> longstanding issue - we've been caching the writeback map for
> multi-page writeback since, well, longer than I've been working on
> XFS....

If I read the git history correctly, previously the imap was only cached
for buffer heads within the same page, commit fbcc02561359 ("xfs:
Introduce writeback context for writepages") made the cached imap live
longer, across the whole xfs_vm_writepages() call, which made the window
wider.

But I can't reproduce the bug until commit bb18782aa47d ("xfs: build bios
directly in xfs_add_to_ioend"), I didn't dig into it deeply, perhaps it
made the window even wider?

> 
> First thing - checking for PAGECACHE_TAG_WRITEBACK in xfs_release()
> is racy as writeback can start between the check and the EOF blocks
> being trimmed in xfs_free_eofblocks(), so it's not really a solution
> to the problem.

Ah, you're right, I missed that. 

> 
> The root cause of the problem is that xfs_imap_valid() code doesn't
> return false when the extent tree is modified and the map is
> rendered potentially incorrect. If this was to notice we changed the
> extent tree, it would trigger the writeback code to look up a new
> map.
> 
> Hmmmm, that means the scope is probably wider than
> xfs_free_eofblocks() - that's a xfs_bunmapi call, but we've also got
> to consider that other IO operations might change the extent map,
> too.

Agreed, I did think about a way to notify writeback code an extent
change was made, but I didn't know the relevant code well enough to do
this nicely. And I thought free eofblocks in xfs_release() was the only
place that could race with writeback to cause problems, so I thought
simply skipping free eoflblocks was easier.

> 
> Quick patch below, doesn't work on reflink filesystems yet because
> the way it handles cached COW mapping invalidation is unnecessarily
> special and so doesn't work.

I've hit this problem and the same assert failure when I was testing
another version of fix, the usage of xfs_map_cow() cut the imap
validation work flow :)

(The basic idea of another version of my fix is comparing timestamp
saved in struct xfs_inode at free eofblocks time with timestamp saved in
struct xfs_writepage_ctx, if timestamp in xfs_inode is newer than that
in xfs_writepage_ctx, invalidate the cached imap and map it again. But
that still only focused on free of eofblocks, ignored other paths that
might change the map.)

> Can you test it and see if it fixes the
> problem?

Yes, patch works for me, lustre-racer test survived 50 iterations,
previously it would fail within 5 runs.

Thanks!

Eryu
