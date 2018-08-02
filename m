Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47662 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726984AbeHBV4b (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 2 Aug 2018 17:56:31 -0400
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] fs: fix iomap_bmap position calculation
Message-ID: <78937e83-5665-11bf-14a6-7815221bf4d8@redhat.com>
Date: Thu, 2 Aug 2018 15:03:51 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>, fsdevel <linux-fsdevel@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>

The position calculation in iomap_bmap() shifts bno the wrong way,
so we don't progress properly and end up re-mapping block zero
over and over, yielding an unchanging physical block range as the
logical block advances:

# filefrag -Be file
 ext:   logical_offset:     physical_offset: length:   expected: flags:
   0:      0..       0:      21..        21:      1:             merged
   1:      1..       1:      21..        21:      1:         22: merged
Discontinuity: Block 1 is at 21 (was 22)
   2:      2..       2:      21..        21:      1:         22: merged
Discontinuity: Block 2 is at 21 (was 22)
   3:      3..       3:      21..        21:      1:         22: merged

This breaks the FIBMAP interface for anyone using it (XFS), which
in turn breaks LILO, zipl, etc.

Bug-actually-spotted-by: Darrick J. Wong <darrick.wong@oracle.com> 
Fixes: 89eb1906a953 ("iomap: add an iomap-based bmap implementation")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/iomap.c b/fs/iomap.c
index 77397b5a96ef..0d0bd8845586 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -1443,7 +1443,7 @@ iomap_bmap(struct address_space *mapping, sector_t bno,
 		const struct iomap_ops *ops)
 {
 	struct inode *inode = mapping->host;
-	loff_t pos = bno >> inode->i_blkbits;
+	loff_t pos = bno << inode->i_blkbits;
 	unsigned blocksize = i_blocksize(inode);
 
 	if (filemap_write_and_wait(mapping))

