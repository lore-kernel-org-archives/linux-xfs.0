Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AF601509BD;
	Tue,  4 Feb 2025 18:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738695192; cv=none; b=RKZIHxKdVs1YpuWKgwvWkcL9i9pIa+twJsxcLq+To8hv6/oNzZvCGFcJZ5fGeKMEqq1yqcxPJIKlF+xHQEkdVu+g+xGzKL0bykIRZTEJgSXOZLiPHFltlqvo+/esrQrIy0tcd2SylWg+m4gs4kFZSTAFj1EWHznACYhxtonP6Fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738695192; c=relaxed/simple;
	bh=4ZECNobaFzxt9Or5NvV4cggnExEAX6q3z1LlwRVSvnM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=btRiQcjZjMPxMPzrox00EV7hx0yEHC0IBLM4OHuQtkEAAU0hLInwY/ItGNtYe5vB1cxCXiR0EkOsE3W0KG8o+gPXy4QK6JLJga3NJwsqHIrkvt3p4tPN2hN/3kPr/fMSqDeYVmMgHO0WtkmLgkCF/MP72R1UkjQs7xGilKmNQmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PbDatvY1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PbDatvY1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 615FAC4CEDF;
	Tue,  4 Feb 2025 18:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738695191;
	bh=4ZECNobaFzxt9Or5NvV4cggnExEAX6q3z1LlwRVSvnM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PbDatvY1XMpTO2LfyTV1wW7IqhCgJ63r4cVUm88fNPr8Y8Cj7/xju7JEzyp5VYdCL
	 8/qojpewIDTmdeQrR3fWXLBLXjgIePtpi+RZu0WppgwtdfVXOzK+voqiHPbbmUheFW
	 ENq6TT99TSsfSoGacKrJAJzdEHe7v5Btv3E9NEYOFy3JCQCEAnx0Ot70wZWBDjma7J
	 9j2DDPvTcpD2e4b1tQgTUeY7R8DUF4YxUEWivdUkQ1vEn2R2Tw4iC0L02f+l1EUW6e
	 nMWUkNkLGhE2jnqeToSKzEC8s+tz6f+Wvepr6kWAZpQ4W9SSU9ppmTIOIjfS0BW3SO
	 vpjSmkcP3mkDQ==
Date: Tue, 04 Feb 2025 10:53:10 -0800
Subject: [PATCH 08/10] xfs: don't over-report free space or inodes in statvfs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, xfs-stable@lists.linux.dev, linux-xfs@vger.kernel.org
Cc: eflorac@intellique.com, hch@lst.de, stable@vger.kernel.org
Message-ID: <173869499472.410229.11902558198274628697.stgit@frogsfrogsfrogs>
In-Reply-To: <173869499323.410229.9898612619797978336.stgit@frogsfrogsfrogs>
References: <173869499323.410229.9898612619797978336.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

commit 4b8d867ca6e2fc6d152f629fdaf027053b81765a upstream

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
index a11436579877d5..410a2a9c18ec52 100644
--- a/fs/xfs/xfs_qm_bhv.c
+++ b/fs/xfs/xfs_qm_bhv.c
@@ -26,21 +26,28 @@ xfs_fill_statvfs_from_dquot(
 	limit = dqp->q_blk.softlimit ?
 		dqp->q_blk.softlimit :
 		dqp->q_blk.hardlimit;
-	if (limit && statp->f_blocks > limit) {
-		statp->f_blocks = limit;
-		statp->f_bfree = statp->f_bavail =
-			(statp->f_blocks > dqp->q_blk.reserved) ?
-			 (statp->f_blocks - dqp->q_blk.reserved) : 0;
+	if (limit) {
+		uint64_t	remaining = 0;
+
+		if (limit > dqp->q_blk.reserved)
+			remaining = limit - dqp->q_blk.reserved;
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
 

