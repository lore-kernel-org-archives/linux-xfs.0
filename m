Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793290076;
	b=1Y6AksAtljwSdYJaqYnWfRdqILXWjjcfSF2bna0X9zTtlD5q8NovMzWo6trhd2uY3BDp
	 Ww2wb/t9JvIZsB4i+u1k2HKQO6DMllcv2lYiRx3iBC2MipTE5L/TA2eebqGsb79BeFKAe
	 XlAuWDuDmmeZMAW8wnYDTuVjP7ul8S2fXq6SX3iTDJpoHiKwIXeVV7XjjRFD3SB7427QE
	 Cq94+DlqhguAo75Ue234QNiBQsp/OEshFYWGwe7zJG5D8HRPU12Eip1cVFsNqqk9Gr41J
	 M7pCG43nVz6xbQcLBf30PigZsXeJ41FLpdFR2TUHpDZ8c1a1z52ehU1Ml+rgghKqdoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793290076;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=zxzMnAfr+mLITGlXVw2HHwWaLKEq9rk+KQbTmA0gnZc=;
	b=GWXZOntutR0HNfkYNghhhfsz8ZzGsoTZe0FvSpigjY/fAd6m5h1YGLZWpY9XSDWfZgIf
	 09SmmJSrIye60kATp0dxulXqgqjTnukpxyXuewg/nTILiMI0ZgfF34BYgi8Pl75Ihc0Cb
	 JS7jY3M23hixnxsM3deDOxYJCYk8bVCsCLkNhcoouKYVgtcmS7j+tgBY/WTxlMdgzo8M6
	 IPHqQvdWb59DEIsx3RKoUFDyl8JrFu+4cinYDaVeZXLpTq7/OuG5u9lw916z3kH7VsSLI
	 Kg9bc1RurDcOinqGR1r2/9Gb9zE1j7lo1ci9hgVHofmdDVGbRfAEWnli5ckF4kxbqdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="lZ/NtxuW";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4668C60A2600;
	Thu, 29 Oct 2026 16:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lZ/NtxuW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3B3F1F01829;
	Thu, 29 Oct 2026 16:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793290075;
	bh=zxzMnAfr+mLITGlXVw2HHwWaLKEq9rk+KQbTmA0gnZc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=lZ/NtxuW+whuET0o12ey+U43ax2RjET2OlE1sxt2rJYT5lAhZhE7nCGkk3w6L4uwG
	 Gpv/NOomzhz109Zgzhq4ZopFhZ2MqmhhfkdciraP6cyN0KAKmTutcGeVw8Xkpm47h+
	 FdROUWFWq9PkGga8qYGhHhY5JrKfsEITLjdQLo1hWaee+eT0E47r3yYiQ+/tVof5F7
	 y9Fg4mwMp73+2lplQrwS8LKDTmw+4HTlimsHI+cMqnEXzXwpqtu0Hh1YDQkP1I24Jx
	 KHO1QAvKX55syZQXI09EsjRMmKBALzT1TAqTfLVEWIXBaCchpAjEV6fwXEikbormVj
	 gommYd3qzRDIw==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 29 Oct 2026 17:06:59 +0100
Subject: [PATCH v2 08/34] exfat: keep the current mount options on remount
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-work-fs-sb_rdonly-v2-8-2f44f64f0b66@kernel.org>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
To: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org, 
 linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
 linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, linux-mm@kvack.org, 
 ntfs@lists.linux.dev, ocfs2-devel@lists.linux.dev, 
 linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev, 
 linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, 
 linux-xfs@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=3964; i=brauner@kernel.org;
 h=from:subject:message-id; bh=mZbazIJ3QS8ZQ3YBus7040jsx8ku0rcjHK0u0BKdtWQ=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQ9ztfvmdgeu79zf5Tfy+ctSyx97ngf2HGVPWRfrAuD/
 OtDnxz/dJSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAExkWg3D/4gbJytOb0pfIrqu
 /PG8B9lxZzaeb1ZeLBr68J/43z6faRYM/1Qf1nipbj/0ZfLEa0cn9U5Ybb4iodhmjjoXt5SzQpP
 xeyYA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

exfat_init_fs_context() only inherits uid, gid, fmask and dmask for a
reconfigure. But exfat_reconfigure() refuses to change iocharset,
keep_last_dots, sys_tz, time_offset and allow_utime. So every remount
that doesn't repeat a non-default value for one of them fails with
EINVAL, including emergency remount (sysrq u) which passes no options at
all. And an option-less remount silently resets errors=, zero_size_dir
and discard.

So start a reconfigure from the current options like gfs2 does. The
iocharset string stays NULL in the new context because
->init_fs_context() runs without s_umount for mount(2) and a concurrent
remount could free it. It's only compared if the remount names one. A
shutdown turns discard off for good so exfat_reconfigure() keeps it off.

The next patch stops exfat from setting SB_RDONLY after errors. An
errored exfat then stays read-write and emergency remount would run into
this as well.

Fixes: e6fd5d3a4317 ("exfat: support modifying mount options via remount")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/exfat/super.c | 31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

diff --git a/fs/exfat/super.c b/fs/exfat/super.c
index 4943cef97741..44d2000007df 100644
--- a/fs/exfat/super.c
+++ b/fs/exfat/super.c
@@ -797,14 +797,12 @@ static int exfat_reconfigure(struct fs_context *fc)
 		mutex_unlock(&sbi->s_lock);
 	}
 
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
@@ -815,6 +813,10 @@ static int exfat_reconfigure(struct fs_context *fc)
 	    new_opts->allow_utime != cur_opts->allow_utime)
 		return -EINVAL;
 
+	/* A shutdown turned discard off for good. */
+	if (exfat_forced_shutdown(sb))
+		new_opts->discard = 0;
+
 	if (new_opts->discard != cur_opts->discard &&
 	    new_opts->discard &&
 	    !bdev_max_discard_sectors(sb->s_bdev)) {
@@ -823,6 +825,8 @@ static int exfat_reconfigure(struct fs_context *fc)
 	}
 
 	swap(*cur_opts, *new_opts);
+	/* The iocharset can't change, keep the current string. */
+	swap(cur_opts->iocharset, new_opts->iocharset);
 
 	return 0;
 }
@@ -849,23 +853,24 @@ static int exfat_init_fs_context(struct fs_context *fc)
 
 	if (fc->purpose == FS_CONTEXT_FOR_RECONFIGURE && fc->root) {
 		struct super_block *sb = fc->root->d_sb;
-		struct exfat_mount_options *cur_opts = &EXFAT_SB(sb)->options;
 
-		sbi->options.fs_uid = cur_opts->fs_uid;
-		sbi->options.fs_gid = cur_opts->fs_gid;
-		sbi->options.fs_fmask = cur_opts->fs_fmask;
-		sbi->options.fs_dmask = cur_opts->fs_dmask;
+		/*
+		 * Start from the current options so a remount only changes
+		 * what it specifies. The iocharset string stays with the
+		 * superblock, see exfat_reconfigure().
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

