Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0D89D7F4E
	for <xfs@oss.sgi.com>; Wed,  7 Jan 2015 15:43:12 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9FDBFAC001
	for <xfs@oss.sgi.com>; Wed,  7 Jan 2015 13:43:11 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	Xu29kBozbbV52k5o for <xfs@oss.sgi.com>;
	Wed, 07 Jan 2015 13:43:10 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1Y8yNe-0005HV-1g
	for xfs@oss.sgi.com; Thu, 08 Jan 2015 08:43:06 +1100
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1Y8yNe-0001uL-0c
	for xfs@oss.sgi.com; Thu, 08 Jan 2015 08:43:06 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/4] xfs: move xfs_bmap_finish prototype
Date: Thu,  8 Jan 2015 08:43:03 +1100
Message-Id: <1420666983-7275-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1420666983-7275-1-git-send-email-david@fromorbit.com>
References: <1420666983-7275-1-git-send-email-david@fromorbit.com>
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

This function is used libxfs code, but is implemented separately in
userspace. Move the function prototype to xfs_bmap.h so that the
prototype is shared even if the implementations aren't.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.h | 2 ++
 fs/xfs/xfs_bmap_util.h   | 2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 856f53c..b9d8a49 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -180,6 +180,8 @@ void	xfs_bmap_local_to_extents_empty(struct xfs_inode *ip, int whichfork);
 void	xfs_bmap_add_free(xfs_fsblock_t bno, xfs_filblks_t len,
 		struct xfs_bmap_free *flist, struct xfs_mount *mp);
 void	xfs_bmap_cancel(struct xfs_bmap_free *flist);
+int	xfs_bmap_finish(struct xfs_trans **tp, struct xfs_bmap_free *flist,
+			int *committed);
 void	xfs_bmap_compute_maxlevels(struct xfs_mount *mp, int whichfork);
 int	xfs_bmap_first_unused(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_extlen_t len, xfs_fileoff_t *unused, int whichfork);
diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
index 1fce0f3..736429a 100644
--- a/fs/xfs/xfs_bmap_util.h
+++ b/fs/xfs/xfs_bmap_util.h
@@ -28,8 +28,6 @@ struct xfs_mount;
 struct xfs_trans;
 struct xfs_bmalloca;
 
-int	xfs_bmap_finish(struct xfs_trans **tp, struct xfs_bmap_free *flist,
-			int *committed);
 int	xfs_bmap_rtalloc(struct xfs_bmalloca *ap);
 int	xfs_bmap_eof(struct xfs_inode *ip, xfs_fileoff_t endoff,
 		     int whichfork, int *eof);
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
