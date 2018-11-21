Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl2.internode.on.net ([150.101.137.133]:59616 "EHLO
        ipmail01.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725939AbeKURXf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Nov 2018 12:23:35 -0500
Date: Wed, 21 Nov 2018 17:50:18 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 6/5] iomap: readpages doesn't zero page tail beyond EOF
 properly
Message-ID: <20181121065018.GS19305@dastard>
References: <20181119211742.8824-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181119211742.8824-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org


From: Dave Chinner <dchinner@redhat.com>

When we read the EOF page of the file via readpages, we need
to zero the region beyond EOF that we either do not read or
should not contain data so that mmap does not expose stale data to
user applications.

However, iomap_adjust_read_range() fails to detect EOF correctly,
and so fsx on 1k block size filesystems fails very quickly with
mapreads exposing data beyond EOF. There are two problems here.

Firstly, when calculating the end block of the EOF byte, we have
to round the size by one to avoid a block aligned EOF from reporting
a block too large. i.e. a size of 1024 bytes is 1 block, which in
index terms is block 0. Therefore we have to calculate the end block
from (isize - 1), not isize.

The second bug is determining if the current page spans EOF, and so
whether we need split it into two half, one for the IO, and the
other for zeroing. Unfortunately, the code that checks whether
we should split the block doesn't actually check if we span EOF, it
just checks if the read spans the /offset in the page/ that EOF
sits on. So it splits every read into two if EOF is not page
aligned, regardless of whether we are reading the EOF block or not.

Hence we need to restrict the "does the read span EOF" check to
just the page that spans EOF, not every page we read.

This patch results in correct EOF detection through readpages:

xfs_vm_readpages:     dev 259:0 ino 0x43 nr_pages 24
xfs_iomap_found:      dev 259:0 ino 0x43 size 0x66c00 offset 0x4f000 count 98304 type hole startoff 0x13c startblock 1368 blockcount 0x4
bprint:               iomap_readpage_actor: orig pos 323584 pos 323584, length 4096, poff 0 plen 4096, isize 420864
xfs_iomap_found:      dev 259:0 ino 0x43 size 0x66c00 offset 0x50000 count 94208 type hole startoff 0x140 startblock 1497 blockcount 0x5c
iomap_readpage_actor: orig pos 327680 pos 327680, length 94208, poff 0 plen 4096, isize 420864
iomap_readpage_actor: orig pos 331776 pos 331776, length 90112, poff 0 plen 4096, isize 420864
iomap_readpage_actor: orig pos 335872 pos 335872, length 86016, poff 0 plen 4096, isize 420864
iomap_readpage_actor: orig pos 339968 pos 339968, length 81920, poff 0 plen 4096, isize 420864
iomap_readpage_actor: orig pos 344064 pos 344064, length 77824, poff 0 plen 4096, isize 420864
iomap_readpage_actor: orig pos 348160 pos 348160, length 73728, poff 0 plen 4096, isize 420864
iomap_readpage_actor: orig pos 352256 pos 352256, length 69632, poff 0 plen 4096, isize 420864
iomap_readpage_actor: orig pos 356352 pos 356352, length 65536, poff 0 plen 4096, isize 420864
iomap_readpage_actor: orig pos 360448 pos 360448, length 61440, poff 0 plen 4096, isize 420864
iomap_readpage_actor: orig pos 364544 pos 364544, length 57344, poff 0 plen 4096, isize 420864
iomap_readpage_actor: orig pos 368640 pos 368640, length 53248, poff 0 plen 4096, isize 420864
iomap_readpage_actor: orig pos 372736 pos 372736, length 49152, poff 0 plen 4096, isize 420864
iomap_readpage_actor: orig pos 376832 pos 376832, length 45056, poff 0 plen 4096, isize 420864
iomap_readpage_actor: orig pos 380928 pos 380928, length 40960, poff 0 plen 4096, isize 420864
iomap_readpage_actor: orig pos 385024 pos 385024, length 36864, poff 0 plen 4096, isize 420864
iomap_readpage_actor: orig pos 389120 pos 389120, length 32768, poff 0 plen 4096, isize 420864
iomap_readpage_actor: orig pos 393216 pos 393216, length 28672, poff 0 plen 4096, isize 420864
iomap_readpage_actor: orig pos 397312 pos 397312, length 24576, poff 0 plen 4096, isize 420864
iomap_readpage_actor: orig pos 401408 pos 401408, length 20480, poff 0 plen 4096, isize 420864
iomap_readpage_actor: orig pos 405504 pos 405504, length 16384, poff 0 plen 4096, isize 420864
iomap_readpage_actor: orig pos 409600 pos 409600, length 12288, poff 0 plen 4096, isize 420864
iomap_readpage_actor: orig pos 413696 pos 413696, length 8192, poff 0 plen 4096, isize 420864
iomap_readpage_actor: orig pos 417792 pos 417792, length 4096, poff 0 plen 3072, isize 420864
iomap_readpage_actor: orig pos 420864 pos 420864, length 1024, poff 3072 plen 1024, isize 420864

As you can see, it now does full page reads until the last one which
is split correctly at the block aligned EOF, reading 3072 bytes and
zeroing the last 1024 bytes.

This fixes the stale data beyond EOF problem that fsx quickly
uncovers on 1k block size filesystems.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/iomap.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/iomap.c b/fs/iomap.c
index d51e7a2ae641..17f71a7ae8be 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -142,13 +142,14 @@ static void
 iomap_adjust_read_range(struct inode *inode, struct iomap_page *iop,
 		loff_t *pos, loff_t length, unsigned *offp, unsigned *lenp)
 {
+	loff_t orig_pos = *pos;
+	loff_t isize = i_size_read(inode);
 	unsigned block_bits = inode->i_blkbits;
 	unsigned block_size = (1 << block_bits);
 	unsigned poff = offset_in_page(*pos);
 	unsigned plen = min_t(loff_t, PAGE_SIZE - poff, length);
 	unsigned first = poff >> block_bits;
 	unsigned last = (poff + plen - 1) >> block_bits;
-	unsigned end = offset_in_page(i_size_read(inode)) >> block_bits;
 
 	/*
 	 * If the block size is smaller than the page size we need to check the
@@ -183,8 +184,11 @@ iomap_adjust_read_range(struct inode *inode, struct iomap_page *iop,
 	 * handle both halves separately so that we properly zero data in the
 	 * page cache for blocks that are entirely outside of i_size.
 	 */
-	if (first <= end && last > end)
-		plen -= (last - end) * block_size;
+	if (orig_pos <= isize && orig_pos + plen > isize) {
+		unsigned end = offset_in_page(isize - 1) >> block_bits;
+		if (first <= end && last > end)
+			plen -= (last - end) * block_size;
+	}
 
 	*offp = poff;
 	*lenp = plen;
