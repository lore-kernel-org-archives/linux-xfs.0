Return-Path: <SRS0=Vfs/=DQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A976C83BA8
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Oct 2020 19:56:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10753225A9
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Oct 2020 19:56:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Nmp22y4a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732138AbgJIT42 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Oct 2020 15:56:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:44647 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389820AbgJITzX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Oct 2020 15:55:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602273322;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pew4BTLvi7Eq8XKKCXi8A7r5tvxC5w7vgzcsal8DL9Q=;
        b=Nmp22y4aGF0socFkGKcUPAu1w5LUlk+VRKfjCuIOVhm/fDjZafc0dykdX7b+z0MTLsyyfy
        BqenfavkYHPcaxKE8YhZ6ne24kebWITk0l+xFpero8sRtZq+7C4dJSPfhQ/yIPyEnlzgus
        fxG4cKdjAnaD1ml5qUbD+MbChFSh6EE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-146-QYrXHmo9NHOfANuYwOfGNA-1; Fri, 09 Oct 2020 15:55:20 -0400
X-MC-Unique: QYrXHmo9NHOfANuYwOfGNA-1
Received: by mail-wm1-f70.google.com with SMTP id l15so4387152wmh.9
        for <linux-xfs@vger.kernel.org>; Fri, 09 Oct 2020 12:55:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pew4BTLvi7Eq8XKKCXi8A7r5tvxC5w7vgzcsal8DL9Q=;
        b=GZx/r4h1KDQem+xf0drC5bcezFXXzHGAqau14sLKyQbHRFiyUC10Lu3CQTaPoPkrQ+
         9oJH/XcsQat7V8T4Xq38sYvGBsTffo4cDatWCPRh3ZCh6Nao8h3eyotSEwr30xHFG62c
         lg9wSh3Pn0yJS6RDcXw56YzIbUV90rBUFt9SOrtP2toBtWVup7XUvEm6McUv/G0C2wif
         uyvFFLk13omPvVzzyCb7Fd40UTe/Ia+w+vd2BrkbemrNlAgcTa6h2uQosq1orAqATEPS
         gnSt+v/cgv5CGAQ5lWVYP8/N+f9K0Az7kCYx9D8TnDCCq69xa9Wnmo9EtN2XvQxX++7v
         8ByA==
X-Gm-Message-State: AOAM533kRA/TrVP6CYJT6S/t3rGqEgfdR9Ll2UeqshDsR2cHjouSe0Ui
        /JX2MsCVjw8HJEhjugWNXKTRvtY0pQisJHtXLERo6rJX5Q7FzR4m/lEel7fQsM3lsiO7qQSaIfT
        nG5JBsGlhddVbzdFQ2MXX
X-Received: by 2002:adf:9027:: with SMTP id h36mr8663665wrh.163.1602273318480;
        Fri, 09 Oct 2020 12:55:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy9x7vepYxratMrcz+xsEhsKNyF77nV37+wTuh6CUp8NdXLnWF8uOWhpq506MbVQLcDggaB1Q==
X-Received: by 2002:adf:9027:: with SMTP id h36mr8663651wrh.163.1602273318220;
        Fri, 09 Oct 2020 12:55:18 -0700 (PDT)
Received: from localhost.localdomain.com ([84.19.91.81])
        by smtp.gmail.com with ESMTPSA id u2sm14069451wre.7.2020.10.09.12.55.17
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2020 12:55:17 -0700 (PDT)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v11 1/4] xfs: Refactor xfs_isilocked()
Date:   Fri,  9 Oct 2020 21:55:12 +0200
Message-Id: <20201009195515.82889-2-preichl@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201009195515.82889-1-preichl@redhat.com>
References: <20201009195515.82889-1-preichl@redhat.com>
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
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_inode.c | 48 ++++++++++++++++++++++++++++++++++++++--------
 fs/xfs/xfs_inode.h | 21 +++++++++++++-------
 2 files changed, 54 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index c06129cffba9..7c1ceb4df4ec 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -345,9 +345,43 @@ xfs_ilock_demote(
 }
 
 #if defined(DEBUG) || defined(XFS_WARN)
-int
+static inline bool
+__xfs_rwsem_islocked(
+	struct rw_semaphore	*rwsem,
+	int			lock_flags)
+{
+	int			arg;
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
 	if (lock_flags & (XFS_ILOCK_EXCL|XFS_ILOCK_SHARED)) {
@@ -362,15 +396,13 @@ xfs_isilocked(
 		return rwsem_is_locked(&ip->i_mmaplock.mr_lock);
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
index e9a8bb184d1f..77776af75c77 100644
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
+bool		xfs_isilocked(struct xfs_inode *, uint);
 uint		xfs_ilock_data_map_shared(struct xfs_inode *);
 uint		xfs_ilock_attr_map_shared(struct xfs_inode *);
 
-- 
2.26.2

