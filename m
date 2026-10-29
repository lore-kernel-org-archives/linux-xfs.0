Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793290050;
	b=OT3YBAo2PJO47RwdLr0/IFuEkVjMNvXGcpqlqwFB3xt9+n0RiJGteU1FoYFN6RXBInil
	 ndBVY6HQwH7Y2gaL+DkVwuujzN+7tIDPtlpefm+EcK2XAID2gccU9c7TQFQn1suN3f/Mb
	 huIFlg1WKBXxH41Q9uKirBaTg1WrG4Xpev4d3j5kgwF+5pKpTAeCMylMVtFuXCJaYzlIU
	 zbxRE/i/hbjAW4nVBFYpN+GH80XG8LMMfhQjLrWnAYaksS8kYamhXAjDgAfjiEvMq+VM0
	 zCDgGHSMEvkNZvLtZ9/5R5tNcpIYfAEuv8VYIHVEEOGo3XfcYrwXXHSajJ4sCdkdi7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793290050;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=AsodWLg6d4leaTd8y1mFAnryBLI0o8mneeaJ96WpEgw=;
	b=S556FIXqUUSqq6nz+YBrzuuE7T0P6fXU0AoYUhruCbHuQ9LaKbaU0WzDSTD7Enuvsk9o
	 tKDjDeQDCFleV9zhMI9uUtIB/Wx4Prj8dMY5F2r3vgfeb48jsRYc++zDbU/TYBiU9qCla
	 BVJs+u2gpd4tMewK08ibDHO6UYiIgT5moRKlhhiV5vqPZUHntV5n2691WegXY3MQ4JmWX
	 KS4BCW9pC2lHB867Z9wc/Y5LmtRObdhmB9lOT3HogSZELMc7leZa1EnbhdIARlF92WaFC
	 U5TIcvwBU8C03AD1oI6seUAmfWQuSduEpPLLJQWqj30k0zuMroUNtgMzV0YF5SnTuVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ov6yHIEg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22976606A31E;
	Thu, 29 Oct 2026 16:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ov6yHIEg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E34131F031E3;
	Thu, 29 Oct 2026 16:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793290049;
	bh=AsodWLg6d4leaTd8y1mFAnryBLI0o8mneeaJ96WpEgw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Ov6yHIEg2RVAwCeDDw6SBsSA7/QgZf/B5/RZ+PrMyoNOlA2ZFmSH/HKL8sVmK2f7b
	 paPyD9rKVu3SoDYAvkbGdQ60kGw6aE4htgXVTuYKQRynd6t9zK3zIdBZsV9v85O8Mj
	 2ZRTQUuihevFeV6XRWctzeju09DfAgoRcuUFzl7KLn0bTZ7zPJjn6OOgakAvdaM7a6
	 QgnFcumIS838qomnB///YdjPCH8tNlkCX/+WJs2K/GYt484cIeqBWgwy3q387QZMzR
	 MaytrDuBlhRxSOEioOdPv+FD/AbxS2zlbH2JtGCuu9f/zNnLX4OROrSaartpR5wSz7
	 ePpSVjFpYsTjQ==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 29 Oct 2026 17:06:53 +0100
Subject: [PATCH v2 02/34] ecryptfs: fall back to a read-only lower file
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
Message-Id: <20261029-work-fs-sb_rdonly-v2-2-2f44f64f0b66@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4207; i=brauner@kernel.org;
 h=from:subject:message-id; bh=Q9NmeDgR8pX/q3aRMUMx4MDSxJG0gbR0HOUiW8m3gzc=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQ9ztfzO7FQbbLu/eafPDoTRBe/dTCvTTqz75Umw0rlj
 8vT7LfodZSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAExE9ADD/xz3jHfC+/K/JTn4
 /Fys/Ot5co9KRsezW9Hf8yvtHtzck8rwz6Js96wDArEOB9apt5RemxK6a57UmabMmXI9J/+ttQ8
 p4QMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

ecryptfs opens the lower file read-write unless the lower inode is
IS_RDONLY(). A read-only mount underneath refuses that and so does ext4
after an error since commit d3476f3dad4a ("ext4: don't set SB_RDONLY
after filesystem errors"). Then every lookup of a regular file fails
with EROFS. The other filesystems are about to behave like ext4, so fall
back to opening the lower file read-only. Opening an ecryptfs file for
writing then fails with EPERM like on top of a read-only superblock.

truncate(2), creating a file and opening an empty file still write to
the lower file and would trip the WARN_ON_ONCE() in
__kernel_write_iter(). So let ecryptfs_write_lower() and
__ecryptfs_truncate() refuse that with EROFS.

Note that ecryptfs never takes write access on the lower mount. On a
read-only bind mount that was only a problem for directories so far.
With this regular files can be unlinked and changed through it too.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/ecryptfs/inode.c      |  8 ++++++++
 fs/ecryptfs/kthread.c    | 15 +++++++++++++--
 fs/ecryptfs/read_write.c |  3 +++
 3 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index 3a966348a578..35afb94143b8 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -741,6 +741,7 @@ static int __ecryptfs_truncate(struct dentry *dentry, const struct iattr *ia)
 	loff_t i_size = i_size_read(inode);
 	loff_t lower_size_before_truncate;
 	loff_t lower_size_after_truncate;
+	struct file *lower_file;
 	struct iattr lower_ia;
 	size_t num_zeros;
 	int rc;
@@ -771,6 +772,13 @@ static int __ecryptfs_truncate(struct dentry *dentry, const struct iattr *ia)
 	if (rc)
 		return rc;
 
+	/* Fail before zeroing the page cache, see ecryptfs_write_lower(). */
+	lower_file = ecryptfs_inode_to_private(inode)->lower_file;
+	if (!(lower_file->f_mode & FMODE_WRITE)) {
+		rc = -EROFS;
+		goto out;
+	}
+
 	if (ia->ia_size > i_size) {
 		char zero[] = { 0x00 };
 
diff --git a/fs/ecryptfs/kthread.c b/fs/ecryptfs/kthread.c
index ae4cb4e2e134..d381d56baa90 100644
--- a/fs/ecryptfs/kthread.c
+++ b/fs/ecryptfs/kthread.c
@@ -30,6 +30,17 @@ static struct ecryptfs_kthread_ctl {
 
 static struct task_struct *ecryptfs_kthread;
 
+/* A read-only mount or a filesystem that hit an error refuses O_RDWR. */
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
@@ -59,7 +70,7 @@ static int ecryptfs_threadfn(void *ignored)
 					       struct ecryptfs_open_req,
 					       kthread_ctl_list);
 			list_del(&req->kthread_ctl_list);
-			*req->lower_file = dentry_open(&req->path,
+			*req->lower_file = ecryptfs_open_lower(&req->path,
 				(O_RDWR | O_LARGEFILE), current_cred());
 			complete(&req->done);
 		}
@@ -132,7 +143,7 @@ int ecryptfs_privileged_open(struct file **lower_file,
 	 * lower file is fput() when all eCryptfs files for the inode are
 	 * released. */
 	flags |= IS_RDONLY(d_inode(lower_dentry)) ? O_RDONLY : O_RDWR;
-	(*lower_file) = dentry_open(&req.path, flags, cred);
+	(*lower_file) = ecryptfs_open_lower(&req.path, flags, cred);
 	if (!IS_ERR(*lower_file))
 		goto out;
 	if ((flags & O_ACCMODE) == O_RDONLY) {
diff --git a/fs/ecryptfs/read_write.c b/fs/ecryptfs/read_write.c
index b3b451c2b941..b3956ae50ff6 100644
--- a/fs/ecryptfs/read_write.c
+++ b/fs/ecryptfs/read_write.c
@@ -33,6 +33,9 @@ int ecryptfs_write_lower(struct inode *ecryptfs_inode, char *data,
 	lower_file = ecryptfs_inode_to_private(ecryptfs_inode)->lower_file;
 	if (!lower_file)
 		return -EIO;
+	/* ecryptfs_open_lower() may have fallen back to a read-only file. */
+	if (!(lower_file->f_mode & FMODE_WRITE))
+		return -EROFS;
 	rc = kernel_write(lower_file, data, size, &offset);
 	mark_inode_dirty_sync(ecryptfs_inode);
 	return rc;

-- 
2.53.0

