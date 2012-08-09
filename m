Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7998i94144204 for <xfs@oss.sgi.com>; Thu, 9 Aug 2012 04:08:44 -0500
From: Tomas Racek <tracek@redhat.com>
Subject: [PATCH v3] xfs: check for possible overflow in xfs_ioc_trim
Date: Thu,  9 Aug 2012 11:07:09 +0200
Message-Id: <1344503229-13022-1-git-send-email-tracek@redhat.com>
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
To: linux-xfs@vger.kernel.org
Cc: Alex Elder <elder@kernel.org>, open list <linux-kernel@vger.kernel.org>, Tomas Racek <tracek@redhat.com>, "supporter:XFS FILESYSTEM" <xfs@oss.sgi.com>, Ben Myers <bpm@sgi.com>, lczerner@redhat.com

If range.start or range.minlen is bigger than filesystem size, return
invalid value error. This fixes possible overflow in BTOBB macro when
passed value was nearly ULLONG_MAX.

Signed-off-by: Tomas Racek <tracek@redhat.com>
---
 fs/xfs/xfs_discard.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index f9c3fe3..4e07a56 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -179,12 +179,14 @@ xfs_ioc_trim(
 	 * used by the fstrim application.  In the end it really doesn't
 	 * matter as trimming blocks is an advisory interface.
 	 */
+	if (range.start >= XFS_FSB_TO_B(mp, mp->m_sb.sb_dblocks) ||
+	    range.minlen > XFS_FSB_TO_B(mp, mp->m_sb.sb_dblocks))
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
