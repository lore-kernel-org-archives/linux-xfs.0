Return-Path: <SRS0=Jdfz=DX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CDA3C433E7
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Oct 2020 02:10:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0065C2087D
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Oct 2020 02:10:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IxQQOEHR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393355AbgJPCKO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:10:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41364 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2393337AbgJPCKO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 22:10:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602814212;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4GKH7rh2k/rQh/hmpoFMT51hnFYcNyy2ZeD2szUoX4I=;
        b=IxQQOEHRCpttf1DtjArUQgkyEXG6zDlGDcJB6piPtGn8dBRq9ZaujY8+uTgKdoySI8eqcQ
        sS2ajf6/xrvlER1/kyxNcZpz9TbYDE3uDAKoNEtbS+bNn09oDWbYjmtlS8Tuq3jIXiQExM
        j0h2hmVgzZzyZbqSE+QRMJgSLm7NNj4=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-499-fhnF4LnHOr2o7X-CdClfOQ-1; Thu, 15 Oct 2020 22:10:10 -0400
X-MC-Unique: fhnF4LnHOr2o7X-CdClfOQ-1
Received: by mail-wr1-f71.google.com with SMTP id q15so612809wrw.8
        for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2020 19:10:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4GKH7rh2k/rQh/hmpoFMT51hnFYcNyy2ZeD2szUoX4I=;
        b=sQEGFrkQZnu73MQgnjBZHtiRDh/7OTPmVyq1rB7eY+Ph/A5NaEdynUQIYWoA6NalFs
         N3H5udwZzkLMZjMB1Q3iFhptMPR6nAtDI2b/VxxKyORCylzpiNIsoYfPbWLFI4lpbt6n
         uiKDNy5j0WsEjL+SuCKeKoFtKUU/NfPpCb3Wt+6PJB3W4dHEFgJRsCXnnIPY6Iy6jEp5
         SNh2CRIf/xk45vsF5TfYHD7PzTLfv3lf5lE8Ls5XWkX7VC3k0nGHD8NHj0cUy5khA49D
         cIX41Q7FjfZ/Wk7gksIhB6AWny21oXBOFJ2oKJaTJzGQgBlw8UfEQbpxxTBFdSHsrEJK
         jDog==
X-Gm-Message-State: AOAM532m6S4gX70Mq8VcXLCZBnGm5GEHTGXFKptuYbwHhVYD4zu+zXz4
        adD3R376jzunHyaUYqRYdN6NnFLlppKkF0Hj4wE+4/08UoeWZ44JH2MQK76Okbh+NmnvytTOR70
        1OLiHWBf80eZkVN5pb3uC
X-Received: by 2002:a7b:c255:: with SMTP id b21mr1381735wmj.25.1602814208677;
        Thu, 15 Oct 2020 19:10:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxhncWo2gLO81Y6v+U+ajCvE2V+WEw2RJiFj5r48Xtx/IJqXG7kYH7K7AZR5AxdDFZEpbSgaw==
X-Received: by 2002:a7b:c255:: with SMTP id b21mr1381726wmj.25.1602814208429;
        Thu, 15 Oct 2020 19:10:08 -0700 (PDT)
Received: from localhost.localdomain.com ([84.19.91.81])
        by smtp.gmail.com with ESMTPSA id v3sm1420685wre.17.2020.10.15.19.10.07
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2020 19:10:07 -0700 (PDT)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v12 1/4] xfs: Refactor xfs_isilocked()
Date:   Fri, 16 Oct 2020 04:10:02 +0200
Message-Id: <20201016021005.548850-2-preichl@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201016021005.548850-1-preichl@redhat.com>
References: <20201016021005.548850-1-preichl@redhat.com>
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
index c06129cffba9..1fdf8c7eb990 100644
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
+	if (lock_flags & (1 << XFS_SHARED_LOCK_SHIFT)) {
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
index e9a8bb184d1f..9cecd6c9c90c 100644
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
+#define XFS_IOLOCK_EXCL		(1 << XFS_IOLOCK_FLAG_SHIFT)
+#define XFS_IOLOCK_SHARED	(XFS_IOLOCK_EXCL << XFS_SHARED_LOCK_SHIFT)
+#define XFS_ILOCK_EXCL		(1 << XFS_ILOCK_FLAG_SHIFT)
+#define XFS_ILOCK_SHARED	(XFS_ILOCK_EXCL << XFS_SHARED_LOCK_SHIFT)
+#define XFS_MMAPLOCK_EXCL	(1 << XFS_MMAPLOCK_FLAG_SHIFT)
+#define XFS_MMAPLOCK_SHARED	(XFS_MMAPLOCK_EXCL << XFS_SHARED_LOCK_SHIFT)
 
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

