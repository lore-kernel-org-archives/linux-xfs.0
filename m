Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B7EE37CB1
	for <xfs@oss.sgi.com>; Mon,  1 Feb 2016 18:39:33 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A8E258F8035
	for <xfs@oss.sgi.com>; Mon,  1 Feb 2016 16:39:33 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	vIQfFgzPqBu6sGrd for <xfs@oss.sgi.com>;
	Mon, 01 Feb 2016 16:39:27 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aQOzw-0007pp-J2
	for xfs@oss.sgi.com; Tue, 02 Feb 2016 11:39:12 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aQOzw-0000pb-I1
	for xfs@oss.sgi.com; Tue, 02 Feb 2016 11:39:12 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/3] xfs: lock rt summary inode on allocation
Date: Tue,  2 Feb 2016 11:39:08 +1100
Message-Id: <1454373550-3102-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1454373550-3102-1-git-send-email-david@fromorbit.com>
References: <1454373550-3102-1-git-send-email-david@fromorbit.com>
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

RT allocation can fail on a debug kernel with:

XFS: Assertion failed: xfs_isilocked(ip, XFS_ILOCK_SHARED|XFS_ILOCK_EXCL), file: fs/xfs/libxfs/xfs_bmap.c, line: 4039

When modifying the summary inode during allocation. This occurs
because the summary inode is never locked, and xfs_bmapi_*
operations expect it to be locked. The summary inode is effectively
protected byt he lock on the bitmap inode, so this really is only a
debug kernel issue.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_bmap_util.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 7087756..fd7f51c 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -202,10 +202,12 @@ xfs_bmap_rtalloc(
 		ralen = MAXEXTLEN / mp->m_sb.sb_rextsize;
 
 	/*
-	 * Lock out other modifications to the RT bitmap inode.
+	 * Lock out modifications to both the RT bitmap and summary inodes
 	 */
 	xfs_ilock(mp->m_rbmip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(ap->tp, mp->m_rbmip, XFS_ILOCK_EXCL);
+	xfs_ilock(mp->m_rsumip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(ap->tp, mp->m_rsumip, XFS_ILOCK_EXCL);
 
 	/*
 	 * If it's an allocation to an empty file at offset 0,
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
