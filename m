Return-Path: <SRS0=Ip4f=4C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04BA3C2BA83
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Feb 2020 18:59:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C2D3D2168B
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Feb 2020 18:59:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YXPK60s2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387815AbgBNS7u (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 14 Feb 2020 13:59:50 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:51938 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387731AbgBNS7t (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Feb 2020 13:59:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581706787;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=bPoJRjMNrY9ooQ5w2MXOpka1uriWvZg33XXV+CXakPs=;
        b=YXPK60s2G9XpohhZbKlE0TKQTOQqWiJCaEMFEymPW98GLyQZaYaZh06jdhR2paD+zrGHpN
        gy6R2paLg2N9FLrNhrUV/UvPRS0NorqIADPkEb5JOkwjZwiWrH4in9xLImdG07K6HE6+z9
        2JruiPax9bHFdUhY0ZJVszAXTA8yXpQ=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-290-pQeqgWnNN4-rQ-14GvA3Qw-1; Fri, 14 Feb 2020 13:59:46 -0500
X-MC-Unique: pQeqgWnNN4-rQ-14GvA3Qw-1
Received: by mail-wr1-f71.google.com with SMTP id j4so4522789wrs.13
        for <linux-xfs@vger.kernel.org>; Fri, 14 Feb 2020 10:59:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bPoJRjMNrY9ooQ5w2MXOpka1uriWvZg33XXV+CXakPs=;
        b=AMS/hMT8v9LL0jE5u9mCowIDra5PSSiwcMghwUyPCtZHCsrnPVDCzIvCqvgWYan99l
         sSZB/+WxzxCSr9FRn7yxd+giSLbDaEogzaFUoh+h7acCEbX3/J1bj5/PZwSd/1b6mw+w
         SFZVGrZunzR4/tY5xsVAqHGXzArrjJaAq/9Giwsz1KgFlTz8OyG6Me4aUCV/hdtugANA
         /FPKXVone3pG8nobC4j1DzeMMguA/fyqbv6qBDGIx7Z4INSVhxc9+ntIx6Mt3i/mA2fV
         GEWnGMfO4DEVC4Qy7DyFc9TtiylQEHNMC9DKF9u4jxb0zEheEjB/LQWAwJmyFk3ceMIb
         yVWA==
X-Gm-Message-State: APjAAAUuKCPZ+VVVM1oaQlVdSG4i5vbZ7CoOMZAHfKA9y/0QjSuciAb1
        XehM0XlN9csSGBeqgeyAaeN5FhVpo+M+NpFbq+hJH1iODxKbrYGfgrJ9jalnfHfrhWh8ggq+hD9
        5mpp8dNhaO3O3ZdpCxOcn
X-Received: by 2002:adf:cd91:: with SMTP id q17mr5452572wrj.306.1581706784715;
        Fri, 14 Feb 2020 10:59:44 -0800 (PST)
X-Google-Smtp-Source: APXvYqyKY4R/clr4T4Sp9znflJJ8OCPE3PWiUgEMSA5d0aVwM9YY3g9D/oJ6w4T8S45/cn/y14cSFw==
X-Received: by 2002:adf:cd91:: with SMTP id q17mr5452555wrj.306.1581706784442;
        Fri, 14 Feb 2020 10:59:44 -0800 (PST)
Received: from localhost.localdomain.com (243.206.broadband12.iol.cz. [90.179.206.243])
        by smtp.gmail.com with ESMTPSA id c9sm8287475wmc.47.2020.02.14.10.59.43
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2020 10:59:43 -0800 (PST)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v5 1/4] xfs: Refactor xfs_isilocked()
Date:   Fri, 14 Feb 2020 19:59:39 +0100
Message-Id: <20200214185942.1147742-1-preichl@redhat.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Refactor xfs_isilocked() to use newly introduced __xfs_rwsem_islocked().
__xfs_rwsem_islocked() is a helper function which encapsulates checking
state of rw_semaphores hold by inode.

Signed-off-by: Pavel Reichl <preichl@redhat.com>
Suggested-by: Dave Chinner <dchinner@redhat.com>
Suggested-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/xfs_inode.c | 54 ++++++++++++++++++++++++++++++++--------------
 fs/xfs/xfs_inode.h |  2 +-
 2 files changed, 39 insertions(+), 17 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index c5077e6326c7..3d28c4790231 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -345,32 +345,54 @@ xfs_ilock_demote(
 }
 
 #if defined(DEBUG) || defined(XFS_WARN)
-int
+static inline bool
+__xfs_rwsem_islocked(
+	struct rw_semaphore	*rwsem,
+	bool			shared,
+	bool			excl)
+{
+	bool locked = false;
+
+	if (!rwsem_is_locked(rwsem))
+		return false;
+
+	if (!debug_locks)
+		return true;
+
+	if (shared)
+		locked = lockdep_is_held_type(rwsem, 0);
+
+	if (excl)
+		locked |= lockdep_is_held_type(rwsem, 1);
+
+	return locked;
+}
+
+bool
 xfs_isilocked(
-	xfs_inode_t		*ip,
+	struct xfs_inode	*ip,
 	uint			lock_flags)
 {
-	if (lock_flags & (XFS_ILOCK_EXCL|XFS_ILOCK_SHARED)) {
-		if (!(lock_flags & XFS_ILOCK_SHARED))
-			return !!ip->i_lock.mr_writer;
-		return rwsem_is_locked(&ip->i_lock.mr_lock);
+	if (lock_flags & (XFS_ILOCK_EXCL | XFS_ILOCK_SHARED)) {
+		return __xfs_rwsem_islocked(&ip->i_lock.mr_lock,
+				(lock_flags & XFS_ILOCK_SHARED),
+				(lock_flags & XFS_ILOCK_EXCL));
 	}
 
-	if (lock_flags & (XFS_MMAPLOCK_EXCL|XFS_MMAPLOCK_SHARED)) {
-		if (!(lock_flags & XFS_MMAPLOCK_SHARED))
-			return !!ip->i_mmaplock.mr_writer;
-		return rwsem_is_locked(&ip->i_mmaplock.mr_lock);
+	if (lock_flags & (XFS_MMAPLOCK_EXCL | XFS_MMAPLOCK_SHARED)) {
+		return __xfs_rwsem_islocked(&ip->i_mmaplock.mr_lock,
+				(lock_flags & XFS_MMAPLOCK_SHARED),
+				(lock_flags & XFS_MMAPLOCK_EXCL));
 	}
 
-	if (lock_flags & (XFS_IOLOCK_EXCL|XFS_IOLOCK_SHARED)) {
-		if (!(lock_flags & XFS_IOLOCK_SHARED))
-			return !debug_locks ||
-				lockdep_is_held_type(&VFS_I(ip)->i_rwsem, 0);
-		return rwsem_is_locked(&VFS_I(ip)->i_rwsem);
+	if (lock_flags & (XFS_IOLOCK_EXCL | XFS_IOLOCK_SHARED)) {
+		return __xfs_rwsem_islocked(&VFS_I(ip)->i_rwsem,
+				(lock_flags & XFS_IOLOCK_SHARED),
+				(lock_flags & XFS_IOLOCK_EXCL));
 	}
 
 	ASSERT(0);
-	return 0;
+	return false;
 }
 #endif
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 492e53992fa9..3d7ce355407d 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -416,7 +416,7 @@ void		xfs_ilock(xfs_inode_t *, uint);
 int		xfs_ilock_nowait(xfs_inode_t *, uint);
 void		xfs_iunlock(xfs_inode_t *, uint);
 void		xfs_ilock_demote(xfs_inode_t *, uint);
-int		xfs_isilocked(xfs_inode_t *, uint);
+bool		xfs_isilocked(xfs_inode_t *, uint);
 uint		xfs_ilock_data_map_shared(struct xfs_inode *);
 uint		xfs_ilock_attr_map_shared(struct xfs_inode *);
 
-- 
2.24.1

