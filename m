Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p614Iwqw028257 for <xfs@oss.sgi.com>; Thu, 30 Jun 2011 23:18:58 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E5206178ADED
	for <xfs@oss.sgi.com>; Thu, 30 Jun 2011 21:18:54 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	OdA17FrAyDNF2ha0 for <xfs@oss.sgi.com>;
	Thu, 30 Jun 2011 21:18:54 -0700 (PDT)
Date: Fri, 1 Jul 2011 14:18:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 03/27] xfs: use write_cache_pages for writeback clustering
Message-ID: <20110701041851.GN561@dastard>
References: <20110629140109.003209430@bombadil.infradead.org>
	<20110629140336.950805096@bombadil.infradead.org>
	<20110701022248.GM561@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110701022248.GM561@dastard>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Fri, Jul 01, 2011 at 12:22:48PM +1000, Dave Chinner wrote:
> On Wed, Jun 29, 2011 at 10:01:12AM -0400, Christoph Hellwig wrote:
> > Instead of implementing our own writeback clustering use write_cache_pages
> > to do it for us.  This means the guts of the current writepage implementation
> > become a new helper used both for implementing ->writepage and as a callback
> > to write_cache_pages for ->writepages.  A new struct xfs_writeback_ctx
> > is used to track block mapping state and the ioend chain over multiple
> > invocation of it.
> > 
> > The advantage over the old code is that we avoid a double pagevec lookup,
> > and a more efficient handling of extent boundaries inside a page for
> > small blocksize filesystems, as well as having less XFS specific code.
> 
> It's not more efficient right now, due to a little bug:
.....
> With the following patch, the trace output now looks like this for
> delalloc writeback:
> 
>            <...>-12623 [000] 694093.594883: xfs_writepage:        dev 253:16 ino 0x2300a5 pgoff 0x505000 size 0xa00000 offset 0 delalloc 1 unwritten 0
>            <...>-12623 [000] 694093.594884: xfs_writepage:        dev 253:16 ino 0x2300a5 pgoff 0x506000 size 0xa00000 offset 0 delalloc 1 unwritten 0
>            <...>-12623 [000] 694093.594884: xfs_writepage:        dev 253:16 ino 0x2300a5 pgoff 0x507000 size 0xa00000 offset 0 delalloc 1 unwritten 0
>            <...>-12623 [000] 694093.594885: xfs_writepage:        dev 253:16 ino 0x2300a5 pgoff 0x508000 size 0xa00000 offset 0 delalloc 1 unwritten 0
>            <...>-12623 [000] 694093.594885: xfs_writepage:        dev 253:16 ino 0x2300a5 pgoff 0x509000 size 0xa00000 offset 0 delalloc 1 unwritten 0
>            <...>-12623 [000] 694093.594886: xfs_writepage:        dev 253:16 ino 0x2300a5 pgoff 0x50a000 size 0xa00000 offset 0 delalloc 1 unwritten 0
>            <...>-12623 [000] 694093.594887: xfs_writepage:        dev 253:16 ino 0x2300a5 pgoff 0x50b000 size 0xa00000 offset 0 delalloc 1 unwritten 0
>            <...>-12623 [000] 694093.594888: xfs_writepage:        dev 253:16 ino 0x2300a5 pgoff 0x50c000 size 0xa00000 offset 0 delalloc 1 unwritten 0
> 
> 
> i.e. there mapping lookup is no longer occurring for every page.
> 
> As a side effect, the failure case I'm seeing with test 180 has gone
> from 5-10 files with the wrong size to >200 files with the wrong
> size with this patch, so clearly there is something wrong with file
> size updates getting to disk that this patch set makes worse.

I'm now only running test 180 on 100 files rather than the 1000 the
test normally runs on, because it's faster and still shows the
problem.  That means the test is only using 1GB of disk space, and
I'm running on a VM with 1GB RAM. It appears to be related to the VM
triggering random page writeback from the LRU - 100x10MB files more
than fills memory, hence it being the smallest test case i could
reproduce the problem on.

My triage notes are as follows, and the patch that fixes the bug is
attached below.

--- 180.out     2010-04-28 15:00:22.000000000 +1000
+++ 180.out.bad 2011-07-01 12:44:12.000000000 +1000
@@ -1 +1,9 @@
 QA output created by 180
+file /mnt/scratch/81 has incorrect size 10473472 - sync failed
+file /mnt/scratch/86 has incorrect size 10371072 - sync failed
+file /mnt/scratch/87 has incorrect size 10104832 - sync failed
+file /mnt/scratch/88 has incorrect size 10125312 - sync failed
+file /mnt/scratch/89 has incorrect size 10469376 - sync failed
+file /mnt/scratch/90 has incorrect size 10240000 - sync failed
+file /mnt/scratch/91 has incorrect size 10362880 - sync failed
+file /mnt/scratch/92 has incorrect size 10366976 - sync failed

$ ls -li /mnt/scratch/ | awk '/rw/ { printf("0x%x %d %d\n", $1, $6, $10); }'
0x244093 10473472 81
0x244098 10371072 86
0x244099 10104832 87
0x24409a 10125312 88
0x24409b 10469376 89
0x24409c 10240000 90
0x24409d 10362880 91
0x24409e 10366976 92

So looking at inode 0x244099 (/mnt/scratch/87), the last setfilesize
call in the trace (got a separate patch for that) is:

           <...>-393   [000] 696245.229559: xfs_ilock_nowait:     dev 253:16 ino 0x244099 flags ILOCK_EXCL caller xfs_setfilesize
           <...>-393   [000] 696245.229560: xfs_setfilesize:      dev 253:16 ino 0x244099 isize 0xa00000 disize 0x94e000 new_size 0x0 offset 0x600000 count 3813376
           <...>-393   [000] 696245.229561: xfs_iunlock:          dev 253:16 ino 0x244099 flags ILOCK_EXCL caller xfs_setfilesize

For an IO that was from offset 0x600000 for just under 4MB. The end
of that IO is at byte 10104832, which is _exactly_ what the inode
size says it is.

It is very clear that from the IO completions that we are getting a
*lot* of kswapd driven writeback directly through .writepage:

$ grep "xfs_setfilesize:" t.t |grep "4096$" | wc -l
801
$ grep "xfs_setfilesize:" t.t |grep -v "4096$" | wc -l
78

So there's ~900 IO completions that change the file size, and 90% of
them are single page updates.

$ ps -ef |grep [k]swap
root       514     2  0 12:43 ?        00:00:00 [kswapd0]
$ grep "writepage:" t.t | grep "514 " |wc -l
799

Oh, now that is too close to just be a co-incidence. We're getting
significant amounts of random page writeback from the the ends of
the LRUs done by the VM.

<sigh>

back on topic:

           <...>-393   [000] 696245.511905: xfs_ilock_nowait:     dev 253:16 ino 0x24409e flags ILOCK_EXCL caller xfs_setfilesize
           <...>-393   [000] 696245.511906: xfs_setfilesize:      dev 253:16 ino 0x24409e isize 0xa00000 disize 0x99e000 new_size 0x0 offset 0x99e000 count 4096
           <...>-393   [000] 696245.511906: xfs_iunlock:          dev 253:16 ino 0x24409e flags ILOCK_EXCL caller xfs_setfilesize

Completion that updated the file size

           <...>-393   [000] 696245.515279: xfs_ilock_nowait:     dev 253:16 ino 0x24409e flags ILOCK_EXCL caller xfs_setfilesize
           <...>-393   [000] 696245.515280: xfs_iunlock:          dev 253:16 ino 0x24409e flags ILOCK_EXCL caller xfs_setfilesize

Immediately followed by one that didn't.

           <...>-2619  [000] 696245.806576: xfs_writepage:        dev 253:16 ino 0x24409e pgoff 0x858000 size 0xa00000 offset 0 delalloc 1 unwritten 0
           <...>-2619  [000] 696245.806578: xfs_ilock:            dev 253:16 ino 0x24409e flags ILOCK_SHARED caller xfs_map_blocks
           <...>-2619  [000] 696245.806579: xfs_iunlock:          dev 253:16 ino 0x24409e flags ILOCK_SHARED caller xfs_map_blocks
           <...>-2619  [000] 696245.806579: xfs_map_blocks_found: dev 253:16 ino 0x24409e size 0x99f000 new_size 0x0 offset 0x858000 count 1024 type  startoff 0x0 startblock 931888 blockcount 0x2800

New writepage call, showing the on disk file size matches with the last  xfs_setfilesize call.

           <...>-2619  [000] 696245.806581: xfs_writepage:        dev 253:16 ino 0x24409e pgoff 0x859000 size 0xa00000 offset 0 delalloc 1 unwritten 0
           <...>-2619  [000] 696245.806582: xfs_writepage:        dev 253:16 ino 0x24409e pgoff 0x85a000 size 0xa00000 offset 0 delalloc 1 unwritten 0
.....
           <...>-2619  [000] 696245.806825: xfs_writepage:        dev 253:16 ino 0x24409e pgoff 0x9fc000 size 0xa00000 offset 0 delalloc 1 unwritten 0
           <...>-2619  [000] 696245.806826: xfs_writepage:        dev 253:16 ino 0x24409e pgoff 0x9fd000 size 0xa00000 offset 0 delalloc 1 unwritten 0
           <...>-2619  [000] 696245.806827: xfs_writepage:        dev 253:16 ino 0x24409e pgoff 0x9fe000 size 0xa00000 offset 0 delalloc 1 unwritten 0
           <...>-2619  [000] 696245.806828: xfs_writepage:        dev 253:16 ino 0x24409e pgoff 0x9ff000 size 0xa00000 offset 0 delalloc 1 unwritten 0

Ummmm, hold on just a second there. We've already written the page
at pgoff 0x9fe000: how else did we get that completion and file size
update?  So how come that page is still considered to be dirty *and*
delalloc?  WTF?

Ok, so limit the tracing to writepage, block map and setfilesize
events to try to see what is going on.

           <...>-514   [000] 699227.049423: xfs_writepage:        dev 253:16 ino 0x21c098 pgoff 0x88a000 size 0xa00000 offset 0 delalloc 1 unwritten 0
           <...>-514   [000] 699227.049426: xfs_map_blocks_found: dev 253:16 ino 0x21c098 size 0x0 new_size 0x0 offset 0x88a000 count 1024 type  startoff 0x0 startblock 870448 blockcount 0x2800
           <...>-393   [000] 699227.229449: xfs_setfilesize:      dev 253:16 ino 0x21c098 isize 0xa00000 disize 0x0 new_size 0x0 offset 0x0 count 2097152
           <...>-514   [000] 699227.251726: xfs_writepage:        dev 253:16 ino 0x21c098 pgoff 0x88b000 size 0xa00000 offset 0 delalloc 1 unwritten 0
           <...>-514   [000] 699227.251729: xfs_map_blocks_found: dev 253:16 ino 0x21c098 size 0x200000 new_size 0x0 offset 0x88b000 count 1024 type  startoff 0x0 startblock 870448 blockcount 0x2800
.....

Ok, a bunch of kswapd writeback, then:

           <...>-4070  [000] 699227.987373: xfs_writepage:        dev 253:16 ino 0x21c098 pgoff 0x800000 size 0xa00000 offset 0 delalloc 1 unwritten 0
           <...>-4070  [000] 699227.987376: xfs_map_blocks_found: dev 253:16 ino 0x21c098 size 0x8ab000 new_size 0x0 offset 0x800000 count 1024 type  startoff 0x0 startblock 870448 blockcount 0x2800
           <...>-4070  [000] 699227.987377: xfs_writepage:        dev 253:16 ino 0x21c098 pgoff 0x801000 size 0xa00000 offset 0 delalloc 1 unwritten 0
.....
           <...>-4070  [000] 699227.987706: xfs_writepage:        dev 253:16 ino 0x21c098 pgoff 0x9fe000 size 0xa00000 offset 0 delalloc 1 unwritten 0
           <...>-4070  [000] 699227.987707: xfs_writepage:        dev 253:16 ino 0x21c098 pgoff 0x9ff000 size 0xa00000 offset 0 delalloc 1 unwritten 0
           <...>-393   [000] 699228.154118: xfs_setfilesize:      dev 253:16 ino 0x21c098 isize 0xa00000 disize 0x8ab000 new_size 0x0 offset 0x800000 count 1961984
 
Normal writeback. Ok, writeback there spanned a range of 0x200000
(2^21 bytes or 2MiB) pages, but we get an ioend count of on 1961984
bytes, which is 136KiB short. Ok, looking back at the kswapd
writeback, it fell right in the middle of this range, and what we
see is this during the scanning:

           <...>-4070  [000] 699227.987474: xfs_writepage:        dev 253:16 ino 0x21c098 pgoff 0x888000 size 0xa00000 offset 0 delalloc 1 unwritten 0
           <...>-4070  [000] 699227.987475: xfs_writepage:        dev 253:16 ino 0x21c098 pgoff 0x889000 size 0xa00000 offset 0 delalloc 1 unwritten 0
           <...>-4070  [000] 699227.987476: xfs_writepage:        dev 253:16 ino 0x21c098 pgoff 0x8ab000 size 0xa00000 offset 0 delalloc 1 unwritten 0
           <...>-4070  [000] 699227.987477: xfs_writepage:        dev 253:16 ino 0x21c098 pgoff 0x8ac000 size 0xa00000 offset 0 delalloc 1 unwritten 0

A non contiguous page range. That's 132KiB long, so matches the
incorrect ioned value pretty closely. There's probably another
single page hole in the scan somewhere.

What this means is that the ioend is aggregating a non-contiguous
range of pages, which is being submitted as multiple IO so the data
is being written to the correct place. The problem is that the ioend
size doesn't include the holes, so doesn't reflect the range of IO
correctly and so if not setting the file size correctly.

The old code used to terminate an ioend when a discontiguity in the
mapping was discovered by the clustering page cache lookup. The
callback we have now doesn't do this discontiguity discovery, so is
simply placing discontiguous pages in the same ioend. We need to
start a new ioend when we get a discontiguity.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: writepage context needs to handle discontiguous page ranges

From: Dave Chinner <dchinner@redhat.com>

If the pages sent down by write_cache_pages to the writepage
callback are discontiguous, we need to detect this and put each
discontiguous page range into individual ioends. This is needed to
ensure that the ioend accurately represents the range of the file
that it covers so that file size updates during IO completion set
the size correctly. Failure to take into account the discontiguous
ranges results in files being too small when writeback patterns are
non-sequential.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_aops.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_aops.c b/fs/xfs/linux-2.6/xfs_aops.c
index 9f3f387..eadff82 100644
--- a/fs/xfs/linux-2.6/xfs_aops.c
+++ b/fs/xfs/linux-2.6/xfs_aops.c
@@ -44,6 +44,7 @@ struct xfs_writeback_ctx {
 	struct xfs_bmbt_irec	imap;
 	struct xfs_ioend	*iohead;
 	struct xfs_ioend	*ioend;
+	sector_t		last_block;
 };
 
 /*
@@ -575,7 +576,10 @@ xfs_add_to_ioend(
 	unsigned int		type,
 	int			need_ioend)
 {
-	if (!ctx->ioend || need_ioend || type != ctx->ioend->io_type) {
+	if (!ctx->ioend ||
+	     need_ioend ||
+	     type != ctx->ioend->io_type ||
+	     bh->b_blocknr != ctx->last_block + 1) {
 		struct xfs_ioend	*new;
 
 		new = xfs_alloc_ioend(inode, type);
@@ -595,6 +599,7 @@ xfs_add_to_ioend(
 
 	bh->b_private = NULL;
 	ctx->ioend->io_size += bh->b_size;
+	ctx->last_block = bh->b_blocknr;
 }
 
 STATIC void

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
