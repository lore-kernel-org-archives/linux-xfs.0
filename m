Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 90B947F7D
	for <xfs@oss.sgi.com>; Thu, 22 Jan 2015 05:11:28 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1F089AC00D
	for <xfs@oss.sgi.com>; Thu, 22 Jan 2015 03:11:28 -0800 (PST)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id fc451oqkekZqBb3P (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 22 Jan 2015 03:11:26 -0800 (PST)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 16/20] xfs: pass a 64-bit count argument to
	xfs_iomap_write_unwritten
Date: Thu, 22 Jan 2015 12:10:02 +0100
Message-Id: <1421925006-24231-17-git-send-email-hch@lst.de>
In-Reply-To: <1421925006-24231-1-git-send-email-hch@lst.de>
References: <1421925006-24231-1-git-send-email-hch@lst.de>
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
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, Jeff Layton <jlayton@primarydata.com>, xfs@oss.sgi.com

The code is already ready for it, and the pnfs layout commit code expects
to be able to pass a larger than 32-bit argument.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_iomap.c | 2 +-
 fs/xfs/xfs_iomap.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index c980e2a..ccb1dd0 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -802,7 +802,7 @@ int
 xfs_iomap_write_unwritten(
 	xfs_inode_t	*ip,
 	xfs_off_t	offset,
-	size_t		count)
+	xfs_off_t	count)
 {
 	xfs_mount_t	*mp = ip->i_mount;
 	xfs_fileoff_t	offset_fsb;
diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
index 411fbb8..8688e66 100644
--- a/fs/xfs/xfs_iomap.h
+++ b/fs/xfs/xfs_iomap.h
@@ -27,6 +27,6 @@ int xfs_iomap_write_delay(struct xfs_inode *, xfs_off_t, size_t,
 			struct xfs_bmbt_irec *);
 int xfs_iomap_write_allocate(struct xfs_inode *, xfs_off_t,
 			struct xfs_bmbt_irec *);
-int xfs_iomap_write_unwritten(struct xfs_inode *, xfs_off_t, size_t);
+int xfs_iomap_write_unwritten(struct xfs_inode *, xfs_off_t, xfs_off_t);
 
 #endif /* __XFS_IOMAP_H__*/
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
