Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7E8eXOs155241 for <xfs@oss.sgi.com>; Tue, 14 Aug 2012 03:40:33 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ft6OPQjGgnhu1uvy for
	<xfs@oss.sgi.com>; Tue, 14 Aug 2012 01:40:32 -0700 (PDT)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q7E8eWmJ001979
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 14 Aug 2012 04:40:32 -0400
From: Tomas Racek <tracek@redhat.com>
Subject: [PATCH v4] xfs: check for possible overflow in xfs_ioc_trim
Date: Tue, 14 Aug 2012 10:35:04 +0200
Message-Id: <1344933304-16014-1-git-send-email-tracek@redhat.com>
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
Cc: lczerner@redhat.com, Tomas Racek <tracek@redhat.com>

If range.start or range.minlen is bigger than filesystem size, return
invalid value error. This fixes possible overflow in BTOBB macro when
passed value was nearly ULLONG_MAX.

Signed-off-by: Tomas Racek <tracek@redhat.com>
---
 fs/xfs/xfs_discard.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index f9c3fe3..69cf4fc 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -179,12 +179,14 @@ xfs_ioc_trim(
 	 * used by the fstrim application.  In the end it really doesn't
 	 * matter as trimming blocks is an advisory interface.
 	 */
+	if (range.start >= XFS_FSB_TO_B(mp, mp->m_sb.sb_dblocks) ||
+	    range.minlen > XFS_FSB_TO_B(mp, XFS_ALLOC_AG_MAX_USABLE(mp)))
+		return -XFS_ERROR(EINVAL);
+
 	start = BTOBB(range.start);
 	end = start + BTOBBT(range.len) - 1;
 	minlen = BTOBB(max_t(u64, granularity, range.minlen));
 
-	if (XFS_BB_TO_FSB(mp, start) >= mp->m_sb.sb_dblocks)
-		return -XFS_ERROR(EINVAL);
 	if (end > XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks) - 1)
 		end = XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks)- 1;
 
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
