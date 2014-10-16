Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 711967F3F
	for <xfs@oss.sgi.com>; Thu, 16 Oct 2014 08:39:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 501108F8035
	for <xfs@oss.sgi.com>; Thu, 16 Oct 2014 06:39:37 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id YyxhvXxbAb3J5dJ3 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 16 Oct 2014 06:39:36 -0700 (PDT)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs: fix error handling in xfs_qm_log_quotaoff()
Date: Thu, 16 Oct 2014 09:39:33 -0400
Message-Id: <1413466773-56087-1-git-send-email-bfoster@redhat.com>
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
To: xfs@oss.sgi.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>

The error handling in xfs_qm_log_quotaoff() has a couple problems. If
xfs_trans_commit() fails, we fall through to the error block and call
xfs_trans_cancel(). This is incorrect on commit failure. If
xfs_trans_reserve() fails, we jump to the error block, cancel the tp and
restore the superblock qflags to oldsbqflag. However, oldsbqflag has
been initialized to zero and not yet updated from the original flags so
we set the flags to zero.

Fix up the error handling in xfs_qm_log_quotaoff() to not restore flags
if they haven't been modified and not cancel the tp on commit failure.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_qm_syscalls.c | 35 ++++++++++++++++++++---------------
 1 file changed, 20 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 80f2d77..f2d454e 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -784,13 +784,17 @@ xfs_qm_log_quotaoff(
 {
 	xfs_trans_t	       *tp;
 	int			error;
-	xfs_qoff_logitem_t     *qoffi=NULL;
-	uint			oldsbqflag=0;
+	xfs_qoff_logitem_t     *qoffi;
+	uint			oldsbqflag;
+
+	*qoffstartp = NULL;
 
 	tp = xfs_trans_alloc(mp, XFS_TRANS_QM_QUOTAOFF);
 	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_qm_quotaoff, 0, 0);
-	if (error)
-		goto error0;
+	if (error) {
+		xfs_trans_cancel(tp, 0);
+		return error;
+	}
 
 	qoffi = xfs_trans_get_qoff_item(tp, NULL, flags & XFS_ALL_QUOTA_ACCT);
 	xfs_trans_log_quotaoff_item(tp, qoffi);
@@ -809,19 +813,20 @@ xfs_qm_log_quotaoff(
 	 */
 	xfs_trans_set_sync(tp);
 	error = xfs_trans_commit(tp, 0);
+	if (error)
+		goto error_flags;
 
-error0:
-	if (error) {
-		xfs_trans_cancel(tp, 0);
-		/*
-		 * No one else is modifying sb_qflags, so this is OK.
-		 * We still hold the quotaofflock.
-		 */
-		spin_lock(&mp->m_sb_lock);
-		mp->m_sb.sb_qflags = oldsbqflag;
-		spin_unlock(&mp->m_sb_lock);
-	}
 	*qoffstartp = qoffi;
+	return 0;
+
+error_flags:
+	/*
+	 * No one else is modifying sb_qflags, so this is OK.
+	 * We still hold the quotaofflock.
+	 */
+	spin_lock(&mp->m_sb_lock);
+	mp->m_sb.sb_qflags = oldsbqflag;
+	spin_unlock(&mp->m_sb_lock);
 	return error;
 }
 
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
