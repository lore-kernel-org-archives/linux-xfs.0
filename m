Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6B1E67F8E
	for <xfs@oss.sgi.com>; Thu, 23 Jul 2015 15:15:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 34B72304051
	for <xfs@oss.sgi.com>; Thu, 23 Jul 2015 13:14:59 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id rQLWRyWvTK5R7mDW for <xfs@oss.sgi.com>;
	Thu, 23 Jul 2015 13:14:58 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 8BA4663C6061
	for <xfs@oss.sgi.com>; Thu, 23 Jul 2015 15:14:57 -0500 (CDT)
Message-ID: <55B14B40.5030209@sandeen.net>
Date: Thu, 23 Jul 2015 15:14:56 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfs_repair: set args.geo in dir2_kill_block
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
To: xfs-oss <xfs@oss.sgi.com>

This path in xfs_repair:

dir2_kill_block
	libxfs_da_shrink_inode
		xfs_dir2_shrink_inode
			xfs_dir2_db_to_da

segfaults, because dir2_kill_block() does not initialize
args.geo, and a null geometry winds up in xfs_dir2_db_to_da(),
which dereferences it.

Fix that.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/repair/phase6.c b/repair/phase6.c
index de445c6..0c952ed 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -1438,6 +1438,7 @@ dir2_kill_block(
 	args.firstblock = &firstblock;
 	args.flist = &flist;
 	args.whichfork = XFS_DATA_FORK;
+	args.geo = mp->m_dir_geo;
 	if (da_bno >= mp->m_dir_geo->leafblk && da_bno < mp->m_dir_geo->freeblk)
 		error = -libxfs_da_shrink_inode(&args, da_bno, bp);
 	else

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
