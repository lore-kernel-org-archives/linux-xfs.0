Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 99B007F37
	for <xfs@oss.sgi.com>; Sun, 31 May 2015 06:35:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8CC308F8037
	for <xfs@oss.sgi.com>; Sun, 31 May 2015 04:35:34 -0700 (PDT)
Received: from zenon.ap.intdata.com (zenon.ap.interactivedata.com
	[203.21.67.34]) by cuda.sgi.com with ESMTP id fyhCYZqLtoaFCWxX
	for <xfs@oss.sgi.com>; Sun, 31 May 2015 04:35:32 -0700 (PDT)
From: Nan Jia <jiananmail@gmail.com>
Subject: [PATCH 2/2] fs: xfs: xfs_trans_dquot: Add missing space according to
	coding style
Date: Sun, 31 May 2015 21:35:28 +1000
Message-Id: <1433072128-2274-1-git-send-email-jiananmail@gmail.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com
Cc: jiananmail@gmail.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Fixed two missing space

Signed-off-by Nan Jia <jiananmail@gmail.com>
---
 fs/xfs/xfs_trans_dquot.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 76a16df..2b68870 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -90,7 +90,7 @@ xfs_trans_dup_dqinfo(
 	xfs_trans_t	*ntp)
 {
 	xfs_dqtrx_t	*oq, *nq;
-	int		i,j;
+	int		i, j;
 	xfs_dqtrx_t	*oqa, *nqa;
 
 	if (!otp->t_dqinfo)
@@ -102,7 +102,7 @@ xfs_trans_dup_dqinfo(
 	 * Because the quota blk reservation is carried forward,
 	 * it is also necessary to carry forward the DQ_DIRTY flag.
 	 */
-	if(otp->t_flags & XFS_TRANS_DQ_DIRTY)
+	if (otp->t_flags & XFS_TRANS_DQ_DIRTY)
 		ntp->t_flags |= XFS_TRANS_DQ_DIRTY;
 
 	for (j = 0; j < XFS_QM_TRANS_DQTYPES; j++) {
-- 
2.4.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
