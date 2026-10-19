Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792434390;
	b=joH01jGMdlVHpDshEC7j9TJVbigX6FIGqPfoup7N+F/vErtwpYup1qoFZ6cbusyE69+L
	 tpU4li3CbSEzrtCLcGhcKd2ootMoLdwsUiEPzJjr+4WtfC1dEs5Cs5eSmt98iistLvjhL
	 RRRzCK4OnYjmcalETicmzYCzhXa9U0zCK0omEqP4BqSJVIy5L3LepKpCeDpTidMywAxs3
	 afuaJrpvYsnbJfQgT6BBBS2yZMv+J0qrpxubizndnRGZ8zSJBNSEKHrCJzPZ+3FS1Km7L
	 oe1FftmDQA+1ulNyGcyfC0/zBaeh8b0OptkHHUk2EYMlqCQFiwLxL4C+zy1A6JC4iRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792434390;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=hTj20ieTvK3hKMPhxPk7vnG3o1kjuNF6YBoMGWWG/DE=;
	b=tYjxpfZUIT5cnVAzTjP1OhIorxkY/B7IE+pBsZ18PkJNQJyz35eSWSgTinqqKohZTTK3
	 ZMcd+ICmEABxVBOrF9uN5+eaciw2c/HA1HLbWgN3zOid/DaJOsKyEwev9a0OdlAQAvjQK
	 OKCnuhzl4b2mKtlGkCzNiFDqH1E9h4W5DoH3vwi2Jq84qh/vaUGV9uBJCskoKoWbMR7Qv
	 I5/YWPlT823ULbeFBfIitUfjI23RsfvD07Mk744xqvgmmwzCpnAY59XSZHZ2UqfoV2e1O
	 u4P8QNGaNBIDEYdgAvKOOjBoDz9AsV29x1JEyGTuHZALfsmlzmtxIzKgwbG2DPQHVsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=OYYuKVTA;
	arc=none smtp.remote-ip=209.85.214.182
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76DF5606A32A
	for <linux-xfs@vger.kernel.org>; Mon, 19 Oct 2026 18:26:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 76DF5606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=OYYuKVTA
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2e987a2ba0cso19829055ad.3
        for <linux-xfs@vger.kernel.org>; Mon, 19 Oct 2026 11:26:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792434389; x=1793039189; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=hTj20ieTvK3hKMPhxPk7vnG3o1kjuNF6YBoMGWWG/DE=;
        b=OYYuKVTAzfaB1W5GbZb/x51DAQkhOerVjiSzfKj/8m5noHrBRZOnJ4PtSwGkriUSUE
         ZZ8hKpisfS8pI5ngVVNvFYwD25SGXrcrGx/b6hsHktpYzMmr2WBaWuAii7Vx888NcrMW
         B/lsRkSjuKDl/WmT2BIQQH31hJ2gurQKQm6FRiVwTFoJP5anZU5Yd4MsxzJPQAC7yul2
         GlZTPH36UZHJLuCmy/75lpHX+Eq0YsthwMNbS+b933kfqc6tKqFmyoG3Xg2pq/uCSC0c
         ySAnXD3IdOmh81Qcmav6wl5P5duMjcXfHOTJaxHtcx5EwUduswQCZkgJCZXDDm5cEN6r
         EEjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792434389; x=1793039189;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=hTj20ieTvK3hKMPhxPk7vnG3o1kjuNF6YBoMGWWG/DE=;
        b=z0wCXKp4AV6T57QHZeyMLvZOjqA/b2498gRQ8cJaK2/68r0PtfObqSALfKIcNPEPuw
         PKeixJwHv6YlS0ExjQGckFqyIJAr+m7G+t0qj6VZerK4Z5MfZbWkZTE9GFQGo5aaKzzj
         hf+6aLMv50FVARSm16CFh9AJLKLG3uNvhIld/JJXo6t1ZLt0/JtiA8auqVYm8qeNf6Bn
         4uouYxxqpj7mmv6rheI5lzGEUJKfkIm3CTRO//+TL4DlFmJNvf6TwUl6TA5ZcIo3uNdO
         9+ph6yMtq7MyfI06KNT+qSv9gAPbjBMe6ds3jc2jF/SBYCYZhMJpHM2kr8oH9sjszGt/
         CFFw==
X-Gm-Message-State: AFq9FYJDjux1qqSroscf4R5jmGdpz/F1Qc0mhK9pKgR5qSYzNbUlgvxb
	tGC7kPMx4Rno9OwcO6lUjtsynLlh8cgYoWefN9iodp5BUcQpfMP+MWtxx94PpMJX
X-Gm-Gg: AYBFou2zRRC/kdR4TOdjkzCFX+ZTYV59FjrsZdsW95hTkT5oe5PjNuIxQi39Ef48W/2
	XK6LWS1QGcBZ8u8rk+bzbn97D7MdC4RoBWDikFbf0T8BXYovBP00Zsr5w5derGXKWTKxX+rJeEV
	Eyy+I02RiCzoHnOGXRc4Nabaza5pfiZoRPtvX/JqYgugLTgaa2j+R35NICAdIYdaoDndDWYKZ1G
	F7S164jcGrpDTLWjbTw/G2+GEyO0uAmWDJgrMZ2kLv7H8qupVHau1MA9XPr0Mp4/ZMZrylvIuEf
	fSOuB6f8eFZKZWxWUGMZBwj3b/bsE3TTl1kd39BX4nXvT8KKtyNox2tGIMhvuwWl3JkxO555lZP
	N47+N1jEG+M3S4/uYODxdBhd4lazw1cXfZUoeGJuJelcFCOODKRbCDMjFLUDU1iQViGU2jWaNuR
	JODAU30nDdfUeXdmH6hGTlk7PWcaHU5Tns1/cuerFBp2tuNavZG21rPPLbDEhXnbCUUZhJVUfdE
	/0Yp7p/kngvpXJ+ic9K+Z8wX6zTCi18Q2oz3WJez1vWoatuhugoW6rTCAQg24uYH+EAxaJvnIuD
	5drKD20TMJP5tWrwCvGCdWIIthEoZA==
X-Received: by 2002:a17:903:22cb:b0:2e9:5d1f:dffe with SMTP id d9443c01a7336-2e9a6d3b0c9mr73738905ad.57.1792434388283;
        Mon, 19 Oct 2026 11:26:28 -0700 (PDT)
Received: from archlinux.tail3acd4.ts.net ([69.110.143.170])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ea1517e7cfsm4156375ad.58.2026.10.19.11.26.27
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 11:26:27 -0700 (PDT)
From: Vitali Lovich <vlovich@gmail.com>
To: linux-xfs@vger.kernel.org
Subject: [RFC PATCH v1 1/6] fs: implement range-based generation-coordinated DIO draining
Date: Mon, 19 Oct 2026 11:26:15 -0700
Message-ID: <20261019182620.1527591-2-vlovich@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261019182620.1527591-1-vlovich@gmail.com>
References: <20261019182620.1527591-1-vlovich@gmail.com>
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
index 844d65eb47a5..7ae93f04dc69 100644
--- a/Documentation/filesystems/locking.rst
+++ b/Documentation/filesystems/locking.rst
@@ -93,40 +93,44 @@ prototypes::
 	int (*fileattr_get)(struct dentry *dentry, struct file_kattr *fa);
 	struct posix_acl * (*get_acl)(struct mnt_idmap *, struct dentry *, int);
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
index d3a93eec3945..54ba380ed4b6 100644
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
index a9d37be390a1..cb35eefe0d40 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -358,6 +358,7 @@ struct inode *alloc_inode(struct super_block *sb)
 
 void __destroy_inode(struct inode *inode)
 {
+	WARN_ON_ONCE(atomic_read(&inode->i_dio_count) & INODE_DIO_DRAINING);
 	inode_detach_wb(inode);
 	security_inode_free(inode);
 	fsnotify_inode_delete(inode);
@@ -2767,10 +2768,114 @@ EXPORT_SYMBOL(inode_owner_or_capable);
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
index deb411e86661..e5c2e857e530 100644
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
@@ -2036,6 +2037,8 @@ struct inode_operations {
 			    struct dentry *dentry, struct file_kattr *fa);
 	int (*fileattr_get)(struct dentry *dentry, struct file_kattr *fa);
 	struct offset_ctx *(*get_offset_ctx)(struct inode *inode);
+	/* Complete an old-generation DIO during a drain; must not sleep. */
+	void (*dio_drain_complete)(struct inode *inode);
 } ____cacheline_aligned;
 
 /* Did the driver provide valid mmap hook configuration? */
@@ -3164,6 +3167,92 @@ bool inode_dio_finished(const struct inode *inode);
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
@@ -3185,7 +3274,8 @@ static inline void inode_dio_begin(struct inode *inode)
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

base-commit: 0fcb05b72344f40806cbe810de8872f1698bf053
-- 
2.56.0

