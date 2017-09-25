Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:34297 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S934788AbdIYToW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Sep 2017 15:44:22 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.21/8.16.0.21) with SMTP id v8PJfdub018552
        for <linux-xfs@vger.kernel.org>; Mon, 25 Sep 2017 12:44:21 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
        by m0001303.ppops.net with ESMTP id 2d77gd85qb-4
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Mon, 25 Sep 2017 12:44:21 -0700
From: Richard Wareing <rwareing@fb.com>
Subject: [PATCH v5 1/3] xfs: Show realtime device stats on statfs calls if inherit flag set
Date: Mon, 25 Sep 2017 12:44:16 -0700
Message-ID: <20170925194418.720146-2-rwareing@fb.com>
In-Reply-To: <20170925194418.720146-1-rwareing@fb.com>
References: <20170925194418.720146-1-rwareing@fb.com>
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

Signed-off-by: Richard Wareing <rwareing@fb.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
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
index 044fb0e..fe46e71 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -280,8 +280,10 @@ static inline __uint64_t howmany_64(__uint64_t x, __uint32_t y)
 
 #ifdef CONFIG_XFS_RT
 #define XFS_IS_REALTIME_INODE(ip) ((ip)->i_d.di_flags & XFS_DIFLAG_REALTIME)
+#define XFS_IS_REALTIME_MOUNT(mp) ((mp)->m_rtdev_targp ? 1 : 0)
 #else
 #define XFS_IS_REALTIME_INODE(ip) (0)
+#define XFS_IS_REALTIME_MOUNT(mp) (0)
 #endif
 
 #endif /* __XFS_LINUX__ */
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 455a575..6d33a5e 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1136,6 +1136,14 @@ xfs_fs_statfs(
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

