Return-Path: <SRS0=AlMJ=EI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E9A7C00A89
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Nov 2020 19:41:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 336F02225E
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Nov 2020 19:41:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gbNs8AnF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726429AbgKBTlo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Nov 2020 14:41:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47403 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725809AbgKBTlo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Nov 2020 14:41:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604346102;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O0RJXfqUT3H9pvNH7MF90A4xM8aPblarY9jXhkF/mZQ=;
        b=gbNs8AnF04/d9pQ2EeOIff9dqmBriy+BCJdDS+52wDeu6n1EncAd3ItOrjG0KHZMxjVmZA
        geX/AuAOV9lf+niFPNdY+B4oG0z8eJwPm5B2cQJ9kqAH3+klAXfOeqDRoDMDh/HN/x8eLk
        OMgioo7WxCPR5FvhOI8oRNf2vXItjGM=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-337-ZrCMx2Q4O0aOOcKZksZN3w-1; Mon, 02 Nov 2020 14:41:40 -0500
X-MC-Unique: ZrCMx2Q4O0aOOcKZksZN3w-1
Received: by mail-wr1-f69.google.com with SMTP id 11so5726090wrc.3
        for <linux-xfs@vger.kernel.org>; Mon, 02 Nov 2020 11:41:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O0RJXfqUT3H9pvNH7MF90A4xM8aPblarY9jXhkF/mZQ=;
        b=C9cFWC0iIoFjyK4rFM2BAE8amTyDG/XVFUKpWQ2WWHII43XazcKdHhPzBCyzLz6Gzl
         fIz1v0W4iulnQ7hNcTZheShF6z+QHIPYW8Sg0/1E+WsepRQIcmBB9VC9373EVdDm6qNw
         21X9ZicKHqEzhy7CRZN+j36leBno0rFH84eCg3/fnspR8aD13X/IUQvVt2rgE4Q60dLs
         lJDn49SW7C2frDY1rMlFDDBO7VT2TaZTktCJ/JJ/aB4SqHbv/BgaxMpFVYo3IV1yVHYN
         5GBPP2ZkfD3MOK0hby+kjlbvgm2azra+AEGUeUNjKk0g3tDepd8wg32CVtIeo2VX/C6x
         7QHA==
X-Gm-Message-State: AOAM531GnLsxS6H5sjEkSWIJ6Ret6I7tTga86Xe21o6llTYOanndFdXx
        BfkuvAqYhHfCZjzBPxehvOb3Dyj1hjP5U/23XbiBEZfILfBCyiqu+GAo4BcdJdLsSzjQYT8eS4G
        bLJd5pD4dt8M/6w/FEYpm
X-Received: by 2002:adf:ab02:: with SMTP id q2mr13242569wrc.320.1604346099033;
        Mon, 02 Nov 2020 11:41:39 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzm0k0Pn6i2+eujcsxOrBnQy1yMZG+ZZGuzCF+TpzAHEke35diXy6eBINxIQkvlRaF7LOol7Q==
X-Received: by 2002:adf:ab02:: with SMTP id q2mr13242556wrc.320.1604346098800;
        Mon, 02 Nov 2020 11:41:38 -0800 (PST)
Received: from localhost.localdomain ([84.19.91.81])
        by smtp.gmail.com with ESMTPSA id 6sm11742465wrc.88.2020.11.02.11.41.37
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 11:41:38 -0800 (PST)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v13 1/4] xfs: Refactor xfs_isilocked()
Date:   Mon,  2 Nov 2020 20:41:32 +0100
Message-Id: <20201102194135.174806-2-preichl@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201102194135.174806-1-preichl@redhat.com>
References: <20201102194135.174806-1-preichl@redhat.com>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_inode.c | 39 +++++++++++++++++++++++++++++++--------
 fs/xfs/xfs_inode.h | 21 ++++++++++++++-------
 2 files changed, 45 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 2bfbcf28b1bd..efe4a0afa23e 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -345,9 +345,34 @@ xfs_ilock_demote(
 }
 
 #if defined(DEBUG) || defined(XFS_WARN)
-int
+static inline bool
+__xfs_rwsem_islocked(
+	struct rw_semaphore	*rwsem,
+	int			lock_flags,
+	int			shift)
+{
+	lock_flags >>= shift;
+
+	if (!debug_locks)
+		return rwsem_is_locked(rwsem);
+	/*
+	 * If the shared flag is not set, pass 0 to explicitly check for
+	 * exclusive access to the lock. If the shared flag is set, we typically
+	 * want to make sure the lock is at least held in shared mode
+	 * (i.e., shared | excl) but we don't necessarily care that it might
+	 * actually be held exclusive. Therefore, pass -1 to check whether the
+	 * lock is held in any mode rather than one of the explicit shared mode
+	 * values (1 or 2)."
+	 */
+	if (lock_flags & 1 << XFS_SHARED_LOCK_SHIFT) {
+		return lockdep_is_held_type(rwsem, -1);
+	}
+	return lockdep_is_held_type(rwsem, 0);
+}
+
+bool
 xfs_isilocked(
-	xfs_inode_t		*ip,
+	struct xfs_inode	*ip,
 	uint			lock_flags)
 {
 	if (lock_flags & (XFS_ILOCK_EXCL|XFS_ILOCK_SHARED)) {
@@ -362,15 +387,13 @@ xfs_isilocked(
 		return rwsem_is_locked(&ip->i_mmaplock.mr_lock);
 	}
 
-	if (lock_flags & (XFS_IOLOCK_EXCL|XFS_IOLOCK_SHARED)) {
-		if (!(lock_flags & XFS_IOLOCK_SHARED))
-			return !debug_locks ||
-				lockdep_is_held_type(&VFS_I(ip)->i_rwsem, 0);
-		return rwsem_is_locked(&VFS_I(ip)->i_rwsem);
+	if (lock_flags & (XFS_IOLOCK_EXCL | XFS_IOLOCK_SHARED)) {
+		return __xfs_rwsem_islocked(&VFS_I(ip)->i_rwsem, lock_flags,
+				XFS_IOLOCK_FLAG_SHIFT);
 	}
 
 	ASSERT(0);
-	return 0;
+	return false;
 }
 #endif
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 751a3d1d7d84..1392a9c452ae 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -242,12 +242,19 @@ static inline bool xfs_inode_has_bigtime(struct xfs_inode *ip)
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
+#define XFS_IOLOCK_EXCL		(1 << XFS_IOLOCK_FLAG_SHIFT)
+#define XFS_IOLOCK_SHARED	(XFS_IOLOCK_EXCL << XFS_SHARED_LOCK_SHIFT)
+#define XFS_ILOCK_EXCL		(1 << XFS_ILOCK_FLAG_SHIFT)
+#define XFS_ILOCK_SHARED	(XFS_ILOCK_EXCL << XFS_SHARED_LOCK_SHIFT)
+#define XFS_MMAPLOCK_EXCL	(1 << XFS_MMAPLOCK_FLAG_SHIFT)
+#define XFS_MMAPLOCK_SHARED	(XFS_MMAPLOCK_EXCL << XFS_SHARED_LOCK_SHIFT)
 
 #define XFS_LOCK_MASK		(XFS_IOLOCK_EXCL | XFS_IOLOCK_SHARED \
 				| XFS_ILOCK_EXCL | XFS_ILOCK_SHARED \
@@ -386,7 +393,7 @@ void		xfs_ilock(xfs_inode_t *, uint);
 int		xfs_ilock_nowait(xfs_inode_t *, uint);
 void		xfs_iunlock(xfs_inode_t *, uint);
 void		xfs_ilock_demote(xfs_inode_t *, uint);
-int		xfs_isilocked(xfs_inode_t *, uint);
+bool		xfs_isilocked(struct xfs_inode *, uint);
 uint		xfs_ilock_data_map_shared(struct xfs_inode *);
 uint		xfs_ilock_attr_map_shared(struct xfs_inode *);
 
-- 
2.26.2

