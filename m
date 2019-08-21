Return-Path: <SRS0=IGv+=WR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 664BBC3A59E
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Aug 2019 06:16:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 336DB216F4
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Aug 2019 06:16:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727818AbfHUGQR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Aug 2019 02:16:17 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:41189 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726193AbfHUGQR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Aug 2019 02:16:17 -0400
Received: from dread.disaster.area (pa49-195-190-67.pa.nsw.optusnet.com.au [49.195.190.67])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 5EDEC43DEEB;
        Wed, 21 Aug 2019 16:16:13 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i0Jth-00040t-5q; Wed, 21 Aug 2019 16:15:05 +1000
Date:   Wed, 21 Aug 2019 16:15:05 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc:     "hch@lst.de" <hch@lst.de>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "darrick.wong@oracle.com" <darrick.wong@oracle.com>
Subject: Re: 5.3-rc1 regression with XFS log recovery
Message-ID: <20190821061505.GM1119@dread.disaster.area>
References: <e49a6a3a244db055995769eb844c281f93e50ab9.camel@intel.com>
 <20190818071128.GA17286@lst.de>
 <20190818074140.GA18648@lst.de>
 <20190818173426.GA32311@lst.de>
 <20190821002643.GK1119@dread.disaster.area>
 <20190821004413.GB20250@lst.de>
 <20190821010813.GL1119@dread.disaster.area>
 <92a9a35a96235fba6537cfdc89cc42603db50fb9.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <92a9a35a96235fba6537cfdc89cc42603db50fb9.camel@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=TR82T6zjGmBjdfWdGgpkDw==:117 a=TR82T6zjGmBjdfWdGgpkDw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=IkcTkHD0fZMA:10 a=FmdZ9Uzk2mMA:10
        a=7-415B0cAAAA:8 a=20KFwNOVAAAA:8 a=viWo9_wYBWZxYAac8tEA:9
        a=QEXdDO2ut3YA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 21, 2019 at 01:56:33AM +0000, Verma, Vishal L wrote:
> On Wed, 2019-08-21 at 11:08 +1000, Dave Chinner wrote:
> > On Wed, Aug 21, 2019 at 02:44:13AM +0200, hch@lst.de wrote:
> > > On Wed, Aug 21, 2019 at 10:26:43AM +1000, Dave Chinner wrote:
> > > > After thinking on this for a bit, I suspect the better thing to do
> > > > here is add a KM_ALIGNED flag to the allocation, so if the
> > > > internal
> > > > kmem_alloc() returns an unaligned pointer we free it and fall
> > > > through to vmalloc() to get a properly aligned pointer....
> > > > 
> > > > That way none of the other interfaces have to change, and we can
> > > > then use kmem_alloc_large() everywhere we allocate buffers for IO.
> > > > And we don't need new infrastructure just to support these debug
> > > > configurations, either.
> > > > 
> > > > Actually, kmem_alloc_io() might be a better idea - keep the
> > > > aligned
> > > > flag internal to the kmem code. Seems like a pretty simple
> > > > solution
> > > > to the entire problem we have here...
> > > 
> > > The interface sounds ok.  The simple try and fallback implementation
> > > OTOH means we always do two allocations іf slub debugging is
> > > enabled,
> > > which is a little lasty.
> > 
> > Some creative ifdefery could avoid that, but quite frankly it's only
> > necessary for limited allocation contexts and so the
> > overhead/interactions would largely be unnoticable compared to the
> > wider impact of memory debugging...
> > 
> > > I guess the best we can do for 5.3 and
> > > then figure out a way to avoid for later.
> > 
> > Yeah, it also has the advantage of documenting all the places we
> > need to be careful of allocation alignment, and it would allow us to
> > simply plug in whatever future infrastructure comes along that
> > guarantees allocation alignment without changing any other XFS
> > code...
> 
> Just to clarify, this precludes the changes to bio_add_page() you
> suggested earlier, right?

Nope, I most certainly want the block layer to catch this, but
given the total lack of understanding from Ming, I've given up
on trying to convince them that validation is both possible and
necessarily.

The patch below basically copies bio_add_page() into xfs as
xfs_bio_add_page() and uses block layer helpers to check alignment.
It's the same helper blk_rq_map_kern() uses to detect and bounce
unaligned user buffers...

WIth that, the simple KASAN enabled reproducer:

# mkfs.xfs /dev/ram0; mount /dev/ram0 /mnt/test
[   88.260091] XFS (ram0): Mounting V5 Filesystem
[   88.314453] WARNING: CPU: 0 PID: 4681 at fs/xfs/xfs_bio_io.c:24 xfs_bio_add_page+0x134/0x1d3
[   88.316484] CPU: 0 PID: 4681 Comm: mount Not tainted 5.3.0-rc5-dgc+ #1516
[   88.318115] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
[   88.320110] RIP: 0010:xfs_bio_add_page+0x134/0x1d3
....
[   88.340471] Call Trace:
[   88.343011]  xfs_rw_bdev.cold.5+0xf4/0x193
[   88.345224]  xlog_do_io+0xd1/0x1c0
[   88.346050]  xlog_bread+0x23/0x70
[   88.346857]  xlog_find_verify_log_record+0xc8/0x330
[   88.349171]  xlog_find_zeroed+0x224/0x330
[   88.356712]  xlog_find_head+0xbe/0x640
[   88.375967]  xlog_find_tail+0xc6/0x500
[   88.388098]  xlog_recover+0x80/0x2a0
[   88.392020]  xfs_log_mount+0x3a5/0x3d0
[   88.392931]  xfs_mountfs+0x753/0xe40
[   88.403201]  xfs_fs_fill_super+0x5c1/0x9d0
[   88.405320]  mount_bdev+0x1be/0x200
[   88.407178]  legacy_get_tree+0x6e/0xb0
[   88.408089]  vfs_get_tree+0x41/0x160
[   88.408955]  do_mount+0xa48/0xcf0
[   88.416384]  ksys_mount+0xb6/0xd0
[   88.417191]  __x64_sys_mount+0x62/0x70
[   88.418101]  do_syscall_64+0x70/0x230
[   88.418991]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[   88.420208] RIP: 0033:0x7f1817194fea
......
[   88.436923] XFS (ram0): log recovery read I/O error at daddr 0x0 len 8 error -5
[   88.438707] XFS (ram0): empty log check failed
[   88.439794] XFS (ram0): log mount/recovery failed: error -5
[   88.441435] XFS (ram0): log mount failed
mount: /mnt/test: can't read superblock on /dev/ram0.
umount: /mnt/test: not mounted.
#

throws a warning and an IO error. No data corruption, no weird
log recovery failures, etc. This is easy to detect, and so easy to
debug now. Shame we can't do this in the block layer code.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: alignment check bio buffers

From: Dave Chinner <dchinner@redhat.com>

Because apparently this is impossible to do in the block layer.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_bio_io.c | 32 +++++++++++++++++++++++++++++---
 fs/xfs/xfs_buf.c    |  7 ++++---
 fs/xfs/xfs_linux.h  |  3 +++
 fs/xfs/xfs_log.c    |  6 +++++-
 4 files changed, 41 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_bio_io.c b/fs/xfs/xfs_bio_io.c
index e2148f2d5d6b..fbaea643c000 100644
--- a/fs/xfs/xfs_bio_io.c
+++ b/fs/xfs/xfs_bio_io.c
@@ -9,6 +9,27 @@ static inline unsigned int bio_max_vecs(unsigned int count)
 	return min_t(unsigned, howmany(count, PAGE_SIZE), BIO_MAX_PAGES);
 }
 
+int
+xfs_bio_add_page(
+	struct bio	*bio,
+	struct page	*page,
+	unsigned int	len,
+	unsigned int	offset)
+{
+	struct request_queue	*q = bio->bi_disk->queue;
+	bool		same_page = false;
+
+	if (WARN_ON_ONCE(!blk_rq_aligned(q, len, offset)))
+		return -EIO;
+
+	if (!__bio_try_merge_page(bio, page, len, offset, &same_page)) {
+		if (bio_full(bio, len))
+			return 0;
+		__bio_add_page(bio, page, len, offset);
+	}
+	return len;
+}
+
 int
 xfs_rw_bdev(
 	struct block_device	*bdev,
@@ -20,7 +41,7 @@ xfs_rw_bdev(
 {
 	unsigned int		is_vmalloc = is_vmalloc_addr(data);
 	unsigned int		left = count;
-	int			error;
+	int			error, ret = 0;
 	struct bio		*bio;
 
 	if (is_vmalloc && op == REQ_OP_WRITE)
@@ -36,9 +57,12 @@ xfs_rw_bdev(
 		unsigned int	off = offset_in_page(data);
 		unsigned int	len = min_t(unsigned, left, PAGE_SIZE - off);
 
-		while (bio_add_page(bio, page, len, off) != len) {
+		while ((ret = xfs_bio_add_page(bio, page, len, off)) != len) {
 			struct bio	*prev = bio;
 
+			if (ret < 0)
+				goto submit;
+
 			bio = bio_alloc(GFP_KERNEL, bio_max_vecs(left));
 			bio_copy_dev(bio, prev);
 			bio->bi_iter.bi_sector = bio_end_sector(prev);
@@ -48,14 +72,16 @@ xfs_rw_bdev(
 			submit_bio(prev);
 		}
 
+		ret = 0;
 		data += len;
 		left -= len;
 	} while (left > 0);
 
+submit:
 	error = submit_bio_wait(bio);
 	bio_put(bio);
 
 	if (is_vmalloc && op == REQ_OP_READ)
 		invalidate_kernel_vmap_range(data, count);
-	return error;
+	return ret ? ret : error;
 }
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index dd3aa64098a8..f2e6669f60b0 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1261,6 +1261,7 @@ xfs_buf_ioapply_map(
 	sector_t	sector =  bp->b_maps[map].bm_bn;
 	int		size;
 	int		offset;
+	int		rbytes = 0;
 
 	/* skip the pages in the buffer before the start offset */
 	page_index = 0;
@@ -1290,12 +1291,12 @@ xfs_buf_ioapply_map(
 	bio_set_op_attrs(bio, op, op_flags);
 
 	for (; size && nr_pages; nr_pages--, page_index++) {
-		int	rbytes, nbytes = PAGE_SIZE - offset;
+		int	nbytes = PAGE_SIZE - offset;
 
 		if (nbytes > size)
 			nbytes = size;
 
-		rbytes = bio_add_page(bio, bp->b_pages[page_index], nbytes,
+		rbytes = xfs_bio_add_page(bio, bp->b_pages[page_index], nbytes,
 				      offset);
 		if (rbytes < nbytes)
 			break;
@@ -1306,7 +1307,7 @@ xfs_buf_ioapply_map(
 		total_nr_pages--;
 	}
 
-	if (likely(bio->bi_iter.bi_size)) {
+	if (likely(bio->bi_iter.bi_size && rbytes >= 0)) {
 		if (xfs_buf_is_vmapped(bp)) {
 			flush_kernel_vmap_range(bp->b_addr,
 						xfs_buf_vmap_len(bp));
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index ca15105681ca..e71c7bf3e714 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -145,6 +145,9 @@ static inline void delay(long ticks)
 	schedule_timeout_uninterruptible(ticks);
 }
 
+int xfs_bio_add_page(struct bio *bio, struct page *page, unsigned int len,
+			unsigned int offset);
+
 /*
  * XFS wrapper structure for sysfs support. It depends on external data
  * structures and is embedded in various internal data structures to implement
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index acc5a824bb9e..c2f1ff57fb6d 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1673,8 +1673,12 @@ xlog_map_iclog_data(
 		struct page	*page = kmem_to_page(data);
 		unsigned int	off = offset_in_page(data);
 		size_t		len = min_t(size_t, count, PAGE_SIZE - off);
+		int		ret;
 
-		WARN_ON_ONCE(bio_add_page(bio, page, len, off) != len);
+		ret = xfs_bio_add_page(bio, page, len, off);
+		WARN_ON_ONCE(ret != len);
+		if (ret < 0)
+			break;
 
 		data += len;
 		count -= len;
