Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q16CjS2S132576 for <xfs@oss.sgi.com>; Mon, 6 Feb 2012 06:45:28 -0600
From: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Subject: [PATCH -v2 3/3] xfs: cleanup quota check on disk blocks and inodes
	reservations
Date: Mon, 06 Feb 2012 21:51:05 +0900
Message-ID: <20120206125105.12624.93123.stgit@ltc219.sdl.hitachi.co.jp>
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

This patch is a cleanup of quota check on disk blocks and inodes
reservations, and changes it as follows.

(1) add a total_count variable to store the total number of
    current usages and new reservations for disk blocks and inodes,
    respectively.

(2) make it more readable to check if the local variables softlimit
    and hardlimit are positive. It has been changed as follows.
	    if (softlimit > 0ULL) -> if (softlimit)
	    if (hardlimit > 0ULL) -> if (hardlimit)
    This is because they are defined as xfs_qcnt_t which is unsigned.

Signed-off-by: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: Ben Myers <bpm@sgi.com>
Cc: Alex Elder <elder@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
---

 fs/xfs/xfs_trans_dquot.c |   17 +++++++----------
 1 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index c4ba366..877fe63 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -605,7 +605,7 @@ xfs_trans_dqresv(
 	time_t		timer;
 	xfs_qwarncnt_t	warns;
 	xfs_qwarncnt_t	warnlimit;
-	xfs_qcnt_t	count;
+	xfs_qcnt_t	total_count;
 	xfs_qcnt_t	*resbcountp;
 	xfs_quotainfo_t	*q = mp->m_quotainfo;
 
@@ -648,13 +648,12 @@ xfs_trans_dqresv(
 			 * hardlimit or exceed the timelimit if we allocate
 			 * nblks.
 			 */
-			if (hardlimit > 0ULL &&
-			    hardlimit < nblks + *resbcountp) {
+			total_count = *resbcountp + nblks;
+			if (hardlimit && total_count > hardlimit) {
 				xfs_quota_warn(mp, dqp, QUOTA_NL_BHARDWARN);
 				goto error_return;
 			}
-			if (softlimit > 0ULL &&
-			    softlimit < nblks + *resbcountp) {
+			if (softlimit && total_count > softlimit) {
 				if ((timer != 0 && get_seconds() > timer) ||
 				    (warns != 0 && warns >= warnlimit)) {
 					xfs_quota_warn(mp, dqp,
@@ -666,7 +665,7 @@ xfs_trans_dqresv(
 			}
 		}
 		if (ninos > 0) {
-			count = be64_to_cpu(dqp->q_core.d_icount);
+			total_count = be64_to_cpu(dqp->q_core.d_icount) + ninos;
 			timer = be32_to_cpu(dqp->q_core.d_itimer);
 			warns = be16_to_cpu(dqp->q_core.d_iwarns);
 			warnlimit = dqp->q_mount->m_quotainfo->qi_iwarnlimit;
@@ -677,13 +676,11 @@ xfs_trans_dqresv(
 			if (!softlimit)
 				softlimit = q->qi_isoftlimit;
 
-			if (hardlimit > 0ULL &&
-			    hardlimit < ninos + count) {
+			if (hardlimit && total_count > hardlimit) {
 				xfs_quota_warn(mp, dqp, QUOTA_NL_IHARDWARN);
 				goto error_return;
 			}
-			if (softlimit > 0ULL &&
-			    softlimit < ninos + count) {
+			if (softlimit && total_count > softlimit) {
 				if  ((timer != 0 && get_seconds() > timer) ||
 				     (warns != 0 && warns >= warnlimit)) {
 					xfs_quota_warn(mp, dqp,

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
