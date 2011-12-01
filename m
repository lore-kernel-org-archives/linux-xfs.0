Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB1NRxbI033812 for <xfs@oss.sgi.com>; Thu, 1 Dec 2011 17:27:59 -0600
From: Ben Myers <bpm@sgi.com>
Subject: [PATCH 6/6] xfs: use doalloc flag in xfs_qm_dqattach_one()
Date: Thu,  1 Dec 2011 17:27:44 -0600
Message-Id: <1322782064-1723-7-git-send-email-bpm@sgi.com>
In-Reply-To: <1322782064-1723-1-git-send-email-bpm@sgi.com>
References: <1322782064-1723-1-git-send-email-bpm@sgi.com>
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
To: stable@vger.kernel.org, greg@kroah.com
Cc: Christoph Hellwig <hch@infradead.org>, bpm@sgi.com, Alex Elder <aelder@sgi.com>, Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>, xfs@oss.sgi.com

From: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>

commit db3e74b582915d66e10b0c73a62763418f54c340 upstream.

The doalloc arg in xfs_qm_dqattach_one() is a flag that indicates
whether a new area to handle quota information will be allocated
if needed. Originally, it was passed to xfs_qm_dqget(), but has
been removed by the following commit (probably by mistake):

	commit 8e9b6e7fa4544ea8a0e030c8987b918509c8ff47
	Author: Christoph Hellwig <hch@lst.de>
	Date:   Sun Feb 8 21:51:42 2009 +0100

	xfs: remove the unused XFS_QMOPT_DQLOCK flag

As the result, xfs_qm_dqget() called from xfs_qm_dqattach_one()
never allocates the new area even if it is needed.

This patch gives the doalloc arg to xfs_qm_dqget() in
xfs_qm_dqattach_one() to fix this problem.

Signed-off-by: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: Alex Elder <aelder@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/xfs_qm.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 9a0aa76..95ba6dc 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -674,7 +674,8 @@ xfs_qm_dqattach_one(
 	 * disk and we didn't ask it to allocate;
 	 * ESRCH if quotas got turned off suddenly.
 	 */
-	error = xfs_qm_dqget(ip->i_mount, ip, id, type, XFS_QMOPT_DOWARN, &dqp);
+	error = xfs_qm_dqget(ip->i_mount, ip, id, type,
+			     doalloc | XFS_QMOPT_DOWARN, &dqp);
 	if (error)
 		return error;
 
-- 
1.7.8.rc4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
