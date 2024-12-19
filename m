Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 384551990B7;
	Thu, 19 Dec 2024 17:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734628598; cv=none; b=QMkUtGMkHJTb0T/9X6xsnYhb/L9KHDzIuL9a9v6M67nYjCOCEwUTVPStHNx9LLMPPOwM8aZHLezSt3lg7M6gaiE3DvpfLr+9+F/Pt+SRepvhD5cA0VlJhzqIdCpJBXItcXIhaZkhthHYbxJodcqDfTIw2QPyitWBzduzTin/LSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734628598; c=relaxed/simple;
	bh=8MrjsRLmd3BBM7xRhk6f57fkHgm6OILuv1akfPK9ksg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=H/6s14HQ5pcAxuMYVKVDPlemj0Kb231uHwtK1UMk5lJr8Ljj8wjVmTvatXN1bGQtI5YYB+tQbOewlfwxoX4HlUfsrFYL2NAYK+jD+byAEt7pUAwhsGIztd5IycmAIUeEMZMK8Ne666fq351JuuojXJ7BFGh7he+K+8OF0+S2uG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lR18sSrR; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lR18sSrR"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-728e3826211so982322b3a.0;
        Thu, 19 Dec 2024 09:16:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734628595; x=1735233395; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=m7d447lDX5XOKN8yC1iqavdO2PEHa/Suygc5gGBo1lI=;
        b=lR18sSrRQIBEqg8sGEHgEhYgNxyMBd6kp+GBkOYXzjrNQ+Mm3m965nVEBrZcheo5dB
         KURdcnsG6JHzmTPWgZBAUnyt/DZ9NdtBZ8cmjeDM5JaDNjyA7h40S9LqdkdKGbaavrdJ
         12E3xJIHAu2jUBlesz/uA7nM1Jj+VUYhLZORkoPnbyZey8oS7aOtzLJnaKF102J4Oc0S
         7S333wAaobHwkbogjFfFpSIHo27w9Ihuq2qWw8Lpk7zaKGe1M2fpQx/J4a7QiROvJh2j
         s4NZizr1eaO1tAW2yhY8mxPtnKjaH2GDWX9xc2rXYswS7tnmCey0L8SBDwyGDIzoMojO
         TDvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734628595; x=1735233395;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m7d447lDX5XOKN8yC1iqavdO2PEHa/Suygc5gGBo1lI=;
        b=BTLgIfYdN9mhhFT71Hk7daP2u52yn+8i3t7Izudh8p0u9kFhTMT48m9O6Z0tfBjvDK
         bkBi5Ply7B9lmSaECnJxjvjZ9BDxyps15e991U4AfVpGOjXHG+YwfOU8AFtL6U+kNBcb
         q/d6OZT0PGBK/bf3k+6o7XpoJMnT/7bZcFY640ubFSEK1o5Q3k5eUxPynjvgGlictdFn
         CSWE04NI7G+sBkneWU3DaF+utz+48IxVh3KvnlMiA9c2hXRlpmmtVx+ujuBySegfkMSE
         8CSz2JaTvCgXQuGggnlMZWTzf/CKXheSLYyCaNKsCkFDKS8iLL0GAuZYNYgqQCdJy4rb
         EDuQ==
X-Forwarded-Encrypted: i=1; AJvYcCWJAIQuhwMFYlkkHChDm1R3zQEp32EEXjs5jx+L9vsCGyQOqf+tK6Naa02fyE+IJusJCcpCB/zzdZrZiw0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzQ+PdKQ2BVt8ziIPXs62ZQBZfNtmFcquWvykyN6/MTA2vR4jQ3
	Og9axKZT1myY7WK1Nvq3b8tMuj0S/yFMN9GvYHVzIZtArKvgTx3V
X-Gm-Gg: ASbGncuohp1ZxSF4wVPrf55yO3lywwl+D54Oj7iGiKAw8tzIEMLv5Tn8djREnvoKT0h
	3mtlmOgotW1iZmhZii73IVHBE5RMFTwKFa5S5nu7llZYKz4V/W3cbdHNAoLrYKHtpzEFHY2oNk2
	pp1Gjs9xePE04cwFiqxlh6qxDJHVwZ1UNnMgF5RLRHXHnOYD2h5+PTPCbfXqT6hhKx1TGPeTjjr
	EXB8RBoALbEjvcYPt1Fab/5QWsTF2jFSObgtNrOm/5pP9kfSpn2oq/qVAb0/Qeras8PSdt4
X-Google-Smtp-Source: AGHT+IH8T89sIuFImkWz2/suBJBux7nf66Zb3S2Mp8SwbT+yUi4yvzn5N283KFWACwSOSQsxO96wHA==
X-Received: by 2002:a05:6a00:218c:b0:725:b702:af with SMTP id d2e1a72fcca58-72a8d2ec099mr11091620b3a.25.1734628595287;
        Thu, 19 Dec 2024 09:16:35 -0800 (PST)
Received: from localhost.localdomain ([119.28.17.178])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72aad8309f3sm1553339b3a.55.2024.12.19.09.16.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Dec 2024 09:16:34 -0800 (PST)
From: Jinliang Zheng <alexjlzheng@gmail.com>
X-Google-Original-From: Jinliang Zheng <alexjlzheng@tencent.com>
To: chandan.babu@oracle.com,
	djwong@kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	flyingpeng@tencent.com,
	Jinliang Zheng <alexjlzheng@tencent.com>
Subject: [PATCH] xfs: using mutex instead of semaphore for xfs_buf_lock()
Date: Fri, 20 Dec 2024 01:16:29 +0800
Message-ID: <20241219171629.73327-1-alexjlzheng@tencent.com>
X-Mailer: git-send-email 2.41.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

xfs_buf uses a semaphore for mutual exclusion, and its count value
is initialized to 1, which is equivalent to a mutex.

However, mutex->owner can provide more information when analyzing
vmcore, making it easier for us to identify which task currently
holds the lock.

Signed-off-by: Jinliang Zheng <alexjlzheng@tencent.com>
---
 fs/xfs/xfs_buf.c   |  9 +++++----
 fs/xfs/xfs_buf.h   |  4 ++--
 fs/xfs/xfs_trace.h | 25 +++++--------------------
 3 files changed, 12 insertions(+), 26 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index aa4dbda7b536..7c59d7905ea1 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -243,7 +243,8 @@ _xfs_buf_alloc(
 	INIT_LIST_HEAD(&bp->b_lru);
 	INIT_LIST_HEAD(&bp->b_list);
 	INIT_LIST_HEAD(&bp->b_li_list);
-	sema_init(&bp->b_sema, 0); /* held, no waiters */
+	mutex_init(&bp->b_mutex);
+	mutex_lock(&bp->b_mutex); /* held, no waiters */
 	spin_lock_init(&bp->b_lock);
 	bp->b_target = target;
 	bp->b_mount = target->bt_mount;
@@ -1168,7 +1169,7 @@ xfs_buf_trylock(
 {
 	int			locked;
 
-	locked = down_trylock(&bp->b_sema) == 0;
+	locked = mutex_trylock(&bp->b_mutex);
 	if (locked)
 		trace_xfs_buf_trylock(bp, _RET_IP_);
 	else
@@ -1193,7 +1194,7 @@ xfs_buf_lock(
 
 	if (atomic_read(&bp->b_pin_count) && (bp->b_flags & XBF_STALE))
 		xfs_log_force(bp->b_mount, 0);
-	down(&bp->b_sema);
+	mutex_lock(&bp->b_mutex);
 
 	trace_xfs_buf_lock_done(bp, _RET_IP_);
 }
@@ -1204,7 +1205,7 @@ xfs_buf_unlock(
 {
 	ASSERT(xfs_buf_islocked(bp));
 
-	up(&bp->b_sema);
+	mutex_unlock(&bp->b_mutex);
 	trace_xfs_buf_unlock(bp, _RET_IP_);
 }
 
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index b1580644501f..2c48e388d451 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -171,7 +171,7 @@ struct xfs_buf {
 	atomic_t		b_hold;		/* reference count */
 	atomic_t		b_lru_ref;	/* lru reclaim ref count */
 	xfs_buf_flags_t		b_flags;	/* status flags */
-	struct semaphore	b_sema;		/* semaphore for lockables */
+	struct mutex		b_mutex;	/* mutex for lockables */
 
 	/*
 	 * concurrent access to b_lru and b_lru_flags are protected by
@@ -304,7 +304,7 @@ extern int xfs_buf_trylock(struct xfs_buf *);
 extern void xfs_buf_lock(struct xfs_buf *);
 extern void xfs_buf_unlock(struct xfs_buf *);
 #define xfs_buf_islocked(bp) \
-	((bp)->b_sema.count <= 0)
+	mutex_is_locked(&(bp)->b_mutex)
 
 static inline void xfs_buf_relse(struct xfs_buf *bp)
 {
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 180ce697305a..ba6c003b82af 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -443,7 +443,6 @@ DECLARE_EVENT_CLASS(xfs_buf_class,
 		__field(int, nblks)
 		__field(int, hold)
 		__field(int, pincount)
-		__field(unsigned, lockval)
 		__field(unsigned, flags)
 		__field(unsigned long, caller_ip)
 		__field(const void *, buf_ops)
@@ -454,19 +453,17 @@ DECLARE_EVENT_CLASS(xfs_buf_class,
 		__entry->nblks = bp->b_length;
 		__entry->hold = atomic_read(&bp->b_hold);
 		__entry->pincount = atomic_read(&bp->b_pin_count);
-		__entry->lockval = bp->b_sema.count;
 		__entry->flags = bp->b_flags;
 		__entry->caller_ip = caller_ip;
 		__entry->buf_ops = bp->b_ops;
 	),
 	TP_printk("dev %d:%d daddr 0x%llx bbcount 0x%x hold %d pincount %d "
-		  "lock %d flags %s bufops %pS caller %pS",
+		  "flags %s bufops %pS caller %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  (unsigned long long)__entry->bno,
 		  __entry->nblks,
 		  __entry->hold,
 		  __entry->pincount,
-		  __entry->lockval,
 		  __print_flags(__entry->flags, "|", XFS_BUF_FLAGS),
 		  __entry->buf_ops,
 		  (void *)__entry->caller_ip)
@@ -514,7 +511,6 @@ DECLARE_EVENT_CLASS(xfs_buf_flags_class,
 		__field(unsigned int, length)
 		__field(int, hold)
 		__field(int, pincount)
-		__field(unsigned, lockval)
 		__field(unsigned, flags)
 		__field(unsigned long, caller_ip)
 	),
@@ -525,17 +521,15 @@ DECLARE_EVENT_CLASS(xfs_buf_flags_class,
 		__entry->flags = flags;
 		__entry->hold = atomic_read(&bp->b_hold);
 		__entry->pincount = atomic_read(&bp->b_pin_count);
-		__entry->lockval = bp->b_sema.count;
 		__entry->caller_ip = caller_ip;
 	),
 	TP_printk("dev %d:%d daddr 0x%llx bbcount 0x%x hold %d pincount %d "
-		  "lock %d flags %s caller %pS",
+		  "flags %s caller %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  (unsigned long long)__entry->bno,
 		  __entry->length,
 		  __entry->hold,
 		  __entry->pincount,
-		  __entry->lockval,
 		  __print_flags(__entry->flags, "|", XFS_BUF_FLAGS),
 		  (void *)__entry->caller_ip)
 )
@@ -558,7 +552,6 @@ TRACE_EVENT(xfs_buf_ioerror,
 		__field(unsigned, flags)
 		__field(int, hold)
 		__field(int, pincount)
-		__field(unsigned, lockval)
 		__field(int, error)
 		__field(xfs_failaddr_t, caller_ip)
 	),
@@ -568,19 +561,17 @@ TRACE_EVENT(xfs_buf_ioerror,
 		__entry->length = bp->b_length;
 		__entry->hold = atomic_read(&bp->b_hold);
 		__entry->pincount = atomic_read(&bp->b_pin_count);
-		__entry->lockval = bp->b_sema.count;
 		__entry->error = error;
 		__entry->flags = bp->b_flags;
 		__entry->caller_ip = caller_ip;
 	),
 	TP_printk("dev %d:%d daddr 0x%llx bbcount 0x%x hold %d pincount %d "
-		  "lock %d error %d flags %s caller %pS",
+		  "error %d flags %s caller %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  (unsigned long long)__entry->bno,
 		  __entry->length,
 		  __entry->hold,
 		  __entry->pincount,
-		  __entry->lockval,
 		  __entry->error,
 		  __print_flags(__entry->flags, "|", XFS_BUF_FLAGS),
 		  (void *)__entry->caller_ip)
@@ -595,7 +586,6 @@ DECLARE_EVENT_CLASS(xfs_buf_item_class,
 		__field(unsigned int, buf_len)
 		__field(int, buf_hold)
 		__field(int, buf_pincount)
-		__field(int, buf_lockval)
 		__field(unsigned, buf_flags)
 		__field(unsigned, bli_recur)
 		__field(int, bli_refcount)
@@ -612,18 +602,16 @@ DECLARE_EVENT_CLASS(xfs_buf_item_class,
 		__entry->buf_flags = bip->bli_buf->b_flags;
 		__entry->buf_hold = atomic_read(&bip->bli_buf->b_hold);
 		__entry->buf_pincount = atomic_read(&bip->bli_buf->b_pin_count);
-		__entry->buf_lockval = bip->bli_buf->b_sema.count;
 		__entry->li_flags = bip->bli_item.li_flags;
 	),
 	TP_printk("dev %d:%d daddr 0x%llx bbcount 0x%x hold %d pincount %d "
-		  "lock %d flags %s recur %d refcount %d bliflags %s "
+		  "flags %s recur %d refcount %d bliflags %s "
 		  "liflags %s",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  (unsigned long long)__entry->buf_bno,
 		  __entry->buf_len,
 		  __entry->buf_hold,
 		  __entry->buf_pincount,
-		  __entry->buf_lockval,
 		  __print_flags(__entry->buf_flags, "|", XFS_BUF_FLAGS),
 		  __entry->bli_recur,
 		  __entry->bli_refcount,
@@ -4802,7 +4790,6 @@ DECLARE_EVENT_CLASS(xfbtree_buf_class,
 		__field(int, nblks)
 		__field(int, hold)
 		__field(int, pincount)
-		__field(unsigned int, lockval)
 		__field(unsigned int, flags)
 	),
 	TP_fast_assign(
@@ -4811,16 +4798,14 @@ DECLARE_EVENT_CLASS(xfbtree_buf_class,
 		__entry->nblks = bp->b_length;
 		__entry->hold = atomic_read(&bp->b_hold);
 		__entry->pincount = atomic_read(&bp->b_pin_count);
-		__entry->lockval = bp->b_sema.count;
 		__entry->flags = bp->b_flags;
 	),
-	TP_printk("xfino 0x%lx daddr 0x%llx bbcount 0x%x hold %d pincount %d lock %d flags %s",
+	TP_printk("xfino 0x%lx daddr 0x%llx bbcount 0x%x hold %d pincount %d flags %s",
 		  __entry->xfino,
 		  (unsigned long long)__entry->bno,
 		  __entry->nblks,
 		  __entry->hold,
 		  __entry->pincount,
-		  __entry->lockval,
 		  __print_flags(__entry->flags, "|", XFS_BUF_FLAGS))
 )
 
-- 
2.41.1

