Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59C722E093A;
	Sat, 21 Mar 2026 11:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774094155; cv=none; b=sTXajewce+Lx7MIzo+M8ajzJ8EzINKDyig8EUbb/oqTWmxujyzBTN+KEW5iY7ZC/MNpFK+/h5KaMl2TX9CjQHxnzHOdTsbTrzNGsDvLd/t4nyPzgI8KoC00lR0/CCZ7k0iMPmJnv1X8hiQ7wHHBmkPSC2auhMgWDAFMd+USbIfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774094155; c=relaxed/simple;
	bh=lvL4EldL7WqBWOKOgCGDgpa+YxAUJE4h3UjLrMVTpOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MEgK+PjB63BI/ZcDR397zzxLLxQSgdWX/9lcLo/YOJNdz8LTfHcwYnDMxDw9/DFL68roPsiijP1im9DK9253erah/g74KzQ9+fgKKIn4RR8w0yHWjaNpLCAoHh4+zKiy0pQl6wgMgzw3my4SjRTe+uSMQg86JkgZ+jo4fh+hT2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c2yrSjrp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c2yrSjrp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED8C1C19421;
	Sat, 21 Mar 2026 11:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774094155;
	bh=lvL4EldL7WqBWOKOgCGDgpa+YxAUJE4h3UjLrMVTpOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c2yrSjrp61VwPbFklVWnVv4dmwlkLmW3i8Y5VW2WU1eJozYguU3uALnpaysX6hqxH
	 GBD4LgM9ku6WrcJHAXkYVfQ9OsnihBe8/KOFZoSDS8oUfF77Emt60WrtiIpswELE4c
	 IvCxqGAGmlIageL3sic7he13DGOgh5WzqhgSoZ5qMC2mPzBUl5W9R1yoUJNZAxy+W+
	 w6L4qns8RY9iE6u/GAGBJiwK9ZNvktz9ZzWly0vMTnm0RBDUkdi0pqS+gdCtq5GSXf
	 cSAA3tSpYr1ujfdcD3y8PQ79vogZOcnPKZYzzhICU0DbtgqvFMfFhPhaojVTw0Pmk/
	 T70XTeifx32+A==
From: Anand Jain <asj@kernel.org>
To: linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	hch@infradead.org
Subject: [PATCH v2 3/3] ext4: derive f_fsid from block device to avoid collisions
Date: Sat, 21 Mar 2026 19:55:19 +0800
Message-ID: <33e8eb64c304a4d42b60f608c26497bf9a2e9e19.1774092915.git.asj@kernel.org>
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

statfs() currently reports f_fsid derived from the on-disk UUID.
Cloned block devices share the same UUID, so distinct ext4 instances
can return identical f_fsid values. This leads to collisions in
fanotify.

Encode sb->s_dev into f_fsid instead of using the superblock UUID.
This provides a per-device identifier and avoids conflicts when
filesystem is cloned, matching the behavior with xfs.

Place this change behind the new mount option "-o nouuid" for ABI
compatibility.

Signed-off-by: Anand Jain <asj@kernel.org>
---
 fs/ext4/ext4.h  |  1 +
 fs/ext4/super.c | 12 ++++++++++--
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 293f698b7042..64d98ab64c11 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1282,6 +1282,7 @@ struct ext4_inode_info {
 						    * scanning in mballoc
 						    */
 #define EXT4_MOUNT2_ABORT		0x00000100 /* Abort filesystem */
+#define EXT4_MOUNT2_NOUUID		0x00000200 /* No duplicate f_fsid for cloned filesystem */
 
 #define clear_opt(sb, opt)		EXT4_SB(sb)->s_mount_opt &= \
 						~EXT4_MOUNT_##opt
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 43f680c750ae..65b712af4ad7 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1664,7 +1664,7 @@ static const struct export_operations ext4_export_ops = {
 enum {
 	Opt_bsd_df, Opt_minix_df, Opt_grpid, Opt_nogrpid,
 	Opt_resgid, Opt_resuid, Opt_sb,
-	Opt_nouid32, Opt_debug, Opt_removed,
+	Opt_nouid32, Opt_debug, Opt_removed, Opt_nouuid,
 	Opt_user_xattr, Opt_acl,
 	Opt_auto_da_alloc, Opt_noauto_da_alloc, Opt_noload,
 	Opt_commit, Opt_min_batch_time, Opt_max_batch_time, Opt_journal_dev,
@@ -1743,6 +1743,7 @@ static const struct fs_parameter_spec ext4_param_specs[] = {
 	fsparam_u32	("sb",			Opt_sb),
 	fsparam_enum	("errors",		Opt_errors, ext4_param_errors),
 	fsparam_flag	("nouid32",		Opt_nouid32),
+	fsparam_flag	("nouuid",		Opt_nouuid),
 	fsparam_flag	("debug",		Opt_debug),
 	fsparam_flag	("oldalloc",		Opt_removed),
 	fsparam_flag	("orlov",		Opt_removed),
@@ -1898,6 +1899,7 @@ static const struct mount_opts {
 	{Opt_acl, 0, MOPT_NOSUPPORT},
 #endif
 	{Opt_nouid32, EXT4_MOUNT_NO_UID32, MOPT_SET},
+	{Opt_nouuid, EXT4_MOUNT2_NOUUID, MOPT_SET | MOPT_2},
 	{Opt_debug, EXT4_MOUNT_DEBUG, MOPT_SET},
 	{Opt_quota, EXT4_MOUNT_QUOTA | EXT4_MOUNT_USRQUOTA, MOPT_SET | MOPT_Q},
 	{Opt_usrquota, EXT4_MOUNT_QUOTA | EXT4_MOUNT_USRQUOTA,
@@ -2389,6 +2391,9 @@ static int ext4_parse_param(struct fs_context *fc, struct fs_parameter *param)
 			return -EINVAL;
 		}
 		return 0;
+	case Opt_nouuid:
+		ctx_set_mount_opt2(ctx, EXT4_MOUNT2_NOUUID);
+		return 0;
 	}
 
 	/*
@@ -6941,7 +6946,10 @@ static int ext4_statfs(struct dentry *dentry, struct kstatfs *buf)
 	buf->f_files = le32_to_cpu(es->s_inodes_count);
 	buf->f_ffree = percpu_counter_sum_positive(&sbi->s_freeinodes_counter);
 	buf->f_namelen = EXT4_NAME_LEN;
-	buf->f_fsid = uuid_to_fsid(es->s_uuid);
+	if (test_opt2(sb, NOUUID))
+		buf->f_fsid = u64_to_fsid(huge_encode_dev(sb->s_bdev->bd_dev));
+	else
+		buf->f_fsid = uuid_to_fsid(es->s_uuid);
 
 #ifdef CONFIG_QUOTA
 	if (ext4_test_inode_flag(dentry->d_inode, EXT4_INODE_PROJINHERIT) &&
-- 
2.43.0

