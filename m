Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q16Cj2nD132521 for <xfs@oss.sgi.com>; Mon, 6 Feb 2012 06:45:02 -0600
From: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Subject: [PATCH -v2 2/3] xfs: make inode quota check more general
Date: Mon, 06 Feb 2012 21:50:30 +0900
Message-ID: <20120206125030.12624.95365.stgit@ltc219.sdl.hitachi.co.jp>
In-Reply-To: <20120206124951.12624.88233.stgit@ltc219.sdl.hitachi.co.jp>
References: <20120206124951.12624.88233.stgit@ltc219.sdl.hitachi.co.jp>
MIME-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Ben Myers <bpm@sgi.com>, Alex Elder <aelder@sgi.com>, Christoph Hellwig <hch@lst.de>
Cc: Alex Elder <elder@kernel.org>, Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, xfs-masters@oss.sgi.com, yrl.pp-manager.tt@hitachi.com

The xfs checks quota when reserving disk blocks and inodes. In the block
reservation, it checks if the total number of blocks including current
usage and new reservation exceed quota. In the inode reservation,
it checks using the total number of inodes including only current usage
without new reservation. However, this inode quota check works well
since the caller of xfs_trans_dquot() always sets the argument of the
number of new inode reservation to 1 or 0 and inode is reserved one by
one in current xfs.

To make it more general, this patch changes it to the same way as the
block quota check.

Signed-off-by: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: Ben Myers <bpm@sgi.com>
Cc: Alex Elder <elder@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
---

 fs/xfs/xfs_trans_dquot.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 8525553..c4ba366 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -677,11 +677,13 @@ xfs_trans_dqresv(
 			if (!softlimit)
 				softlimit = q->qi_isoftlimit;
 
-			if (hardlimit > 0ULL && count >= hardlimit) {
+			if (hardlimit > 0ULL &&
+			    hardlimit < ninos + count) {
 				xfs_quota_warn(mp, dqp, QUOTA_NL_IHARDWARN);
 				goto error_return;
 			}
-			if (softlimit > 0ULL && count >= softlimit) {
+			if (softlimit > 0ULL &&
+			    softlimit < ninos + count) {
 				if  ((timer != 0 && get_seconds() > timer) ||
 				     (warns != 0 && warns >= warnlimit)) {
 					xfs_quota_warn(mp, dqp,

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
