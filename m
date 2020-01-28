Return-Path: <SRS0=UJS8=3R=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3530C2D0DB
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jan 2020 14:55:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 686E9214AF
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jan 2020 14:55:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cej6tKLo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbgA1Oz4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jan 2020 09:55:56 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:49132 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726497AbgA1Ozz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jan 2020 09:55:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580223354;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8WDsMSrTfymQa9IEKP6vhstBDQMYGJuHFDA/6Sgx5zU=;
        b=cej6tKLovxQ0zDMSE82SegmMiKANsu5/iT84PKhVQr1m/iJLLkfogFxzrBm89tZEl7q/nv
        e28S+Nr0cCizZLtYFIRieKUTFH5ceUq0gN2EbnRRDNbgMziDb24bOLyeHq/XF/i45JKZZe
        2DhK3dyr8BdMIQmjfeotjZedXhVVlP8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-4-j4eObx8zOkm0ugqH8wTnvg-1; Tue, 28 Jan 2020 09:55:53 -0500
X-MC-Unique: j4eObx8zOkm0ugqH8wTnvg-1
Received: by mail-wm1-f72.google.com with SMTP id b202so1023330wmb.2
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jan 2020 06:55:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8WDsMSrTfymQa9IEKP6vhstBDQMYGJuHFDA/6Sgx5zU=;
        b=jsk0JTWoFuBflyhZduuURJ0p/stVWWzWnvGFBhpPn0Uz0L+dEbwo8XTDfnJQvcxLMe
         dSOK1z/qdyFp2hCAXHdwIC/0nrNpozPGNgP2kvDwOHdWCupxDeb0XOYI/T+77tDjawwd
         VqPe+MZJbD6+GdRB19Z1al2thLFsUY8u9r3PtDGSFyJClu5Kndj4Tuq/HwILsqc619dv
         lHZQJBsx5n1+2/nBHtmkF/JNh4JPUjk2fyRg1/pRvYGnTXOH2OSFAcKoIvjq4i4M952B
         cokiogwPIPdKdQxT+sVXfhE6JZ8QDLbi/FKvFFoofYtCmraS1iW41VqGJ11dSLrKu4MX
         qpKA==
X-Gm-Message-State: APjAAAVS0WrHNAc3vD1+UIxtbX5DBo3u1By4t3G2RdwJNPK0biaR4o8y
        FlhYeo/eog04iL3oowsCnQCo6jkFZ9TEpthZbBgoUaBslBOcVDRRqUoyQ3xLUG3L3NIpd/S10eu
        +u3zQisAYRvQ7POQNG5Jg
X-Received: by 2002:adf:d4ca:: with SMTP id w10mr30767974wrk.53.1580223350234;
        Tue, 28 Jan 2020 06:55:50 -0800 (PST)
X-Google-Smtp-Source: APXvYqwE62UgF6fZ6+r2T0LYzv/IwzDZ9nAn7gABzsAoqaHKA1bHIMc+OUxgxopqji1Fvjgp065FsQ==
X-Received: by 2002:adf:d4ca:: with SMTP id w10mr30767959wrk.53.1580223350019;
        Tue, 28 Jan 2020 06:55:50 -0800 (PST)
Received: from localhost.localdomain.com (243.206.broadband12.iol.cz. [90.179.206.243])
        by smtp.gmail.com with ESMTPSA id q130sm3325939wme.19.2020.01.28.06.55.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jan 2020 06:55:47 -0800 (PST)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Pavel Reichl <preichl@redhat.com>
Subject: [PATCH 3/4] xfs: Make i_lock and i_mmap native rwsems
Date:   Tue, 28 Jan 2020 15:55:27 +0100
Message-Id: <20200128145528.2093039-4-preichl@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200128145528.2093039-1-preichl@redhat.com>
References: <20200128145528.2093039-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

mr*() functions need to take struct rw_semaphore as parameter.

Signed-off-by: Pavel Reichl <preichl@redhat.com>
---
 fs/xfs/mrlock.h    | 38 ++++++++++++++++++--------------------
 fs/xfs/xfs_inode.c |  8 ++++----
 fs/xfs/xfs_inode.h |  6 ++++--
 fs/xfs/xfs_iops.c  |  4 ++--
 4 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/fs/xfs/mrlock.h b/fs/xfs/mrlock.h
index 1923be92a832..245f417a7ffe 100644
--- a/fs/xfs/mrlock.h
+++ b/fs/xfs/mrlock.h
@@ -13,51 +13,49 @@ typedef struct {
 } mrlock_t;
 
 #if defined(DEBUG) || defined(XFS_WARN)
-#define mrinit(mrp, name)	\
-	do { init_rwsem(&(mrp)->mr_lock); } while (0)
+#define mrinit(smp, name)	init_rwsem(smp)
 #else
-#define mrinit(mrp, name)	\
-	do { init_rwsem(&(mrp)->mr_lock); } while (0)
+#define mrinit(smp, name)	init_rwsem(smp)
 #endif
 
-#define mrlock_init(mrp, t,n,s)	mrinit(mrp, n)
-#define mrfree(mrp)		do { } while (0)
+#define mrlock_init(smp, t, n, s)	mrinit(smp, n)
+#define mrfree(smp)		do { } while (0)
 
-static inline void mraccess_nested(mrlock_t *mrp, int subclass)
+static inline void mraccess_nested(struct rw_semaphore *s, int subclass)
 {
-	down_read_nested(&mrp->mr_lock, subclass);
+	down_read_nested(s, subclass);
 }
 
-static inline void mrupdate_nested(mrlock_t *mrp, int subclass)
+static inline void mrupdate_nested(struct rw_semaphore *s, int subclass)
 {
-	down_write_nested(&mrp->mr_lock, subclass);
+	down_write_nested(s, subclass);
 }
 
-static inline int mrtryaccess(mrlock_t *mrp)
+static inline int mrtryaccess(struct rw_semaphore *s)
 {
-	return down_read_trylock(&mrp->mr_lock);
+	return down_read_trylock(s);
 }
 
-static inline int mrtryupdate(mrlock_t *mrp)
+static inline int mrtryupdate(struct rw_semaphore *s)
 {
-	if (!down_write_trylock(&mrp->mr_lock))
+	if (!down_write_trylock(s))
 		return 0;
 	return 1;
 }
 
-static inline void mrunlock_excl(mrlock_t *mrp)
+static inline void mrunlock_excl(struct rw_semaphore *s)
 {
-	up_write(&mrp->mr_lock);
+	up_write(s);
 }
 
-static inline void mrunlock_shared(mrlock_t *mrp)
+static inline void mrunlock_shared(struct rw_semaphore *s)
 {
-	up_read(&mrp->mr_lock);
+	up_read(s);
 }
 
-static inline void mrdemote(mrlock_t *mrp)
+static inline void mrdemote(struct rw_semaphore *s)
 {
-	downgrade_write(&mrp->mr_lock);
+	downgrade_write(s);
 }
 
 #endif /* __XFS_SUPPORT_MRLOCK_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 32fac6152dc3..567dae69cfac 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -353,17 +353,17 @@ xfs_isilocked(
 	if (lock_flags & (XFS_ILOCK_EXCL|XFS_ILOCK_SHARED)) {
 		if (!(lock_flags & XFS_ILOCK_SHARED))
 			return !debug_locks ||
-				lockdep_is_held_type(&ip->i_lock.mr_lock, 0);
-		return rwsem_is_locked(&ip->i_lock.mr_lock);
+				lockdep_is_held_type(&ip->i_lock, 0);
+		return rwsem_is_locked(&ip->i_lock);
 	}
 
 	if (lock_flags & (XFS_MMAPLOCK_EXCL|XFS_MMAPLOCK_SHARED)) {
 		if (!(lock_flags & XFS_MMAPLOCK_SHARED))
 			return !debug_locks ||
 				lockdep_is_held_type(
-					&ip->i_mmaplock.mr_lock,
+					&ip->i_mmaplock,
 					0);
-		return rwsem_is_locked(&ip->i_mmaplock.mr_lock);
+		return rwsem_is_locked(&ip->i_mmaplock);
 	}
 
 	if (lock_flags & (XFS_IOLOCK_EXCL|XFS_IOLOCK_SHARED)) {
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 492e53992fa9..0ea811587cec 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -9,6 +9,8 @@
 #include "xfs_inode_buf.h"
 #include "xfs_inode_fork.h"
 
+#include <linux/rwsem.h>
+
 /*
  * Kernel only inode definitions
  */
@@ -39,8 +41,8 @@ typedef struct xfs_inode {
 
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
-- 
2.24.1

