Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6U8EI2F008060 for <xfs@oss.sgi.com>; Mon, 30 Jul 2012 03:14:18 -0500
From: Tomas Racek <tracek@redhat.com>
Subject: [PATCH 1/1] xfs: check for possible overflow in xfs_ioc_trim
Date: Mon, 30 Jul 2012 10:13:44 +0200
Message-Id: <1343636024-20123-1-git-send-email-tracek@redhat.com>
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

If range.start argument was between ULLONG_MAX - BBSIZE and ULLONG_MAX,
BTOBB macro resulted in overflow which caused start to be set to 0.
Now, invalid argument error is returned instead.

Signed-off-by: Tomas Racek <tracek@redhat.com>
---
 fs/xfs/xfs_discard.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index f9c3fe3..0ef7dd4 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -179,6 +179,10 @@ xfs_ioc_trim(
 	 * used by the fstrim application.  In the end it really doesn't
 	 * matter as trimming blocks is an advisory interface.
 	 */
+
+	if (range.start > ULLONG_MAX - BBSIZE)
+		return -XFS_ERROR(EINVAL);
+
 	start = BTOBB(range.start);
 	end = start + BTOBBT(range.len) - 1;
 	minlen = BTOBB(max_t(u64, granularity, range.minlen));
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
