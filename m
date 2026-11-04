Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793815971;
	b=iDRP4xIpyXs5kHeC/9IDfV9ZuH16rEz6y6xkhNeI+Rj4uUS+68Rvxh5Cd2NTEzM7Nrrw
	 dsZEgVqbR/UlkiTsuYtrnHr2RJiirCgUtU6LorsVYvf6mL3JCud55pwQB7xO+tuY4qxtG
	 PRYLqz5UE2F33yDAeUdQaP1t9XISU8+aUtv1fzjCYSizWMxtvu8tOVNMsBtedRX25Jj+W
	 rHDmpvWktg925a0QJvGGNcqiRhw+d3e0N+aEYnSvxxpMkppBeoi3oNfuhDYX6p3Eh8SwO
	 0nyRUbMlIuo+j+idXm+taxR5vRtIzU2Ry7Lc/tZK1v5MAAxgD8ni+CPd7N7UBYXGr7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793815971;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4jR5g7ZhU4ZTGj4CMxjvz0KvZ1iGvcXv9dfVeD7UpZk=;
	b=kMLQONpbaOXGAKd+2Q+E3+ifVTubSXECLdJNGqOgF7U7a4z0vVo2awI3r+0Y3z3jDsOw
	 iI3aq77qkatBIJFjx1dhJIsq+Fb/oXqPxcJwUDIGEFUPGhb8m+MHvBqFf9UKeUVYcklgi
	 IQfxubG/PA/PytdjMqIsevN18gyd9wLHhtgRaUHdXptqSAlCYVdtRRDDACH5wU+98McIv
	 D48fo4ihHqvGNEB1ZepRc39/xUNFAt7ihZwWg09L/jAQ9RXa00SwynDCkPwwcI827tLMu
	 gEDPM0flUYtAi3RS7mUzvVEt66WFyd13UXrQWHtY6bIZvfgHBKlGWbK/x7UmtHlwC3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FIsUsuW5;
	arc=none smtp.remote-ip=209.85.216.42
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73DC5606A68D
	for <linux-xfs@vger.kernel.org>; Wed,  4 Nov 2026 18:12:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 73DC5606A68D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FIsUsuW5
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-3b0a519049aso424531a91.1
        for <linux-xfs@vger.kernel.org>; Wed, 04 Nov 2026 10:12:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793815970; x=1794420770; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4jR5g7ZhU4ZTGj4CMxjvz0KvZ1iGvcXv9dfVeD7UpZk=;
        b=FIsUsuW5NoG69NJafmTOnWTznIvcoqZo9UCZ1OuHWAJjN8xWk48DArZpaYIeDy7AOo
         fn4neCccdUetUbZSOD1K3XrAUS4J5vTo8ArjURPPx0SazxfY9IoqYkRZ/1RcM6/nwiKx
         B7LWinKQdNzU8mGzrPmE2vvx0ddvlXnbJ7IUuycGjK3Ku2G8rh++LHJTcSQXjAqSiw97
         MqIVhh4LBxQ/trfg1H1a1UNhBygB1CbBln/FOuuhOBmyK+WM0hf/Sz+mS7/IfuRnBCdT
         lf8KLBO78MdLpJ5+qeVXdjs6xZ57fQHvgqZEJz0wB2i1imJarCx72nyQ6UEPRXjFVFhx
         pQEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793815970; x=1794420770;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4jR5g7ZhU4ZTGj4CMxjvz0KvZ1iGvcXv9dfVeD7UpZk=;
        b=w8Vyb7NwdWnd34EYn7D7Hb/v137JIjboJj0muZcIlX8MtNCvxOwXUkTCZRlgTltGCV
         DO1FJRSZXRnticxHUU0/8OlvuTZ6avucvCcK7j1pzcG66yfiMHXmgjV1XJ7ZeKpbUcKG
         nNILrjnQZdGztvTKK2dHKn+zvCSKkMvF8gwZxMJw6yYGw/VDPrzy90Niw6CUmZWF1ozy
         mTHmGTOtOc50lyowUa1OtTfUKbSYrP4+cWAgTA05OFUZKPOfkEL0DfMsBhZvzCs2CYti
         yBRR+0UTVf7DrVGE5p2RMZwY0xsa7s3NQnLiSLhGAqmoN+CQswLxk7nBdKSNmZ5rP8Yb
         hMAg==
X-Forwarded-Encrypted: i=1; AKwUvBxUuvwJIEquP/FHrQBGmjb+sOp8QkLF1bUuVYxz/t7URxplNkDepC/T9SZYIbYumG19KzuF5lmsT0w=@vger.kernel.org
X-Gm-Message-State: APuU4Z/vbRVItDIXytNADU4WQV/KZUMjJxAYiAoglh7bqark4AmoYsxX
	I0lLn2/MLal4ll+2UoZr/PJnI8vc034cAlVkdvX5bOnqEKr9lLyskpcz
X-Gm-Gg: AYBFou1TC7uiuCQbFv/haniObetTnT2nVzmrfr73Jly+g5Tu2hr325Dek4WC6Q/tuic
	cy5vg4XaFdGeJIn16feQp3M+f4gjQPEL06npyEBL6expYhBOKopmCckoeL3QO/VhIhik0dgEuDm
	TjWXD/vbLVBd0opC4cyFBWr4gleOeodjaigzeiqWfanUI5/TNk0g+yTfDE3AGvdLvZQfJlSqj2t
	7oSM7z+ymGqhkCmJXeVZinK5qsLrXyh2pEnXS4uzmekUsOOWo1Je0sgTExlrVivBnK4uEuusyv3
	oZemRCaK90d+2Z9LresOkrrKGhcYOOYd4Bq+qg77xJLRtbr+PYPa8wjPvfEtBQAsC2yF2cYjD5y
	68RWtdR99kSQE+sGOKyxE9By3UZ4rHVe+dm1YlFHdhlquMne44KhpmAxy1Otn7Pd+mYa6aRQ1S3
	DjbrsqpQcsiwB2h+wFplR0e8jkYU8bUEKCXlajGZ7oT3XO2hVRhi5i6yOl70KB87bXzABPCfp94
	oc9LOkGbYATezJPOdQuEo5mL4UNd/0ckBDRUNuXkI92Q+ORhwZFi0ZOVMW24hIgn7ppq/QCrliD
	jqL+G1XR1LDhV40IsodB6RR4a/dzvOjm02KD7bLLsibs575euyicIn5tk6SW5MI9+7xghwKIJGf
	3cPhF7g==
X-Received: by 2002:a17:90b:28c5:b0:3ad:ce24:acfa with SMTP id 98e67ed59e1d1-3ae897c652dmr13485282a91.20.1793815969563;
        Wed, 04 Nov 2026 10:12:49 -0800 (PST)
Received: from archlinux.tail3acd4.ts.net ([69.110.143.170])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b0b31a3efasm78326a91.9.2026.11.04.10.12.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 10:12:49 -0800 (PST)
From: Vitali Lovich <vlovich@gmail.com>
To: linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Cc: brauner@kernel.org,
	viro@zeniv.linux.org.uk,
	jack@suse.cz,
	cem@kernel.org,
	djwong@kernel.org
Subject: [RFC PATCH 1/6] fs: implement range-based generation-coordinated DIO draining
Date: Wed,  4 Nov 2026 10:12:41 -0800
Message-ID: <f8d8760ee9bfac6478fe18f866c8b809b2c22f40.1793815542.git.vlovich@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1793815542.git.vlovich@gmail.com>
References: <cover.1793815542.git.vlovich@gmail.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Whole-inode direct I/O (DIO) draining currently requires filesystems to
exclude all new submission requests, even those completely disjoint from
the range being modified.

Add generation accounting and range admission to allow filesystems to
drain a finite cohort of in-flight DIO while concurrently admitting
new, disjoint DIO under a shared i_rwsem.

This reserves the top two bits of i_inode->i_dio_count for generation
and draining state, utilizes seqcount_latch_t for lockless range snapshot
validation, and introduces a new ->dio_drain_complete VFS operation to
resolve private drain state lazily without bloating struct inode or
per-request storage.

Signed-off-by: Vitali Lovich <vlovich@gmail.com>
---
 Documentation/filesystems/locking.rst         |  89 ++++++++++-----
 Documentation/filesystems/vfs.rst             |  41 +++++++
 fs/inode.c                                    | 107 +++++++++++++++++-
 fs/xfs/xfs_reflink.h                          |   2 +-
 include/linux/fs.h                            |  92 ++++++++++++++-
 .../litmus-tests/DIO-register-first.litmus    |  36 ++++++
 6 files changed, 334 insertions(+), 33 deletions(-)
 create mode 100644 tools/memory-model/litmus-tests/DIO-register-first.litmus

diff --git a/Documentation/filesystems/locking.rst b/Documentation/filesystems/locking.rst
index f7363ad770c7..cfd4ce7ed563 100644
--- a/Documentation/filesystems/locking.rst
+++ b/Documentation/filesystems/locking.rst
@@ -93,40 +93,44 @@ prototypes::
 	int (*fileattr_get)(struct dentry *dentry, struct file_kattr *fa);
 	struct posix_acl * (*get_acl)(const struct mnt_idmap *, struct dentry *, int);
 	struct offset_ctx *(*get_offset_ctx)(struct inode *inode);
+	void (*dio_drain_complete)(struct inode *inode);
 
 locking rules:
-	all may block
+	all may block except dio_drain_complete
 
-==============	==================================================
-ops		i_rwsem(inode)
-==============	==================================================
-lookup:		shared
-create:		exclusive
-link:		exclusive (both)
-mknod:		exclusive
-symlink:	exclusive
-mkdir:		exclusive
-unlink:		exclusive (both)
-rmdir:		exclusive (both)(see below)
-rename:		exclusive (both parents, some children)	(see below)
-readlink:	no
-get_link:	no
-setattr:	exclusive
-permission:	no (may not block if called in rcu-walk mode)
-get_inode_acl:	no
-get_acl:	no
-getattr:	no
-listxattr:	no
-fiemap:		no
-update_time:	no
-sync_lazytime:	no
-atomic_open:	shared (exclusive if O_CREAT is set in open flags)
-tmpfile:	no
-fileattr_get:	no or exclusive
-fileattr_set:	exclusive
-get_offset_ctx  no
-==============	==================================================
+==================  ==================================================
+ops                 i_rwsem(inode)
+==================  ==================================================
+lookup:             shared
+create:             exclusive
+link:               exclusive (both)
+mknod:              exclusive
+symlink:            exclusive
+mkdir:              exclusive
+unlink:             exclusive (both)
+rmdir:              exclusive (both)(see below)
+rename:             exclusive (both parents, some children) (see below)
+readlink:           no
+get_link:           no
+setattr:            exclusive
+permission:         no (may not block if called in rcu-walk mode)
+get_inode_acl:      no
+get_acl:            no
+getattr:            no
+listxattr:          no
+fiemap:             no
+update_time:        no
+sync_lazytime:      no
+atomic_open:        shared (exclusive if O_CREAT is set in open flags)
+tmpfile:            no
+fileattr_get:       no or exclusive
+fileattr_set:       exclusive
+get_offset_ctx      no
+dio_drain_complete  no
+==================  ==================================================
 
+->dio_drain_complete() does not require i_rwsem and must not block. It may
+run in interrupt context.
 
 	Additionally, ->rmdir(), ->unlink() and ->rename() have ->i_rwsem
 	exclusive on victim.
@@ -138,6 +142,31 @@ get_offset_ctx  no
 See Documentation/filesystems/directory-locking.rst for more detailed discussion
 of the locking scheme for directory operations.
 
+Direct I/O range draining
+=========================
+
+Range drainers acquire ``drain->lock`` before ``inode->i_rwsem`` and any
+filesystem locks needed by the protected operation. Hold the drain mutex
+through inode_dio_drain_finish(): it serializes range publication, cohort
+draining, the protected operation, and exclusion removal. Never wait for
+this mutex while holding i_rwsem, even shared.
+
+A drainer can drop i_rwsem and reacquire it exclusively during write
+checks, for example to strip privileges. Acquiring the mutex inside shared
+i_rwsem would permit this deadlock:
+
+1. Drainer A holds the drain mutex and shared i_rwsem.
+2. Drainer B holds shared i_rwsem and waits for A's drain mutex.
+3. A drops shared i_rwsem and tries to acquire it exclusively. B's shared
+   lock prevents A from proceeding, while B cannot release it until A
+   releases the mutex.
+
+Callers that already hold i_rwsem must drop it before waiting for the drain
+mutex, then reacquire i_rwsem and repeat their checks. DIO admission and
+completion do not acquire the drain mutex, so the old cohort can complete
+while a drainer holds it. Drain the old cohort before taking any filesystem
+lock that its I/O preparation or completion might need.
+
 xattr_handler operations
 ========================
 
diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesystems/vfs.rst
index 1824462a4371..60fa5c12e451 100644
--- a/Documentation/filesystems/vfs.rst
+++ b/Documentation/filesystems/vfs.rst
@@ -445,6 +445,7 @@ As of kernel 2.6.22, the following members are defined:
 				    struct dentry *dentry, struct file_kattr *fa);
 		int (*fileattr_get)(struct dentry *dentry, struct file_kattr *fa);
 	        struct offset_ctx *(*get_offset_ctx)(struct inode *inode);
+		void (*dio_drain_complete)(struct inode *inode);
 	};
 
 Again, all methods are called without any locks being held, unless
@@ -634,6 +635,46 @@ otherwise noted.
         filesystem must define this operation to use
         simple_offset_dir_operations.
 
+``dio_drain_complete``
+	called by inode_dio_end_generation() when a direct I/O request
+	from the old generation completes while a drain is active.
+	Filesystems that use inode_dio_drain_start() must implement this
+	method to look up their private struct inode_dio_drain pointer
+	(allocated via inode_dio_drain_get() and retained until inode
+	reclamation) and pass it to inode_dio_drain_complete(). Because
+	a drain may be started while earlier requests are already in
+	flight, the method must locate the drain state from the inode
+	itself rather than from per-request submission state. May be
+	called in interrupt context and must not sleep.
+
+	inode_dio_drain_start() returns -EOPNOTSUPP without changing drain
+	state if this method is absent. Callers must check for success
+	before waiting for or finishing the drain.
+
+	Drain operations serialize with the drain mutex, then hold i_rwsem
+	shared to exclude truncate and buffered writes. Never wait for the
+	drain mutex while holding i_rwsem: its owner may need to drop shared
+	i_rwsem and reacquire it exclusively during write checks. See the
+	deadlock example in Documentation/filesystems/locking.rst.
+
+	Every DIO admission must use inode_dio_try_begin() to register
+	provisionally with a fully ordered atomic increment before reading the
+	range snapshot and preparing or submitting I/O. A failed admission
+	withdraws its token with generation-aware completion accounting before
+	returning. The caller must drop its submission lock before waiting for
+	the exclusion to clear, then reacquire the lock and recheck the request.
+
+	inode_dio_drain_start() publishes both copies of a seqcount_latch_t
+	range snapshot before the fully ordered generation flip and DIO count
+	snapshot. Earlier registrations belong to the finite old cohort;
+	later registrations observe the exclusion or a later snapshot.
+	Nonoverlapping new-generation I/O can proceed without extending the
+	old cohort. Readers only load and validate scalar snapshots, and do
+	not acquire the drain mutex, including on PREEMPT_RT. The lazy drain
+	allocation is acquired through its published pointer and lives until
+	inode reclaim. inode_dio_drain_finish() publishes an inactive snapshot
+	and wakes blocked admissions. Range reuse requires no RCU grace period.
+
 The Address Space Object
 ========================
 
diff --git a/fs/inode.c b/fs/inode.c
index f63535ee3629..7b027547b305 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -358,6 +358,7 @@ struct inode *alloc_inode(struct super_block *sb)
 
 void __destroy_inode(struct inode *inode)
 {
+	WARN_ON_ONCE(atomic_read(&inode->i_dio_count) & INODE_DIO_DRAINING);
 	inode_detach_wb(inode);
 	security_inode_free(inode);
 	fsnotify_inode_delete(inode);
@@ -2778,10 +2779,114 @@ EXPORT_SYMBOL(inode_owner_or_capable);
  */
 bool inode_dio_finished(const struct inode *inode)
 {
-	return atomic_read(&inode->i_dio_count) == 0;
+	return !(atomic_read(&inode->i_dio_count) & INODE_DIO_COUNT_MASK);
 }
 EXPORT_SYMBOL(inode_dio_finished);
 
+/*
+ * Allocated on the first draining operation, never on ordinary DIO. The
+ * filesystem owns the pointer and retains the allocation until inode reclaim.
+ */
+struct inode_dio_drain *inode_dio_drain_get(struct inode_dio_drain **drainp)
+{
+	struct inode_dio_drain *drain, *existing;
+
+	/* Acquire the initialized metadata published by the successful cmpxchg. */
+	drain = smp_load_acquire(drainp);
+	if (drain)
+		return drain;
+	drain = kzalloc_obj(*drain, GFP_NOFS);
+	if (!drain)
+		return ERR_PTR(-ENOMEM);
+	mutex_init(&drain->lock);
+	seqcount_latch_init(&drain->range_seq);
+	existing = cmpxchg(drainp, NULL, drain);
+	if (existing) {
+		kfree(drain);
+		/* A failed cmpxchg does not acquire the winner's initialization. */
+		drain = smp_load_acquire(drainp);
+	}
+	return drain;
+}
+EXPORT_SYMBOL_GPL(inode_dio_drain_get);
+
+/* Writers hold drain->lock; readers retain scalars, never copy pointers. */
+static void inode_dio_publish_range(struct inode_dio_drain *drain,
+		bool active, loff_t start, loff_t last)
+{
+	struct inode_dio_range range = {
+		.active = active, .start = start, .last = last,
+	};
+
+	lockdep_assert_held(&drain->lock);
+	write_seqcount_latch_begin(&drain->range_seq);
+	drain->range[0] = range;
+	write_seqcount_latch(&drain->range_seq);
+	drain->range[1] = range;
+	write_seqcount_latch_end(&drain->range_seq);
+}
+
+/*
+ * The drain mutex serializes drain operations before they acquire the shared
+ * inode lock. Never wait for it while holding i_rwsem: its owner may need to
+ * drop shared i_rwsem and reacquire it exclusively during write checks.
+ * Keep the mutex through the protected operation and inode_dio_drain_finish().
+ * Every DIO on this inode must use inode_dio_try_begin() for admission and
+ * generation-aware completion accounting, including pre-submission failures.
+ * The filesystem must publish the drain pointer before calling this function
+ * and provide ->dio_drain_complete to find it at completion, including for
+ * requests admitted before the first drain allocation.
+ * Return -EOPNOTSUPP without publishing a drain if the callback is absent.
+ */
+int inode_dio_drain_start(struct inode *inode, struct inode_dio_drain *drain,
+			 loff_t start, loff_t last)
+{
+	unsigned int old;
+
+	lockdep_assert_held(&drain->lock);
+	lockdep_assert_held(&inode->i_rwsem);
+	if (!inode->i_op->dio_drain_complete)
+		return -EOPNOTSUPP;
+	WARN_ON_ONCE(atomic_read(&inode->i_dio_count) & INODE_DIO_DRAINING);
+	WARN_ON_ONCE(atomic_read(&drain->pending));
+	WARN_ON_ONCE(drain->range[0].active);
+	atomic_set(&drain->pending, 0);
+	/* Both latch copies are published before the fully ordered cohort cutover. */
+	inode_dio_publish_range(drain, true, start, last);
+	old = atomic_fetch_xor(INODE_DIO_DRAINING | INODE_DIO_GENERATION,
+			&inode->i_dio_count);
+	/* Early completions subtract from zero; adding the snapshot reconciles it. */
+	atomic_add(old & INODE_DIO_COUNT_MASK, &drain->pending);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(inode_dio_drain_start);
+
+void inode_dio_drain_wait(struct inode *inode, struct inode_dio_drain *drain)
+{
+	lockdep_assert_held(&drain->lock);
+	wait_var_event(&inode->i_dio_count, !atomic_read(&drain->pending));
+}
+EXPORT_SYMBOL_GPL(inode_dio_drain_wait);
+
+void inode_dio_drain_finish(struct inode *inode, struct inode_dio_drain *drain)
+{
+	lockdep_assert_held(&drain->lock);
+	WARN_ON_ONCE(atomic_read(&drain->pending));
+	atomic_fetch_and(~INODE_DIO_DRAINING, &inode->i_dio_count);
+	inode_dio_publish_range(drain, false, 0, 0);
+	/* Order exclusion clearing before wake_up_var's waiter check. */
+	smp_mb();
+	wake_up_var(&inode->i_dio_count);
+}
+EXPORT_SYMBOL_GPL(inode_dio_drain_finish);
+
+void inode_dio_drain_complete(struct inode *inode, struct inode_dio_drain *drain)
+{
+	if (atomic_dec_and_test(&drain->pending))
+		wake_up_var(&inode->i_dio_count);
+}
+EXPORT_SYMBOL_GPL(inode_dio_drain_complete);
+
 /**
  * inode_dio_wait - wait for outstanding DIO requests to finish
  * @inode: inode to wait for
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
index 683c1841e640..c862b9a01c78 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -20,7 +20,7 @@ xfs_can_free_cowblocks(struct xfs_inode *ip)
 	if ((inode_state_read_once(inode) & I_DIRTY_PAGES) ||
 	    mapping_tagged(inode->i_mapping, PAGECACHE_TAG_DIRTY) ||
 	    mapping_tagged(inode->i_mapping, PAGECACHE_TAG_WRITEBACK) ||
-	    atomic_read(&inode->i_dio_count))
+	    !inode_dio_finished(inode))
 		return false;
 	return true;
 }
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 99caef43ff3c..016f621345af 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -24,6 +24,7 @@
 #include <linux/mm_types.h>
 #include <linux/capability.h>
 #include <linux/semaphore.h>
+#include <linux/seqlock.h>
 #include <linux/fcntl.h>
 #include <linux/rculist_bl.h>
 #include <linux/atomic.h>
@@ -2040,6 +2041,8 @@ struct inode_operations {
 			    struct dentry *dentry, struct file_kattr *fa);
 	int (*fileattr_get)(struct dentry *dentry, struct file_kattr *fa);
 	struct offset_ctx *(*get_offset_ctx)(struct inode *inode);
+	/* Complete an old-generation DIO during a drain; must not sleep. */
+	void (*dio_drain_complete)(struct inode *inode);
 } ____cacheline_aligned;
 
 /* Did the driver provide valid mmap hook configuration? */
@@ -3170,6 +3173,92 @@ bool inode_dio_finished(const struct inode *inode);
 void inode_dio_wait(struct inode *inode);
 void inode_dio_wait_interruptible(struct inode *inode);
 
+/*
+ * Completion and drain publication share this single atomic cutover. Only
+ * inodes whose DIO always uses the generation-aware helpers may arm a drain.
+ * The low bits retain the normal DIO count, including newer generations.
+ */
+#define INODE_DIO_COUNT_MASK	((1U << 30) - 1)
+#define INODE_DIO_GENERATION	(1U << 30)
+#define INODE_DIO_DRAINING	(1U << 31)
+
+struct inode_dio_range {
+	bool		active;
+	loff_t		start;
+	loff_t		last;
+};
+
+struct inode_dio_drain {
+	struct mutex	lock;
+	atomic_t	pending;
+	seqcount_latch_t range_seq;
+	struct inode_dio_range range[2];
+};
+
+struct inode_dio_drain *inode_dio_drain_get(struct inode_dio_drain **drainp);
+int __must_check inode_dio_drain_start(struct inode *inode,
+		struct inode_dio_drain *drain, loff_t start, loff_t last);
+void inode_dio_drain_wait(struct inode *inode, struct inode_dio_drain *drain);
+void inode_dio_drain_finish(struct inode *inode, struct inode_dio_drain *drain);
+void inode_dio_drain_complete(struct inode *inode, struct inode_dio_drain *drain);
+
+/* The allocation lives until inode reclaim; readers need no RCU section. */
+static inline bool inode_dio_drain_overlap(struct inode *inode,
+		struct inode_dio_drain *drain, loff_t pos, loff_t len)
+{
+	struct inode_dio_range range;
+	unsigned int seq;
+	loff_t last;
+
+	if (!len || !drain)
+		return false;
+	do {
+		seq = read_seqcount_latch(&drain->range_seq);
+		range.active = READ_ONCE(drain->range[seq & 1].active);
+		range.start = READ_ONCE(drain->range[seq & 1].start);
+		range.last = READ_ONCE(drain->range[seq & 1].last);
+	} while (read_seqcount_latch_retry(&drain->range_seq, seq));
+	last = min_t(u64, LLONG_MAX, (u64)pos + len - 1);
+	return range.active && last >= range.start && pos <= range.last;
+}
+
+static inline bool inode_dio_begin_generation(struct inode *inode)
+{
+	return atomic_fetch_inc(&inode->i_dio_count) &
+		INODE_DIO_GENERATION;
+}
+
+static inline void inode_dio_end_generation(struct inode *inode, bool generation)
+{
+	unsigned int old = atomic_fetch_sub(1, &inode->i_dio_count);
+
+	/* A later load of the generation would race with drain publication. */
+	if (unlikely((old & INODE_DIO_DRAINING) &&
+		     !!(old & INODE_DIO_GENERATION) != generation))
+		inode->i_op->dio_drain_complete(inode);
+	if ((old & INODE_DIO_COUNT_MASK) == 1)
+		wake_up_var(&inode->i_dio_count);
+}
+
+/*
+ * Register before inspecting the exclusion. The fully ordered increment pairs
+ * with the publisher's fully ordered generation cutover: a request either
+ * belongs to the finite old cohort or observes the published range (or a
+ * later snapshot). No I/O preparation may precede this admission helper.
+ * Rejected requests withdraw their provisional token before waiting/returning.
+ */
+static inline bool inode_dio_try_begin(struct inode *inode,
+		struct inode_dio_drain **drainp, loff_t pos, loff_t len,
+		bool *generation)
+{
+	*generation = inode_dio_begin_generation(inode);
+	/* Pair with the first allocation's publication in inode_dio_drain_get(). */
+	if (!inode_dio_drain_overlap(inode, smp_load_acquire(drainp), pos, len))
+		return true;
+	inode_dio_end_generation(inode, *generation);
+	return false;
+}
+
 /**
  * inode_dio_begin - signal start of a direct I/O requests
  * @inode: inode the direct I/O happens on
@@ -3191,7 +3280,8 @@ static inline void inode_dio_begin(struct inode *inode)
  */
 static inline void inode_dio_end(struct inode *inode)
 {
-	if (atomic_dec_and_test(&inode->i_dio_count))
+	if ((atomic_fetch_sub(1, &inode->i_dio_count) &
+	     INODE_DIO_COUNT_MASK) == 1)
 		wake_up_var(&inode->i_dio_count);
 }
 
diff --git a/tools/memory-model/litmus-tests/DIO-register-first.litmus b/tools/memory-model/litmus-tests/DIO-register-first.litmus
new file mode 100644
index 000000000000..a7bca403bdfa
--- /dev/null
+++ b/tools/memory-model/litmus-tests/DIO-register-first.litmus
@@ -0,0 +1,36 @@
+C DIO-register-first
+
+(*
+ * Result: Never
+ *
+ * Model one drain cutover, with count bit 0 and generation bit 1.
+ * Publishing both latch copies (or the first initialized drain pointer)
+ * precedes the fully ordered generation RMW. An admission increment which
+ * follows the cutover must see the exclusion. A pre-cutover registration is
+ * instead accounted in the finite old cohort. Completion and subsequent
+ * latch reuse are deliberately outside this single-cutover ordering model.
+ *)
+
+{
+	atomic_t count = 0;
+	int active = 0;
+}
+
+P0(atomic_t *count, int *active)
+{
+	int r0;
+
+	WRITE_ONCE(*active, 1);
+	r0 = atomic_fetch_add(2, count);
+}
+
+P1(atomic_t *count, int *active)
+{
+	int r0;
+	int r1;
+
+	r0 = atomic_fetch_add(1, count);
+	r1 = READ_ONCE(*active);
+}
+
+exists (1:r0=2 /\ 1:r1=0)
-- 
2.56.0

