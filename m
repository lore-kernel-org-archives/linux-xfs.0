Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 627741AAA28;
	Thu, 19 Dec 2024 19:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734636033; cv=none; b=gTZVLG0QMUofcwhlmsM7Fm/UeiLB4wy782MVeTYZaPOVSt4cKza9k4IWS3P9482NXFfIjWZAJPVIUyoXKLAyRsLo2dLBK9P5i/lUg6TXXwOu5gd3yPYNDZB+Sx3yYrpXdFSYEuEyR9iJ2jTyGQegAf68uHtOmRqrV8ONT/OsDGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734636033; c=relaxed/simple;
	bh=HA4XOeCq2CSwB1SCiIC5hUhYTpNQNBuvaPf1ozcEFI0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EgKAopTHdxbmu0L7840zs9OX/Lel/GHF9gY1OzFpP2KhQnSG3nbR/85vp4fDepGc7D9HDpTyzBQCKgH/axwH4JyeFysqGXhcVCT6g421kXU1Lg860GlbCAp3aBoXz2aF9g1FZBW6ePZgTER8B9rI3Zfx7XxpH5ezcIn8unxJKaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KU7ENB0x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KU7ENB0x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59F63C4CECE;
	Thu, 19 Dec 2024 19:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734636032;
	bh=HA4XOeCq2CSwB1SCiIC5hUhYTpNQNBuvaPf1ozcEFI0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=KU7ENB0x2fx+VUorYJ6nJHLFZwXVkZbjbScVxmf1QSjMg+jrx51cmNye8Px4hHOya
	 J+LA9bfJZ7S7TXjmiwRr5PlV/llitcLzrtvSNwJHRqqZfQUpEJCZcK4PO/cSDtzO3F
	 eabFNx6pgA6AB0eAYJt8+4RMJ7uuq43tiHjF0Vst5swKsl9E4en/mkA8AMYu/2+D2B
	 cnA54G0AObsqOGKRLsPF93IU8MTNO7WASG4jOa6rdnb+y8hH3ggBYeMKSanm2+ilkj
	 L01/zXDCY4eH831pL6w4/kTHbkKfuqUIwu1dTCc/fPFgZGxWCRkHpWjUgycO0vR7OQ
	 bJXKWkC7r4tTA==
Date: Thu, 19 Dec 2024 11:20:31 -0800
Subject: [PATCH 1/2] xfs: don't over-report free space or inodes in statvfs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: stable@vger.kernel.org, eflorac@intellique.com, hch@lst.de,
 linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173463578233.1570935.16752846658475955331.stgit@frogsfrogsfrogs>
In-Reply-To: <173463578212.1570935.4004660775026906039.stgit@frogsfrogsfrogs>
References: <173463578212.1570935.4004660775026906039.stgit@frogsfrogsfrogs>
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
 

