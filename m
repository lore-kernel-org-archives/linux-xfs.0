Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6214AC433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 01:46:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3AB19611C6
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 01:46:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233367AbhIPBsP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 21:48:15 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:33185 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233564AbhIPBsO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Sep 2021 21:48:14 -0400
Received: from dread.disaster.area (pa49-195-238-16.pa.nsw.optusnet.com.au [49.195.238.16])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 8ACE788A6E
        for <linux-xfs@vger.kernel.org>; Thu, 16 Sep 2021 11:46:53 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mQgUG-00CySd-WC
        for linux-xfs@vger.kernel.org; Thu, 16 Sep 2021 11:46:53 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95-RC2)
        (envelope-from <david@fromorbit.com>)
        id 1mQgUG-007hWs-Uo
        for linux-xfs@vger.kernel.org;
        Thu, 16 Sep 2021 11:46:52 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/5] libxfs: add spinlock_t wrapper
Date:   Thu, 16 Sep 2021 11:46:46 +1000
Message-Id: <20210916014649.1835564-3-david@fromorbit.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916014649.1835564-1-david@fromorbit.com>
References: <20210916013707.GQ2361455@dread.disaster.area>
 <20210916014649.1835564-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=DzKKRZjfViQTE5W6EVc0VA==:117 a=DzKKRZjfViQTE5W6EVc0VA==:17
        a=7QKq2e-ADPsA:10 a=20KFwNOVAAAA:8 a=Ab2Hbm8BP3q4J0kLDiQA:9
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
index bc07655e64f1..a494a1d4b002 100644
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
index 0551fe457d0c..08a62d833372 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -43,6 +43,7 @@ struct inode {
 	struct timespec64	i_atime;
 	struct timespec64	i_mtime;
 	struct timespec64	i_ctime;
+	spinlock_t		i_lock;
 };
 
 static inline uint32_t i_uid_read(struct inode *inode)
diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index 12019c4b4dbd..2f3208802575 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -22,6 +22,7 @@ typedef struct xfs_mount {
 #define m_icount	m_sb.sb_icount
 #define m_ifree		m_sb.sb_ifree
 #define m_fdblocks	m_sb.sb_fdblocks
+	spinlock_t		m_sb_lock;
 
 	/*
 	 * Bitsets of per-fs metadata that have been checked and/or are sick.
@@ -32,6 +33,7 @@ typedef struct xfs_mount {
 
 	char			*m_fsname;	/* filesystem name */
 	int			m_bsize;	/* fs logical block size */
+	spinlock_t		m_agirotor_lock;
 	xfs_agnumber_t		m_agfrotor;	/* last ag where space found */
 	xfs_agnumber_t		m_agirotor;	/* last ag dir inode alloced */
 	xfs_agnumber_t		m_maxagi;	/* highest inode alloc group */
diff --git a/include/xfs_trans.h b/include/xfs_trans.h
index ad76ecfddebc..2c55bb857369 100644
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
index b06faf8acdde..2c54546bcdda 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -743,7 +743,9 @@ libxfs_mount(
 	mp->m_flags = (LIBXFS_MOUNT_32BITINODES|LIBXFS_MOUNT_32BITINOOPT);
 	mp->m_sb = *sb;
 	INIT_RADIX_TREE(&mp->m_perag_tree, GFP_KERNEL);
-	sbp = &(mp->m_sb);
+	sbp = &mp->m_sb;
+	spin_lock_init(&mp->m_sb_lock);
+	spin_lock_init(&mp->m_agirotor_lock);
 
 	xfs_sb_mount_common(mp, sb);
 
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index db90e173f36e..e1e90268c0b7 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -48,6 +48,7 @@
 #include "kmem.h"
 #include "libfrog/radix-tree.h"
 #include "atomic.h"
+#include "spinlock.h"
 
 #include "xfs_types.h"
 #include "xfs_arch.h"
@@ -205,9 +206,6 @@ enum ce { CE_DEBUG, CE_CONT, CE_NOTE, CE_WARN, CE_ALERT, CE_PANIC };
 #endif
 
 /* miscellaneous kernel routines not in user space */
-#define spin_lock_init(a)	((void) 0)
-#define spin_lock(a)		((void) 0)
-#define spin_unlock(a)		((void) 0)
 #define likely(x)		(x)
 #define unlikely(x)		(x)
 
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 713ef9afc8c6..a5fd0596687e 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -1070,6 +1070,8 @@ libxfs_iget(
 	VFS_I(ip)->i_count = 1;
 	ip->i_ino = ino;
 	ip->i_mount = mp;
+	spin_lock_init(&VFS_I(ip)->i_lock);
+
 	error = xfs_imap(mp, tp, ip->i_ino, &ip->i_imap, 0);
 	if (error)
 		goto out_destroy;
-- 
2.33.0

