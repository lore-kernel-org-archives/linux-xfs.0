Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q16CiS1m132445 for <xfs@oss.sgi.com>; Mon, 6 Feb 2012 06:44:28 -0600
From: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Subject: [PATCH -v2 1/3] xfs: change available ranges of softlimit and
	hardlimit in quota check
Date: Mon, 06 Feb 2012 21:50:07 +0900
Message-ID: <20120206125007.12624.58454.stgit@ltc219.sdl.hitachi.co.jp>
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

In general, quota allows us to use disk blocks and inodes up to each
limit, that is, they are available if they don't exceed their limitations.
Current xfs sets their available ranges to lower than them except disk
inode quota check. So, this patch changes the ranges to not beyond them.

Signed-off-by: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: Ben Myers <bpm@sgi.com>
Cc: Alex Elder <elder@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
---

 fs/xfs/xfs_dquot.c       |   24 ++++++++++++------------
 fs/xfs/xfs_log_recover.c |    6 +++---
 fs/xfs/xfs_qm_syscalls.c |    4 ++--
 fs/xfs/xfs_trans_dquot.c |    4 ++--
 4 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index b4ff40b..307e4a3 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -215,10 +215,10 @@ xfs_qm_adjust_dqtimers(
 
 	if (!d->d_btimer) {
 		if ((d->d_blk_softlimit &&
-		     (be64_to_cpu(d->d_bcount) >=
+		     (be64_to_cpu(d->d_bcount) >
 		      be64_to_cpu(d->d_blk_softlimit))) ||
 		    (d->d_blk_hardlimit &&
-		     (be64_to_cpu(d->d_bcount) >=
+		     (be64_to_cpu(d->d_bcount) >
 		      be64_to_cpu(d->d_blk_hardlimit)))) {
 			d->d_btimer = cpu_to_be32(get_seconds() +
 					mp->m_quotainfo->qi_btimelimit);
@@ -227,10 +227,10 @@ xfs_qm_adjust_dqtimers(
 		}
 	} else {
 		if ((!d->d_blk_softlimit ||
-		     (be64_to_cpu(d->d_bcount) <
+		     (be64_to_cpu(d->d_bcount) <=
 		      be64_to_cpu(d->d_blk_softlimit))) &&
 		    (!d->d_blk_hardlimit ||
-		    (be64_to_cpu(d->d_bcount) <
+		    (be64_to_cpu(d->d_bcount) <=
 		     be64_to_cpu(d->d_blk_hardlimit)))) {
 			d->d_btimer = 0;
 		}
@@ -238,10 +238,10 @@ xfs_qm_adjust_dqtimers(
 
 	if (!d->d_itimer) {
 		if ((d->d_ino_softlimit &&
-		     (be64_to_cpu(d->d_icount) >=
+		     (be64_to_cpu(d->d_icount) >
 		      be64_to_cpu(d->d_ino_softlimit))) ||
 		    (d->d_ino_hardlimit &&
-		     (be64_to_cpu(d->d_icount) >=
+		     (be64_to_cpu(d->d_icount) >
 		      be64_to_cpu(d->d_ino_hardlimit)))) {
 			d->d_itimer = cpu_to_be32(get_seconds() +
 					mp->m_quotainfo->qi_itimelimit);
@@ -250,10 +250,10 @@ xfs_qm_adjust_dqtimers(
 		}
 	} else {
 		if ((!d->d_ino_softlimit ||
-		     (be64_to_cpu(d->d_icount) <
+		     (be64_to_cpu(d->d_icount) <=
 		      be64_to_cpu(d->d_ino_softlimit)))  &&
 		    (!d->d_ino_hardlimit ||
-		     (be64_to_cpu(d->d_icount) <
+		     (be64_to_cpu(d->d_icount) <=
 		      be64_to_cpu(d->d_ino_hardlimit)))) {
 			d->d_itimer = 0;
 		}
@@ -261,10 +261,10 @@ xfs_qm_adjust_dqtimers(
 
 	if (!d->d_rtbtimer) {
 		if ((d->d_rtb_softlimit &&
-		     (be64_to_cpu(d->d_rtbcount) >=
+		     (be64_to_cpu(d->d_rtbcount) >
 		      be64_to_cpu(d->d_rtb_softlimit))) ||
 		    (d->d_rtb_hardlimit &&
-		     (be64_to_cpu(d->d_rtbcount) >=
+		     (be64_to_cpu(d->d_rtbcount) >
 		      be64_to_cpu(d->d_rtb_hardlimit)))) {
 			d->d_rtbtimer = cpu_to_be32(get_seconds() +
 					mp->m_quotainfo->qi_rtbtimelimit);
@@ -273,10 +273,10 @@ xfs_qm_adjust_dqtimers(
 		}
 	} else {
 		if ((!d->d_rtb_softlimit ||
-		     (be64_to_cpu(d->d_rtbcount) <
+		     (be64_to_cpu(d->d_rtbcount) <=
 		      be64_to_cpu(d->d_rtb_softlimit))) &&
 		    (!d->d_rtb_hardlimit ||
-		     (be64_to_cpu(d->d_rtbcount) <
+		     (be64_to_cpu(d->d_rtbcount) <=
 		      be64_to_cpu(d->d_rtb_hardlimit)))) {
 			d->d_rtbtimer = 0;
 		}
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 541a508..d3ce9ad 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1981,7 +1981,7 @@ xfs_qm_dqcheck(
 
 	if (!errs && ddq->d_id) {
 		if (ddq->d_blk_softlimit &&
-		    be64_to_cpu(ddq->d_bcount) >=
+		    be64_to_cpu(ddq->d_bcount) >
 				be64_to_cpu(ddq->d_blk_softlimit)) {
 			if (!ddq->d_btimer) {
 				if (flags & XFS_QMOPT_DOWARN)
@@ -1992,7 +1992,7 @@ xfs_qm_dqcheck(
 			}
 		}
 		if (ddq->d_ino_softlimit &&
-		    be64_to_cpu(ddq->d_icount) >=
+		    be64_to_cpu(ddq->d_icount) >
 				be64_to_cpu(ddq->d_ino_softlimit)) {
 			if (!ddq->d_itimer) {
 				if (flags & XFS_QMOPT_DOWARN)
@@ -2003,7 +2003,7 @@ xfs_qm_dqcheck(
 			}
 		}
 		if (ddq->d_rtb_softlimit &&
-		    be64_to_cpu(ddq->d_rtbcount) >=
+		    be64_to_cpu(ddq->d_rtbcount) >
 				be64_to_cpu(ddq->d_rtb_softlimit)) {
 			if (!ddq->d_rtbtimer) {
 				if (flags & XFS_QMOPT_DOWARN)
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index eafbcff..711a86e 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -813,11 +813,11 @@ xfs_qm_export_dquot(
 	     (XFS_IS_OQUOTA_ENFORCED(mp) &&
 			(dst->d_flags & (FS_PROJ_QUOTA | FS_GROUP_QUOTA)))) &&
 	    dst->d_id != 0) {
-		if (((int) dst->d_bcount >= (int) dst->d_blk_softlimit) &&
+		if (((int) dst->d_bcount > (int) dst->d_blk_softlimit) &&
 		    (dst->d_blk_softlimit > 0)) {
 			ASSERT(dst->d_btimer != 0);
 		}
-		if (((int) dst->d_icount >= (int) dst->d_ino_softlimit) &&
+		if (((int) dst->d_icount > (int) dst->d_ino_softlimit) &&
 		    (dst->d_ino_softlimit > 0)) {
 			ASSERT(dst->d_itimer != 0);
 		}
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 4d00ee6..8525553 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -649,12 +649,12 @@ xfs_trans_dqresv(
 			 * nblks.
 			 */
 			if (hardlimit > 0ULL &&
-			    hardlimit <= nblks + *resbcountp) {
+			    hardlimit < nblks + *resbcountp) {
 				xfs_quota_warn(mp, dqp, QUOTA_NL_BHARDWARN);
 				goto error_return;
 			}
 			if (softlimit > 0ULL &&
-			    softlimit <= nblks + *resbcountp) {
+			    softlimit < nblks + *resbcountp) {
 				if ((timer != 0 && get_seconds() > timer) ||
 				    (warns != 0 && warns >= warnlimit)) {
 					xfs_quota_warn(mp, dqp,

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
