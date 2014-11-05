Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D5A2D7F9B
	for <xfs@oss.sgi.com>; Tue,  4 Nov 2014 18:05:50 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 57082AC005
	for <xfs@oss.sgi.com>; Tue,  4 Nov 2014 16:05:50 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	6yyZlMB342tiN3Fw for <xfs@oss.sgi.com>;
	Tue, 04 Nov 2014 16:05:48 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1Xlo6G-0001se-Aj
	for xfs@oss.sgi.com; Wed, 05 Nov 2014 11:05:24 +1100
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1Xlo6G-0008DL-A0
	for xfs@oss.sgi.com; Wed, 05 Nov 2014 11:05:24 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/6] xfs: bulkstat main loop logic is a mess
Date: Wed,  5 Nov 2014 11:05:19 +1100
Message-Id: <1415145921-31507-5-git-send-email-david@fromorbit.com>
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

There are a bunch of variables tha tare more wildy scoped than they
need to be, obfuscated user buffer checks and tortured "next inode"
tracking. This all needs cleaning up to expose the real issues that
need fixing.

cc: <stable@vger.kernel.org>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_itable.c | 52 ++++++++++++++++++++--------------------------------
 1 file changed, 20 insertions(+), 32 deletions(-)

diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 7ea2b11..a9c28d1 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -348,30 +348,23 @@ xfs_bulkstat(
 	xfs_agino_t		agino;	/* inode # in allocation group */
 	xfs_agnumber_t		agno;	/* allocation group number */
 	xfs_btree_cur_t		*cur;	/* btree cursor for ialloc btree */
-	int			end_of_ag; /* set if we've seen the ag end */
-	int			error;	/* error code */
-	int			icount;	/* count of inodes good in irbuf */
 	size_t			irbsize; /* size of irec buffer in bytes */
-	xfs_ino_t		ino;	/* inode number (filesystem) */
-	xfs_inobt_rec_incore_t	*irbp;	/* current irec buffer pointer */
 	xfs_inobt_rec_incore_t	*irbuf;	/* start of irec buffer */
-	xfs_inobt_rec_incore_t	*irbufend; /* end of good irec buffer entries */
 	xfs_ino_t		lastino; /* last inode number returned */
 	int			nirbuf;	/* size of irbuf */
 	int			rval;	/* return value error code */
 	int			ubcount; /* size of user's buffer */
-	int			stat;
 	struct xfs_bulkstat_agichunk ac;
+	int			error = 0;
 
 	/*
 	 * Get the last inode value, see if there's nothing to do.
 	 */
-	ino = (xfs_ino_t)*lastinop;
-	lastino = ino;
-	agno = XFS_INO_TO_AGNO(mp, ino);
-	agino = XFS_INO_TO_AGINO(mp, ino);
+	lastino = *lastinop;
+	agno = XFS_INO_TO_AGNO(mp, lastino);
+	agino = XFS_INO_TO_AGINO(mp, lastino);
 	if (agno >= mp->m_sb.sb_agcount ||
-	    ino != XFS_AGINO_TO_INO(mp, agno, agino)) {
+	    lastino != XFS_AGINO_TO_INO(mp, agno, agino)) {
 		*done = 1;
 		*ubcountp = 0;
 		return 0;
@@ -396,8 +389,13 @@ xfs_bulkstat(
 	 * inode returned; 0 means start of the allocation group.
 	 */
 	rval = 0;
-	while (XFS_BULKSTAT_UBLEFT(ac.ac_ubleft) && agno < mp->m_sb.sb_agcount) {
-		cond_resched();
+	while (ac.ac_ubleft >= statstruct_size && agno < mp->m_sb.sb_agcount) {
+		struct xfs_inobt_rec_incore	*irbp = irbuf;
+		struct xfs_inobt_rec_incore	*irbufend = irbuf + nirbuf;
+		bool				end_of_ag = false;
+		int				icount = 0;
+		int				stat;
+
 		error = xfs_ialloc_read_agi(mp, NULL, agno, &agbp);
 		if (error)
 			break;
@@ -407,10 +405,6 @@ xfs_bulkstat(
 		 */
 		cur = xfs_inobt_init_cursor(mp, NULL, agbp, agno,
 					    XFS_BTNUM_INO);
-		irbp = irbuf;
-		irbufend = irbuf + nirbuf;
-		end_of_ag = 0;
-		icount = 0;
 		if (agino > 0) {
 			/*
 			 * In the middle of an allocation group, we need to get
@@ -435,7 +429,7 @@ xfs_bulkstat(
 			error = xfs_inobt_lookup(cur, 0, XFS_LOOKUP_GE, &stat);
 		}
 		if (error || stat == 0) {
-			end_of_ag = 1;
+			end_of_ag = true;
 			goto del_cursor;
 		}
 
@@ -448,7 +442,7 @@ xfs_bulkstat(
 
 			error = xfs_inobt_get_rec(cur, &r, &stat);
 			if (error || stat == 0) {
-				end_of_ag = 1;
+				end_of_ag = true;
 				goto del_cursor;
 			}
 
@@ -470,7 +464,7 @@ xfs_bulkstat(
 			agino = r.ir_startino + XFS_INODES_PER_CHUNK;
 			error = xfs_btree_increment(cur, 0, &stat);
 			if (error || stat == 0) {
-				end_of_ag = 1;
+				end_of_ag = true;
 				goto del_cursor;
 			}
 			cond_resched();
@@ -491,7 +485,7 @@ del_cursor:
 		 */
 		irbufend = irbp;
 		for (irbp = irbuf;
-		     irbp < irbufend && XFS_BULKSTAT_UBLEFT(ac.ac_ubleft);
+		     irbp < irbufend && ac.ac_ubleft >= statstruct_size;
 		     irbp++) {
 			error = xfs_bulkstat_ag_ichunk(mp, agno, irbp,
 					formatter, statstruct_size, &ac,
@@ -502,17 +496,11 @@ del_cursor:
 			cond_resched();
 		}
 
-		/*
-		 * Set up for the next loop iteration.
-		 */
-		if (XFS_BULKSTAT_UBLEFT(ac.ac_ubleft)) {
-			if (end_of_ag) {
-				agno++;
-				agino = 0;
-			} else
-				agino = XFS_INO_TO_AGINO(mp, lastino);
+		if (end_of_ag) {
+			agno++;
+			agino = 0;
 		} else
-			break;
+			agino = XFS_INO_TO_AGINO(mp, lastino);
 	}
 	/*
 	 * Done, we're either out of filesystem or space to put the data.
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
