Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D05C4657CF;
	Tue, 16 Jun 2026 14:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781618969; cv=none; b=nYUzySh1BJ377WGBHJO6wXPTEYik4PHk7F6CM3ROGNslg5EKyCzlmWsMJepbub0TCPSIDJD4XBVyosw/G3AVCvU00rsZ9o7FsTTdyTh1TfWADW4SXw9evZY3udzfB695WNVE54vJar4L/a6O8MCn7z2Uaq3hEQrMHQo8JfW7e1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781618969; c=relaxed/simple;
	bh=Z/efa63dzeSwzrgzZeku7qcS3jdFDHlu9oQwzGdroFs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=DZi7LtW/YZpbKatY5Qrvqi/id2zGE0nuFBzb0v+zuQEU74h8w5YP1g4JmZfHj78XkQQ/aElfN5jJFZbPGwazU1Y0CJ7Zkxa4jJ2doKHQw3WXibv7pJbpfDaN4c7CAea/RmoGW+WOq5Wqx3pgJCXYiOkNwdJ/4bIUk2b6jMnYnNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LnBkmJyC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LnBkmJyC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 140C71F000E9;
	Tue, 16 Jun 2026 14:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781618968;
	bh=G0U6rjaCuzJtGqVL/l9BMHO6/Q/fzl00kgN3Vn3kWUE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=LnBkmJyCuAmHtaaRaT0d15XEfPy13Lg3jk2ijzl0vNeALCtIB489c04dHESaHVijW
	 wI9UeI1OwP+DEWcnKp5ShvoPJNgs++jfkIRf85Cou2hYAKzqqcdqdMFMqJBB0Vvf6A
	 jASziwFdPMWdM+kFqfL5+7hEvTo7dLO9hc23aGmA4gXXwkxZ8MN0ezbrbSn3PgH8NE
	 lCjAiGrRwdU6EbVRsZst/N9MkicuSV3dKKkJy0WFqGxlGNlsskUpPtoCytOlquiq3M
	 hdaVnRpBCd0LQbmbOA4+LjqZFcJWBO6n2zUddC+zCTC6xk3ebZnQdZiyTmtaJGxA4V
	 Ig8FKHri4PEeg==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 16 Jun 2026 16:08:30 +0200
Subject: [PATCH RFC v2 14/18] erofs: open via dedicated fs bdev helpers
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260616-work-super-bdev_holder_global-v2-14-7df6b864028e@kernel.org>
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
 Gao Xiang <xiang@kernel.org>
X-Mailer: b4 0.16-dev-4090c
X-Developer-Signature: v=1; a=openpgp-sha256; l=4587; i=brauner@kernel.org;
 h=from:subject:message-id; bh=Z/efa63dzeSwzrgzZeku7qcS3jdFDHlu9oQwzGdroFs=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQZRtyPLuZZzbDkRlqH0fz3M77PtRG+6s8rGe180ZZj0
 tJ8hRTPjhIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIk4lzD8+F664lIrx50bNX9i
 Wae1B3kVSZ3T4/lzSvH3pcKdkhMjGBnOqW1dwvH85Svh61edQvgWflreoSa6oZjP2lT3lsjEf68
 ZAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Route opens through fs_bdev_file_open_by_path() so each external device
is registered against the correct superblock, and convert the matching
releases.

Gao Xiang: I think typical immutable filesystems don't need .shutdown()
and .remove_bdev() for the following reasons:

  - blk_mark_disk_dead() sets GD_DEAD in advance of fs_bdev_mark_dead()
    so that the following bios will fail immediately; block_device
    references are still valid so it seems overkill to handle dead
    blockdevs in the deep filesystem I/O submission path.

  - Immutable filesystems like EROFS don't have write paths and journals,
    so they don't need to block writes (i.e., new dirty pages), metadata
    changes, and abort journals.

  - The comment above loop_change_fd() documents a valid read-only use
    case we need to support anyway, but it calls disk_force_media_change()
    which will call fs_bdev_mark_dead() later: we don't want loop_change_fd()
    shutdowns the active filesystems and return -EIO unconditionally.

Currently I think the default behavior (shrink_dcache_sb + evict_inodes)
in fs_bdev_mark_dead() is enough for immutable filesystems, tried to
document in the commit here for later reference.

Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/erofs/super.c | 35 +++++++++++++++++++++++------------
 1 file changed, 23 insertions(+), 12 deletions(-)

diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index 802add6652fd..def9cbfbc9d8 100644
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

-- 
2.47.3

