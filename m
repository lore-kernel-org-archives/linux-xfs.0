Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82C62C2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:14:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 55B70206E4
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:14:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iuiS9cbE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727175AbgAABOV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:14:21 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:54618 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727134AbgAABOU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:14:20 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011EJrX092059
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:14:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=ZPjqWYFM/9x7cXVAgeo78pmaiKUwvVI3xi3R6n9tRDo=;
 b=iuiS9cbEEdC4tz43fDUExguDOd1ueIyE+jA1Z45wsIREBfwUdPcfeJ/U1I7gSW9RSWk9
 wkwksIvLYPsyCgKL84ALxyYBmNHu8pf96GyGePoMB5MHr6EF26F0adzKYZCc9zI17GJ0
 Ba01UmRprrAz2F828dF3Az0KF2D5RKmDfT3sh9Tq1uklfka7WMdvUb96JFnXplYpdLuI
 zpm5fVEN0kDl1mw1EvM9kvTrniQ1xT+VyOqJg2tYesxwCKgvymBCSCL2sH+GVH+77iyk
 RWOT3jKUFwRnfh5Vrzkb5ChvCGHb8GbgfZoQOsW7ye6YbXfEsqBuk9mg6oq9WxT8Ji4O QA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2x5y0pjy0a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:14:19 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118x7e012461
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:14:19 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2x8guef42s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:14:18 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0011EHZi012866
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:14:18 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:14:17 -0800
Subject: [PATCH 16/21] xfs: create libxfs helper to link an existing inode
 into a directory
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:14:15 -0800
Message-ID: <157784125528.1365473.6288343272418797604.stgit@magnolia>
In-Reply-To: <157784115560.1365473.15056496428451670757.stgit@magnolia>
References: <157784115560.1365473.15056496428451670757.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=980
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010010
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create a new libxfs function to link an existing inode into a directory.
The upcoming metadata directory feature will need this to create a
metadata directory tree.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_dir2.c |   45 +++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_dir2.h |    3 +++
 fs/xfs/xfs_inode.c       |   22 +---------------------
 3 files changed, 49 insertions(+), 21 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 2a41aa2b3b30..3b727944f756 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -794,3 +794,48 @@ xfs_dir_create_new_child(
 	xfs_bumplink(tp, dp);
 	return 0;
 }
+
+/*
+ * Given a directory @dp, an existing non-directory inode @ip, and a @name,
+ * link @ip into @dp under the given @name.  Both inodes must have the ILOCK
+ * held.
+ */
+int
+xfs_dir_link_existing_child(
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
+	ASSERT(!S_ISDIR(VFS_I(ip)->i_mode));
+
+	if (!resblks) {
+		error = xfs_dir_canenter(tp, dp, name);
+		if (error)
+			return error;
+	}
+
+	/*
+	 * Handle initial link state of O_TMPFILE inode
+	 */
+	if (VFS_I(ip)->i_nlink == 0) {
+		error = xfs_iunlink_remove(tp, ip);
+		if (error)
+			return error;
+	}
+
+	error = xfs_dir_createname(tp, dp, name, ip->i_ino, resblks);
+	if (error)
+		return error;
+
+	xfs_trans_ichgtime(tp, dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
+	xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
+
+	xfs_bumplink(tp, ip);
+	return 0;
+}
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index de38d6335a72..14ade8f81bcc 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -253,5 +253,8 @@ bool xfs_dir2_namecheck(const void *name, size_t length);
 int xfs_dir_create_new_child(struct xfs_trans *tp, uint resblks,
 		struct xfs_inode *dp, struct xfs_name *name,
 		struct xfs_inode *ip);
+int xfs_dir_link_existing_child(struct xfs_trans *tp, uint resblks,
+		struct xfs_inode *dp, struct xfs_name *name,
+		struct xfs_inode *ip);
 
 #endif	/* __XFS_DIR2_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index b3ff374025dd..80aa21149bd9 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -975,29 +975,9 @@ xfs_link(
 		goto error_return;
 	}
 
-	if (!resblks) {
-		error = xfs_dir_canenter(tp, tdp, target_name);
-		if (error)
-			goto error_return;
-	}
-
-	/*
-	 * Handle initial link state of O_TMPFILE inode
-	 */
-	if (VFS_I(sip)->i_nlink == 0) {
-		error = xfs_iunlink_remove(tp, sip);
-		if (error)
-			goto error_return;
-	}
-
-	error = xfs_dir_createname(tp, tdp, target_name, sip->i_ino,
-				   resblks);
+	error = xfs_dir_link_existing_child(tp, resblks, tdp, target_name, sip);
 	if (error)
 		goto error_return;
-	xfs_trans_ichgtime(tp, tdp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
-	xfs_trans_log_inode(tp, tdp, XFS_ILOG_CORE);
-
-	xfs_bumplink(tp, sip);
 
 	/*
 	 * If this is a synchronous mount, make sure that the

