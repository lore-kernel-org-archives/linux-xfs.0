Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D26C436403D;
	Tue, 16 Jun 2026 14:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781618928; cv=none; b=LTikJtLJIIVxwIMTNXQ8kUTiHnpepiTttDJCF8VV+4M5QFEuSVuVqwzt9+NfH9Xl9EdVJW8R3HQ8iuVHkl0NqtvDcTv5jcGJ+RDd4DaxamNNhaGuXAbvS/JytxkL42MLO/KGUnDL4W897qAYoyi183Cv/42x5sFMJqSugTWHbbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781618928; c=relaxed/simple;
	bh=KF0v8pHPVEotJs4Vm14KV+E8jIKihwjzaTF127NKnwI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=owQJivB3xKZmZv8pFWHtBxoOQgVfW+PAGwfWj6Tb3oK1ukSnP+DjfPnHBPcGiIGE4t5P5xfr6y+k0reG4jPdg5GlRM1DDvfDc6Q8Kn/yJ/zFaBEgcZLvUgivuxyDikd4nmJWTJWpCFCdzMUQW51dhhHd0/zDLie5SLHPNVVvbZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M5Ulyvr3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M5Ulyvr3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A6791F00AC4;
	Tue, 16 Jun 2026 14:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781618926;
	bh=WjwR9vH2WMcKI4lWeyLWZRoEHjyG3qd8eI9XdYYTssg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=M5Ulyvr3daRP5zh6cUjMPi43jyuPuURwEOEBaRzTHiwelTGy8K2bTfBE0TK6fY9J1
	 oWddHvGy4bkAg7UgN1bR3hLuGNEg8zCMs1zz+jZ6n/jZkEBScIyvoJMBqPd8557EfY
	 67hi6jiK8fRG72FT6OYFCApiEkJi2NfI28GNq0VPn2rD6mQhb4OFIhyZ7zEhSjm3m9
	 HTVjEJySwhBKTqrABFIE6IB1LpP92V3mvf/OF0OvzaZdoTgk5EDhYw6LQoqCWSCL+I
	 JQYEz+RJt0819L4/hDh3W3sSg9nWrg9l9hp6xaF4ad5qRgCKBL1KWYF7DkyROTuV67
	 s6ueMsJwUVBYA==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 16 Jun 2026 16:08:19 +0200
Subject: [PATCH RFC v2 03/18] super: take lock after last reference count
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260616-work-super-bdev_holder_global-v2-3-7df6b864028e@kernel.org>
References: <20260616-work-super-bdev_holder_global-v2-0-7df6b864028e@kernel.org>
In-Reply-To: <20260616-work-super-bdev_holder_global-v2-0-7df6b864028e@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, linux-block@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, 
 Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
 linux-btrfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, 
 linux-ext4@vger.kernel.org, Gao Xiang <xiang@kernel.org>, 
 linux-erofs@lists.ozlabs.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-4090c
X-Developer-Signature: v=1; a=openpgp-sha256; l=4988; i=brauner@kernel.org;
 h=from:subject:message-id; bh=KF0v8pHPVEotJs4Vm14KV+E8jIKihwjzaTF127NKnwI=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQZRtw7Jz+vQe2eqESxmfqUV2y+rd/CI/wftyRMiHNf9
 1ttUWhjRwkLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwES4pBm+F0awyQaUuy171exY
 n2I2z+xP49fS6+Z+GYV5hl+5Hh1m+F9vYrSkxc9+ySQv0YM1a4zTj1rHnxQNfcY7o3eJlo+JCBs A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

__put_super() required the caller to hold sb_lock, so put_super()
wrapped it. The per-device superblock table introduced later drops its
passive references from contexts that do not hold sb_lock, so make
put_super() self-locking: drop the count first and take sb_lock only for
the final list_del.

With the count now dropped outside sb_lock a superblock can briefly sit
on @super_blocks with s_passive == 0 before it is unlinked, so the list
walkers (__iterate_supers(), iterate_supers_type(), user_get_super())
switch to refcount_inc_not_zero() and skip it.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/super.c | 63 ++++++++++++++++++++++++++++----------------------------------
 1 file changed, 28 insertions(+), 35 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 25dd72b550e0..a771a0ad4c9a 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -403,12 +403,17 @@ static struct super_block *alloc_super(struct file_system_type *type, int flags,
 /* Superblock refcounting  */
 
 /*
- * Drop a superblock's refcount.  The caller must hold sb_lock.
+ * Drop a superblock's passive reference.  Must be called WITHOUT sb_lock held;
+ * put_super() acquires sb_lock itself when the final reference is dropped.
  */
-static void __put_super(struct super_block *s)
+void put_super(struct super_block *s)
 {
 	if (refcount_dec_and_test(&s->s_passive)) {
+
+		spin_lock(&sb_lock);
 		list_del_init(&s->s_list);
+		spin_unlock(&sb_lock);
+
 		WARN_ON(s->s_dentry_lru.node);
 		WARN_ON(s->s_inode_lru.node);
 		WARN_ON(s->s_mounts);
@@ -416,20 +421,6 @@ static void __put_super(struct super_block *s)
 	}
 }
 
-/**
- *	put_super	-	drop a temporary reference to superblock
- *	@sb: superblock in question
- *
- *	Drops a temporary reference, frees superblock if there's no
- *	references left.
- */
-void put_super(struct super_block *sb)
-{
-	spin_lock(&sb_lock);
-	__put_super(sb);
-	spin_unlock(&sb_lock);
-}
-
 static void kill_super_notify(struct super_block *sb)
 {
 	lockdep_assert_not_held(&sb->s_umount);
@@ -478,11 +469,7 @@ void deactivate_locked_super(struct super_block *s)
 
 		kill_super_notify(s);
 
-		/*
-		 * Since list_lru_destroy() may sleep, we cannot call it from
-		 * put_super(), where we hold the sb_lock. Therefore we destroy
-		 * the lru lists right now.
-		 */
+		/* list_lru_destroy() may sleep; put_super() callers may not. */
 		list_lru_destroy(&s->s_dentry_lru);
 		list_lru_destroy(&s->s_inode_lru);
 
@@ -851,14 +838,17 @@ static void __iterate_supers(void (*f)(struct super_block *, void *), void *arg,
 	struct super_block *sb, *p = NULL;
 	bool excl = flags & SUPER_ITER_EXCL;
 
-	guard(spinlock)(&sb_lock);
+	spin_lock(&sb_lock);
 
 	for (sb = first_super(flags);
 	     !list_entry_is_head(sb, &super_blocks, s_list);
 	     sb = next_super(sb, flags)) {
 		if (super_flags(sb, SB_DYING))
 			continue;
-		refcount_inc(&sb->s_passive);
+
+		if (!refcount_inc_not_zero(&sb->s_passive))
+			continue;
+
 		spin_unlock(&sb_lock);
 
 		if (flags & SUPER_ITER_UNLOCKED) {
@@ -868,13 +858,14 @@ static void __iterate_supers(void (*f)(struct super_block *, void *), void *arg,
 			super_unlock(sb, excl);
 		}
 
-		spin_lock(&sb_lock);
 		if (p)
-			__put_super(p);
+			put_super(p);
 		p = sb;
+		spin_lock(&sb_lock);
 	}
+	spin_unlock(&sb_lock);
 	if (p)
-		__put_super(p);
+		put_super(p);
 }
 
 void iterate_supers(void (*f)(struct super_block *, void *), void *arg)
@@ -903,7 +894,9 @@ void iterate_supers_type(struct file_system_type *type,
 		if (super_flags(sb, SB_DYING))
 			continue;
 
-		refcount_inc(&sb->s_passive);
+		if (!refcount_inc_not_zero(&sb->s_passive))
+			continue;
+
 		spin_unlock(&sb_lock);
 
 		locked = super_lock_shared(sb);
@@ -912,14 +905,14 @@ void iterate_supers_type(struct file_system_type *type,
 			super_unlock_shared(sb);
 		}
 
-		spin_lock(&sb_lock);
 		if (p)
-			__put_super(p);
+			put_super(p);
 		p = sb;
+		spin_lock(&sb_lock);
 	}
-	if (p)
-		__put_super(p);
 	spin_unlock(&sb_lock);
+	if (p)
+		put_super(p);
 }
 
 EXPORT_SYMBOL(iterate_supers_type);
@@ -935,15 +928,17 @@ struct super_block *user_get_super(dev_t dev, bool excl)
 		if (sb->s_dev != dev)
 			continue;
 
-		refcount_inc(&sb->s_passive);
+		if (!refcount_inc_not_zero(&sb->s_passive))
+			continue;
+
 		spin_unlock(&sb_lock);
 
 		locked = super_lock(sb, excl);
 		if (locked)
 			return sb;
 
+		put_super(sb);
 		spin_lock(&sb_lock);
-		__put_super(sb);
 		break;
 	}
 	spin_unlock(&sb_lock);
@@ -1368,9 +1363,7 @@ static struct super_block *bdev_super_lock(struct block_device *bdev, bool excl)
 	lockdep_assert_not_held(&bdev->bd_disk->open_mutex);
 
 	/* Make sure sb doesn't go away from under us */
-	spin_lock(&sb_lock);
 	refcount_inc(&sb->s_passive);
-	spin_unlock(&sb_lock);
 
 	mutex_unlock(&bdev->bd_holder_lock);
 

-- 
2.47.3

