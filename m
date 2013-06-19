Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 50D2E29E31
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 23:51:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D2814AC002
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 21:51:33 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	DHRzzwxLwEAjxiMo for <xfs@oss.sgi.com>;
	Tue, 18 Jun 2013 21:51:32 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UpAMb-0002y5-AO
	for xfs@oss.sgi.com; Wed, 19 Jun 2013 14:51:21 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UpAMR-0008Vd-7E
	for xfs@oss.sgi.com; Wed, 19 Jun 2013 14:51:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 06/60] xfs: xfs_ifree doesn't need to modify the inode buffer
Date: Wed, 19 Jun 2013 14:50:14 +1000
Message-Id: <1371617468-32559-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1371617468-32559-1-git-send-email-david@fromorbit.com>
References: <1371617468-32559-1-git-send-email-david@fromorbit.com>
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
index d1f76da..9ecfe1e 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2048,8 +2048,6 @@ xfs_ifree(
 	int			error;
 	int			delete;
 	xfs_ino_t		first_ino;
-	xfs_dinode_t    	*dip;
-	xfs_buf_t       	*ibp;
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	ASSERT(ip->i_d.di_nlink == 0);
@@ -2062,14 +2060,13 @@ xfs_ifree(
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
@@ -2081,31 +2078,10 @@ xfs_ifree(
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
