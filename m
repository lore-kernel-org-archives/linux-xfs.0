Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47986 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750860AbdEUH7l (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 21 May 2017 03:59:41 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9D7A65AFC6
        for <linux-xfs@vger.kernel.org>; Sun, 21 May 2017 07:59:40 +0000 (UTC)
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH] xfs: fix off-by-one on max nr_pages in xfs_find_get_desired_pgoff()
Date: Sun, 21 May 2017 15:59:39 +0800
Message-Id: <20170521075939.18071-1-eguan@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Eryu Guan <eguan@redhat.com>

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

This is unconvered by generic/285 subtest 07 and 08 on ppc64 host,
where pagesize is 64k. Because a recent change to generic/285
reduced the preallocated file size to smaller than 64k.

Cc: stable@vger.kernel.org # v3.7+
Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 fs/xfs/xfs_file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 35703a8..aefa213 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1049,7 +1049,7 @@ xfs_find_get_desired_pgoff(
 		unsigned	nr_pages;
 		unsigned int	i;
 
-		want = min_t(pgoff_t, end - index, PAGEVEC_SIZE);
+		want = min_t(pgoff_t, end - index, PAGEVEC_SIZE - 1) + 1;
 		nr_pages = pagevec_lookup(&pvec, inode->i_mapping, index,
 					  want);
 		/*
-- 
2.9.4

