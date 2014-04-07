Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 60A177FA2
	for <xfs@oss.sgi.com>; Mon,  7 Apr 2014 14:59:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 39D068F8059
	for <xfs@oss.sgi.com>; Mon,  7 Apr 2014 12:59:09 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 4zDJkkz7wpKjho72 for <xfs@oss.sgi.com>;
	Mon, 07 Apr 2014 12:59:08 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 04/19] xfs: remove unused mp arg from xfs_bmap_forkoff_reset()
Date: Mon,  7 Apr 2014 14:58:51 -0500
Message-Id: <1396900746-22201-5-git-send-email-sandeen@redhat.com>
In-Reply-To: <1396900746-22201-1-git-send-email-sandeen@redhat.com>
References: <1396900746-22201-1-git-send-email-sandeen@redhat.com>
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

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/xfs_bmap.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index eeb673b..03b6ff2 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -233,7 +233,6 @@ xfs_default_attroffset(
  */
 STATIC void
 xfs_bmap_forkoff_reset(
-	xfs_mount_t	*mp,
 	xfs_inode_t	*ip,
 	int		whichfork)
 {
@@ -905,7 +904,7 @@ xfs_bmap_local_to_extents_empty(
 	ASSERT(ifp->if_bytes == 0);
 	ASSERT(XFS_IFORK_NEXTENTS(ip, whichfork) == 0);
 
-	xfs_bmap_forkoff_reset(ip->i_mount, ip, whichfork);
+	xfs_bmap_forkoff_reset(ip, whichfork);
 	ifp->if_flags &= ~XFS_IFINLINE;
 	ifp->if_flags |= XFS_IFEXTENTS;
 	XFS_IFORK_FMT_SET(ip, whichfork, XFS_DINODE_FMT_EXTENTS);
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
