Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7B4FB7CA7
	for <xfs@oss.sgi.com>; Wed, 10 Feb 2016 02:48:00 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DA22AAC005
	for <xfs@oss.sgi.com>; Wed, 10 Feb 2016 00:47:59 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	JIdk5H6AHjjFqirr for <xfs@oss.sgi.com>;
	Wed, 10 Feb 2016 00:47:58 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aTQQo-0005Bg-7j
	for xfs@oss.sgi.com; Wed, 10 Feb 2016 19:47:26 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aTQQo-0002aL-6y
	for xfs@oss.sgi.com; Wed, 10 Feb 2016 19:47:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/8] xfs: remove nonblocking mode from xfs_vm_writepage
Date: Wed, 10 Feb 2016 19:47:16 +1100
Message-Id: <1455094043-9694-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1455094043-9694-1-git-send-email-david@fromorbit.com>
References: <1455094043-9694-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Remove the nonblocking optimisation done for mapping lookups during
writeback. It's not clear that leaving a hole in the writeback range
just because we couldn't get a lock is really a win, as it makes us
do another small random IO later on rather than a large sequential
IO now.

As this gets in the way of sane error handling later on, just remove
for the moment and we can re-introduce an equivalent optimisation in
future if we see problems due to extent map lock contention.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_aops.c | 20 +++-----------------
 1 file changed, 3 insertions(+), 17 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 14ac982..00452cb 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -289,8 +289,7 @@ xfs_map_blocks(
 	struct inode		*inode,
 	loff_t			offset,
 	struct xfs_bmbt_irec	*imap,
-	int			type,
-	int			nonblocking)
+	int			type)
 {
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_mount	*mp = ip->i_mount;
@@ -306,12 +305,7 @@ xfs_map_blocks(
 	if (type == XFS_IO_UNWRITTEN)
 		bmapi_flags |= XFS_BMAPI_IGSTATE;
 
-	if (!xfs_ilock_nowait(ip, XFS_ILOCK_SHARED)) {
-		if (nonblocking)
-			return -EAGAIN;
-		xfs_ilock(ip, XFS_ILOCK_SHARED);
-	}
-
+	xfs_ilock(ip, XFS_ILOCK_SHARED);
 	ASSERT(ip->i_d.di_format != XFS_DINODE_FMT_BTREE ||
 	       (ip->i_df.if_flags & XFS_IFEXTENTS));
 	ASSERT(offset <= mp->m_super->s_maxbytes);
@@ -961,7 +955,6 @@ xfs_vm_writepage(
 	ssize_t			len;
 	int			err, imap_valid = 0, uptodate = 1;
 	int			count = 0;
-	int			nonblocking = 0;
 
 	trace_xfs_writepage(inode, page, 0, 0);
 
@@ -1061,9 +1054,6 @@ xfs_vm_writepage(
 	offset = page_offset(page);
 	type = XFS_IO_OVERWRITE;
 
-	if (wbc->sync_mode == WB_SYNC_NONE)
-		nonblocking = 1;
-
 	do {
 		int new_ioend = 0;
 
@@ -1123,8 +1113,7 @@ xfs_vm_writepage(
 			 * time.
 			 */
 			new_ioend = 1;
-			err = xfs_map_blocks(inode, offset, &imap, type,
-					     nonblocking);
+			err = xfs_map_blocks(inode, offset, &imap, type);
 			if (err)
 				goto error;
 			imap_valid = xfs_imap_valid(inode, &imap, offset);
@@ -1194,9 +1183,6 @@ error:
 	if (iohead)
 		xfs_cancel_ioend(iohead);
 
-	if (err == -EAGAIN)
-		goto redirty;
-
 	xfs_aops_discard_page(page);
 	ClearPageUptodate(page);
 	unlock_page(page);
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
