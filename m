Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com [209.85.219.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E3C438B66C
	for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 20:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755807635; cv=none; b=QL6Nk834t1fb8/tdgFh/s9QAFCXjoqYvPDl4ufY8lTAIXTZ8sZeZ6Faq+hBrBJ8owWUI5wFm3gBKDS3M27JSTNYStJZ4+zjedjql2pwpBOyRy5vMkFfFLZi0K+KbR2oGXJhe5u3Ha8mpgBTUvBTxuj4aBVnK8biL3rblwtf9ipI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755807635; c=relaxed/simple;
	bh=k08C8v+dbri2Td95rFSblahs5058v4x4Pk8rcv0fBIU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iw2SobEIOWSRU5zLHn0O9xHAP1/tyDlvyb6vLi1EZO6uYLOZC304mPUH4xU2MJCvLxf0Z9PL7ojJYts+qzSKDqrELoirlI2uVb6NVUQkXkRnydBKy5IuIiVx4U+w1+/EiL7lECJTKrBJydZtJ+S2tlhyPm4jWfeLCeQapbTg8GE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=mQ1e+6TL; arc=none smtp.client-ip=209.85.219.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="mQ1e+6TL"
Received: by mail-yb1-f171.google.com with SMTP id 3f1490d57ef6-e94f573e4f5so1149787276.2
        for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 13:20:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1755807632; x=1756412432; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+1kpIKHN/ijHuvWafJ0jJ7li2TFJSTYw3gzfhNZtJgk=;
        b=mQ1e+6TLE7QVd89PjmHqFK+sa8azvf4fGwngHCjwbUGrQIyZ18C7n9JlQWSKPUipp7
         OreE26cEjc++5/SoaDO+nzUxDVodQE1uzWOgbowA1/NzKN3cnQH0JEahXSgeCFsBmsDi
         XEvzfgsaJN8IuCnbyTGSZfcOPQ+uyQnceu4uXa9DK5NtvZDSpMa6qakDI6fsNgUzC9gp
         OgAjg94TL1qa8uUREv/cpmNOOzVgV9NDBU7r+rpLQt609LRD+z9NBWRQLNlHbnMo4/cj
         NWnb9OgL/AAZEeTNB7x919t7+Hos8Zk2xgyUXpsKC27X8u4MFjgUXkE1jvKUa18RAoZN
         aXUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755807632; x=1756412432;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+1kpIKHN/ijHuvWafJ0jJ7li2TFJSTYw3gzfhNZtJgk=;
        b=K0+6/2KW3z2SG8fLa89V2kAZD4EZuALXOve3O1/SkucqkcMu1DE+eGSPLxVdLchYYw
         7hPgkf8w0Uv8VCAPYOPBJLdTvHODF4wODrfP9gYRyuFWayRz9dPsJVrN0qJrWNDekOLe
         DDGxADY4fJLJMU7tX9ZFE92hY+73mXGVUybe7TKu97q2TWtI2kSz+h/Q+/4DFiIv0W7h
         fF8WP4uFvgAJ6V8GfhFEV8zCZByTeSUKG1iWfwLAplDESgvnsFWNkvreUvbj/caYdV5Q
         sKMVB10VXk9NnPp5f0r1K9A/XAl27BQKXeaDuL8f+Yetbze/yRU5hH3mxUuEQa7EBTJ6
         Cr1Q==
X-Forwarded-Encrypted: i=1; AJvYcCXrNK1r5pF3tdAVDEijDKOYarE4Ln4/nn76kEUnubuq0bu1TJDhS4Y97dXybjw7xcqXxzDTZ8hglvk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxms8lIYdiUa2m4Riw/RrVpnSN4HdxnFSv9XBI++AM9Poatcx4J
	AxqCov5t9Uq02FoSzYSJxrEIbGqjPFrSv0MUd114UP1747BP09DVkldvBbRcFZhx9MI=
X-Gm-Gg: ASbGncvmKmX7ORZdXScRo+JB4jnlk6yuH+dDQCpxAN9F9z965X+OqoT+7Ka/GU530fj
	D1LfgwLNLQd6vWSOWkgYYnaU6LBkgG6MLap+FAmDrOmCG3a70FbMahz3eOv82fntyeYKSpiGj8X
	3ZOx6FKwISI68VdSqk5SVEBZPpPutTMnfHQ1e/8wFd6ow7yyilURQMBX2JxGqgmXqdwODBSwjcs
	cB6/B4LA5KZ/4KR/nzk/RrNWDiZMWQNORT1bYbk/1R+8hCNbV4adjc47/OEA5bPqU/JSzakmKPP
	DlM/xncWw/egptvD76usEkgFw+5nYc2DujEKjdGLiYuFsTGdZa/FZ+cqj7UGuxIID+yLoZFA/+W
	X8j8rEC5G1XCg1QFt/rt2thBiElkgCEsIof1GyaJe5xh6UVuzZNkRmm/GZKfELpnOcf9SIA==
X-Google-Smtp-Source: AGHT+IHUz11rC+SEDiUMFpURAl6bZ0Q/kqeBOcps7ePJ17GgLV0wAujubaZOcSSL45YNyD4XEPUBLQ==
X-Received: by 2002:a05:6902:3309:b0:e91:7c31:f70f with SMTP id 3f1490d57ef6-e951c32c9b3mr867244276.29.1755807631868;
        Thu, 21 Aug 2025 13:20:31 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e94df639cbbsm3261267276.36.2025.08.21.13.20.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Aug 2025 13:20:31 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	kernel-team@fb.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	brauner@kernel.org,
	viro@ZenIV.linux.org.uk
Subject: [PATCH 11/50] fs: hold an i_obj_count when we have an i_count reference
Date: Thu, 21 Aug 2025 16:18:22 -0400
Message-ID: <af798c04abfb7e25ced350a451bd80c031fc11a6.1755806649.git.josef@toxicpanda.com>
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
 fs/inode.c         | 29 +++++++++++------------------
 include/linux/fs.h |  1 +
 4 files changed, 15 insertions(+), 21 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 784bd48b4da9..bbbcd96e8f5c 100644
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
index 2b0d26a58a5a..d2e1fb1a0787 100644
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
index 12e2e01aae0c..16acad5583fc 100644
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
@@ -1945,6 +1931,11 @@ void iput(struct inode *inode)
 retry:
 	if (atomic_dec_and_lock(&inode->i_count, &inode->i_lock)) {
 		if (inode->i_nlink && (inode->i_state & I_DIRTY_TIME)) {
+			/*
+			 * Increment i_count directly as we still have our
+			 * i_obj_count reference still. This is temporary and
+			 * will go away in a future patch.
+			 */
 			atomic_inc(&inode->i_count);
 			spin_unlock(&inode->i_lock);
 			trace_writeback_lazytime_iput(inode);
@@ -1953,6 +1944,7 @@ void iput(struct inode *inode)
 		}
 		iput_final(inode);
 	}
+	iobj_put(inode);
 }
 EXPORT_SYMBOL(iput);
 
@@ -1960,13 +1952,14 @@ EXPORT_SYMBOL(iput);
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
index e741dc453c2c..b2048fd9c300 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3381,6 +3381,7 @@ static inline void iobj_get(struct inode *inode)
  */
 static inline void __iget(struct inode *inode)
 {
+	iobj_get(inode);
 	atomic_inc(&inode->i_count);
 }
 
-- 
2.49.0

