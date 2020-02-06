Return-Path: <SRS0=lRpT=32=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4E99C35247
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Feb 2020 19:05:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E2CF21741
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Feb 2020 19:05:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KR64D4Ke"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727884AbgBFTFM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Feb 2020 14:05:12 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:57610 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727698AbgBFTFM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Feb 2020 14:05:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581015911;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zzke4bK+UMofBGA/WHc6y1qD10IGk0OhcAncB7cBOQ4=;
        b=KR64D4Keo0JNMpa8hJcMG6K8Me/HUbfA6yiTG2FEmfnlMx7SxM/M1Z/tB/lFbHfhK+MjgJ
        ymVcjxsDLv/XhKxOlhzIkWTnAnotb6f/RQ6Q7FAmMCgaR52lLn8h0Dx0Oov55TniOWJdZP
        sMyMCnzirs5dvnW1GHoF1xcang9tlkY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-315-7uJAmavAO-eHX8BUU1w-Rg-1; Thu, 06 Feb 2020 14:05:09 -0500
X-MC-Unique: 7uJAmavAO-eHX8BUU1w-Rg-1
Received: by mail-wr1-f72.google.com with SMTP id t3so3936299wrm.23
        for <linux-xfs@vger.kernel.org>; Thu, 06 Feb 2020 11:05:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zzke4bK+UMofBGA/WHc6y1qD10IGk0OhcAncB7cBOQ4=;
        b=djROt6Wh7xINGcuTvrs60YCgXg5LdKhr0Cx2LjzP/0X/OohPrk+lm5wEDX4UwA51Np
         qDElGt2JKg4DSTyYm2mo30ceV8wTB4R9qsBKVkXhXW0ZwcED+PEPHfUKP4qlK/GgGXak
         i+DWZ2yN625jEd9OKgPzJ9uBmc+HVoJa+carOKeEHkhgtZwDzZxtyQ4yp5JhIShCJIka
         owUlL2cTVXxQD4Qv8jU0kwwBHpA3s5FUAH33td4mQrAxCojd0jIb4l2/nDGI56NL35MG
         43HUH4Y6mw0xlW7tKo1W9sVbMA+dgJuP93c0vejiGH8zDdhSekQ7WLtuu+mc6HdjCh6a
         vOcg==
X-Gm-Message-State: APjAAAXF/QdaUjNISA1eva6/UrHAtOnFsEq2D6rlv6a4hbhQmOnn7XGi
        LwXLpC+qERbUj+6CFRHmQR87ekKcq6+O0GRgOV654NdnZ68ZoE7MAWcNvOGcdTGtceYstgI3gGx
        eVs6s5yGPEktCu4XcGlxa
X-Received: by 2002:a5d:610a:: with SMTP id v10mr5112014wrt.267.1581015907768;
        Thu, 06 Feb 2020 11:05:07 -0800 (PST)
X-Google-Smtp-Source: APXvYqyDtSx+o3pGAvBZgzZH47ZUKJVreQ2OLmT1evNkq5M1c+SMxauE2wKt9nBKwFnYu4vCfC1p9w==
X-Received: by 2002:a5d:610a:: with SMTP id v10mr5112004wrt.267.1581015907582;
        Thu, 06 Feb 2020 11:05:07 -0800 (PST)
Received: from localhost.localdomain.com (243.206.broadband12.iol.cz. [90.179.206.243])
        by smtp.gmail.com with ESMTPSA id l29sm215448wrb.64.2020.02.06.11.05.06
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2020 11:05:07 -0800 (PST)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 1/4] xfs: Refactor xfs_isilocked()
Date:   Thu,  6 Feb 2020 20:04:59 +0100
Message-Id: <20200206190502.389139-2-preichl@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200206190502.389139-1-preichl@redhat.com>
References: <20200206190502.389139-1-preichl@redhat.com>
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
 fs/xfs/xfs_inode.c | 48 +++++++++++++++++++++++++++++++++-------------
 fs/xfs/xfs_inode.h |  2 +-
 2 files changed, 36 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index c5077e6326c7..b5f71b9ae77b 100644
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
 	if (lock_flags & (XFS_ILOCK_EXCL|XFS_ILOCK_SHARED)) {
-		if (!(lock_flags & XFS_ILOCK_SHARED))
-			return !!ip->i_lock.mr_writer;
-		return rwsem_is_locked(&ip->i_lock.mr_lock);
+		return __xfs_rwsem_islocked(&ip->i_lock.mr_lock,
+				(lock_flags & XFS_ILOCK_SHARED),
+				(lock_flags & XFS_ILOCK_EXCL));
 	}
 
 	if (lock_flags & (XFS_MMAPLOCK_EXCL|XFS_MMAPLOCK_SHARED)) {
-		if (!(lock_flags & XFS_MMAPLOCK_SHARED))
-			return !!ip->i_mmaplock.mr_writer;
-		return rwsem_is_locked(&ip->i_mmaplock.mr_lock);
+		return __xfs_rwsem_islocked(&ip->i_mmaplock.mr_lock,
+				(lock_flags & XFS_MMAPLOCK_SHARED),
+				(lock_flags & XFS_MMAPLOCK_EXCL));
 	}
 
 	if (lock_flags & (XFS_IOLOCK_EXCL|XFS_IOLOCK_SHARED)) {
-		if (!(lock_flags & XFS_IOLOCK_SHARED))
-			return !debug_locks ||
-				lockdep_is_held_type(&VFS_I(ip)->i_rwsem, 0);
-		return rwsem_is_locked(&VFS_I(ip)->i_rwsem);
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

