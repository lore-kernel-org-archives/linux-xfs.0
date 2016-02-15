Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AB8007CAA
	for <xfs@oss.sgi.com>; Mon, 15 Feb 2016 00:19:02 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8E0588F8033
	for <xfs@oss.sgi.com>; Sun, 14 Feb 2016 22:19:02 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	6SsfcF5JRoYHbNBd for <xfs@oss.sgi.com>;
	Sun, 14 Feb 2016 22:19:00 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aVCUN-0000ME-Ia
	for xfs@oss.sgi.com; Mon, 15 Feb 2016 17:18:27 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aVCUN-0005GY-Hq
	for xfs@oss.sgi.com; Mon, 15 Feb 2016 17:18:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 06/14] xfs: get mp from bma->ip in xfs_bmap code
Date: Mon, 15 Feb 2016 17:18:17 +1100
Message-Id: <1455517105-20033-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1455517105-20033-1-git-send-email-david@fromorbit.com>
References: <1455517105-20033-1-git-send-email-david@fromorbit.com>
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

From: Eric Sandeen <sandeen@redhat.com>

Source kernel commit f1f96c4946590616812711ac19eb7a84be160877

In my earlier commit

  c29aad4 xfs: pass mp to XFS_WANT_CORRUPTED_GOTO

I added some local mp variables with code which indicates that
mp might be NULL.  Coverity doesn't like this now, because the
updated per-fs XFS_STATS macros dereference mp.

I don't think this is actually a problem; from what I can tell,
we cannot get to these functions with a null bma->tp, so my NULL
check was probably pointless.  Still, it's not super obvious.

So switch this code to get mp from the inode on the xfs_bmalloca
structure, with no conditional, because the functions are already
using bmap->ip directly.

Addresses-Coverity-Id: 1339552
Addresses-Coverity-Id: 1339553
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 libxfs/xfs_bmap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index a38549c..70417fc 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -1718,7 +1718,7 @@ xfs_bmap_add_extent_delay_real(
 	struct xfs_mount	*mp;
 	int			whichfork = XFS_DATA_FORK;
 
-	mp  = bma->tp ? bma->tp->t_mountp : NULL;
+	mp = bma->ip->i_mount;
 	ifp = XFS_IFORK_PTR(bma->ip, whichfork);
 
 	ASSERT(bma->idx >= 0);
@@ -2932,7 +2932,7 @@ xfs_bmap_add_extent_hole_real(
 	int			state;	/* state bits, accessed thru macros */
 	struct xfs_mount	*mp;
 
-	mp = bma->tp ? bma->tp->t_mountp : NULL;
+	mp = bma->ip->i_mount;
 	ifp = XFS_IFORK_PTR(bma->ip, whichfork);
 
 	ASSERT(bma->idx >= 0);
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
