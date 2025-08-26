Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com [209.85.219.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 951EA352FCA
	for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 15:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756222872; cv=none; b=EwD8T/XeNiaERmtlgSWMGcp6XfWQReeZpa+D2xmo+j8Dd6RL/73ycv07y7VnU5+7rgURcNDgmH8VXaDokU9RnJd1aravJYbjvH76D8dzE0H6zbezTT65mosvwAydlmq/ZHpnQ94KELmL40g3GV1tV8LE+QyItxWN1IdWmNhsGVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756222872; c=relaxed/simple;
	bh=K/2E6jJOHKbiBNVw4qyhmvX0VNRB3Q1kRWjPnsEz6Qs=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WGezhoNuTOnQ+O/PAx4Fw0mE/Af1Wh+cZWmrdKn/ckLamDvoyDff201pr2yyMXLjuik1EMQEFslSvZ7Uv5FZCYxkGGWhEiyA0w4qjPX/etet6smWn0JSkpzaV6qflUsVDDvX0qa0uwpZA42tepAiKwMm4ZNI1TjFeq9e3xv7OwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=GNCRS63J; arc=none smtp.client-ip=209.85.219.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="GNCRS63J"
Received: by mail-yb1-f171.google.com with SMTP id 3f1490d57ef6-e931c71a1baso8240416276.0
        for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 08:41:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1756222867; x=1756827667; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N3dSZ2phmUuD6/YyE9yBKEL4BgEi76aqZtdAMW8+MgI=;
        b=GNCRS63J8a9NYmPb/q/1ShkfAfOSsgSqU7FjkpR5hdwPXCuDb/O7olFpxJAurLh7ja
         NFPV5bFN8GZFLBrDuGNaCH29F49cn2mEFXR3DMv0SWcf5ZghO0wbjAbeHvbll3C3VMC+
         cWpR5G/B9VOQsxob+no7avnfUlFBiU7nGvqYTe02GdABSzgAqmkV/izBk5L90W7k7iOr
         vLpbS2kdPwC76UrRTtxMlDiCaHzxN+M4+BPYtSQq8yVp7PYeZQmkceIpzug/pLRsVzbW
         ue6TjDDpEyqyCc3P2VaKxEK4NG1ip70Aephv2CKEENOjxXqv5PFoXhyeCRFKr2A2Kt2J
         eGRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756222867; x=1756827667;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N3dSZ2phmUuD6/YyE9yBKEL4BgEi76aqZtdAMW8+MgI=;
        b=fHFt8aYCE1Z4v3TTN1bDO9Z7uHFuitHu/9i3/2Iy43gOMlzhFLousznFkXl2lWj34g
         eZAnPWCGpPGwCPyflkTiB+S1iFbiq9bIIwyvBJr8i2j08NfKgSzKImlKNXpvoLqJjQ+D
         PBKouJ45qW9qyHLNXyhXSaXHtDfrBSIWx4gMKZCeuY7Lx4nvc0xFOrOgCwf4Xpb2TOg1
         8CyhuAg77w2/taICbcUZVVkXwtCzHj/jmV32brSBvJTh8UCM2KqCMQngnM9daWbJV7MP
         YjLchq2fkib1pjC+KenDioLcOdOsoZQNUVZrpkN/J0/FWepQDmKuVjgb2JJykeUqa3Y6
         KFHw==
X-Forwarded-Encrypted: i=1; AJvYcCWtDK/JR3ghPIf17uAwLangsu6ju7g9U1bmg9Dxp2UP5c3gAdkRjgVvBdqdxPTl7eMobDfEbZ9jsS8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxeaypNmq4WrobT7UETCqWW+Tf7gwJSeHMBn2aoFkfFmynodPOw
	MvXnvoQse/DKxjjmm7dAqxIUhwzRRNlLp/k7HGVsUDfo/dADfR6HWwWm1djbuTlAJ3U=
X-Gm-Gg: ASbGncvKPAAgp0ze3Ol8heLh7oMRkCEFrfSgox/yuxh21D8mm7ZBdbJlTnWiPm37bEM
	qf2E64qHjrfQ/JO3PQMKyBf0ZXjpyFRHbjiYLGMVyM5tgswtYA1wciIYfPcOC4/3etA9fcGskqk
	F3+uUwkcE5hWUYAOWPTP0xrAeVc8VChhK2sZTnkdBX/h3kL0R4Tb9ogznk7nXJHHfdlLTjXxmJn
	LoSIFRunr2z8y4VQYpCIlAw8oHbpJwUg75MpPSqbOiXlNC8vvJgZMpJVhJCUzK7q2zDtOWrqsds
	toWbnM+l6ODyNpYsRDEPKvsuxJdCWThqZnIF7oDhme7c3QMgxIODy4KIs5Aqnl4EMdg6RWtrxMC
	lIcoFtxovJUfUMj9M8liJ1Y9Jd+ZrAqSrX0hn+DDJ0KkTQ4TJyR/Lgd+l02s=
X-Google-Smtp-Source: AGHT+IHgXLWIa08EKF5iBQbTPMW+F15MA8jv2gb9313joQGOaaJYJEPu1PArCNZdnFyQDIVStDqfzA==
X-Received: by 2002:a05:690c:c1a:b0:719:4421:70b2 with SMTP id 00721157ae682-71fdc2e0f12mr177717567b3.18.1756222867429;
        Tue, 26 Aug 2025 08:41:07 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-71ff6edd00fsm22874937b3.10.2025.08.26.08.41.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 08:41:06 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	kernel-team@fb.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	brauner@kernel.org,
	viro@ZenIV.linux.org.uk,
	amir73il@gmail.com
Subject: [PATCH v2 13/54] fs: hold an i_obj_count when we have an i_count reference
Date: Tue, 26 Aug 2025 11:39:13 -0400
Message-ID: <62383d1029eca5053a2fa320ae51f407c9ae2896.1756222465.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1756222464.git.josef@toxicpanda.com>
References: <cover.1756222464.git.josef@toxicpanda.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is the start of the semantic changes of inode lifetimes.
Unfortunately we have to do two things in one patch to be properly safe,
but this is the only case where this happens.

First we take and drop an i_obj_count reference every time we get an
i_count reference.  This is because we will be changing the i_count
reference to be the indicator of a "live" inode.

The second thing we do is move the life time of the memory allocation
for the inode under the control of the i_obj_count reference.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/inode.c   |  4 +++-
 fs/fs-writeback.c  |  2 --
 fs/inode.c         | 28 +++++++++-------------------
 include/linux/fs.h |  1 +
 4 files changed, 13 insertions(+), 22 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index ac00554e8479..e16df38e0eef 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3418,8 +3418,10 @@ void btrfs_add_delayed_iput(struct btrfs_inode *inode)
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	unsigned long flags;
 
-	if (atomic_add_unless(&inode->vfs_inode.i_count, -1, 1))
+	if (atomic_add_unless(&inode->vfs_inode.i_count, -1, 1)) {
+		iobj_put(&inode->vfs_inode);
 		return;
+	}
 
 	WARN_ON_ONCE(test_bit(BTRFS_FS_STATE_NO_DELAYED_IPUT, &fs_info->fs_state));
 	atomic_inc(&fs_info->nr_delayed_iputs);
diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 773b276328ec..b83d556d7ffe 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -2736,7 +2736,6 @@ static void wait_sb_inodes(struct super_block *sb)
 			continue;
 		}
 		__iget(inode);
-		iobj_get(inode);
 		spin_unlock(&inode->i_lock);
 		rcu_read_unlock();
 
@@ -2750,7 +2749,6 @@ static void wait_sb_inodes(struct super_block *sb)
 		cond_resched();
 
 		iput(inode);
-		iobj_put(inode);
 
 		rcu_read_lock();
 		spin_lock_irq(&sb->s_inode_wblist_lock);
diff --git a/fs/inode.c b/fs/inode.c
index b146b37f7097..ddaf282f7c25 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -527,6 +527,7 @@ static void init_once(void *foo)
  */
 void ihold(struct inode *inode)
 {
+	iobj_get(inode);
 	WARN_ON(atomic_inc_return(&inode->i_count) < 2);
 }
 EXPORT_SYMBOL(ihold);
@@ -843,13 +844,6 @@ static void evict(struct inode *inode)
 	 */
 	inode_wake_up_bit(inode, __I_NEW);
 	BUG_ON(inode->i_state != (I_FREEING | I_CLEAR));
-
-	/*
-	 * refcount_dec_and_test must be used here to avoid the underflow
-	 * warning.
-	 */
-	WARN_ON(!refcount_dec_and_test(&inode->i_obj_count));
-	destroy_inode(inode);
 }
 
 /*
@@ -867,16 +861,8 @@ static void dispose_list(struct list_head *head)
 		inode = list_first_entry(head, struct inode, i_lru);
 		list_del_init(&inode->i_lru);
 
-		/*
-		 * This is going right here for now only because we are
-		 * currently not using the i_obj_count reference for anything,
-		 * and it needs to hit 0 when we call evict().
-		 *
-		 * This will be moved when we change the lifetime rules in a
-		 * future patch.
-		 */
-		iobj_put(inode);
 		evict(inode);
+		iobj_put(inode);
 		cond_resched();
 	}
 }
@@ -1943,8 +1929,10 @@ void iput(struct inode *inode)
 		return;
 	BUG_ON(inode->i_state & I_CLEAR);
 
-	if (atomic_add_unless(&inode->i_count, -1, 1))
+	if (atomic_add_unless(&inode->i_count, -1, 1)) {
+		iobj_put(inode);
 		return;
+	}
 
 	if (inode->i_nlink && (inode->i_state & I_DIRTY_TIME)) {
 		trace_writeback_lazytime_iput(inode);
@@ -1958,6 +1946,7 @@ void iput(struct inode *inode)
 	} else {
 		spin_unlock(&inode->i_lock);
 	}
+	iobj_put(inode);
 }
 EXPORT_SYMBOL(iput);
 
@@ -1965,13 +1954,14 @@ EXPORT_SYMBOL(iput);
  *	iobj_put	- put a object reference on an inode
  *	@inode: inode to put
  *
- *	Puts a object reference on an inode.
+ *	Puts a object reference on an inode, free's it if we get to zero.
  */
 void iobj_put(struct inode *inode)
 {
 	if (!inode)
 		return;
-	refcount_dec(&inode->i_obj_count);
+	if (refcount_dec_and_test(&inode->i_obj_count))
+		destroy_inode(inode);
 }
 EXPORT_SYMBOL(iobj_put);
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 84f5218755c3..023ad47685be 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3381,6 +3381,7 @@ static inline unsigned int iobj_count_read(const struct inode *inode)
  */
 static inline void __iget(struct inode *inode)
 {
+	iobj_get(inode);
 	atomic_inc(&inode->i_count);
 }
 
-- 
2.49.0

