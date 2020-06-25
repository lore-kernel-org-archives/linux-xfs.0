Return-Path: <SRS0=UnAH=AG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37393C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 01:18:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A93420706
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 01:18:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="H1oy6w0x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389037AbgFYBSq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Jun 2020 21:18:46 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49300 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388942AbgFYBSq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Jun 2020 21:18:46 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05P1732O082153;
        Thu, 25 Jun 2020 01:18:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=dZkV2Cx3e1Q5dXiHmWyBoI3icDmUG17kl8wEqsyglZY=;
 b=H1oy6w0xX9sbSJJoMTa0j85NWA62ZjXp04nLMi29VrLM1XIJ8ri50s6rql0Wip4yWQW6
 f8P5wP/nLvoz3Uzru7EpI+KyppbIDvu3hTqetQTKjCeHgUmOhFcDX7dZyOTySooLkDRP
 mlcuVpQeLU2ZC7lR3iv+Feq/NzPacouJQ+P01Jp9SUZubMi93AUWDMnbmxnrGxrgD2I6
 gIHhCp2lbgFdzmLJuNvCKCilNNxfmgUj+utTT+je2OrUymfUhVYxkTeeT7pNV1AMM7nm
 kjqcE4nlC9rErKRUgtejq3UOcYdv8+IJTTlViKiG36kaexzgPd7AsQ1ybXoNUA7fVMEm XA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 31uut5nuyd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 25 Jun 2020 01:18:41 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05P17t9c180594;
        Thu, 25 Jun 2020 01:18:40 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 31uur0fxh9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Jun 2020 01:18:40 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05P1IdPq009937;
        Thu, 25 Jun 2020 01:18:39 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 25 Jun 2020 01:18:38 +0000
Subject: [PATCH 9/9] xfs: move helpers that lock and unlock two inodes against
 userspace IO
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        edwin@etorok.net
Date:   Wed, 24 Jun 2020 18:18:37 -0700
Message-ID: <159304791766.874036.17659898139855742701.stgit@magnolia>
In-Reply-To: <159304785928.874036.4735877085735285950.stgit@magnolia>
References: <159304785928.874036.4735877085735285950.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9662 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 suspectscore=1 malwarescore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006250004
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9662 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 clxscore=1015
 lowpriorityscore=0 bulkscore=0 adultscore=0 spamscore=0 suspectscore=1
 phishscore=0 impostorscore=0 cotscore=-2147483648 priorityscore=1501
 mlxscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006250004
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Move the double-inode locking helpers to xfs_inode.c since they're not
specific to reflink.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_file.c    |    2 +
 fs/xfs/xfs_inode.c   |   93 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_inode.h   |    3 ++
 fs/xfs/xfs_reflink.c |   97 +-------------------------------------------------
 fs/xfs/xfs_reflink.h |    1 -
 5 files changed, 99 insertions(+), 97 deletions(-)


diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index f189bdcbeddd..97aa74800bd9 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1065,7 +1065,7 @@ xfs_file_remap_range(
 	if (mp->m_flags & XFS_MOUNT_WSYNC)
 		xfs_log_force_inode(dest);
 out_unlock:
-	xfs_reflink_remap_unlock(src, dest);
+	xfs_iunlock2_io_mmap(src, dest);
 	if (ret)
 		trace_xfs_reflink_remap_range_error(dest, ret, _RET_IP_);
 	return remapped > 0 ? remapped : ret;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 9aea7d68d8ab..24edec472a7c 100644
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
+ * Lock two inodes so that userspace cannot initiate I/O via file syscalls or
+ * mmap activity.
+ */
+int
+xfs_ilock2_io_mmap(
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
+/* Unlock both inodes to allow IO and mmap activity. */
+void
+xfs_iunlock2_io_mmap(
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
index 47d3b391030d..1534386b430c 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -499,4 +499,7 @@ void xfs_iunlink_destroy(struct xfs_perag *pag);
 
 void xfs_end_io(struct work_struct *work);
 
+int xfs_ilock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
+void xfs_iunlock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
+
 #endif	/* __XFS_INODE_H__ */
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 81190e963c8a..fac19d9bc083 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1226,99 +1226,6 @@ xfs_reflink_remap_blocks(
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
-/*
- * Lock two files so that userspace cannot initiate I/O via file syscalls or
- * mmap activity.
- */
-static int
-xfs_reflink_remap_lock(
-	struct xfs_inode	*ip1,
-	struct xfs_inode	*ip2)
-{
-	int			ret;
-
-	ret = xfs_iolock_two_inodes_and_break_layout(VFS_I(ip1), VFS_I(ip2));
-	if (ret)
-		return ret;
-	if (ip1 == ip2)
-		xfs_ilock(ip1, XFS_MMAPLOCK_EXCL);
-	else
-		xfs_lock_two_inodes(ip1, XFS_MMAPLOCK_EXCL,
-				    ip2, XFS_MMAPLOCK_EXCL);
-	return 0;
-}
-
-/* Unlock both files to allow IO and mmap activity. */
-void
-xfs_reflink_remap_unlock(
-	struct xfs_inode	*ip1,
-	struct xfs_inode	*ip2)
-{
-	bool			same_inode = (ip1 == ip2);
-
-	xfs_iunlock(ip2, XFS_MMAPLOCK_EXCL);
-	if (!same_inode)
-		xfs_iunlock(ip1, XFS_MMAPLOCK_EXCL);
-	inode_unlock(VFS_I(ip2));
-	if (!same_inode)
-		inode_unlock(VFS_I(ip1));
-}
-
 /*
  * If we're reflinking to a point past the destination file's EOF, we must
  * zero any speculative post-EOF preallocations that sit between the old EOF
@@ -1384,7 +1291,7 @@ xfs_reflink_remap_prep(
 	int			ret;
 
 	/* Lock both files against IO */
-	ret = xfs_reflink_remap_lock(src, dest);
+	ret = xfs_ilock2_io_mmap(src, dest);
 	if (ret)
 		return ret;
 
@@ -1437,7 +1344,7 @@ xfs_reflink_remap_prep(
 
 	return 0;
 out_unlock:
-	xfs_reflink_remap_unlock(src, dest);
+	xfs_iunlock2_io_mmap(src, dest);
 	return ret;
 }
 
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
index ceeb59b86b29..487b00434b96 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -56,6 +56,5 @@ extern int xfs_reflink_remap_blocks(struct xfs_inode *src, loff_t pos_in,
 		loff_t *remapped);
 extern int xfs_reflink_update_dest(struct xfs_inode *dest, xfs_off_t newlen,
 		xfs_extlen_t cowextsize, unsigned int remap_flags);
-extern void xfs_reflink_remap_unlock(struct xfs_inode *ip1, struct xfs_inode *ip2);
 
 #endif /* __XFS_REFLINK_H */

