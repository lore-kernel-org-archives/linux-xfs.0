Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 682606AD7
	for <linux-xfs@vger.kernel.org>; Wed,  3 Apr 2024 05:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712121518; cv=none; b=S7muOF3ZNk3+YHEyaTPxfvpfLclPrU4PoHyfBTKGKRIHWEHwucQeZjdW6ljNSU29fBX0ULOHnsZSfZWKyCKEiiERlAxjL0lDyZBIvEZ+dghVHWVVPhqZb1M+Dt4lZm4Z7Ln+pzoCQeFdOh3qHOhvYQvIH5hBSfx3z1ACxyAjeTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712121518; c=relaxed/simple;
	bh=lRb+TsarW5R/Tn/SO9RjlahlNd0a6gfCZWdcB9EDNEQ=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RGiB0Cjqs5rIEfd5/S/2OBO9F+zk5H4D3oiWX7IdFJnCIeklS4bvi3XdVhcnGw2gikhpPTaRW+x2fQPtX/xeM9HEAU+UclrIMLjMlQrizVIvyy2FtB+BGG1T58TvZiHK4eVWnRYVynYys41A/vYNMTUL4vyrVKJetpQy/ho4xUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RbTdfJf4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RbTdfJf4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3558BC433F1;
	Wed,  3 Apr 2024 05:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712121518;
	bh=lRb+TsarW5R/Tn/SO9RjlahlNd0a6gfCZWdcB9EDNEQ=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=RbTdfJf4XmYGYpSIJ5PgdB2lhCoxUqPrjO4QP2Y07r3w6wNOKDNU0cKnO3CGakJat
	 O3KkrbNLyTDFhZcDWDU4V9JEXDpSkxfAxSh627T/8vDjYgPXnps/u6Ql5uaquqv5ZZ
	 hEHJY2xyjo0cawX5Q8QJ1bild449fczrtyZpAN4L1oVDVOTmh0xL4bTrkGcpDhaZwi
	 +eDHMbYVSK/wlTxV2uar18K/R6hDwUmLuOlvCtE1hlnCTOGGP880Kz9BKuFy9tLa7w
	 tY+LOpcfQp/D68KqSYJU31TbatH3//CKAa1fvkfi5ukyoKouSZZ1o1vCgP9BzZJQgb
	 cAlBxUNajUhQA==
Subject: [PATCH 3/3] xfs: fix potential AGI <-> ILOCK ABBA deadlock in
 xrep_dinode_findmode_walk_directory
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Date: Tue, 02 Apr 2024 22:18:37 -0700
Message-ID: <171212151764.1535150.4553637479403597514.stgit@frogsfrogsfrogs>
In-Reply-To: <171212150033.1535150.8307366470561747407.stgit@frogsfrogsfrogs>
References: <171212150033.1535150.8307366470561747407.stgit@frogsfrogsfrogs>
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
 fs/xfs/scrub/inode_repair.c |   49 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 48 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index 35da0193c919e..097afba3043f8 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -282,6 +282,51 @@ xrep_dinode_findmode_dirent(
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
+
+		if (xfs_need_iread_extents(&dp->i_df))
+			lock_mode = XFS_ILOCK_EXCL;
+		else
+			lock_mode = XFS_ILOCK_SHARED;
+
+		if (xrep_dinode_ilock_nowait(dp, lock_mode)) {
+			*lock_modep = lock_mode;
+			return 0;
+		}
+	} while (!time_is_before_jiffies(deadline));
+	return -EBUSY;
+}
+
 /*
  * If this is a directory, walk the dirents looking for any that point to the
  * scrub target inode.
@@ -299,7 +344,9 @@ xrep_dinode_findmode_walk_directory(
 	 * Scan the directory to see if there it contains an entry pointing to
 	 * the directory that we are repairing.
 	 */
-	lock_mode = xfs_ilock_data_map_shared(dp);
+	error = xrep_dinode_trylock_directory(ri, dp, &lock_mode);
+	if (error)
+		return error;
 
 	/*
 	 * If this directory is known to be sick, we cannot scan it reliably

