Return-Path: <SRS0=C9JY=4P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 179A3C35E1D
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Feb 2020 20:36:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E379E246A0
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Feb 2020 20:36:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K9wunsri"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbgB0Ugn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Feb 2020 15:36:43 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:39066 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729390AbgB0Ugn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Feb 2020 15:36:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582835802;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y6MT4UtOBzFR1h4DyNC8cqcoSl937BEDZoWb49mSsj0=;
        b=K9wunsrizH+ycGUg/+nPsrUk5Mjv5ALLJhgTSPlBpA8uD/h/J5Dzachh3UQCyvUFCuPBH2
        hF6N3nxDaosuLISEqoRDQj53ATxgSVwTOmK/qGHX9hRSWdqw41W5yXZnigHcTSrlGCN4/0
        UOTSBHdKbDSBy7Wi3glf0dvdJ1f4XVI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-220-6FZUBi70NDO0_ihROFMVng-1; Thu, 27 Feb 2020 15:36:40 -0500
X-MC-Unique: 6FZUBi70NDO0_ihROFMVng-1
Received: by mail-wr1-f71.google.com with SMTP id y28so315131wrd.23
        for <linux-xfs@vger.kernel.org>; Thu, 27 Feb 2020 12:36:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y6MT4UtOBzFR1h4DyNC8cqcoSl937BEDZoWb49mSsj0=;
        b=TqWk4vGZwFoN8YDJXg1co+bP/9B0IoQPVPs6IhIlam3OkVJReOhl6uO3IBgl05Uknf
         I3PdvhxUgQhBn5cLxt6AG1rU/jHoQVSaWouM5Gx0VxU9wLNNUNzhuJEo5tbpeF3iD/0o
         VJ0gCYFrHb0GYywcq/9Uv2xva/UHfP5OW5iuntbS8Ayu3sUgrknwgrDxCnw5ynmCvl8e
         hD8dbGWhhpRye+VMDAsFtKxVx1S69Rq/Cev9E8L2lYatcLpXSQzAv8mFARy0LpDcRwC2
         zhI4QEhbb61kEPUKKaXNPjI5PawJnXCz7/RMrmJCk6M5UYEGTxMOrbifD590X8OxcSx7
         p2CA==
X-Gm-Message-State: APjAAAWkCD6ZimTsDf+zt/ydL0BcM4rkUGxZUQFK0pqj0I0i/esAFUeX
        n3R+P2zy3s500cCxfNCGJEPshrlP8p5AaWp8OYMJACsFSHZKv7HiyrUlIBqXXvxhedIR3QP2HcJ
        o18sX29eoq3zX5aAsXivI
X-Received: by 2002:a7b:c4c3:: with SMTP id g3mr513811wmk.131.1582835798827;
        Thu, 27 Feb 2020 12:36:38 -0800 (PST)
X-Google-Smtp-Source: APXvYqwqxtw8e/NvxgUmum3XW3nheraGvVkRcfQ3kTEeX3xyF3/SGw0OyOPkqzPqqG7M4F/y7uTq1w==
X-Received: by 2002:a7b:c4c3:: with SMTP id g3mr513798wmk.131.1582835798562;
        Thu, 27 Feb 2020 12:36:38 -0800 (PST)
Received: from localhost.localdomain (243.206.broadband12.iol.cz. [90.179.206.243])
        by smtp.gmail.com with ESMTPSA id e11sm9217157wrm.80.2020.02.27.12.36.37
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2020 12:36:38 -0800 (PST)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v6 1/4] xfs: Refactor xfs_isilocked()
Date:   Thu, 27 Feb 2020 21:36:33 +0100
Message-Id: <20200227203636.317790-2-preichl@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200227203636.317790-1-preichl@redhat.com>
References: <20200227203636.317790-1-preichl@redhat.com>
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
Changes from V5:
	Drop shared flag from __xfs_rwsem_islocked()


 fs/xfs/xfs_inode.c | 42 ++++++++++++++++++++++++++----------------
 fs/xfs/xfs_inode.h |  2 +-
 2 files changed, 27 insertions(+), 17 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index c5077e6326c7..4faf7827717b 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -345,32 +345,42 @@ xfs_ilock_demote(
 }
 
 #if defined(DEBUG) || defined(XFS_WARN)
-int
+static inline bool
+__xfs_rwsem_islocked(
+	struct rw_semaphore	*rwsem,
+	bool			excl)
+{
+	if (!rwsem_is_locked(rwsem))
+		return false;
+
+	if (debug_locks && excl)
+		return lockdep_is_held_type(rwsem, 1);
+
+	return true;
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
+				(lock_flags & XFS_ILOCK_EXCL));
 	}
 
-	if (lock_flags & (XFS_MMAPLOCK_EXCL|XFS_MMAPLOCK_SHARED)) {
-		if (!(lock_flags & XFS_MMAPLOCK_SHARED))
-			return !!ip->i_mmaplock.mr_writer;
-		return rwsem_is_locked(&ip->i_mmaplock.mr_lock);
+	if (lock_flags & (XFS_MMAPLOCK_EXCL | XFS_MMAPLOCK_SHARED)) {
+		return __xfs_rwsem_islocked(&ip->i_mmaplock.mr_lock,
+				(lock_flags & XFS_MMAPLOCK_EXCL));
 	}
 
-	if (lock_flags & (XFS_IOLOCK_EXCL|XFS_IOLOCK_SHARED)) {
-		if (!(lock_flags & XFS_IOLOCK_SHARED))
-			return !debug_locks ||
-				lockdep_is_held_type(&VFS_I(ip)->i_rwsem, 0);
-		return rwsem_is_locked(&VFS_I(ip)->i_rwsem);
+	if (lock_flags & (XFS_IOLOCK_EXCL | XFS_IOLOCK_SHARED)) {
+		return __xfs_rwsem_islocked(&VFS_I(ip)->i_rwsem,
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

