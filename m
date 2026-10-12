Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C400B3D6CA5;
	Mon, 12 Oct 2026 10:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791800493; cv=none; b=nIL95eCpkl8KrSxVPlr1fkq+F+xJfXjldbvrNuWFMl/+nDfPwckCMMr1i39bHhs0lOltDQzJSkdGEUWhA+/2xFa1V8cJOauHDcQGqK0dHuXjC+KxeUDk98yjfPp4bOAAIbQ1YEBAaP5jE5NqPdyWP/xF1RFrncTFRjZhgw4ZoIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791800493; c=relaxed/simple;
	bh=d4DV3ux+YqNZSwnqbBQiz2kxcDy+uUjQAoj3knRirZc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=HFLRfMg1uByvq0JpBkGrGB2a/jlz4L2mJxX+nlWFz6Jhd81Q42pNWaizgPiNV31WYkBCSYTkLgdD2Wu1J8c+GV8YdZLjHzJnjnYRMVGMOYbYJKY0wGfJTTcPBNcYVfMG/QOLx7tHKbVKloI87s6UbgrH4te26N2KWnZQ82b/rjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g0UxJmEz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g0UxJmEz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23E421F0089D;
	Mon, 12 Oct 2026 10:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791800482;
	bh=ICZn17F2Qr1X/UcceZ9Xh+NsEcH0M5p2m4jZVNK55KU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=g0UxJmEzdyfUNiNQFIlrTFJ4b2QMSnKfjzzfqPjucOeB7magi9V/kezyJu6R8lLmW
	 5sHP0dy+ooX22UL76Mn6Ig4IU9RLQtMMY4tOEhL2pDyEPTN95tJLEiRQMUimGQkShR
	 iZvC4WLmJhQgjbvA2LuTISoc7qjNQl6pBicsiTfqLxgKDjlOCCdNlW4bN524TTABZS
	 UVMFT66mgA/1LJjmAZNQRqSjYUMCjOJqjB8Gp88OWutDuzQ56ZgMxBfiuVApEPx5kn
	 Qs3IumkvEI4gAE38fP3hMdxjKtSwIJCqQ/M1R/dZ9S+oojJKed2pi4ANX7Xgw/lf7I
	 N7/j/BB5Y4muw==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 12 Oct 2026 12:20:47 +0200
Subject: [PATCH RFC 02/28] ecryptfs: fall back to a read-only lower file
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261012-work-fs-sb_rdonly-v1-2-60743a3dc326@kernel.org>
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
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-3d1b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=3015; i=brauner@kernel.org;
 h=from:subject:message-id; bh=d4DV3ux+YqNZSwnqbBQiz2kxcDy+uUjQAoj3knRirZc=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSd2TLJICW/8hrXjx/Ldws/XrCs8MZc3ZN3/ud2ieUq5
 O/L+Bhh31HKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjAREz5GhgWGG6KDt2zoSozU
 sA7/e6XfdhXflaoT5+s0nqRkzHvvtISR4bO9X/sly5MVnAmuoWuucH/wlXm9e63liY1mGUIhKfV
 L+QA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

ecryptfs opens the lower file read-write unless the lower inode is
IS_RDONLY(). But a filesystem whose superblock is read-write can still
refuse to open a file for writing. A read-only mount underneath does
that with EROFS, and so does ext4 after an error since commit
d3476f3dad4a ("ext4: don't set SB_RDONLY after filesystem errors"). The
retry through the kthread opens read-write as well and fails the same
way. Then every lookup of a regular file fails with EROFS because
ecryptfs can't read the header, and nothing can be read through
ecryptfs anymore.

The filesystems that still set SB_RDONLY after an error are about to
stop doing that as well. So far ecryptfs opened their files read-only
after an error. Fall back to that on EROFS. Opening an ecryptfs file for
writing then fails with EPERM like it does on top of a read-only
superblock.

Reproducer:

  sig=$(printf x | ecryptfs-add-passphrase - | sed -n 's/.*\[\(.*\)\].*/\1/p')
  mount --bind -o ro /lower /lower
  mount -i -t ecryptfs -o ecryptfs_sig=$sig,ecryptfs_cipher=aes,ecryptfs_key_bytes=16,ecryptfs_passthrough /lower /upper
  cat /upper/f      # before: EROFS, after: works

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/ecryptfs/kthread.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/fs/ecryptfs/kthread.c b/fs/ecryptfs/kthread.c
index ae4cb4e2e134..ba94b304edf3 100644
--- a/fs/ecryptfs/kthread.c
+++ b/fs/ecryptfs/kthread.c
@@ -30,6 +30,21 @@ static struct ecryptfs_kthread_ctl {
 
 static struct task_struct *ecryptfs_kthread;
 
+/*
+ * A filesystem can refuse writes while its superblock stays read-write, e.g.
+ * after an error, and a read-only mount refuses them as well. Reading still
+ * works so fall back to that.
+ */
+static struct file *ecryptfs_open_lower(const struct path *path, int flags,
+					const struct cred *cred)
+{
+	struct file *file = dentry_open(path, flags, cred);
+
+	if (PTR_ERR_OR_ZERO(file) == -EROFS && (flags & O_ACCMODE) == O_RDWR)
+		file = dentry_open(path, (flags & ~O_ACCMODE) | O_RDONLY, cred);
+	return file;
+}
+
 /**
  * ecryptfs_threadfn
  * @ignored: ignored
@@ -59,7 +74,7 @@ static int ecryptfs_threadfn(void *ignored)
 					       struct ecryptfs_open_req,
 					       kthread_ctl_list);
 			list_del(&req->kthread_ctl_list);
-			*req->lower_file = dentry_open(&req->path,
+			*req->lower_file = ecryptfs_open_lower(&req->path,
 				(O_RDWR | O_LARGEFILE), current_cred());
 			complete(&req->done);
 		}
@@ -132,7 +147,7 @@ int ecryptfs_privileged_open(struct file **lower_file,
 	 * lower file is fput() when all eCryptfs files for the inode are
 	 * released. */
 	flags |= IS_RDONLY(d_inode(lower_dentry)) ? O_RDONLY : O_RDWR;
-	(*lower_file) = dentry_open(&req.path, flags, cred);
+	(*lower_file) = ecryptfs_open_lower(&req.path, flags, cred);
 	if (!IS_ERR(*lower_file))
 		goto out;
 	if ((flags & O_ACCMODE) == O_RDONLY) {

-- 
2.53.0

