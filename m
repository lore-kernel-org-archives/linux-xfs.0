Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5109E7462;
	Mon, 23 Dec 2024 22:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734994428; cv=none; b=J6u3/iKu5+nkdPh2FSBDLq4qfwfZAPqn+hB8WbgT3eQ8avkALAZDPjgH0+2ZX9aqRaCSNySwjvSU/Ug1oz4ss3LA7TFdL25cCD3cdwUFjYKp7WUxb4gNrsKF8fLjoB8a7nZW2vSERTc2qgnYhXn2uKhMqEBp4aRnxvF/gybpteE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734994428; c=relaxed/simple;
	bh=HA4XOeCq2CSwB1SCiIC5hUhYTpNQNBuvaPf1ozcEFI0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W1zzng+bI8yVubj8MVyqXNeQ8CKCmJtgkPIxNWIoEWnt+A3IyriBmD/xlz12nZ8V1YBuv6pFrxF96Gl2omYe/vhgNMW+mnPpFNzgII7kFt/9hlis/ayRWLGjuqyK+le6jQal3OjWzbp3iLxIhZAmbbE09MALtXNF2lykH7goKSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kzyq8ZgR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kzyq8ZgR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB537C4CED3;
	Mon, 23 Dec 2024 22:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734994427;
	bh=HA4XOeCq2CSwB1SCiIC5hUhYTpNQNBuvaPf1ozcEFI0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=kzyq8ZgRTBizY9y0+sFR+Re/Udipyfw6KneLAk8YjeAtx3k6fUpXB07jxZu1YG4Y+
	 dDXHg3plqfBTOlnZzEQ8KVd/eZngOzOh7bPDSDmzY7YxAwb7vdmcYQYET/XRDX34yj
	 O0HAh0jOCr0k+4rQ8rjJVG66UTFVT90JsdbWZ5838QAXGGQ2cLBCFUoG95haxgbPuG
	 Z/yPQ+mQPvYZYZrxR3rQbBu5ZxDynncEhW42CGfub7i6JCvKP0S5gqwSSelnbJx1Ee
	 vWT505mxsVubHRhHfsUe7jo4ZtclcOGb+5/UOi799vHKOcEW0cy0y+OxG+G4kUMfZO
	 oKDRTsHTcBd/A==
Date: Mon, 23 Dec 2024 14:53:47 -0800
Subject: [PATCH 1/2] xfs: don't over-report free space or inodes in statvfs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, eflorac@intellique.com, hch@lst.de,
 linux-xfs@vger.kernel.org
Message-ID: <173499417150.2379546.487719930933042459.stgit@frogsfrogsfrogs>
In-Reply-To: <173499417129.2379546.10223550496728939171.stgit@frogsfrogsfrogs>
References: <173499417129.2379546.10223550496728939171.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Emmanual Florac reports a strange occurrence when project quota limits
are enabled, free space is lower than the remaining quota, and someone
runs statvfs:

  # mkfs.xfs -f /dev/sda
  # mount /dev/sda /mnt -o prjquota
  # xfs_quota  -x -c 'limit -p bhard=2G 55' /mnt
  # mkdir /mnt/dir
  # xfs_io -c 'chproj 55' -c 'chattr +P' -c 'stat -vvvv' /mnt/dir
  # fallocate -l 19g /mnt/a
  # df /mnt /mnt/dir
  Filesystem      Size  Used Avail Use% Mounted on
  /dev/sda         20G   20G  345M  99% /mnt
  /dev/sda        2.0G     0  2.0G   0% /mnt

I think the bug here is that xfs_fill_statvfs_from_dquot unconditionally
assigns to f_bfree without checking that the filesystem has enough free
space to fill the remaining project quota.  However, this is a
longstanding behavior of xfs so it's unclear what to do here.

Cc: <stable@vger.kernel.org> # v2.6.18
Fixes: 932f2c323196c2 ("[XFS] statvfs component of directory/project quota support, code originally by Glen.")
Reported-by: Emmanuel Florac <eflorac@intellique.com>
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_qm_bhv.c |   27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
index 847ba29630e9d8..db5b8afd9d1b97 100644
--- a/fs/xfs/xfs_qm_bhv.c
+++ b/fs/xfs/xfs_qm_bhv.c
@@ -32,21 +32,28 @@ xfs_fill_statvfs_from_dquot(
 	limit = blkres->softlimit ?
 		blkres->softlimit :
 		blkres->hardlimit;
-	if (limit && statp->f_blocks > limit) {
-		statp->f_blocks = limit;
-		statp->f_bfree = statp->f_bavail =
-			(statp->f_blocks > blkres->reserved) ?
-			 (statp->f_blocks - blkres->reserved) : 0;
+	if (limit) {
+		uint64_t	remaining = 0;
+
+		if (limit > blkres->reserved)
+			remaining = limit - blkres->reserved;
+
+		statp->f_blocks = min(statp->f_blocks, limit);
+		statp->f_bfree = min(statp->f_bfree, remaining);
+		statp->f_bavail = min(statp->f_bavail, remaining);
 	}
 
 	limit = dqp->q_ino.softlimit ?
 		dqp->q_ino.softlimit :
 		dqp->q_ino.hardlimit;
-	if (limit && statp->f_files > limit) {
-		statp->f_files = limit;
-		statp->f_ffree =
-			(statp->f_files > dqp->q_ino.reserved) ?
-			 (statp->f_files - dqp->q_ino.reserved) : 0;
+	if (limit) {
+		uint64_t	remaining = 0;
+
+		if (limit > dqp->q_ino.reserved)
+			remaining = limit - dqp->q_ino.reserved;
+
+		statp->f_files = min(statp->f_files, limit);
+		statp->f_ffree = min(statp->f_ffree, remaining);
 	}
 }
 

