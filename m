Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4909B2594B3;
	Wed, 11 Dec 2024 20:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733947742; cv=none; b=A68AhqKn1TCdRCQAupZ/+GHxPvF6XbFHQ5mFap8vFDNLQkMY1lDn6hTxY1AvSIB9DYuf7VSIhu/Gxn79vE0zLtvsSl+pSBgwYgNWrAOYgTTqwXpwoWHouWsT1WL4fx1gNmEPXqZgIGX+C5JvlOagXnyQEQm6qIvlb8jGnnAoIso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733947742; c=relaxed/simple;
	bh=Q9pXaAeGQzLuS7Y7a4pvKyvgQUQw8ZYdE/YM9zxiaiE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rAnUBIpvimd94yh3Vt9mpOLoiQnJVhs9JacANAcBexik/mkOPTmcQPEVfH12y6XkBhLv9x12TfidVPQa+CWM9nuMixeh0RG72Wf0w5tB85nQ+ZtrpwyZFtUdPv92UpFBwz7tDmww+3hzuL7sv/coKvrCd2grPTEOug1ig5W8edg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KFYYhxl4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KFYYhxl4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDCADC4CED2;
	Wed, 11 Dec 2024 20:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733947741;
	bh=Q9pXaAeGQzLuS7Y7a4pvKyvgQUQw8ZYdE/YM9zxiaiE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=KFYYhxl4EA8g5Pfvo3kUFh+jydrZWXHLkk/M91DFC8KJ4ig+AMxWVzUsJVgUOuAH8
	 xna8bIX0zt9j1Ac8AKPBHvR2Qp7WKXbwh29cHiNY990y9VyMc9w7pGjk8khsJBsIL7
	 RdM3qR1F7+5yYw7if4eQgEc7iMnIUXYuT8unqcBJlJ4ouyjEEzS4X9BUEunX2AV+0f
	 F2lilHdJ7AbmTHe76jfO9/DLLkDpTOR4vuiH42dKhnfTB7dE0bXO6Ezd3mEg/3xspj
	 BeL+xi0hOvXS1Nk9MtSJC+rVl821WvKaEV2FVA6lM5puROe8eb7NrbZbEszw7k64aa
	 o74Pn0Oc3Nmxg==
Date: Wed, 11 Dec 2024 12:09:01 -0800
Subject: [PATCH 6/6] xfs: port xfs_ioc_start_commit to multigrain timestamps
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: jlayton@kernel.org, stable@vger.kernel.org, hch@lst.de,
 jlayton@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173394758170.171676.7652487151213103514.stgit@frogsfrogsfrogs>
In-Reply-To: <173394758055.171676.7276594331259256376.stgit@frogsfrogsfrogs>
References: <173394758055.171676.7276594331259256376.stgit@frogsfrogsfrogs>
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

