Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7IBaCD4110424 for <xfs@oss.sgi.com>; Wed, 18 Aug 2010 06:36:12 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3DE1555BC
	for <xfs@oss.sgi.com>; Wed, 18 Aug 2010 04:36:41 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	fauqX07uO34MEKJD for <xfs@oss.sgi.com>;
	Wed, 18 Aug 2010 04:36:41 -0700 (PDT)
Received: from dastard (unverified [121.44.216.100])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	35480615-1927428
	for <xfs@oss.sgi.com>; Wed, 18 Aug 2010 21:06:40 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1Olgwh-0005Ks-4I
	for xfs@oss.sgi.com; Wed, 18 Aug 2010 21:36:39 +1000
Received: from dave by disturbed with local (Exim 4.72)
	(envelope-from <dave@disturbed.disaster>) id 1Olgwd-0007o4-6R
	for xfs@oss.sgi.com; Wed, 18 Aug 2010 21:36:35 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 6/8] xfs: fix untrusted inode number lookup
Date: Wed, 18 Aug 2010 21:36:17 +1000
Message-Id: <1282131379-29932-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1282131379-29932-1-git-send-email-david@fromorbit.com>
References: <1282131379-29932-1-git-send-email-david@fromorbit.com>
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

Commit 7124fe0a5b619d65b739477b3b55a20bf805b06d ("xfs: validate untrusted inode
numbers during lookup") changes the inode lookup code to do btree lookups for
untrusted inode numbers. This change made an invalid assumption about the
alignment of inodes and hence incorrectly calculated the first inode in the
cluster. As a result, some inode numbers were being incorrectly considered
invalid when they were actually valid.

The issue was not picked up by the xfstests suite because it always runs fsr
and dump (the two utilities that utilise the bulkstat interface) on cache hot
inodes and hence the lookup code in the cold cache path was not sufficiently
exercised to uncover this intermittent problem.

Fix the issue by relaxing the btree lookup criteria and then checking if the
record returned contains the inode number we are lookup for. If it we get an
incorrect record, then the inode number is invalid.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_ialloc.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index abf80ae..5371d2d 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -1213,7 +1213,6 @@ xfs_imap_lookup(
 	struct xfs_inobt_rec_incore rec;
 	struct xfs_btree_cur	*cur;
 	struct xfs_buf		*agbp;
-	xfs_agino_t		startino;
 	int			error;
 	int			i;
 
@@ -1227,13 +1226,13 @@ xfs_imap_lookup(
 	}
 
 	/*
-	 * derive and lookup the exact inode record for the given agino. If the
-	 * record cannot be found, then it's an invalid inode number and we
-	 * should abort.
+	 * Lookup the inode record for the given agino. If the record cannot be
+	 * found, then it's an invalid inode number and we should abort. Once
+	 * we have a record, we need to ensure it contains the inode number
+	 * we are looking up.
 	 */
 	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno);
-	startino = agino & ~(XFS_IALLOC_INODES(mp) - 1);
-	error = xfs_inobt_lookup(cur, startino, XFS_LOOKUP_EQ, &i);
+	error = xfs_inobt_lookup(cur, agino, XFS_LOOKUP_LE, &i);
 	if (!error) {
 		if (i)
 			error = xfs_inobt_get_rec(cur, &rec, &i);
@@ -1246,6 +1245,11 @@ xfs_imap_lookup(
 	if (error)
 		return error;
 
+	/* check that the returned record contains the required inode */
+	if (rec.ir_startino > agino ||
+	    rec.ir_startino + XFS_IALLOC_INODES(mp) <= agino)
+		return EINVAL;
+
 	/* for untrusted inodes check it is allocated first */
 	if ((flags & XFS_IGET_UNTRUSTED) &&
 	    (rec.ir_free & XFS_INOBT_MASK(agino - rec.ir_startino)))
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
