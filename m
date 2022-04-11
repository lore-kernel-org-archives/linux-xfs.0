Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E029EC433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Apr 2022 00:32:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240793AbiDKAeN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 10 Apr 2022 20:34:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235477AbiDKAeI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Apr 2022 20:34:08 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BB3F6DF7B
        for <linux-xfs@vger.kernel.org>; Sun, 10 Apr 2022 17:31:55 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-233-190.pa.vic.optusnet.com.au [49.186.233.190])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 80AE710CE8A4
        for <linux-xfs@vger.kernel.org>; Mon, 11 Apr 2022 10:31:50 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ndhy9-00GEMz-FX
        for linux-xfs@vger.kernel.org; Mon, 11 Apr 2022 10:31:49 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1ndhy9-008pjh-EZ
        for linux-xfs@vger.kernel.org;
        Mon, 11 Apr 2022 10:31:49 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 13/17] xfs: convert inode lock flags to unsigned.
Date:   Mon, 11 Apr 2022 10:31:43 +1000
Message-Id: <20220411003147.2104423-14-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220411003147.2104423-1-david@fromorbit.com>
References: <20220411003147.2104423-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=625376f6
        a=bHAvQTfMiaNt/bo4vVGwyA==:117 a=bHAvQTfMiaNt/bo4vVGwyA==:17
        a=z0gMJWrwH1QA:10 a=20KFwNOVAAAA:8 a=dZ_Rv8cH-hu2rEWN-S0A:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

5.18 w/ std=gnu11 compiled with gcc-5 wants flags stored in unsigned
fields to be unsigned.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_file.c  | 12 ++++++------
 fs/xfs/xfs_inode.c | 21 ++++++++++++---------
 fs/xfs/xfs_inode.h | 16 ++++++++--------
 3 files changed, 26 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 5bddb1e9e0b3..f3e878408747 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -310,7 +310,7 @@ STATIC ssize_t
 xfs_file_write_checks(
 	struct kiocb		*iocb,
 	struct iov_iter		*from,
-	int			*iolock)
+	unsigned int		*iolock)
 {
 	struct file		*file = iocb->ki_filp;
 	struct inode		*inode = file->f_mapping->host;
@@ -513,7 +513,7 @@ xfs_file_dio_write_aligned(
 	struct kiocb		*iocb,
 	struct iov_iter		*from)
 {
-	int			iolock = XFS_IOLOCK_SHARED;
+	unsigned int		iolock = XFS_IOLOCK_SHARED;
 	ssize_t			ret;
 
 	ret = xfs_ilock_iocb(iocb, iolock);
@@ -566,7 +566,7 @@ xfs_file_dio_write_unaligned(
 {
 	size_t			isize = i_size_read(VFS_I(ip));
 	size_t			count = iov_iter_count(from);
-	int			iolock = XFS_IOLOCK_SHARED;
+	unsigned int		iolock = XFS_IOLOCK_SHARED;
 	unsigned int		flags = IOMAP_DIO_OVERWRITE_ONLY;
 	ssize_t			ret;
 
@@ -655,7 +655,7 @@ xfs_file_dax_write(
 {
 	struct inode		*inode = iocb->ki_filp->f_mapping->host;
 	struct xfs_inode	*ip = XFS_I(inode);
-	int			iolock = XFS_IOLOCK_EXCL;
+	unsigned int		iolock = XFS_IOLOCK_EXCL;
 	ssize_t			ret, error = 0;
 	loff_t			pos;
 
@@ -700,7 +700,7 @@ xfs_file_buffered_write(
 	struct xfs_inode	*ip = XFS_I(inode);
 	ssize_t			ret;
 	bool			cleared_space = false;
-	int			iolock;
+	unsigned int		iolock;
 
 	if (iocb->ki_flags & IOCB_NOWAIT)
 		return -EOPNOTSUPP;
@@ -1181,7 +1181,7 @@ xfs_dir_open(
 	struct file	*file)
 {
 	struct xfs_inode *ip = XFS_I(inode);
-	int		mode;
+	unsigned int	mode;
 	int		error;
 
 	error = xfs_file_open(inode, file);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 9de6205fe134..5ea460f62201 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -416,10 +416,12 @@ xfs_lockdep_subclass_ok(
  * parent locking. Care must be taken to ensure we don't overrun the subclass
  * storage fields in the class mask we build.
  */
-static inline int
-xfs_lock_inumorder(int lock_mode, int subclass)
+static inline uint
+xfs_lock_inumorder(
+	uint	lock_mode,
+	uint	subclass)
 {
-	int	class = 0;
+	uint	class = 0;
 
 	ASSERT(!(lock_mode & (XFS_ILOCK_PARENT | XFS_ILOCK_RTBITMAP |
 			      XFS_ILOCK_RTSUM)));
@@ -464,7 +466,10 @@ xfs_lock_inodes(
 	int			inodes,
 	uint			lock_mode)
 {
-	int			attempts = 0, i, j, try_lock;
+	int			attempts = 0;
+	uint			i;
+	int			j;
+	bool			try_lock;
 	struct xfs_log_item	*lp;
 
 	/*
@@ -489,9 +494,9 @@ xfs_lock_inodes(
 	} else if (lock_mode & XFS_MMAPLOCK_EXCL)
 		ASSERT(!(lock_mode & XFS_ILOCK_EXCL));
 
-	try_lock = 0;
-	i = 0;
 again:
+	try_lock = false;
+	i = 0;
 	for (; i < inodes; i++) {
 		ASSERT(ips[i]);
 
@@ -506,7 +511,7 @@ xfs_lock_inodes(
 			for (j = (i - 1); j >= 0 && !try_lock; j--) {
 				lp = &ips[j]->i_itemp->ili_item;
 				if (lp && test_bit(XFS_LI_IN_AIL, &lp->li_flags))
-					try_lock++;
+					try_lock = true;
 			}
 		}
 
@@ -546,8 +551,6 @@ xfs_lock_inodes(
 		if ((attempts % 5) == 0) {
 			delay(1); /* Don't just spin the CPU */
 		}
-		i = 0;
-		try_lock = 0;
 		goto again;
 	}
 }
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 740ab13d1aa2..172dba285c37 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -278,12 +278,12 @@ static inline bool xfs_inode_has_bigtime(struct xfs_inode *ip)
  * Bit ranges:	1<<1  - 1<<16-1 -- iolock/ilock modes (bitfield)
  *		1<<16 - 1<<32-1 -- lockdep annotation (integers)
  */
-#define	XFS_IOLOCK_EXCL		(1<<0)
-#define	XFS_IOLOCK_SHARED	(1<<1)
-#define	XFS_ILOCK_EXCL		(1<<2)
-#define	XFS_ILOCK_SHARED	(1<<3)
-#define	XFS_MMAPLOCK_EXCL	(1<<4)
-#define	XFS_MMAPLOCK_SHARED	(1<<5)
+#define	XFS_IOLOCK_EXCL		(1u << 0)
+#define	XFS_IOLOCK_SHARED	(1u << 1)
+#define	XFS_ILOCK_EXCL		(1u << 2)
+#define	XFS_ILOCK_SHARED	(1u << 3)
+#define	XFS_MMAPLOCK_EXCL	(1u << 4)
+#define	XFS_MMAPLOCK_SHARED	(1u << 5)
 
 #define XFS_LOCK_MASK		(XFS_IOLOCK_EXCL | XFS_IOLOCK_SHARED \
 				| XFS_ILOCK_EXCL | XFS_ILOCK_SHARED \
@@ -350,12 +350,12 @@ static inline bool xfs_inode_has_bigtime(struct xfs_inode *ip)
  */
 #define XFS_IOLOCK_SHIFT		16
 #define XFS_IOLOCK_MAX_SUBCLASS		3
-#define XFS_IOLOCK_DEP_MASK		0x000f0000
+#define XFS_IOLOCK_DEP_MASK		0x000f0000u
 
 #define XFS_MMAPLOCK_SHIFT		20
 #define XFS_MMAPLOCK_NUMORDER		0
 #define XFS_MMAPLOCK_MAX_SUBCLASS	3
-#define XFS_MMAPLOCK_DEP_MASK		0x00f00000
+#define XFS_MMAPLOCK_DEP_MASK		0x00f00000u
 
 #define XFS_ILOCK_SHIFT			24
 #define XFS_ILOCK_PARENT_VAL		5
-- 
2.35.1

