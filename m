Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C53B87F66
	for <xfs@oss.sgi.com>; Tue,  4 Nov 2014 06:53:29 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5184DAC003
	for <xfs@oss.sgi.com>; Tue,  4 Nov 2014 04:53:28 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	35wn9EjhX661B2sx for <xfs@oss.sgi.com>;
	Tue, 04 Nov 2014 04:53:27 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1Xldbv-0008Ph-Qy
	for xfs@oss.sgi.com; Tue, 04 Nov 2014 23:53:23 +1100
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1Xldbv-0001jD-Q4
	for xfs@oss.sgi.com; Tue, 04 Nov 2014 23:53:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/6] xfs: bulkstat btree walk doesn't terminate
Date: Tue,  4 Nov 2014 23:53:16 +1100
Message-Id: <1415105601-6455-2-git-send-email-david@fromorbit.com>
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

The bulkstat code has several different ways of detecting the end of
an AG when doing a walk. They are not consistently detected, and the
code that checks for the end of AG conditions is not consistently
coded. Hence the are conditions where the walk code can get stuck in
an endless loop making no progress and not triggering any
termination conditions.

Convert all the "tmp/i" status return codes from btree operations
to a common name (stat) and apply end-of-ag detection to these
operations consistently.

cc: stable@vger.kernel.org
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_itable.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 7765ff7..16737cb 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -356,7 +356,6 @@ xfs_bulkstat(
 	int			end_of_ag; /* set if we've seen the ag end */
 	int			error;	/* error code */
 	int                     fmterror;/* bulkstat formatter result */
-	int			i;	/* loop index */
 	int			icount;	/* count of inodes good in irbuf */
 	size_t			irbsize; /* size of irec buffer in bytes */
 	xfs_ino_t		ino;	/* inode number (filesystem) */
@@ -366,11 +365,11 @@ xfs_bulkstat(
 	xfs_ino_t		lastino; /* last inode number returned */
 	int			nirbuf;	/* size of irbuf */
 	int			rval;	/* return value error code */
-	int			tmp;	/* result value from btree calls */
 	int			ubcount; /* size of user's buffer */
 	int			ubleft;	/* bytes left in user's buffer */
 	char			__user *ubufp;	/* pointer into user's buffer */
 	int			ubelem;	/* spaces used in user's buffer */
+	int			stat;
 
 	/*
 	 * Get the last inode value, see if there's nothing to do.
@@ -436,13 +435,15 @@ xfs_bulkstat(
 				agino = r.ir_startino + XFS_INODES_PER_CHUNK;
 			}
 			/* Increment to the next record */
-			error = xfs_btree_increment(cur, 0, &tmp);
+			error = xfs_btree_increment(cur, 0, &stat);
 		} else {
 			/* Start of ag.  Lookup the first inode chunk */
-			error = xfs_inobt_lookup(cur, 0, XFS_LOOKUP_GE, &tmp);
+			error = xfs_inobt_lookup(cur, 0, XFS_LOOKUP_GE, &stat);
 		}
-		if (error)
+		if (error || stat == 0) {
+			end_of_ag = 1;
 			goto del_cursor;
+		}
 
 		/*
 		 * Loop through inode btree records in this ag,
@@ -451,8 +452,8 @@ xfs_bulkstat(
 		while (irbp < irbufend && icount < ubcount) {
 			struct xfs_inobt_rec_incore	r;
 
-			error = xfs_inobt_get_rec(cur, &r, &i);
-			if (error || i == 0) {
+			error = xfs_inobt_get_rec(cur, &r, &stat);
+			if (error || stat == 0) {
 				end_of_ag = 1;
 				goto del_cursor;
 			}
@@ -473,8 +474,8 @@ xfs_bulkstat(
 			 * Set agino to after this chunk and bump the cursor.
 			 */
 			agino = r.ir_startino + XFS_INODES_PER_CHUNK;
-			error = xfs_btree_increment(cur, 0, &tmp);
-			if (error) {
+			error = xfs_btree_increment(cur, 0, &stat);
+			if (error || stat == 0) {
 				end_of_ag = 1;
 				goto del_cursor;
 			}
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
