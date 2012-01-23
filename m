Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0N3duBl048264 for <xfs@oss.sgi.com>; Sun, 22 Jan 2012 21:39:56 -0600
From: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Subject: [PATCH 3/3] xfs: cleanup quota check on disk blocks and inodes
	reservations
Date: Mon, 23 Jan 2012 12:45:43 +0900
Message-ID: <20120123034543.3339.56848.stgit@ltc219.sdl.hitachi.co.jp>
In-Reply-To: <20120123034513.3339.97432.stgit@ltc219.sdl.hitachi.co.jp>
References: <20120123034513.3339.97432.stgit@ltc219.sdl.hitachi.co.jp>
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
reservations.

Signed-off-by: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: Ben Myers <bpm@sgi.com>
Cc: Alex Elder <elder@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
---

 fs/xfs/xfs_trans_dquot.c |   17 +++++++----------
 1 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index c4ba366..5e6cd1c 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -605,7 +605,7 @@ xfs_trans_dqresv(
 	time_t		timer;
 	xfs_qwarncnt_t	warns;
 	xfs_qwarncnt_t	warnlimit;
-	xfs_qcnt_t	count;
+	xfs_qcnt_t	tcount;
 	xfs_qcnt_t	*resbcountp;
 	xfs_quotainfo_t	*q = mp->m_quotainfo;
 
@@ -648,13 +648,12 @@ xfs_trans_dqresv(
 			 * hardlimit or exceed the timelimit if we allocate
 			 * nblks.
 			 */
-			if (hardlimit > 0ULL &&
-			    hardlimit < nblks + *resbcountp) {
+			tcount = *resbcountp + nblks;
+			if (hardlimit > 0ULL && tcount > hardlimit) {
 				xfs_quota_warn(mp, dqp, QUOTA_NL_BHARDWARN);
 				goto error_return;
 			}
-			if (softlimit > 0ULL &&
-			    softlimit < nblks + *resbcountp) {
+			if (softlimit > 0ULL && tcount > softlimit) {
 				if ((timer != 0 && get_seconds() > timer) ||
 				    (warns != 0 && warns >= warnlimit)) {
 					xfs_quota_warn(mp, dqp,
@@ -666,7 +665,7 @@ xfs_trans_dqresv(
 			}
 		}
 		if (ninos > 0) {
-			count = be64_to_cpu(dqp->q_core.d_icount);
+			tcount = be64_to_cpu(dqp->q_core.d_icount) + ninos;
 			timer = be32_to_cpu(dqp->q_core.d_itimer);
 			warns = be16_to_cpu(dqp->q_core.d_iwarns);
 			warnlimit = dqp->q_mount->m_quotainfo->qi_iwarnlimit;
@@ -677,13 +676,11 @@ xfs_trans_dqresv(
 			if (!softlimit)
 				softlimit = q->qi_isoftlimit;
 
-			if (hardlimit > 0ULL &&
-			    hardlimit < ninos + count) {
+			if (hardlimit > 0ULL && tcount > hardlimit) {
 				xfs_quota_warn(mp, dqp, QUOTA_NL_IHARDWARN);
 				goto error_return;
 			}
-			if (softlimit > 0ULL &&
-			    softlimit < ninos + count) {
+			if (softlimit > 0ULL && tcount > softlimit) {
 				if  ((timer != 0 && get_seconds() > timer) ||
 				     (warns != 0 && warns >= warnlimit)) {
 					xfs_quota_warn(mp, dqp,

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
