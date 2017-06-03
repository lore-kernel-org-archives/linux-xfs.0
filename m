Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:45408 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751272AbdFCNTs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 3 Jun 2017 09:19:48 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 23/25] xfs: fix off-by-one on max nr_pages in xfs_find_get_desired_pgoff()
Date: Sat,  3 Jun 2017 15:18:34 +0200
Message-Id: <20170603131836.26661-24-hch@lst.de>
In-Reply-To: <20170603131836.26661-1-hch@lst.de>
References: <20170603131836.26661-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Eryu Guan <eguan@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>

From: Eryu Guan <eguan@redhat.com>

commit 8affebe16d79ebefb1d9d6d56a46dc89716f9453 upstream.

xfs_find_get_desired_pgoff() is used to search for offset of hole or
data in page range [index, end] (both inclusive), and the max number
of pages to search should be at least one, if end == index.
Otherwise the only page is missed and no hole or data is found,
which is not correct.

When block size is smaller than page size, this can be demonstrated
by preallocating a file with size smaller than page size and writing
data to the last block. E.g. run this xfs_io command on a 1k block
size XFS on x86_64 host.

  # xfs_io -fc "falloc 0 3k" -c "pwrite 2k 1k" \
  	    -c "seek -d 0" /mnt/xfs/testfile
  wrote 1024/1024 bytes at offset 2048
  1 KiB, 1 ops; 0.0000 sec (33.675 MiB/sec and 34482.7586 ops/sec)
  Whence  Result
  DATA    EOF

Data at offset 2k was missed, and lseek(2) returned ENXIO.

This is uncovered by generic/285 subtest 07 and 08 on ppc64 host,
where pagesize is 64k. Because a recent change to generic/285
reduced the preallocated file size to smaller than 64k.

Signed-off-by: Eryu Guan <eguan@redhat.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 1209ad29e902..a4efc61fa775 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1136,7 +1136,7 @@ xfs_find_get_desired_pgoff(
 		unsigned	nr_pages;
 		unsigned int	i;
 
-		want = min_t(pgoff_t, end - index, PAGEVEC_SIZE);
+		want = min_t(pgoff_t, end - index, PAGEVEC_SIZE - 1) + 1;
 		nr_pages = pagevec_lookup(&pvec, inode->i_mapping, index,
 					  want);
 		/*
-- 
2.11.0

