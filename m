Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1853112B168
	for <linux-xfs@vger.kernel.org>; Wed, 21 Feb 2024 22:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708555668; cv=none; b=lzLHm3zw6PPx0VSqCghlAfj+zyanO0ymfS6sLIfykLPiHCMKZwGHH6pwQDUVEYPze0hPDeAl9SWfL4aRHRhW+TyyxXVqT1gQbgtpap/uYJF9wKlOLDf2hJXateVfgJ40KYvZjZbohn+UD7OW6yti3XyoLpHRIZdiOcJGC1jnPvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708555668; c=relaxed/simple;
	bh=fOAu/unXR1jQhq9SZLLZvpAwofNCivLy6wZBOHdld/4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DorQnCtl8YfsWCb5UDI9g4FZrG3ETprPi10UXNfl9SuGNlXkuufxrYIfTEllmRRSbA7c4kdejb0vFOfvM+x3FBoBib/gKO+GLm1FEolsYB1vJ4hoV5zicCgFcqd50YSGigw/BLZcDVbReBh3gm+bQwLbdP0Z0dgGFCoCyVeSWLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=1H9u1WgT; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="1H9u1WgT"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-6e3ffafa708so4399996b3a.1
        for <linux-xfs@vger.kernel.org>; Wed, 21 Feb 2024 14:47:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1708555647; x=1709160447; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hxNiWcliLyUh4yua1zpU96lOU34wt/fb6YUdk+3r520=;
        b=1H9u1WgToeawhUhseAHzycL/APZszc+g2xiNtQOQ/qj0TbKAWbePhCh0ICwWS3aQG1
         wkfNE8JfLoOueZv4ObqcRq61/DUrG5/dl504+cQqBbgrDJf6o5fGLFL3oJpJS9sLwBtQ
         wlRDH7L1h69D1DACgcEIM1wX4bdIvywYkFv0WbXhJHGHNEMkjENRwTY2DVdpxsFF5wor
         W3uu8AxuL3FLfz4grbZEb4S+7ab/ks+YuSBTEikdKxd4xY5axsAPeW98karm4qqmvh7H
         ODGmSmAgHE22MaISFQlpta4SDD1l6Y4g7VbgExS47nZUm6IXkQGJ4L7BhzZ8vHPLyyWU
         iG7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708555647; x=1709160447;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hxNiWcliLyUh4yua1zpU96lOU34wt/fb6YUdk+3r520=;
        b=sxIVg84QsBoyuZidNvgVLVX0KdXuzQmxLVKk+dQ0XR5YnTt9ZkaoCu14O0aXJ7u38D
         2t3jNif5ErzzVK+cGaTKI/1QEXZ4sQG7TtYG5yTXq969Wd7wUpQqVFtdOw+0at2Fpbv2
         WrEFx2vmFuBK2fC/XrKskv7Tnn32fB0uQHuJcPAqZNMuYiFJBk5p4cHUDvBX/DgmHy9y
         eftR2zMP3NiRAtpaY8MWRjalvWMQc/Co71bNUqNN8e4KyhgffIJMC/Fin7aD7sAC7NNd
         9Hch03FRpOEb7r4KxA2+UziRqpbRf4wsWsuUE73bCChtgWmqp6CKnv0P39jbChthKgbY
         I9cQ==
X-Gm-Message-State: AOJu0YycsmJ+wCEN7fbwuFVRlURdKPVZyt49YWieY1gtHxr0ugvuqufT
	dICl0F+LH4MMOn8pd6WYEehoQ7m4gn4kZUKgdRt55c3bz4+IUcweSzvKEs4/OnZCpwS8fnUFeGy
	r
X-Google-Smtp-Source: AGHT+IE62rcC5MaWbo1r9WS2tyhYX5PsTwnJUyeAr3R/vsK23mu34ZPPqIqWYmihfvH3m302/5siKw==
X-Received: by 2002:a05:6a20:c78e:b0:1a0:a43b:cbd8 with SMTP id hk14-20020a056a20c78e00b001a0a43bcbd8mr7768093pzb.59.1708555647435;
        Wed, 21 Feb 2024 14:47:27 -0800 (PST)
Received: from dread.disaster.area (pa49-181-247-196.pa.nsw.optusnet.com.au. [49.181.247.196])
        by smtp.gmail.com with ESMTPSA id p4-20020aa79e84000000b006e13e202914sm9397893pfq.56.2024.02.21.14.47.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Feb 2024 14:47:27 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1rcvN6-009hrv-1B;
	Thu, 22 Feb 2024 09:47:24 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1rcvN5-00000000TNO-3ecX;
	Thu, 22 Feb 2024 09:47:23 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Cc: chandan.babu@oracle.com
Subject: [PATCH] xfs: don't use current->journal_info
Date: Thu, 22 Feb 2024 09:47:23 +1100
Message-ID: <20240221224723.112913-1-david@fromorbit.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

syzbot reported an ext4 panic during a page fault where found a
journal handle when it didn't expect to find one. The structure
it tripped over had a value of 'TRAN' in the first entry in the
structure, and that indicates it tripped over a struct xfs_trans
instead of a jbd2 handle.

The reason for this is that the page fault was taken during a
copy-out to a user buffer from an xfs bulkstat operation. XFS uses
an "empty" transaction context for bulkstat to do automated metadata
buffer cleanup, and so the transaction context is valid across the
copyout of the bulkstat info into the user buffer.

We are using empty transaction contexts like this in XFS in more
places to reduce the risk of failing to release objects we reference
during the operation, especially during error handling. Hence we
really need to ensure that we can take page faults from these
contexts without leaving landmines for the code processing the page
fault to trip over.

We really only use current->journal_info for a single warning check
in xfs_vm_writepages() to ensure we aren't doing writeback from a
transaction context. Writeback might need to do allocation, so it
can need to run transactions itself. Hence it's a debug check to
warn us that we've done something silly, and largely it is not all
that useful.

So let's just remove all the use of current->journal_info in XFS and
get rid of all the potential issues from nested contexts where
current->journal_info might get misused by another filesytsem
context.

Reported-by: syzbot+cdee56dbcdf0096ef605@syzkaller.appspotmail.com
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/scrub/common.c | 4 +---
 fs/xfs/xfs_aops.c     | 7 -------
 fs/xfs/xfs_icache.c   | 8 +++++---
 fs/xfs/xfs_trans.h    | 9 +--------
 4 files changed, 7 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 81f2b96bb5a7..d853348a48c8 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -1000,9 +1000,7 @@ xchk_irele(
 	struct xfs_scrub	*sc,
 	struct xfs_inode	*ip)
 {
-	if (current->journal_info != NULL) {
-		ASSERT(current->journal_info == sc->tp);
-
+	if (sc->tp) {
 		/*
 		 * If we are in a transaction, we /cannot/ drop the inode
 		 * ourselves, because the VFS will trigger writeback, which
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 813f85156b0c..bc3b649d29c4 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -502,13 +502,6 @@ xfs_vm_writepages(
 {
 	struct xfs_writepage_ctx wpc = { };
 
-	/*
-	 * Writing back data in a transaction context can result in recursive
-	 * transactions. This is bad, so issue a warning and get out of here.
-	 */
-	if (WARN_ON_ONCE(current->journal_info))
-		return 0;
-
 	xfs_iflags_clear(XFS_I(mapping->host), XFS_ITRUNCATED);
 	return iomap_writepages(mapping, wbc, &wpc.ctx, &xfs_writeback_ops);
 }
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 06046827b5fe..9b966af7d55c 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -2030,8 +2030,10 @@ xfs_inodegc_want_queue_work(
  *  - Memory shrinkers queued the inactivation worker and it hasn't finished.
  *  - The queue depth exceeds the maximum allowable percpu backlog.
  *
- * Note: If the current thread is running a transaction, we don't ever want to
- * wait for other transactions because that could introduce a deadlock.
+ * Note: If we are in a NOFS context here (e.g. current thread is running a
+ * transaction) the we don't want to block here as inodegc progress may require
+ * filesystem resources we hold to make progress and that could result in a
+ * deadlock. Hence we skip out of here if we are in a scoped NOFS context.
  */
 static inline bool
 xfs_inodegc_want_flush_work(
@@ -2039,7 +2041,7 @@ xfs_inodegc_want_flush_work(
 	unsigned int		items,
 	unsigned int		shrinker_hits)
 {
-	if (current->journal_info)
+	if (current->flags & PF_MEMALLOC_NOFS)
 		return false;
 
 	if (shrinker_hits > 0)
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index c6d0795085a3..2bd673715ace 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -269,19 +269,14 @@ static inline void
 xfs_trans_set_context(
 	struct xfs_trans	*tp)
 {
-	ASSERT(current->journal_info == NULL);
 	tp->t_pflags = memalloc_nofs_save();
-	current->journal_info = tp;
 }
 
 static inline void
 xfs_trans_clear_context(
 	struct xfs_trans	*tp)
 {
-	if (current->journal_info == tp) {
-		memalloc_nofs_restore(tp->t_pflags);
-		current->journal_info = NULL;
-	}
+	memalloc_nofs_restore(tp->t_pflags);
 }
 
 static inline void
@@ -289,10 +284,8 @@ xfs_trans_switch_context(
 	struct xfs_trans	*old_tp,
 	struct xfs_trans	*new_tp)
 {
-	ASSERT(current->journal_info == old_tp);
 	new_tp->t_pflags = old_tp->t_pflags;
 	old_tp->t_pflags = 0;
-	current->journal_info = new_tp;
 }
 
 #endif	/* __XFS_TRANS_H__ */
-- 
2.43.0

