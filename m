Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 76BA829DFA
	for <xfs@oss.sgi.com>; Fri, 12 Apr 2013 08:57:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E9EE0AC002
	for <xfs@oss.sgi.com>; Fri, 12 Apr 2013 06:57:30 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	Tc6vVk0QJmlOhlZx for <xfs@oss.sgi.com>;
	Fri, 12 Apr 2013 06:57:28 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UQeTO-0000oY-9B
	for xfs@oss.sgi.com; Fri, 12 Apr 2013 23:57:02 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UQeTO-0000aY-47
	for xfs@oss.sgi.com; Fri, 12 Apr 2013 23:57:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs_repair: validate on-disk extent count better
Date: Fri, 12 Apr 2013 23:57:02 +1000
Message-Id: <1365775022-2234-1-git-send-email-david@fromorbit.com>
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

When scanning a btree format inode, we trust the extent count to be
in range.  However, values of the range 2^31 <= cnt < 2^32 are
invalid and can cause problems with signed range checks. This
results in assert failures which validating the extent count such
as:

xfs_repair: dinode.c:768: process_bmbt_reclist_int: Assertion `i < *numrecs' failed.

Validate the extent count is at least within the positive range of a
singed 32 bit integer before using it.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 repair/dinode.c |   25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/repair/dinode.c b/repair/dinode.c
index 5a2da39..239bb7b 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -1293,7 +1293,7 @@ process_exinode(
 	xfs_bmbt_rec_t		*rp;
 	xfs_dfiloff_t		first_key;
 	xfs_dfiloff_t		last_key;
-	int			numrecs;
+	int32_t			numrecs;
 	int			ret;
 
 	lino = XFS_AGINO_TO_INO(mp, agno, ino);
@@ -1302,6 +1302,15 @@ process_exinode(
 	numrecs = XFS_DFORK_NEXTENTS(dip, whichfork);
 
 	/*
+	 * We've already decided on the maximum number of extents on the inode,
+	 * and numrecs may be corrupt. Hence make sure we only allow numrecs to
+	 * be in the range of valid on-disk numbers, which is:
+	 *	0 < numrecs < 2^31 - 1
+	 */
+	if (numrecs < 0)
+		numrecs = *nex;
+
+	/*
 	 * XXX - if we were going to fix up the btree record,
 	 * we'd do it right here.  For now, if there's a problem,
 	 * we'll bail out and presumably clear the inode.
@@ -2038,11 +2047,23 @@ process_inode_data_fork(
 {
 	xfs_ino_t	lino = XFS_AGINO_TO_INO(mp, agno, ino);
 	int		err = 0;
+	int		nex;
+
+	/*
+	 * extent count on disk is only valid for positive values. The kernel
+	 * uses negative values in memory. hence if we see negative numbers
+	 * here, trash it!
+	 */
+	nex = be32_to_cpu(dino->di_nextents);
+	if (nex < 0)
+		*nextents = 1;
+	else
+		*nextents = nex;
 
-	*nextents = be32_to_cpu(dino->di_nextents);
 	if (*nextents > be64_to_cpu(dino->di_nblocks))
 		*nextents = 1;
 
+
 	if (dino->di_format != XFS_DINODE_FMT_LOCAL && type != XR_INO_RTDATA)
 		*dblkmap = blkmap_alloc(*nextents, XFS_DATA_FORK);
 	*nextents = 0;
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
