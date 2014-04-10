Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 898447F9D
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 00:01:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 804DB8F8054
	for <xfs@oss.sgi.com>; Wed,  9 Apr 2014 22:01:18 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	hXNOmXAqdmsdalh7 for <xfs@oss.sgi.com>;
	Wed, 09 Apr 2014 22:01:16 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WY76e-0004cD-PC
	for xfs@oss.sgi.com; Thu, 10 Apr 2014 15:00:56 +1000
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1WY76e-0002Cb-OV
	for xfs@oss.sgi.com; Thu, 10 Apr 2014 15:00:56 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 6/6] xfs: collapse range is delalloc challenged.
Date: Thu, 10 Apr 2014 15:00:53 +1000
Message-Id: <1397106053-7489-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1397106053-7489-1-git-send-email-david@fromorbit.com>
References: <1397106053-7489-1-git-send-email-david@fromorbit.com>
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

FSX has been detecting data corruption after to collapse range
calls. The key observation is that the offset of the last extent in
the file was not being shifted, and hence when the file size was
adjusted it was truncating away data because the extents handled
been correctly shifted.

Tracing indicated that before the collapse, the extent list looked
like:

....
ino 0x5788 state  idx 6 offset 26 block 195904 count 10 flag 0
ino 0x5788 state  idx 7 offset 39 block 195917 count 35 flag 0
ino 0x5788 state  idx 8 offset 86 block 195964 count 32 flag 0

and after the shift of 2 blocks:

ino 0x5788 state  idx 6 offset 24 block 195904 count 10 flag 0
ino 0x5788 state  idx 7 offset 37 block 195917 count 35 flag 0
ino 0x5788 state  idx 8 offset 86 block 195964 count 32 flag 0

Note that the last extent did not change offset. After the changing
of the file size:

ino 0x5788 state  idx 6 offset 24 block 195904 count 10 flag 0
ino 0x5788 state  idx 7 offset 37 block 195917 count 35 flag 0
ino 0x5788 state  idx 8 offset 86 block 195964 count 30 flag 0

You can see that the last extent had it's length truncated,
indicating that we've lost data.

The reason for this is that the xfs_bmap_shift_extents() loop uses
XFS_IFORK_NEXTENTS() to determine how many extents are in the inode.
This, unfortunately, doesn't take into account delayed allocation
extents - it's a count of physically allocated extents - and hence
when the file being collapsed has a delalloc extent like this one
does prior to the range being collapsed:

....
ino 0x5788 state  idx 4 offset 11 block 4503599627239429 count 1 flag 0
....

it gets the count wrong and terminates the shift loop early.

Fix it by using the in-memory extent array size that includes
delayed allocation extents to determine the number of extents on the
inode.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_bmap.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 5b6092e..f0efc7e 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -5413,6 +5413,7 @@ xfs_bmap_shift_extents(
 	int				whichfork = XFS_DATA_FORK;
 	int				logflags;
 	xfs_filblks_t			blockcount = 0;
+	int				total_extents;
 
 	if (unlikely(XFS_TEST_ERROR(
 	    (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
@@ -5429,7 +5430,6 @@ xfs_bmap_shift_extents(
 	ASSERT(current_ext != NULL);
 
 	ifp = XFS_IFORK_PTR(ip, whichfork);
-
 	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
 		/* Read in all the extents */
 		error = xfs_iread_extents(tp, ip, whichfork);
@@ -5456,7 +5456,6 @@ xfs_bmap_shift_extents(
 
 	/* We are going to change core inode */
 	logflags = XFS_ILOG_CORE;
-
 	if (ifp->if_flags & XFS_IFBROOT) {
 		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
 		cur->bc_private.b.firstblock = *firstblock;
@@ -5467,8 +5466,14 @@ xfs_bmap_shift_extents(
 		logflags |= XFS_ILOG_DEXT;
 	}
 
-	while (nexts++ < num_exts &&
-	       *current_ext <  XFS_IFORK_NEXTENTS(ip, whichfork)) {
+	/*
+	 * There may be delalloc extents in the data fork before the range we
+	 * are collapsing out, so we cannot
+	 * use the count of real extents here. Instead we have to calculate it
+	 * from the incore fork.
+	 */
+	total_extents = ifp->if_bytes / sizeof(xfs_bmbt_rec_t);
+	while (nexts++ < num_exts && *current_ext < total_extents) {
 
 		gotp = xfs_iext_get_ext(ifp, *current_ext);
 		xfs_bmbt_get_all(gotp, &got);
@@ -5556,10 +5561,11 @@ xfs_bmap_shift_extents(
 		}
 
 		(*current_ext)++;
+		total_extents = ifp->if_bytes / sizeof(xfs_bmbt_rec_t);
 	}
 
 	/* Check if we are done */
-	if (*current_ext ==  XFS_IFORK_NEXTENTS(ip, whichfork))
+	if (*current_ext == total_extents)
 		*done = 1;
 
 del_cursor:
@@ -5568,6 +5574,5 @@ del_cursor:
 			error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
 
 	xfs_trans_log_inode(tp, ip, logflags);
-
 	return error;
 }
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
