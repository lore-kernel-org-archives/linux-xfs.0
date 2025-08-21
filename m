Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14274350D54
	for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 20:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755807622; cv=none; b=NihblelNaj73zM25bvb5aw3HnqWYUR1Oxq4y9lyNarPN90t9sbFVRbVjAohHpx45uxRfO4+wB41umvR/Mv3ev7yN7VJsUOvTMRK+gi6Y6wXeqpqQ1FoT3iKTS8rASXHq+zvddeEt6BhmeZcN0JZQPYaTE/ejbFqkOThpGlnelTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755807622; c=relaxed/simple;
	bh=xDF1BZHRgll8r9ePxqTRE8AusjqiPqbehJhffi4bwTQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CzwHHMBC6ybJDs/5y+TVttHM0ZDEXUyYTD2WKerp2i6gt0zjcTUIbwa7m6T+oYGF2ka1o1SJOF/zWUgZ1Ny27EqHa5+0yKMG38umFwn0ie+pSRFE86xw+bjCLqm0XZm6DROy02DSEWtLWYsZtucV0JLON6UxK4PQd1OrDSjlfNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=UFw/f9q7; arc=none smtp.client-ip=209.85.128.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="UFw/f9q7"
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-71d6014810fso13114717b3.0
        for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 13:20:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1755807619; x=1756412419; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l9fMeApSwNvWbdSWinLhDcYIQNpYIQGmK7DG9fmCNOo=;
        b=UFw/f9q7rNOO7csqpfrpBUX8Yil6NoEd+jVMWPAmOlWWZtO4XgrbNArARt6aWsBw0J
         VATF149SG1I9kkYLkXacDZY57Eyz3qqW72N5QPPivl6AxRg9oMM3y6jESni/hOT1GV/T
         1LWEA+w4IXJtpHjz4KHXtcI07haMRMYONdAX3WcVA7qVJMfL+XYjNscQ72hAJZM6aX1d
         7x6OdRzm0xY2DJRgBSt70xWwQORWs/djAbQakZgjy2xMCuyVeu7i4wP/X1dTftmWaOLq
         8uaA3/MHDgfaNcIPmBMoE0wgTTXadmUEexvLvSKkIohRXL4l5aKp9mge/zZjsntggD32
         ZaEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755807619; x=1756412419;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l9fMeApSwNvWbdSWinLhDcYIQNpYIQGmK7DG9fmCNOo=;
        b=OfZSR+iVNFGniAjU5Ty9rT1wEnn9YW25/0AQ49mA3+I0e3vll5MGSAUb3tpIlD95vv
         H913fLt9mZH0E7rgnCtSjl2RZBKkfokNMjI7FpfKI48fX7gydlKXBBSQ59jTosHnZs2d
         uSTegkA5/LfvvthiOBfEENXToogO5/HZdVOEcqK5pA6eD8KzwGDff1JDYnBE+kg/4P90
         7ofH79XvVghPxf3l8zn8HiVn1pQxebf8F1hxl3LTOL3fZcmtcaCxjdGKqn7Wxx3pOapJ
         58m+YCdkI4L1ioJqoRZdhTuJnF8r28bTEDjEyEVCA5/FL2HJ4h40Zc1/+YitVEpQUlLy
         dlgg==
X-Forwarded-Encrypted: i=1; AJvYcCUVHGTSrTSKU9ebFiAGFI3Zu4s5jBBpJAhGt4vk41+OLQErk2uEBNfzJxFE2lIX6c1mJ/otS/IGJqM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4Zu/S4qZCtRZCc2dp1jZlH01UqwOLYSDSyRJd4ERJ3Ezyr02e
	yJzs2PrUcs3hkccgJ11aUSyS2ya3DmDD2IdAxjtLO8YHm2ccv/DKRiqRCxHSUTo2Uhg=
X-Gm-Gg: ASbGnct9J0iP/DMslvE7/FAhHaAosMY2fqcNtGYqbM+6DubkiTVwxXyqxw7ZZDjHWTQ
	I1Yl8J/QteCR+NWo0buFIZBCrmTf0ijb96B4i1AH8zEb1B8XziWeW5OVw3djmG7n2Tws12ytv2l
	USvt6UrKp6NkQp/+0kMr5aojU8JN5nTS75PqZ3PI15J56k5fsBRn4fzpc6AiYrtrgSaabdQteFl
	buy+McWt1POIJu2UqjNUqcSqsyQ1u23sdA0jDJ0jFlOIokxStEuGqEC6IGmfFvZ7NwE3xQjWV2N
	1aSbNa2e4Lkc+OdaWwC+hEJotDT5YL34uxrWFsR6EAoID7JFfCnsHdXkwuG4l8p1hh1s6N952+p
	ynlEbGyoHVuHDUpjEtf6vu0sUnVUpoh7xRtiU2op3RLBrNh2PJmv0oae48QvC6tHtx/+5Lw==
X-Google-Smtp-Source: AGHT+IFvKOM/RTV7+esqnfgkT3+zba4GE5pNwWEUHiiv9ICW/Oer0zq0k7w/85TozYi/lPW8a3I+MQ==
X-Received: by 2002:a05:690c:6e12:b0:71f:b944:1041 with SMTP id 00721157ae682-71fdc542caemr6096967b3.50.1755807618684;
        Thu, 21 Aug 2025 13:20:18 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-5f52c8b347csm50305d50.6.2025.08.21.13.20.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Aug 2025 13:20:17 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	kernel-team@fb.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	brauner@kernel.org,
	viro@ZenIV.linux.org.uk
Subject: [PATCH 02/50] fs: make the i_state flags an enum
Date: Thu, 21 Aug 2025 16:18:13 -0400
Message-ID: <02211105388c53dc68b7f4332f9b5649d5b66b71.1755806649.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1755806649.git.josef@toxicpanda.com>
References: <cover.1755806649.git.josef@toxicpanda.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Adjusting i_state flags always means updating the values manually. Bring
these forward into the 2020's and make a nice clean macro for defining
the i_state values as an enum, providing __ variants for the cases where
we need the bit position instead of the actual value, and leaving the
actual NAME as the 1U << bit value.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 include/linux/fs.h | 234 +++++++++++++++++++++++----------------------
 1 file changed, 122 insertions(+), 112 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 9a1ce67eed33..e741dc453c2c 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -665,6 +665,127 @@ is_uncached_acl(struct posix_acl *acl)
 #define IOP_MGTIME	0x0020
 #define IOP_CACHED_LINK	0x0040
 
+/*
+ * Inode state bits.  Protected by inode->i_lock
+ *
+ * Four bits determine the dirty state of the inode: I_DIRTY_SYNC,
+ * I_DIRTY_DATASYNC, I_DIRTY_PAGES, and I_DIRTY_TIME.
+ *
+ * Four bits define the lifetime of an inode.  Initially, inodes are I_NEW,
+ * until that flag is cleared.  I_WILL_FREE, I_FREEING and I_CLEAR are set at
+ * various stages of removing an inode.
+ *
+ * Two bits are used for locking and completion notification, I_NEW and I_SYNC.
+ *
+ * I_DIRTY_SYNC		Inode is dirty, but doesn't have to be written on
+ *			fdatasync() (unless I_DIRTY_DATASYNC is also set).
+ *			Timestamp updates are the usual cause.
+ * I_DIRTY_DATASYNC	Data-related inode changes pending.  We keep track of
+ *			these changes separately from I_DIRTY_SYNC so that we
+ *			don't have to write inode on fdatasync() when only
+ *			e.g. the timestamps have changed.
+ * I_DIRTY_PAGES	Inode has dirty pages.  Inode itself may be clean.
+ * I_DIRTY_TIME		The inode itself has dirty timestamps, and the
+ *			lazytime mount option is enabled.  We keep track of this
+ *			separately from I_DIRTY_SYNC in order to implement
+ *			lazytime.  This gets cleared if I_DIRTY_INODE
+ *			(I_DIRTY_SYNC and/or I_DIRTY_DATASYNC) gets set. But
+ *			I_DIRTY_TIME can still be set if I_DIRTY_SYNC is already
+ *			in place because writeback might already be in progress
+ *			and we don't want to lose the time update
+ * I_NEW		Serves as both a mutex and completion notification.
+ *			New inodes set I_NEW.  If two processes both create
+ *			the same inode, one of them will release its inode and
+ *			wait for I_NEW to be released before returning.
+ *			Inodes in I_WILL_FREE, I_FREEING or I_CLEAR state can
+ *			also cause waiting on I_NEW, without I_NEW actually
+ *			being set.  find_inode() uses this to prevent returning
+ *			nearly-dead inodes.
+ * I_WILL_FREE		Must be set when calling write_inode_now() if i_count
+ *			is zero.  I_FREEING must be set when I_WILL_FREE is
+ *			cleared.
+ * I_FREEING		Set when inode is about to be freed but still has dirty
+ *			pages or buffers attached or the inode itself is still
+ *			dirty.
+ * I_CLEAR		Added by clear_inode().  In this state the inode is
+ *			clean and can be destroyed.  Inode keeps I_FREEING.
+ *
+ *			Inodes that are I_WILL_FREE, I_FREEING or I_CLEAR are
+ *			prohibited for many purposes.  iget() must wait for
+ *			the inode to be completely released, then create it
+ *			anew.  Other functions will just ignore such inodes,
+ *			if appropriate.  I_NEW is used for waiting.
+ *
+ * I_SYNC		Writeback of inode is running. The bit is set during
+ *			data writeback, and cleared with a wakeup on the bit
+ *			address once it is done. The bit is also used to pin
+ *			the inode in memory for flusher thread.
+ *
+ * I_REFERENCED		Marks the inode as recently references on the LRU list.
+ *
+ * I_WB_SWITCH		Cgroup bdi_writeback switching in progress.  Used to
+ *			synchronize competing switching instances and to tell
+ *			wb stat updates to grab the i_pages lock.  See
+ *			inode_switch_wbs_work_fn() for details.
+ *
+ * I_OVL_INUSE		Used by overlayfs to get exclusive ownership on upper
+ *			and work dirs among overlayfs mounts.
+ *
+ * I_CREATING		New object's inode in the middle of setting up.
+ *
+ * I_DONTCACHE		Evict inode as soon as it is not used anymore.
+ *
+ * I_SYNC_QUEUED	Inode is queued in b_io or b_more_io writeback lists.
+ *			Used to detect that mark_inode_dirty() should not move
+ *			inode between dirty lists.
+ *
+ * I_PINNING_FSCACHE_WB	Inode is pinning an fscache object for writeback.
+ *
+ * I_LRU_ISOLATING	Inode is pinned being isolated from LRU without holding
+ *			i_count.
+ *
+ * Q: What is the difference between I_WILL_FREE and I_FREEING?
+ *
+ * __I_{SYNC,NEW,LRU_ISOLATING} are used to derive unique addresses to wait
+ * upon. There's one free address left.
+ */
+
+/*
+ * As simple macro to define the inode state bits, __NAME will be the bit value
+ * (0, 1, 2, ...), and NAME will be the bit mask (1U << __NAME). The __NAME_SEQ
+ * is used to reset the sequence number so the next name gets the next bit value
+ * in the sequence.
+ */
+#define INODE_BIT(name)			\
+	__ ## name,			\
+	name = (1U << __ ## name),	\
+	__ ## name ## _SEQ = __ ## name
+
+enum inode_state_bits {
+	INODE_BIT(I_NEW),
+	INODE_BIT(I_SYNC),
+	INODE_BIT(I_LRU_ISOLATING),
+	INODE_BIT(I_DIRTY_SYNC),
+	INODE_BIT(I_DIRTY_DATASYNC),
+	INODE_BIT(I_DIRTY_PAGES),
+	INODE_BIT(I_WILL_FREE),
+	INODE_BIT(I_FREEING),
+	INODE_BIT(I_CLEAR),
+	INODE_BIT(I_REFERENCED),
+	INODE_BIT(I_LINKABLE),
+	INODE_BIT(I_DIRTY_TIME),
+	INODE_BIT(I_WB_SWITCH),
+	INODE_BIT(I_OVL_INUSE),
+	INODE_BIT(I_CREATING),
+	INODE_BIT(I_DONTCACHE),
+	INODE_BIT(I_SYNC_QUEUED),
+	INODE_BIT(I_PINNING_NETFS_WB),
+};
+
+#define I_DIRTY_INODE (I_DIRTY_SYNC | I_DIRTY_DATASYNC)
+#define I_DIRTY (I_DIRTY_INODE | I_DIRTY_PAGES)
+#define I_DIRTY_ALL (I_DIRTY | I_DIRTY_TIME)
+
 /*
  * Keep mostly read-only and often accessed (especially for
  * the RCU path lookup and 'stat' data) fields at the beginning
@@ -723,7 +844,7 @@ struct inode {
 #endif
 
 	/* Misc */
-	u32			i_state;
+	enum inode_state_bits	i_state;
 	/* 32-bit hole */
 	struct rw_semaphore	i_rwsem;
 
@@ -2484,117 +2605,6 @@ static inline void kiocb_clone(struct kiocb *kiocb, struct kiocb *kiocb_src,
 	};
 }
 
-/*
- * Inode state bits.  Protected by inode->i_lock
- *
- * Four bits determine the dirty state of the inode: I_DIRTY_SYNC,
- * I_DIRTY_DATASYNC, I_DIRTY_PAGES, and I_DIRTY_TIME.
- *
- * Four bits define the lifetime of an inode.  Initially, inodes are I_NEW,
- * until that flag is cleared.  I_WILL_FREE, I_FREEING and I_CLEAR are set at
- * various stages of removing an inode.
- *
- * Two bits are used for locking and completion notification, I_NEW and I_SYNC.
- *
- * I_DIRTY_SYNC		Inode is dirty, but doesn't have to be written on
- *			fdatasync() (unless I_DIRTY_DATASYNC is also set).
- *			Timestamp updates are the usual cause.
- * I_DIRTY_DATASYNC	Data-related inode changes pending.  We keep track of
- *			these changes separately from I_DIRTY_SYNC so that we
- *			don't have to write inode on fdatasync() when only
- *			e.g. the timestamps have changed.
- * I_DIRTY_PAGES	Inode has dirty pages.  Inode itself may be clean.
- * I_DIRTY_TIME		The inode itself has dirty timestamps, and the
- *			lazytime mount option is enabled.  We keep track of this
- *			separately from I_DIRTY_SYNC in order to implement
- *			lazytime.  This gets cleared if I_DIRTY_INODE
- *			(I_DIRTY_SYNC and/or I_DIRTY_DATASYNC) gets set. But
- *			I_DIRTY_TIME can still be set if I_DIRTY_SYNC is already
- *			in place because writeback might already be in progress
- *			and we don't want to lose the time update
- * I_NEW		Serves as both a mutex and completion notification.
- *			New inodes set I_NEW.  If two processes both create
- *			the same inode, one of them will release its inode and
- *			wait for I_NEW to be released before returning.
- *			Inodes in I_WILL_FREE, I_FREEING or I_CLEAR state can
- *			also cause waiting on I_NEW, without I_NEW actually
- *			being set.  find_inode() uses this to prevent returning
- *			nearly-dead inodes.
- * I_WILL_FREE		Must be set when calling write_inode_now() if i_count
- *			is zero.  I_FREEING must be set when I_WILL_FREE is
- *			cleared.
- * I_FREEING		Set when inode is about to be freed but still has dirty
- *			pages or buffers attached or the inode itself is still
- *			dirty.
- * I_CLEAR		Added by clear_inode().  In this state the inode is
- *			clean and can be destroyed.  Inode keeps I_FREEING.
- *
- *			Inodes that are I_WILL_FREE, I_FREEING or I_CLEAR are
- *			prohibited for many purposes.  iget() must wait for
- *			the inode to be completely released, then create it
- *			anew.  Other functions will just ignore such inodes,
- *			if appropriate.  I_NEW is used for waiting.
- *
- * I_SYNC		Writeback of inode is running. The bit is set during
- *			data writeback, and cleared with a wakeup on the bit
- *			address once it is done. The bit is also used to pin
- *			the inode in memory for flusher thread.
- *
- * I_REFERENCED		Marks the inode as recently references on the LRU list.
- *
- * I_WB_SWITCH		Cgroup bdi_writeback switching in progress.  Used to
- *			synchronize competing switching instances and to tell
- *			wb stat updates to grab the i_pages lock.  See
- *			inode_switch_wbs_work_fn() for details.
- *
- * I_OVL_INUSE		Used by overlayfs to get exclusive ownership on upper
- *			and work dirs among overlayfs mounts.
- *
- * I_CREATING		New object's inode in the middle of setting up.
- *
- * I_DONTCACHE		Evict inode as soon as it is not used anymore.
- *
- * I_SYNC_QUEUED	Inode is queued in b_io or b_more_io writeback lists.
- *			Used to detect that mark_inode_dirty() should not move
- * 			inode between dirty lists.
- *
- * I_PINNING_FSCACHE_WB	Inode is pinning an fscache object for writeback.
- *
- * I_LRU_ISOLATING	Inode is pinned being isolated from LRU without holding
- *			i_count.
- *
- * Q: What is the difference between I_WILL_FREE and I_FREEING?
- *
- * __I_{SYNC,NEW,LRU_ISOLATING} are used to derive unique addresses to wait
- * upon. There's one free address left.
- */
-#define __I_NEW			0
-#define I_NEW			(1 << __I_NEW)
-#define __I_SYNC		1
-#define I_SYNC			(1 << __I_SYNC)
-#define __I_LRU_ISOLATING	2
-#define I_LRU_ISOLATING		(1 << __I_LRU_ISOLATING)
-
-#define I_DIRTY_SYNC		(1 << 3)
-#define I_DIRTY_DATASYNC	(1 << 4)
-#define I_DIRTY_PAGES		(1 << 5)
-#define I_WILL_FREE		(1 << 6)
-#define I_FREEING		(1 << 7)
-#define I_CLEAR			(1 << 8)
-#define I_REFERENCED		(1 << 9)
-#define I_LINKABLE		(1 << 10)
-#define I_DIRTY_TIME		(1 << 11)
-#define I_WB_SWITCH		(1 << 12)
-#define I_OVL_INUSE		(1 << 13)
-#define I_CREATING		(1 << 14)
-#define I_DONTCACHE		(1 << 15)
-#define I_SYNC_QUEUED		(1 << 16)
-#define I_PINNING_NETFS_WB	(1 << 17)
-
-#define I_DIRTY_INODE (I_DIRTY_SYNC | I_DIRTY_DATASYNC)
-#define I_DIRTY (I_DIRTY_INODE | I_DIRTY_PAGES)
-#define I_DIRTY_ALL (I_DIRTY | I_DIRTY_TIME)
-
 extern void __mark_inode_dirty(struct inode *, int);
 static inline void mark_inode_dirty(struct inode *inode)
 {
-- 
2.49.0

