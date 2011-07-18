Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6I44rdm079192 for <xfs@oss.sgi.com>; Sun, 17 Jul 2011 23:04:54 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1FA3FECD23D
	for <xfs@oss.sgi.com>; Sun, 17 Jul 2011 21:04:52 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	9dZ8lIAeQ9VpGC8V for <xfs@oss.sgi.com>;
	Sun, 17 Jul 2011 21:04:52 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/2] xfs: fix splice/direct-IO deadlock
Date: Mon, 18 Jul 2011 14:04:44 +1000
Message-Id: <1310961884-11634-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1310961884-11634-1-git-send-email-david@fromorbit.com>
References: <1310961884-11634-1-git-send-email-david@fromorbit.com>
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
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

lockdep reports splice vs direct-io write lock inversions due to
generic_file_splice_write() taking the inode->i_mutex inside
XFS_IOLOCK_EXCL context. These lock contexts are inverted, hence can
deadlock.  Use generic_file_splice_write_unlocked() because the
i_mutex does not need to be held over the operations that are done
in the XFS splice write path.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_file.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_file.c b/fs/xfs/linux-2.6/xfs_file.c
index f51a384..1e641e6 100644
--- a/fs/xfs/linux-2.6/xfs_file.c
+++ b/fs/xfs/linux-2.6/xfs_file.c
@@ -463,7 +463,8 @@ xfs_file_splice_write(
 
 	trace_xfs_file_splice_write(ip, count, *ppos, ioflags);
 
-	ret = generic_file_splice_write(pipe, outfilp, ppos, count, flags);
+	ret = generic_file_splice_write_unlocked(pipe, outfilp, ppos,
+						count, flags);
 
 	xfs_aio_write_isize_update(inode, ppos, ret);
 	xfs_aio_write_newsize_update(ip);
-- 
1.7.5.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
