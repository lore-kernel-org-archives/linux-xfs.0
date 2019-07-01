Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:44726 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726439AbfGAVzo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Jul 2019 17:55:44 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 07/15] gfs2: use page_offset in gfs2_page_mkwrite
Date: Mon,  1 Jul 2019 23:54:31 +0200
Message-Id: <20190701215439.19162-8-hch@lst.de>
In-Reply-To: <20190701215439.19162-1-hch@lst.de>
References: <20190701215439.19162-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com

Without casting page->index to a guaranteed 64-bit type the value
might be treated as 32-bit on 32-bit platforms and thus get truncated.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/gfs2/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 1cb0c3afd3dc..282a4aaab900 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -424,7 +424,7 @@ static vm_fault_t gfs2_page_mkwrite(struct vm_fault *vmf)
 	struct gfs2_sbd *sdp = GFS2_SB(inode);
 	struct gfs2_alloc_parms ap = { .aflags = 0, };
 	unsigned long last_index;
-	u64 pos = page->index << PAGE_SHIFT;
+	u64 pos = page_offset(page);
 	unsigned int data_blocks, ind_blocks, rblocks;
 	struct gfs2_holder gh;
 	loff_t size;
-- 
2.20.1
