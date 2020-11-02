Return-Path: <SRS0=AlMJ=EI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86A90C00A89
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Nov 2020 19:42:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1BE0C20786
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Nov 2020 19:42:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KjDwl6IB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725838AbgKBTmr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Nov 2020 14:42:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:29499 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725824AbgKBTmr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Nov 2020 14:42:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604346164;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GK+6caFWaFH5t2N79/Q2f7WbYR/SrAJzjXNlpLzlYHA=;
        b=KjDwl6IBVueGjVYm+yPvIkxkftsc885QAbda4aKv50PtJ1NUn3viZutyol0wyvvVNV/48I
        plV9SPulIg5QmJ2PB9YiQ7QAfwMHG+VewSBBKW6wL8oKIMRAY/1VRQgqQDQMA9tVRVKO1s
        8+RH7QdoQgdK8wtseEc6Wf2DCscrEtY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-149-W417mEf_M6-IxOs_aw4oOQ-1; Mon, 02 Nov 2020 14:41:45 -0500
X-MC-Unique: W417mEf_M6-IxOs_aw4oOQ-1
Received: by mail-wm1-f72.google.com with SMTP id e15so2189884wme.4
        for <linux-xfs@vger.kernel.org>; Mon, 02 Nov 2020 11:41:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GK+6caFWaFH5t2N79/Q2f7WbYR/SrAJzjXNlpLzlYHA=;
        b=Cw+tpjMjwB3MUA4xFO5A2TtDE9cK/PuLwKMJ0VEcIlEpF4om1B7jKEItr9i4PX1S5Y
         yXz3e16EbkuHzehPhr/Fr/dxmKW/dAHfyEogVoa17Hl8lbFwvpciT3WzO0AB8plHKrM2
         3i7PIeaa/e2IvUoszZXMDF1KQGx+fkzmEhRmgw3YBixA+kzMq3oNotFcCufgGtHIcAtA
         2Ux2+lXGA5Ek8p8zBpmbDfsVM87UUmnQ06s/J1Y8CYPjaFRRA+P9mYaGMOJgSJ1BmqsY
         TpoL5LRh1VrRqKbSmDxihFFKjaiw5hF3ZHgXCq3V7oU54RUf4stFwXOAF/8D9gRVnNwa
         9QMQ==
X-Gm-Message-State: AOAM532IQLq0BySgNwYuE1vCXmXd5dRRgJFlTp4uJu29c4vgrl1/lhMo
        MmxtbFT7z9KGexN7Ut0pKQlu5o1MGfgNJCqtAV8SxMOkZ6BhXe0FUmbnb6Q97yuTBMI8xZmsMaX
        VSt30P1mHFq3u8+A78Qxe
X-Received: by 2002:adf:9184:: with SMTP id 4mr22164040wri.258.1604346103582;
        Mon, 02 Nov 2020 11:41:43 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzDgaVv6Te4XynUaQ6QtBxyqTztVdDipuPPlZ+QgaiDDExgrI7sTSIli5ACQbFS3XXAsMlcUw==
X-Received: by 2002:adf:9184:: with SMTP id 4mr22164022wri.258.1604346103306;
        Mon, 02 Nov 2020 11:41:43 -0800 (PST)
Received: from localhost.localdomain ([84.19.91.81])
        by smtp.gmail.com with ESMTPSA id 6sm11742465wrc.88.2020.11.02.11.41.42
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 11:41:42 -0800 (PST)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v13 4/4] xfs: replace mrlock_t with rw_semaphores
Date:   Mon,  2 Nov 2020 20:41:35 +0100
Message-Id: <20201102194135.174806-5-preichl@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201102194135.174806-1-preichl@redhat.com>
References: <20201102194135.174806-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Remove mrlock_t as it does not provide any extra value over
rw_semaphores. Make i_lock and i_mmaplock native rw_semaphores and
replace mr*() functions with native rwsem calls.

Release the lock in xfs_btree_split() just before the work-queue
executing xfs_btree_split_worker() is scheduled and make
xfs_btree_split_worker() to acquire the lock as a first thing and
release it just before returning from the function. This it done so the
ownership of the lock is transfered between kernel threads and thus
lockdep won't complain about lock being held by a different kernel
thread.

Signed-off-by: Pavel Reichl <preichl@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>

---
 fs/xfs/libxfs/xfs_btree.c | 16 ++++++++
 fs/xfs/mrlock.h           | 78 ---------------------------------------
 fs/xfs/xfs_inode.c        | 52 ++++++++++++++------------
 fs/xfs/xfs_inode.h        |  4 +-
 fs/xfs/xfs_iops.c         |  4 +-
 fs/xfs/xfs_linux.h        |  2 +-
 fs/xfs/xfs_super.c        |  6 +--
 7 files changed, 51 insertions(+), 111 deletions(-)
 delete mode 100644 fs/xfs/mrlock.h

diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 2d25bab68764..181d5797c97b 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -2816,6 +2816,10 @@ xfs_btree_split_worker(
 	unsigned long		pflags;
 	unsigned long		new_pflags = PF_MEMALLOC_NOFS;
 
+	/*
+	 * Tranfer lock ownership to workqueue task.
+	 */
+	rwsem_acquire(&args->cur->bc_ino.ip->i_lock.dep_map, 0, 0, _RET_IP_);
 	/*
 	 * we are in a transaction context here, but may also be doing work
 	 * in kswapd context, and hence we may need to inherit that state
@@ -2829,6 +2833,7 @@ xfs_btree_split_worker(
 
 	args->result = __xfs_btree_split(args->cur, args->level, args->ptrp,
 					 args->key, args->curp, args->stat);
+	rwsem_release(&args->cur->bc_ino.ip->i_lock.dep_map, _THIS_IP_);
 	complete(args->done);
 
 	current_restore_flags_nested(&pflags, new_pflags);
@@ -2863,8 +2868,19 @@ xfs_btree_split(
 	args.done = &done;
 	args.kswapd = current_is_kswapd();
 	INIT_WORK_ONSTACK(&args.work, xfs_btree_split_worker);
+	/*
+	 * Update lockdep's ownership information to reflect transfer of the
+	 * ilock from the current task to the worker. Otherwise assertions that
+	 * the lock is held (such as when logging the inode) might fail due to
+	 * incorrect task owner state.
+	 */
+	rwsem_release(&cur->bc_ino.ip->i_lock.dep_map, _THIS_IP_);
 	queue_work(xfs_alloc_wq, &args.work);
 	wait_for_completion(&done);
+	/*
+	 * Tranfer lock ownership back to the thread.
+	 */
+	rwsem_acquire(&cur->bc_ino.ip->i_lock.dep_map, 0, 0, _RET_IP_);
 	destroy_work_on_stack(&args.work);
 	return args.result;
 }
diff --git a/fs/xfs/mrlock.h b/fs/xfs/mrlock.h
deleted file mode 100644
index 79155eec341b..000000000000
--- a/fs/xfs/mrlock.h
+++ /dev/null
@@ -1,78 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * Copyright (c) 2000-2006 Silicon Graphics, Inc.
- * All Rights Reserved.
- */
-#ifndef __XFS_SUPPORT_MRLOCK_H__
-#define __XFS_SUPPORT_MRLOCK_H__
-
-#include <linux/rwsem.h>
-
-typedef struct {
-	struct rw_semaphore	mr_lock;
-#if defined(DEBUG) || defined(XFS_WARN)
-	int			mr_writer;
-#endif
-} mrlock_t;
-
-#if defined(DEBUG) || defined(XFS_WARN)
-#define mrinit(mrp, name)	\
-	do { (mrp)->mr_writer = 0; init_rwsem(&(mrp)->mr_lock); } while (0)
-#else
-#define mrinit(mrp, name)	\
-	do { init_rwsem(&(mrp)->mr_lock); } while (0)
-#endif
-
-#define mrlock_init(mrp, t,n,s)	mrinit(mrp, n)
-#define mrfree(mrp)		do { } while (0)
-
-static inline void mraccess_nested(mrlock_t *mrp, int subclass)
-{
-	down_read_nested(&mrp->mr_lock, subclass);
-}
-
-static inline void mrupdate_nested(mrlock_t *mrp, int subclass)
-{
-	down_write_nested(&mrp->mr_lock, subclass);
-#if defined(DEBUG) || defined(XFS_WARN)
-	mrp->mr_writer = 1;
-#endif
-}
-
-static inline int mrtryaccess(mrlock_t *mrp)
-{
-	return down_read_trylock(&mrp->mr_lock);
-}
-
-static inline int mrtryupdate(mrlock_t *mrp)
-{
-	if (!down_write_trylock(&mrp->mr_lock))
-		return 0;
-#if defined(DEBUG) || defined(XFS_WARN)
-	mrp->mr_writer = 1;
-#endif
-	return 1;
-}
-
-static inline void mrunlock_excl(mrlock_t *mrp)
-{
-#if defined(DEBUG) || defined(XFS_WARN)
-	mrp->mr_writer = 0;
-#endif
-	up_write(&mrp->mr_lock);
-}
-
-static inline void mrunlock_shared(mrlock_t *mrp)
-{
-	up_read(&mrp->mr_lock);
-}
-
-static inline void mrdemote(mrlock_t *mrp)
-{
-#if defined(DEBUG) || defined(XFS_WARN)
-	mrp->mr_writer = 0;
-#endif
-	downgrade_write(&mrp->mr_lock);
-}
-
-#endif /* __XFS_SUPPORT_MRLOCK_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 16d481cf3793..43ecfcb63f99 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -191,14 +191,15 @@ xfs_ilock(
 	}
 
 	if (lock_flags & XFS_MMAPLOCK_EXCL)
-		mrupdate_nested(&ip->i_mmaplock, XFS_MMAPLOCK_DEP(lock_flags));
+		down_write_nested(&ip->i_mmaplock,
+				XFS_MMAPLOCK_DEP(lock_flags));
 	else if (lock_flags & XFS_MMAPLOCK_SHARED)
-		mraccess_nested(&ip->i_mmaplock, XFS_MMAPLOCK_DEP(lock_flags));
+		down_read_nested(&ip->i_mmaplock, XFS_MMAPLOCK_DEP(lock_flags));
 
 	if (lock_flags & XFS_ILOCK_EXCL)
-		mrupdate_nested(&ip->i_lock, XFS_ILOCK_DEP(lock_flags));
+		down_write_nested(&ip->i_lock, XFS_ILOCK_DEP(lock_flags));
 	else if (lock_flags & XFS_ILOCK_SHARED)
-		mraccess_nested(&ip->i_lock, XFS_ILOCK_DEP(lock_flags));
+		down_read_nested(&ip->i_lock, XFS_ILOCK_DEP(lock_flags));
 }
 
 /*
@@ -242,27 +243,27 @@ xfs_ilock_nowait(
 	}
 
 	if (lock_flags & XFS_MMAPLOCK_EXCL) {
-		if (!mrtryupdate(&ip->i_mmaplock))
+		if (!down_write_trylock(&ip->i_mmaplock))
 			goto out_undo_iolock;
 	} else if (lock_flags & XFS_MMAPLOCK_SHARED) {
-		if (!mrtryaccess(&ip->i_mmaplock))
+		if (!down_read_trylock(&ip->i_mmaplock))
 			goto out_undo_iolock;
 	}
 
 	if (lock_flags & XFS_ILOCK_EXCL) {
-		if (!mrtryupdate(&ip->i_lock))
+		if (!down_write_trylock(&ip->i_lock))
 			goto out_undo_mmaplock;
 	} else if (lock_flags & XFS_ILOCK_SHARED) {
-		if (!mrtryaccess(&ip->i_lock))
+		if (!down_read_trylock(&ip->i_lock))
 			goto out_undo_mmaplock;
 	}
 	return 1;
 
 out_undo_mmaplock:
 	if (lock_flags & XFS_MMAPLOCK_EXCL)
-		mrunlock_excl(&ip->i_mmaplock);
+		up_write(&ip->i_mmaplock);
 	else if (lock_flags & XFS_MMAPLOCK_SHARED)
-		mrunlock_shared(&ip->i_mmaplock);
+		up_read(&ip->i_mmaplock);
 out_undo_iolock:
 	if (lock_flags & XFS_IOLOCK_EXCL)
 		up_write(&VFS_I(ip)->i_rwsem);
@@ -309,14 +310,14 @@ xfs_iunlock(
 		up_read(&VFS_I(ip)->i_rwsem);
 
 	if (lock_flags & XFS_MMAPLOCK_EXCL)
-		mrunlock_excl(&ip->i_mmaplock);
+		up_write(&ip->i_mmaplock);
 	else if (lock_flags & XFS_MMAPLOCK_SHARED)
-		mrunlock_shared(&ip->i_mmaplock);
+		up_read(&ip->i_mmaplock);
 
 	if (lock_flags & XFS_ILOCK_EXCL)
-		mrunlock_excl(&ip->i_lock);
+		up_write(&ip->i_lock);
 	else if (lock_flags & XFS_ILOCK_SHARED)
-		mrunlock_shared(&ip->i_lock);
+		up_read(&ip->i_lock);
 
 	trace_xfs_iunlock(ip, lock_flags, _RET_IP_);
 }
@@ -335,9 +336,9 @@ xfs_ilock_demote(
 		~(XFS_IOLOCK_EXCL|XFS_MMAPLOCK_EXCL|XFS_ILOCK_EXCL)) == 0);
 
 	if (lock_flags & XFS_ILOCK_EXCL)
-		mrdemote(&ip->i_lock);
+		downgrade_write(&ip->i_lock);
 	if (lock_flags & XFS_MMAPLOCK_EXCL)
-		mrdemote(&ip->i_mmaplock);
+		downgrade_write(&ip->i_mmaplock);
 	if (lock_flags & XFS_IOLOCK_EXCL)
 		downgrade_write(&VFS_I(ip)->i_rwsem);
 
@@ -375,19 +376,22 @@ xfs_isilocked(
 	struct xfs_inode	*ip,
 	uint			lock_flags)
 {
-	if (lock_flags & (XFS_ILOCK_EXCL|XFS_ILOCK_SHARED)) {
-		if (!(lock_flags & XFS_ILOCK_SHARED))
-			return !!ip->i_lock.mr_writer;
-		return rwsem_is_locked(&ip->i_lock.mr_lock);
+	if (lock_flags & (XFS_ILOCK_EXCL | XFS_ILOCK_SHARED)) {
+		ASSERT(!(lock_flags & ~(XFS_ILOCK_EXCL | XFS_ILOCK_SHARED)));
+		return __xfs_rwsem_islocked(&ip->i_lock, lock_flags,
+				XFS_ILOCK_FLAG_SHIFT);
 	}
 
-	if (lock_flags & (XFS_MMAPLOCK_EXCL|XFS_MMAPLOCK_SHARED)) {
-		if (!(lock_flags & XFS_MMAPLOCK_SHARED))
-			return !!ip->i_mmaplock.mr_writer;
-		return rwsem_is_locked(&ip->i_mmaplock.mr_lock);
+	if (lock_flags & (XFS_MMAPLOCK_EXCL | XFS_MMAPLOCK_SHARED)) {
+		ASSERT(!(lock_flags &
+			~(XFS_MMAPLOCK_EXCL | XFS_MMAPLOCK_SHARED)));
+		return __xfs_rwsem_islocked(&ip->i_mmaplock, lock_flags,
+				XFS_MMAPLOCK_FLAG_SHIFT);
 	}
 
 	if (lock_flags & (XFS_IOLOCK_EXCL | XFS_IOLOCK_SHARED)) {
+		ASSERT(!(lock_flags &
+			~(XFS_IOLOCK_EXCL | XFS_IOLOCK_SHARED)));
 		return __xfs_rwsem_islocked(&VFS_I(ip)->i_rwsem, lock_flags,
 				XFS_IOLOCK_FLAG_SHIFT);
 	}
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 1392a9c452ae..66ceb127192e 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -39,8 +39,8 @@ typedef struct xfs_inode {
 
 	/* Transaction and locking information. */
 	struct xfs_inode_log_item *i_itemp;	/* logging information */
-	mrlock_t		i_lock;		/* inode lock */
-	mrlock_t		i_mmaplock;	/* inode mmap IO lock */
+	struct rw_semaphore	i_lock;		/* inode lock */
+	struct rw_semaphore	i_mmaplock;	/* inode mmap IO lock */
 	atomic_t		i_pincount;	/* inode pin count */
 
 	/*
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 5e165456da68..8181f6785a7a 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1336,9 +1336,9 @@ xfs_setup_inode(
 		 */
 		lockdep_set_class(&inode->i_rwsem,
 				  &inode->i_sb->s_type->i_mutex_dir_key);
-		lockdep_set_class(&ip->i_lock.mr_lock, &xfs_dir_ilock_class);
+		lockdep_set_class(&ip->i_lock, &xfs_dir_ilock_class);
 	} else {
-		lockdep_set_class(&ip->i_lock.mr_lock, &xfs_nondir_ilock_class);
+		lockdep_set_class(&ip->i_lock, &xfs_nondir_ilock_class);
 	}
 
 	/*
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index 5b7a1e201559..64e28ec16cf7 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -22,7 +22,6 @@ typedef __u32			xfs_nlink_t;
 #include "xfs_types.h"
 
 #include "kmem.h"
-#include "mrlock.h"
 
 #include <linux/semaphore.h>
 #include <linux/mm.h>
@@ -61,6 +60,7 @@ typedef __u32			xfs_nlink_t;
 #include <linux/ratelimit.h>
 #include <linux/rhashtable.h>
 #include <linux/xattr.h>
+#include <linux/rwsem.h>
 
 #include <asm/page.h>
 #include <asm/div64.h>
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index e3e229e52512..380ba196b165 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -708,10 +708,8 @@ xfs_fs_inode_init_once(
 	atomic_set(&ip->i_pincount, 0);
 	spin_lock_init(&ip->i_flags_lock);
 
-	mrlock_init(&ip->i_mmaplock, MRLOCK_ALLOW_EQUAL_PRI|MRLOCK_BARRIER,
-		     "xfsino", ip->i_ino);
-	mrlock_init(&ip->i_lock, MRLOCK_ALLOW_EQUAL_PRI|MRLOCK_BARRIER,
-		     "xfsino", ip->i_ino);
+	init_rwsem(&ip->i_mmaplock);
+	init_rwsem(&ip->i_lock);
 }
 
 /*
-- 
2.26.2

