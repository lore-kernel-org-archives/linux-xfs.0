Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 20A5D7F7D
	for <xfs@oss.sgi.com>; Tue, 29 Oct 2013 23:31:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8F417AC0A4
	for <xfs@oss.sgi.com>; Tue, 29 Oct 2013 21:31:39 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	JyIgOmlMNXZgHiF0 for <xfs@oss.sgi.com>;
	Tue, 29 Oct 2013 21:31:38 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VbNRF-0002yh-OG
	for xfs@oss.sgi.com; Wed, 30 Oct 2013 15:31:25 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VbNRF-0007eL-Nj
	for xfs@oss.sgi.com; Wed, 30 Oct 2013 15:31:25 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 12/30] xfs: fix the wrong new_size/rnew_size at
	xfs_iext_realloc_direct()
Date: Wed, 30 Oct 2013 15:31:03 +1100
Message-Id: <1383107481-28937-13-git-send-email-david@fromorbit.com>
In-Reply-To: <1383107481-28937-1-git-send-email-david@fromorbit.com>
References: <1383107481-28937-1-git-send-email-david@fromorbit.com>
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

At xfs_iext_realloc_direct(), the new_size is changed by adding
if_bytes if originally the extent records are stored at the inline
extent buffer, and we have to switch from it to a direct extent
list for those new allocated extents, this is wrong.

This patch fix above problem and revise the new_size comments at
xfs_iext_realloc_direct() to make it more readable.  Also, fix the
comments while switching from the inline extent buffer to a direct
extent list to reflect this change.

Ported from kernel commit 17ec81c1.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 libxfs/xfs_inode_fork.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index 190690c..dfa86ae 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -1330,7 +1330,7 @@ xfs_iext_remove_indirect(
 void
 xfs_iext_realloc_direct(
 	xfs_ifork_t	*ifp,		/* inode fork pointer */
-	int		new_size)	/* new size of extents */
+	int		new_size)	/* new size of extents after adding */
 {
 	int		rnew_size;	/* real new size of extents */
 
@@ -1368,13 +1368,8 @@ xfs_iext_realloc_direct(
 				rnew_size - ifp->if_real_bytes);
 		}
 	}
-	/*
-	 * Switch from the inline extent buffer to a direct
-	 * extent list. Be sure to include the inline extent
-	 * bytes in new_size.
-	 */
+	/* Switch from the inline extent buffer to a direct extent list */
 	else {
-		new_size += ifp->if_bytes;
 		if (!is_power_of_2(new_size)) {
 			rnew_size = roundup_pow_of_two(new_size);
 		}
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
