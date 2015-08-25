Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 043E07F3F
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 00:06:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BAF1B304039
	for <xfs@oss.sgi.com>; Mon, 24 Aug 2015 22:06:41 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	qInJ2mSojwzURoC8 for <xfs@oss.sgi.com>;
	Mon, 24 Aug 2015 22:06:10 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1ZU6Ql-0001qt-Hf
	for xfs@oss.sgi.com; Tue, 25 Aug 2015 15:05:55 +1000
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1ZU6Ql-0000lJ-Gx
	for xfs@oss.sgi.com; Tue, 25 Aug 2015 15:05:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/4] xfs: remove nonblocking mode from xfs_vm_writepage
Date: Tue, 25 Aug 2015 15:05:50 +1000
Message-Id: <1440479153-1584-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1440479153-1584-1-git-send-email-david@fromorbit.com>
References: <1440479153-1584-1-git-send-email-david@fromorbit.com>
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
---
 fs/xfs/xfs_aops.c | 20 +++-----------------
 1 file changed, 3 insertions(+), 17 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 3859f5e..89fad6b 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -276,8 +276,7 @@ xfs_map_blocks(
 	struct inode		*inode,
 	loff_t			offset,
 	struct xfs_bmbt_irec	*imap,
-	int			type,
-	int			nonblocking)
+	int			type)
 {
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_mount	*mp = ip->i_mount;
@@ -293,12 +292,7 @@ xfs_map_blocks(
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
@@ -949,7 +943,6 @@ xfs_vm_writepage(
 	ssize_t			len;
 	int			err, imap_valid = 0, uptodate = 1;
 	int			count = 0;
-	int			nonblocking = 0;
 
 	trace_xfs_writepage(inode, page, 0, 0);
 
@@ -1049,9 +1042,6 @@ xfs_vm_writepage(
 	offset = page_offset(page);
 	type = XFS_IO_OVERWRITE;
 
-	if (wbc->sync_mode == WB_SYNC_NONE)
-		nonblocking = 1;
-
 	do {
 		int new_ioend = 0;
 
@@ -1111,8 +1101,7 @@ xfs_vm_writepage(
 			 * time.
 			 */
 			new_ioend = 1;
-			err = xfs_map_blocks(inode, offset, &imap, type,
-					     nonblocking);
+			err = xfs_map_blocks(inode, offset, &imap, type);
 			if (err)
 				goto error;
 			imap_valid = xfs_imap_valid(inode, &imap, offset);
@@ -1182,9 +1171,6 @@ error:
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
