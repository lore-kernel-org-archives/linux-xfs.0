Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 61D947CCA
	for <xfs@oss.sgi.com>; Mon,  9 May 2016 03:47:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0EFE0304043
	for <xfs@oss.sgi.com>; Mon,  9 May 2016 01:47:48 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 7pcrU6biYjBUVfkL (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 09 May 2016 01:47:46 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 05/15] xfs: make xfs_bmbt_to_iomap available outside of
	xfs_pnfs.c
Date: Mon,  9 May 2016 10:47:08 +0200
Message-Id: <1462783638-4968-6-git-send-email-hch@lst.de>
In-Reply-To: <1462783638-4968-1-git-send-email-hch@lst.de>
References: <1462783638-4968-1-git-send-email-hch@lst.de>
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
Cc: rpeterso@redhat.com, vishal.l.verma@intel.com, linux-fsdevel@vger.kernel.org

And ensure it works for RT subvolume files an set the block device,
both of which will be needed to be able to use the function in the
buffered write path.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bob Peterson <rpeterso@redhat.com>
---
 fs/xfs/xfs_iomap.c | 27 +++++++++++++++++++++++++++
 fs/xfs/xfs_iomap.h |  4 ++++
 fs/xfs/xfs_pnfs.c  | 26 --------------------------
 3 files changed, 31 insertions(+), 26 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 5839135..2f37194 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -15,6 +15,7 @@
  * along with this program; if not, write the Free Software Foundation,
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
+#include <linux/iomap.h>
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
@@ -940,3 +941,29 @@ error_on_bmapi_transaction:
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return error;
 }
+
+void
+xfs_bmbt_to_iomap(
+	struct xfs_inode	*ip,
+	struct iomap		*iomap,
+	struct xfs_bmbt_irec	*imap)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+
+	if (imap->br_startblock == HOLESTARTBLOCK) {
+		iomap->blkno = IOMAP_NULL_BLOCK;
+		iomap->type = IOMAP_HOLE;
+	} else if (imap->br_startblock == DELAYSTARTBLOCK) {
+		iomap->blkno = IOMAP_NULL_BLOCK;
+		iomap->type = IOMAP_DELALLOC;
+	} else {
+		iomap->blkno = xfs_fsb_to_db(ip, imap->br_startblock);
+		if (imap->br_state == XFS_EXT_UNWRITTEN)
+			iomap->type = IOMAP_UNWRITTEN;
+		else
+			iomap->type = IOMAP_MAPPED;
+	}
+	iomap->offset = XFS_FSB_TO_B(mp, imap->br_startoff);
+	iomap->length = XFS_FSB_TO_B(mp, imap->br_blockcount);
+	iomap->bdev = xfs_find_bdev_for_inode(VFS_I(ip));
+}
diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
index 8688e66..718f07c 100644
--- a/fs/xfs/xfs_iomap.h
+++ b/fs/xfs/xfs_iomap.h
@@ -18,6 +18,7 @@
 #ifndef __XFS_IOMAP_H__
 #define __XFS_IOMAP_H__
 
+struct iomap;
 struct xfs_inode;
 struct xfs_bmbt_irec;
 
@@ -29,4 +30,7 @@ int xfs_iomap_write_allocate(struct xfs_inode *, xfs_off_t,
 			struct xfs_bmbt_irec *);
 int xfs_iomap_write_unwritten(struct xfs_inode *, xfs_off_t, xfs_off_t);
 
+void xfs_bmbt_to_iomap(struct xfs_inode *, struct iomap *,
+		struct xfs_bmbt_irec *);
+
 #endif /* __XFS_IOMAP_H__*/
diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index 0a56787..dc1a71f 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -80,32 +80,6 @@ xfs_fs_get_uuid(
 	return 0;
 }
 
-static void
-xfs_bmbt_to_iomap(
-	struct xfs_inode	*ip,
-	struct iomap		*iomap,
-	struct xfs_bmbt_irec	*imap)
-{
-	struct xfs_mount	*mp = ip->i_mount;
-
-	if (imap->br_startblock == HOLESTARTBLOCK) {
-		iomap->blkno = IOMAP_NULL_BLOCK;
-		iomap->type = IOMAP_HOLE;
-	} else if (imap->br_startblock == DELAYSTARTBLOCK) {
-		iomap->blkno = IOMAP_NULL_BLOCK;
-		iomap->type = IOMAP_DELALLOC;
-	} else {
-		iomap->blkno =
-			XFS_FSB_TO_DADDR(ip->i_mount, imap->br_startblock);
-		if (imap->br_state == XFS_EXT_UNWRITTEN)
-			iomap->type = IOMAP_UNWRITTEN;
-		else
-			iomap->type = IOMAP_MAPPED;
-	}
-	iomap->offset = XFS_FSB_TO_B(mp, imap->br_startoff);
-	iomap->length = XFS_FSB_TO_B(mp, imap->br_blockcount);
-}
-
 /*
  * Get a layout for the pNFS client.
  */
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
