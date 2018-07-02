Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:38412 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751493AbeGBMuG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 2 Jul 2018 08:50:06 -0400
Date: Mon, 2 Jul 2018 14:50:36 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 23/24] iomap: add support for sub-pagesize buffered I/O
        without buffer heads
Message-ID: <20180702125036.GA3366@lst.de>
References: <20180615130209.1970-1-hch@lst.de> <20180615130209.1970-24-hch@lst.de> <20180619165211.GD2806@bfoster> <20180620075655.GA2668@lst.de> <20180620143252.GE3241@bfoster> <20180620160803.GA4838@magnolia> <20180620181259.GD4493@bfoster> <20180620190230.GB4838@magnolia> <20180621084646.GA5764@lst.de> <20180623130624.GA16691@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180623130624.GA16691@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

The problem is that we need to split extents at the eof block
so that the existing zeroing actually takes effect.  The patch below
fixes the test case for me:

diff --git a/fs/iomap.c b/fs/iomap.c
index e8f1bcdc95cf..9c88b8736de0 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -143,13 +143,20 @@ static void
 iomap_adjust_read_range(struct inode *inode, struct iomap_page *iop,
 		loff_t *pos, loff_t length, unsigned *offp, unsigned *lenp)
 {
+	unsigned block_bits = inode->i_blkbits;
+	unsigned block_size = (1 << block_bits);
 	unsigned poff = *pos & (PAGE_SIZE - 1);
 	unsigned plen = min_t(loff_t, PAGE_SIZE - poff, length);
+	unsigned first = poff >> block_bits;
+	unsigned last = (poff + plen - 1) >> block_bits;
+	unsigned end = (i_size_read(inode) & (PAGE_SIZE - 1)) >> block_bits;
 
+	/*
+	 * If the block size is smaller than the page size we need to check the
+	 * per-block uptodate status and adjust the offset and length if needed
+	 * to avoid reading in already uptodate ranges.
+	 */
 	if (iop) {
-		unsigned block_size = i_blocksize(inode);
-		unsigned first = poff >> inode->i_blkbits;
-		unsigned last = (poff + plen - 1) >> inode->i_blkbits;
 		unsigned int i;
 
 		/* move forward for each leading block marked uptodate */
@@ -159,17 +166,27 @@ iomap_adjust_read_range(struct inode *inode, struct iomap_page *iop,
 			*pos += block_size;
 			poff += block_size;
 			plen -= block_size;
+			first++;
 		}
 
 		/* truncate len if we find any trailing uptodate block(s) */
 		for ( ; i <= last; i++) {
 			if (test_bit(i, iop->uptodate)) {
 				plen -= (last - i + 1) * block_size;
+				last = i - 1;
 				break;
 			}
 		}
 	}
 
+	/*
+	 * If the extent spans the block that contains the i_size we need to
+	 * handle both halves separately so that we properly zero data in the
+	 * page cache for blocks that are entirely outside of i_size.
+	 */
+	if (first <= end && last > end)
+		plen -= (last - end) * block_size;
+
 	*offp = poff;
 	*lenp = plen;
 }
