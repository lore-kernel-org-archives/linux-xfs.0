Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:43060 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753853AbdJSOVm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2017 10:21:42 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 05/18] xfs: report zeroed or not correctly in xfs_zero_range()
Date: Thu, 19 Oct 2017 16:21:10 +0200
Message-Id: <20171019142123.18109-6-hch@lst.de>
In-Reply-To: <20171019142123.18109-1-hch@lst.de>
References: <20171019142123.18109-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Eryu Guan <eguan@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>

From: Eryu Guan <eguan@redhat.com>

commit d20a5e3851969fa685f118a80e4df670255a4e8d upstream.

The 'did_zero' param of xfs_zero_range() was not passed to
iomap_zero_range() correctly. This was introduced by commit
7bb41db3ea16 ("xfs: handle 64-bit length in xfs_iozero"), and found
by code inspection.

Signed-off-by: Eryu Guan <eguan@redhat.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index c4893e226fd8..812cd17b331f 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -58,7 +58,7 @@ xfs_zero_range(
 	xfs_off_t		count,
 	bool			*did_zero)
 {
-	return iomap_zero_range(VFS_I(ip), pos, count, NULL, &xfs_iomap_ops);
+	return iomap_zero_range(VFS_I(ip), pos, count, did_zero, &xfs_iomap_ops);
 }
 
 int
-- 
2.14.2

