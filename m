Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:38100 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725878AbfG3BSY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Jul 2019 21:18:24 -0400
Subject: [PATCH 4/6] iomap: warn on inline maps in iomap_writepage_map
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 29 Jul 2019 18:18:05 -0700
Message-ID: <156444948583.2682261.16607334257055353357.stgit@magnolia>
In-Reply-To: <156444945993.2682261.3926017251626679029.stgit@magnolia>
References: <156444945993.2682261.3926017251626679029.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: hch@infradead.org, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Damien.LeMoal@wdc.com, Christoph Hellwig <hch@lst.de>, agruenba@redhat.com

From: Christoph Hellwig <hch@lst.de>

And inline mapping should never mark the page dirty and thus never end up
in writepages.  Add a check for that condition and warn if it happens.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/iomap/buffered-io.c |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 21b50e8cb9f2..ed694a59c527 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1405,6 +1405,8 @@ iomap_writepage_map(struct iomap_writepage_ctx *wpc,
 		error = wpc->ops->map_blocks(wpc, inode, file_offset);
 		if (error)
 			break;
+		if (WARN_ON_ONCE(wpc->iomap.type == IOMAP_INLINE))
+			continue;
 		if (wpc->iomap.type == IOMAP_HOLE)
 			continue;
 		iomap_add_to_ioend(inode, file_offset, page, iop, wpc, wbc,
