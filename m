Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3E8F407CD0;
	Tue, 16 Jun 2026 14:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781618958; cv=none; b=KohkwottcSzCk5PAo2+cvqc8gvDD5csgBucl21azKjjjoF1r9Nej4+f3gOBsH3XzxyXJGcQTuqSIVZlPp5bczx9+qDkstnzkOOb0XmTEhcpKE7BzRSHASRwTwC4IEEJIVWOrVYEXgidnu7ZTM4nvsnOLDtBf0b6FQvh956a2snw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781618958; c=relaxed/simple;
	bh=mEavDJy+fkdUc8IBWKjs2UM866Kx5OEdydgBKLvNJwI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=i3NNuvPt20/5Rz4wIRI376+74xoovoLuXWvvE84ivDV6n0Lh6ZAt6bS3v/V/SWWCweaeBNQBg0hVOeQ8Lho3GqaniC23JMsVZEJZj/RS/PquIFw39XmLPMH+jMoK2d6Sh2P7qA3p5xueIGc/3AGWSTd9grBcYd0He8Ww8+OXDyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WcApXdFf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WcApXdFf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93E671F00A3F;
	Tue, 16 Jun 2026 14:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781618956;
	bh=Is8R3wvaCq/80vj1DXKU0n4cGeOyh4O2DUMSCyO+wtE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=WcApXdFfYYYKjKwwroYDEmWqiKf8LsKq1xZJ/+ThX43fSpdUpzlicaz96+1qaRxSo
	 DlF3HFcwGG/E5T2G/JSXGhneiDFiaJZtUOrfByxmRwpS6eaJ2O4xYIWldm0YG0yTOn
	 sj+gjoCm1wmNH10dqcrAB2NsHTNxP4lwrzomS2+Bd+UM2HqgQbcL4mu1QPeLVrByr/
	 cPqInXaWJvx0zs4gs1FHE1cwUd7Jy7SPgYdhGRm06rGrKazUSEyff9D3uHVMEVM8K3
	 XjSrcKU8XL+GRy0xxsW3cfSbIqcxYF0SoNgPf8W+yflfSUVbX3IGfVHoP4fYqqI6yU
	 DKTo9j2IEaJ6Q==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 16 Jun 2026 16:08:27 +0200
Subject: [PATCH RFC v2 11/18] ext4: open via dedicated fs bdev helpers
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260616-work-super-bdev_holder_global-v2-11-7df6b864028e@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2024; i=brauner@kernel.org;
 h=from:subject:message-id; bh=mEavDJy+fkdUc8IBWKjs2UM866Kx5OEdydgBKLvNJwI=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQZRtw/777zxln1Gg6hy+86lq71uK52TVV/ggaDjGXHR
 7P/82UndpSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEwk9i3DP0275KOKq+ari5eI
 VrQu8TB8t+OwjVe20bTnVeVnrm6x9Wb4K3nmZUBeQdm864XnxYVXvAw/V/ghdfKEz38CbaVuVpu
 VMgAA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Route the external journal device open through fs_bdev_file_open_by_dev()
so it is registered against the superblock, and convert the matching
releases to fs_bdev_file_release().

Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/ext4/super.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 7283108d7609..2b5301a3bcfb 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5793,7 +5793,7 @@ failed_mount8: __maybe_unused
 	brelse(sbi->s_sbh);
 	if (sbi->s_journal_bdev_file) {
 		invalidate_bdev(file_bdev(sbi->s_journal_bdev_file));
-		bdev_fput(sbi->s_journal_bdev_file);
+		fs_bdev_file_release(sbi->s_journal_bdev_file, sb);
 	}
 out_fail:
 	invalidate_bdev(sb->s_bdev);
@@ -5972,9 +5972,9 @@ static struct file *ext4_get_journal_blkdev(struct super_block *sb,
 	struct ext4_super_block *es;
 	int errno;
 
-	bdev_file = bdev_file_open_by_dev(j_dev,
+	bdev_file = fs_bdev_file_open_by_dev(j_dev,
 		BLK_OPEN_READ | BLK_OPEN_WRITE | BLK_OPEN_RESTRICT_WRITES,
-		sb, &fs_holder_ops);
+		sb, sb);
 	if (IS_ERR(bdev_file)) {
 		ext4_msg(sb, KERN_ERR,
 			 "failed to open journal device unknown-block(%u,%u) %ld",
@@ -6034,7 +6034,7 @@ static struct file *ext4_get_journal_blkdev(struct super_block *sb,
 out_bh:
 	brelse(bh);
 out_bdev:
-	bdev_fput(bdev_file);
+	fs_bdev_file_release(bdev_file, sb);
 	return ERR_PTR(errno);
 }
 
@@ -6073,7 +6073,7 @@ static journal_t *ext4_open_dev_journal(struct super_block *sb,
 out_journal:
 	ext4_journal_destroy(EXT4_SB(sb), journal);
 out_bdev:
-	bdev_fput(bdev_file);
+	fs_bdev_file_release(bdev_file, sb);
 	return ERR_PTR(errno);
 }
 
@@ -7490,7 +7490,7 @@ static void ext4_kill_sb(struct super_block *sb)
 	kill_block_super(sb);
 
 	if (bdev_file)
-		bdev_fput(bdev_file);
+		fs_bdev_file_release(bdev_file, sb);
 }
 
 static struct file_system_type ext4_fs_type = {

-- 
2.47.3

