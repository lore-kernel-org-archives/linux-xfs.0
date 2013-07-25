Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9C69C7F37
	for <xfs@oss.sgi.com>; Thu, 25 Jul 2013 03:23:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 37A70AC002
	for <xfs@oss.sgi.com>; Thu, 25 Jul 2013 01:23:11 -0700 (PDT)
Received: from e8.ny.us.ibm.com (e8.ny.us.ibm.com [32.97.182.138]) by
	cuda.sgi.com with ESMTP id bVTiYFKngqgOXWfH (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 25 Jul 2013 01:23:09 -0700 (PDT)
Received: from /spool/local
	by e8.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <zwu.kernel@gmail.com>;
	Thu, 25 Jul 2013 09:23:08 +0100
Received: from d01relay05.pok.ibm.com (d01relay05.pok.ibm.com [9.56.227.237])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 04F1A6E803C
	for <xfs@oss.sgi.com>; Thu, 25 Jul 2013 04:23:01 -0400 (EDT)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r6P8N5ub132158 for <xfs@oss.sgi.com>; Thu, 25 Jul 2013 04:23:05 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	r6P8N5Uw007665 for <xfs@oss.sgi.com>; Thu, 25 Jul 2013 04:23:05 -0400
From: zwu.kernel@gmail.com
Subject: [PATCH] xfs: introduce object readahead to log recovery
Date: Thu, 25 Jul 2013 16:23:39 +0800
Message-Id: <1374740619-29797-1-git-send-email-zwu.kernel@gmail.com>
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

  In dirty log case as below:
    data device: 0xfd10
    log device: 0xfd10 daddr: 20480032 length: 20480

    log tail: 7941 head: 11077 state: <DIRTY>

This dirty ratio is about 15%. I am trying to do tests in larger scale
and dirtier filesystem environment.

Log recovery time stat:

            w/o this patch        w/ this patch
  real         0m1.051s             0m0.965s
  sys          0m0.033s             0m0.035s

  iowait       0m1.018s             0m0.930s

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/xfs/xfs_log_recover.c | 131 +++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 127 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 6fcc910a..f07e5e0 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3107,6 +3107,121 @@ xlog_recover_free_trans(
 	kmem_free(trans);
 }
 
+STATIC void
+xlog_recover_buffer_ra_pass2(
+	struct xlog                     *log,
+	struct xlog_recover_item        *item)
+{
+	xfs_buf_log_format_t	*buf_f = item->ri_buf[0].i_addr;
+	xfs_mount_t		*mp = log->l_mp;
+
+	if (xlog_check_buffer_cancelled(log, buf_f->blf_blkno,
+			buf_f->blf_len, buf_f->blf_flags)) {
+		return;
+	}
+
+	xfs_buf_readahead(mp->m_ddev_targp, buf_f->blf_blkno,
+			buf_f->blf_len, NULL);
+}
+
+STATIC void
+xlog_recover_inode_ra_pass2(
+	struct xlog                     *log,
+	struct xlog_recover_item        *item)
+{
+	xfs_inode_log_format_t	*in_f;
+	xfs_mount_t		*mp = log->l_mp;
+	int			error;
+	int			need_free = 0;
+
+	if (item->ri_buf[0].i_len == sizeof(xfs_inode_log_format_t)) {
+		in_f = item->ri_buf[0].i_addr;
+	} else {
+		in_f = kmem_alloc(sizeof(xfs_inode_log_format_t), KM_SLEEP);
+		need_free = 1;
+		error = xfs_inode_item_format_convert(&item->ri_buf[0], in_f);
+		if (error)
+			goto error;
+	}
+
+	if (xlog_check_buffer_cancelled(log, in_f->ilf_blkno,
+					in_f->ilf_len, 0)) {
+		goto error;
+	}
+
+	xfs_buf_readahead(mp->m_ddev_targp, in_f->ilf_blkno,
+			in_f->ilf_len, &xfs_inode_buf_ops);
+
+error:
+	if (need_free)
+		kmem_free(in_f);
+}
+
+STATIC void
+xlog_recover_dquot_ra_pass2(
+	struct xlog			*log,
+	struct xlog_recover_item	*item)
+{
+	xfs_mount_t		*mp = log->l_mp;
+	xfs_buf_t		*bp;
+	struct xfs_disk_dquot	*recddq;
+	int			error;
+	xfs_dq_logformat_t	*dq_f;
+	uint			type;
+
+
+	if (mp->m_qflags == 0)
+		return;
+
+	recddq = item->ri_buf[1].i_addr;
+	if (recddq == NULL)
+		return;
+	if (item->ri_buf[1].i_len < sizeof(xfs_disk_dquot_t))
+		return;
+
+	type = recddq->d_flags & (XFS_DQ_USER | XFS_DQ_PROJ | XFS_DQ_GROUP);
+	ASSERT(type);
+	if (log->l_quotaoffs_flag & type)
+		return;
+
+	dq_f = item->ri_buf[0].i_addr;
+	ASSERT(dq_f);
+	error = xfs_qm_dqcheck(mp, recddq, dq_f->qlf_id, 0, XFS_QMOPT_DOWARN,
+			   "xlog_recover_dquot_ra_pass2 (log copy)");
+	if (error)
+		return;
+	ASSERT(dq_f->qlf_len == 1);
+
+	error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp, dq_f->qlf_blkno,
+				   XFS_FSB_TO_BB(mp, dq_f->qlf_len), 0, &bp,
+				   NULL);
+	if (!error)
+		xfs_buf_relse(bp);
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
@@ -3140,10 +3255,14 @@ xlog_recover_commit_pass2(
 	struct xlog			*log,
 	struct xlog_recover		*trans,
 	struct list_head		*buffer_list,
-	struct xlog_recover_item	*item)
+	struct xlog_recover_item	*item,
+	struct xlog_recover_item	*next_item)
 {
 	trace_xfs_log_recover_item_recover(log, trans, item, XLOG_RECOVER_PASS2);
 
+	if (next_item)
+		xlog_recover_ra_pass2(log, next_item);
+
 	switch (ITEM_TYPE(item)) {
 	case XFS_LI_BUF:
 		return xlog_recover_buffer_pass2(log, buffer_list, item);
@@ -3181,7 +3300,7 @@ xlog_recover_commit_trans(
 	int			pass)
 {
 	int			error = 0, error2;
-	xlog_recover_item_t	*item;
+	xlog_recover_item_t	*item, *next_item, *temp_item;
 	LIST_HEAD		(buffer_list);
 
 	hlist_del(&trans->r_list);
@@ -3190,14 +3309,18 @@ xlog_recover_commit_trans(
 	if (error)
 		return error;
 
-	list_for_each_entry(item, &trans->r_itemq, ri_list) {
+	list_for_each_entry_safe(item, temp_item, &trans->r_itemq, ri_list) {
 		switch (pass) {
 		case XLOG_RECOVER_PASS1:
 			error = xlog_recover_commit_pass1(log, trans, item);
 			break;
 		case XLOG_RECOVER_PASS2:
+			if (&temp_item->ri_list != &trans->r_itemq)
+				next_item = temp_item;
+			else
+				next_item = NULL;
 			error = xlog_recover_commit_pass2(log, trans,
-							  &buffer_list, item);
+					  &buffer_list, item, next_item);
 			break;
 		default:
 			ASSERT(0);
-- 
1.7.11.7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
