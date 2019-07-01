Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:44720 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726439AbfGAVzm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Jul 2019 17:55:42 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 06/15] HACK: disable lockdep annotation in iomap_dio_rw
Date: Mon,  1 Jul 2019 23:54:30 +0200
Message-Id: <20190701215439.19162-7-hch@lst.de>
In-Reply-To: <20190701215439.19162-1-hch@lst.de>
References: <20190701215439.19162-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com

gfs2 seems to never calls this with i_rwsem held, disable for testing.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/iomap.c b/fs/iomap.c
index 63952a7b1c05..264cfb2e796f 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -1885,7 +1885,7 @@ iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 	struct blk_plug plug;
 	struct iomap_dio *dio;
 
-	lockdep_assert_held(&inode->i_rwsem);
+//	lockdep_assert_held(&inode->i_rwsem);
 
 	if (!count)
 		return 0;
-- 
2.20.1
