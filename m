Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:52038 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726603AbfF0Ksv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jun 2019 06:48:51 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 03/13] xfs: fix a comment typo in xfs_submit_ioend
Date: Thu, 27 Jun 2019 12:48:26 +0200
Message-Id: <20190627104836.25446-4-hch@lst.de>
In-Reply-To: <20190627104836.25446-1-hch@lst.de>
References: <20190627104836.25446-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J . Wong" <darrick.wong@oracle.com>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Andreas Gruenbacher <agruenba@redhat.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

The fail argument is long gone, update the comment.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_aops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 73c291aeae17..8f7b2d91d9a4 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -626,7 +626,7 @@ xfs_map_blocks(
  * reference to the ioend to ensure that the ioend completion is only done once
  * all bios have been submitted and the ioend is really done.
  *
- * If @fail is non-zero, it means that we have a situation where some part of
+ * If @status is non-zero, it means that we have a situation where some part of
  * the submission process has failed after we have marked paged for writeback
  * and unlocked them. In this situation, we need to fail the bio and ioend
  * rather than submit it to IO. This typically only happens on a filesystem
-- 
2.20.1
