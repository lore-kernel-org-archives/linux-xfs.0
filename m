Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6B2FC7F6C
	for <xfs@oss.sgi.com>; Wed, 15 Jul 2015 04:03:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 44575304032
	for <xfs@oss.sgi.com>; Wed, 15 Jul 2015 02:03:25 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id a2BpQCORjIA6q2kx (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 15 Jul 2015 02:03:06 -0700 (PDT)
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 7AD6DAAC1
	for <xfs@oss.sgi.com>; Wed, 15 Jul 2015 09:03:05 +0000 (UTC)
From: Jan Kara <jack@suse.com>
Subject: [PATCH] xfs: Remove duplicate jumps to the same label
Date: Wed, 15 Jul 2015 11:02:55 +0200
Message-Id: <1436950975-5004-1-git-send-email-jack@suse.com>
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
Cc: Jan Kara <jack@suse.com>

xfs_create() and xfs_create_tmpfile() have useless jumps to identical
labels. Simplify them.

Signed-off-by: Jan Kara <jack@suse.com>
---
 fs/xfs/xfs_inode.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 3da9f4da4f3d..d22a984d8470 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1175,11 +1175,8 @@ xfs_create(
 	 */
 	error = xfs_dir_ialloc(&tp, dp, mode, is_dir ? 2 : 1, rdev,
 			       prid, resblks > 0, &ip, &committed);
-	if (error) {
-		if (error == -ENOSPC)
-			goto out_trans_cancel;
+	if (error)
 		goto out_trans_cancel;
-	}
 
 	/*
 	 * Now we join the directory inode to the transaction.  We do not do it
@@ -1318,11 +1315,8 @@ xfs_create_tmpfile(
 
 	error = xfs_dir_ialloc(&tp, dp, mode, 1, 0,
 				prid, resblks > 0, &ip, NULL);
-	if (error) {
-		if (error == -ENOSPC)
-			goto out_trans_cancel;
+	if (error)
 		goto out_trans_cancel;
-	}
 
 	if (mp->m_flags & XFS_MOUNT_WSYNC)
 		xfs_trans_set_sync(tp);
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
