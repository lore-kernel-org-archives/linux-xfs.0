Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:38501 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751009AbdIABAg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Aug 2017 21:00:36 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.21/8.16.0.21) with SMTP id v810vS4L021850
        for <linux-xfs@vger.kernel.org>; Thu, 31 Aug 2017 18:00:36 -0700
Received: from maileast.thefacebook.com ([199.201.65.23])
        by m0001303.ppops.net with ESMTP id 2cpq8psgnf-1
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Aug 2017 18:00:35 -0700
From: Richard Wareing <rwareing@fb.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: [PATCH 2/3] xfs: Add rtstatfs mount option
Message-ID: <1E472D47-4CB3-4B74-9AD6-4AB163CC9B35@fb.com>
Date: Thu, 31 Aug 2017 18:00:27 -0700
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

- Adds rtstatfs mount option to report real-time device free blocks for
  statfs calls.  In the event the real-time device is a large HDD, this
  will return the number of free blocks on the HDD vs. the SSD which is
  a bit more useful/important.
---
 fs/xfs/xfs_mount.h |  5 ++++-
 fs/xfs/xfs_super.c | 23 ++++++++++++++++++++---
 2 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index da25398..e1a931a 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -244,9 +244,12 @@ typedef struct xfs_mount {
 #define XFS_MOUNT_NOATTR2	(1ULL << 25)	/* disable use of attr2 format */
 
 /* FB Real-time device options */
+#define XFS_MOUNT_RTSTATFS	(1ULL << 60)	/* Use RT device for free
+						 * blocks w/ statfs
+						 */
 #define XFS_MOUNT_RTDEFAULT	(1ULL << 61)	/* Always allocate blocks from
 						 * RT device
-						 */
+                                                 */
 
 #define XFS_MOUNT_DAX		(1ULL << 62)	/* TEST ONLY! */
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index e4f85a9..bcab840 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -83,7 +83,8 @@ enum {
 	Opt_quota, Opt_noquota, Opt_usrquota, Opt_grpquota, Opt_prjquota,
 	Opt_uquota, Opt_gquota, Opt_pquota,
 	Opt_uqnoenforce, Opt_gqnoenforce, Opt_pqnoenforce, Opt_qnoenforce,
-	Opt_discard, Opt_nodiscard, Opt_dax, Opt_rtdefault, Opt_err,
+	Opt_discard, Opt_nodiscard, Opt_dax, Opt_rtdefault, Opt_rtstatfs,
+	Opt_err,
 };
 
 static const match_table_t tokens = {
@@ -135,6 +136,7 @@ static const match_table_t tokens = {
 
 #ifdef CONFIG_XFS_RT
 	{Opt_rtdefault,	"rtdefault"},	/* Default to real-time device */
+	{Opt_rtstatfs,	"rtstatfs"},	/* Use real-time device for statfs */
 #endif
 	/* Deprecated mount options scheduled for removal */
 	{Opt_barrier,	"barrier"},	/* use writer barriers for log write and
@@ -373,6 +375,9 @@ xfs_parseargs(
 #ifdef CONFIG_XFS_RT
 		case Opt_rtdefault:
 			mp->m_flags |= XFS_MOUNT_RTDEFAULT;
+                        break;
+		case Opt_rtstatfs:
+			mp->m_flags |= XFS_MOUNT_RTSTATFS;
 			break;
 #endif
 #ifdef CONFIG_FS_DAX
@@ -502,6 +507,7 @@ xfs_showargs(
 		{ XFS_MOUNT_DAX,		",dax" },
 #ifdef CONFIG_XFS_RT
 		{ XFS_MOUNT_RTDEFAULT,          ",rtdefault" },
+		{ XFS_MOUNT_RTSTATFS,           ",rtstatfs" },
 #endif
 		{ 0, NULL }
 	};
@@ -1120,10 +1126,21 @@ xfs_fs_statfs(
 	spin_lock(&mp->m_sb_lock);
 	statp->f_bsize = sbp->sb_blocksize;
 	lsize = sbp->sb_logstart ? sbp->sb_logblocks : 0;
-	statp->f_blocks = sbp->sb_dblocks - lsize;
+
+	/*
+	 * If rtstatfs mount option is used, fill in kstatfs (statp)
+	 * struct with free block data from real-time device.
+	 */
+	if (mp->m_rtdev_targp != NULL && mp->m_flags & XFS_MOUNT_RTSTATFS) {
+		statp->f_blocks = sbp->sb_rblocks;
+		statp->f_bfree = sbp->sb_frextents * sbp->sb_rextsize -
+			mp->m_alloc_set_aside;
+	} else {
+		statp->f_blocks = sbp->sb_dblocks - lsize;
+		statp->f_bfree = fdblocks - mp->m_alloc_set_aside;
+	}
 	spin_unlock(&mp->m_sb_lock);
 
-	statp->f_bfree = fdblocks - mp->m_alloc_set_aside;
 	statp->f_bavail = statp->f_bfree;
 
 	fakeinos = statp->f_bfree << sbp->sb_inopblog;
-- 
2.9.3

