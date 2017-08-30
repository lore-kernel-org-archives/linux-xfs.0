Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45238 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751691AbdH3O0d (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 30 Aug 2017 10:26:33 -0400
Date: Wed, 30 Aug 2017 10:26:31 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: skip free eofblocks if inode is under written back
Message-ID: <20170830142631.GA16641@bfoster.bfoster>
References: <20170830042628.5592-1-eguan@redhat.com>
 <20170830072950.GJ10621@dastard>
 <20170830091206.GB27835@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170830091206.GB27835@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org

On Wed, Aug 30, 2017 at 05:12:06PM +0800, Eryu Guan wrote:
> On Wed, Aug 30, 2017 at 05:29:50PM +1000, Dave Chinner wrote:
> > On Wed, Aug 30, 2017 at 12:26:28PM +0800, Eryu Guan wrote:
> > > xfs_vm_writepages() saves a cached imap in a writeback context
> > > structure and passes it to xfs_do_writepage() for every page in this
> > > writeback, so xfs_writepage_map() (called by xfs_do_writepage())
> > > doesn't have to lookup & recalculate the mapping for every buffer it
> > > writes if the cached imap is considered as valid.
> > > 
> > > But there's a chance that the cached imap becomes stale (doesn't
> > > match the real extent entry) due to the removing of speculative
> > > preallocated blocks, in this case xfs_imap_valid() still reports
> > > imap as valid, because the buffer it's writing is still within the
> > > cached imap range. This could result in fs corruption and data
> > > corruption (data written to wrong block).
> > > 
> > > For example, the following sequences make it possible (assuming 4k
> > > block size XFS):
> > > 
> > >   1. delalloc write 1072 blocks, with speculative preallocation,
> > >   2032 blocks got allocated
> > > 
> > >   2. started a WB_SYNC_NONE writeback (so it wrote all
> > >   PAGECACHE_TAG_DIRTY pages, additional dirty page from step 4 can
> > >   be picked up, this could be a background writeback, or a bare
> > >   SYNC_FILE_RANGE_WRITE sync_file_range() call) on this inode,
> > >   filled in br_startblock, converted delayed allocation to real
> > >   allocation, but br_blockcount was unchanged, still 2032, and this
> > >   imap got cached in writeback context structure for writing
> > >   subsequent pages
> > 

Thanks Eryu, nice work indeed. :) FWIW, I have patch (appended) that
helps detect this problem consistently in DEBUG mode by essentially
revalidating the ioend at submit time. I suppose it could be updated to
validate the bio target as well, but care to validate that independently
and possibly include it in your next post?

> > Excellent work in tracking this down, Eryu! This has been a
> > longstanding issue - we've been caching the writeback map for
> > multi-page writeback since, well, longer than I've been working on
> > XFS....
> 
> If I read the git history correctly, previously the imap was only cached
> for buffer heads within the same page, commit fbcc02561359 ("xfs:
> Introduce writeback context for writepages") made the cached imap live
> longer, across the whole xfs_vm_writepages() call, which made the window
> wider.
>

The difference here is that the previous code used xfs_cluster_write()
which implicitly limited the scope of the cached mapping to within EOF.
By implicitly, I mean that we only flushed up to EOF at the time the
mapping was created. I think this aspect of the problem is sort of a
regression as of the writeback rework and could be addressed by simply
trimming the cached mapping to EOF (I had previously run a test that
allowed the lustre-racer test to survive a weekend without any issues
with such a tweak). Note that the previous code also limited the
lifetime of the cached mapping to a single writeback "cycle," fwiw.

Given the nature of the above, could we try to independently verify
whether there is also an issue that might go further back than that?
Even if these are both fixed by the same patch, it would be good to have
independent analysis of the separate issues in the commit logs. For
example, what happens if writeback maps a largish delalloc extent, then
stalls (i.e., introduce an artificial delay), and then some other task
comes in and truncates off the last block of the just allocated extent
and then does another buffered write to place a delalloc block at that
offset? Note that hole punch probably won't work here because it waits
for writeback. Also note that this may be further complicated by the
fact that some writeback cases tag the pages to writeback up front.

> But I can't reproduce the bug until commit bb18782aa47d ("xfs: build bios
> directly in xfs_add_to_ioend"), I didn't dig into it deeply, perhaps it
> made the window even wider?
> 

Perhaps doing bio allocation at page processing time rather than submit
time is enough to stretch the window the mapping has to remain valid..?
I believe we've always done ioend allocation at this time, but those
look like they come from a memory pool and so may return quickly.

Brian

--- 8< ---

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 6bf120b..71b55b0 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -457,6 +457,47 @@ static inline int xfs_bio_add_buffer(struct bio *bio, struct buffer_head *bh)
 	return bio_add_page(bio, bh->b_page, bh->b_size, bh_offset(bh));
 }
 
+#ifdef DEBUG
+static int
+xfs_validate_ioend(
+	struct xfs_ioend	*ioend)
+{
+	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
+	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
+	struct xfs_mount	*mp = ip->i_mount;
+	xfs_fileoff_t		offset = XFS_B_TO_FSB(mp, ioend->io_offset);
+	xfs_filblks_t		count = XFS_B_TO_FSB(mp, ioend->io_size);
+	xfs_extnum_t		idx;
+	struct xfs_bmbt_irec	got;
+	int			error;
+
+	xfs_ilock(ip, XFS_ILOCK_SHARED);
+
+	error = -EFSCORRUPTED;
+	while (count) {
+		if (!xfs_iext_lookup_extent(ip, ifp, offset, &idx, &got))
+			goto out;
+		if (isnullstartblock(got.br_startblock))
+			goto out;
+		offset += got.br_blockcount;
+		count -= min_t(xfs_filblks_t, count, got.br_blockcount);
+	}
+
+	error = 0;
+out:
+	xfs_iunlock(ip, XFS_ILOCK_SHARED);
+	if (error) {
+		xfs_alert(mp,
+		"I/O submission to invalid extent (ino 0x%llx offset 0x%llx).",
+			  ip->i_ino, ioend->io_offset);
+		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+	}
+	return error;
+}
+#else
+#define xfs_validate_ioend(ioend)	(0)
+#endif
+
 /*
  * Submit the bio for an ioend. We are passed an ioend with a bio attached to
  * it, and we submit that bio. The ioend may be used for multiple bio
@@ -506,6 +547,10 @@ xfs_submit_ioend(
 		return status;
 	}
 
+	status = xfs_validate_ioend(ioend);
+	if (status)
+		return status;
+
 	ioend->io_bio->bi_write_hint = ioend->io_inode->i_write_hint;
 	submit_bio(ioend->io_bio);
 	return 0;
