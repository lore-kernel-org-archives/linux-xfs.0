Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q99CEQgB028312 for <xfs@oss.sgi.com>; Tue, 9 Oct 2012 07:14:27 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id cB6DzOa0bN75koEh for
	<xfs@oss.sgi.com>; Tue, 09 Oct 2012 05:15:57 -0700 (PDT)
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] xfs: avoid underflow in xfs_ioc_trim()
Date: Tue,  9 Oct 2012 14:15:45 +0200
Message-Id: <1349784945-28399-1-git-send-email-lczerner@redhat.com>
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
Cc: Lukas Czerner <lczerner@redhat.com>

Currently if len argument in xfs_ioc_trim() is smaller than one BB
(basic block) the 'end' variable underflow. Avoid that by bailing out if
len is smaller than BB.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/xfs/xfs_discard.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index 69cf4fc..54dc58a 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -183,8 +183,12 @@ xfs_ioc_trim(
 	    range.minlen > XFS_FSB_TO_B(mp, XFS_ALLOC_AG_MAX_USABLE(mp)))
 		return -XFS_ERROR(EINVAL);
 
+	end = BTOBBT(range.len);
+	if (0 == end)
+		goto out;
+
 	start = BTOBB(range.start);
-	end = start + BTOBBT(range.len) - 1;
+	end += start - 1;
 	minlen = BTOBB(max_t(u64, granularity, range.minlen));
 
 	if (end > XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks) - 1)
@@ -203,6 +207,7 @@ xfs_ioc_trim(
 	if (last_error)
 		return last_error;
 
+out:
 	range.len = XFS_FSB_TO_B(mp, blocks_trimmed);
 	if (copy_to_user(urange, &range, sizeof(range)))
 		return -XFS_ERROR(EFAULT);
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
