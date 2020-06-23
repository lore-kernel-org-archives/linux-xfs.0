Return-Path: <SRS0=nlsN=AE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6BCBC433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Jun 2020 04:03:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F24520771
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Jun 2020 04:03:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oJrPqtPp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726054AbgFWED4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Jun 2020 00:03:56 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:33268 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726088AbgFWEDz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Jun 2020 00:03:55 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05N3uORm007859;
        Tue, 23 Jun 2020 04:03:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=C0mWD4BqSOO3u1FpJknYuVtDwGZwBsm/lue7AYlZfAw=;
 b=oJrPqtPpBwfRJ7thHtyr3+Gdz/uik289Scr5E4TKF2E09sVNnX4xI9MkQqAOpvW3Td8p
 lhLLj3UMn0DgSKICzBvFqx7viPxdixPmMCM3+7MBAAMWDT0Q0iMXizxnEmT+9ZWGc3xF
 t3Gl74Mcx9arYLBfiSopWAruDBDU6PIGDKwWQavTebJ8R5GSbMfISHPmK3jO/4uCDA+x
 g2V7+wc8omYBS7ihDY0GtJ0ayo9GUD+orZjpr7gmJAJkRmQhQMv0qCaZbrwsS1A3k+mA
 uAGT7i98D+vvMkwgI6KcCWrsv5ye9UqS/XPsMtj7yPRHbTI3c9sDs/87cEEvgIfT9NIc Dg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 31sebbjsq9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 23 Jun 2020 04:03:52 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05N3w7ug105871;
        Tue, 23 Jun 2020 04:01:52 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 31sv7r4b59-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Jun 2020 04:01:52 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05N41oHs024922;
        Tue, 23 Jun 2020 04:01:51 GMT
Received: from localhost (/10.159.143.140)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 23 Jun 2020 04:01:50 +0000
Subject: [PATCH 3/3] xfs: refactor locking and unlocking two inodes against
 userspace IO
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, edwin@etorok.net
Date:   Mon, 22 Jun 2020 21:01:49 -0700
Message-ID: <159288490975.150128.5869655548489048713.stgit@magnolia>
In-Reply-To: <159288488965.150128.10967331397379450406.stgit@magnolia>
References: <159288488965.150128.10967331397379450406.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9660 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 suspectscore=1 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006230028
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9660 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 lowpriorityscore=0
 mlxlogscore=999 cotscore=-2147483648 mlxscore=0 phishscore=0
 priorityscore=1501 malwarescore=0 bulkscore=0 suspectscore=1 clxscore=1015
 impostorscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006230028
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Refactor the two functions that we use to lock and unlock two inodes to
block userspace from initiating IO against a file, whether via system
calls or mmap activity.  Move them to xfs_inode.c since this functionality
isn't specific to reflink anyway.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_file.c    |    2 +
 fs/xfs/xfs_inode.c   |   93 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_inode.h   |    3 ++
 fs/xfs/xfs_reflink.c |   85 +---------------------------------------------
 fs/xfs/xfs_reflink.h |    2 -
 5 files changed, 99 insertions(+), 86 deletions(-)


diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index b375fae811f2..a32d1eeee0f7 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1065,7 +1065,7 @@ xfs_file_remap_range(
 	if (mp->m_flags & XFS_MOUNT_WSYNC)
 		xfs_log_force_inode(dest);
 out_unlock:
-	xfs_reflink_remap_unlock(file_in, file_out);
+	xfs_iunlock_io_mmap(src, dest);
 	if (ret)
 		trace_xfs_reflink_remap_range_error(dest, ret, _RET_IP_);
 	return remapped > 0 ? remapped : ret;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 9aea7d68d8ab..b9c6d1cc64a9 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3881,3 +3881,96 @@ xfs_log_force_inode(
 		return 0;
 	return xfs_log_force_lsn(ip->i_mount, lsn, XFS_LOG_SYNC, NULL);
 }
+
+/*
+ * Grab the exclusive iolock for a data copy from src to dest, making sure to
+ * abide vfs locking order (lowest pointer value goes first) and breaking the
+ * layout leases before proceeding.  The loop is needed because we cannot call
+ * the blocking break_layout() with the iolocks held, and therefore have to
+ * back out both locks.
+ */
+static int
+xfs_iolock_two_inodes_and_break_layout(
+	struct inode		*src,
+	struct inode		*dest)
+{
+	int			error;
+
+	if (src > dest)
+		swap(src, dest);
+
+retry:
+	/* Wait to break both inodes' layouts before we start locking. */
+	error = break_layout(src, true);
+	if (error)
+		return error;
+	if (src != dest) {
+		error = break_layout(dest, true);
+		if (error)
+			return error;
+	}
+
+	/* Lock one inode and make sure nobody got in and leased it. */
+	inode_lock(src);
+	error = break_layout(src, false);
+	if (error) {
+		inode_unlock(src);
+		if (error == -EWOULDBLOCK)
+			goto retry;
+		return error;
+	}
+
+	if (src == dest)
+		return 0;
+
+	/* Lock the other inode and make sure nobody got in and leased it. */
+	inode_lock_nested(dest, I_MUTEX_NONDIR2);
+	error = break_layout(dest, false);
+	if (error) {
+		inode_unlock(src);
+		inode_unlock(dest);
+		if (error == -EWOULDBLOCK)
+			goto retry;
+		return error;
+	}
+
+	return 0;
+}
+
+/*
+ * Lock two files so that userspace cannot initiate I/O via file syscalls or
+ * mmap activity.
+ */
+int
+xfs_ilock_io_mmap(
+	struct xfs_inode	*ip1,
+	struct xfs_inode	*ip2)
+{
+	int			ret;
+
+	ret = xfs_iolock_two_inodes_and_break_layout(VFS_I(ip1), VFS_I(ip2));
+	if (ret)
+		return ret;
+	if (ip1 == ip2)
+		xfs_ilock(ip1, XFS_MMAPLOCK_EXCL);
+	else
+		xfs_lock_two_inodes(ip1, XFS_MMAPLOCK_EXCL,
+				    ip2, XFS_MMAPLOCK_EXCL);
+	return 0;
+}
+
+/* Unlock both files to allow IO and mmap activity. */
+void
+xfs_iunlock_io_mmap(
+	struct xfs_inode	*ip1,
+	struct xfs_inode	*ip2)
+{
+	bool			same_inode = (ip1 == ip2);
+
+	xfs_iunlock(ip2, XFS_MMAPLOCK_EXCL);
+	if (!same_inode)
+		xfs_iunlock(ip1, XFS_MMAPLOCK_EXCL);
+	inode_unlock(VFS_I(ip2));
+	if (!same_inode)
+		inode_unlock(VFS_I(ip1));
+}
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 47d3b391030d..001529784f96 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -499,4 +499,7 @@ void xfs_iunlink_destroy(struct xfs_perag *pag);
 
 void xfs_end_io(struct work_struct *work);
 
+int xfs_ilock_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
+void xfs_iunlock_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
+
 #endif	/* __XFS_INODE_H__ */
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index dd9ed7d5694d..130b6be8180e 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1203,81 +1203,6 @@ xfs_reflink_remap_blocks(
 	return error;
 }
 
-/*
- * Grab the exclusive iolock for a data copy from src to dest, making sure to
- * abide vfs locking order (lowest pointer value goes first) and breaking the
- * layout leases before proceeding.  The loop is needed because we cannot call
- * the blocking break_layout() with the iolocks held, and therefore have to
- * back out both locks.
- */
-static int
-xfs_iolock_two_inodes_and_break_layout(
-	struct inode		*src,
-	struct inode		*dest)
-{
-	int			error;
-
-	if (src > dest)
-		swap(src, dest);
-
-retry:
-	/* Wait to break both inodes' layouts before we start locking. */
-	error = break_layout(src, true);
-	if (error)
-		return error;
-	if (src != dest) {
-		error = break_layout(dest, true);
-		if (error)
-			return error;
-	}
-
-	/* Lock one inode and make sure nobody got in and leased it. */
-	inode_lock(src);
-	error = break_layout(src, false);
-	if (error) {
-		inode_unlock(src);
-		if (error == -EWOULDBLOCK)
-			goto retry;
-		return error;
-	}
-
-	if (src == dest)
-		return 0;
-
-	/* Lock the other inode and make sure nobody got in and leased it. */
-	inode_lock_nested(dest, I_MUTEX_NONDIR2);
-	error = break_layout(dest, false);
-	if (error) {
-		inode_unlock(src);
-		inode_unlock(dest);
-		if (error == -EWOULDBLOCK)
-			goto retry;
-		return error;
-	}
-
-	return 0;
-}
-
-/* Unlock both inodes after they've been prepped for a range clone. */
-void
-xfs_reflink_remap_unlock(
-	struct file		*file_in,
-	struct file		*file_out)
-{
-	struct inode		*inode_in = file_inode(file_in);
-	struct xfs_inode	*src = XFS_I(inode_in);
-	struct inode		*inode_out = file_inode(file_out);
-	struct xfs_inode	*dest = XFS_I(inode_out);
-	bool			same_inode = (inode_in == inode_out);
-
-	xfs_iunlock(dest, XFS_MMAPLOCK_EXCL);
-	if (!same_inode)
-		xfs_iunlock(src, XFS_MMAPLOCK_EXCL);
-	inode_unlock(inode_out);
-	if (!same_inode)
-		inode_unlock(inode_in);
-}
-
 /*
  * If we're reflinking to a point past the destination file's EOF, we must
  * zero any speculative post-EOF preallocations that sit between the old EOF
@@ -1340,18 +1265,12 @@ xfs_reflink_remap_prep(
 	struct xfs_inode	*src = XFS_I(inode_in);
 	struct inode		*inode_out = file_inode(file_out);
 	struct xfs_inode	*dest = XFS_I(inode_out);
-	bool			same_inode = (inode_in == inode_out);
 	int			ret;
 
 	/* Lock both files against IO */
-	ret = xfs_iolock_two_inodes_and_break_layout(inode_in, inode_out);
+	ret = xfs_ilock_io_mmap(src, dest);
 	if (ret)
 		return ret;
-	if (same_inode)
-		xfs_ilock(src, XFS_MMAPLOCK_EXCL);
-	else
-		xfs_lock_two_inodes(src, XFS_MMAPLOCK_EXCL, dest,
-				XFS_MMAPLOCK_EXCL);
 
 	/* Check file eligibility and prepare for block sharing. */
 	ret = -EINVAL;
@@ -1402,7 +1321,7 @@ xfs_reflink_remap_prep(
 
 	return 0;
 out_unlock:
-	xfs_reflink_remap_unlock(file_in, file_out);
+	xfs_iunlock_io_mmap(src, dest);
 	return ret;
 }
 
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
index 3e4fd46373ab..487b00434b96 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -56,7 +56,5 @@ extern int xfs_reflink_remap_blocks(struct xfs_inode *src, loff_t pos_in,
 		loff_t *remapped);
 extern int xfs_reflink_update_dest(struct xfs_inode *dest, xfs_off_t newlen,
 		xfs_extlen_t cowextsize, unsigned int remap_flags);
-extern void xfs_reflink_remap_unlock(struct file *file_in,
-		struct file *file_out);
 
 #endif /* __XFS_REFLINK_H */

