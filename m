Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794571254;
	b=2b0G4Sg7AOz7B6d4+DcaF0zMV3oXEmzTYzshr/03k/F/1E/2cbJ3mt4h6dY9G0WrJNHL
	 +OVvVQNpsMmxkPNHbxq2/pHQgEejnJEhaoK96ZAeIVZtAAwX81yLfIDt93FeYIYOCLcEm
	 00sOfBePc+mRHvO5bt6gq0M7zx5ekhHwB3NkRnzAp8FR0ZNg0t2NaK2/4fst0c1AiYwfR
	 irje1rX/FBsZASt0R224u9E0nbNY44kNCyQ6+btVD/uBUkQdcoUgRrNqIxC6+R+6f97jU
	 Ty46S6pp2hbHtkq5oAx1sCZO05zzp9lH97U5FdncjnTeMdaS2l26AysO04XWMu45i8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794571254;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=Ypt6ULu3JwdPcJUCYN4Pu3PAb0qap28rHPCyQWyGM7s=;
	b=KATqCNLwuWS+f9IMrK1ZHZeP2zWjgMSMFw/l3Tzw1Iv0iy7RPU0o8urkbeAPwkyWiwF4
	 pJSUejndUgIikxafiBorAOaaNmXoRnAZ4dgcioeHHUc4cjITSxFNim/qx827x5k0q6y9Y
	 aOADHMRGGCDnxYpgKXWlQi4Tf+8ptd84ymTL0G2QJrzAVUNtmqy15rkTAChJt7lnLSYZp
	 /btvUl+5RnU06BBks243b0V7zF0riA8pzSSr0pnWjhwjzMF+2ecLDMZUS1j0f/JT4tuNV
	 2CiByrVF997mDBnSyyHh3Mgqi+4s0rpSw4XOxbgz3tPUOqHIVYqx1sjHKxYWuWYxjWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WAJ2uDjA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97C28606A337;
	Fri, 13 Nov 2026 12:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WAJ2uDjA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59C001F000C4;
	Fri, 13 Nov 2026 12:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794571254;
	bh=Ypt6ULu3JwdPcJUCYN4Pu3PAb0qap28rHPCyQWyGM7s=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=WAJ2uDjAWudaH8KPpTusxWD5T3lyda66Qun0huxINDe2hQlZsWqFpuproeFGHqH9l
	 qgVPMsSmjd15IllLkxMEHr1fu68/jaHjUmhyQl+GSlICHMsh8INQwIwoYZ+KZEbzXH
	 MZsQSnDpkE/5CUquOzq8zpDYEE/XneMMYIhr1I6weg7CiGvwKHLTLDm1KliMI21XRp
	 XmyAwx59+M70ZeTKRl9Mt35u8qedo9LKYI3dy5hMpdmBRemUM7/zhtPDhVttb8LSQ5
	 sT9VbWwKFSYZZ5iB+w9HJJj3mZIROf/grZRgKjY4FC62T1nN82taUsbfoZvaZSpxPB
	 Vorm2daFZNsSg==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 13 Nov 2026 12:59:06 +0100
Subject: [PATCH v3 10/33] exfat: keep the current mount options on remount
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
Message-Id: <20261113-work-fs-sb_rdonly-v3-10-0be92bb73709@kernel.org>
References: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
In-Reply-To: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3966; i=brauner@kernel.org;
 h=from:subject:message-id; bh=xVd1t6ge+zArPbkQcafgR82XBzAI62aSa6+KImihqMQ=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9+730sNAfFnlho9cqhmKf3s/ePfn7RIU7t9QLoqcfn
 PxnMsO06o5SFgYxLgZZMUUWh3aTcLnlPBWbjTI1YOawMoEMYeDiFICJxL9nZOirrgy6Neuj+pu6
 QyeaP+ac5U09tzpWyOSx1QeXNTqrgxMY/opOem3tX7bb9f6lxXcZs084a6lu3JJzQv2nduniah3
 53cwA
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
index 4943cef977418..44d2000007dfb 100644
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

