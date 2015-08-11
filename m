Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7E7737F50
	for <xfs@oss.sgi.com>; Tue, 11 Aug 2015 17:49:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 582828F8035
	for <xfs@oss.sgi.com>; Tue, 11 Aug 2015 15:49:59 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	CFqBSvZLYyHaH5mI for <xfs@oss.sgi.com>;
	Tue, 11 Aug 2015 15:49:57 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1ZPIMh-0005YG-0O
	for xfs@oss.sgi.com; Wed, 12 Aug 2015 08:49:51 +1000
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1ZPIMg-0004OZ-Vw
	for xfs@oss.sgi.com; Wed, 12 Aug 2015 08:49:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/8] xfs: remove nonblocking mode from xfs_vm_writepage
Date: Wed, 12 Aug 2015 08:49:43 +1000
Message-Id: <1439333388-16452-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1439333388-16452-1-git-send-email-david@fromorbit.com>
References: <1439333388-16452-1-git-send-email-david@fromorbit.com>
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

As this gets inteh way of sane error handling later on, just remove
for the moment and we can re-introduce an equivalent optimisation in
future if we see problems due to extent map lock contention.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_aops.c | 19 +++----------------
 1 file changed, 3 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 4d5479d..b718156 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -285,8 +285,7 @@ xfs_map_blocks(
 	struct inode		*inode,
 	loff_t			offset,
 	struct xfs_bmbt_irec	*imap,
-	int			type,
-	int			nonblocking)
+	int			type)
 {
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_mount	*mp = ip->i_mount;
@@ -302,12 +301,7 @@ xfs_map_blocks(
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
@@ -958,7 +952,6 @@ xfs_do_writepage(
 	ssize_t			len;
 	int			err, uptodate = 1;
 	int			count = 0;
-	int			nonblocking = 0;
 
 	trace_xfs_writepage(inode, page, 0, 0);
 
@@ -1057,9 +1050,6 @@ xfs_do_writepage(
 	bh = head = page_buffers(page);
 	offset = page_offset(page);
 
-	if (wbc->sync_mode == WB_SYNC_NONE)
-		nonblocking = 1;
-
 	do {
 		int new_ioend = 0;
 
@@ -1121,7 +1111,7 @@ xfs_do_writepage(
 			 */
 			new_ioend = 1;
 			err = xfs_map_blocks(inode, offset, &wpc->imap,
-					     wpc->io_type, nonblocking);
+					     wpc->io_type);
 			if (err)
 				goto error;
 			wpc->imap_valid = xfs_imap_valid(inode, &wpc->imap,
@@ -1192,9 +1182,6 @@ error:
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
