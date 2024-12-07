Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79E7038B;
	Sat,  7 Dec 2024 00:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733531546; cv=none; b=qatm4iB77hBL76aHqlYFZhyTVykiroLAEQrjPltf+ovE8Dx0w9ttvTRQHrDcYBP5CpXm1AahISID0eAptrQUGDBaAxGMmcwscRHJA3ZrDa5sur+A3RVZktvo/Ijku8pVC5jhi7At2Wc1XyDXbpcI7ysZEaxOQU6LXgSYl7ynMaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733531546; c=relaxed/simple;
	bh=Q9pXaAeGQzLuS7Y7a4pvKyvgQUQw8ZYdE/YM9zxiaiE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pa1r6Xphz3Sd/DbrEcgnhQZ9/+4GX07tQ4sQnd4q0pWXUfCLD1cnS8/HaAE0wNem4cEilvfTXNa2yKt+YvbLor54/XPDbQ+XX2s0KAcFYfpoUK1kOQMTbIeIuS05JTBeayiRfnUpYt4ocafxWOKQjKPaVw90wiGRI/AVsEujklE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sbb1NCfs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sbb1NCfs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 000AFC4CED1;
	Sat,  7 Dec 2024 00:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733531546;
	bh=Q9pXaAeGQzLuS7Y7a4pvKyvgQUQw8ZYdE/YM9zxiaiE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=sbb1NCfs98KOxJjEwiWP0k4no31SFUwgXEecFi/hd7EDJoC3xc3OxLcp4eRYikGH9
	 sjLPln6MWKmU5JuIRdTRhRo/H25tXk0uQjeqrOEZa01okF+8MaIOP/vGkHZKIC08FL
	 /UrJJjUpKiQnrbX8/Mp37J62iMUnkfqXfgdok2wdc6gIFXcSx5O1R4ya0Vjm5Dqe1V
	 +pQ3/7csTYhrAvt7Ti0XJQBL2aIPCyPivlonNYP4SRT8Cfc9tACqqBpk6NCNzmknvA
	 04HY5XfvJxJyHv4cVf9feHUkN9fXOO2GTN+2q6xEaiZldg8c6W5mwyar/2WRO1wTVY
	 Nqxs9UtLjPixQ==
Date: Fri, 06 Dec 2024 16:32:25 -0800
Subject: [PATCH 6/6] xfs: port xfs_ioc_start_commit to multigrain timestamps
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: jlayton@kernel.org, stable@vger.kernel.org, hch@lst.de,
 jlayton@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173353139401.192136.14215988524314353493.stgit@frogsfrogsfrogs>
In-Reply-To: <173353139288.192136.15243674953215007178.stgit@frogsfrogsfrogs>
References: <173353139288.192136.15243674953215007178.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Take advantage of the multigrain timestamp APIs to ensure that nobody
can sneak in and write things to a file between starting a file update
operation and committing the results.  This should have been part of the
multigrain timestamp merge, but I forgot to fling it at jlayton when he
resubmitted the patchset due to developer bandwidth problems.

Cc: jlayton@kernel.org
Cc: <stable@vger.kernel.org> # v6.13-rc1
Fixes: 4e40eff0b5737c ("fs: add infrastructure for multigrain timestamps")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
---
 fs/xfs/xfs_exchrange.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/xfs_exchrange.c b/fs/xfs/xfs_exchrange.c
index 9ab05ad224d127..dd24de420714ab 100644
--- a/fs/xfs/xfs_exchrange.c
+++ b/fs/xfs/xfs_exchrange.c
@@ -854,7 +854,7 @@ xfs_ioc_start_commit(
 	struct xfs_commit_range __user	*argp)
 {
 	struct xfs_commit_range		args = { };
-	struct timespec64		ts;
+	struct kstat			kstat;
 	struct xfs_commit_range_fresh	*kern_f;
 	struct xfs_commit_range_fresh	__user *user_f;
 	struct inode			*inode2 = file_inode(file);
@@ -871,12 +871,12 @@ xfs_ioc_start_commit(
 	memcpy(&kern_f->fsid, ip2->i_mount->m_fixedfsid, sizeof(xfs_fsid_t));
 
 	xfs_ilock(ip2, lockflags);
-	ts = inode_get_ctime(inode2);
-	kern_f->file2_ctime		= ts.tv_sec;
-	kern_f->file2_ctime_nsec	= ts.tv_nsec;
-	ts = inode_get_mtime(inode2);
-	kern_f->file2_mtime		= ts.tv_sec;
-	kern_f->file2_mtime_nsec	= ts.tv_nsec;
+	/* Force writing of a distinct ctime if any writes happen. */
+	fill_mg_cmtime(&kstat, STATX_CTIME | STATX_MTIME, inode2);
+	kern_f->file2_ctime		= kstat.ctime.tv_sec;
+	kern_f->file2_ctime_nsec	= kstat.ctime.tv_nsec;
+	kern_f->file2_mtime		= kstat.mtime.tv_sec;
+	kern_f->file2_mtime_nsec	= kstat.mtime.tv_nsec;
 	kern_f->file2_ino		= ip2->i_ino;
 	kern_f->file2_gen		= inode2->i_generation;
 	kern_f->magic			= XCR_FRESH_MAGIC;

