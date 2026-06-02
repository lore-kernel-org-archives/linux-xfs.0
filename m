Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B20233D47B2;
	Tue,  2 Jun 2026 10:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780395048; cv=none; b=XM6M5bEK8L/2pfJtDPJXe6QWSPWglQGNEBT+3nqzroFavgWzeCVhHZ6RV+A3MY91rEE5CQP/qS1QA9hRPqPPzlvnKsbYXszuIlQr5GrE+JhYTHbuk6JuWw+R1r2A2vMy027FjgVKYb11ovQ8Lh0DsW5Va2DmGnOa+pNNAaaj1Aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780395048; c=relaxed/simple;
	bh=rcHD4HbFbUrUpExn6n0CNv7K4b9hWXj4N9RjO33LQqM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=qdp2AyL9uKbKKpTADv9M7QiGl1vtaPfEXLFa2ajdc9oSmWwQkYLM4qhuK/GSdr5gXmQrcu+1tXzbFXKXDFBw2YHcLqsTDfR3dwiIbQZnQ0TrB6mVbL888DwAswTKdQkyHYMfcVcg8ffofI9THlgWR2ebL7hha2I7OcniowDOBiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AeFRVuEy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AeFRVuEy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 216A91F00893;
	Tue,  2 Jun 2026 10:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780395047;
	bh=5bBzVi4bBIK5tK2AYeV9dNHzpJuPm4TjbWGXo8xGZGo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=AeFRVuEyR0A20ZtgU5dPVf0eDw0c7XFSyhj5dtede4QGcluYMTeYtifMC5iR5XnGX
	 wHUXAPLk+87sonl7T37TwkoLvCUZhbd+gSThgOX309X9rE6TwvVadruCk76Aytlj3N
	 XPa6OOtFtvZXSWMIsWJG0wswkVofTjU6Njtcw2QXDs/57twKmM7AF/YprE14G8CHsY
	 YwKGXHThQducHnEKFUNrDWRB2wS3HC+ZvcQj7kT7ZhJAzd8+UO058UeOS2+IAcBODf
	 pvevE4L1pq85maDAfTFD9Mu4vl2NugCGFtDYmOXe2FsTxnuO2ET/UgGfjRZ4kNnUmK
	 Y3edpjJ2DBISA==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 02 Jun 2026 12:10:13 +0200
Subject: [PATCH RFC 7/8] erofs: open via dedicated fs bdev helpers
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260602-work-super-bdev_holder_global-v1-7-bb0fd82f3861@kernel.org>
References: <20260602-work-super-bdev_holder_global-v1-0-bb0fd82f3861@kernel.org>
In-Reply-To: <20260602-work-super-bdev_holder_global-v1-0-bb0fd82f3861@kernel.org>
To: Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, Carlos Maiolino <cem@kernel.org>, 
 linux-xfs@vger.kernel.org, Chris Mason <clm@fb.com>, 
 David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, 
 Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org, 
 Gao Xiang <xiang@kernel.org>, linux-erofs@lists.ozlabs.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-fffa9
X-Developer-Signature: v=1; a=openpgp-sha256; l=7744; i=brauner@kernel.org;
 h=from:subject:message-id; bh=rcHD4HbFbUrUpExn6n0CNv7K4b9hWXj4N9RjO33LQqM=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTJreHY5X4o6u+VmAbplGN/S3j3PHN4Y3E6fV/YwhOP9
 xzn0LM811HKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjCRj5MZ/pdG+t3afEJN7Iv4
 7K8VLJ5qPTwuh6dfD5swLYGjfGXyVRNGhgVzy244cyedkOOIP3gw8fjEU3XCp3+/C0wpWreUz2X
 lHhYA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Route opens through fs_bdev_file_open_by_path() so each external device
is registered against the correct superblock, and convert the matching
releases.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/erofs/data.c     |  6 +++++
 fs/erofs/internal.h | 10 ++++++++
 fs/erofs/super.c    | 66 +++++++++++++++++++++++++++++++++++++++++++----------
 fs/erofs/zdata.c    | 10 +++++---
 4 files changed, 77 insertions(+), 15 deletions(-)

diff --git a/fs/erofs/data.c b/fs/erofs/data.c
index 44da21c9d777..5220585293df 100644
--- a/fs/erofs/data.c
+++ b/fs/erofs/data.c
@@ -69,6 +69,9 @@ int erofs_init_metabuf(struct erofs_buf *buf, struct super_block *sb,
 {
 	struct erofs_sb_info *sbi = EROFS_SB(sb);
 
+	if (erofs_is_shutdown(sb))
+		return -EIO;
+
 	buf->file = NULL;
 	if (in_metabox) {
 		if (unlikely(!sbi->metabox_inode))
@@ -236,6 +239,9 @@ int erofs_map_dev(struct super_block *sb, struct erofs_map_dev *map)
 		}
 		up_read(&devs->rwsem);
 	}
+	if (erofs_is_shutdown(sb) ||
+	    (map->m_dif && READ_ONCE(map->m_dif->dead)))
+		return -EIO;
 	return 0;
 }
 
diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
index 4792490161ec..ca1ed7ce3961 100644
--- a/fs/erofs/internal.h
+++ b/fs/erofs/internal.h
@@ -48,6 +48,7 @@ struct erofs_device_info {
 
 	erofs_blk_t blocks;
 	erofs_blk_t uniaddr;
+	bool dead;		/* backing device gone; fence I/O */
 };
 
 enum {
@@ -104,6 +105,7 @@ struct erofs_xattr_prefix_item {
 struct erofs_sb_info {
 	struct erofs_device_info dif0;
 	struct erofs_mount_opts opt;	/* options */
+	unsigned long flags;		/* see EROFS_SB_* */
 #ifdef CONFIG_EROFS_FS_ZIP
 	/* list for all registered superblocks, mainly for shrinker */
 	struct list_head list;
@@ -195,6 +197,14 @@ static inline bool erofs_is_fscache_mode(struct super_block *sb)
 			!erofs_is_fileio_mode(EROFS_SB(sb)) && !sb->s_bdev;
 }
 
+/* erofs_sb_info->flags */
+#define EROFS_SB_SHUTDOWN	0	/* primary device gone; fail all I/O */
+
+static inline bool erofs_is_shutdown(struct super_block *sb)
+{
+	return test_bit(EROFS_SB_SHUTDOWN, &EROFS_SB(sb)->flags);
+}
+
 enum {
 	EROFS_ZIP_CACHE_DISABLED,
 	EROFS_ZIP_CACHE_READAHEAD,
diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index 802add6652fd..e03cb95be96b 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -153,8 +153,8 @@ static int erofs_init_device(struct erofs_buf *buf, struct super_block *sb,
 	} else if (!sbi->devs->flatdev) {
 		file = erofs_is_fileio_mode(sbi) ?
 				filp_open(dif->path, O_RDONLY | O_LARGEFILE, 0) :
-				bdev_file_open_by_path(dif->path,
-						BLK_OPEN_READ, sb->s_type, NULL);
+				fs_bdev_file_open_by_path(dif->path,
+						BLK_OPEN_READ, sb->s_type, sb);
 		if (IS_ERR(file)) {
 			if (file == ERR_PTR(-ENOTBLK))
 				return -EINVAL;
@@ -843,11 +843,16 @@ static int erofs_fc_reconfigure(struct fs_context *fc)
 
 static int erofs_release_device_info(int id, void *ptr, void *data)
 {
+	struct super_block *sb = data;
 	struct erofs_device_info *dif = ptr;
 
 	fs_put_dax(dif->dax_dev, NULL);
-	if (dif->file)
-		fput(dif->file);
+	if (dif->file) {
+		if (S_ISBLK(file_inode(dif->file)->i_mode))
+			fs_bdev_file_release(dif->file, sb);
+		else
+			fput(dif->file);
+	}
 	erofs_fscache_unregister_cookie(dif->fscache);
 	dif->fscache = NULL;
 	kfree(dif->path);
@@ -855,18 +860,19 @@ static int erofs_release_device_info(int id, void *ptr, void *data)
 	return 0;
 }
 
-static void erofs_free_dev_context(struct erofs_dev_context *devs)
+static void erofs_free_dev_context(struct erofs_dev_context *devs,
+				   struct super_block *sb)
 {
 	if (!devs)
 		return;
-	idr_for_each(&devs->tree, &erofs_release_device_info, NULL);
+	idr_for_each(&devs->tree, &erofs_release_device_info, sb);
 	idr_destroy(&devs->tree);
 	kfree(devs);
 }
 
-static void erofs_sb_free(struct erofs_sb_info *sbi)
+static void erofs_sb_free(struct erofs_sb_info *sbi, struct super_block *sb)
 {
-	erofs_free_dev_context(sbi->devs);
+	erofs_free_dev_context(sbi->devs, sb);
 	kfree(sbi->fsid);
 	kfree_sensitive(sbi->domain_id);
 	if (sbi->dif0.file)
@@ -879,8 +885,13 @@ static void erofs_fc_free(struct fs_context *fc)
 {
 	struct erofs_sb_info *sbi = fc->s_fs_info;
 
-	if (sbi) /* free here if an error occurs before transferring to sb */
-		erofs_sb_free(sbi);
+	/*
+	 * Freed here only if an error occurs before the sb is set up; at that
+	 * point no block-backed device has been claimed (that happens in
+	 * fill_super), so the NULL sb never reaches fs_bdev_file_release().
+	 */
+	if (sbi)
+		erofs_sb_free(sbi, NULL);
 }
 
 static const struct fs_context_operations erofs_context_ops = {
@@ -936,7 +947,7 @@ static void erofs_kill_sb(struct super_block *sb)
 	erofs_drop_internal_inodes(sbi);
 	fs_put_dax(sbi->dif0.dax_dev, NULL);
 	erofs_fscache_unregister_fs(sb);
-	erofs_sb_free(sbi);
+	erofs_sb_free(sbi, sb);
 	sb->s_fs_info = NULL;
 }
 
@@ -948,7 +959,7 @@ static void erofs_put_super(struct super_block *sb)
 	erofs_shrinker_unregister(sb);
 	erofs_xattr_prefixes_cleanup(sb);
 	erofs_drop_internal_inodes(sbi);
-	erofs_free_dev_context(sbi->devs);
+	erofs_free_dev_context(sbi->devs, sb);
 	sbi->devs = NULL;
 	erofs_fscache_unregister_fs(sb);
 }
@@ -1121,6 +1132,35 @@ static void erofs_evict_inode(struct inode *inode)
 	clear_inode(inode);
 }
 
+/*
+ * A blob device may back several erofs superblocks; fence only the affected
+ * one and keep the rest of the mount alive.  The primary device falls back to
+ * the generic teardown (return non-zero).
+ */
+static int erofs_remove_bdev(struct super_block *sb, struct block_device *bdev)
+{
+	struct erofs_dev_context *devs = EROFS_SB(sb)->devs;
+	struct erofs_device_info *dif;
+	int id;
+
+	if (bdev == sb->s_bdev)
+		return 1;
+
+	down_read(&devs->rwsem);
+	idr_for_each_entry(&devs->tree, dif, id) {
+		if (dif->file && S_ISBLK(file_inode(dif->file)->i_mode) &&
+		    file_bdev(dif->file)->bd_dev == bdev->bd_dev)
+			WRITE_ONCE(dif->dead, true);
+	}
+	up_read(&devs->rwsem);
+	return 0;
+}
+
+static void erofs_shutdown(struct super_block *sb)
+{
+	set_bit(EROFS_SB_SHUTDOWN, &EROFS_SB(sb)->flags);
+}
+
 const struct super_operations erofs_sops = {
 	.put_super = erofs_put_super,
 	.alloc_inode = erofs_alloc_inode,
@@ -1128,6 +1168,8 @@ const struct super_operations erofs_sops = {
 	.evict_inode = erofs_evict_inode,
 	.statfs = erofs_statfs,
 	.show_options = erofs_show_options,
+	.remove_bdev = erofs_remove_bdev,
+	.shutdown = erofs_shutdown,
 };
 
 module_init(erofs_module_init);
diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index 43bb5a6a9924..89ae91935364 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -1697,11 +1697,15 @@ static void z_erofs_submit_queue(struct z_erofs_frontend *f,
 			continue;
 		}
 
-		/* no device id here, thus it will always succeed */
 		mdev = (struct erofs_map_dev) {
 			.m_pa = round_down(pcl->pos, sb->s_blocksize),
 		};
-		(void)erofs_map_dev(sb, &mdev);
+		if (erofs_map_dev(sb, &mdev)) {
+			/* the backing device is gone; fail the batch */
+			q[JQ_SUBMIT]->eio = true;
+			qtail[JQ_SUBMIT] = &pcl->next;
+			continue;
+		}
 
 		cur = mdev.m_pa;
 		end = round_up(cur + pcl->pageofs_in + pcl->pclustersize,
@@ -1785,7 +1789,7 @@ static void z_erofs_submit_queue(struct z_erofs_frontend *f,
 	 * although background is preferred, no one is pending for submission.
 	 * don't issue decompression but drop it directly instead.
 	 */
-	if (!*force_fg && !nr_bios) {
+	if (!*force_fg && !nr_bios && !q[JQ_SUBMIT]->eio) {
 		kvfree(q[JQ_SUBMIT]);
 		return;
 	}

-- 
2.47.3

