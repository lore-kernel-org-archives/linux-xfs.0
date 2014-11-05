Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C9DE97FAB
	for <xfs@oss.sgi.com>; Tue,  4 Nov 2014 18:05:51 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B55538F8039
	for <xfs@oss.sgi.com>; Tue,  4 Nov 2014 16:05:48 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	WQUUVO7zT6zIbN2Q for <xfs@oss.sgi.com>;
	Tue, 04 Nov 2014 16:05:47 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1Xlo6G-0001sf-BF
	for xfs@oss.sgi.com; Wed, 05 Nov 2014 11:05:24 +1100
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1Xlo6G-0008DQ-AV
	for xfs@oss.sgi.com; Wed, 05 Nov 2014 11:05:24 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5/6] xfs: bulkstat error handling is broken
Date: Wed,  5 Nov 2014 11:05:20 +1100
Message-Id: <1415145921-31507-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1415145921-31507-1-git-send-email-david@fromorbit.com>
References: <1415145921-31507-1-git-send-email-david@fromorbit.com>
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

The error propagation is a horror - xfs_bulkstat() returns
a rval variable which is only set if there are formatter errors. Any
sort of btree walk error or corruption will cause the bulkstat walk
to terminate but will not pass an error back to userspace. Worse
is the fact that formatter errors will also be ignored if any inodes
were correctly formatted into the user buffer.

Hence bulkstat can fail badly yet still report success to userspace.
This causes significant issues with xfsdump not dumping everything
in the filesystem yet reporting success. It's not until a restore
fails that there is any indication that the dump was bad and tha
bulkstat failed. This patch now triggers xfsdump to fail with
bulkstat errors rather than silently missing files in the dump.

This now causes bulkstat to fail when the lastino cookie does not
fall inside an existing inode chunk. The pre-3.17 code tolerated
that error by allowing the code to move to the next inode chunk
as the agino target is guaranteed to fall into the next btree
record.

With the fixes up to this point in the series, xfsdump now passes on
the troublesome filesystem image that exposes all these bugs.

cc: <stable@vger.kernel.org>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_itable.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index a9c28d1..be96754 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -236,8 +236,10 @@ xfs_bulkstat_grab_ichunk(
 	XFS_WANT_CORRUPTED_RETURN(stat == 1);
 
 	/* Check if the record contains the inode in request */
-	if (irec->ir_startino + XFS_INODES_PER_CHUNK <= agino)
-		return -EINVAL;
+	if (irec->ir_startino + XFS_INODES_PER_CHUNK <= agino) {
+		*icount = 0;
+		return 0;
+	}
 
 	idx = agino - irec->ir_startino + 1;
 	if (idx < XFS_INODES_PER_CHUNK &&
@@ -352,7 +354,6 @@ xfs_bulkstat(
 	xfs_inobt_rec_incore_t	*irbuf;	/* start of irec buffer */
 	xfs_ino_t		lastino; /* last inode number returned */
 	int			nirbuf;	/* size of irbuf */
-	int			rval;	/* return value error code */
 	int			ubcount; /* size of user's buffer */
 	struct xfs_bulkstat_agichunk ac;
 	int			error = 0;
@@ -388,7 +389,6 @@ xfs_bulkstat(
 	 * Loop over the allocation groups, starting from the last
 	 * inode returned; 0 means start of the allocation group.
 	 */
-	rval = 0;
 	while (ac.ac_ubleft >= statstruct_size && agno < mp->m_sb.sb_agcount) {
 		struct xfs_inobt_rec_incore	*irbp = irbuf;
 		struct xfs_inobt_rec_incore	*irbufend = irbuf + nirbuf;
@@ -491,11 +491,14 @@ del_cursor:
 					formatter, statstruct_size, &ac,
 					&lastino);
 			if (error)
-				rval = error;
+				break;
 
 			cond_resched();
 		}
 
+		if (error)
+			break;
+
 		if (end_of_ag) {
 			agno++;
 			agino = 0;
@@ -507,11 +510,17 @@ del_cursor:
 	 */
 	kmem_free(irbuf);
 	*ubcountp = ac.ac_ubelem;
+
 	/*
-	 * Found some inodes, return them now and return the error next time.
+	 * We found some inodes, so clear the error status and return them.
+	 * The lastino pointer will point directly at the inode that triggered
+	 * any error that occurred, so on the next call the error will be
+	 * triggered again and propagated to userspace as there will be no
+	 * formatted inodes in the buffer.
 	 */
 	if (ac.ac_ubelem)
-		rval = 0;
+		error = 0;
+
 	if (agno >= mp->m_sb.sb_agcount) {
 		/*
 		 * If we ran out of filesystem, mark lastino as off
@@ -523,7 +532,7 @@ del_cursor:
 	} else
 		*lastinop = (xfs_ino_t)lastino;
 
-	return rval;
+	return error;
 }
 
 int
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
