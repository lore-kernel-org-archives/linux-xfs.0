Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 945C8377006;
	Tue, 16 Jun 2026 14:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781618935; cv=none; b=S9j+MCVTVMpYg4VzCezBd/XnIHSLn8r7rrZO/7n49L3TnuqbJUMvSmx6Kc1H10qpbobrkHZCWZM2Ib3JswEYz75zbWwB7uyOvlzA88DBi8G1T13QzBaJSvbO2OC9uAyt6NGo3yrk+IfI/Srzr0y9Gfv9CrJ4H6Zsyzk2WXE/su8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781618935; c=relaxed/simple;
	bh=8k1zf1Xhv1DGOeFMfDC/l7TAYeTE4+X4pRdFgzN3Qrk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=gNeYH/GEpQEvdXUSBTFdw/9Wgmmpk2QqiRIDO4hYgzwLcXEmXBZbVlfftOBaB8nNANlVjdkd37c4UNbRgItpbh3FwA7jSuhTDDIRIJMyDmt8sEiEQ+q0skJySi/ZRRoorxLujJh3PNGarwp5RYa4ehJzt8oKw+KgKj04XiRkBBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YErVXEEI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YErVXEEI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E595E1F00A3A;
	Tue, 16 Jun 2026 14:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781618934;
	bh=YhQnc85bhNppX3ZWtjMTIiQZA5BWEXOerB7NxvXiEsY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=YErVXEEI97QukE5WwtZDkNCrh8zvAAbO493SZHRJP0UY6wJSXsDkm6g0fuf9t9afl
	 2C8tMUrhnBFGhPb0rvQCfBuWiiSn2SxN70646xDlZO8j0aCkHdO048moY9huSDpywc
	 mt9bIk16S6sk2fia2i+A0gWOOr+95pS+2uIZlWwps3NzBdFi+ilPqtOH87ie53KdiH
	 cQxZTYhOSI5AFxACkQQXT9FrQOpFFFnBEwcerrLpfxZUzp4VNmLC9j1Q4Bd79BWX0a
	 dPB0ZLfCwPlm6YNJTVxB81iH3rUTNjG1cbFd5nTAm2uyFcAbt07aD7aIC22I9yTKQx
	 OjcvPNxqXfZYQ==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 16 Jun 2026 16:08:21 +0200
Subject: [PATCH RFC v2 05/18] ext4: use anonymous devices for KUnit test
 superblocks
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260616-work-super-bdev_holder_global-v2-5-7df6b864028e@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2549; i=brauner@kernel.org;
 h=from:subject:message-id; bh=8k1zf1Xhv1DGOeFMfDC/l7TAYeTE4+X4pRdFgzN3Qrk=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQZRty7rJkuyThlafyx1mIfjotdVpZ67EFinW+lVrsm6
 M7QlP3UUcrCIMbFICumyOLQbhIut5ynYrNRpgbMHFYmkCEMXJwCMJFjvxkZNh5cy6Npvn9z+LWY
 x3cOHzqavPJzxZ1Uvcs2TCKPvDzWaDMyzIoU7rjsZfN8+0tGuzPhUV/+TPWL69tZnSwxqedB5X8
 nLgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

The mballoc and extents KUnit tests create superblocks through
sget_fc() with a set callback that never assigns s_dev and a kill_sb
that only calls generic_shutdown_super().

The upcoming global device-to-superblock table registers every
superblock under its s_dev, so each superblock needs a unique device
number. Allocate a proper anonymous device via set_anon_super_fc() and
release it through kill_anon_super().

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/ext4/extents-test.c | 9 ++-------
 fs/ext4/mballoc-test.c | 9 ++-------
 2 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/fs/ext4/extents-test.c b/fs/ext4/extents-test.c
index bd7795a82607..c3836ecb89f9 100644
--- a/fs/ext4/extents-test.c
+++ b/fs/ext4/extents-test.c
@@ -126,11 +126,6 @@ struct kunit_ext_test_param {
 	struct kunit_ext_data_state exp_data_state[3];
 };
 
-static void ext_kill_sb(struct super_block *sb)
-{
-	generic_shutdown_super(sb);
-}
-
 static int ext_init_fs_context(struct fs_context *fc)
 {
 	return 0;
@@ -138,13 +133,13 @@ static int ext_init_fs_context(struct fs_context *fc)
 
 static int ext_set(struct super_block *sb, struct fs_context *fc)
 {
-	return 0;
+	return set_anon_super_fc(sb, fc);
 }
 
 static struct file_system_type ext_fs_type = {
 	.name		 = "extents test",
 	.init_fs_context = ext_init_fs_context,
-	.kill_sb	 = ext_kill_sb,
+	.kill_sb	 = kill_anon_super,
 };
 
 static void extents_kunit_exit(struct kunit *test)
diff --git a/fs/ext4/mballoc-test.c b/fs/ext4/mballoc-test.c
index d90da44aadbd..a3b33ed2c172 100644
--- a/fs/ext4/mballoc-test.c
+++ b/fs/ext4/mballoc-test.c
@@ -59,11 +59,6 @@ static const struct super_operations mbt_sops = {
 	.free_inode	= mbt_free_inode,
 };
 
-static void mbt_kill_sb(struct super_block *sb)
-{
-	generic_shutdown_super(sb);
-}
-
 static int mbt_init_fs_context(struct fs_context *fc)
 {
 	return 0;
@@ -72,7 +67,7 @@ static int mbt_init_fs_context(struct fs_context *fc)
 static struct file_system_type mbt_fs_type = {
 	.name			= "mballoc test",
 	.init_fs_context	= mbt_init_fs_context,
-	.kill_sb		= mbt_kill_sb,
+	.kill_sb		= kill_anon_super,
 };
 
 static int mbt_mb_init(struct super_block *sb)
@@ -136,7 +131,7 @@ static void mbt_mb_release(struct super_block *sb)
 
 static int mbt_set(struct super_block *sb, struct fs_context *fc)
 {
-	return 0;
+	return set_anon_super_fc(sb, fc);
 }
 
 static struct super_block *mbt_ext4_alloc_super_block(void)

-- 
2.47.3

