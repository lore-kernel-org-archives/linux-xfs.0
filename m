Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:33314 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727519AbeJWPIH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Oct 2018 11:08:07 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w9N6d22X146834
        for <linux-xfs@vger.kernel.org>; Tue, 23 Oct 2018 02:46:04 -0400
Received: from e16.ny.us.ibm.com (e16.ny.us.ibm.com [129.33.205.206])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2n9tfc927a-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Tue, 23 Oct 2018 02:46:04 -0400
Received: from localhost
        by e16.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Tue, 23 Oct 2018 02:46:03 -0400
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [PATCH] xfs: flush CoW fork reservations before processing quota get request
Date: Tue, 23 Oct 2018 12:18:08 +0530
Message-Id: <20181023064808.23374-1-chandan@linux.vnet.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, darrick.wong@oracle.com

generic/305 fails on a 64k block sized filesystem due to the following
interaction,

1. We are writing 8 blocks (i.e. [0, 512k-1]) of data to a 1 MiB file.
2. XFS reserves 32 blocks of space in the CoW fork.
   xfs_bmap_extsize_align() calculates XFS_DEFAULT_COWEXTSZ_HINT (32
   blocks) as the number of blocks to be reserved.
3. The reserved space in the range [1M(i.e. i_size), 1M + 16
   blocks] is  freed by __fput(). This corresponds to freeing "eof
   blocks" i.e. space reserved beyond EOF of a file.

The reserved space to which data was never written i.e. [9th block,
1M(EOF)], remains reserved in the CoW fork until either the CoW block
reservation trimming worker gets invoked or the filesystem is
unmounted.

This commit fixes the issue by freeing unused CoW block reservations
whenever quota numbers are requested by userspace application.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---

PS: With the above patch, the tests xfs/214 & xfs/440 fail because the
value passed to xfs_io's cowextsize does not have any effect when CoW
fork reservations are flushed before querying for quota usage numbers.

fs/xfs/xfs_quotaops.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
index a7c0c65..9236a38 100644
--- a/fs/xfs/xfs_quotaops.c
+++ b/fs/xfs/xfs_quotaops.c
@@ -218,14 +218,21 @@ xfs_fs_get_dqblk(
 	struct kqid		qid,
 	struct qc_dqblk		*qdq)
 {
+	int			ret;
 	struct xfs_mount	*mp = XFS_M(sb);
 	xfs_dqid_t		id;
+	struct xfs_eofblocks	eofb = { 0 };
 
 	if (!XFS_IS_QUOTA_RUNNING(mp))
 		return -ENOSYS;
 	if (!XFS_IS_QUOTA_ON(mp))
 		return -ESRCH;
 
+	eofb.eof_flags = XFS_EOF_FLAGS_SYNC;
+	ret = xfs_icache_free_cowblocks(mp, &eofb);
+	if (ret)
+		return ret;
+
 	id = from_kqid(&init_user_ns, qid);
 	return xfs_qm_scall_getquota(mp, id, xfs_quota_type(qid.type), qdq);
 }
@@ -240,12 +247,18 @@ xfs_fs_get_nextdqblk(
 	int			ret;
 	struct xfs_mount	*mp = XFS_M(sb);
 	xfs_dqid_t		id;
+	struct xfs_eofblocks	eofb = { 0 };
 
 	if (!XFS_IS_QUOTA_RUNNING(mp))
 		return -ENOSYS;
 	if (!XFS_IS_QUOTA_ON(mp))
 		return -ESRCH;
 
+	eofb.eof_flags = XFS_EOF_FLAGS_SYNC;
+	ret = xfs_icache_free_cowblocks(mp, &eofb);
+	if (ret)
+		return ret;
+
 	id = from_kqid(&init_user_ns, *qid);
 	ret = xfs_qm_scall_getquota_next(mp, &id, xfs_quota_type(qid->type),
 			qdq);
-- 
2.9.5
