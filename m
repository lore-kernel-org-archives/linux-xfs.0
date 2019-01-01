Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:43438 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728189AbfAACUT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Dec 2018 21:20:19 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x012EBvI018775
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:20:18 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2pp0btp79n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Jan 2019 02:20:18 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x012KCxj026015
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:20:12 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x012KCis001780
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:20:12 GMT
Subject: [PATCH 11/22] xfs: refactor special inode roll out of xfs_dir_ialloc
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 31 Dec 2018 18:20:10 -0800
Message-ID: <154630921076.18437.14193766050551378677.stgit@magnolia>
In-Reply-To: <154630914104.18437.15354380637179830566.stgit@magnolia>
References: <154630914104.18437.15354380637179830566.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

In xfs_dir_ialloc, we roll the transaction if we had to allocate a new
inode chunk and before we actually initialize the inode.  In the kernel
this requires us to detach the transaction's quota charge information
from the ichunk allocation transaction and to attach it the ialloc
transaction because we don't charge quota for inode chunks.  This
doesn't exist in the userspace side of things, so pop it out into a
separately called function.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_inode_util.h |    6 ++++
 fs/xfs/xfs_inode.c             |   66 ++++++++++++++++++++++++----------------
 2 files changed, 46 insertions(+), 26 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_util.h b/fs/xfs/libxfs/xfs_inode_util.h
index 5a1d98d1546d..ee274d74b8d4 100644
--- a/fs/xfs/libxfs/xfs_inode_util.h
+++ b/fs/xfs/libxfs/xfs_inode_util.h
@@ -82,6 +82,12 @@ struct xfs_ialloc_ops {
 
 	/* Do any final setup needed before we return the inode. */
 	void (*setup)(struct xfs_inode *ip);
+
+	/*
+	 * Roll the transaction between allocating a new ichunk and
+	 * initializing a new inode core.
+	 */
+	int (*ichunk_roll)(struct xfs_trans **tpp);
 };
 
 /* The libxfs client must provide this symbol. */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index e6fda8777fe1..82de92bc84b9 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -647,10 +647,49 @@ xfs_ialloc_platform_init(
 	VFS_I(ip)->i_ctime = tv;
 }
 
+/*
+ * Roll the transaction after allocating an inode chunk and before allocating
+ * the actual inode, moving the quota charge information to the second
+ * transaction.
+ */
+static int
+xfs_dir_ialloc_roll(
+	struct xfs_trans	**tpp)
+{
+	struct xfs_dquot_acct	*dqinfo = NULL;
+	unsigned int		tflags = 0;
+	int			error;
+
+	/*
+	 * We want the quota changes to be associated with the next
+	 * transaction, NOT this one. So, detach the dqinfo from this
+	 * and attach it to the next transaction.
+	 */
+	if ((*tpp)->t_dqinfo) {
+		dqinfo = (*tpp)->t_dqinfo;
+		(*tpp)->t_dqinfo = NULL;
+		tflags = (*tpp)->t_flags & XFS_TRANS_DQ_DIRTY;
+		(*tpp)->t_flags &= ~(XFS_TRANS_DQ_DIRTY);
+	}
+
+	error = xfs_trans_roll(tpp);
+
+	/*
+	 * Re-attach the quota info that we detached from prev trx.
+	 */
+	if (dqinfo) {
+		(*tpp)->t_dqinfo = dqinfo;
+		(*tpp)->t_flags |= tflags;
+	}
+
+	return error;
+}
+
 const struct xfs_ialloc_ops xfs_default_ialloc_ops = {
 	.iget		= xfs_ialloc_iget,
 	.platform_init	= xfs_ialloc_platform_init,
 	.setup		= xfs_setup_inode,
+	.ichunk_roll	= xfs_dir_ialloc_roll,
 };
 
 /*
@@ -672,8 +711,6 @@ xfs_dir_ialloc(
 	struct xfs_trans		*tp;
 	struct xfs_inode		*ip;
 	struct xfs_buf			*ialloc_context = NULL;
-	void				*dqinfo;
-	uint				tflags;
 	int				code;
 
 	tp = *tpp;
@@ -726,30 +763,7 @@ xfs_dir_ialloc(
 		 */
 		xfs_trans_bhold(tp, ialloc_context);
 
-		/*
-		 * We want the quota changes to be associated with the next
-		 * transaction, NOT this one. So, detach the dqinfo from this
-		 * and attach it to the next transaction.
-		 */
-		dqinfo = NULL;
-		tflags = 0;
-		if (tp->t_dqinfo) {
-			dqinfo = (void *)tp->t_dqinfo;
-			tp->t_dqinfo = NULL;
-			tflags = tp->t_flags & XFS_TRANS_DQ_DIRTY;
-			tp->t_flags &= ~(XFS_TRANS_DQ_DIRTY);
-		}
-
-		code = xfs_trans_roll(&tp);
-
-		/*
-		 * Re-attach the quota info that we detached from prev trx.
-		 */
-		if (dqinfo) {
-			tp->t_dqinfo = dqinfo;
-			tp->t_flags |= tflags;
-		}
-
+		code = args->ops->ichunk_roll(&tp);
 		if (code) {
 			xfs_buf_relse(ialloc_context);
 			*tpp = tp;
