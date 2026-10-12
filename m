Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D7213F8707;
	Mon, 12 Oct 2026 10:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791800514; cv=none; b=oUtbu+ItM9Du/2R/T6r489kr5XOltw9NKHZ1JChNzWU2esnGsyUjWHjG2y+y+k1z/oeyDNcy/jPTrrJWsgTbkGgbspCywSfYbR6Esuezgs4yjyFLB9SA/SvP/zlhJsv4vWPkvAfIbAHG+eMimuMouF2YtQi61kImx3s4gp17pGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791800514; c=relaxed/simple;
	bh=3iMWmfvmCuAdq5v+SaSeEIdfuzYc4xAqqIwykSe1fjo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=omWv5BLAc+EOz9dSpKvZcJmc9dQXhuH16LvRHsi8XgrHVZLJz5cqwb9kVj2aSC0J003S7uS1Z/4jlsuqh1VVHtZtebmm8ErmVwW3ST3/3++rD5D6no52BK7RllwqpXyGPQaQOYtJTb8bPIVH3g7V70sizIR0+3Lz54290EYiZzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m4azUks+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m4azUks+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F7D91F0089E;
	Mon, 12 Oct 2026 10:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791800503;
	bh=X/NeEkjlYYb7QCBaqw/bOK1fqIFnvJqV0IiLIukJrsk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=m4azUks+ewFwlZJu0iG4zBG0dU7hFBBsZMlUUKHQ4pmbPgjBL852agDkDkV61J+r7
	 TOepxKYl6Qy3po1Cv815gK7mEuJ0zQa3rxsZnRNXT/le8f+EfbovYsp6RTmehktUjo
	 IXWuu+yE9OMh1pY7hv6rXZ9CRNxkI641H9hme21MOshUUJNtH2gfAxjmo6Gm+JD3vt
	 gwQKkfrbLvbJsgk5XXdeVk6uRhVYHD+IOw1RziyNJRv+QGoG6403wHjLBvzZbGlWtq
	 Ibo0nIBuW+dNLcaQx4T6SQMvi7NeUMCB82DC9q7M2aZ/ctq1CElboUbs7cMO033InJ
	 8pSbyQlvixX4A==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 12 Oct 2026 12:20:52 +0200
Subject: [PATCH RFC 07/28] exfat: keep the current mount options on remount
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261012-work-fs-sb_rdonly-v1-7-60743a3dc326@kernel.org>
References: <20261012-work-fs-sb_rdonly-v1-0-60743a3dc326@kernel.org>
In-Reply-To: <20261012-work-fs-sb_rdonly-v1-0-60743a3dc326@kernel.org>
To: Jan Kara <jack@suse.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org, 
 linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
 linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, 
 linux-fsdevel@vger.kernel.org, ntfs@lists.linux.dev, 
 ocfs2-devel@lists.linux.dev, linux-btrfs@vger.kernel.org, 
 gfs2@lists.linux.dev, linux-efi@vger.kernel.org, 
 linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.17-dev-3d1b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=5637; i=brauner@kernel.org;
 h=from:subject:message-id; bh=3iMWmfvmCuAdq5v+SaSeEIdfuzYc4xAqqIwykSe1fjo=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSd2TJJzNP/8IkFC/9u3bx8/rrG8iMzI6xff921NdA9z
 eKCSfAHhY5SFgYxLgZZMUUWh3aTcLnlPBWbjTI1YOawMoEMYeDiFICJzLZhZPj2cibfvczKV3P7
 TdpmyHG8yDsrkZ/5ed/7/oWNM9tUjlkwMvww1jc6PNkw8tnKMx1/ns3c4+eZPIt/e+XB5PvpTAU
 +v7kB
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

exfat_init_fs_context() only inherits uid, gid, fmask and dmask from the
mounted superblock for a reconfigure and everything else starts out with
its default. But exfat_reconfigure() refuses to change iocharset,
keep_last_dots, sys_tz, time_offset and allow_utime and returns -EINVAL
if any of them differs. So on an exfat that was mounted with a
non-default value for one of them every remount fails that doesn't
repeat it. That includes emergency remount (sysrq u) which passes no
options at all and reconfigure_super() warns about it:

  forced remount of a exfat fs returned -22
  WARNING: fs/super.c:1133 at reconfigure_super+0x498/0xb20, CPU#3: kworker/3:1/54

The options that can change on remount have the opposite problem. An
option-less remount silently resets them to their defaults. So
errors=continue turns into errors=remount-ro and zero_size_dir and
discard are dropped.

So start a reconfigure from the current options instead, like
gfs2_init_fs_context() does. Then a remount only changes what it
specifies. The iocharset string is the exception. For mount(2)
->init_fs_context() runs without s_umount and a concurrent remount could
free the string while we copy it. And we can't take s_umount there
because emergency remount already holds it. So leave it NULL in the new
context, only compare it in exfat_reconfigure() if the remount names
one, and keep the superblock's string when the options are swapped. All
of that happens under s_umount.

Note that a shutdown turns discard off for good. But the context of a
remount may have been set up before the shutdown and would turn it back
on. So exfat_reconfigure() keeps discard off once the filesystem was
shut down.

The next patch stops exfat from setting SB_RDONLY after errors. An
errored exfat then stays read-write as far as the VFS is concerned and
emergency remount would run into this for it as well.

Reproducer:

  mount -t exfat -o iocharset=iso8859-1 /dev/vdb /mnt
  echo u > /proc/sysrq-trigger    # "forced remount of a exfat fs returned -22"

  mount -t exfat -o errors=continue /dev/vdc /mnt2
  # remount through mount(2) without data, e.g.
  # mount(NULL, "/mnt2", NULL, MS_REMOUNT | MS_RDONLY, NULL)
  grep /mnt2 /proc/mounts          # errors=remount-ro

Fixes: e6fd5d3a4317 ("exfat: support modifying mount options via remount")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/exfat/super.c | 37 ++++++++++++++++++++++++-------------
 1 file changed, 24 insertions(+), 13 deletions(-)

diff --git a/fs/exfat/super.c b/fs/exfat/super.c
index a9ea36ba2693..71a348d10c26 100644
--- a/fs/exfat/super.c
+++ b/fs/exfat/super.c
@@ -779,14 +779,12 @@ static int exfat_reconfigure(struct fs_context *fc)
 	exfat_clear_volume_dirty(sb);
 	mutex_unlock(&sbi->s_lock);
 
-	if (new_opts->allow_utime == (unsigned short)-1)
-		new_opts->allow_utime = ~new_opts->fs_dmask & 0022;
-
 	/*
 	 * Since the old settings of these mount options are cached in
 	 * inodes or dentries, they cannot be modified dynamically.
 	 */
-	if (strcmp(new_opts->iocharset, cur_opts->iocharset) ||
+	if ((new_opts->iocharset &&
+	     strcmp(new_opts->iocharset, cur_opts->iocharset)) ||
 	    new_opts->keep_last_dots != cur_opts->keep_last_dots ||
 	    new_opts->sys_tz != cur_opts->sys_tz ||
 	    new_opts->time_offset != cur_opts->time_offset ||
@@ -797,6 +795,10 @@ static int exfat_reconfigure(struct fs_context *fc)
 	    new_opts->allow_utime != cur_opts->allow_utime)
 		return -EINVAL;
 
+	/* A shutdown turned discard off for good. */
+	if (exfat_forced_shutdown(sb))
+		new_opts->discard = 0;
+
 	if (new_opts->discard != cur_opts->discard &&
 	    new_opts->discard &&
 	    !bdev_max_discard_sectors(sb->s_bdev)) {
@@ -805,6 +807,11 @@ static int exfat_reconfigure(struct fs_context *fc)
 	}
 
 	swap(*cur_opts, *new_opts);
+	/*
+	 * The iocharset can't change, keep the current string. The new
+	 * options have none if the remount didn't specify one.
+	 */
+	swap(cur_opts->iocharset, new_opts->iocharset);
 
 	return 0;
 }
@@ -831,23 +838,27 @@ static int exfat_init_fs_context(struct fs_context *fc)
 
 	if (fc->purpose == FS_CONTEXT_FOR_RECONFIGURE && fc->root) {
 		struct super_block *sb = fc->root->d_sb;
-		struct exfat_mount_options *cur_opts = &EXFAT_SB(sb)->options;
 
-		sbi->options.fs_uid = cur_opts->fs_uid;
-		sbi->options.fs_gid = cur_opts->fs_gid;
-		sbi->options.fs_fmask = cur_opts->fs_fmask;
-		sbi->options.fs_dmask = cur_opts->fs_dmask;
+		/*
+		 * Start from the current options so a remount only changes
+		 * what it specifies. exfat_reconfigure() refuses to change
+		 * most of them, so a remount that doesn't repeat them all
+		 * would fail, e.g. emergency remount which passes none. The
+		 * iocharset string stays with the superblock and is only
+		 * compared if the remount names one, see exfat_reconfigure().
+		 */
+		sbi->options = EXFAT_SB(sb)->options;
+		sbi->options.iocharset = NULL;
 	} else {
 		sbi->options.fs_uid = current_uid();
 		sbi->options.fs_gid = current_gid();
 		sbi->options.fs_fmask = current->fs->umask;
 		sbi->options.fs_dmask = current->fs->umask;
+		sbi->options.allow_utime = -1;
+		sbi->options.errors = EXFAT_ERRORS_RO;
+		exfat_set_iocharset(&sbi->options, exfat_default_iocharset);
 	}
 
-	sbi->options.allow_utime = -1;
-	sbi->options.errors = EXFAT_ERRORS_RO;
-	exfat_set_iocharset(&sbi->options, exfat_default_iocharset);
-
 	fc->s_fs_info = sbi;
 	fc->ops = &exfat_context_ops;
 	return 0;

-- 
2.53.0

