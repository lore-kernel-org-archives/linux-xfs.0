Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67310C2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:13:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3BD17206E4
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:13:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PN6HkANa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727180AbgAABNt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:13:49 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:55578 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727134AbgAABNt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:13:49 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011Aw6w110406
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:13:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=owhaVuaze46+FNmSNNqyTBAmMQngCM5lw8qC8XUsSvA=;
 b=PN6HkANa1bNSpT4fqEeLaUZPLnJUCMq0Ryd2zYeIcK5eSTqhyFaglf1w8LwKlmhnFEey
 UjYv41sbsFcWku2ISCTK6AGxatfHoHgJPTA53D/O4JUnlYuc/B4Y12VmP6/QugpJ4nbf
 ziyjYAHbA0S0DfRG04sna0LOPuYYus6w3yNQ2ig3WGk5gW/TXsqME5iZz6IcXZcxAg6p
 Zroy7EDhG2JZGHZ0s+7otw89DwuyQsIhPje71AXpe9zoQ1dqDoGAhtO/oAtHc4WwGUOe
 Ox2VfH5rVAZBy5QP4pd6AhXsJiDgJkRqI6Kk7jJlnBq1TAx4Mo/k7prm70QrrcpUTimW SQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2x5xftk2jh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:13:47 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118vqV172055
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:13:47 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2x8gj918sf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:13:47 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0011Dljc000633
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:13:47 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:13:46 -0800
Subject: [PATCH 11/21] xfs: refactor special inode roll out of xfs_dir_ialloc
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:13:44 -0800
Message-ID: <157784122440.1365473.15001800973344418611.stgit@magnolia>
In-Reply-To: <157784115560.1365473.15056496428451670757.stgit@magnolia>
References: <157784115560.1365473.15056496428451670757.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010009
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

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
 fs/xfs/libxfs/xfs_inode_util.h |    1 +
 fs/xfs/xfs_inode.c             |   65 ++++++++++++++++++++++++----------------
 2 files changed, 40 insertions(+), 26 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_util.h b/fs/xfs/libxfs/xfs_inode_util.h
index b54495182932..2ee6e5bfb80a 100644
--- a/fs/xfs/libxfs/xfs_inode_util.h
+++ b/fs/xfs/libxfs/xfs_inode_util.h
@@ -39,6 +39,7 @@ void xfs_setup_inode(struct xfs_inode *ip);
 void xfs_trans_ichgtime(struct xfs_trans *tp, struct xfs_inode *ip, int flags);
 int xfs_ialloc_iget(struct xfs_trans *tp, xfs_ino_t ino,
 		    struct xfs_inode **ipp);
+int xfs_dir_ialloc_roll(struct xfs_trans **tpp);
 
 int xfs_ialloc(struct xfs_trans *tp, const struct xfs_ialloc_args *args,
 	       struct xfs_buf **ialloc_context, struct xfs_inode **ipp);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index eef85fbb6102..0d1cfc85a268 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -632,6 +632,44 @@ xfs_ialloc_iget(
 			ipp);
 }
 
+/*
+ * Roll the transaction after allocating an inode chunk and before allocating
+ * the actual inode, moving the quota charge information to the second
+ * transaction.
+ */
+int
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
 /*
  * Allocates a new inode from disk and return a pointer to the
  * incore copy. This routine will internally commit the current
@@ -651,8 +689,6 @@ xfs_dir_ialloc(
 	struct xfs_trans		*tp;
 	struct xfs_inode		*ip;
 	struct xfs_buf			*ialloc_context = NULL;
-	void				*dqinfo;
-	uint				tflags;
 	int				code;
 
 	tp = *tpp;
@@ -705,30 +741,7 @@ xfs_dir_ialloc(
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
+		code = xfs_dir_ialloc_roll(&tp);
 		if (code) {
 			xfs_buf_relse(ialloc_context);
 			*tpp = tp;

