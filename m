Return-Path: <SRS0=3qtu=37=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F129C35242
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Feb 2020 22:10:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 62CFC20708
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Feb 2020 22:10:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G9eGW/J2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727111AbgBKWKZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Feb 2020 17:10:25 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:60596 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727054AbgBKWKY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Feb 2020 17:10:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581459024;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=CIHj4fmFOPkcDFDIVcWIGi8WITB3+o9MuIUoCmi4ZKY=;
        b=G9eGW/J2Hi9M4P8uZrlKNKqu0dm+Vi9UUKjC74WytfalVppRAbxsUP/MDKFrOaxwQb9v0+
        pnJ++CE9RKsWbwRgn609jjcRITghbU0E/kgZSbl4R9o5X3BR3zeapKMn9slfl4rzQ9VlYO
        YcttY87hrj0dHqlwvyl8xjcJSPeQZJM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-390-aR4UM8CZME6FGd4eRQle5A-1; Tue, 11 Feb 2020 17:10:21 -0500
X-MC-Unique: aR4UM8CZME6FGd4eRQle5A-1
Received: by mail-wr1-f71.google.com with SMTP id n23so7675703wra.20
        for <linux-xfs@vger.kernel.org>; Tue, 11 Feb 2020 14:10:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CIHj4fmFOPkcDFDIVcWIGi8WITB3+o9MuIUoCmi4ZKY=;
        b=nSvli2UWJyf3O7Pfl3eICvE4mNPOPL6Mva63sx4AUVsiQ6nBiGYXapdYes65vDcAR8
         dS7qWgWiI4MnjNvt+xXEvdXBMNpPcr6Fxpjqent01nOGFCdzG5r6k8Zig475rH4zAecQ
         ObrXDedQc2t/tP6+Rn8AWzXUnwhzhOJZRIuDrH670z1CQpYOfGGlNp0+f1Wm6bVmXgqd
         qqWzXje4vryn00nhOfRlHe55PINwCvptOZe35uJty9qOoCVU/DqN2dzzknQSQLD+iker
         cRYQ12kDWuIdv1sP3J4sLRDNcckUsfCBbFxtJGsHtWMPIlttw0KdP5hfMgFKWobQp7Bf
         aozQ==
X-Gm-Message-State: APjAAAUqjqh218zKhNT4FcM2nbuf3RqarxAh9kCs3Q6W+LPd0IqBSvSO
        vYbCpFi7wkjJfbkMiw6MTetDuqdpe0tzLLkqFcvG2xWK7eDxpCOKG6Zl3ohMk4HIdsT6Zt4mA/t
        xa+dpUzKupCxmT0mieAoe
X-Received: by 2002:a1c:6a16:: with SMTP id f22mr7861389wmc.53.1581459019836;
        Tue, 11 Feb 2020 14:10:19 -0800 (PST)
X-Google-Smtp-Source: APXvYqwh71D7CtpfEocX+t/YqT5oQ3B/V7hoENWFJ2njgWT7uL0Xr5w843zVAaOD1gYD9tjqrVMw1A==
X-Received: by 2002:a1c:6a16:: with SMTP id f22mr7861379wmc.53.1581459019597;
        Tue, 11 Feb 2020 14:10:19 -0800 (PST)
Received: from localhost.localdomain.com (243.206.broadband12.iol.cz. [90.179.206.243])
        by smtp.gmail.com with ESMTPSA id p12sm4896786wrx.10.2020.02.11.14.10.18
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2020 14:10:19 -0800 (PST)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v4 1/4] xfs: Refactor xfs_isilocked()
Date:   Tue, 11 Feb 2020 23:10:15 +0100
Message-Id: <20200211221018.709125-1-preichl@redhat.com>
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
Changelog from V3:
Added ASSERTS() to isilocked() to make sure that only flags for a single
type of lock are passed 


 fs/xfs/xfs_inode.c | 51 ++++++++++++++++++++++++++++++++++------------
 fs/xfs/xfs_inode.h |  2 +-
 2 files changed, 39 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index c5077e6326c7..cfefa7543b37 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -345,32 +345,57 @@ xfs_ilock_demote(
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
 	if (lock_flags & (XFS_ILOCK_EXCL|XFS_ILOCK_SHARED)) {
-		if (!(lock_flags & XFS_ILOCK_SHARED))
-			return !!ip->i_lock.mr_writer;
-		return rwsem_is_locked(&ip->i_lock.mr_lock);
+		ASSERT(!(lock_flags & ~(XFS_ILOCK_EXCL|XFS_ILOCK_SHARED)));
+		return __xfs_rwsem_islocked(&ip->i_lock.mr_lock,
+				(lock_flags & XFS_ILOCK_SHARED),
+				(lock_flags & XFS_ILOCK_EXCL));
 	}
 
 	if (lock_flags & (XFS_MMAPLOCK_EXCL|XFS_MMAPLOCK_SHARED)) {
-		if (!(lock_flags & XFS_MMAPLOCK_SHARED))
-			return !!ip->i_mmaplock.mr_writer;
-		return rwsem_is_locked(&ip->i_mmaplock.mr_lock);
+		ASSERT(!(lock_flags & ~(XFS_MMAPLOCK_EXCL|XFS_MMAPLOCK_SHARED)));
+		return __xfs_rwsem_islocked(&ip->i_mmaplock.mr_lock,
+				(lock_flags & XFS_MMAPLOCK_SHARED),
+				(lock_flags & XFS_MMAPLOCK_EXCL));
 	}
 
 	if (lock_flags & (XFS_IOLOCK_EXCL|XFS_IOLOCK_SHARED)) {
-		if (!(lock_flags & XFS_IOLOCK_SHARED))
-			return !debug_locks ||
-				lockdep_is_held_type(&VFS_I(ip)->i_rwsem, 0);
-		return rwsem_is_locked(&VFS_I(ip)->i_rwsem);
+		ASSERT(!(lock_flags & ~(XFS_IOLOCK_EXCL|XFS_IOLOCK_SHARED)));
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

