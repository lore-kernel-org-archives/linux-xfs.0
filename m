Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:40388 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729392AbfGVJuy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Jul 2019 05:50:54 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 10/12] iomap: warn on inline maps in iomap_writepage_map
Date: Mon, 22 Jul 2019 11:50:22 +0200
Message-Id: <20190722095024.19075-11-hch@lst.de>
In-Reply-To: <20190722095024.19075-1-hch@lst.de>
References: <20190722095024.19075-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J . Wong" <darrick.wong@oracle.com>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Andreas Gruenbacher <agruenba@redhat.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

And inline mapping should never mark the page dirty and thus never end up
in writepages.  Add a check for that condition and warn if it happens.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap/buffered-io.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 16f2ea46a238..91a9796f8a7c 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1422,6 +1422,8 @@ iomap_writepage_map(struct iomap_writepage_ctx *wpc,
 		error = wpc->ops->map_blocks(wpc, inode, file_offset);
 		if (error)
 			break;
+		if (WARN_ON_ONCE(wpc->iomap.type == IOMAP_INLINE))
+			continue;
 		if (wpc->iomap.type == IOMAP_HOLE)
 			continue;
 		iomap_add_to_ioend(inode, file_offset, page, iop, wpc, wbc,
-- 
2.20.1
