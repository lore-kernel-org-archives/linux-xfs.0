Return-Path: <SRS0=UJS8=3R=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E47BC2D0DB
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jan 2020 14:56:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 69B03214AF
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jan 2020 14:56:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Tlz8dgGy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbgA1O4C (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jan 2020 09:56:02 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:24258 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726497AbgA1O4B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jan 2020 09:56:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580223360;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TWboZqW3VINuafp7zIAqRVFxTqG2UygmPXqzURkJ23o=;
        b=Tlz8dgGyBFBogOiQwlAsxYRcBQB9kN27rAZlrzopnu8Gl+npmt9LPS/Odk8Ia2W62V/Zrx
        ATUWRIelibR+DqE0nSTlHYcWWqqWuTQER4a+LxvZRfEZqmQXvwzLpKYDkvalP1n9adgAvD
        2DhD4gWE3G9po4uzCdY+rdlu55SrJ/k=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-31-_xMRPlnVMxCe4xU7R75Nkw-1; Tue, 28 Jan 2020 09:55:59 -0500
X-MC-Unique: _xMRPlnVMxCe4xU7R75Nkw-1
Received: by mail-wm1-f69.google.com with SMTP id g26so1020818wmk.6
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jan 2020 06:55:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TWboZqW3VINuafp7zIAqRVFxTqG2UygmPXqzURkJ23o=;
        b=hAXvx6ORKusPd9HrQ5h0DU9owLe+xd5lLRmj7YbdOypjqwtj0VkerHw6RIGyURPwyl
         lG9K20lBIHawjNDqVtavAq3bW3WsnBLX3K7fXqUHDggwJyZ6oS6wIkydaOZysDeT7Mh4
         ylLGqG49Lt2wH2uIvIRzcjHdy1abkwuuepE3TbEC++zq0ygU7nAmDFVFDdmHB0JHsXdl
         Tu3iZOmJZYA7NgPs0t+Vixao3kCcoAB9Tc1dLE74Cy0uhp4y/HjJTl1ZCkHVikRZemc2
         pqImfJiazkx5O1tfbcfvKHZfcXkXOWQbFsk30EeDJOtSSZNj9zg6DS/+aq45R2i5vpgF
         K1Pg==
X-Gm-Message-State: APjAAAUcZTYzzAvEhRIWdnJQyP9kQuFTv4x0BLb6UxR4rUNe80TJb/Fn
        xDe+ltmIKY1i8wOfh84DxOzFkYxhtvFJ/+hamdJh/vgiAPQLDDf6FPq6ZRuKl2se4l6LurxrcB9
        kxuZEwPGjqoUH+Ep4Yr54
X-Received: by 2002:adf:f789:: with SMTP id q9mr30922417wrp.103.1580223356428;
        Tue, 28 Jan 2020 06:55:56 -0800 (PST)
X-Google-Smtp-Source: APXvYqy+1cnTm92JkZUNOwiwW7Iek2u0wFgfuatNcETYrlwx5tgkLjbHzxy/FMnLfYSvseD2nS+A+Q==
X-Received: by 2002:adf:f789:: with SMTP id q9mr30922400wrp.103.1580223356179;
        Tue, 28 Jan 2020 06:55:56 -0800 (PST)
Received: from localhost.localdomain.com (243.206.broadband12.iol.cz. [90.179.206.243])
        by smtp.gmail.com with ESMTPSA id q130sm3325939wme.19.2020.01.28.06.55.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jan 2020 06:55:52 -0800 (PST)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Pavel Reichl <preichl@redhat.com>
Subject: [PATCH 4/4] xfs: replace mr*() functions with native rwsem calls
Date:   Tue, 28 Jan 2020 15:55:28 +0100
Message-Id: <20200128145528.2093039-5-preichl@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200128145528.2093039-1-preichl@redhat.com>
References: <20200128145528.2093039-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Remove mr*() functions as they only wrap the standard kernel functions
for kernel manimulation.

Signed-off-by: Pavel Reichl <preichl@redhat.com>
---
 fs/xfs/mrlock.h    | 61 ----------------------------------------------
 fs/xfs/xfs_inode.c | 33 +++++++++++++------------
 fs/xfs/xfs_linux.h |  1 -
 fs/xfs/xfs_super.c |  6 ++---
 4 files changed, 19 insertions(+), 82 deletions(-)
 delete mode 100644 fs/xfs/mrlock.h

diff --git a/fs/xfs/mrlock.h b/fs/xfs/mrlock.h
deleted file mode 100644
index 245f417a7ffe..000000000000
--- a/fs/xfs/mrlock.h
+++ /dev/null
@@ -1,61 +0,0 @@
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
-} mrlock_t;
-
-#if defined(DEBUG) || defined(XFS_WARN)
-#define mrinit(smp, name)	init_rwsem(smp)
-#else
-#define mrinit(smp, name)	init_rwsem(smp)
-#endif
-
-#define mrlock_init(smp, t, n, s)	mrinit(smp, n)
-#define mrfree(smp)		do { } while (0)
-
-static inline void mraccess_nested(struct rw_semaphore *s, int subclass)
-{
-	down_read_nested(s, subclass);
-}
-
-static inline void mrupdate_nested(struct rw_semaphore *s, int subclass)
-{
-	down_write_nested(s, subclass);
-}
-
-static inline int mrtryaccess(struct rw_semaphore *s)
-{
-	return down_read_trylock(s);
-}
-
-static inline int mrtryupdate(struct rw_semaphore *s)
-{
-	if (!down_write_trylock(s))
-		return 0;
-	return 1;
-}
-
-static inline void mrunlock_excl(struct rw_semaphore *s)
-{
-	up_write(s);
-}
-
-static inline void mrunlock_shared(struct rw_semaphore *s)
-{
-	up_read(s);
-}
-
-static inline void mrdemote(struct rw_semaphore *s)
-{
-	downgrade_write(s);
-}
-
-#endif /* __XFS_SUPPORT_MRLOCK_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 567dae69cfac..01bca957e305 100644
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
 
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index 8738bb03f253..921a3eb093ed 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -22,7 +22,6 @@ typedef __u32			xfs_nlink_t;
 #include "xfs_types.h"
 
 #include "kmem.h"
-#include "mrlock.h"
 
 #include <linux/semaphore.h>
 #include <linux/mm.h>
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

