Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:44836 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726439AbfGAV4U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Jul 2019 17:56:20 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 12/15] gfs2: use iomap_bmap instead of generic_block_bmap
Date: Mon,  1 Jul 2019 23:54:36 +0200
Message-Id: <20190701215439.19162-13-hch@lst.de>
In-Reply-To: <20190701215439.19162-1-hch@lst.de>
References: <20190701215439.19162-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com

No need to indirect through get_blocks and buffer_heads when we can
just use the iomap version.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/gfs2/aops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index 030210f1430b..15a234fb8f88 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -697,7 +697,7 @@ static sector_t gfs2_bmap(struct address_space *mapping, sector_t lblock)
 		return 0;
 
 	if (!gfs2_is_stuffed(ip))
-		dblock = generic_block_bmap(mapping, lblock, gfs2_block_map);
+		dblock = iomap_bmap(mapping, lblock, &gfs2_iomap_ops);
 
 	gfs2_glock_dq_uninit(&i_gh);
 
-- 
2.20.1
