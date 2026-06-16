Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B07B34534A7;
	Tue, 16 Jun 2026 14:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781618965; cv=none; b=qOqC7g3KQqH56aH8lWFUr6zR8z+vQAxk7z3AsV5CuxlepgcZQWD3APDl/ZE+af1VWZR31Fpgd8LEnYxAkxmXC4JXbkbZLThrqQNEmxV+h4NwW27SSZIz92jQd/URWW5xMc1iBk8c2FkWUncR1iTbxWNXV3Sqga0Ow3VoiMJc4CI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781618965; c=relaxed/simple;
	bh=fe1mfAo4ng9tx0MNylpx9ggBk5p6FEGdbQMCTGJTVlU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=kWnuMDcJVK0oyo69CV1Fpvh65YgtQivQLMChYcYngr0jdrriCenJVaskifd8YqrKgy4eOd2bW27rUgDxBGmTTG/0PwZGdEULFIg4A+L4HjYMlbpHpyK32/4TqHdJpi5OCdZW7zq6wdpuq2il4jxN3iwPOj0i5hNKNRGBtbUNjFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fCur5czk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fCur5czk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17F451F00A3A;
	Tue, 16 Jun 2026 14:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781618964;
	bh=TAVWBMn/0AgwgnXw81P+LkKKHh8ejKGFmQpo5ju/AbA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=fCur5czkdS8GxjwXheJ4YcLF8SzC0Fe2x28Ag2om3TK1ymVVaIUggeDoUhhGmcsSB
	 oIHLRM+5XS3IiI/6HCufOvnTnkGUglCX1E3rgy9H9e670/tp2nsEZ/nVjttF7+yuBc
	 sfrF4Kv5XIoCj/hnh6b+3IiY3/jdWfE9vFJl3siQ6HB+6JRhAsiPfn0rdqYnbVTQDo
	 ekEOHBvPncIT+FzUVizMJ/zqAikfr3JmnbP1o+VUN5M/aqIq5O6l2mAp7mV/MiXv6L
	 CZ+JdO01TA+dHlOEC1DLea1pGMslfrOkPA0yQeF1o3YRtnxdfUlFhbyTbEeD8Y//0V
	 +aWnNO/RvaZ3Q==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 16 Jun 2026 16:08:29 +0200
Subject: [PATCH RFC v2 13/18] fs: tolerate per-superblock freeze errors on
 shared devices
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260616-work-super-bdev_holder_global-v2-13-7df6b864028e@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3209; i=brauner@kernel.org;
 h=from:subject:message-id; bh=fe1mfAo4ng9tx0MNylpx9ggBk5p6FEGdbQMCTGJTVlU=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQZRtznFz6nuNvDtXTpC6NXkSFffb1fNseH3me7rbX/9
 87D/z+u6ihlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZjIBzOG/+49OsFT5qUILnD0
 NiiaxK6dPOnFO913jco3jZT4xBdck2L4w/99TdwOH1/NEzot97cxczffnBdsXKsb12YgUfbi8TE
 3FgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

When several superblocks share a device, keep it frozen even if some of
them failed to freeze and swallow the error: rolling the others back
via thaw_super() can fail too, so neither is a clear win. A single
filesystem still reports its error, and a sync_blockdev() failure is
always reported. Thaw follows the same rule.

A device can only be shared once superblocks claim it with a common
exclusivity token, which erofs starts doing in the next patch; for
everyone else the loop visits exactly one superblock and the behavior
is unchanged.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/super.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 236e868209a4..a83f58755cf8 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -1548,13 +1548,15 @@ static void fs_bdev_sync(struct block_device *bdev)
  * devices is frozen once per device and stays frozen until all are thawed; the
  * block layer nests these freezes so the count stays balanced.
  *
- * Return: 0, or the first error from freezing a superblock or syncing the
- *         block device.
+ * Return: 0, or the error from the one superblock on a single-fs device.  When
+ *         several superblocks share @bdev a per-superblock failure is swallowed
+ *         (see below), but a sync_blockdev() failure is always reported.
  */
 static int fs_bdev_freeze(struct block_device *bdev)
 {
 	dev_t dev = bdev->bd_dev;
 	struct super_dev *sb_dev;
+	unsigned int count = 0;
 	int error = 0, err;
 
 	lockdep_assert_held(&bdev->bd_fsfreeze_mutex);
@@ -1568,8 +1570,17 @@ static int fs_bdev_freeze(struct block_device *bdev)
 		if (err && !error)
 			error = err;
 		deactivate_super(sb_dev->sd_sb);
+		count++;
 	}
 
+	/*
+	 * When several superblocks share the device, keep it frozen even if some
+	 * of them failed to freeze and swallow the error: rolling the rest back
+	 * via thaw_super() can fail too, so neither is a clear win. A single
+	 * filesystem (count == 1) still reports its error.
+	 */
+	if (error && count > 1)
+		error = 0;
 	if (!error)
 		error = sync_blockdev(bdev);
 	return error;
@@ -1583,12 +1594,14 @@ static int fs_bdev_freeze(struct block_device *bdev)
  * A zero return does not imply a superblock is fully unfrozen; it may have been
  * frozen more than once (by the kernel or via another device).
  *
- * Return: 0, or the first error from thawing a superblock.
+ * Return: 0, or the first error on a single-fs device; a shared device swallows
+ *         per-superblock errors, as fs_bdev_freeze() does.
  */
 static int fs_bdev_thaw(struct block_device *bdev)
 {
 	dev_t dev = bdev->bd_dev;
 	struct super_dev *sb_dev;
+	unsigned int count = 0;
 	int error = 0, err;
 
 	lockdep_assert_held(&bdev->bd_fsfreeze_mutex);
@@ -1602,8 +1615,12 @@ static int fs_bdev_thaw(struct block_device *bdev)
 		if (err && !error)
 			error = err;
 		deactivate_super(sb_dev->sd_sb);
+		count++;
 	}
 
+	/* Shared device: swallow per-superblock errors, like fs_bdev_freeze(). */
+	if (error && count > 1)
+		error = 0;
 	return error;
 }
 

-- 
2.47.3

