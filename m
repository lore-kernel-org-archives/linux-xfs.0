Return-Path: <SRS0=eQWr=DM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A408AC4727D
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Oct 2020 21:39:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53AD92083B
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Oct 2020 21:39:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bWC7PaBR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726692AbgJEVi7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Oct 2020 17:38:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47337 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726685AbgJEVi7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Oct 2020 17:38:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601933937;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TOh0YDpvNjX+rcObXo523OUYbm/24DDF2+v1+gMlk9E=;
        b=bWC7PaBRnGIjXLW45B+5FgTSDAZ2Jiz8/E/RVG6oyI6Z5sf5B5+iycQMONX3Pqog5Ib/lv
        pp3Prjcs6ziDnf6fKuGNbsFvSs0vXIpg+SUeTOKVZgrvX5XnccHcj3HafaOIGTL5c7tFtb
        Iy9bY3PlfHVCg0vEGlis3vNmMZw1iRI=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-393-SaY9npiONMms4HUcXfUwKg-1; Mon, 05 Oct 2020 17:38:56 -0400
X-MC-Unique: SaY9npiONMms4HUcXfUwKg-1
Received: by mail-wr1-f72.google.com with SMTP id d9so4500367wrv.16
        for <linux-xfs@vger.kernel.org>; Mon, 05 Oct 2020 14:38:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TOh0YDpvNjX+rcObXo523OUYbm/24DDF2+v1+gMlk9E=;
        b=QBdZiUhU9DHy8jywc01blmbYRcztNhLy2ngtLgVLycR0wJrpOnLAYbYdIm4+LSk3ir
         tuSSI0nNPtzP37pBmeGB2U7rYM1jaxqk6yURVEvYi25UH9hT44Cu1TV6ciJf6MeUhL80
         TbzhDf1ox6qUfRwnJxS2O4WJHZGgwRcfUK54iqZsN/ebvScel6yAtzkwP7El0jY1+v6Q
         Vc3xag/RDk09A7x6Zh9Yv5d1BkU+YXv0sdhAe/jmPgYpBXzwMZiWam79nUNaBFQdE9Q1
         SGCG2nqqNzeFyd/W3oJhj2PK4Q3YhLiKWCjukaGZjU6CbJdLKqPdueYgnqONwZ5mS8cG
         g9Pg==
X-Gm-Message-State: AOAM531pOnSHMa9uZiFwsZUQfpMJRvagSENmwfP+Rm3DisK3rDPfPkkk
        +74bExHwallq+GZy0tHgIzQkVWjYxasZiPxSb77p9M2VBuDRZ1bOfsepQ7KMaLWArnK6YYZlDfb
        YRKODgOkgyIwOUDDxy6GH
X-Received: by 2002:adf:f10e:: with SMTP id r14mr1269505wro.337.1601933934626;
        Mon, 05 Oct 2020 14:38:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxMJXsNc8Iq/oF3icoV7ljKTt4Lk/xBmhVT2Y6Vmkp5hq9EzpBQCBoYF1/E54phYI+GPHMw/A==
X-Received: by 2002:adf:f10e:: with SMTP id r14mr1269489wro.337.1601933934428;
        Mon, 05 Oct 2020 14:38:54 -0700 (PDT)
Received: from localhost.localdomain.com ([84.19.91.81])
        by smtp.gmail.com with ESMTPSA id r5sm1576499wrp.15.2020.10.05.14.38.53
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2020 14:38:53 -0700 (PDT)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v8 1/4] xfs: Refactor xfs_isilocked()
Date:   Mon,  5 Oct 2020 23:38:49 +0200
Message-Id: <20201005213852.233004-2-preichl@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201005213852.233004-1-preichl@redhat.com>
References: <20201005213852.233004-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
 fs/xfs/xfs_inode.c | 62 ++++++++++++++++++++++++++++++++++------------
 fs/xfs/xfs_inode.h | 21 ++++++++++------
 2 files changed, 60 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index c06129cffba9..1f39bce96656 100644
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
index e9a8bb184d1f..77d5655191ab 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -268,12 +268,19 @@ static inline void xfs_ifunlock(struct xfs_inode *ip)
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
@@ -412,7 +419,7 @@ void		xfs_ilock(xfs_inode_t *, uint);
 int		xfs_ilock_nowait(xfs_inode_t *, uint);
 void		xfs_iunlock(xfs_inode_t *, uint);
 void		xfs_ilock_demote(xfs_inode_t *, uint);
-int		xfs_isilocked(xfs_inode_t *, uint);
+bool		xfs_isilocked(xfs_inode_t *, uint);
 uint		xfs_ilock_data_map_shared(struct xfs_inode *);
 uint		xfs_ilock_attr_map_shared(struct xfs_inode *);
 
-- 
2.26.2

