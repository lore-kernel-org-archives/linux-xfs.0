Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E41636E46C;
	Tue, 16 Jun 2026 14:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781618931; cv=none; b=Z8e22KfXbwLSqRl39xgHopz24sZVhpxDi5dDgjfK46NNG4hfRPttwdGMp61nn+bIY0uCA67FVSlMyEkuu8gJnv6Eg4aX8NntbETOvF+KI62SN7ynaVh22H3u+Ts7VMIDBJPChT5djqkFm8U9g8kAMg1EsojrKL4Zjipw3PfMMsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781618931; c=relaxed/simple;
	bh=y54UXAJRPaUH3JPt09MKqM3AXvuTz0c3R1gVHeRUQ3I=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Us/Jz9jK+63IPsCklX1o14/qCbB8SmwGq4RGHFLAupEyyExW6NUPpmWhYa7K+51ifuENJ8//PvAOVi3RzDr002JHF91B6agS4IHM4czrBVkbgK2/PYn8+vUCX0naPLrfMnyZgUD1tKU/PsI3HsVCr3OgJ58k5k2VmzodHt4urxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=STD2m7/1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="STD2m7/1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B93C1F000E9;
	Tue, 16 Jun 2026 14:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781618922;
	bh=BDwvgPs41b9NomLfrf+TZ2/uwsHPCsvN55JM7hxVyiE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=STD2m7/1c8lDu75kKhiuRlo1RmsBXm4p17Ot3rye3G5/Dju7RyT42Vk98jczhmP9z
	 pSXy32SnuoVMmFW22GQlnSzHN+SZmVpxtm9rnTnd8q2l4D12/xzZZZPo1ab0kF2NhB
	 R+RmwVHOWT3UXlzp+m7RT2RyM0j/hu4nk++gx22L1cXR+VdYBZl4wFhUd65+vkTJm/
	 c77GwnVi0uE84XN0JD9Pd0km7DUDlYs1Mk0yZPm9XqB/hevSsKL2bi9LLqdWRn1/gP
	 Phxj7/7zUodIOYoZgtW2psNux1EIjp/S3n4Cn8QaKy4cURQhXoSL2UmlF6RLRuAyPi
	 /c57jWaPBj6Dw==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 16 Jun 2026 16:08:18 +0200
Subject: [PATCH RFC v2 02/18] super: convert s_count to refcount_t
 s_passive
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260616-work-super-bdev_holder_global-v2-2-7df6b864028e@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4567; i=brauner@kernel.org;
 h=from:subject:message-id; bh=y54UXAJRPaUH3JPt09MKqM3AXvuTz0c3R1gVHeRUQ3I=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQZRtzbu6L88yErjpcyu+yyM06eKZGvXtfXuyklteNt0
 ELLT+e8O0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACZy5yrDLyYXzyU9r05a/gxW
 eSi0ueSC65yY7ae//AxWSrdrkbW8z8/wPyJ8l+K+H6YGc4sLr5tJ3NjnHvnZ6472iXMFXurSKx5
 c5QcA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

The superblock carries two counters: s_active, the active reference
count that keeps the filesystem usable, and s_count, the passive
reference count that merely keeps the structure itself alive. Turn the
passive count into a refcount_t and rename it to s_passive to make the
pairing with s_active obvious.

Everything is still serialized by sb_lock, so there is no functional
change; the conversion buys the usual refcount_t saturation and
underflow checking. The following patches start dropping passive
references without holding sb_lock and make the device-to-superblock
table hold one passive reference per registered entry, which a plain
integer cannot support.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/super.c                     | 18 +++++++++---------
 include/linux/fs/super_types.h |  2 +-
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index a8fd61136aaf..25dd72b550e0 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -102,7 +102,7 @@ static bool super_flags(const struct super_block *sb, unsigned int flags)
  * creation will succeed and SB_BORN is set by vfs_get_tree() or we're
  * woken and we'll see SB_DYING.
  *
- * The caller must have acquired a temporary reference on @sb->s_count.
+ * The caller must have acquired a temporary reference on @sb->s_passive.
  *
  * Return: The function returns true if SB_BORN was set and with
  *         s_umount held. The function returns false if SB_DYING was
@@ -367,7 +367,7 @@ static struct super_block *alloc_super(struct file_system_type *type, int flags,
 	spin_lock_init(&s->s_inode_wblist_lock);
 	fserror_mount(s);
 
-	s->s_count = 1;
+	refcount_set(&s->s_passive, 1);
 	atomic_set(&s->s_active, 1);
 	mutex_init(&s->s_vfs_rename_mutex);
 	lockdep_set_class(&s->s_vfs_rename_mutex, &type->s_vfs_rename_key);
@@ -407,7 +407,7 @@ static struct super_block *alloc_super(struct file_system_type *type, int flags,
  */
 static void __put_super(struct super_block *s)
 {
-	if (!--s->s_count) {
+	if (refcount_dec_and_test(&s->s_passive)) {
 		list_del_init(&s->s_list);
 		WARN_ON(s->s_dentry_lru.node);
 		WARN_ON(s->s_inode_lru.node);
@@ -529,7 +529,7 @@ static bool grab_super(struct super_block *sb)
 {
 	bool locked;
 
-	sb->s_count++;
+	refcount_inc(&sb->s_passive);
 	spin_unlock(&sb_lock);
 	locked = super_lock_excl(sb);
 	if (locked) {
@@ -556,7 +556,7 @@ static bool grab_super(struct super_block *sb)
  *	lock held in read mode in case of success. On successful return,
  *	the caller must drop the s_umount lock when done.
  *
- *	Note that unlike get_super() et.al. this one does *not* bump ->s_count.
+ *	Note that unlike get_super() et.al. this one does *not* bump ->s_passive.
  *	The reason why it's safe is that we are OK with doing trylock instead
  *	of down_read().  There's a couple of places that are OK with that, but
  *	it's very much not a general-purpose interface.
@@ -858,7 +858,7 @@ static void __iterate_supers(void (*f)(struct super_block *, void *), void *arg,
 	     sb = next_super(sb, flags)) {
 		if (super_flags(sb, SB_DYING))
 			continue;
-		sb->s_count++;
+		refcount_inc(&sb->s_passive);
 		spin_unlock(&sb_lock);
 
 		if (flags & SUPER_ITER_UNLOCKED) {
@@ -903,7 +903,7 @@ void iterate_supers_type(struct file_system_type *type,
 		if (super_flags(sb, SB_DYING))
 			continue;
 
-		sb->s_count++;
+		refcount_inc(&sb->s_passive);
 		spin_unlock(&sb_lock);
 
 		locked = super_lock_shared(sb);
@@ -935,7 +935,7 @@ struct super_block *user_get_super(dev_t dev, bool excl)
 		if (sb->s_dev != dev)
 			continue;
 
-		sb->s_count++;
+		refcount_inc(&sb->s_passive);
 		spin_unlock(&sb_lock);
 
 		locked = super_lock(sb, excl);
@@ -1369,7 +1369,7 @@ static struct super_block *bdev_super_lock(struct block_device *bdev, bool excl)
 
 	/* Make sure sb doesn't go away from under us */
 	spin_lock(&sb_lock);
-	sb->s_count++;
+	refcount_inc(&sb->s_passive);
 	spin_unlock(&sb_lock);
 
 	mutex_unlock(&bdev->bd_holder_lock);
diff --git a/include/linux/fs/super_types.h b/include/linux/fs/super_types.h
index ef7941e9dc79..68747182abf9 100644
--- a/include/linux/fs/super_types.h
+++ b/include/linux/fs/super_types.h
@@ -145,7 +145,7 @@ struct super_block {
 	unsigned long				s_magic;
 	struct dentry				*s_root;
 	struct rw_semaphore			s_umount;
-	int					s_count;
+	refcount_t				s_passive;
 	atomic_t				s_active;
 #ifdef CONFIG_SECURITY
 	void					*s_security;

-- 
2.47.3

