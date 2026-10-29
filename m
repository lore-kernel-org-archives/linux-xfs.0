Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793290161;
	b=PDqKztAdoe2qw8arVZEMcX+hOftv5baPrp7Cr0doo9rVqpk3vNTtEIcWEUhw0Z/RUOZv
	 lrkpaxr9Slo12qPdBlz5/iWqV9cvRTj9MpDYzrdjdAUaGeieub4Drvg8wly7TGLWwHErU
	 XHm5NW4cVR6vC8J1d7npBtF8Hu0A8YxVc9o9Cdq+v0G34q6/g7qt0wa7yVBUtFBAvEFgL
	 6Ke1pb5wFAI0mnDXM2bamv4VaIbiCUciMiG58ESSayp/mHTuzrC8uY6Sa40zwUHbD+pjw
	 d6/mEyoAMeYF2QeFSUhOq1nwA/LVWjnMwUU6d/5gdORNShS8Q3a/XCQT4AAUNAi9lqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793290161;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=eQCxXsTbwof9FUg6Ix787w22LF6YubBqqIH8KJ6MCDE=;
	b=vkvi3GiFlMboLARAuSKWJr4dkG7U1fHz5rjKk4jwkZ/dawwpk8bt0Dy9XDCcGIzMVzw9
	 krTAUpH3kBa3mBptTcwih5Ozc+58zEkX5x79GuegrFdfXCwRPjc8HJRj1t6FjTYH2j89H
	 w5zVMQs4fTpR6UPyDwdU5gXYgWnQMuIy9fFwKG07AZxFIrcgsA4ybvLl0BorxcWFXMmjr
	 jM3I3J0Dz6dj0BTBta5R4oy7G1yc5cFJEQWtOhVWO+oHw27awKEbI/3tunPmB+rV2YeFz
	 mw/YL34Z2i1LWSGOCWMICkkNis5eM7I+MyKXSIqmz0WtA3x79sYIVGFTpWZtQvcs0ew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JPzI4b+4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0AA660A2607;
	Thu, 29 Oct 2026 16:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JPzI4b+4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F13B41F01824;
	Thu, 29 Oct 2026 16:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793290160;
	bh=eQCxXsTbwof9FUg6Ix787w22LF6YubBqqIH8KJ6MCDE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=JPzI4b+44MGHLq4Jf1Gd4otwA/YDDR9WxZIZKcBtPYvVLxg/NVjj0FSUl04NGD2UF
	 jW+QM9NGcJ8xak2TPxWrHzDPZWsqhQZpmf3e7baLAZcqmOEyqRQFv51S7CZqCBb4ac
	 L6XwWdAsCey9Ual2ko+9VwDzSQk3VqQaRkiLecBFhzzuVikzgtCdezSfjS6hRkvMLH
	 U/N7Ctvgg+K8gvHTFhjxufgGW2WB29OW4MRVU6GRO17sWpTay79NvLRfX8CghFCIEC
	 HxFOPT2Ot/wN3eHNjYIeDLuWrUzgbMFq3kzaw8rT4HrXFXsFEIClPDfvwd6J1cAeEm
	 8E2KYC0d+8GfA==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 29 Oct 2026 17:07:19 +0100
Subject: [PATCH v2 28/34] ubifs: don't set SB_RDONLY after errors
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
Message-Id: <20261029-work-fs-sb_rdonly-v2-28-2f44f64f0b66@kernel.org>
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
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=2955; i=brauner@kernel.org;
 h=from:subject:message-id; bh=/l/eYRwD7NiCvHpR0M4Ent49C5EEBbats3rfxEZnvhM=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQ9zjc437ZtHl/b8osXnrN8PqroI20dtn0u773jdfe+R
 in93ha3vaOUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAiqx8y/I8+fdTck0/0T9Sm
 R2ZFJzZ1leZviTm5Wqdaa8P/dzYRjCYM/9RevWHu7F/ra+K9+1tjgk3Rmwynj2dXLHg2QdjwwLR
 FJUwA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

ubifs_ro_mode() sets c->ro_error and SB_RDONLY from whatever context hit
the error, e.g. a failing write, and without holding s_umount. UBIFS
can't be frozen but that still races with everyone else changing
sb->s_flags. And c->ro_error alone already makes every write fail with
EROFS.

So only set SB_RDONLY while the filesystem is still being mounted and
call sb_set_emergency_ro() after that. The xattr setters check
c->ro_error as well because ecryptfs calls them without write access on
the lower mount and they change the inode in memory first.

So far a remount to read-only after an error was refused and a remount
to read-write went through and cleared SB_RDONLY again because
c->ro_mount was never set. Now going read-only works and its writes fail
with EROFS before any I/O, and going read-write is refused by the VFS.
fsync() fails with EROFS instead of taking ubifs_fsync()'s read-only
shortcut.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/ubifs/io.c    | 9 ++++++++-
 fs/ubifs/super.c | 5 +----
 fs/ubifs/xattr.c | 6 ++++++
 3 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/fs/ubifs/io.c b/fs/ubifs/io.c
index 6c6d68242779..7a59aa1ea5ce 100644
--- a/fs/ubifs/io.c
+++ b/fs/ubifs/io.c
@@ -72,7 +72,14 @@ void ubifs_ro_mode(struct ubifs_info *c, int err)
 	if (!c->ro_error) {
 		c->ro_error = 1;
 		c->no_chk_data_crc = 0;
-		c->vfs_sb->s_flags |= SB_RDONLY;
+		/*
+		 * Before SB_BORN the mounter holds s_umount, later see
+		 * sb_set_emergency_ro().
+		 */
+		if (!(c->vfs_sb->s_flags & SB_BORN))
+			c->vfs_sb->s_flags |= SB_RDONLY;
+		else
+			sb_set_emergency_ro(c->vfs_sb);
 		ubifs_warn(c, "switched to read-only mode, error %d", err);
 		dump_stack();
 	}
diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index 38972786817e..ef39da4e780b 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -1977,10 +1977,7 @@ static int ubifs_reconfigure(struct fs_context *fc)
 		if (err)
 			return err;
 	} else if (!c->ro_mount && (fc->sb_flags & SB_RDONLY)) {
-		if (c->ro_error) {
-			ubifs_msg(c, "cannot re-mount R/O due to prior errors");
-			return -EROFS;
-		}
+		/* After an error ubifs_remount_ro() can't write but still works. */
 		ubifs_remount_ro(c);
 	}
 
diff --git a/fs/ubifs/xattr.c b/fs/ubifs/xattr.c
index 3b0e8a270f59..572f6f3e52ad 100644
--- a/fs/ubifs/xattr.c
+++ b/fs/ubifs/xattr.c
@@ -260,6 +260,9 @@ int ubifs_xattr_set(struct inode *host, const char *name, const void *value,
 	if (check_lock)
 		ubifs_assert(c, inode_is_locked(host));
 
+	if (c->ro_error)
+		return -EROFS;
+
 	if (size > UBIFS_MAX_INO_DATA)
 		return -ERANGE;
 
@@ -564,6 +567,9 @@ static int ubifs_xattr_remove(struct inode *host, const char *name)
 
 	ubifs_assert(c, inode_is_locked(host));
 
+	if (c->ro_error)
+		return -EROFS;
+
 	if (fname_len(&nm) > UBIFS_MAX_NLEN)
 		return -ENAMETOOLONG;
 

-- 
2.53.0

