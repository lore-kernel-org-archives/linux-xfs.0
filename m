Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B6E2C2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:13:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 432F820718
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:13:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="k0fjNFGO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727207AbgAABN4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:13:56 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:54394 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727134AbgAABN4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:13:56 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011Dtvo091860
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:13:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=UA7PPgtAFTyVOXA7abEwp7eq0Kw1JYFjI2A/XQXRxMU=;
 b=k0fjNFGOVp/HMU1V6zDLLpbo6NMQV5oJ8Ikdz3GoCBaet7i52MjLICXwLMh2PxBGWRWA
 BQD35ArnxMdSJkmgkLbapX3ydkQdTGKpRSsITFELXpi6JHGM3Tl0ZptB3MqycwNcrScT
 XThYMTFvWoA+LAuApYeO5Bdus6JjpKyC15cZXr+qaY3XnvAXrKjw2Zf2MSYU7/c9hUiB
 5XNsGEE5k12ZRthmvWPq9Pz9hZrQumW7B1NgHxP+wJWQzXHeBPdUDtliCi9UKXWUmwBG
 UnWARCsQeBAot5O2cJAWCWN/XJxLWwJqd6+cn92eKVWKpQZrfaK0KKuGog+tQOShQOH2 mQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2x5y0pjxyj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:13:54 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118ung190218
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:13:54 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2x8bsrg2qs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:13:53 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0011DrE7007407
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:13:53 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:13:52 -0800
Subject: [PATCH 12/21] xfs: move xfs_dir_ialloc to libxfs
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:13:50 -0800
Message-ID: <157784123050.1365473.5886354142413885877.stgit@magnolia>
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

Move xfs_dir_ialloc to libxfs, and make xfs_ialloc static since we only
needed it to be non-static temporarily.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_inode_util.c |  108 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_inode_util.h |    4 +
 fs/xfs/xfs_inode.c             |  106 ---------------------------------------
 fs/xfs/xfs_inode.h             |    4 -
 4 files changed, 109 insertions(+), 113 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_util.c b/fs/xfs/libxfs/xfs_inode_util.c
index 30c6e4c5aae9..9e7eb1f2581c 100644
--- a/fs/xfs/libxfs/xfs_inode_util.c
+++ b/fs/xfs/libxfs/xfs_inode_util.c
@@ -329,7 +329,7 @@ xfs_inode_init(
  * are not linked into the directory structure - they are attached
  * directly to the superblock - and so have no parent.
  */
-int
+STATIC int
 xfs_ialloc(
 	struct xfs_trans		*tp,
 	const struct xfs_ialloc_args	*args,
@@ -384,3 +384,109 @@ xfs_ialloc(
 	*ipp = ip;
 	return 0;
 }
+
+/*
+ * Allocates a new inode from disk and return a pointer to the
+ * incore copy. This routine will internally commit the current
+ * transaction and allocate a new one if the Space Manager needed
+ * to do an allocation to replenish the inode free-list.
+ *
+ * This routine is designed to be called from xfs_create and
+ * xfs_create_dir.
+ *
+ */
+int
+xfs_dir_ialloc(
+	struct xfs_trans		**tpp,
+	const struct xfs_ialloc_args	*args,
+	struct xfs_inode		**ipp)
+{
+	struct xfs_trans		*tp;
+	struct xfs_inode		*ip;
+	struct xfs_buf			*ialloc_context = NULL;
+	int				error;
+
+	tp = *tpp;
+	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
+
+	/*
+	 * xfs_ialloc will return a pointer to an incore inode if
+	 * the Space Manager has an available inode on the free
+	 * list. Otherwise, it will do an allocation and replenish
+	 * the freelist.  Since we can only do one allocation per
+	 * transaction without deadlocks, we will need to commit the
+	 * current transaction and start a new one.  We will then
+	 * need to call xfs_ialloc again to get the inode.
+	 *
+	 * If xfs_ialloc did an allocation to replenish the freelist,
+	 * it returns the bp containing the head of the freelist as
+	 * ialloc_context. We will hold a lock on it across the
+	 * transaction commit so that no other process can steal
+	 * the inode(s) that we've just allocated.
+	 */
+	error = xfs_ialloc(tp, args, &ialloc_context, &ip);
+
+	/*
+	 * Return an error if we were unable to allocate a new inode.
+	 * This should only happen if we run out of space on disk or
+	 * encounter a disk error.
+	 */
+	if (error) {
+		*ipp = NULL;
+		return error;
+	}
+	if (!ialloc_context && !ip) {
+		*ipp = NULL;
+		return -ENOSPC;
+	}
+
+	/*
+	 * If the AGI buffer is non-NULL, then we were unable to get an
+	 * inode in one operation.  We need to commit the current
+	 * transaction and call xfs_ialloc() again.  It is guaranteed
+	 * to succeed the second time.
+	 */
+	if (ialloc_context) {
+		/*
+		 * Normally, xfs_trans_commit releases all the locks.
+		 * We call bhold to hang on to the ialloc_context across
+		 * the commit.  Holding this buffer prevents any other
+		 * processes from doing any allocations in this
+		 * allocation group.
+		 */
+		xfs_trans_bhold(tp, ialloc_context);
+
+		error = xfs_dir_ialloc_roll(&tp);
+		if (error) {
+			xfs_buf_relse(ialloc_context);
+			*tpp = tp;
+			*ipp = NULL;
+			return error;
+		}
+		xfs_trans_bjoin(tp, ialloc_context);
+
+		/*
+		 * Call ialloc again. Since we've locked out all
+		 * other allocations in this allocation group,
+		 * this call should always succeed.
+		 */
+		error = xfs_ialloc(tp, args, &ialloc_context, &ip);
+
+		/*
+		 * If we get an error at this point, return to the caller
+		 * so that the current transaction can be aborted.
+		 */
+		if (error) {
+			*tpp = tp;
+			*ipp = NULL;
+			return error;
+		}
+		ASSERT(!ialloc_context && ip);
+
+	}
+
+	*ipp = ip;
+	*tpp = tp;
+
+	return 0;
+}
diff --git a/fs/xfs/libxfs/xfs_inode_util.h b/fs/xfs/libxfs/xfs_inode_util.h
index 2ee6e5bfb80a..95b58b18dd8b 100644
--- a/fs/xfs/libxfs/xfs_inode_util.h
+++ b/fs/xfs/libxfs/xfs_inode_util.h
@@ -41,8 +41,8 @@ int xfs_ialloc_iget(struct xfs_trans *tp, xfs_ino_t ino,
 		    struct xfs_inode **ipp);
 int xfs_dir_ialloc_roll(struct xfs_trans **tpp);
 
-int xfs_ialloc(struct xfs_trans *tp, const struct xfs_ialloc_args *args,
-	       struct xfs_buf **ialloc_context, struct xfs_inode **ipp);
+int xfs_dir_ialloc(struct xfs_trans **tpp, const struct xfs_ialloc_args *args,
+		   struct xfs_inode **ipp);
 void xfs_inode_init(struct xfs_trans *tp, const struct xfs_ialloc_args *args,
 		    struct xfs_inode *ip);
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 0d1cfc85a268..90102a77e445 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -670,112 +670,6 @@ xfs_dir_ialloc_roll(
 	return error;
 }
 
-/*
- * Allocates a new inode from disk and return a pointer to the
- * incore copy. This routine will internally commit the current
- * transaction and allocate a new one if the Space Manager needed
- * to do an allocation to replenish the inode free-list.
- *
- * This routine is designed to be called from xfs_create and
- * xfs_create_dir.
- *
- */
-int
-xfs_dir_ialloc(
-	struct xfs_trans		**tpp,
-	const struct xfs_ialloc_args	*args,
-	struct xfs_inode		**ipp)
-{
-	struct xfs_trans		*tp;
-	struct xfs_inode		*ip;
-	struct xfs_buf			*ialloc_context = NULL;
-	int				code;
-
-	tp = *tpp;
-	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
-
-	/*
-	 * xfs_ialloc will return a pointer to an incore inode if
-	 * the Space Manager has an available inode on the free
-	 * list. Otherwise, it will do an allocation and replenish
-	 * the freelist.  Since we can only do one allocation per
-	 * transaction without deadlocks, we will need to commit the
-	 * current transaction and start a new one.  We will then
-	 * need to call xfs_ialloc again to get the inode.
-	 *
-	 * If xfs_ialloc did an allocation to replenish the freelist,
-	 * it returns the bp containing the head of the freelist as
-	 * ialloc_context. We will hold a lock on it across the
-	 * transaction commit so that no other process can steal
-	 * the inode(s) that we've just allocated.
-	 */
-	code = xfs_ialloc(tp, args, &ialloc_context, &ip);
-
-	/*
-	 * Return an error if we were unable to allocate a new inode.
-	 * This should only happen if we run out of space on disk or
-	 * encounter a disk error.
-	 */
-	if (code) {
-		*ipp = NULL;
-		return code;
-	}
-	if (!ialloc_context && !ip) {
-		*ipp = NULL;
-		return -ENOSPC;
-	}
-
-	/*
-	 * If the AGI buffer is non-NULL, then we were unable to get an
-	 * inode in one operation.  We need to commit the current
-	 * transaction and call xfs_ialloc() again.  It is guaranteed
-	 * to succeed the second time.
-	 */
-	if (ialloc_context) {
-		/*
-		 * Normally, xfs_trans_commit releases all the locks.
-		 * We call bhold to hang on to the ialloc_context across
-		 * the commit.  Holding this buffer prevents any other
-		 * processes from doing any allocations in this
-		 * allocation group.
-		 */
-		xfs_trans_bhold(tp, ialloc_context);
-
-		code = xfs_dir_ialloc_roll(&tp);
-		if (code) {
-			xfs_buf_relse(ialloc_context);
-			*tpp = tp;
-			*ipp = NULL;
-			return code;
-		}
-		xfs_trans_bjoin(tp, ialloc_context);
-
-		/*
-		 * Call ialloc again. Since we've locked out all
-		 * other allocations in this allocation group,
-		 * this call should always succeed.
-		 */
-		code = xfs_ialloc(tp, args, &ialloc_context, &ip);
-
-		/*
-		 * If we get an error at this point, return to the caller
-		 * so that the current transaction can be aborted.
-		 */
-		if (code) {
-			*tpp = tp;
-			*ipp = NULL;
-			return code;
-		}
-		ASSERT(!ialloc_context && ip);
-
-	}
-
-	*ipp = ip;
-	*tpp = tp;
-
-	return 0;
-}
-
 /*
  * Decrement the link count on an inode & log the change.  If this causes the
  * link count to go to zero, move the inode to AGI unlinked list so that it can
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 24e167cd9a72..79c26e8494a6 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -440,10 +440,6 @@ int		xfs_iflush(struct xfs_inode *, struct xfs_buf **);
 void		xfs_lock_two_inodes(struct xfs_inode *ip0, uint ip0_mode,
 				struct xfs_inode *ip1, uint ip1_mode);
 
-int		xfs_dir_ialloc(struct xfs_trans **,
-			       const struct xfs_ialloc_args *,
-			       struct xfs_inode **);
-
 static inline int
 xfs_itruncate_extents(
 	struct xfs_trans	**tpp,

