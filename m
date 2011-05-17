Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4HEdjrI188716 for <xfs@oss.sgi.com>; Tue, 17 May 2011 09:39:45 -0500
Received: from mail-qy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B7AAC45DE35
	for <xfs@oss.sgi.com>; Tue, 17 May 2011 07:39:44 -0700 (PDT)
Received: from mail-qy0-f181.google.com (mail-qy0-f181.google.com
	[209.85.216.181]) by cuda.sgi.com with ESMTP id
	oX2553EgKBgG3weP for <xfs@oss.sgi.com>;
	Tue, 17 May 2011 07:39:44 -0700 (PDT)
Received: by qyg14 with SMTP id 14so372391qyg.5
	for <xfs@oss.sgi.com>; Tue, 17 May 2011 07:39:44 -0700 (PDT)
From: Peter Watkins <treestem@gmail.com>
Subject: [PATCH] xfs: Fix inode buffer deadlock during memory reclaim
Date: Tue, 17 May 2011 10:39:35 -0400
Message-Id: <1305643175-8673-1-git-send-email-treestem@gmail.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Peter Watkins <treestem@gmail.com>

During reclaim under clear_inode, one thread holds the iprune_mutex while
trying to get an inode buffer lock. The other thread has the inode buffer
lock while trying to get the iprune_mutex lock.

Avoid reclaim recursing into the file system by using KM_NOFS in
xfs_trans_alloc.

Signed-off-by: Peter Watkins <treestem@gmail.com>
---
 fs/xfs/xfs_trans.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 7692279..f26f6d8 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -578,7 +578,7 @@ xfs_trans_alloc(
 	uint		type)
 {
 	xfs_wait_for_freeze(mp, SB_FREEZE_TRANS);
-	return _xfs_trans_alloc(mp, type, KM_SLEEP);
+	return _xfs_trans_alloc(mp, type, KM_SLEEP|KM_NOFS);
 }
 
 xfs_trans_t *
-- 
1.7.0.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
