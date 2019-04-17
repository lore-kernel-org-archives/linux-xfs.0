Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:39625 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728486AbfDQB12 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Apr 2019 21:27:28 -0400
From: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
Subject: [RFC PATCH 2/4] fs/xfs: iomap: add handle for reflink in fsdax mode
Date: Wed, 17 Apr 2019 09:27:13 +0800
Message-ID: <20190417012715.8287-3-ruansy.fnst@cn.fujitsu.com>
In-Reply-To: <20190417012715.8287-1-ruansy.fnst@cn.fujitsu.com>
References: <20190417012715.8287-1-ruansy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, linux-nvdimm@lists.01.org

xfs_file_iomap_begin() is supposed to allocate new extents for reflinked
inode and pass the source blocks' start address to the actor functions.

Signed-off-by: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
---
 fs/xfs/xfs_iomap.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 63d323916bba..a45b4e5a1d87 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -255,7 +255,11 @@ xfs_iomap_write_direct(
 	 * left but we need to do unwritten extent conversion.
 	 */
 	if (IS_DAX(VFS_I(ip))) {
-		bmapi_flags = XFS_BMAPI_CONVERT | XFS_BMAPI_ZERO;
+		if (xfs_is_cow_inode(ip))
+			/* we need to allocate new extents for reflink */
+			bmapi_flags = XFS_BMAPI_COWFORK;
+		else
+			bmapi_flags = XFS_BMAPI_CONVERT | XFS_BMAPI_ZERO;
 		if (imap->br_state == XFS_EXT_UNWRITTEN) {
 			tflags |= XFS_TRANS_RESERVE;
 			resblks = XFS_DIOSTRAT_SPACE_RES(mp, 0) << 1;
@@ -983,7 +987,8 @@ xfs_file_iomap_begin(
 	 */
 	if (xfs_is_cow_inode(ip)) {
 		struct xfs_bmbt_irec	cmap;
-		bool			directio = (flags & IOMAP_DIRECT);
+		bool			convert = (flags & IOMAP_DIRECT)
+							|| IS_DAX(inode);
 
 		/* if zeroing doesn't need COW allocation, then we are done. */
 		if ((flags & IOMAP_ZERO) &&
@@ -993,10 +998,16 @@ xfs_file_iomap_begin(
 		/* may drop and re-acquire the ilock */
 		cmap = imap;
 		error = xfs_reflink_allocate_cow(ip, &cmap, &shared, &lockmode,
-				directio);
+				convert);
 		if (error)
 			goto out_unlock;
 
+		if (shared && IS_DAX(inode)) {
+			/* get source address and pass it to actor functions */
+			iomap->src_addr = BBTOB(xfs_fsb_to_db(ip,
+							imap.br_startblock));
+		}
+
 		/*
 		 * For buffered writes we need to report the address of the
 		 * previous block (if there was any) so that the higher level
@@ -1005,8 +1016,9 @@ xfs_file_iomap_begin(
 		 * I/O, which must be block aligned, we need to report the
 		 * newly allocated address.  If the data fork has a hole, copy
 		 * the COW fork mapping to avoid allocating to the data fork.
+		 * If is DAX, we need to allocate new address.
 		 */
-		if (directio || imap.br_startblock == HOLESTARTBLOCK)
+		if (convert || imap.br_startblock == HOLESTARTBLOCK)
 			imap = cmap;
 
 		end_fsb = imap.br_startoff + imap.br_blockcount;
-- 
2.17.0
