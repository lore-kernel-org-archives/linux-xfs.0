Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C90C3BB11A;
	Tue, 16 Jun 2026 14:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781618954; cv=none; b=OnQaMhIwRRTtGszbI7SBv/v1aInetDsBaxnXvCekfXWY6UQpBxuCIZLFEydDdrTS4Pp8v4pIi5ax/ksAmAUVGUOpxLLjCRu3XHZSCNz7I7EPQMIr32k2SnXap1ZaaGd2rccyiRrTuvYZ/nIQHRaJ67SJGi6KtF26ngh39OXNGXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781618954; c=relaxed/simple;
	bh=WAS9v0eXyVZhv6xmqXDDzRmVWFkX855PUkKhakPqLu4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=fsZ6PHL3ImJhW8WJ0fswC1rg11dPFFJ6o+F3SONsoQScSF4XQQnpkNFRysW2iMxWoXqNIngOBCvgZ7vb82M3wTUxyfy8JhZKKxIbUHI3+0Ye+Sx7x0gValoFi4+UlJjbrdVgVVylbDw43iH6LdnocLKhWu6Gkj3NuWo9bHGhjPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y8TQODWF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y8TQODWF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0D4E1F00A3A;
	Tue, 16 Jun 2026 14:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781618953;
	bh=XwlYHCXEjgOfBd9eMDiRNWEu85T7O7itSinaXNxPYa0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Y8TQODWF+48JAbRxowOyxKTpW1leNmA3ssR1Z0UPIJWpiv9O2uXDVTneST3naTvrM
	 4KDRzktedgORUun6XI06jlQ12vXro1Mi6YyfLphuWxwkFuOTlHoltifJNLTuN472mJ
	 KAo/ZX2JT6PSCVWmZsGmj8nuVSdGiXu4oOawkfqEN9WTnRCdpJI4HupKiXr0tbMscc
	 rff7IWjKUkLtdS7AMaOmapYbtV/kcVCQetg42wuITzOd/inL03S0L2pZJAI0tNFmB1
	 8Mfh738rihlNQsJTK3XkQpCrrVvwXyK2pwiBDEhlPG3yxJNa4Tf8d0+2k7mhDAvMVE
	 n/oDlsPW+0cmA==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 16 Jun 2026 16:08:26 +0200
Subject: [PATCH RFC v2 10/18] btrfs: open via dedicated fs bdev helpers
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260616-work-super-bdev_holder_global-v2-10-7df6b864028e@kernel.org>
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
 "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 syzbot@syzkaller.appspotmail.com
X-Mailer: b4 0.16-dev-4090c
X-Developer-Signature: v=1; a=openpgp-sha256; l=4154; i=brauner@kernel.org;
 h=from:subject:message-id; bh=WAS9v0eXyVZhv6xmqXDDzRmVWFkX855PUkKhakPqLu4=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQZRtw7OLVr6p+VW3/mZXMa7HkUX1DuszZep79hKlvAb
 OOWVxl+HaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABNRfMnw38WNaeKu6wHf/6oe
 lWMRbZyerGmwY1foFS+hPF698PlfrjH8d/4ocOz//MUl7NNfJ+38qNVecMvfcnvO0T1pS1+9jfF
 /ygcA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Route the device opens through fs_bdev_file_open_by_path() so each device
is registered against the superblock, and convert the matching releases
to fs_bdev_file_release().

The temporary identification opens that only read the superblock and
close again pass a NULL holder and keep using bdev_fput().

On the close path the superblock is taken from bdev_file->private_data
(the holder set at open) rather than device->fs_info->sb: a mount that
fails before btrfs_init_devices_late() runs leaves device->fs_info NULL,
which close_fs_devices() would otherwise dereference.

Tested-by: syzbot@syzkaller.appspotmail.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/btrfs/volumes.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 2d9e2ca09c5f..02abbfce5ea3 100644
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
@@ -1087,7 +1095,7 @@ static void __btrfs_free_extra_devids(struct btrfs_fs_devices *fs_devices,
 			continue;
 
 		if (device->bdev_file) {
-			bdev_fput(device->bdev_file);
+			fs_bdev_file_release(device->bdev_file, device->bdev_file->private_data);
 			device->bdev = NULL;
 			device->bdev_file = NULL;
 			fs_devices->open_devices--;
@@ -1127,10 +1135,12 @@ void btrfs_free_extra_devids(struct btrfs_fs_devices *fs_devices)
 /* Release a device that was made unfreezable for a membership change. */
 void btrfs_release_device_allow_freeze(struct file *bdev_file)
 {
+	struct super_block *sb = bdev_file->private_data;
+
 	/* Yield before allow (strand-safe); file still open for the allow (UAF-safe). */
 	bdev_yield_claim(bdev_file);
 	bdev_allow_freeze(file_bdev(bdev_file));
-	bdev_fput(bdev_file);
+	fs_bdev_file_release(bdev_file, sb);
 }
 
 static void btrfs_close_bdev(struct btrfs_device *device, bool allow_freeze)
@@ -1147,7 +1157,8 @@ static void btrfs_close_bdev(struct btrfs_device *device, bool allow_freeze)
 	if (allow_freeze)
 		btrfs_release_device_allow_freeze(device->bdev_file);
 	else
-		bdev_fput(device->bdev_file);
+		fs_bdev_file_release(device->bdev_file,
+				     device->bdev_file->private_data);
 }
 
 static void btrfs_close_one_device(struct btrfs_device *device)
@@ -2894,8 +2905,8 @@ struct file *btrfs_open_device_deny_freeze(const char *path,
 		return ERR_PTR(ret);
 	}
 
-	bdev_file = bdev_file_open_by_dev(file_bdev(probe_file)->bd_dev,
-					  BLK_OPEN_WRITE, sb, &fs_holder_ops);
+	bdev_file = fs_bdev_file_open_by_dev(file_bdev(probe_file)->bd_dev,
+					     BLK_OPEN_WRITE, sb, sb);
 	if (IS_ERR(bdev_file))
 		bdev_allow_freeze(file_bdev(probe_file));
 	bdev_fput(probe_file);

-- 
2.47.3

