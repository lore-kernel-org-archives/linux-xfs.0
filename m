Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A82DC2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:13:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 430C6206E4
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:13:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IQjNZXFZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727156AbgAABNZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:13:25 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:54096 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727134AbgAABNZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:13:25 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00119gL2089391
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:13:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=5dIPIZ6WMrKTmurxAtWsxJ5V9Ga4EjDVhcJ9xDXa+sI=;
 b=IQjNZXFZ0GaOBbVqW68LhuFqBsjMQlaeEqIUvF3xl1BHmHgjFDcowfBSbqR/BXXORl37
 K1huNuuGRgIBsejumwSxa4zILTwCkiYrVJGCkm350SsZH+RiElsnAI6OAW21lnQjaMwQ
 UGJTsfRRYml5GRj2qGdNfPdIOFZJbkWYCVJRvtgjzvqvIZ5quha+WgCyy/4E1xWmVgSo
 j4awdSgap33REQ0ezAmkDFILMChVOqRl1/5IvtoZRMdX+Zyh3Sqo4A29vPg79QsgmnnX
 Rg4cHqY8isu2UISzz0Uq8ogg2G7ZkB8exU52Qicc5+j4bJZfWS+QDqTVZCF05e/jx2bF yQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2x5y0pjxy7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:13:23 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118vUe190348
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:13:23 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2x8bsrg2eb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:13:23 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0011DMLY007280
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:13:22 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:13:21 -0800
Subject: [PATCH 07/21] xfs: split inode allocation and initialization
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:13:19 -0800
Message-ID: <157784119957.1365473.9043368068627793648.stgit@magnolia>
In-Reply-To: <157784115560.1365473.15056496428451670757.stgit@magnolia>
References: <157784115560.1365473.15056496428451670757.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010009
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Split new inode allocation and initialization into separate helpers.
Eventually we'll supply a force-reinitialization function so that
xfs_repair can use libxfs to reset the root directory and friends.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_inode.c |  172 ++++++++++++++++++++++++++++------------------------
 1 file changed, 93 insertions(+), 79 deletions(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index f71ddcccd390..75a0a22c605d 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -618,91 +618,20 @@ xfs_lookup(
 }
 
 /*
- * Allocate an inode on disk and return a copy of its in-core version.
- * The in-core inode is locked exclusively.  Set mode, nlink, and rdev
- * appropriately within the inode.  The uid and gid for the inode are
- * set according to the contents of the given cred structure.
- *
- * Use xfs_dialloc() to allocate the on-disk inode. If xfs_dialloc()
- * has a free inode available, call xfs_iget() to obtain the in-core
- * version of the allocated inode.  Finally, fill in the inode and
- * log its initial contents.  In this case, ialloc_context would be
- * set to NULL.
- *
- * If xfs_dialloc() does not have an available inode, it will replenish
- * its supply by doing an allocation. Since we can only do one
- * allocation within a transaction without deadlocks, we must commit
- * the current transaction before returning the inode itself.
- * In this case, therefore, we will set ialloc_context and return.
- * The caller should then commit the current transaction, start a new
- * transaction, and call xfs_ialloc() again to actually get the inode.
- *
- * To ensure that some other process does not grab the inode that
- * was allocated during the first call to xfs_ialloc(), this routine
- * also returns the [locked] bp pointing to the head of the freelist
- * as ialloc_context.  The caller should hold this buffer across
- * the commit and pass it back into this routine on the second call.
- *
- * If we are allocating quota inodes, we do not have a parent inode
- * to attach to or associate with (i.e. pip == NULL) because they
- * are not linked into the directory structure - they are attached
- * directly to the superblock - and so have no parent.
+ * Initialize a newly allocated inode with the given arguments.  Heritable
+ * inode properties will be copied from the parent if one is supplied and the
+ * appropriate inode flags are set on the parent.
  */
-static int
-xfs_ialloc(
+STATIC void
+xfs_inode_init(
 	struct xfs_trans		*tp,
 	const struct xfs_ialloc_args	*args,
-	struct xfs_buf			**ialloc_context,
-	struct xfs_inode		**ipp)
+	struct xfs_inode		*ip)
 {
-	struct xfs_mount		*mp = tp->t_mountp;
 	struct xfs_inode		*pip = args->pip;
-	struct xfs_inode		*ip;
-	struct inode			*inode;
-	xfs_ino_t			ino;
-	uint				flags;
+	struct inode			*inode = VFS_I(ip);
 	int				times;
-	int				error;
-
-	/*
-	 * Call the space management code to pick
-	 * the on-disk inode to be allocated.
-	 */
-	error = xfs_dialloc(tp, pip ? pip->i_ino : 0, args->mode,
-			    ialloc_context, &ino);
-	if (error)
-		return error;
-	if (*ialloc_context || ino == NULLFSINO) {
-		*ipp = NULL;
-		return 0;
-	}
-	ASSERT(*ialloc_context == NULL);
-
-	/*
-	 * Protect against obviously corrupt allocation btree records. Later
-	 * xfs_iget checks will catch re-allocation of other active in-memory
-	 * and on-disk inodes. If we don't catch reallocating the parent inode
-	 * here we will deadlock in xfs_iget() so we have to do these checks
-	 * first.
-	 */
-	if ((pip && ino == pip->i_ino) || !xfs_verify_dir_ino(mp, ino)) {
-		xfs_alert(mp, "Allocated a known in-use inode 0x%llx!", ino);
-		xfs_agno_mark_sick(mp, XFS_INO_TO_AGNO(mp, ino),
-				XFS_SICK_AG_INOBT);
-		return -EFSCORRUPTED;
-	}
-
-	/*
-	 * Get the in-core inode with the lock held exclusively.
-	 * This is because we're setting fields here we need
-	 * to prevent others from looking at until we're done.
-	 */
-	error = xfs_iget(mp, tp, ino, XFS_IGET_CREATE,
-			 XFS_ILOCK_EXCL, &ip);
-	if (error)
-		return error;
-	ASSERT(ip != NULL);
-	inode = VFS_I(ip);
+	uint				flags;
 
 	/*
 	 * We always convert v1 inodes to v2 now - we only support filesystems
@@ -843,7 +772,92 @@ xfs_ialloc(
 
 	/* now that we have an i_mode we can setup the inode structure */
 	xfs_setup_inode(ip);
+}
+
+/*
+ * Allocate an inode on disk and return a copy of its in-core version.
+ * The in-core inode is locked exclusively.  Set mode, nlink, and rdev
+ * appropriately within the inode.  The uid and gid for the inode are
+ * set according to the contents of the given cred structure.
+ *
+ * Use xfs_dialloc() to allocate the on-disk inode. If xfs_dialloc()
+ * has a free inode available, call xfs_iget() to obtain the in-core
+ * version of the allocated inode.  Finally, fill in the inode and
+ * log its initial contents.  In this case, ialloc_context would be
+ * set to NULL.
+ *
+ * If xfs_dialloc() does not have an available inode, it will replenish
+ * its supply by doing an allocation. Since we can only do one
+ * allocation within a transaction without deadlocks, we must commit
+ * the current transaction before returning the inode itself.
+ * In this case, therefore, we will set ialloc_context and return.
+ * The caller should then commit the current transaction, start a new
+ * transaction, and call xfs_ialloc() again to actually get the inode.
+ *
+ * To ensure that some other process does not grab the inode that
+ * was allocated during the first call to xfs_ialloc(), this routine
+ * also returns the [locked] bp pointing to the head of the freelist
+ * as ialloc_context.  The caller should hold this buffer across
+ * the commit and pass it back into this routine on the second call.
+ *
+ * If we are allocating quota inodes, we do not have a parent inode
+ * to attach to or associate with (i.e. pip == NULL) because they
+ * are not linked into the directory structure - they are attached
+ * directly to the superblock - and so have no parent.
+ */
+static int
+xfs_ialloc(
+	struct xfs_trans		*tp,
+	const struct xfs_ialloc_args	*args,
+	struct xfs_buf			**ialloc_context,
+	struct xfs_inode		**ipp)
+{
+	struct xfs_mount		*mp = tp->t_mountp;
+	struct xfs_inode		*pip = args->pip;
+	struct xfs_inode		*ip;
+	xfs_ino_t			ino;
+	int				error;
+
+	/*
+	 * Call the space management code to pick
+	 * the on-disk inode to be allocated.
+	 */
+	error = xfs_dialloc(tp, pip ? pip->i_ino : 0, args->mode,
+			    ialloc_context, &ino);
+	if (error)
+		return error;
+	if (*ialloc_context || ino == NULLFSINO) {
+		*ipp = NULL;
+		return 0;
+	}
+	ASSERT(*ialloc_context == NULL);
+
+	/*
+	 * Protect against obviously corrupt allocation btree records. Later
+	 * xfs_iget checks will catch re-allocation of other active in-memory
+	 * and on-disk inodes. If we don't catch reallocating the parent inode
+	 * here we will deadlock in xfs_iget() so we have to do these checks
+	 * first.
+	 */
+	if ((pip && ino == pip->i_ino) || !xfs_verify_dir_ino(mp, ino)) {
+		xfs_alert(mp, "Allocated a known in-use inode 0x%llx!", ino);
+		xfs_agno_mark_sick(mp, XFS_INO_TO_AGNO(mp, ino),
+				XFS_SICK_AG_INOBT);
+		return -EFSCORRUPTED;
+	}
+
+	/*
+	 * Get the in-core inode with the lock held exclusively.
+	 * This is because we're setting fields here we need
+	 * to prevent others from looking at until we're done.
+	 */
+	error = xfs_iget(mp, tp, ino, XFS_IGET_CREATE,
+			 XFS_ILOCK_EXCL, &ip);
+	if (error)
+		return error;
+	ASSERT(ip != NULL);
 
+	xfs_inode_init(tp, args, ip);
 	*ipp = ip;
 	return 0;
 }

