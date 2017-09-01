Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:59470 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751009AbdIABAd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Aug 2017 21:00:33 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v8110OpT004399
        for <linux-xfs@vger.kernel.org>; Thu, 31 Aug 2017 18:00:33 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2cprn1s4qu-1
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Aug 2017 18:00:33 -0700
From: Richard Wareing <rwareing@fb.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: [PATCH 3/3] xfs: Add rtfallocmin mount option
Message-ID: <0C079CBF-235F-48A5-AAE3-0782C81B607D@fb.com>
Date: Thu, 31 Aug 2017 18:00:30 -0700
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

- Gates real-time block device fallocation's to rtfallocmin bytes
- Use case: Allows developers to send files to the SSD with ease simply
  by fallocating them, if they are below rtfallocmin XFS will allocate the
  blocks from the non-RT device (e.g. an SSD)
- Useful to automagically store small files on the SSD vs. RT device
  (HDD) for tiered XFS setups without having to rely on XFS specific
  ioctl calls.  Userland tools such as rsync can also use fallocation
  behavior to migrate files between SSD and RT (HDD) device without
  modifiction (e.g. w/ --preallocate flag).
---
 fs/xfs/xfs_file.c  | 16 ++++++++++++++++
 fs/xfs/xfs_mount.h |  1 +
 fs/xfs/xfs_super.c | 14 +++++++++++++-
 3 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 5fb5a09..a29f6e8 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -730,6 +730,7 @@ xfs_file_fallocate(
 {
 	struct inode		*inode = file_inode(file);
 	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_mount	*mp = ip->i_mount;
 	long			error;
 	enum xfs_prealloc_flags	flags = 0;
 	uint			iolock = XFS_IOLOCK_EXCL;
@@ -749,6 +750,21 @@ xfs_file_fallocate(
 	xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
 	iolock |= XFS_MMAPLOCK_EXCL;
 
+	/*
+	 * If fallocating a file < rtfallocmin store it on the non RT device.
+	 * In a tiered storage setup, this device might be a device suitable
+	 * for better small file storage/performance (e.g. SSD).
+	 */
+	if (mp->m_rtdev_targp && mp->m_rtfallocmin && !offset &&
+			!inode->i_size) {
+		if (len >= mp->m_rtfallocmin) {
+			ip->i_d.di_flags |= XFS_DIFLAG_REALTIME;
+		/* Clear flag if inheritence or rtdefault is being used */
+		} else {
+			ip->i_d.di_flags &= ~XFS_DIFLAG_REALTIME;
+		}
+	}
+
 	if (mode & FALLOC_FL_PUNCH_HOLE) {
 		error = xfs_free_file_space(ip, offset, len);
 		if (error)
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index e1a931a..e7f11c8 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -84,6 +84,7 @@ typedef struct xfs_mount {
 	char			*m_fsname;	/* filesystem name */
 	int			m_fsname_len;	/* strlen of fs name */
 	char			*m_rtname;	/* realtime device name */
+	int			m_rtfallocmin;  /* Min size for RT fallocate */
 	char			*m_logname;	/* external log device name */
 	int			m_bsize;	/* fs logical block size */
 	xfs_agnumber_t		m_agfrotor;	/* last ag where space found */
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index bcab840..d8710d6 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -84,7 +84,7 @@ enum {
 	Opt_uquota, Opt_gquota, Opt_pquota,
 	Opt_uqnoenforce, Opt_gqnoenforce, Opt_pqnoenforce, Opt_qnoenforce,
 	Opt_discard, Opt_nodiscard, Opt_dax, Opt_rtdefault, Opt_rtstatfs,
-	Opt_err,
+	Opt_rtfallocmin, Opt_err,
 };
 
 static const match_table_t tokens = {
@@ -137,6 +137,9 @@ static const match_table_t tokens = {
 #ifdef CONFIG_XFS_RT
 	{Opt_rtdefault,	"rtdefault"},	/* Default to real-time device */
 	{Opt_rtstatfs,	"rtstatfs"},	/* Use real-time device for statfs */
+	{Opt_rtfallocmin, "rtfallocmin=%u"}, /* Min fallocation required
+					      * for rt device
+					      */
 #endif
 	/* Deprecated mount options scheduled for removal */
 	{Opt_barrier,	"barrier"},	/* use writer barriers for log write and
@@ -378,6 +381,10 @@ xfs_parseargs(
                         break;
 		case Opt_rtstatfs:
 			mp->m_flags |= XFS_MOUNT_RTSTATFS;
+                        break;
+		case Opt_rtfallocmin:
+			if (match_int(args, &mp->m_rtfallocmin))
+				return -EINVAL;
 			break;
 #endif
 #ifdef CONFIG_FS_DAX
@@ -543,6 +550,11 @@ xfs_showargs(
 	if (mp->m_rtname)
 		seq_show_option(m, "rtdev", mp->m_rtname);
 
+#ifdef CONFIG_XFS_RT
+	if (mp->m_rtfallocmin > 0)
+		seq_printf(m, ",rtfallocmin=%d", mp->m_rtfallocmin);
+#endif
+
 	if (mp->m_dalign > 0)
 		seq_printf(m, ",sunit=%d",
 				(int)XFS_FSB_TO_BB(mp, mp->m_dalign));
-- 
2.9.3
