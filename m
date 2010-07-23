Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6NAcPbQ195579 for <xfs@oss.sgi.com>; Fri, 23 Jul 2010 05:38:25 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 603761E33222
	for <xfs@oss.sgi.com>; Fri, 23 Jul 2010 03:41:25 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	WnZlKXBp4pnJgfyC for <xfs@oss.sgi.com>;
	Fri, 23 Jul 2010 03:41:25 -0700 (PDT)
Received: from dastard (unverified [121.44.18.238])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	32479376-1927428
	for <xfs@oss.sgi.com>; Fri, 23 Jul 2010 20:11:24 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1OcFgx-0007Qv-0y
	for xfs@oss.sgi.com; Fri, 23 Jul 2010 20:41:23 +1000
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1OcFgv-0000RU-Kk
	for xfs@oss.sgi.com; Fri, 23 Jul 2010 20:41:21 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/3] xfs: serialise unaligned direct IO into unwritten extents
Date: Fri, 23 Jul 2010 20:41:17 +1000
Message-Id: <1279881678-1660-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1279881678-1660-1-git-send-email-david@fromorbit.com>
References: <1279881678-1660-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

If we do unaligned direct IO to a unwritten extent, the direct Io
code does sub-block zeroing for us. However, we need to serialise
the sub-block zeroing as we canot have another outstanding IO to the
same block that is being zeroed at the same time. Ifw e do so, then
we'll have two direct IOs to the same block that zero different
portions of the block and we'll end up with zeros where we should
have data.

Serialise such IOs in the get_blocks callback when we know that we
are mapping an unaligned direct IO. This initial implementation is
the sledge-hammer approach - we can probably be finer grained than
this to avoid excessive serialisation when all IO is unaligned to a
file.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_aops.c |   47 +++++++++++++++++++++++++++++++++---------
 1 files changed, 37 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_aops.c b/fs/xfs/linux-2.6/xfs_aops.c
index 8abbf05..5682490 100644
--- a/fs/xfs/linux-2.6/xfs_aops.c
+++ b/fs/xfs/linux-2.6/xfs_aops.c
@@ -1286,15 +1286,17 @@ __xfs_get_blocks(
 	struct inode		*inode,
 	sector_t		iblock,
 	struct buffer_head	*bh_result,
-	int			create,
+	int			flags,
 	int			direct)
 {
-	int			flags = create ? BMAPI_WRITE : BMAPI_READ;
+	int			create = flags & GET_BLOCKS_CREATE;
+	int			bflags = create ? BMAPI_WRITE : BMAPI_READ;
 	struct xfs_bmbt_irec	imap;
 	xfs_off_t		offset;
 	ssize_t			size;
-	int			nimap = 1;
-	int			new = 0;
+	int			nimap;
+	int			new;
+	int			iolock_changed = 0;
 	int			error;
 
 	offset = (xfs_off_t)iblock << inode->i_blkbits;
@@ -1305,15 +1307,40 @@ __xfs_get_blocks(
 		return 0;
 
 	if (direct && create)
-		flags |= BMAPI_DIRECT;
+		bflags |= BMAPI_DIRECT;
 
-	error = xfs_iomap(XFS_I(inode), offset, size, flags, &imap, &nimap,
+remap:
+	memset(&imap, 0, sizeof(imap));
+	nimap = 1;
+	new = 0;
+	error = xfs_iomap(XFS_I(inode), offset, size, bflags, &imap, &nimap,
 			  &new);
 	if (error)
 		return -error;
 	if (nimap == 0)
 		return 0;
 
+	/*
+	 * If this is an unwritten extent and we are doing unaligned direct IO
+	 * to it, we need to serialise the sub-block zeroing across multiple
+	 * concurrent IOs. As a brute-force way of doing that, promote the
+	 * IOLOCK we hold to exclusive to prevent new IO from being issued,
+	 * wait for all the current IO to drain (and potentially convert the
+	 * unwritten extents) and remap the extent once all the IO has drained.
+	 * Then we can demote the IOLOCK back to shared and proceed with the
+	 * IO.
+	 */
+	if (direct && create && ISUNWRITTEN(&imap) &&
+	    (flags & GET_BLOCKS_UNALIGNED) && !iolock_changed) {
+		xfs_iunlock(XFS_I(inode), XFS_IOLOCK_SHARED);
+		xfs_ilock(XFS_I(inode), XFS_IOLOCK_EXCL);
+		xfs_ioend_wait(XFS_I(inode));
+		iolock_changed = 1;
+		goto remap;
+	}
+	if (iolock_changed)
+		xfs_ilock_demote(XFS_I(inode), XFS_IOLOCK_EXCL);
+
 	if (imap.br_startblock != HOLESTARTBLOCK &&
 	    imap.br_startblock != DELAYSTARTBLOCK) {
 		/*
@@ -1386,9 +1413,9 @@ xfs_get_blocks(
 	struct inode		*inode,
 	sector_t		iblock,
 	struct buffer_head	*bh_result,
-	int			create)
+	int			flags)
 {
-	return __xfs_get_blocks(inode, iblock, bh_result, create, 0);
+	return __xfs_get_blocks(inode, iblock, bh_result, flags, 0);
 }
 
 STATIC int
@@ -1396,9 +1423,9 @@ xfs_get_blocks_direct(
 	struct inode		*inode,
 	sector_t		iblock,
 	struct buffer_head	*bh_result,
-	int			create)
+	int			flags)
 {
-	return __xfs_get_blocks(inode, iblock, bh_result, create, 1);
+	return __xfs_get_blocks(inode, iblock, bh_result, flags, 1);
 }
 
 STATIC void
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
