Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:49750 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753148AbdKVWkM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Nov 2017 17:40:12 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id vAMMe5Zq017886
        for <linux-xfs@vger.kernel.org>; Wed, 22 Nov 2017 14:40:12 -0800
Received: from mail.thefacebook.com ([199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2edhtj02pm-4
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Wed, 22 Nov 2017 14:40:12 -0800
From: Richard Wareing <rwareing@fb.com>
Subject: [PATCH RESEND v6 1/3] xfs: Show realtime device stats on statfs calls if inherit flag set
Date: Wed, 22 Nov 2017 14:40:07 -0800
Message-ID: <20171122224009.3533341-2-rwareing@fb.com>
In-Reply-To: <20171122224009.3533341-1-rwareing@fb.com>
References: <20171122224009.3533341-1-rwareing@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: david@fromorbit.com, darrick.wong@oracle.com, hch@infradead.org

- Reports realtime device free blocks in statfs calls if inheritance
  bit is set on the inode of directory.  This is a bit more intuitive,
  especially for use-cases which are using a much larger device for
  the realtime device.
- Add XFS_IS_REALTIME_MOUNT option to gate based on the existence of a
  realtime device on the mount, similar to the XFS_IS_REALTIME_INODE
  option.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Richard Wareing <rwareing@fb.com>
---
Changes since v5:
* None

Changes since v4:
* None

Changes since v3:
* Fixed accounting bug, we are not required to substract m_alloc_set_aside
  as this is a data device only requirement.
* Added XFS_IS_REALTIME_MOUNT macro based on learnings from CVE-2017-14340,
  now provides similar gating on the mount as XFS_IS_REALTIME_INODE does
  for the inode.

Changes since v2:
* Style updated per Christoph Hellwig's comment
* Fixed bug: statp->f_bavail = statp->f_bfree


 fs/xfs/xfs_linux.h | 2 ++
 fs/xfs/xfs_super.c | 8 ++++++++
 2 files changed, 10 insertions(+)

diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index dcd1292..944b02d 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -278,8 +278,10 @@ static inline uint64_t howmany_64(uint64_t x, uint32_t y)
 #define XFS_IS_REALTIME_INODE(ip)			\
 	(((ip)->i_d.di_flags & XFS_DIFLAG_REALTIME) &&	\
 	 (ip)->i_mount->m_rtdev_targp)
+#define XFS_IS_REALTIME_MOUNT(mp) ((mp)->m_rtdev_targp ? 1 : 0)
 #else
 #define XFS_IS_REALTIME_INODE(ip) (0)
+#define XFS_IS_REALTIME_MOUNT(mp) (0)
 #endif
 
 #endif /* __XFS_LINUX__ */
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index f663022..3c9a989 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1153,6 +1153,14 @@ xfs_fs_statfs(
 	    ((mp->m_qflags & (XFS_PQUOTA_ACCT|XFS_PQUOTA_ENFD))) ==
 			      (XFS_PQUOTA_ACCT|XFS_PQUOTA_ENFD))
 		xfs_qm_statvfs(ip, statp);
+
+	if (XFS_IS_REALTIME_MOUNT(mp) &&
+	    (ip->i_d.di_flags & XFS_DIFLAG_RTINHERIT)) {
+		statp->f_blocks = sbp->sb_rblocks;
+		statp->f_bavail = statp->f_bfree =
+			sbp->sb_frextents * sbp->sb_rextsize;
+	}
+
 	return 0;
 }
 
-- 
2.9.5

