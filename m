Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:34898 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390376AbfFLGuG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Jun 2019 02:50:06 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5C6n0Gd055467
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jun 2019 06:50:05 GMT
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2t05nqsby8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jun 2019 06:50:05 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5C6mdHu099116
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jun 2019 06:50:04 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2t0p9rq3a9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jun 2019 06:50:04 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5C6o3D9007490
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jun 2019 06:50:03 GMT
Subject: [PATCH 9/9] xfs: allow bulkstat_single of special inodes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 11 Jun 2019 23:50:01 -0700
Message-ID: <156032220182.3774581.1524699549367116132.stgit@magnolia>
In-Reply-To: <156032214432.3774581.1304900948974476604.stgit@magnolia>
References: <156032214432.3774581.1304900948974476604.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, allison.henderson@oracle.com

From: Darrick J. Wong <darrick.wong@oracle.com>

Create a new ireq flag (for single bulkstats) that enables userspace to
ask us for a special inode number instead of interpreting @ino as a
literal inode number.  This enables us to query the root inode easily.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_fs.h |   11 ++++++++++-
 fs/xfs/xfs_ioctl.c     |   10 ++++++++++
 2 files changed, 20 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 77c06850ac52..1489bce07d66 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -482,7 +482,16 @@ struct xfs_ireq {
 	uint64_t	reserved[2];	/* must be zero			*/
 };
 
-#define XFS_IREQ_FLAGS_ALL	(0)
+/*
+ * The @ino value is a special value, not a literal inode number.  See the
+ * XFS_IREQ_SPECIAL_* values below.
+ */
+#define XFS_IREQ_SPECIAL	(1 << 0)
+
+#define XFS_IREQ_FLAGS_ALL	(XFS_IREQ_SPECIAL)
+
+/* Operate on the root directory inode. */
+#define XFS_IREQ_SPECIAL_ROOT	(1)
 
 /*
  * ioctl structures for v5 bulkstat and inumbers requests
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index f71341cd8340..3bb5f980fabf 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -961,6 +961,16 @@ xfs_ireq_setup(
 	    memchr_inv(hdr->reserved, 0, sizeof(hdr->reserved)))
 		return -EINVAL;
 
+	if (hdr->flags & XFS_IREQ_SPECIAL) {
+		switch (hdr->ino) {
+		case XFS_IREQ_SPECIAL_ROOT:
+			hdr->ino = mp->m_sb.sb_rootino;
+			break;
+		default:
+			return -EINVAL;
+		}
+	}
+
 	if (XFS_INO_TO_AGNO(mp, hdr->ino) >= mp->m_sb.sb_agcount)
 		return -EINVAL;
 
