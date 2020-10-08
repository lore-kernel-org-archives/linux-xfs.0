Return-Path: <SRS0=9l/N=DP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14E03C4363C
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Oct 2020 13:46:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B48582184D
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Oct 2020 13:46:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UtQB3/V6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730361AbgJHNqO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 8 Oct 2020 09:46:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:21653 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730387AbgJHNqN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Oct 2020 09:46:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602164772;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cFGfkrRBjPPb/whN2KYzusQD8yRyWLH03wTWdOhqzfw=;
        b=UtQB3/V6sIMI3oMQNkAM46S06qsffegaFi9qzolLkv8IyTyvXL7AQwVm+BiHO7YZAI4QRM
        i+8kXUpYkYBP8/AgItV1D/Mu5/05JUPepvJCTlFxn4j1zx7gOwSFKNsszTnbs3fjH4m/Qb
        OCaJaddlaLRDtLByuW0wNkwoHYZRdfA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-202-NXkh1bRLNYOqNgXXtPfeMA-1; Thu, 08 Oct 2020 09:46:10 -0400
X-MC-Unique: NXkh1bRLNYOqNgXXtPfeMA-1
Received: by mail-wr1-f72.google.com with SMTP id n14so424999wrp.1
        for <linux-xfs@vger.kernel.org>; Thu, 08 Oct 2020 06:46:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cFGfkrRBjPPb/whN2KYzusQD8yRyWLH03wTWdOhqzfw=;
        b=P2B0SkE/ABAMjuwJ8VchvF69/i/RHbAjPm2RbYcH6zdSdh1rgjklGVKfLZyozeLy7W
         VUsF/50tooXhSkxZGw/WztS+sCdAg+eGy6VhWFKoGsgwP9dtHow6fwr33SWUjP8cyjv+
         CR47zTvXrG54Va89M0o64ElkW15uFCqh4VE5uJUW4KmkkEiwyk37uG7/DuqtY4tdt2zh
         9TjXibJXKyajsN0nD4wTKamX/Ba4+/h2UsHTfD1pb+xdEmAz0SRNK1l2aQxuhCJ6RDho
         tQMdq6JJ44pJRi/fhx3SrXBtn4V9OAOvq06jKCROx0UbRo8KJ5vhcsfM9AArjsXqTYYg
         BSNA==
X-Gm-Message-State: AOAM532q2kNPO5CsFhXLKH2sJ3ErcFGc98yIBhlSVv7DUOrbCPW+evPk
        T4vj5mWMpsEYAb6EG5DdsfGHkhdXR0Nu3DfFbSBeXhdP/w2hL9FIOdpC8/w1bySYniVmSvXX/p0
        NEmOpSHkwMG1sxHofxsv/
X-Received: by 2002:adf:f548:: with SMTP id j8mr9837182wrp.114.1602164768791;
        Thu, 08 Oct 2020 06:46:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxu6oWpj6AvVHJzubXqt/JtR/aErHpzjPLnKn9aQIbGQeHQjhsQNmKtGFEKMulF3/cDmX/kKg==
X-Received: by 2002:adf:f548:: with SMTP id j8mr9837166wrp.114.1602164768590;
        Thu, 08 Oct 2020 06:46:08 -0700 (PDT)
Received: from localhost.localdomain.com ([84.19.91.81])
        by smtp.gmail.com with ESMTPSA id s19sm7069465wmc.41.2020.10.08.06.46.07
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 06:46:07 -0700 (PDT)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v10 1/4] xfs: Refactor xfs_isilocked()
Date:   Thu,  8 Oct 2020 15:46:02 +0200
Message-Id: <20201008134605.863269-2-preichl@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201008134605.863269-1-preichl@redhat.com>
References: <20201008134605.863269-1-preichl@redhat.com>
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

