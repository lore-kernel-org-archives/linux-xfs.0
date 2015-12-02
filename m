Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C029529E0E
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 05:26:54 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8115D3040F1
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 03:26:54 -0800 (PST)
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25]) by
	cuda.sgi.com with ESMTP id rV9fxCJlL9GcTmTe (version=TLSv1
	cipher=DHE-RSA-AES128-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 02 Dec 2015 03:26:52 -0800 (PST)
Received: from epcpsbgr1.samsung.com
	(u141.gpu120.samsung.co.kr [203.254.230.141])
	by mailout2.samsung.com (Oracle Communications Messaging Server
	7.0.5.31.0 64bit (built May  5 2014))
	with ESMTP id <0NYQ02W6ZAEWL3D0@mailout2.samsung.com> for
	xfs@oss.sgi.com; Wed, 02 Dec 2015 20:25:44 +0900 (KST)
From: Vivek Trivedi <t.vivek@samsung.com>
Subject: [PATCH 11/11] xfsprogs: xfs_repair: fix possible null pointer
	dereference in mark_standalone_inodes
Date: Wed, 02 Dec 2015 16:49:27 +0530
Message-id: <1449055167-19936-12-git-send-email-t.vivek@samsung.com>
In-reply-to: <1449055167-19936-1-git-send-email-t.vivek@samsung.com>
References: <1449055167-19936-1-git-send-email-t.vivek@samsung.com>
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
Cc: Vivek Trivedi <t.vivek@samsung.com>, a.sahrawat@samsung.com, pankaj.m@samsung.com

Fix possible null pointer dereference in mark_standalone_inodes by
rearranging and adding ASSERT for null irec.
Reported by coverity.

Signed-off-by: Vivek Trivedi <t.vivek@samsung.com>
---
 repair/phase6.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/repair/phase6.c b/repair/phase6.c
index e41bf20..1e5fc46 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -3088,11 +3088,11 @@ mark_standalone_inodes(xfs_mount_t *mp)
 	irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp, mp->m_sb.sb_rsumino),
 			XFS_INO_TO_AGINO(mp, mp->m_sb.sb_rsumino));
 
+	ASSERT(irec != NULL);
+
 	offset = XFS_INO_TO_AGINO(mp, mp->m_sb.sb_rsumino) -
 			irec->ino_startnum;
 
-	ASSERT(irec != NULL);
-
 	add_inode_reached(irec, offset);
 
 	if (fs_quotas)  {
@@ -3101,6 +3101,7 @@ mark_standalone_inodes(xfs_mount_t *mp)
 			irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp,
 						mp->m_sb.sb_uquotino),
 				XFS_INO_TO_AGINO(mp, mp->m_sb.sb_uquotino));
+			ASSERT(irec != NULL);
 			offset = XFS_INO_TO_AGINO(mp, mp->m_sb.sb_uquotino)
 					- irec->ino_startnum;
 			add_inode_reached(irec, offset);
@@ -3110,6 +3111,7 @@ mark_standalone_inodes(xfs_mount_t *mp)
 			irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp,
 						mp->m_sb.sb_gquotino),
 				XFS_INO_TO_AGINO(mp, mp->m_sb.sb_gquotino));
+			ASSERT(irec != NULL);
 			offset = XFS_INO_TO_AGINO(mp, mp->m_sb.sb_gquotino)
 					- irec->ino_startnum;
 			add_inode_reached(irec, offset);
@@ -3119,6 +3121,7 @@ mark_standalone_inodes(xfs_mount_t *mp)
 			irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp,
 						mp->m_sb.sb_pquotino),
 				XFS_INO_TO_AGINO(mp, mp->m_sb.sb_pquotino));
+			ASSERT(irec != NULL);
 			offset = XFS_INO_TO_AGINO(mp, mp->m_sb.sb_pquotino)
 					- irec->ino_startnum;
 			add_inode_reached(irec, offset);
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
