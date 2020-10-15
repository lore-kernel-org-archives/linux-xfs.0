Return-Path: <SRS0=m1l6=DW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D22ADC43467
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 07:22:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 885562224E
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 07:22:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728691AbgJOHWJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Oct 2020 03:22:09 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:34910 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728911AbgJOHWE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 03:22:04 -0400
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 166D758C4D7
        for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2020 18:21:57 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kSxaG-000hvS-Ji
        for linux-xfs@vger.kernel.org; Thu, 15 Oct 2020 18:21:56 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1kSxaG-006qLj-CG
        for linux-xfs@vger.kernel.org; Thu, 15 Oct 2020 18:21:56 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 08/27] libxfs: add spinlock_t wrapper
Date:   Thu, 15 Oct 2020 18:21:36 +1100
Message-Id: <20201015072155.1631135-9-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201015072155.1631135-1-david@fromorbit.com>
References: <20201015072155.1631135-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Ubgvt5aN c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=afefHYAZSVUA:10 a=20KFwNOVAAAA:8 a=Ab2Hbm8BP3q4J0kLDiQA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

These provide the kernel spinlock_t interface, but are *not*
spinlocks. Spinlocks cannot be used by general purpose userspace
processes due to the fact they cannot control task preemption and
scheduling reliability. Hence these are implemented as a
pthread_mutex_t, similar to the way the kernel RT build implements
spinlock_t as a kernel mutex.

Because the current libxfs spinlock "implementation" just makes
spinlocks go away, we have to also add initialisation to spinlocks
that libxfs uses that are missing from the userspace implementation.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/Makefile     |  1 +
 include/libxfs.h     |  1 +
 include/spinlock.h   | 25 +++++++++++++++++++++++++
 include/xfs_inode.h  |  1 +
 include/xfs_mount.h  |  2 ++
 include/xfs_trans.h  |  1 +
 libxfs/init.c        |  4 +++-
 libxfs/libxfs_priv.h |  4 +---
 libxfs/rdwr.c        |  2 ++
 9 files changed, 37 insertions(+), 4 deletions(-)
 create mode 100644 include/spinlock.h

diff --git a/include/Makefile b/include/Makefile
index 632b819fcded..f7c40a5ce1a1 100644
--- a/include/Makefile
+++ b/include/Makefile
@@ -16,6 +16,7 @@ LIBHFILES = libxfs.h \
 	kmem.h \
 	list.h \
 	parent.h \
+	spinlock.h \
 	xfs_inode.h \
 	xfs_log_recover.h \
 	xfs_metadump.h \
diff --git a/include/libxfs.h b/include/libxfs.h
index eb2db7f9647d..caf4a5139469 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -18,6 +18,7 @@
 #include "kmem.h"
 #include "libfrog/radix-tree.h"
 #include "atomic.h"
+#include "spinlock.h"
 
 #include "xfs_types.h"
 #include "xfs_fs.h"
diff --git a/include/spinlock.h b/include/spinlock.h
new file mode 100644
index 000000000000..8da2325cc8f5
--- /dev/null
+++ b/include/spinlock.h
@@ -0,0 +1,25 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2019-20 RedHat, Inc.
+ * All Rights Reserved.
+ */
+#ifndef __LIBXFS_SPINLOCK_H__
+#define __LIBXFS_SPINLOCK_H__
+
+/*
+ * This implements kernel compatible spinlock exclusion semantics. These,
+ * however, are not spinlocks, as spinlocks cannot be reliably implemented in
+ * userspace without using realtime scheduling task contexts. Hence this
+ * interface is implemented with pthread mutexes and so can block, but this is
+ * no different to the kernel RT build which replaces spinlocks with mutexes.
+ * Hence we know it works.
+ */
+
+typedef pthread_mutex_t	spinlock_t;
+
+#define spin_lock_init(l)	pthread_mutex_init(l, NULL)
+#define spin_lock(l)           pthread_mutex_lock(l)
+#define spin_trylock(l)        (pthread_mutex_trylock(l) != EBUSY)
+#define spin_unlock(l)         pthread_mutex_unlock(l)
+
+#endif /* __LIBXFS_SPINLOCK_H__ */
diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index 588d8c7258f4..29086a7d5e2e 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -42,6 +42,7 @@ struct inode {
 	struct timespec	i_atime;
 	struct timespec	i_mtime;
 	struct timespec	i_ctime;
+	spinlock_t	i_lock;
 };
 
 static inline uint32_t i_uid_read(struct inode *inode)
diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index 20c8bfaf4fa8..d78c4cdc4f78 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -20,6 +20,7 @@ typedef struct xfs_mount {
 #define m_icount	m_sb.sb_icount
 #define m_ifree		m_sb.sb_ifree
 #define m_fdblocks	m_sb.sb_fdblocks
+	spinlock_t		m_sb_lock;
 
 	/*
 	 * Bitsets of per-fs metadata that have been checked and/or are sick.
@@ -30,6 +31,7 @@ typedef struct xfs_mount {
 
 	char			*m_fsname;	/* filesystem name */
 	int			m_bsize;	/* fs logical block size */
+	spinlock_t		m_agirotor_lock;
 	xfs_agnumber_t		m_agfrotor;	/* last ag where space found */
 	xfs_agnumber_t		m_agirotor;	/* last ag dir inode alloced */
 	xfs_agnumber_t		m_maxagi;	/* highest inode alloc group */
diff --git a/include/xfs_trans.h b/include/xfs_trans.h
index 1f087672a2a8..9e6eae9ff483 100644
--- a/include/xfs_trans.h
+++ b/include/xfs_trans.h
@@ -35,6 +35,7 @@ struct xfs_inode_log_item {
 	unsigned int		ili_last_fields;	/* fields when flushed*/
 	unsigned int		ili_fields;		/* fields to be logged */
 	unsigned int		ili_fsync_fields;	/* ignored by userspace */
+	spinlock_t		ili_lock;
 };
 
 typedef struct xfs_buf_log_item {
diff --git a/libxfs/init.c b/libxfs/init.c
index 477487e985c4..fe784940c299 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -683,7 +683,9 @@ libxfs_mount(
 	mp->m_flags = (LIBXFS_MOUNT_32BITINODES|LIBXFS_MOUNT_32BITINOOPT);
 	mp->m_sb = *sb;
 	INIT_RADIX_TREE(&mp->m_perag_tree, GFP_KERNEL);
-	sbp = &(mp->m_sb);
+	sbp = &mp->m_sb;
+	spin_lock_init(&mp->m_sb_lock);
+	spin_lock_init(&mp->m_agirotor_lock);
 
 	xfs_sb_mount_common(mp, sb);
 
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 4cce1d680921..e134f65c5dd1 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -48,6 +48,7 @@
 #include "kmem.h"
 #include "libfrog/radix-tree.h"
 #include "atomic.h"
+#include "spinlock.h"
 
 #include "xfs_types.h"
 #include "xfs_arch.h"
@@ -189,9 +190,6 @@ enum ce { CE_DEBUG, CE_CONT, CE_NOTE, CE_WARN, CE_ALERT, CE_PANIC };
 #endif
 
 /* miscellaneous kernel routines not in user space */
-#define spin_lock_init(a)	((void) 0)
-#define spin_lock(a)		((void) 0)
-#define spin_unlock(a)		((void) 0)
 #define likely(x)		(x)
 #define unlikely(x)		(x)
 
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 174cbcac1250..5ab1987eb0fe 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -1062,6 +1062,8 @@ libxfs_iget(
 
 	ip->i_ino = ino;
 	ip->i_mount = mp;
+	spin_lock_init(&VFS_I(ip)->i_lock);
+
 	error = xfs_imap(mp, tp, ip->i_ino, &ip->i_imap, 0);
 	if (error)
 		goto out_destroy;
-- 
2.28.0

