Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1DD0F7FB5
	for <xfs@oss.sgi.com>; Wed, 14 Aug 2013 02:18:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id ACC2FAC003
	for <xfs@oss.sgi.com>; Wed, 14 Aug 2013 00:18:20 -0700 (PDT)
Received: from e35.co.us.ibm.com (e35.co.us.ibm.com [32.97.110.153]) by
	cuda.sgi.com with ESMTP id K6vEEJYrbC2uS5TB (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 14 Aug 2013 00:18:19 -0700 (PDT)
Received: from /spool/local
	by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <zwu.kernel@gmail.com>;
	Wed, 14 Aug 2013 01:18:18 -0600
Received: from d03relay05.boulder.ibm.com (d03relay05.boulder.ibm.com
	[9.17.195.107])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id DB5231FF001B
	for <xfs@oss.sgi.com>; Wed, 14 Aug 2013 01:12:45 -0600 (MDT)
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay05.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r7E7IBiP135108 for <xfs@oss.sgi.com>; Wed, 14 Aug 2013 01:18:11 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id r7E7IAmT009133
	for <xfs@oss.sgi.com>; Wed, 14 Aug 2013 01:18:11 -0600
From: zwu.kernel@gmail.com
Subject: [PATCH v4] xfs: introduce object readahead to log recovery
Date: Wed, 14 Aug 2013 15:16:03 +0800
Message-Id: <1376464563-27821-1-git-send-email-zwu.kernel@gmail.com>
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
Cc: linux-fsdevel@vger.kernel.org, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

  It can take a long time to run log recovery operation because it is
single threaded and is bound by read latency. We can find that it took
most of the time to wait for the read IO to occur, so if one object
readahead is introduced to log recovery, it will obviously reduce the
log recovery time.

Log recovery time stat:

          w/o this patch        w/ this patch

real:        0m15.023s             0m7.802s
user:        0m0.001s              0m0.001s
sys:         0m0.246s              0m0.107s

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/xfs/xfs_log_recover.c | 159 ++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 152 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 7681b19..5f48a92 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3116,6 +3116,106 @@ xlog_recover_free_trans(
 	kmem_free(trans);
 }
 
+STATIC void
+xlog_recover_buffer_ra_pass2(
+	struct xlog                     *log,
+	struct xlog_recover_item        *item)
+{
+	struct xfs_buf_log_format	*buf_f = item->ri_buf[0].i_addr;
+	struct xfs_mount		*mp = log->l_mp;
+
+	if (xlog_check_buffer_cancelled(log, buf_f->blf_blkno,
+			buf_f->blf_len, buf_f->blf_flags)) {
+		return;
+	}
+
+	xfs_buf_readahead(mp->m_ddev_targp, buf_f->blf_blkno,
+				buf_f->blf_len, NULL);
+}
+
+STATIC void
+xlog_recover_inode_ra_pass2(
+	struct xlog                     *log,
+	struct xlog_recover_item        *item)
+{
+	struct xfs_inode_log_format	ilf_buf;
+	struct xfs_inode_log_format	*ilfp;
+	struct xfs_mount		*mp = log->l_mp;
+	int			error;
+
+	if (item->ri_buf[0].i_len == sizeof(struct xfs_inode_log_format)) {
+		ilfp = item->ri_buf[0].i_addr;
+	} else {
+		ilfp = &ilf_buf;
+		memset(ilfp, 0, sizeof(*ilfp));
+		error = xfs_inode_item_format_convert(&item->ri_buf[0], ilfp);
+		if (error)
+			return;
+	}
+
+	if (xlog_check_buffer_cancelled(log, ilfp->ilf_blkno, ilfp->ilf_len, 0))
+		return;
+
+	xfs_buf_readahead(mp->m_ddev_targp, ilfp->ilf_blkno,
+				ilfp->ilf_len, &xfs_inode_buf_ops);
+}
+
+STATIC void
+xlog_recover_dquot_ra_pass2(
+	struct xlog			*log,
+	struct xlog_recover_item	*item)
+{
+	struct xfs_mount	*mp = log->l_mp;
+	struct xfs_disk_dquot	*recddq;
+	struct xfs_dq_logformat	*dq_f;
+	uint			type;
+
+
+	if (mp->m_qflags == 0)
+		return;
+
+	recddq = item->ri_buf[1].i_addr;
+	if (recddq == NULL)
+		return;
+	if (item->ri_buf[1].i_len < sizeof(struct xfs_disk_dquot))
+		return;
+
+	type = recddq->d_flags & (XFS_DQ_USER | XFS_DQ_PROJ | XFS_DQ_GROUP);
+	ASSERT(type);
+	if (log->l_quotaoffs_flag & type)
+		return;
+
+	dq_f = item->ri_buf[0].i_addr;
+	ASSERT(dq_f);
+	ASSERT(dq_f->qlf_len == 1);
+
+	xfs_buf_readahead(mp->m_ddev_targp, dq_f->qlf_blkno,
+				dq_f->qlf_len, NULL);
+}
+
+STATIC void
+xlog_recover_ra_pass2(
+	struct xlog			*log,
+	struct xlog_recover_item	*item)
+{
+	switch (ITEM_TYPE(item)) {
+	case XFS_LI_BUF:
+		xlog_recover_buffer_ra_pass2(log, item);
+		break;
+	case XFS_LI_INODE:
+		xlog_recover_inode_ra_pass2(log, item);
+		break;
+	case XFS_LI_DQUOT:
+		xlog_recover_dquot_ra_pass2(log, item);
+		break;
+	case XFS_LI_EFI:
+	case XFS_LI_EFD:
+	case XFS_LI_QUOTAOFF:
+	default:
+		break;
+	}
+}
+
 STATIC int
 xlog_recover_commit_pass1(
 	struct xlog			*log,
@@ -3177,6 +3277,26 @@ xlog_recover_commit_pass2(
 	}
 }
 
+STATIC int
+xlog_recover_items_pass2(
+	struct xlog                     *log,
+	struct xlog_recover             *trans,
+	struct list_head                *buffer_list,
+	struct list_head                *item_list)
+{
+	struct xlog_recover_item	*item;
+	int				error = 0;
+
+	list_for_each_entry(item, item_list, ri_list) {
+		error = xlog_recover_commit_pass2(log, trans,
+					  buffer_list, item);
+		if (error)
+			return error;
+	}
+
+	return error;
+}
+
 /*
  * Perform the transaction.
  *
@@ -3189,9 +3309,16 @@ xlog_recover_commit_trans(
 	struct xlog_recover	*trans,
 	int			pass)
 {
-	int			error = 0, error2;
-	xlog_recover_item_t	*item;
-	LIST_HEAD		(buffer_list);
+	int				error = 0;
+	int				error2;
+	int				items_queued = 0;
+	struct xlog_recover_item	*item;
+	struct xlog_recover_item	*next;
+	LIST_HEAD			(buffer_list);
+	LIST_HEAD			(ra_list);
+	LIST_HEAD			(done_list);
+
+	#define XLOG_RECOVER_COMMIT_QUEUE_MAX 100
 
 	hlist_del(&trans->r_list);
 
@@ -3199,14 +3326,22 @@ xlog_recover_commit_trans(
 	if (error)
 		return error;
 
-	list_for_each_entry(item, &trans->r_itemq, ri_list) {
+	list_for_each_entry_safe(item, next, &trans->r_itemq, ri_list) {
 		switch (pass) {
 		case XLOG_RECOVER_PASS1:
 			error = xlog_recover_commit_pass1(log, trans, item);
 			break;
 		case XLOG_RECOVER_PASS2:
-			error = xlog_recover_commit_pass2(log, trans,
-							  &buffer_list, item);
+			xlog_recover_ra_pass2(log, item);
+			list_move_tail(&item->ri_list, &ra_list);
+			items_queued++;
+			if (items_queued >= XLOG_RECOVER_COMMIT_QUEUE_MAX) {
+				error = xlog_recover_items_pass2(log, trans,
+						&buffer_list, &ra_list);
+				list_splice_tail_init(&ra_list, &done_list);
+				items_queued = 0;
+			}
+
 			break;
 		default:
 			ASSERT(0);
@@ -3216,9 +3351,19 @@ xlog_recover_commit_trans(
 			goto out;
 	}
 
+out:
+	if (!list_empty(&ra_list)) {
+		if (!error)
+			error = xlog_recover_items_pass2(log, trans,
+					&buffer_list, &ra_list);
+		list_splice_tail_init(&ra_list, &done_list);
+	}
+
+	if (!list_empty(&done_list))
+		list_splice_init(&done_list, &trans->r_itemq);
+
 	xlog_recover_free_trans(trans);
 
-out:
 	error2 = xfs_buf_delwri_submit(&buffer_list);
 	return error ? error : error2;
 }
-- 
1.7.11.7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
