Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A70ED7CA7
	for <xfs@oss.sgi.com>; Sat, 13 Aug 2016 18:43:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 29AD2AC004
	for <xfs@oss.sgi.com>; Sat, 13 Aug 2016 16:43:11 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id pOepNsX2nuujrCmA (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 13 Aug 2016 16:43:09 -0700 (PDT)
Received: from [107.17.164.165] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
	id 1bYia4-0006LX-M8
	for xfs@oss.sgi.com; Sat, 13 Aug 2016 23:43:08 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6/7] xfs: simplify xfs_file_iomap_begin
Date: Sat, 13 Aug 2016 16:43:00 -0700
Message-Id: <1471131781-14107-7-git-send-email-hch@lst.de>
In-Reply-To: <1471131781-14107-1-git-send-email-hch@lst.de>
References: <1471131781-14107-1-git-send-email-hch@lst.de>
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
To: xfs@oss.sgi.com

We'll never get nimap == 0 for a successful return from xfs_bmapi_read,
so don't try to handle it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_iomap.c | 14 ++++----------
 fs/xfs/xfs_trace.h |  1 -
 2 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 2114d53..1cce760 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1037,20 +1037,14 @@ xfs_file_iomap_begin(
 			return error;
 
 		trace_xfs_iomap_alloc(ip, offset, length, 0, &imap);
-		xfs_bmbt_to_iomap(ip, iomap, &imap);
-	} else if (nimaps) {
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
-		trace_xfs_iomap_found(ip, offset, length, 0, &imap);
-		xfs_bmbt_to_iomap(ip, iomap, &imap);
 	} else {
+		ASSERT(nimaps);
+
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
-		trace_xfs_iomap_not_found(ip, offset, length, 0, &imap);
-		iomap->blkno = IOMAP_NULL_BLOCK;
-		iomap->type = IOMAP_HOLE;
-		iomap->offset = offset;
-		iomap->length = length;
+		trace_xfs_iomap_found(ip, offset, length, 0, &imap);
 	}
 
+	xfs_bmbt_to_iomap(ip, iomap, &imap);
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 551b7e2..7e88bec 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1298,7 +1298,6 @@ DEFINE_IOMAP_EVENT(xfs_get_blocks_alloc);
 DEFINE_IOMAP_EVENT(xfs_get_blocks_map_direct);
 DEFINE_IOMAP_EVENT(xfs_iomap_alloc);
 DEFINE_IOMAP_EVENT(xfs_iomap_found);
-DEFINE_IOMAP_EVENT(xfs_iomap_not_found);
 
 DECLARE_EVENT_CLASS(xfs_simple_io_class,
 	TP_PROTO(struct xfs_inode *ip, xfs_off_t offset, ssize_t count),
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
