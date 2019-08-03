Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37058 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726170AbfHCNzH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 3 Aug 2019 09:55:07 -0400
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH] iomap: Fix trivial typo
Date: Sat,  3 Aug 2019 15:55:02 +0200
Message-Id: <20190803135502.19572-1-agruenba@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J . Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/iomap/buffered-io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index ba0511131868..4ab1ec0a282f 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1258,7 +1258,7 @@ static void iomap_writepage_end_bio(struct bio *bio)
  * all bios have been submitted and the ioend is really done.
  *
  * If @error is non-zero, it means that we have a situation where some part of
- * the submission process has failed after we have marked paged for writeback
+ * the submission process has failed after we have marked pages for writeback
  * and unlocked them. In this situation, we need to fail the bio and ioend
  * rather than submit it to IO. This typically only happens on a filesystem
  * shutdown.
-- 
2.20.1
