Return-Path: <SRS0=ynSb=5F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6DBEC4332B
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Mar 2020 21:03:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D44120658
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Mar 2020 21:03:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WyHiQkKy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbgCTVDg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 Mar 2020 17:03:36 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:60122 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727261AbgCTVDf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Mar 2020 17:03:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584738215;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lAxEUE3XwljgZQNfiIhQ1uRgNkAw845DwaZy+s3uKVE=;
        b=WyHiQkKyiAUn3Zpw3o58mVRcV9bXYVEcmlwl4HEgY23+mLFFg9F2ogitdE32FBaOeY6qRm
        YcZbamPwsH7nfqjHjugaYzQOqyfeUlwSC710B7c/rB3rNzn4QIsZXh9HOsp3eZrQSVgUQz
        jx5HlPEtqyCIyVJapZBA8F/vZOwme9U=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-39-4V9FiKXvP16iNt3NX_N6VQ-1; Fri, 20 Mar 2020 17:03:33 -0400
X-MC-Unique: 4V9FiKXvP16iNt3NX_N6VQ-1
Received: by mail-wr1-f72.google.com with SMTP id p2so3205872wrw.8
        for <linux-xfs@vger.kernel.org>; Fri, 20 Mar 2020 14:03:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lAxEUE3XwljgZQNfiIhQ1uRgNkAw845DwaZy+s3uKVE=;
        b=fLrdEEmwy4fmpRTbQt2oUc6Shovj3sSkN2EwCliL9kX4Uf0cJimPQcK9MRGhwthyWJ
         qWUtVc33pl+qWSBzQolTbeNCkPFuh+hzGr7f5/ShMy69hJYcX0rMOkmHq6mvW1Bv8LLe
         Qk0BKF3uQUeL5C7wFNeoBpzQDFzQ13V0l0UpdWrNiooV9oneDFSmB/gDoHaehUYOISS9
         i5U1QZu4uzRxbLJSEBOhLCAAEXPdP3fKi7hbqGwu6b6+Fwm6XyJH+peokn7MxGv7xMXp
         XukHPJlWGMPqDjOLRWWL0BrGtXHfgYJvmA6JVdwR5QjshAUjCO4a9vlPRuSDMpm8RTAU
         9+fw==
X-Gm-Message-State: ANhLgQ1Vs6PrTdw+p2FzoVRXWlkM4bHH/moauHKFvnZyiDyxous4RxPz
        qXixxt+cKf26RG3KqkNRb6cPM7RKs64a1c8fy+AJ2x54VZtfxbJxMJFrs7TalhI56i9qrTnyXWs
        qFEH1urY+EL//sfqEzWHA
X-Received: by 2002:adf:f749:: with SMTP id z9mr12880955wrp.332.1584738211764;
        Fri, 20 Mar 2020 14:03:31 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vuTF0EVi56lFI2qhq+DVgfTSz/Scp0AxQjHd4MBXpYA7AIYRlJHBrWx4WpL9RF5WAXXIuOkSg==
X-Received: by 2002:adf:f749:: with SMTP id z9mr12880935wrp.332.1584738211534;
        Fri, 20 Mar 2020 14:03:31 -0700 (PDT)
Received: from localhost.localdomain.com (243.206.broadband12.iol.cz. [90.179.206.243])
        by smtp.gmail.com with ESMTPSA id w7sm10479668wrr.60.2020.03.20.14.03.24
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2020 14:03:30 -0700 (PDT)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v7 1/4] xfs: Refactor xfs_isilocked()
Date:   Fri, 20 Mar 2020 22:03:14 +0100
Message-Id: <20200320210317.1071747-2-preichl@redhat.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200320210317.1071747-1-preichl@redhat.com>
References: <20200320210317.1071747-1-preichl@redhat.com>
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
Suggested-by: Darrick J. Wong <darrick.wong@oracle.com>
---
Changes from V6:
	* __xfs_rwsem_islocked() takes flags param
	* changed logic of __xfs_rwsem_islocked() so that
	holding a rwsem writte-locked implies read access as wel 

 fs/xfs/xfs_inode.c | 62 ++++++++++++++++++++++++++++++++++------------
 fs/xfs/xfs_inode.h | 21 ++++++++++------
 2 files changed, 60 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index c5077e6326c7..db356f815adc 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -345,32 +345,62 @@ xfs_ilock_demote(
 }
 
 #if defined(DEBUG) || defined(XFS_WARN)
-int
+static inline bool
+__xfs_rwsem_islocked(
+	struct rw_semaphore	*rwsem,
+	int			lock_flags)
+{
+	int	arg;
+
+	if (!debug_locks)
+		return rwsem_is_locked(rwsem);
+
+	if (lock_flags & (1 << XFS_SHARED_LOCK_SHIFT)) {
+		/*
+		 * The caller could be asking if we have (shared | excl)
+		 * access to the lock. Ask lockdep if the rwsem is
+		 * locked either for read or write access.
+		 *
+		 * The caller could also be asking if we have only
+		 * shared access to the lock. Holding a rwsem
+		 * write-locked implies read access as well, so the
+		 * request to lockdep is the same for this case.
+		 */
+		arg = -1;
+	} else {
+		/*
+		 * The caller is asking if we have only exclusive access
+		 * to the lock. Ask lockdep if the rwsem is locked for
+		 * write access.
+		 */
+		arg = 0;
+	}
+
+	return lockdep_is_held_type(rwsem, arg);
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
+		return __xfs_rwsem_islocked(&ip->i_lock,
+				(lock_flags >> XFS_ILOCK_FLAG_SHIFT));
 	}
 
-	if (lock_flags & (XFS_MMAPLOCK_EXCL|XFS_MMAPLOCK_SHARED)) {
-		if (!(lock_flags & XFS_MMAPLOCK_SHARED))
-			return !!ip->i_mmaplock.mr_writer;
-		return rwsem_is_locked(&ip->i_mmaplock.mr_lock);
+	if (lock_flags & (XFS_MMAPLOCK_EXCL | XFS_MMAPLOCK_SHARED)) {
+		return __xfs_rwsem_islocked(&ip->i_mmaplock,
+				(lock_flags >> XFS_MMAPLOCK_FLAG_SHIFT));
 	}
 
-	if (lock_flags & (XFS_IOLOCK_EXCL|XFS_IOLOCK_SHARED)) {
-		if (!(lock_flags & XFS_IOLOCK_SHARED))
-			return !debug_locks ||
-				lockdep_is_held_type(&VFS_I(ip)->i_rwsem, 0);
-		return rwsem_is_locked(&VFS_I(ip)->i_rwsem);
+	if (lock_flags & (XFS_IOLOCK_EXCL | XFS_IOLOCK_SHARED)) {
+		return __xfs_rwsem_islocked(&VFS_I(ip)->i_rwsem,
+				(lock_flags >> XFS_IOLOCK_FLAG_SHIFT));
 	}
 
 	ASSERT(0);
-	return 0;
+	return false;
 }
 #endif
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 492e53992fa9..8df2c9e1a34e 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -272,12 +272,19 @@ static inline void xfs_ifunlock(struct xfs_inode *ip)
  * Bit ranges:	1<<1  - 1<<16-1 -- iolock/ilock modes (bitfield)
  *		1<<16 - 1<<32-1 -- lockdep annotation (integers)
  */
-#define	XFS_IOLOCK_EXCL		(1<<0)
-#define	XFS_IOLOCK_SHARED	(1<<1)
-#define	XFS_ILOCK_EXCL		(1<<2)
-#define	XFS_ILOCK_SHARED	(1<<3)
-#define	XFS_MMAPLOCK_EXCL	(1<<4)
-#define	XFS_MMAPLOCK_SHARED	(1<<5)
+
+#define XFS_IOLOCK_FLAG_SHIFT	0
+#define XFS_ILOCK_FLAG_SHIFT	2
+#define XFS_MMAPLOCK_FLAG_SHIFT	4
+
+#define XFS_SHARED_LOCK_SHIFT	1
+
+#define XFS_IOLOCK_EXCL		(1 << (XFS_IOLOCK_FLAG_SHIFT))
+#define XFS_IOLOCK_SHARED	(XFS_IOLOCK_EXCL << (XFS_SHARED_LOCK_SHIFT))
+#define XFS_ILOCK_EXCL		(1 << (XFS_ILOCK_FLAG_SHIFT))
+#define XFS_ILOCK_SHARED	(XFS_ILOCK_EXCL << (XFS_SHARED_LOCK_SHIFT))
+#define XFS_MMAPLOCK_EXCL	(1 << (XFS_MMAPLOCK_FLAG_SHIFT))
+#define XFS_MMAPLOCK_SHARED	(XFS_MMAPLOCK_EXCL << (XFS_SHARED_LOCK_SHIFT))
 
 #define XFS_LOCK_MASK		(XFS_IOLOCK_EXCL | XFS_IOLOCK_SHARED \
 				| XFS_ILOCK_EXCL | XFS_ILOCK_SHARED \
@@ -416,7 +423,7 @@ void		xfs_ilock(xfs_inode_t *, uint);
 int		xfs_ilock_nowait(xfs_inode_t *, uint);
 void		xfs_iunlock(xfs_inode_t *, uint);
 void		xfs_ilock_demote(xfs_inode_t *, uint);
-int		xfs_isilocked(xfs_inode_t *, uint);
+bool		xfs_isilocked(xfs_inode_t *, uint);
 uint		xfs_ilock_data_map_shared(struct xfs_inode *);
 uint		xfs_ilock_attr_map_shared(struct xfs_inode *);
 
-- 
2.25.1

