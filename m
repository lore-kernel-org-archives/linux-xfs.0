Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8C2157F66
	for <xfs@oss.sgi.com>; Tue,  4 Nov 2014 06:53:30 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6B0118F8039
	for <xfs@oss.sgi.com>; Tue,  4 Nov 2014 04:53:30 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	OGPnqQqdlsO32rq4 for <xfs@oss.sgi.com>;
	Tue, 04 Nov 2014 04:53:28 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1Xldbv-0008Pm-TU
	for xfs@oss.sgi.com; Tue, 04 Nov 2014 23:53:23 +1100
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1Xldbv-0001jc-Sc
	for xfs@oss.sgi.com; Tue, 04 Nov 2014 23:53:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 6/6] xfs: track bulkstat progress by agino
Date: Tue,  4 Nov 2014 23:53:21 +1100
Message-Id: <1415105601-6455-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1415105601-6455-1-git-send-email-david@fromorbit.com>
References: <1415105601-6455-1-git-send-email-david@fromorbit.com>
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

The bulkstat main loop progress is tracked by the "lastino"
variable, which is a full 64 bit inode. However, the loop actually
works on agno/agino pairs, and so there's a significant disconnect
between the rest of the loop and the main cursor. Convert this to
use the agino, and pass the agino into the chunk formatting function
and convert it too.

This gets rid of the inconsistency in the loop processing, and
finally makes it simple for us to skip inodes at any point in the
loop simply by incrementing the agino cursor.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_itable.c | 50 +++++++++++++++++++-------------------------------
 1 file changed, 19 insertions(+), 31 deletions(-)

diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 6a4ef8e..2a6f2e8 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -282,45 +282,39 @@ xfs_bulkstat_ag_ichunk(
 	bulkstat_one_pf			formatter,
 	size_t				statstruct_size,
 	struct xfs_bulkstat_agichunk	*acp,
-	xfs_ino_t			*lastino)
+	xfs_agino_t			*last_agino)
 {
 	char				__user **ubufp = acp->ac_ubuffer;
 	int				chunkidx;
 	int				error = 0;
-	xfs_agino_t			agino;
 
-	agino = irbp->ir_startino;
+	*last_agino = irbp->ir_startino;
 	for (chunkidx = 0; chunkidx < XFS_INODES_PER_CHUNK;
-	     chunkidx++, agino++) {
+	     chunkidx++, (*last_agino)++) {
 		int		fmterror;
 		int		ubused;
-		xfs_ino_t	ino = XFS_AGINO_TO_INO(mp, agno, agino);
 
 		/* Skip if this inode is free */
-		if (XFS_INOBT_MASK(chunkidx) & irbp->ir_free) {
-			*lastino = ino;
+		if (XFS_INOBT_MASK(chunkidx) & irbp->ir_free)
 			continue;
-		}
 
 		/* Get the inode and fill in a single buffer */
 		ubused = statstruct_size;
-		error = formatter(mp, ino, *ubufp, acp->ac_ubleft,
-				  &ubused, &fmterror);
+		error = formatter(mp, XFS_AGINO_TO_INO(mp, agno, *last_agino),
+				  *ubufp, acp->ac_ubleft, &ubused, &fmterror);
+
 		if (fmterror == BULKSTAT_RV_GIVEUP ||
 		    (error && error != -ENOENT && error != -EINVAL)) {
 			acp->ac_ubleft = 0;
 			ASSERT(error);
 			break;
 		}
-		if (fmterror == BULKSTAT_RV_NOTHING || error) {
-			*lastino = ino;
+		if (fmterror == BULKSTAT_RV_NOTHING || error)
 			continue;
-		}
 
 		*ubufp += ubused;
 		acp->ac_ubleft -= ubused;
 		acp->ac_ubelem++;
-		*lastino = ino;
 
 		if (acp->ac_ubleft < statstruct_size)
 			break;
@@ -349,7 +343,6 @@ xfs_bulkstat(
 	xfs_btree_cur_t		*cur;	/* btree cursor for ialloc btree */
 	size_t			irbsize; /* size of irec buffer in bytes */
 	xfs_inobt_rec_incore_t	*irbuf;	/* start of irec buffer */
-	xfs_ino_t		lastino; /* last inode number returned */
 	int			nirbuf;	/* size of irbuf */
 	int			ubcount; /* size of user's buffer */
 	struct xfs_bulkstat_agichunk ac;
@@ -358,11 +351,10 @@ xfs_bulkstat(
 	/*
 	 * Get the last inode value, see if there's nothing to do.
 	 */
-	lastino = *lastinop;
-	agno = XFS_INO_TO_AGNO(mp, lastino);
-	agino = XFS_INO_TO_AGINO(mp, lastino);
+	agno = XFS_INO_TO_AGNO(mp, *lastinop);
+	agino = XFS_INO_TO_AGINO(mp, *lastinop);
 	if (agno >= mp->m_sb.sb_agcount ||
-	    lastino != XFS_AGINO_TO_INO(mp, agno, agino)) {
+	    *lastinop != XFS_AGINO_TO_INO(mp, agno, agino)) {
 		*done = 1;
 		*ubcountp = 0;
 		return 0;
@@ -486,7 +478,7 @@ del_cursor:
 		     irbp++) {
 			error = xfs_bulkstat_ag_ichunk(mp, agno, irbp,
 					formatter, statstruct_size, &ac,
-					&lastino);
+					&agino);
 			if (error)
 				break;
 
@@ -499,8 +491,7 @@ del_cursor:
 		if (end_of_ag) {
 			agno++;
 			agino = 0;
-		} else
-			agino = XFS_INO_TO_AGINO(mp, lastino);
+		}
 	}
 	/*
 	 * Done, we're either out of filesystem or space to put the data.
@@ -518,16 +509,13 @@ del_cursor:
 	if (ac.ac_ubelem)
 		error = 0;
 
-	if (agno >= mp->m_sb.sb_agcount) {
-		/*
-		 * If we ran out of filesystem, mark lastino as off
-		 * the end of the filesystem, so the next call
-		 * will return immediately.
-		 */
-		*lastinop = (xfs_ino_t)XFS_AGINO_TO_INO(mp, agno, 0);
+	/*
+	 * If we ran out of filesystem, lastino will point off the end of
+	 * the filesystem so the next call will return immediately.
+	 */
+	*lastinop = XFS_AGINO_TO_INO(mp, agno, agino);
+	if (agno >= mp->m_sb.sb_agcount)
 		*done = 1;
-	} else
-		*lastinop = (xfs_ino_t)lastino;
 
 	return error;
 }
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
