Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DD9277F4E
	for <xfs@oss.sgi.com>; Mon, 20 Oct 2014 08:57:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C9DE5304048
	for <xfs@oss.sgi.com>; Mon, 20 Oct 2014 06:57:35 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id qhTcvOsuhTQDRUb2 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 20 Oct 2014 06:57:34 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s9KDvXtn030026
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Mon, 20 Oct 2014 09:57:33 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s9KDvX3k006326
	for <xfs@oss.sgi.com>; Mon, 20 Oct 2014 09:57:33 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2] xfs: fix error handling in xfs_qm_log_quotaoff()
Date: Mon, 20 Oct 2014 09:57:32 -0400
Message-Id: <1413813452-43059-1-git-send-email-bfoster@redhat.com>
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

The error handling in xfs_qm_log_quotaoff() has a couple problems. If
xfs_trans_commit() fails, we fall through to the error block and call
xfs_trans_cancel(). This is incorrect on commit failure. If
xfs_trans_reserve() fails, we jump to the error block, cancel the tp and
restore the superblock qflags to oldsbqflag. However, oldsbqflag has
been initialized to zero and not yet updated from the original flags so
we set the flags to zero.

Fix up the error handling in xfs_qm_log_quotaoff() to not restore flags
if they haven't been modified and not cancel the tp on commit failure.
Remove the flag restore code altogether because commit error is the only
failure condition and we don't know whether the transaction made it to
disk.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Brian Foster <bfoster@redhat.com>
---

v2:
- Don't restore sb_qflags on tp commit failure.
v1: http://oss.sgi.com/archives/xfs/2014-10/msg00314.html

 fs/xfs/xfs_qm_syscalls.c | 26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 80f2d77..d1e0ab7 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -784,19 +784,21 @@ xfs_qm_log_quotaoff(
 {
 	xfs_trans_t	       *tp;
 	int			error;
-	xfs_qoff_logitem_t     *qoffi=NULL;
-	uint			oldsbqflag=0;
+	xfs_qoff_logitem_t     *qoffi;
+
+	*qoffstartp = NULL;
 
 	tp = xfs_trans_alloc(mp, XFS_TRANS_QM_QUOTAOFF);
 	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_qm_quotaoff, 0, 0);
-	if (error)
-		goto error0;
+	if (error) {
+		xfs_trans_cancel(tp, 0);
+		goto out;
+	}
 
 	qoffi = xfs_trans_get_qoff_item(tp, NULL, flags & XFS_ALL_QUOTA_ACCT);
 	xfs_trans_log_quotaoff_item(tp, qoffi);
 
 	spin_lock(&mp->m_sb_lock);
-	oldsbqflag = mp->m_sb.sb_qflags;
 	mp->m_sb.sb_qflags = (mp->m_qflags & ~(flags)) & XFS_MOUNT_QUOTA_ALL;
 	spin_unlock(&mp->m_sb_lock);
 
@@ -809,19 +811,11 @@ xfs_qm_log_quotaoff(
 	 */
 	xfs_trans_set_sync(tp);
 	error = xfs_trans_commit(tp, 0);
+	if (error)
+		goto out;
 
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
+out:
 	return error;
 }
 
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
