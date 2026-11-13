Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794571219;
	b=YFlqUEdfjeNCl98tVuXer2AFHuCo2X4jJMZ+z+VH0WgIFLo+BZNJJZunXXGzG2zoHpzz
	 v931JYBVBenrNkrb19KHHcbn4K7B+bDM4co/LluhHs9cDV7+LXiLBsBiBrOP9VVTzxPzC
	 gTJ9GE9EGU2hLsm/g4deWKM4ifqiDh3S77pIZNpnoay/Fk5GicSSnDIiJi2BgxsqRp/GR
	 NRf8DwyH+XHkJMbhYvPmDB3+08jKJt1ThVBmWQfsN9gk9ddCSIJjb/c4zpbkwxVIhaE1m
	 Lo08GzFbKTmEXVhdMYVyFZ+Djt9s5t+q4banqP5JcRT+2fGeCGJu3IfSBH2yHiaO8eQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794571219;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=lmd4fnAESC5s+S1auO0HRGz+bU+qihMAxFdeQVUo7iY=;
	b=M8gyHAbPBMEi7tyrrdC5hBkIeO0v5Htl8/EcvQHu9pXnw6em5M7a2XqeAFK8+E6uPWcr
	 OigVY4f6gU74g8W8u/0j6mzifIMgPA1Y0ftyD4fP39OVxuseKGrd6gfP5F82jgnOAlnG5
	 5XP9ReAkOGfHBb6LoL04VqhFt0+/JhMPKSLWTma6SQfJYVqOxBgkG81IUPEI/upRm6hdZ
	 yKcDKIZZvzBuqQFJCG9YH3ADzgeGJeGSnwfAh8U4aWEWx2rMvDiY0tvBcn0ieiOYEcAdb
	 G2+tiNXu9Rv/GzJApL5Sva1ydJT/2T3TL6c6OesCMV5tZjxZ5aPqOxsTpIvLHK8V6Mw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GTn2UBg5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6150C606A888;
	Fri, 13 Nov 2026 12:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GTn2UBg5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BB001F000CD;
	Fri, 13 Nov 2026 12:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794571219;
	bh=lmd4fnAESC5s+S1auO0HRGz+bU+qihMAxFdeQVUo7iY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=GTn2UBg5bwmUVXQO/l/ba5bU7JvnblZR6f7K8Cc/4UDIpbisDGUOWJtOTtUWlomC8
	 VoTwfmsqGlb34fjZGac21NjFClu/qAObLKxD5tGb1irA1w34zaFbLToPCCtUHK/TyS
	 TxRlzsEuQRKg9jvXiNWkhwn9qAKto3lYrXe+vG9WKGRsF8/fh++J0dWAH++mER+ing
	 9y7YaesnZpirMMeMVnQqx/ombJZ6cDiQavuu2lAPxAc+Oohj5LPdGFrh9XeRPoKI0f
	 S1Crb5FaAt16rrSx0O4hcFnQuFCYfEdZ516JjptC1aONpuXVNsCwZVO2XZlOzYkkNX
	 2Rs9VM5LgosKQ==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 13 Nov 2026 12:58:58 +0100
Subject: [PATCH v3 02/33] jfs: use jfs_symlink_inode_operations in
 jfs_iget()
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
Message-Id: <20261113-work-fs-sb_rdonly-v3-2-0be92bb73709@kernel.org>
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
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1129; i=brauner@kernel.org;
 h=from:subject:message-id; bh=JNfFHN04nudrc8oADaIN14/RzFJ3qnkM6OHZD27WnLA=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9+z17w2YfgQm3c9fKKT85PU0/OsvvnNxsGdf+1J8r5
 K1zg3u8OkpZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACby5j7DX5HJ5yzcGOUSeE7m
 ltbNm+AulPvoyXS3Y+ElWj+my5yd/JXhn9ml3bZNU1x3LBTU8mWI3fJ2iuiWyx55DcvlxH7wc6V
 O5AEA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

jfs_symlink() gives slow symlinks jfs_symlink_inode_operations but
jfs_iget() gives them page_symlink_inode_operations. So once the inode
has been evicted a chown doesn't go through jfs_setattr() anymore and
skips dquot_transfer(), and listxattr(2) doesn't see the symlink's
xattrs. Use jfs_symlink_inode_operations in jfs_iget() as well like it
already does for fast symlinks.

Fixes: c7f2e1f0ac14 ("jfs: add jfs specific ->setattr call")
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/jfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/jfs/inode.c b/fs/jfs/inode.c
index 6390d915c7f11..24b51461aacc9 100644
--- a/fs/jfs/inode.c
+++ b/fs/jfs/inode.c
@@ -47,7 +47,7 @@ struct inode *jfs_iget(struct super_block *sb, unsigned long ino)
 		inode->i_fop = &jfs_dir_operations;
 	} else if (S_ISLNK(inode->i_mode)) {
 		if (inode->i_size >= IDATASIZE) {
-			inode->i_op = &page_symlink_inode_operations;
+			inode->i_op = &jfs_symlink_inode_operations;
 			inode_nohighmem(inode);
 			inode->i_mapping->a_ops = &jfs_aops;
 		} else {

-- 
2.53.0

