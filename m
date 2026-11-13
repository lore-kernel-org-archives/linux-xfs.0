Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794571350;
	b=nWsjGhAEvEAkR3e0RyxSOBBdrC9QljUVy7+iCX673dN+SyK7DJpRUtyXUzb9dTKtjl3P
	 V7WLN6J5ui9pNLObkmF/fZ0EQIHtFHF9kgVWG06MHsksVE+gXAExU7fGif5awqUX3BfTq
	 5qD+iw+9PJk/y5SqXi30wkSjLNCqoc0fXfUBli8HSVmujzOu3CCxHyDE3vhig3tH8Dafn
	 A8oJoFI8LJtVZwRRIz94R6hbSzKaVxcJ09pZNzoZb48ivAixmiQywUxANg7t3RQEEQR1m
	 ASQQ1sP+Idj8wx4AeJXx6Q7kK4HcISugZHQTDhlG1UuxfI2/PV7JQv/mYG1KUSlc44Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794571350;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=Qt0v88hxlQUHI5QSZLphXypscQRdWRHgm1ofeIg78vE=;
	b=V8xy0RDNBMl6ViBhLkYUFjsFimPLQ88Ao4/7rhdUM8X/RZEx7notYmwDfK5uNPQKEuzi
	 emI3K3rmSgOZZkrG/WAdzrcv5wUw2EnXp7ti5+l16VCUa/lgtyH3+ww4mIj3QP6XqIVWt
	 yee6QE8ST79kXLp26AktI/t65fCexU1xrtMiag1u21QIwTBf+I/b+00U/6lBWdL0xlbDs
	 YGAbQmggNG0BTpdHSXWowcurwLAPSEjAQwCKnOVgdXpuB0vjxG7CQhzeKoRc2v7otykDj
	 29BABbrufEMztosAQr6q4g4q6d1UxwLn1w91vt4gjva8klxbDEDe3KV+EOsw7pkRyVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mwYSclny;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2217606B58E;
	Fri, 13 Nov 2026 12:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mwYSclny
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C5F71F000C5;
	Fri, 13 Nov 2026 12:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794571350;
	bh=Qt0v88hxlQUHI5QSZLphXypscQRdWRHgm1ofeIg78vE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=mwYSclnymZN538OO44zhjeiEF6ZBwOXg+mNWuDn2mVMpnozTukYByPU2VgZwWVlDc
	 8xvcI8z68lxnamK03WoMc/sB/4yH0m1mIAy22y/0RN0mL5Pip9ZsoY8rM536vNcpRO
	 Fp9Yfhil3dDe21+/vxCwhBUlwdHiJ8sYmcN3wgI//hBpOa9+a8+MZggxdslsmwdHKk
	 /PtldJ1cR3JjJTGX1l58yZ4uFbBE56y458DWqBNcap2sbf7u7VQmpCwLN2C7t+Xkv5
	 EoeS8LhRnwEcexIRsxUlQqnxWH0U01IxyKtPS18Og0Ph9Um1ZWSD3IiKJYuaOlhIMx
	 m5h4cQZ/ZZhIw==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 13 Nov 2026 12:59:28 +0100
Subject: [PATCH v3 32/33] ext4: use the generic emergency read-only state
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
Message-Id: <20261113-work-fs-sb_rdonly-v3-32-0be92bb73709@kernel.org>
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
 "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 Jan Kara <jack@suse.cz>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1968; i=brauner@kernel.org;
 h=from:subject:message-id; bh=zrZfOrGsMUXliH43rTDbUbAuKN/ihY34a/GnGYlk2N0=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9+70/IHPi5j8ze6a9MUj6Ed4VbFn6fMHhxGfa69pff
 LpexvHrSEcpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBEBJcwMkz8vWXzrYkLLY+d
 Whp69v8jweSr7KumH5kkxXtikSHHrzwLhv8Bj4w+WD5692yWYNEenn+bWBdNqHVfUBEgWtKXeyj
 xXBcvAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Set SB_STATE_EMERGENCY_RO next to EXT4_FLAGS_EMERGENCY_RO when an error
makes the filesystem read-only. The VFS then refuses modifications
before they reach ext4 and reports the superblock as read-only like it
did when ext4 still set SB_RDONLY. The shutdown state stays ext4's own
and so do all of ext4's checks because they cover both states. ext4
keeps showing "emergency_ro" in its mount options.

EXT4_IOC_SHUTDOWN with EXT4_GOING_FLAGS_DEFAULT fails after an error on
mainline today because ext4_sync_fs() fails the freeze. freeze_super()
refuses it in the emergency state now. ext4 refuses writes in that state
anyway and the journal is aborted, so shut down without the freeze like
EXT4_GOING_FLAGS_NOLOGFLUSH does.

Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/ext4/ioctl.c | 4 ++++
 fs/ext4/super.c | 1 +
 2 files changed, 5 insertions(+)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index e8e579498c990..ce0e0ebdded61 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -821,6 +821,10 @@ int ext4_force_shutdown(struct super_block *sb, u32 flags)
 	ext4_msg(sb, KERN_ALERT, "shut down requested (%d)", flags);
 	trace_ext4_shutdown(sb, flags);
 
+	/* After an error there is nothing to flush and freezing fails. */
+	if (flags == EXT4_GOING_FLAGS_DEFAULT && ext4_emergency_ro(sb))
+		flags = EXT4_GOING_FLAGS_NOLOGFLUSH;
+
 	switch (flags) {
 	case EXT4_GOING_FLAGS_DEFAULT:
 		ret = bdev_freeze(sb->s_bdev);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index ae5ba6823c01c..afbdbb607b144 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -757,6 +757,7 @@ static void ext4_handle_error(struct super_block *sb, bool force_ro, int error,
 	 * and other problems.
 	 */
 	set_bit(EXT4_FLAGS_EMERGENCY_RO, &EXT4_SB(sb)->s_ext4_flags);
+	sb_set_emergency_ro(sb);
 }
 
 static void update_super_work(struct work_struct *work)

-- 
2.53.0

