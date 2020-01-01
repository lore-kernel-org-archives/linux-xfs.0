Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2F29C2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:14:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99B97206E6
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:14:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ATmM/S3l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727154AbgAABOk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:14:40 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:54802 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727134AbgAABOk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:14:40 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011EA8k092020
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:14:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=kFEhwXSbCJkYhXWAOE/dMH0EVqzXfTJGRZa66R1mN98=;
 b=ATmM/S3lT00dMa97NY6KVP6tfA6eYExckevXBxXj+56VVTj0cLppTkaQs6BntACiUWlM
 ikvDxp/NWWQMc4tspgjJyj6NW9K0SFhJehzhchfzAiW/a6Zja0c6ZS9DLC2S3b8Xw5uV
 VDwMI5NoZXoJ1sFc7VfoLIufq0MmiLUYtUxl6QWyJyMAf9QQ2PxIp6oG3xhbgh/xv3Vf
 m5ZHf9ZLX8i1mPKb+UDJ1I7J4NjtEP9kL8WxdD67e8K88TSvT9Or6NaiTtJZA7ln/+Vt
 wnspZjCPmr2wM9y/Y6RQAjyHMmH61ydyAN7err5Rqkyq3Lh8vJiNH+p4jBPt1UezNCPg rw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2x5y0pjy0k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:14:38 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118v3p190376
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:14:37 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2x8bsrg368-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:14:37 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0011Ea4K012915
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:14:36 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:14:36 -0800
Subject: [PATCH 19/21] xfs: create libxfs helper to exchange two directory
 entries
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:14:34 -0800
Message-ID: <157784127391.1365473.687716246893340734.stgit@magnolia>
In-Reply-To: <157784115560.1365473.15056496428451670757.stgit@magnolia>
References: <157784115560.1365473.15056496428451670757.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=837
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=900 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010010
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create a new libxfs function to exchange two directory entries.
The upcoming metadata directory feature will need this to replace a
metadata inode directory entry.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_dir2.c |  108 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_dir2.h |    4 ++
 fs/xfs/xfs_inode.c       |   85 +-----------------------------------
 3 files changed, 115 insertions(+), 82 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index dbadc8aae1ba..56700df1c830 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -899,3 +899,111 @@ xfs_dir_remove_child(
 
 	return 0;
 }
+
+/*
+ * Exchange the entry (@name1, @ip1) in directory @dp1 with the entry (@name2,
+ * @ip2) in directory @dp2, and update '..' @ip1 and @ip2's entries as needed.
+ * @ip1 and @ip2 need not be of the same type.
+ *
+ * All inodes must have the ILOCK held, and both entries must already exist.
+ */
+int
+xfs_dir_exchange(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*dp1,
+	struct xfs_name		*name1,
+	struct xfs_inode	*ip1,
+	struct xfs_inode	*dp2,
+	struct xfs_name		*name2,
+	struct xfs_inode	*ip2,
+	unsigned int		spaceres)
+{
+	int			ip1_flags = 0;
+	int			ip2_flags = 0;
+	int			dp2_flags = 0;
+	int			error;
+
+	/* Swap inode number for dirent in first parent */
+	error = xfs_dir_replace(tp, dp1, name1, ip2->i_ino, spaceres);
+	if (error)
+		return error;
+
+	/* Swap inode number for dirent in second parent */
+	error = xfs_dir_replace(tp, dp2, name2, ip1->i_ino, spaceres);
+	if (error)
+		return error;
+
+	/*
+	 * If we're renaming one or more directories across different parents,
+	 * update the respective ".." entries (and link counts) to match the new
+	 * parents.
+	 */
+	if (dp1 != dp2) {
+		dp2_flags = XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG;
+
+		if (S_ISDIR(VFS_I(ip2)->i_mode)) {
+			error = xfs_dir_replace(tp, ip2, &xfs_name_dotdot,
+						dp1->i_ino, spaceres);
+			if (error)
+				return error;
+
+			/* transfer ip2 ".." reference to dp1 */
+			if (!S_ISDIR(VFS_I(ip1)->i_mode)) {
+				error = xfs_droplink(tp, dp2);
+				if (error)
+					return error;
+				xfs_bumplink(tp, dp1);
+			}
+
+			/*
+			 * Although ip1 isn't changed here, userspace needs
+			 * to be warned about the change, so that applications
+			 * relying on it (like backup ones), will properly
+			 * notify the change
+			 */
+			ip1_flags |= XFS_ICHGTIME_CHG;
+			ip2_flags |= XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG;
+		}
+
+		if (S_ISDIR(VFS_I(ip1)->i_mode)) {
+			error = xfs_dir_replace(tp, ip1, &xfs_name_dotdot,
+						dp2->i_ino, spaceres);
+			if (error)
+				return error;
+
+			/* transfer ip1 ".." reference to dp2 */
+			if (!S_ISDIR(VFS_I(ip2)->i_mode)) {
+				error = xfs_droplink(tp, dp1);
+				if (error)
+					return error;
+				xfs_bumplink(tp, dp2);
+			}
+
+			/*
+			 * Although ip2 isn't changed here, userspace needs
+			 * to be warned about the change, so that applications
+			 * relying on it (like backup ones), will properly
+			 * notify the change
+			 */
+			ip1_flags |= XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG;
+			ip2_flags |= XFS_ICHGTIME_CHG;
+		}
+	}
+
+	if (ip1_flags) {
+		xfs_trans_ichgtime(tp, ip1, ip1_flags);
+		xfs_trans_log_inode(tp, ip1, XFS_ILOG_CORE);
+	}
+	if (ip2_flags) {
+		xfs_trans_ichgtime(tp, ip2, ip2_flags);
+		xfs_trans_log_inode(tp, ip2, XFS_ILOG_CORE);
+	}
+	if (dp2_flags) {
+		xfs_trans_ichgtime(tp, dp2, dp2_flags);
+		xfs_trans_log_inode(tp, dp2, XFS_ILOG_CORE);
+	}
+	xfs_trans_ichgtime(tp, dp1, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
+	xfs_trans_log_inode(tp, dp1, XFS_ILOG_CORE);
+
+	return 0;
+}
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index bf8ad78ab573..f5d5e428b673 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -259,5 +259,9 @@ int xfs_dir_link_existing_child(struct xfs_trans *tp, uint resblks,
 int xfs_dir_remove_child(struct xfs_trans *tp, uint resblks,
 		struct xfs_inode *dp, struct xfs_name *name,
 		struct xfs_inode *ip);
+int xfs_dir_exchange(struct xfs_trans *tp, struct xfs_inode *dp1,
+		struct xfs_name *name1, struct xfs_inode *ip1,
+		struct xfs_inode *dp2, struct xfs_name *name2,
+		struct xfs_inode *ip2, unsigned int spaceres);
 
 #endif	/* __XFS_DIR2_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index e9db45783aec..0a39e343f5ed 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2284,92 +2284,13 @@ xfs_cross_rename(
 	struct xfs_inode	*ip2,
 	int			spaceres)
 {
-	int		error = 0;
-	int		ip1_flags = 0;
-	int		ip2_flags = 0;
-	int		dp2_flags = 0;
-
-	/* Swap inode number for dirent in first parent */
-	error = xfs_dir_replace(tp, dp1, name1, ip2->i_ino, spaceres);
-	if (error)
-		goto out_trans_abort;
+	int			error;
 
-	/* Swap inode number for dirent in second parent */
-	error = xfs_dir_replace(tp, dp2, name2, ip1->i_ino, spaceres);
+	error = xfs_dir_exchange(tp, dp1, name1, ip1, dp2, name2, ip2,
+			spaceres);
 	if (error)
 		goto out_trans_abort;
 
-	/*
-	 * If we're renaming one or more directories across different parents,
-	 * update the respective ".." entries (and link counts) to match the new
-	 * parents.
-	 */
-	if (dp1 != dp2) {
-		dp2_flags = XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG;
-
-		if (S_ISDIR(VFS_I(ip2)->i_mode)) {
-			error = xfs_dir_replace(tp, ip2, &xfs_name_dotdot,
-						dp1->i_ino, spaceres);
-			if (error)
-				goto out_trans_abort;
-
-			/* transfer ip2 ".." reference to dp1 */
-			if (!S_ISDIR(VFS_I(ip1)->i_mode)) {
-				error = xfs_droplink(tp, dp2);
-				if (error)
-					goto out_trans_abort;
-				xfs_bumplink(tp, dp1);
-			}
-
-			/*
-			 * Although ip1 isn't changed here, userspace needs
-			 * to be warned about the change, so that applications
-			 * relying on it (like backup ones), will properly
-			 * notify the change
-			 */
-			ip1_flags |= XFS_ICHGTIME_CHG;
-			ip2_flags |= XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG;
-		}
-
-		if (S_ISDIR(VFS_I(ip1)->i_mode)) {
-			error = xfs_dir_replace(tp, ip1, &xfs_name_dotdot,
-						dp2->i_ino, spaceres);
-			if (error)
-				goto out_trans_abort;
-
-			/* transfer ip1 ".." reference to dp2 */
-			if (!S_ISDIR(VFS_I(ip2)->i_mode)) {
-				error = xfs_droplink(tp, dp1);
-				if (error)
-					goto out_trans_abort;
-				xfs_bumplink(tp, dp2);
-			}
-
-			/*
-			 * Although ip2 isn't changed here, userspace needs
-			 * to be warned about the change, so that applications
-			 * relying on it (like backup ones), will properly
-			 * notify the change
-			 */
-			ip1_flags |= XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG;
-			ip2_flags |= XFS_ICHGTIME_CHG;
-		}
-	}
-
-	if (ip1_flags) {
-		xfs_trans_ichgtime(tp, ip1, ip1_flags);
-		xfs_trans_log_inode(tp, ip1, XFS_ILOG_CORE);
-	}
-	if (ip2_flags) {
-		xfs_trans_ichgtime(tp, ip2, ip2_flags);
-		xfs_trans_log_inode(tp, ip2, XFS_ILOG_CORE);
-	}
-	if (dp2_flags) {
-		xfs_trans_ichgtime(tp, dp2, dp2_flags);
-		xfs_trans_log_inode(tp, dp2, XFS_ILOG_CORE);
-	}
-	xfs_trans_ichgtime(tp, dp1, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
-	xfs_trans_log_inode(tp, dp1, XFS_ILOG_CORE);
 	return xfs_finish_rename(tp);
 
 out_trans_abort:

