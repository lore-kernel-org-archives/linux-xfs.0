Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1189A208A4
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 01:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711504230; cv=none; b=dwd5t/BNN+IGtlVUwZ22iMJHuQpjKhIT1+eKFkYug2iVN6tnvz2YZCj/t09Cw7wBj0HCqEpSPtwkCBNJLeHzLUql9NxakLAOY3zFN/As06NIr+nM/tL/bYNMUZJDmhcwPJbheTC8XSyPtZuPUmTNLrHOU8zYrJEiPM5MjwkIGJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711504230; c=relaxed/simple;
	bh=dzAMBARn/zOQu2vkWbzU6/jxfkBddv+YPdHNtKiUxms=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Rmir/rAkiFl4L0Z7SHBa7WUgXSlPd++dG/GOTxN8560LOxmgbUYSSvxUKok+YuD7AGamF7JkBgK+md0JGH1G5xq5jF+IbH7hg0wr7Q+d5ROBZ6nYlj3qVCVnALOwjcK8YSHhsVvuMLO6qTW0a1YC1me+2JwQl3PCw3l8TZ7ro3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VGqa6gkR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VGqa6gkR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89EBBC433F1;
	Wed, 27 Mar 2024 01:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711504229;
	bh=dzAMBARn/zOQu2vkWbzU6/jxfkBddv+YPdHNtKiUxms=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=VGqa6gkRGLTbGfD16kpgEP0OInL6sL/vJkxwOSmz+ej091VpscR7jQq8ntsTumZy5
	 HtfAgfPxzJkdxDHCiKpP0iYclIG9yZn4lZ1zUOJ40jJ5skqwCRWnC8ZY6MuehAbslU
	 zrep9EkgiXA4AQwrOudheRF+Z465xWR4udjZOvPd1wtSRNBJWRByx6Eo3XchCvLjik
	 4gx7hEUIb68muECIdfdq4vsLA3jUlfIK4y7QIh5TTavignt1D7atHNnmfYyQ4LAfiV
	 xJeCGuHHU4iJA9AvOMk5CfH3oDIYO6ofsedk4AqwC6yN6yslp+M+asgURUh1C6VEot
	 c5UNoulRvyMBg==
Date: Tue, 26 Mar 2024 18:50:29 -0700
Subject: [PATCH 1/1] xfs: fix potential AGI <-> ILOCK ABBA deadlock in
 xrep_dinode_findmode_walk_directory
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <171150379387.3216268.6890967813601957901.stgit@frogsfrogsfrogs>
In-Reply-To: <171150379369.3216268.2525451022899750269.stgit@frogsfrogsfrogs>
References: <171150379369.3216268.2525451022899750269.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

xfs/399 found the following deadlock when fuzzing core.mode = ones:

/proc/20506/task/20558/stack :
[<0>] xfs_ilock+0xa0/0x240 [xfs]
[<0>] xfs_ilock_data_map_shared+0x1b/0x20 [xfs]
[<0>] xrep_dinode_findmode_walk_directory+0x69/0xe0 [xfs]
[<0>] xrep_dinode_find_mode+0x103/0x2a0 [xfs]
[<0>] xrep_dinode_mode+0x7c/0x120 [xfs]
[<0>] xrep_dinode_core+0xed/0x2b0 [xfs]
[<0>] xrep_dinode_problems+0x10/0x80 [xfs]
[<0>] xrep_inode+0x6c/0xc0 [xfs]
[<0>] xrep_attempt+0x64/0x1d0 [xfs]
[<0>] xfs_scrub_metadata+0x365/0x840 [xfs]
[<0>] xfs_scrubv_metadata+0x282/0x430 [xfs]
[<0>] xfs_ioc_scrubv_metadata+0x149/0x1a0 [xfs]
[<0>] xfs_file_ioctl+0xc68/0x1780 [xfs]
/proc/20506/task/20559/stack :
[<0>] xfs_buf_lock+0x3b/0x110 [xfs]
[<0>] xfs_buf_find_lock+0x66/0x1c0 [xfs]
[<0>] xfs_buf_get_map+0x208/0xc00 [xfs]
[<0>] xfs_buf_read_map+0x5d/0x2c0 [xfs]
[<0>] xfs_trans_read_buf_map+0x1b0/0x4c0 [xfs]
[<0>] xfs_read_agi+0xbd/0x190 [xfs]
[<0>] xfs_ialloc_read_agi+0x47/0x160 [xfs]
[<0>] xfs_imap_lookup+0x69/0x1f0 [xfs]
[<0>] xfs_imap+0x1fc/0x3d0 [xfs]
[<0>] xfs_iget+0x357/0xd50 [xfs]
[<0>] xchk_dir_actor+0x16e/0x330 [xfs]
[<0>] xchk_dir_walk_block+0x164/0x1e0 [xfs]
[<0>] xchk_dir_walk+0x13a/0x190 [xfs]
[<0>] xchk_directory+0x1a2/0x2b0 [xfs]
[<0>] xfs_scrub_metadata+0x2f4/0x840 [xfs]
[<0>] xfs_scrubv_metadata+0x282/0x430 [xfs]
[<0>] xfs_ioc_scrubv_metadata+0x149/0x1a0 [xfs]
[<0>] xfs_file_ioctl+0xc68/0x1780 [xfs]

Thread 20558 holds an AGI buffer and is trying to grab the ILOCK of the
root directory.  Thread 20559 holds the root directory ILOCK and is
trying to grab the AGI of an inode that is one of the root directory's
children.  The AGI held by 20558 is the same buffer that 20559 is trying
to acquire.  In other words, this is an ABBA deadlock.

In general, the lock order is ILOCK and then AGI -- rename does this
while preparing for an operation involving whiteouts or renaming files
out of existence; and unlink does this when moving an inode to the
unlinked list.  The only place where we do it in the opposite order is
on the child during an icreate, but at that point the child is marked
INEW and is not visible to other threads.

Work around this deadlock by replacing the blocking ilock attempt with a
nonblocking loop that aborts after 30 seconds.  Relax for a jiffy after
a failed lock attempt.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/inode_repair.c |   48 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 47 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index eab380e95ef40..96c5763dc3839 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -282,6 +282,50 @@ xrep_dinode_findmode_dirent(
 	return 0;
 }
 
+/* Try to lock a directory, or wait a jiffy. */
+static inline int
+xrep_dinode_ilock_nowait(
+	struct xfs_inode	*dp,
+	unsigned int		lock_mode)
+{
+	if (xfs_ilock_nowait(dp, lock_mode))
+		return true;
+
+	schedule_timeout_killable(1);
+	return false;
+}
+
+/*
+ * Try to lock a directory to look for ftype hints.  Since we already hold the
+ * AGI buffer, we cannot block waiting for the ILOCK because rename can take
+ * the ILOCK and then try to lock AGIs.
+ */
+STATIC int
+xrep_dinode_trylock_directory(
+	struct xrep_inode	*ri,
+	struct xfs_inode	*dp,
+	unsigned int		*lock_modep)
+{
+	unsigned long		deadline = jiffies + msecs_to_jiffies(30000);
+	unsigned int		lock_mode;
+	int			error = 0;
+
+	do {
+		if (xchk_should_terminate(ri->sc, &error))
+			return error;
+		if (time_is_before_jiffies(deadline))
+			return -EBUSY;
+
+		if (xfs_need_iread_extents(&dp->i_df))
+			lock_mode = XFS_ILOCK_EXCL;
+		else
+			lock_mode = XFS_ILOCK_SHARED;
+	} while (!xrep_dinode_ilock_nowait(dp, lock_mode));
+
+	*lock_modep = lock_mode;
+	return 0;
+}
+
 /*
  * If this is a directory, walk the dirents looking for any that point to the
  * scrub target inode.
@@ -299,7 +343,9 @@ xrep_dinode_findmode_walk_directory(
 	 * Scan the directory to see if there it contains an entry pointing to
 	 * the directory that we are repairing.
 	 */
-	lock_mode = xfs_ilock_data_map_shared(dp);
+	error = xrep_dinode_trylock_directory(ri, dp, &lock_mode);
+	if (error)
+		return error;
 
 	/*
 	 * If this directory is known to be sick, we cannot scan it reliably

