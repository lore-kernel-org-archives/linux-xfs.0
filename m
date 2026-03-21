Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF9092E093A;
	Sat, 21 Mar 2026 11:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774094153; cv=none; b=LxQLf/FOmCLR2k7Kh7OYTBD1h8p34mlwhbUGamdi76N0m7hcnZHmtnrrIC5rJKg9dRUUSfXxRlAg1puHWYs/xC14ritOLGOMleVNJpd3rcXLQOWdfZu6x1p2ky8quHAQZwfUbMCzjQEeO9E4YYZzYEeoubk6O/FHjSA10Cim9a4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774094153; c=relaxed/simple;
	bh=iJcFL/6FlTKmTORa19GJC7yC3dh2zZUTBPwV/szAKO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rbx/oE0642U8QknU9o5QigWiTqzhT5WVerCZsMMFu5U2UrA2j8m8v3Mujagt31IXzDm3sqR/47/Ei9/lZG+M/9DM66pN6MJet7a7PECiBSlD5IIz3kg6bFvEXp4UxAgD6NIif9lvHUj4unFkGGTJyMurSNoetcWJKTIYPadDttk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HUYOgVpH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HUYOgVpH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 658CAC19421;
	Sat, 21 Mar 2026 11:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774094153;
	bh=iJcFL/6FlTKmTORa19GJC7yC3dh2zZUTBPwV/szAKO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HUYOgVpHGd9+1hFFzbvOrKqiw7uv4WjznCTguPGZxpq3eha3A6TSZc633ZHt/orlh
	 pN0W/8wAuJYu+hidUwOiEgS8LTL27T5/NGWJMojoqQj7Cmi8o3aVPUZNO2EPP+syYy
	 PEjGFDBQ0xgo7e5X/+2u3q/H8zQIohHthUN39PguEBYArR8syT4Abla1vKuZjEQPwe
	 l7agbrokhxhOUcFBLGQu7GpbHQZJxRglv6f2B4Htq+IvfCnoQDYtoqMzbxrfxnjxL7
	 jTtXwWF/pVvxXtwMT2daCTo3rO3RXgzlBtLuAS7ixCdcnV/EOnmbkGAdkBwi1PYYsS
	 koTMI8HkIr1ag==
From: Anand Jain <asj@kernel.org>
To: linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	hch@infradead.org
Subject: [PATCH v2 2/3] btrfs: derive f_fsid from on-disk fsuuid and dev_t
Date: Sat, 21 Mar 2026 19:55:18 +0800
Message-ID: <10a393d9bc7379a54b87df7c7c8c3374b28138ee.1774092915.git.asj@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1774092915.git.asj@kernel.org>
References: <cover.1774092915.git.asj@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

f_fsid depends on fs_devices->fsid and subvol root id.

For cloned devices either same as the source or dynamical generated
at mount won't suite because tools like fanotify and ima depends on it.

Switch to a stable derivation using the persistent on-disk fsuuid +
root id + devt of the block device for the single device filesystem.
This is consistent as long as the device remains unchanged/replace
(excludes btrfs device replace secnario for now).

This change is only for the single device configs and is behind the
-o nouuid mount option to keep this change compatible with ABI.

Signed-off-by: Anand Jain <asj@kernel.org>
---
 fs/btrfs/fs.h    |  1 +
 fs/btrfs/super.c | 35 +++++++++++++++++++++++++++++++----
 2 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
index a4758d94b32e..6e2a5c2bd03c 100644
--- a/fs/btrfs/fs.h
+++ b/fs/btrfs/fs.h
@@ -270,6 +270,7 @@ enum {
 	BTRFS_MOUNT_IGNOREMETACSUMS		= (1ULL << 31),
 	BTRFS_MOUNT_IGNORESUPERFLAGS		= (1ULL << 32),
 	BTRFS_MOUNT_REF_TRACKER			= (1ULL << 33),
+	BTRFS_MOUNT_NOUUID			= (1ULL << 34),
 };
 
 /* These mount options require a full read-only fs, no new transaction is allowed. */
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 125fca57c164..2fb82032f1e1 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -102,6 +102,7 @@ enum {
 	Opt_compress_type,
 	Opt_degraded,
 	Opt_device,
+	Opt_nouuid,
 	Opt_fatal_errors,
 	Opt_flushoncommit,
 	Opt_max_inline,
@@ -227,6 +228,7 @@ static const struct fs_parameter_spec btrfs_fs_parameters[] = {
 	fsparam_flag_no("datasum", Opt_datasum),
 	fsparam_flag("degraded", Opt_degraded),
 	fsparam_string("device", Opt_device),
+	fsparam_flag("nouuid", Opt_nouuid),
 	fsparam_flag_no("discard", Opt_discard),
 	fsparam_enum("discard", Opt_discard_mode, btrfs_parameter_discard),
 	fsparam_enum("fatal_errors", Opt_fatal_errors, btrfs_parameter_fatal_errors),
@@ -382,6 +384,9 @@ static int btrfs_parse_param(struct fs_context *fc, struct fs_parameter *param)
 			return PTR_ERR(device);
 		break;
 	}
+	case Opt_nouuid:
+		btrfs_set_opt(ctx->mount_opt, NOUUID);
+		break;
 	case Opt_datasum:
 		if (result.negated) {
 			btrfs_set_opt(ctx->mount_opt, NODATASUM);
@@ -1113,6 +1118,8 @@ static int btrfs_show_options(struct seq_file *seq, struct dentry *dentry)
 		seq_puts(seq, ",discard");
 	if (btrfs_test_opt(info, DISCARD_ASYNC))
 		seq_puts(seq, ",discard=async");
+	if (btrfs_test_opt(info, NOUUID))
+		seq_puts(seq, ",nouuid");
 	if (!(info->sb->s_flags & SB_POSIXACL))
 		seq_puts(seq, ",noacl");
 	if (btrfs_free_space_cache_v1_active(info))
@@ -1733,7 +1740,7 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	u64 total_free_data = 0;
 	u64 total_free_meta = 0;
 	u32 bits = fs_info->sectorsize_bits;
-	__be32 *fsid = (__be32 *)fs_info->fs_devices->fsid;
+	__be32 *fsid;
 	unsigned factor = 1;
 	struct btrfs_block_rsv *block_rsv = &fs_info->global_block_rsv;
 	int ret;
@@ -1819,15 +1826,35 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	buf->f_bsize = fs_info->sectorsize;
 	buf->f_namelen = BTRFS_NAME_LEN;
 
-	/* We treat it as constant endianness (it doesn't matter _which_)
-	   because we want the fsid to come out the same whether mounted
-	   on a big-endian or little-endian host */
+	/*
+	 * fs_devices->fsid is dynamically generated when temp_fsid is active
+	 * to support cloned devices. Use the original on-disk fsid instead,
+	 * as it remains consistent across mount cycles.
+	 */
+	fsid = (__be32 *)fs_info->super_copy->fsid;
+	/*
+	 * We treat it as constant endianness (it doesn't matter _which_)
+	 * because we want the fsid to come out the same whether mounted
+	 * on a big-endian or little-endian host.
+	 */
 	buf->f_fsid.val[0] = be32_to_cpu(fsid[0]) ^ be32_to_cpu(fsid[2]);
 	buf->f_fsid.val[1] = be32_to_cpu(fsid[1]) ^ be32_to_cpu(fsid[3]);
 	/* Mask in the root object ID too, to disambiguate subvols */
 	buf->f_fsid.val[0] ^= btrfs_root_id(BTRFS_I(d_inode(dentry))->root) >> 32;
 	buf->f_fsid.val[1] ^= btrfs_root_id(BTRFS_I(d_inode(dentry))->root);
 
+	/*
+	 * dev_t provides way to differentiate mounted cloned devices keeps
+	 * the statfs fid is consistent and unique.
+	 */
+	if (btrfs_test_opt(fs_info, NOUUID) &&
+	    fs_info->fs_devices->total_devices == 1) {
+		__kernel_fsid_t dev_fsid = \
+	u64_to_fsid(huge_encode_dev(fs_info->fs_devices->latest_dev->bdev->bd_dev));
+		buf->f_fsid.val[0] ^= dev_fsid.val[1];
+		buf->f_fsid.val[1] ^= dev_fsid.val[0];
+	}
+
 	return 0;
 }
 
-- 
2.43.0

