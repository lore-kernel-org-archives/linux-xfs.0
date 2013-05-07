Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0488629DF8
	for <xfs@oss.sgi.com>; Tue,  7 May 2013 03:04:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E721930406A
	for <xfs@oss.sgi.com>; Tue,  7 May 2013 01:04:55 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	fieAGAzT82UT3jNV for <xfs@oss.sgi.com>;
	Tue, 07 May 2013 01:04:54 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UZctH-0006Z9-GA
	for xfs@oss.sgi.com; Tue, 07 May 2013 18:04:51 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UZctH-0007rI-7B
	for xfs@oss.sgi.com; Tue, 07 May 2013 18:04:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/7] xfs: xfs_ifree doesn't need to modify the inode buffer
Date: Tue,  7 May 2013 18:04:31 +1000
Message-Id: <1367913876-30086-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1367913876-30086-1-git-send-email-david@fromorbit.com>
References: <1367913876-30086-1-git-send-email-david@fromorbit.com>
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

Long ago, bulkstat used to read inodes directly fromteh backing
buffer for speed. This had the unfortunate problem of being cache
incoherent with unlinks, and so xfs_ifree() had to mark the inode
as free directly in the backing buffer. bulkstat was changed some
time ago to use inode cache coherent lookups, and so will never see
unlinked inodes in it's lookups. Hence xfs_ifree() does not need to
touch the inode backing buffer anymore.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_inode.c |   32 ++++----------------------------
 1 file changed, 4 insertions(+), 28 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 9a475d1..22e635d 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2032,8 +2032,6 @@ xfs_ifree(
 	int			error;
 	int			delete;
 	xfs_ino_t		first_ino;
-	xfs_dinode_t    	*dip;
-	xfs_buf_t       	*ibp;
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	ASSERT(ip->i_d.di_nlink == 0);
@@ -2046,14 +2044,13 @@ xfs_ifree(
 	 * Pull the on-disk inode from the AGI unlinked list.
 	 */
 	error = xfs_iunlink_remove(tp, ip);
-	if (error != 0) {
+	if (error)
 		return error;
-	}
 
 	error = xfs_difree(tp, ip->i_ino, flist, &delete, &first_ino);
-	if (error != 0) {
+	if (error)
 		return error;
-	}
+
 	ip->i_d.di_mode = 0;		/* mark incore inode as free */
 	ip->i_d.di_flags = 0;
 	ip->i_d.di_dmevmask = 0;
@@ -2065,31 +2062,10 @@ xfs_ifree(
 	 * by reincarnations of this inode.
 	 */
 	ip->i_d.di_gen++;
-
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
-	error = xfs_imap_to_bp(ip->i_mount, tp, &ip->i_imap, &dip, &ibp,
-			       0, 0);
-	if (error)
-		return error;
-
-        /*
-	* Clear the on-disk di_mode. This is to prevent xfs_bulkstat
-	* from picking up this inode when it is reclaimed (its incore state
-	* initialzed but not flushed to disk yet). The in-core di_mode is
-	* already cleared  and a corresponding transaction logged.
-	* The hack here just synchronizes the in-core to on-disk
-	* di_mode value in advance before the actual inode sync to disk.
-	* This is OK because the inode is already unlinked and would never
-	* change its di_mode again for this inode generation.
-	* This is a temporary hack that would require a proper fix
-	* in the future.
-	*/
-	dip->di_mode = 0;
-
-	if (delete) {
+	if (delete)
 		error = xfs_ifree_cluster(ip, tp, first_ino);
-	}
 
 	return error;
 }
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
