Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 974DE7F47
	for <xfs@oss.sgi.com>; Sun,  3 Jan 2016 06:09:50 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 86FBE8F8037
	for <xfs@oss.sgi.com>; Sun,  3 Jan 2016 04:09:50 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id uHuhLrmfm9B97UfG (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 03 Jan 2016 04:09:44 -0800 (PST)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/3] xfs: cancel COW in xfs_cancel_ioend
Date: Sun,  3 Jan 2016 13:07:53 +0100
Message-Id: <1451822873-12969-4-git-send-email-hch@lst.de>
In-Reply-To: <1451822873-12969-1-git-send-email-hch@lst.de>
References: <1451822873-12969-1-git-send-email-hch@lst.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

Otherwise we leak COW allocations done earlier in writepage.  This
can be reproduced fairly easily when we hit the non-blocking writeback
EAGAIN case.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_aops.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 185415a..9c69dc3 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -588,6 +588,7 @@ xfs_cancel_ioend(
 {
 	xfs_ioend_t		*next;
 	struct buffer_head	*bh, *next_bh;
+	int			error;
 
 	do {
 		next = ioend->io_list;
@@ -605,6 +606,12 @@ xfs_cancel_ioend(
 			unlock_buffer(bh);
 		} while ((bh = next_bh) != NULL);
 
+		if (ioend->io_flags & XFS_IOEND_COW) {
+			error = xfs_reflink_end_cow_failed(
+					XFS_I(ioend->io_inode),
+					ioend->io_offset, ioend->io_size);
+			WARN_ON_ONCE(error);
+		}
 		mempool_free(ioend, xfs_ioend_pool);
 	} while ((ioend = next) != NULL);
 }
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
