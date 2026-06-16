Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D4CF43DA25;
	Tue, 16 Jun 2026 14:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781618977; cv=none; b=PxKUDMUV2KnluFs42YVEBTXUhA591GxKLkvGflS3HQomYwg72Fkxzur3bvj//HtYyEeBHJnWYZtfF7/rWVTi5TyYTqBqPagd3sDL1yIXSYVfYL5XJCMsllih/iI/4C4D2QzkL63Yr0qfbOGEzItb71JQ49OhGMftWIB8tMF9K74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781618977; c=relaxed/simple;
	bh=OtwyzN33qcp3Tprake7kNYtJqUhDTVNsJipaTKEubwM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=pd6pRRf1Bd/WGAb/CtlQKg+/tSwFqMWcMr2yr/HWhSXL03d/l9yg8qu2MXoVwCvSGjOqAZPmALiXD1kv3uzgFYSMTjPYX8YRcA6/srJEHjItKUDkNOa5WUoew3QB71mzbb/gmdWnmvV92h8vUIegiPZftpaMK5LF6lWzJFgWvV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QNk8Pde8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QNk8Pde8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5FD11F00AC4;
	Tue, 16 Jun 2026 14:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781618976;
	bh=aTcPWezXgQ5+ASGJFKrfJE2MFrpVhk3GuVEmxFiscQY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=QNk8Pde81+c7bz69IC0LrqDsR1/mXDO52tE+dSEVlTe7lMbb7fhh8KvJfcB+mdK1j
	 L9uA2jfjMpAtXaozInTXS9WAaM48C4YFenMHIKmBY/UuV8up1sH9vRm1cUkjOUBup3
	 ptLH455DhZPnM+LFkkLkNYmUwDc34HwFOVfrQraizZbA0mjELJOz9p3h9r80RVVQwE
	 bEV3aQrkfYrOTN3UtEL+mbqgyUvD3+nFnltDkNASM1m/APM0sO/yJSNZk8W6I+RX3A
	 ib3/4f79FL0DxavjHTYT9JvAij/YnqJSmSNEdL276TmLIkLwbTaAa4ScF2oV0Qha7M
	 U1Dij6CJxoD0A==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 16 Jun 2026 16:08:32 +0200
Subject: [PATCH RFC v2 16/18] super: make fs_holder_ops private
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260616-work-super-bdev_holder_global-v2-16-7df6b864028e@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1644; i=brauner@kernel.org;
 h=from:subject:message-id; bh=OtwyzN33qcp3Tprake7kNYtJqUhDTVNsJipaTKEubwM=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQZRtyXtw26x3kveDp/QJy3R8bk6qXGTds7JFa7tyat3
 +euxxjaUcrCIMbFICumyOLQbhIut5ynYrNRpgbMHFYmkCEMXJwCMBExb0aGU/ftebO63h2sKS7X
 uSzP5dE1eULVkapbrpaTd3mZ/b6iyPBPXcGu+N2X7Hsb/v/lOVoVFL9q1QJm7ynK+ttnmixKunW
 BDwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Now that filesystems open and claim their block devices through
fs_bdev_file_open_by_{dev,path}(), nothing outside fs/super.c references
fs_holder_ops. Make it static and drop its declaration from blkdev.h.

Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/super.c             | 3 +--
 include/linux/blkdev.h | 7 -------
 2 files changed, 1 insertion(+), 9 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index a83f58755cf8..2d0a07861bfc 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -1624,13 +1624,12 @@ static int fs_bdev_thaw(struct block_device *bdev)
 	return error;
 }
 
-const struct blk_holder_ops fs_holder_ops = {
+static const struct blk_holder_ops fs_holder_ops = {
 	.mark_dead		= fs_bdev_mark_dead,
 	.sync			= fs_bdev_sync,
 	.freeze			= fs_bdev_freeze,
 	.thaw			= fs_bdev_thaw,
 };
-EXPORT_SYMBOL_GPL(fs_holder_ops);
 
 static struct super_dev *super_dev_lookup(dev_t dev, struct super_block *sb)
 {
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index cee548184a7b..45225b4f7193 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1772,13 +1772,6 @@ struct blk_holder_ops {
 		__releases(&bdev->bd_holder_lock);
 };
 
-/*
- * For filesystems using @fs_holder_ops, the @holder argument passed to
- * helpers used to open and claim block devices via
- * bd_prepare_to_claim() must point to a superblock.
- */
-extern const struct blk_holder_ops fs_holder_ops;
-
 /*
  * Return the correct open flags for blkdev_get_by_* for super block flags
  * as stored in sb->s_flags.

-- 
2.47.3

