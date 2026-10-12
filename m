Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EC033F4DCA;
	Mon, 12 Oct 2026 10:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791800490; cv=none; b=f7KkYBjx8q0DcXkqWMk4PFaTL0MjKlxN9xlLaG6QyJ6KXIkZlb2Hm//ELJYFLX+qNrtx6FrrhvWcMDGqdYcLGfggzPnsCTZkjYUqp3o/L7nU64oRTE2AyLddJd3SivGUkE8N5a/GIcxxDO9p4WhEt8qsIp7UrJ8qzwQqpQQoT5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791800490; c=relaxed/simple;
	bh=FHwfq/OCDsnntrfJYkKn8tLOjs4Tv7YHZV8JitYQDQ0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=llHmXC+YlFhxReQ+rBpOwfXrUggAXxiutyzHwER/gdhdOZULL9JInaAX+tBU0WNtkK+y/kuXR4AKWIl8bwRcC8mqj8RmXRJen71R5nn89q49m2v1txB5bxEBlCdTCE7mEC0G7dOGAeoRpIHHbRcWfn/e0xGpvYmQyx/l2oIl9Bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=daD9kmOa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="daD9kmOa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07DB31F0089C;
	Mon, 12 Oct 2026 10:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791800478;
	bh=jSaTeXy5zEI39kgqqTi6yfSkP3Kgm5wm6RfoGXruvqg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=daD9kmOaoDrecEZ+GKWXxyW9H20UJr48DcxIiw0e65dcl8QTST3JZXcj61YvqNTyb
	 c5d34ADQW1FTC40OtFvDZ/r1oWnvdCTDB2nBPiUWZpsdvr64rU3yyTUZCbQmtT/WHN
	 M4L3IE8ZFu/uZjDyHAoHWVVDuNF/pppyPWohHYEa4Yvx8fprF5PUJYsVDI169f9kxo
	 jBe+V1vSuEX9xF71FfYPmOVHGKSg4cEB3pIABRCDPA7K95hBDggmzUqYSJbpYomakn
	 PXM0tJDgLdWEhvw5L8NTowb8aNFn6hJrwa/MlDBOPgqwCRarNEsyBQ1YwBmx0RfVjr
	 WbnHd24KBBfVA==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 12 Oct 2026 12:20:46 +0200
Subject: [PATCH RFC 01/28] ecryptfs: don't leak the inode when a lookup
 can't open the lower file
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261012-work-fs-sb_rdonly-v1-1-60743a3dc326@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1919; i=brauner@kernel.org;
 h=from:subject:message-id; bh=FHwfq/OCDsnntrfJYkKn8tLOjs4Tv7YHZV8JitYQDQ0=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSd2TJJmlVX9PaCsIn+FsHZwuxHGEpPFCj+mriqsDrpf
 qGIfFJFRykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwETcDjD8sz1q8vHQt6fh7p09
 uT08PmKLO9tkzFMehF2fYnDC/qOTC8P/xLgFX20+PbiQ+CC39cSDhwe1Dlq6qHKtT7/euMmvwfE
 UHwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

ecryptfs_lookup_interpose() opens the lower file of a regular file to
read the size from the header. If that fails it calls make_bad_inode()
and returns the error. A new inode is still I_NEW at that point and
nothing ever unlocks or puts it, so it leaks together with the reference
it holds on the lower inode. And an inode that was already in the cache
gets marked bad for all its other users instead of just losing the
reference this lookup took.

umount then complains:

  VFS: Busy inodes after unmount of ecryptfs (ecryptfs)

That's a WARN, or a BUG with CONFIG_BUG_ON_DATA_CORRUPTION. The lower
filesystem reports the same when it is unmounted. Use iget_failed() for
a new inode and iput() for one from the cache.

Reproducer, opening the lower file read-write fails on a read-only bind
mount:

  sig=$(printf x | ecryptfs-add-passphrase - | sed -n 's/.*\[\(.*\)\].*/\1/p')
  mount --bind -o ro /lower /lower
  mount -i -t ecryptfs -o ecryptfs_sig=$sig,ecryptfs_cipher=aes,ecryptfs_key_bytes=16,ecryptfs_passthrough /lower /upper
  cat /upper/f      # EROFS
  umount /upper     # VFS: Busy inodes after unmount of ecryptfs

Fixes: 3b06b3ebf441 ("eCryptfs: Fix new inode race condition")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/ecryptfs/inode.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index 525297c7ebd8..0d8452558a98 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -362,7 +362,10 @@ static struct dentry *ecryptfs_lookup_interpose(struct dentry *dentry,
 	if (S_ISREG(inode->i_mode)) {
 		rc = ecryptfs_i_size_read(dentry, inode);
 		if (rc) {
-			make_bad_inode(inode);
+			if (inode_state_read_once(inode) & I_NEW)
+				iget_failed(inode);
+			else
+				iput(inode);
 			return ERR_PTR(rc);
 		}
 	}

-- 
2.53.0

