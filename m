Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2FBWeBi006954 for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 06:33:00 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C67E719A010
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 04:32:17 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail05.adl2.internode.on.net
	[203.16.214.69]) by cuda.sgi.com with ESMTP id C4jM8ex01nOuT7xC
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 04:32:17 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/5] [XFS] Flush delayed allcoation blocks on ENOSPC in create
Date: Sun, 15 Mar 2009 22:31:46 +1100
Message-Id: <1237116707-25793-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1237116707-25793-1-git-send-email-david@fromorbit.com>
References: <1237116707-25793-1-git-send-email-david@fromorbit.com>
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
Cc: mpatocka@redhat.com

If we are creating lots of small files, we can fail to get
a reservation for inode create earlier than we should due to
EOF preallocation done during delayed allocation reservation.
Hence on the first reservation ENOSPC failure flush all the
delayed allocation blocks out of the system and retry.

This fixes the last commonly triggered spurious ENOSPC issue
that has been reported.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_vnodeops.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index 59de049..faf671b 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -1457,6 +1457,13 @@ xfs_create(
 	error = xfs_trans_reserve(tp, resblks, log_res, 0,
 			XFS_TRANS_PERM_LOG_RES, log_count);
 	if (error == ENOSPC) {
+		/* flush outstanding delalloc blocks and retry */
+		xfs_flush_inodes(dp);
+		error = xfs_trans_reserve(tp, resblks, XFS_CREATE_LOG_RES(mp), 0,
+			XFS_TRANS_PERM_LOG_RES, XFS_CREATE_LOG_COUNT);
+	}
+	if (error == ENOSPC) {
+		/* No space at all so try a "no-allocation" reservation */
 		resblks = 0;
 		error = xfs_trans_reserve(tp, 0, log_res, 0,
 				XFS_TRANS_PERM_LOG_RES, log_count);
-- 
1.6.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
