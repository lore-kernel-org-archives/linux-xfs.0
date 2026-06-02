Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A1073D649C;
	Tue,  2 Jun 2026 10:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780395041; cv=none; b=OkkMnpwBjMVQUpjFrdVh0pjgi4DLNzURp6nqFVjLvpRJAi1mb9b1oR6wVu8qzaW9EA0xLqKFN0OVg/59d7dKF80Y7YVxGcrfJt5cL7zZRyk4gJEBdWHdYbAPtNJFb1xEJapHusdBx743kULnntTl7kZbe+93BH9mNc5H9c+Syt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780395041; c=relaxed/simple;
	bh=R6lYGCJCu4lkxrUCRLzgOgiNYkfZrRAWRY4AmVTHu6c=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=dpVaCpUwnsMVAhReBMvS6cc9EZU6vvE6wJj8KHVGGC5yfCqWq9dNECzcDww0QxnIN9eYjvQ2QqlV+rgmZjr8pw5Bt4WtN0B0idG+w6NmwUlKbwFgtjsq/4iONNGxHBTJHAShaor0by53hI2biwPC2WKl+VN3rDr/gGBj+mZ01Fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WQeLmDsh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WQeLmDsh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8751F1F0089E;
	Tue,  2 Jun 2026 10:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780395039;
	bh=Y8/E0TuOj6HisojXfCRnxMPnMP6DVmDM0aSEXinDBTM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=WQeLmDshDmSVqiwu4w+Ps30a/Px9tLvBr3ZxYV1T/pO05z0uG+q/nWeMSnY2qqwjR
	 gw2ssSZPIXMboT49toM2ciEyuYRlRTB1l737ZWecKj2C3FkwtQ+ugiXYQzkNKhHEnG
	 yHZiju/5+pCeXtkRIod6jSckUVYEm8wE/hB4uD43SZDn6PSQuYOMOZBncu3F5X+k3k
	 dVTbvwUtrzvvHw/9vK45zsrglaTmh1dKmYzvuoQuhz5rHKa1n9jVKh/aDr4C7lRqq6
	 lX+Yz/BnuDvINboizgtmr66rq6wr/7UqLMEq1Wmh1M4p5OeSKU1/5DXMSAkHaArDux
	 UN4P2IBbXUBAA==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 02 Jun 2026 12:10:11 +0200
Subject: [PATCH RFC 5/8] btrfs: open via dedicated fs bdev helpers
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260602-work-super-bdev_holder_global-v1-5-bb0fd82f3861@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5068; i=brauner@kernel.org;
 h=from:subject:message-id; bh=R6lYGCJCu4lkxrUCRLzgOgiNYkfZrRAWRY4AmVTHu6c=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTJreGoVd72Q36ffFai5ax5Ytve3U7h2uDTrWvJwMy03
 aVja11sRykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwESaMhgZfm/9Guscvav3GfPp
 9XnP04vnly6w2+cnd8SsfdKL85KmYQy/WeP+PNzAtjHCs67Gm7379v4r8zY/2cj85fBRM4VYfoG
 VDAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Route opens through fs_bdev_file_open_by_path() so each external device
is registered against the correct superblock, and convert the matching
releases.

The temporary identification opens that only read the superblock and close
again pass a NULL holder and are left untouched.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/btrfs/dev-replace.c |  6 +++---
 fs/btrfs/ioctl.c       |  4 ++--
 fs/btrfs/volumes.c     | 26 +++++++++++++++++---------
 3 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 8f8fa14886de..463155b0b1ff 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -247,8 +247,8 @@ static int btrfs_init_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
 		return -EINVAL;
 	}
 
-	bdev_file = bdev_file_open_by_path(device_path, BLK_OPEN_WRITE,
-					   fs_info->sb, &fs_holder_ops);
+	bdev_file = fs_bdev_file_open_by_path(device_path, BLK_OPEN_WRITE,
+					      fs_info->sb, fs_info->sb);
 	if (IS_ERR(bdev_file)) {
 		btrfs_err(fs_info, "target device %s is invalid!", device_path);
 		return PTR_ERR(bdev_file);
@@ -325,7 +325,7 @@ static int btrfs_init_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
 	return 0;
 
 error:
-	bdev_fput(bdev_file);
+	fs_bdev_file_release(bdev_file, fs_info->sb);
 	return ret;
 }
 
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index b2e447f5005c..16afa71b98f2 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2579,7 +2579,7 @@ static long btrfs_ioctl_rm_dev_v2(struct file *file, void __user *arg)
 err_drop:
 	mnt_drop_write_file(file);
 	if (bdev_file)
-		bdev_fput(bdev_file);
+		fs_bdev_file_release(bdev_file, fs_info->sb);
 out:
 	btrfs_put_dev_args_from_path(&args);
 	kfree(vol_args);
@@ -2630,7 +2630,7 @@ static long btrfs_ioctl_rm_dev(struct file *file, void __user *arg)
 
 	mnt_drop_write_file(file);
 	if (bdev_file)
-		bdev_fput(bdev_file);
+		fs_bdev_file_release(bdev_file, fs_info->sb);
 out:
 	btrfs_put_dev_args_from_path(&args);
 out_free:
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index a88e68f90564..6f7d7afb4d66 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -480,7 +480,12 @@ btrfs_get_bdev_and_sb(const char *device_path, blk_mode_t flags, void *holder,
 	struct block_device *bdev;
 	int ret;
 
-	*bdev_file = bdev_file_open_by_path(device_path, flags, holder, &fs_holder_ops);
+	if (holder)
+		*bdev_file = fs_bdev_file_open_by_path(device_path, flags,
+						       holder, holder);
+	else
+		*bdev_file = bdev_file_open_by_path(device_path, flags, NULL,
+						    NULL);
 
 	if (IS_ERR(*bdev_file)) {
 		ret = PTR_ERR(*bdev_file);
@@ -495,7 +500,7 @@ btrfs_get_bdev_and_sb(const char *device_path, blk_mode_t flags, void *holder,
 	if (holder) {
 		ret = set_blocksize(*bdev_file, BTRFS_BDEV_BLOCKSIZE);
 		if (ret) {
-			bdev_fput(*bdev_file);
+			fs_bdev_file_release(*bdev_file, holder);
 			goto error;
 		}
 	}
@@ -503,7 +508,10 @@ btrfs_get_bdev_and_sb(const char *device_path, blk_mode_t flags, void *holder,
 	*disk_super = btrfs_read_disk_super(bdev, 0, false);
 	if (IS_ERR(*disk_super)) {
 		ret = PTR_ERR(*disk_super);
-		bdev_fput(*bdev_file);
+		if (holder)
+			fs_bdev_file_release(*bdev_file, holder);
+		else
+			bdev_fput(*bdev_file);
 		goto error;
 	}
 
@@ -727,7 +735,7 @@ static int btrfs_open_one_device(struct btrfs_fs_devices *fs_devices,
 
 error_free_page:
 	btrfs_release_disk_super(disk_super);
-	bdev_fput(bdev_file);
+	fs_bdev_file_release(bdev_file, holder);
 
 	return -EINVAL;
 }
@@ -1082,7 +1090,7 @@ static void __btrfs_free_extra_devids(struct btrfs_fs_devices *fs_devices,
 			continue;
 
 		if (device->bdev_file) {
-			bdev_fput(device->bdev_file);
+			fs_bdev_file_release(device->bdev_file, fs_devices->fs_info->sb);
 			device->bdev = NULL;
 			device->bdev_file = NULL;
 			fs_devices->open_devices--;
@@ -1129,7 +1137,7 @@ static void btrfs_close_bdev(struct btrfs_device *device)
 		invalidate_bdev(device->bdev);
 	}
 
-	bdev_fput(device->bdev_file);
+	fs_bdev_file_release(device->bdev_file, device->fs_info->sb);
 }
 
 static void btrfs_close_one_device(struct btrfs_device *device)
@@ -2820,8 +2828,8 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 	if (sb_rdonly(sb) && !fs_devices->seeding)
 		return -EROFS;
 
-	bdev_file = bdev_file_open_by_path(device_path, BLK_OPEN_WRITE,
-					   fs_info->sb, &fs_holder_ops);
+	bdev_file = fs_bdev_file_open_by_path(device_path, BLK_OPEN_WRITE,
+					      fs_info->sb, fs_info->sb);
 	if (IS_ERR(bdev_file))
 		return PTR_ERR(bdev_file);
 
@@ -3045,7 +3053,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 error_free_device:
 	btrfs_free_device(device);
 error:
-	bdev_fput(bdev_file);
+	fs_bdev_file_release(bdev_file, fs_info->sb);
 	if (locked) {
 		mutex_unlock(&uuid_mutex);
 		up_write(&sb->s_umount);

-- 
2.47.3

