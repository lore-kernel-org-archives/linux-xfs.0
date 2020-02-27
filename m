Return-Path: <SRS0=C9JY=4P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2259AC35E1C
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Feb 2020 20:36:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EDA5B2469C
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Feb 2020 20:36:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AQUD5Ly1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729409AbgB0Ugq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Feb 2020 15:36:46 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:58853 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729351AbgB0Ugq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Feb 2020 15:36:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582835805;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qXwUmFyfEVUf6Tn/A8v7+J5jfteXoZyBtLDyuFl68/c=;
        b=AQUD5Ly1X7401BzxyH4ipWuLHN37Lm9zrB+22F4W9ETwszLd0reB9/adMFbTDPb7SWWpmT
        xfW8PAbTXgvH6dRNduvLemfi7DS4iFWdkK1TfZ1Q78qP1Hx0n7DkSECt1Ve0PgynQpQkxZ
        M0cM0AQDhPJliBBS4w0rFCjVYyPat3Y=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-17-KjLK6UWtMdClogjtxi8NVQ-1; Thu, 27 Feb 2020 15:36:43 -0500
X-MC-Unique: KjLK6UWtMdClogjtxi8NVQ-1
Received: by mail-wr1-f71.google.com with SMTP id c6so320761wrm.18
        for <linux-xfs@vger.kernel.org>; Thu, 27 Feb 2020 12:36:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qXwUmFyfEVUf6Tn/A8v7+J5jfteXoZyBtLDyuFl68/c=;
        b=fhdZ5DPkJ9OpapOv2BY5+E9b19hgxflV5xzyW/V+7+HDlDbkazmv9ZY26WF+l8zczM
         nuaaC5rYUh3F/E6+TWXCV0+B33JeJqP/IKyijKOJzYm0ePTx7k35sidnK4efGdvn+dy3
         irCVPkz8I0i5YSXf0nh2OiiQVybJBu8rVIPZ/pIDAE8OKHwAS8chIYnOXr0YGzossJsC
         cDPgibcxJ8WFmRH7oaeVLCedTOq8AMQ/Rw0Z0FSPqLdDGsT7LDCmAmYl1N0XY8tVzks2
         7tgEj0UFRSkS5ZDfFhDVFCX36HgGrg/7ynegwrUNci+kUmgvr81y9S0NRjA1emQNOWbP
         t0fQ==
X-Gm-Message-State: APjAAAWhPrLF2IhKYYHdY1g0bVzjJyFiS/jEom4WDKRdDxlQBepTMtMw
        NUCigJwAiUinl1KRIPooPZIpk0sAz9qetsbkba6DhKGpsxKCPogHbow966sfX/jIkjqS+f1tSuK
        zN6TGf/R2H+hSgPgAGOFM
X-Received: by 2002:adf:828b:: with SMTP id 11mr638739wrc.169.1582835802251;
        Thu, 27 Feb 2020 12:36:42 -0800 (PST)
X-Google-Smtp-Source: APXvYqwLcPGvAhZZHJ2OUScGEbllIsJc8yu/9H3zIQvqPb2aNkFcAI6yjKCj5+Mobhv/+D/YkJkhtA==
X-Received: by 2002:adf:828b:: with SMTP id 11mr638728wrc.169.1582835801941;
        Thu, 27 Feb 2020 12:36:41 -0800 (PST)
Received: from localhost.localdomain (243.206.broadband12.iol.cz. [90.179.206.243])
        by smtp.gmail.com with ESMTPSA id e11sm9217157wrm.80.2020.02.27.12.36.41
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2020 12:36:41 -0800 (PST)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v6 4/4] xfs: replace mrlock_t with rw_semaphores
Date:   Thu, 27 Feb 2020 21:36:36 +0100
Message-Id: <20200227203636.317790-5-preichl@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200227203636.317790-1-preichl@redhat.com>
References: <20200227203636.317790-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Remove mrlock_t as it does not provide any extra value over
rw_semaphores. Make i_lock and i_mmaplock native rw_semaphores and
replace mr*() functions with native rwsem calls.

Signed-off-by: Pavel Reichl <preichl@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
Changes from V5: None

 fs/xfs/mrlock.h    | 78 ----------------------------------------------
 fs/xfs/xfs_inode.c | 40 +++++++++++++-----------
 fs/xfs/xfs_inode.h |  4 +--
 fs/xfs/xfs_iops.c  |  4 +--
 fs/xfs/xfs_linux.h |  2 +-
 fs/xfs/xfs_super.c |  6 ++--
 6 files changed, 29 insertions(+), 105 deletions(-)
 delete mode 100644 fs/xfs/mrlock.h

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
index e778739adbf8..c07323e05db9 100644
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
 
@@ -365,12 +366,15 @@ xfs_isilocked(
 	uint			lock_flags)
 {
 	if (lock_flags & (XFS_ILOCK_EXCL | XFS_ILOCK_SHARED)) {
-		return __xfs_rwsem_islocked(&ip->i_lock.mr_lock,
+		ASSERT(!(lock_flags & ~(XFS_ILOCK_EXCL | XFS_ILOCK_SHARED)));
+		return __xfs_rwsem_islocked(&ip->i_lock,
 				(lock_flags & XFS_ILOCK_EXCL));
 	}
 
 	if (lock_flags & (XFS_MMAPLOCK_EXCL | XFS_MMAPLOCK_SHARED)) {
-		return __xfs_rwsem_islocked(&ip->i_mmaplock.mr_lock,
+		ASSERT(!(lock_flags &
+			~(XFS_MMAPLOCK_EXCL | XFS_MMAPLOCK_SHARED)));
+		return __xfs_rwsem_islocked(&ip->i_mmaplock,
 				(lock_flags & XFS_MMAPLOCK_EXCL));
 	}
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 3d7ce355407d..a7cf112a9e4f 100644
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
index 81f2f93caec0..7c3df574cf4c 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1319,9 +1319,9 @@ xfs_setup_inode(
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
index 8738bb03f253..8248744f1245 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -22,7 +22,6 @@ typedef __u32			xfs_nlink_t;
 #include "xfs_types.h"
 
 #include "kmem.h"
-#include "mrlock.h"
 
 #include <linux/semaphore.h>
 #include <linux/mm.h>
@@ -60,6 +59,7 @@ typedef __u32			xfs_nlink_t;
 #include <linux/list_sort.h>
 #include <linux/ratelimit.h>
 #include <linux/rhashtable.h>
+#include <linux/rwsem.h>
 
 #include <asm/page.h>
 #include <asm/div64.h>
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 760901783944..1289ce1f4e9e 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -661,10 +661,8 @@ xfs_fs_inode_init_once(
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
2.24.1

