Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3817381B10;
	Wed, 10 Jun 2026 06:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781074568; cv=none; b=HIPpeupgSTQEVDgRvQsPRJrnON1epPhsR7vQtiPZloOYK8h0rnJMNujW0qPF662+N6Xnmls1+tU9m/fjIU/gZzWsiW0KfV9EdiMoLgA4AjN80CP2xOoARsY2aiXE5h8bDmIkLLFDFIBWxcrZtXSpaZ668x9s75C4znxpSfHTOGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781074568; c=relaxed/simple;
	bh=rRDfpSzw3X6enhuhpGqG6t8VOaobODgmutXYPZvFcJg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BIV4QqlhujrT17+c8450TMq2cE90pC2cpniEEr7pom0515Rh8MqJSQ5cA6UmOD2dlj3Do9et2YkHhxfpPA810P5sU732tPuhUj4SBtX3DfTwuUhOjV6644JZ1DJzARhTaIEtvjzAYE2cck0hRV1NAD9MjoqIs0Kaonli9NjV4cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=aNQ7PbRk; arc=none smtp.client-ip=115.124.30.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="aNQ7PbRk"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1781074556; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=tHKZXlYHzQiuz4CuXIVUBayRBgQEvDJmST6DE9mf+8g=;
	b=aNQ7PbRkZItFf11r6vye/H8dRDn2Z6ZAjuVVWvn0YNKanggFZPXafrhDoQui5jX0eHL87te9FysI5HQa/o/wTuo4pGFqDZdwSkh4X9Fmze5auj2q9kC249IitnczyEeadQwx8k3Dv6Ayl1JqDryyulYUiVOs5hAajrIAlZLwxGU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R961e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0X4ZbVxy_1781074555;
Received: from 30.221.130.225(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X4ZbVxy_1781074555 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 10 Jun 2026 14:55:56 +0800
Message-ID: <e4aa171b-ac0f-4cd1-8605-91a3f82a4faf@linux.alibaba.com>
Date: Wed, 10 Jun 2026 14:55:54 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 7/8] erofs: open via dedicated fs bdev helpers
To: Christian Brauner <brauner@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, Carlos Maiolino <cem@kernel.org>,
 linux-xfs@vger.kernel.org, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
 Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
 Gao Xiang <xiang@kernel.org>, linux-erofs@lists.ozlabs.org,
 Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>
References: <20260602-work-super-bdev_holder_global-v1-0-bb0fd82f3861@kernel.org>
 <20260602-work-super-bdev_holder_global-v1-7-bb0fd82f3861@kernel.org>
 <7c5bfcf0-36a3-4cc6-bf31-6af4fc901c37@linux.alibaba.com>
 <20260603-nieder-ausdehnen-siebdruck-aa96f40ebec6@brauner>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260603-nieder-ausdehnen-siebdruck-aa96f40ebec6@brauner>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Christian,

On 2026/6/3 21:42, Christian Brauner wrote:
>> May I ask if it's an urgent 7.2 work? If not, I could
> 
> No no, it's way too late for that this cycle.
> 
>> make a preparation patch for the upcoming 7.2 cycle
>> to handle erofs_map_dev() failure here so you don't
>> need to bother with this in this patchset.
> 
> Sounds good. I take it you can just do this yourself without me.
> 
>> I will seek more time to resolve the recent todos
> 
> Thanks!
> 
>> yet always intercepted by other unrelated stuffs.
> 
> :)

I removed .shutdown() and .remove_bdev() implementations since I
think it doesn't quite seem necessary for immutable fses, but
would like to know your thoughts too, my overall own comments are
documented in the commit message below:


 From 933f6c6f2e704116d9a15815c880196bec7b9ee3 Mon Sep 17 00:00:00 2001
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 2 Jun 2026 12:10:13 +0200
Subject: [PATCH] erofs: open via dedicated fs bdev helpers

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

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
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
2.43.5


