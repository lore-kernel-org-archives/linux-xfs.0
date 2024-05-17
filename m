Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2827913DDB8
	for <linux-xfs@vger.kernel.org>; Fri, 17 May 2024 21:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715981187; cv=none; b=prf/bNcyy6edpMqfWe+OkZdzMbdFNNocxOdlk6gV7fnToGBHEFcQfa2n3Y9qMFrDW9z6dk3AAba/tXZlFN4bhCW6glJvAeCNczAYrS91dpEaLG4F0B6ejmvmVIqEYeQxBnIqPdvEF4ncs2DYK5kYcVfigYyTy1AlfHBwqPseg2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715981187; c=relaxed/simple;
	bh=2TJaf/b17bj7ipuDPEto6WFd5kYkRB0yIxLag8WLRDU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=pncObNNX0zIeyx4ppQdJT4W3J2dUEQgzQOozqQ76u7wACIjMSQDJS9J7/nQH7iBirShxRRVNG7PFQPsqokZis7fEyQuFr7CSDPStWfNUMzqKQGlnvHomjxFPWITgPq5Hj53NvNDXmH9vuyUnbNQqUTMVlaZ0uqgztct2pfke6po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nzzr1Eac; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nzzr1Eac"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44HI98he002404
	for <linux-xfs@vger.kernel.org>; Fri, 17 May 2024 21:26:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2023-11-20; bh=kqZzMV7hGeAJczbQotHOj117+Cz3JKVx8l4piOLr5g0=;
 b=nzzr1EachD3cedo3dU3NC6jI2XZvRbfha6HfFnaR2Fn1Gvp/AAH/50nCTr1KfNDalICA
 9f7WjF4vofyJUYxN+7bMlBIt6Fq94twtsk4Gi52gS+CXN6ZYSBkL1n9ejZ+QrFo7Ms9Q
 KiSBu/+18tLTcRZeOtp0iS1X4Qdiu/OTkp9oJjbvPjYyRNs527qK53l54WHcwT6nVmd+
 PBnim8V9VqzGDV7giNi2MBakcJHctDRcLKG+U6wzrLwKzyiiYFjqRFvkb1++0w0gSw7W
 cjkO3y1r9iOY+YzmSPqNH2vSctt+58c0TKY8U7iAmREmOXc56f0gjorzBB3GMkS24dHQ gg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3y3t4fjr5g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Fri, 17 May 2024 21:26:23 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44HJt5QK038451
	for <linux-xfs@vger.kernel.org>; Fri, 17 May 2024 21:26:22 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3y24q1w9q6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Fri, 17 May 2024 21:26:22 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 44HLQMdq002950
	for <linux-xfs@vger.kernel.org>; Fri, 17 May 2024 21:26:22 GMT
Received: from wwg-mac.us.oracle.com (dhcp-10-159-128-110.vpn.oracle.com [10.159.128.110])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3y24q1w9pu-1;
	Fri, 17 May 2024 21:26:22 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: linux-xfs@vger.kernel.org
Cc: wen.gang.wang@oracle.com
Subject: [PATCH] xfs: dont remain new blocks in cowfork for unshare
Date: Fri, 17 May 2024 14:26:21 -0700
Message-Id: <20240517212621.9394-1-wen.gang.wang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-17_10,2024-05-17_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 mlxscore=0
 spamscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2405170165
X-Proofpoint-ORIG-GUID: s1uwaiBDDyk_xhwdW5DKk_q3zPLsEiYK
X-Proofpoint-GUID: s1uwaiBDDyk_xhwdW5DKk_q3zPLsEiYK

Unsharing blocks is implemented by doing CoW to those blocks. That has a side
effect that some new allocatd blocks remain in inode Cow fork. As unsharing blocks
has no hint that future writes would like come to the blocks that follow the
unshared ones, the extra blocks in Cow fork is meaningless.

This patch makes that no new blocks caused by unshare remain in Cow fork.
The change in xfs_get_extsz_hint() makes the new blocks have more change to be
contigurous in unshare path when there are multiple extents to unshare.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/xfs/xfs_inode.c   | 17 ++++++++++++++++
 fs/xfs/xfs_inode.h   | 48 +++++++++++++++++++++++---------------------
 fs/xfs/xfs_reflink.c |  7 +++++--
 3 files changed, 47 insertions(+), 25 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index d55b42b2480d..ade945c8d783 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -58,6 +58,15 @@ xfs_get_extsz_hint(
 	 */
 	if (xfs_is_always_cow_inode(ip))
 		return 0;
+
+	/*
+	 * let xfs_buffered_write_iomap_begin() do delayed allocation
+	 * in unshare path so that the new blocks have more chance to
+	 * be contigurous
+	 */
+	if (xfs_iflags_test(ip, XFS_IUNSHARE))
+		return 0;
+
 	if ((ip->i_diflags & XFS_DIFLAG_EXTSIZE) && ip->i_extsize)
 		return ip->i_extsize;
 	if (XFS_IS_REALTIME_INODE(ip))
@@ -77,6 +86,14 @@ xfs_get_cowextsz_hint(
 {
 	xfs_extlen_t		a, b;
 
+	/*
+	 * in unshare path, allocate exactly the number of the blocks to be
+	 * unshared so that no new blocks caused the unshare operation remain
+	 * in Cow fork after the unshare is done
+	 */
+	if (xfs_iflags_test(ip, XFS_IUNSHARE))
+		return 1;
+
 	a = 0;
 	if (ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE)
 		a = ip->i_cowextsize;
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index ab46ffb3ac19..6a8ad68dac1e 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -207,13 +207,13 @@ xfs_new_eof(struct xfs_inode *ip, xfs_fsize_t new_size)
  * i_flags helper functions
  */
 static inline void
-__xfs_iflags_set(xfs_inode_t *ip, unsigned short flags)
+__xfs_iflags_set(xfs_inode_t *ip, unsigned long flags)
 {
 	ip->i_flags |= flags;
 }
 
 static inline void
-xfs_iflags_set(xfs_inode_t *ip, unsigned short flags)
+xfs_iflags_set(xfs_inode_t *ip, unsigned long flags)
 {
 	spin_lock(&ip->i_flags_lock);
 	__xfs_iflags_set(ip, flags);
@@ -221,7 +221,7 @@ xfs_iflags_set(xfs_inode_t *ip, unsigned short flags)
 }
 
 static inline void
-xfs_iflags_clear(xfs_inode_t *ip, unsigned short flags)
+xfs_iflags_clear(xfs_inode_t *ip, unsigned long flags)
 {
 	spin_lock(&ip->i_flags_lock);
 	ip->i_flags &= ~flags;
@@ -229,13 +229,13 @@ xfs_iflags_clear(xfs_inode_t *ip, unsigned short flags)
 }
 
 static inline int
-__xfs_iflags_test(xfs_inode_t *ip, unsigned short flags)
+__xfs_iflags_test(xfs_inode_t *ip, unsigned long flags)
 {
 	return (ip->i_flags & flags);
 }
 
 static inline int
-xfs_iflags_test(xfs_inode_t *ip, unsigned short flags)
+xfs_iflags_test(xfs_inode_t *ip, unsigned long flags)
 {
 	int ret;
 	spin_lock(&ip->i_flags_lock);
@@ -245,7 +245,7 @@ xfs_iflags_test(xfs_inode_t *ip, unsigned short flags)
 }
 
 static inline int
-xfs_iflags_test_and_clear(xfs_inode_t *ip, unsigned short flags)
+xfs_iflags_test_and_clear(xfs_inode_t *ip, unsigned long flags)
 {
 	int ret;
 
@@ -258,7 +258,7 @@ xfs_iflags_test_and_clear(xfs_inode_t *ip, unsigned short flags)
 }
 
 static inline int
-xfs_iflags_test_and_set(xfs_inode_t *ip, unsigned short flags)
+xfs_iflags_test_and_set(xfs_inode_t *ip, unsigned long flags)
 {
 	int ret;
 
@@ -321,25 +321,25 @@ static inline bool xfs_inode_has_large_extent_counts(struct xfs_inode *ip)
 /*
  * In-core inode flags.
  */
-#define XFS_IRECLAIM		(1 << 0) /* started reclaiming this inode */
-#define XFS_ISTALE		(1 << 1) /* inode has been staled */
-#define XFS_IRECLAIMABLE	(1 << 2) /* inode can be reclaimed */
-#define XFS_INEW		(1 << 3) /* inode has just been allocated */
-#define XFS_IPRESERVE_DM_FIELDS	(1 << 4) /* has legacy DMAPI fields set */
-#define XFS_ITRUNCATED		(1 << 5) /* truncated down so flush-on-close */
-#define XFS_IDIRTY_RELEASE	(1 << 6) /* dirty release already seen */
-#define XFS_IFLUSHING		(1 << 7) /* inode is being flushed */
+#define XFS_IRECLAIM		(1UL << 0) /* started reclaiming this inode */
+#define XFS_ISTALE		(1UL << 1) /* inode has been staled */
+#define XFS_IRECLAIMABLE	(1UL<< 2) /* inode can be reclaimed */
+#define XFS_INEW		(1UL<< 3) /* inode has just been allocated */
+#define XFS_IPRESERVE_DM_FIELDS	(1UL << 4) /* has legacy DMAPI fields set */
+#define XFS_ITRUNCATED		(1UL << 5) /* truncated down so flush-on-close */
+#define XFS_IDIRTY_RELEASE	(1UL << 6) /* dirty release already seen */
+#define XFS_IFLUSHING		(1UL << 7) /* inode is being flushed */
 #define __XFS_IPINNED_BIT	8	 /* wakeup key for zero pin count */
-#define XFS_IPINNED		(1 << __XFS_IPINNED_BIT)
-#define XFS_IEOFBLOCKS		(1 << 9) /* has the preallocblocks tag set */
-#define XFS_NEED_INACTIVE	(1 << 10) /* see XFS_INACTIVATING below */
+#define XFS_IPINNED		(1UL << __XFS_IPINNED_BIT)UL
+#define XFS_IEOFBLOCKS		(1UL << 9) /* has the preallocblocks tag set */
+#define XFS_NEED_INACTIVE	(1UL << 10) /* see XFS_INACTIVATING below */
 /*
  * If this unlinked inode is in the middle of recovery, don't let drop_inode
  * truncate and free the inode.  This can happen if we iget the inode during
  * log recovery to replay a bmap operation on the inode.
  */
-#define XFS_IRECOVERY		(1 << 11)
-#define XFS_ICOWBLOCKS		(1 << 12)/* has the cowblocks tag set */
+#define XFS_IRECOVERY		(1UL << 11)
+#define XFS_ICOWBLOCKS		(1UL << 12)/* has the cowblocks tag set */
 
 /*
  * If we need to update on-disk metadata before this IRECLAIMABLE inode can be
@@ -348,10 +348,10 @@ static inline bool xfs_inode_has_large_extent_counts(struct xfs_inode *ip)
  * inactivation completes, both flags will be cleared and the inode is a
  * plain old IRECLAIMABLE inode.
  */
-#define XFS_INACTIVATING	(1 << 13)
+#define XFS_INACTIVATING	(1UL << 13)
 
 /* Quotacheck is running but inode has not been added to quota counts. */
-#define XFS_IQUOTAUNCHECKED	(1 << 14)
+#define XFS_IQUOTAUNCHECKED	(1UL << 14)
 
 /*
  * Remap in progress. Callers that wish to update file data while
@@ -359,7 +359,9 @@ static inline bool xfs_inode_has_large_extent_counts(struct xfs_inode *ip)
  * the lock in exclusive mode. Relocking the file will block until
  * IREMAPPING is cleared.
  */
-#define XFS_IREMAPPING		(1U << 15)
+#define XFS_IREMAPPING		(1UL << 15)
+
+#define XFS_IUNSHARE		(1UL << 16) /* file under unsharing */
 
 /* All inode state flags related to inode reclaim. */
 #define XFS_ALL_IRECLAIM_FLAGS	(XFS_IRECLAIMABLE | \
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 7da0e8f961d3..7867e4a80b16 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1703,12 +1703,15 @@ xfs_reflink_unshare(
 
 	inode_dio_wait(inode);
 
-	if (IS_DAX(inode))
+	if (IS_DAX(inode)) {
 		error = dax_file_unshare(inode, offset, len,
 				&xfs_dax_write_iomap_ops);
-	else
+	} else {
+		xfs_iflags_set(ip, XFS_IUNSHARE);
 		error = iomap_file_unshare(inode, offset, len,
 				&xfs_buffered_write_iomap_ops);
+		xfs_iflags_clear(ip, XFS_IUNSHARE);
+	}
 	if (error)
 		goto out;
 
-- 
2.39.3 (Apple Git-146)

