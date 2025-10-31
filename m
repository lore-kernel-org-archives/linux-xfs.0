Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B56D246783
	for <linux-xfs@vger.kernel.org>; Fri, 31 Oct 2025 14:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761920156; cv=none; b=M64Ka9uEeQKMSKn9T7R9u8GQ8dgIorsn1uk6sAaQHK6KTnG9pFhx82QJh2EAGEsXBPE7BbojdFbGBh2Nu63JFzFzxJILBWQ1P8jB5Otd+Xw1VC0xW/GmsBYLD63WRdyAR5pvCwmIxR4njQBaLYEy8IRV9M+5nR1TIH7QRRIJZW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761920156; c=relaxed/simple;
	bh=jHment6D9PwBgVwdgtbjy8CvJnSiNtPsaWQNeEVk41M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=prQE6Ks1WXE+C6FunvdJKyd4waK7K550B15KKSAbZftU2uyvWy+fywd8QzbV0N5gwBM9QfSh9FnjQlYvB6nxMSX7Rz36lpnYQDCwTd0EyVsf1n6HAUdyT14mNkHYRzSqaaTZ4e9kN9WNqC/Bwzd8V9jlvMPKrH7vQTDyIyccGTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZQqt7OB4; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZQqt7OB4"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2907948c1d2so24629135ad.3
        for <linux-xfs@vger.kernel.org>; Fri, 31 Oct 2025 07:15:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761920154; x=1762524954; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=weWpY5lIoBECXK4shvaN2XP2LXnw19fzpfkt8TwGVjI=;
        b=ZQqt7OB4EJc/CYG9vCEJQsKwngaCUY5pEt6raiCE+9zifyz5w8xtbDabYwbEovnzvC
         6UrgHQrvEPXEUdQOi8RyLSxhkqJnowSjz0sRNJGdcLmPvP8Pv+VbaGtV71h8gx8GWuHU
         8SxbAvMU/YD8H2Kn0c1+OqWByhFHVMVCD0gP7wqG+trxPGzJhGxXTJ1yAOQXmOsRe8v/
         iN2M64hLvQ1xFBhxdLbn1Q7NTo3DXxzqv1PoNxHUBZeV8PCkxVn3WdoL4O2Vh6BCTj/+
         dHlq5KDI7lUFEs5K79GWh3E6GSEwH660ZtD/j6eLmaSilg+/oJcnYADP+EZAVAl3yxjF
         7qMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761920154; x=1762524954;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=weWpY5lIoBECXK4shvaN2XP2LXnw19fzpfkt8TwGVjI=;
        b=K0hdAoMjwX2Gb26IwVbOq34t5Fip8agU1nbC8NT1coqDp53U3bBCfJ3zp9Bi1+YjQz
         /IxyNK6l1WzyjegruSIEosTW27LE9yzteTaQBxZ0JpB+wFa3uNxnOYkXdDCkCmbpeRjM
         3NCKYB1j3n2yk3Wl+wAsqW/U84w9oLl4X+tk0buYHgMWmE/47n+Dvff0569Egb3H6J7B
         MZlwjSGa52qqN8+vVYaKecaJ3QjmXeWuLNNdWt6Mxd5ZOyqchQww7WQf2M9cVFR/Sl2V
         wLgWd+N1xdymRUutlQfiMeWPJnmdD1/DRJuH10HP27AKdWAyUrRxlVxjruABBW8uqV8j
         1nxA==
X-Gm-Message-State: AOJu0Yx3BM/yw2ppEiiIP3UczDH8hNs6sO+GF8JUw7Nn3/MXtG8DyU6P
	SppbTQnVq4Flm4i050Y0hihitLYhX1XFLsP/m4iA4gaRtrHvhf6JZPsb
X-Gm-Gg: ASbGncvnzPvL2vozbrlxs0zHPeBEQl5E26tGXFV2mKkQzAGyc39QoovFF2Gds1dymQ5
	cUG+y5GSZVAvVS9Y32HkyJ4yskr0wDgDrU7ocf9QstUcnSt+GBBrxWJPq6QIbV+DaLxmrDUzU6V
	S6yGEi+ILpQMYBcVRgS8lvwaPX12IE8Cxo7zs9evG69VWN6u/9KboT/9HcDidVH5z25evE98nfX
	4SfmktfMqJ48GCI+5ANoX2pJE3Ipu1wcrHHXkrPBMFZsGabOQLkN0zyplsqH8aGZ/GTMtCktxFR
	kXwrBYLwdmhfbdABnqz24mcvwVNrAQ+/jxsmuHxXEE67R17qam8OJ+38Xb2yZ67+z8aYaeNWJVl
	cnMn68mr5BpHLQ2DPs1RMGF7TFehVIbCJVS1vATmJg4rFxnJZk68MWVUGvnn+cwD09bRw6yoQqN
	4w9XwcZby3mNTp1xKC0QfXBCydOp4W6OpAq8oS9AVv5Kucj0rkXFkZZfJ7SA==
X-Google-Smtp-Source: AGHT+IF9JAuH5pE+LRBTZJp2p+ijGSLjbEZ3NNnilNTFbZasg1Sa3+ulfnuYpzEXx/7bmxbdjd3K+A==
X-Received: by 2002:a17:902:f544:b0:270:ced4:911a with SMTP id d9443c01a7336-2951a36c2cbmr48823365ad.9.1761920153132;
        Fri, 31 Oct 2025 07:15:53 -0700 (PDT)
Received: from xiaomi-ThinkCentre-M760t.mioffice.cn ([43.224.245.241])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b93b8aa3ef0sm2286709a12.11.2025.10.31.07.15.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Oct 2025 07:15:52 -0700 (PDT)
From: Yongpeng Yang <yangyongpeng.storage@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jan Kara <jack@suse.cz>,
	Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Yongpeng Yang <yangyongpeng@xiaomi.com>
Subject: [PATCH] fix missing sb_min_blocksize() return value checks in some filesystems
Date: Fri, 31 Oct 2025 22:15:27 +0800
Message-ID: <20251031141528.1084112-1-yangyongpeng.storage@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yongpeng Yang <yangyongpeng@xiaomi.com>

When emulating an nvme device on qemu with both logical_block_size and
physical_block_size set to 8 KiB, but without format, a kernel panic
was triggered during the early boot stage while attempting to mount a
vfat filesystem.

[95553.682035] EXT4-fs (nvme0n1): unable to set blocksize
[95553.684326] EXT4-fs (nvme0n1): unable to set blocksize
[95553.686501] EXT4-fs (nvme0n1): unable to set blocksize
[95553.696448] ISOFS: unsupported/invalid hardware sector size 8192
[95553.697117] ------------[ cut here ]------------
[95553.697567] kernel BUG at fs/buffer.c:1582!
[95553.697984] Oops: invalid opcode: 0000 [#1] SMP NOPTI
[95553.698602] CPU: 0 UID: 0 PID: 7212 Comm: mount Kdump: loaded Not tainted 6.18.0-rc2+ #38 PREEMPT(voluntary)
[95553.699511] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
[95553.700534] RIP: 0010:folio_alloc_buffers+0x1bb/0x1c0
[95553.701018] Code: 48 8b 15 e8 93 18 02 65 48 89 35 e0 93 18 02 48 83 c4 10 5b 41 5c 41 5d 41 5e 41 5f 5d 31 d2 31 c9 31 f6 31 ff c3 cc cc cc cc <0f> 0b 90 66 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 0f
[95553.702648] RSP: 0018:ffffd1b0c676f990 EFLAGS: 00010246
[95553.703132] RAX: ffff8cfc4176d820 RBX: 0000000000508c48 RCX: 0000000000000001
[95553.703805] RDX: 0000000000002000 RSI: 0000000000000000 RDI: 0000000000000000
[95553.704481] RBP: ffffd1b0c676f9c8 R08: 0000000000000000 R09: 0000000000000000
[95553.705148] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
[95553.705816] R13: 0000000000002000 R14: fffff8bc8257e800 R15: 0000000000000000
[95553.706483] FS:  000072ee77315840(0000) GS:ffff8cfdd2c8d000(0000) knlGS:0000000000000000
[95553.707248] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[95553.707782] CR2: 00007d8f2a9e5a20 CR3: 0000000039d0c006 CR4: 0000000000772ef0
[95553.708439] PKRU: 55555554
[95553.708734] Call Trace:
[95553.709015]  <TASK>
[95553.709266]  __getblk_slow+0xd2/0x230
[95553.709641]  ? find_get_block_common+0x8b/0x530
[95553.710084]  bdev_getblk+0x77/0xa0
[95553.710449]  __bread_gfp+0x22/0x140
[95553.710810]  fat_fill_super+0x23a/0xfc0
[95553.711216]  ? __pfx_setup+0x10/0x10
[95553.711580]  ? __pfx_vfat_fill_super+0x10/0x10
[95553.712014]  vfat_fill_super+0x15/0x30
[95553.712401]  get_tree_bdev_flags+0x141/0x1e0
[95553.712817]  get_tree_bdev+0x10/0x20
[95553.713177]  vfat_get_tree+0x15/0x20
[95553.713550]  vfs_get_tree+0x2a/0x100
[95553.713910]  vfs_cmd_create+0x62/0xf0
[95553.714273]  __do_sys_fsconfig+0x4e7/0x660
[95553.714669]  __x64_sys_fsconfig+0x20/0x40
[95553.715062]  x64_sys_call+0x21ee/0x26a0
[95553.715453]  do_syscall_64+0x80/0x670
[95553.715816]  ? __fs_parse+0x65/0x1e0
[95553.716172]  ? fat_parse_param+0x103/0x4b0
[95553.716587]  ? vfs_parse_fs_param_source+0x21/0xa0
[95553.717034]  ? __do_sys_fsconfig+0x3d9/0x660
[95553.717548]  ? __x64_sys_fsconfig+0x20/0x40
[95553.717957]  ? x64_sys_call+0x21ee/0x26a0
[95553.718360]  ? do_syscall_64+0xb8/0x670
[95553.718734]  ? __x64_sys_fsconfig+0x20/0x40
[95553.719141]  ? x64_sys_call+0x21ee/0x26a0
[95553.719545]  ? do_syscall_64+0xb8/0x670
[95553.719922]  ? x64_sys_call+0x1405/0x26a0
[95553.720317]  ? do_syscall_64+0xb8/0x670
[95553.720702]  ? __x64_sys_close+0x3e/0x90
[95553.721080]  ? x64_sys_call+0x1b5e/0x26a0
[95553.721478]  ? do_syscall_64+0xb8/0x670
[95553.721841]  ? irqentry_exit+0x43/0x50
[95553.722211]  ? exc_page_fault+0x90/0x1b0
[95553.722681]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[95553.723166] RIP: 0033:0x72ee774f3afe
[95553.723562] Code: 73 01 c3 48 8b 0d 0a 33 0f 00 f7 d8 64 89 01 48 83 c8 ff c3 0f 1f 84 00 00 00 00 00 f3 0f 1e fa 49 89 ca b8 af 01 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d da 32 0f 00 f7 d8 64 89 01 48
[95553.725188] RSP: 002b:00007ffe97148978 EFLAGS: 00000246 ORIG_RAX: 00000000000001af
[95553.725892] RAX: ffffffffffffffda RBX: 00005dcfe53d0080 RCX: 000072ee774f3afe
[95553.726526] RDX: 0000000000000000 RSI: 0000000000000006 RDI: 0000000000000003
[95553.727176] RBP: 00007ffe97148ac0 R08: 0000000000000000 R09: 000072ee775e7ac0
[95553.727818] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
[95553.728459] R13: 00005dcfe53d04b0 R14: 000072ee77670b00 R15: 00005dcfe53d1a28
[95553.729086]  </TASK>

The panic occurs as follows:
1. logical_block_size is 8KiB, causing {struct super_block *sb}->s_blocksize
is initialized to 0.
vfat_fill_super
 - fat_fill_super
  - sb_min_blocksize
   - sb_set_blocksize //return 0 when size is 8KiB.
2. __bread_gfp is called with size == 0, causing folio_alloc_buffers() to
compute an offset equal to folio_size(folio), which triggers a BUG_ON.
fat_fill_super
 - sb_bread
  - __bread_gfp  // size == {struct super_block *sb}->s_blocksize == 0
   - bdev_getblk
    - __getblk_slow
     - grow_buffers
      - grow_dev_folio
       - folio_alloc_buffers  // size == 0
        - folio_set_bh //offset == folio_size(folio) and panic

To fix this issue, add proper return value checks for sb_min_blocksize()
in vfat, exfat, isofs, and xfs.

Signed-off-by: Yongpeng Yang <yangyongpeng@xiaomi.com>
---
 fs/exfat/super.c   | 7 ++++++-
 fs/fat/inode.c     | 9 +++++++--
 fs/isofs/inode.c   | 5 +++++
 fs/xfs/xfs_super.c | 8 ++++++--
 4 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/fs/exfat/super.c b/fs/exfat/super.c
index 7f9592856bf7..fea41732354e 100644
--- a/fs/exfat/super.c
+++ b/fs/exfat/super.c
@@ -431,9 +431,14 @@ static int exfat_read_boot_sector(struct super_block *sb)
 {
 	struct boot_sector *p_boot;
 	struct exfat_sb_info *sbi = EXFAT_SB(sb);
+	int blocksize;
 
 	/* set block size to read super block */
-	sb_min_blocksize(sb, 512);
+	blocksize = sb_min_blocksize(sb, 512);
+	if (!blocksize) {
+		exfat_err(sb, "unable to set blocksize");
+		return -EINVAL;
+	}
 
 	/* read boot sector */
 	sbi->boot_bh = sb_bread(sb, 0);
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 9648ed097816..d22eec4f17b2 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -1535,7 +1535,7 @@ int fat_fill_super(struct super_block *sb, struct fs_context *fc,
 		   void (*setup)(struct super_block *))
 {
 	struct fat_mount_options *opts = fc->fs_private;
-	int silent = fc->sb_flags & SB_SILENT;
+	int silent = fc->sb_flags & SB_SILENT, blocksize;
 	struct inode *root_inode = NULL, *fat_inode = NULL;
 	struct inode *fsinfo_inode = NULL;
 	struct buffer_head *bh;
@@ -1595,8 +1595,13 @@ int fat_fill_super(struct super_block *sb, struct fs_context *fc,
 
 	setup(sb); /* flavour-specific stuff that needs options */
 
+	error = -EINVAL;
+	blocksize = sb_min_blocksize(sb, 512);
+	if (!blocksize) {
+		fat_msg(sb, KERN_ERR, "unable to set blocksize");
+		goto out_fail;
+	}
 	error = -EIO;
-	sb_min_blocksize(sb, 512);
 	bh = sb_bread(sb, 0);
 	if (bh == NULL) {
 		fat_msg(sb, KERN_ERR, "unable to read boot sector");
diff --git a/fs/isofs/inode.c b/fs/isofs/inode.c
index 6f0e6b19383c..ad3143d4066b 100644
--- a/fs/isofs/inode.c
+++ b/fs/isofs/inode.c
@@ -610,6 +610,11 @@ static int isofs_fill_super(struct super_block *s, struct fs_context *fc)
 		goto out_freesbi;
 	}
 	opt->blocksize = sb_min_blocksize(s, opt->blocksize);
+	if (!opt->blocksize) {
+		printk(KERN_ERR
+		       "ISOFS: unable to set blocksize\n");
+		goto out_freesbi;
+	}
 
 	sbi->s_high_sierra = 0; /* default is iso9660 */
 	sbi->s_session = opt->session;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index e85a156dc17d..b6e52861378f 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1642,7 +1642,7 @@ xfs_fs_fill_super(
 {
 	struct xfs_mount	*mp = sb->s_fs_info;
 	struct inode		*root;
-	int			flags = 0, error;
+	int			flags = 0, error, blocksize;
 
 	mp->m_super = sb;
 
@@ -1662,7 +1662,11 @@ xfs_fs_fill_super(
 	if (error)
 		return error;
 
-	sb_min_blocksize(sb, BBSIZE);
+	blocksize = sb_min_blocksize(sb, BBSIZE);
+	if (!blocksize) {
+		xfs_err(mp, "unable to set blocksize");
+		return -EINVAL;
+	}
 	sb->s_xattr = xfs_xattr_handlers;
 	sb->s_export_op = &xfs_export_operations;
 #ifdef CONFIG_XFS_QUOTA
-- 
2.43.0

