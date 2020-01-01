Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 808B2C2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:14:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 47D71206E4
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:14:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="G1R/l/e6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727141AbgAABOd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:14:33 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:54736 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727134AbgAABOd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:14:33 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011E9qt092017
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:14:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=yWSwnkotuHh6vI7JjpL2zv4mEttYvm4Bo7KKfb/v9ss=;
 b=G1R/l/e6SbGkmcz0XOv8Ba+JzXXk1pLbwNpJWH2QXgSbl94rnZGF8JgK3wPfvMDd2eSa
 5wcPcHgZ+L2tO0WxkWGHeeAkuAnYIrlR3Rt3MJ+cG4V+G1LNHOTJlZ6LBwjStHxDZHpF
 Pg9o6t40xushn26aAfvYScWYk3MvAYy1BS0d+3THykGc82IcI5pURaibQtvTp385tXgB
 KDhK4xhpxJTpKtwzM3m6xKFxbAAKZOASBVUHZXBe5k93js+c7mFDboKaVcMuspjjzVGe
 fNIg3/gPL3QAuTQ5niXwU0HrAPi1wT1DHZLsWWG19qOw3vNi6ImM0fQlf1i6WMonFnyl hw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2x5y0pjy0f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:14:32 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118v0G190269
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:14:31 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2x8bsrg34b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:14:31 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0011EU4A029586
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:14:30 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:14:30 -0800
Subject: [PATCH 18/21] xfs: create libxfs helper to remove an existing
 inode/name from a directory
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:14:27 -0800
Message-ID: <157784126758.1365473.2938653459708690962.stgit@magnolia>
In-Reply-To: <157784115560.1365473.15056496428451670757.stgit@magnolia>
References: <157784115560.1365473.15056496428451670757.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=637
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=691 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010010
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create a new libxfs function to remove a (name, inode) entry from a
directory.  The upcoming metadata directory feature will need this to
create a metadata directory tree.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_dir2.c |   60 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_dir2.h |    3 ++
 fs/xfs/xfs_inode.c       |   42 +-------------------------------
 3 files changed, 64 insertions(+), 41 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 3b727944f756..dbadc8aae1ba 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -839,3 +839,63 @@ xfs_dir_link_existing_child(
 	xfs_bumplink(tp, ip);
 	return 0;
 }
+
+/*
+ * Given a directory @dp, a child @ip, and a @name, remove the (@name, @ip)
+ * entry from the directory.  Both inodes must have the ILOCK held.
+ */
+int
+xfs_dir_remove_child(
+	struct xfs_trans		*tp,
+	uint				resblks,
+	struct xfs_inode		*dp,
+	struct xfs_name			*name,
+	struct xfs_inode		*ip)
+{
+	int				error;
+
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+	ASSERT(xfs_isilocked(dp, XFS_ILOCK_EXCL));
+
+	/*
+	 * If we're removing a directory perform some additional validation.
+	 */
+	if (S_ISDIR(VFS_I(ip)->i_mode)) {
+		ASSERT(VFS_I(ip)->i_nlink >= 2);
+		if (VFS_I(ip)->i_nlink != 2)
+			return -ENOTEMPTY;
+		if (!xfs_dir_isempty(ip))
+			return -ENOTEMPTY;
+
+		/* Drop the link from ip's "..".  */
+		error = xfs_droplink(tp, dp);
+		if (error)
+			return error;
+
+		/* Drop the "." link from ip to self.  */
+		error = xfs_droplink(tp, ip);
+		if (error)
+			return error;
+	} else {
+		/*
+		 * When removing a non-directory we need to log the parent
+		 * inode here.  For a directory this is done implicitly
+		 * by the xfs_droplink call for the ".." entry.
+		 */
+		xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
+	}
+	xfs_trans_ichgtime(tp, dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
+
+	/* Drop the link from dp to ip. */
+	error = xfs_droplink(tp, ip);
+	if (error)
+		return error;
+
+	error = xfs_dir_removename(tp, dp, name, ip->i_ino, resblks);
+	if (error) {
+		ASSERT(error != -ENOENT);
+		return error;
+	}
+
+	return 0;
+}
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index 14ade8f81bcc..bf8ad78ab573 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -256,5 +256,8 @@ int xfs_dir_create_new_child(struct xfs_trans *tp, uint resblks,
 int xfs_dir_link_existing_child(struct xfs_trans *tp, uint resblks,
 		struct xfs_inode *dp, struct xfs_name *name,
 		struct xfs_inode *ip);
+int xfs_dir_remove_child(struct xfs_trans *tp, uint resblks,
+		struct xfs_inode *dp, struct xfs_name *name,
+		struct xfs_inode *ip);
 
 #endif	/* __XFS_DIR2_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 99795618974b..e9db45783aec 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2176,50 +2176,10 @@ xfs_remove(
 	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 
-	/*
-	 * If we're removing a directory perform some additional validation.
-	 */
-	if (is_dir) {
-		ASSERT(VFS_I(ip)->i_nlink >= 2);
-		if (VFS_I(ip)->i_nlink != 2) {
-			error = -ENOTEMPTY;
-			goto out_trans_cancel;
-		}
-		if (!xfs_dir_isempty(ip)) {
-			error = -ENOTEMPTY;
-			goto out_trans_cancel;
-		}
-
-		/* Drop the link from ip's "..".  */
-		error = xfs_droplink(tp, dp);
-		if (error)
-			goto out_trans_cancel;
-
-		/* Drop the "." link from ip to self.  */
-		error = xfs_droplink(tp, ip);
-		if (error)
-			goto out_trans_cancel;
-	} else {
-		/*
-		 * When removing a non-directory we need to log the parent
-		 * inode here.  For a directory this is done implicitly
-		 * by the xfs_droplink call for the ".." entry.
-		 */
-		xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
-	}
-	xfs_trans_ichgtime(tp, dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
-
-	/* Drop the link from dp to ip. */
-	error = xfs_droplink(tp, ip);
+	error = xfs_dir_remove_child(tp, resblks, dp, name, ip);
 	if (error)
 		goto out_trans_cancel;
 
-	error = xfs_dir_removename(tp, dp, name, ip->i_ino, resblks);
-	if (error) {
-		ASSERT(error != -ENOENT);
-		goto out_trans_cancel;
-	}
-
 	/*
 	 * If this is a synchronous mount, make sure that the
 	 * remove transaction goes to disk before returning to

