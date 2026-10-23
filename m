Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792759500;
	b=Hod6/J1kJUgO1n3Y/zBFVnGE+RB8sjYZ9WFSrG600OqMbIOPkTamusPFPDsfk71IArTM
	 YRedWDcr822OVqI5nu6XuDPxQGC80ywaWooOOzhxeD2bChGXYhzLTIyTxrtWqRy3CaZ52
	 p4OVAnvqe5ZRvvbWYhYQwrxEebZueVm7xs+vOpLWN5hL+XBeXRHqD+tJyiuoFKXgGo+HW
	 7QICw8DzSRMx0aUF7ShTMHU/pw2mvARNnl/Kl+FY/RlVcrZ6JsztC8kbSb3sH2srE9wWX
	 VlZlupXrWLK6p6wkYiYU62pH0jMtgBAAj6MZ4T8qZRhZfyJ9sO56/MrnLO1gR28K6GA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792759500;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=f/jgck1/B2jP5Cxin5WuX27Pbk4Su0v7UABSBfjcW6U=;
	b=00NWqeuOXZCceENcCgDBbvJRf9YqVOHOl50not8bPcfRL5xZy49Rl2Pi04zHHFm2BbJd
	 BfHQRpodEoRSQY2lMaAJmow0+gkVOax7g+xWDDBBY69Ypt3zL+jJGU/a24kyJmZmJJ2UL
	 9s/uNZQ8BXHlnHzPMtD5XBBKqA5Ariq3Mr8AsYfQTTOm9doZMnTRc7CB5d4MPn2gJtCpb
	 ztOlbLWX94p0tUemYmjWcCeFrOGZTUpi2jj6DsbxJoDuxffYThDhCDmZhhJNUjHfFtFyv
	 ouT2zv6ymACs7r2rUxu47R3i7WmI1X6hU92wSG9PvmeoIG4jeODIHTqtS71ZUSB9rGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="jfH/qyuZ";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63129606A323;
	Fri, 23 Oct 2026 12:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jfH/qyuZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 930841F01829;
	Fri, 23 Oct 2026 12:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792759500;
	bh=f/jgck1/B2jP5Cxin5WuX27Pbk4Su0v7UABSBfjcW6U=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=jfH/qyuZd3kejUmi+LHhUQ0Lbt0Z0Q5dfbUYU7ekb7mW5joY66m+94DK4KZVWLEAM
	 vC6brHn4cEX1u7aQfAoTpGVteyuiBO7CfhaFOlu743UQqMqLn5WdIq86Epvlam7Zhe
	 6cRjxXn04WU3XdFtNncm/RTYvdJ/nwJKZwvdnE+sQTWZ/4HvabUPzpO979kd+h4IME
	 VAl5n5PMo3ThrjPVYm2yR8ZtQrALZ7xGIzkUdhVtDf75UvIkmWyO9/Qky/p+zDdvj1
	 QDgOiEuS9YKhIe093TNlY8bw5QDSYa+0A3BJp3MUcLite6i7OjH6qVkZrpjtuyqI4w
	 ms+TP81QUf7yQ==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 23 Oct 2026 14:44:22 +0200
Subject: [PATCH 1/2] dcache: don't leave negative dentries in casefolded
 directories
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
Message-Id: <20261023-work-dcache-casefold-v1-1-1b0bd5c73a69@kernel.org>
References: <20261023-work-dcache-casefold-v1-0-1b0bd5c73a69@kernel.org>
In-Reply-To: <20261023-work-dcache-casefold-v1-0-1b0bd5c73a69@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
 linux-xfs@vger.kernel.org, Gabriel Krisman Bertazi <krisman@kernel.org>, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=5070; i=brauner@kernel.org;
 h=from:subject:message-id; bh=uraFryhr3pXYI4wU9TenrkcrtkF88x7auRzStx88u1E=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTdDjv2oVz49tkJNl2JXV+dnCKtFrBrLtl0Qmf9av/KC
 7V98w6d6ihlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZiI8Q9Ghkeqkkcn2hrHL7t7
 jPHItQWbdCyc8uUOBFscOsTM8WpBXyUjw8ZDeRzfZlxIcbdUKLjFXMBS+Y+TYYP1Mh/ZR8XvbKf
 m8QAA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

ext4, f2fs and tmpfs keep negative dentries out of casefolded
directories. A negative dentry remembers one spelling of the name and
the next create() through it would write that spelling to disk.

So their ->lookup() doesn't cache a miss and their ->unlink() and
->rmdir() call d_invalidate() on the dentry so that d_delete() doesn't
turn it into a negative dentry.

But d_invalidate() is the wrong primitive for that. It's for a name that
went stale. It walks the subtree, prunes it and detaches every mount it
finds, under namespace_sem, and here that runs from inside the
filesystem's own directory operation. ext4_rmdir() does it with the
journal handle still open and ext4_unlink() does it even when the
unlink failed. All anyone wanted is the unhash.

So d_delete() now unhashes the dentry when the parent is casefolded,
next to the dentry-negative sysctl that does the same for every
directory. ext4, f2fs and tmpfs drop their d_invalidate() calls.

Nothing changes for a casefolded directory. A miss still isn't cached
and a removed name still doesn't leave a negative dentry behind. The
target of a rename over an existing name, which tmpfs also passes
through shmem_unlink(), doesn't turn negative either. vfs_rename()
detaches its mounts and d_move() unhashes it. A failed unlink or rmdir
now leaves the dentry hashed and its mounts in place, as in any other
directory.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/dcache.c     |  8 +++++++-
 fs/ext4/namei.c | 18 ------------------
 fs/f2fs/namei.c |  9 ---------
 mm/shmem.c      |  7 -------
 4 files changed, 7 insertions(+), 35 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index efd9332c8407..f5cbb2e24e53 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2746,6 +2746,12 @@ struct dentry *d_hash_and_lookup(struct dentry *dir, struct qstr *name)
 	return d_lookup(dir, name);
 }
 
+static __always_inline bool d_delete_drop(struct dentry *dentry)
+{
+	return dentry_negative_policy ||
+	       IS_CASEFOLDED(d_inode(dentry->d_parent));
+}
+
 /*
  * When a file is deleted, we have two options:
  * - turn this dentry into a negative dentry
@@ -2777,7 +2783,7 @@ void d_delete(struct dentry * dentry)
 	 * Are we the only user?
 	 */
 	if (dentry->d_lockref.count == 1) {
-		if (dentry_negative_policy)
+		if (d_delete_drop(dentry))
 			__d_drop(dentry);
 		dentry->d_flags &= ~DCACHE_CANT_MOUNT;
 		dentry_unlink_inode(dentry);
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 6e0630a49e48..c4b1121471e6 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3209,15 +3209,6 @@ static int ext4_rmdir(struct inode *dir, struct dentry *dentry)
 	ext4_fc_track_unlink(handle, dentry);
 	retval = ext4_mark_inode_dirty(handle, dir);
 
-	/* VFS negative dentries are incompatible with Encoding and
-	 * Case-insensitiveness. Eventually we'll want avoid
-	 * invalidating the dentries here, alongside with returning the
-	 * negative dentries at ext4_lookup(), when it is better
-	 * supported by the VFS for the CI case.
-	 */
-	if (IS_ENABLED(CONFIG_UNICODE) && IS_CASEFOLDED(dir))
-		d_invalidate(dentry);
-
 end_rmdir:
 	brelse(bh);
 	if (handle)
@@ -3320,15 +3311,6 @@ static int ext4_unlink(struct inode *dir, struct dentry *dentry)
 
 	retval = __ext4_unlink(dir, &dentry->d_name, d_inode(dentry), dentry);
 
-	/* VFS negative dentries are incompatible with Encoding and
-	 * Case-insensitiveness. Eventually we'll want avoid
-	 * invalidating the dentries here, alongside with returning the
-	 * negative dentries at ext4_lookup(), when it is  better
-	 * supported by the VFS for the CI case.
-	 */
-	if (IS_ENABLED(CONFIG_UNICODE) && IS_CASEFOLDED(dir))
-		d_invalidate(dentry);
-
 out_trace:
 	trace_ext4_unlink_exit(dentry, retval);
 	return retval;
diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index 233c07fec171..30f6b8448eee 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -631,15 +631,6 @@ static int f2fs_unlink(struct inode *dir, struct dentry *dentry)
 	if (err)
 		goto out;
 
-	/* VFS negative dentries are incompatible with Encoding and
-	 * Case-insensitiveness. Eventually we'll want avoid
-	 * invalidating the dentries here, alongside with returning the
-	 * negative dentries at f2fs_lookup(), when it is better
-	 * supported by the VFS for the CI case.
-	 */
-	if (IS_ENABLED(CONFIG_UNICODE) && IS_CASEFOLDED(dir))
-		d_invalidate(dentry);
-
 	if (IS_DIRSYNC(dir))
 		err = f2fs_sync_fs(F2FS_I_SB(dir)->sb, 1);
 out:
diff --git a/mm/shmem.c b/mm/shmem.c
index 0d891ade18b5..5a353ac32573 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3953,13 +3953,6 @@ static int shmem_unlink(struct inode *dir, struct dentry *dentry)
 	inode_inc_iversion(dir);
 	simple_unlink(dir, dentry);
 
-	/*
-	 * For now, VFS can't deal with case-insensitive negative dentries, so
-	 * we invalidate them
-	 */
-	if (IS_ENABLED(CONFIG_UNICODE) && IS_CASEFOLDED(dir))
-		d_invalidate(dentry);
-
 	return 0;
 }
 

-- 
2.53.0

