Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8BF6D7F5E
	for <xfs@oss.sgi.com>; Wed,  2 Jul 2014 23:57:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 899B4304064
	for <xfs@oss.sgi.com>; Wed,  2 Jul 2014 21:57:43 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id KqwqqP4Rfk8kAdHf for <xfs@oss.sgi.com>;
	Wed, 02 Jul 2014 21:57:41 -0700 (PDT)
Message-ID: <53B4E2C5.1000303@sandeen.net>
Date: Wed, 02 Jul 2014 23:57:41 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 2/2] xfs: tidy up xfs_set_inode32
References: <53B4E1EE.40702@redhat.com>
In-Reply-To: <53B4E1EE.40702@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

xfs_set_inode32() caught my eye because it had
weird spacing around the "-1's".  In cleaning that
up, I realized that the assignment in the declaration
of "ino" is never used; it's rewritten before it gets
read.

Drop the ino initializer from its declaration since it's
not used, and move the agino initialization into the body
of the function, mostly so that we can have pretty
whitespace and not exceed 80 columns.  :)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index e71c0f8..39c9315 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -609,8 +609,8 @@ xfs_set_inode32(struct xfs_mount *mp, xfs_agnumber_t agcount)
 	xfs_agnumber_t	maxagi = 0;
 	xfs_sb_t	*sbp = &mp->m_sb;
 	xfs_agnumber_t	max_metadata;
-	xfs_agino_t	agino =	XFS_OFFBNO_TO_AGINO(mp, sbp->sb_agblocks -1, 0);
-	xfs_ino_t	ino = XFS_AGINO_TO_INO(mp, sbp->sb_agcount -1, agino);
+	xfs_agino_t	agino;
+	xfs_ino_t	ino;
 	xfs_perag_t	*pag;
 
 	/* Calculate how much should be reserved for inodes to meet
@@ -628,6 +628,8 @@ xfs_set_inode32(struct xfs_mount *mp, xfs_agnumber_t agcount)
 		max_metadata = agcount;
 	}
 
+	agino =	XFS_OFFBNO_TO_AGINO(mp, sbp->sb_agblocks - 1, 0);
+
 	for (index = 0; index < agcount; index++) {
 		ino = XFS_AGINO_TO_INO(mp, index, agino);
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
