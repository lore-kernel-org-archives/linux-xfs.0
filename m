Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 502AF195
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724371580; cv=none; b=RWWAhOx2QKyOoRd/yMM7Rr2iI9aN/aMBB5pZDlZ47gC6slAcPolI6C8gZGHjIrGc0NSEsDSUmwn3228KejycQjSqPaUhFz08kFWFtpPKuj/Y/AVwJJozO63dMEI79Wi1zU/LtdYE+7DblJUoNpjJU54NcH8yctjon+UhC0AW1lU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724371580; c=relaxed/simple;
	bh=NzdbgdPT9mJbkcUWRmpZjD5T67joEyVuoAN6IvjKw+o=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pKni2Pk3LYqjrJ2pYVlW9uAt2EjHMkz9e6G7c4IloFGRvbVc5yZiMvEqgq+LSNgekqtgi/3S0+kLOs6a8Q/MnlQNl2sP325yWPpoP1y1QBIGSca7cIka/rTraOyVsNwlNxjZV6lCDdxaIIdJl34TNa4Ey8tpXWLLa973rtFw22Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZkcQEO6G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZkcQEO6G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F37AC4AF09;
	Fri, 23 Aug 2024 00:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724371580;
	bh=NzdbgdPT9mJbkcUWRmpZjD5T67joEyVuoAN6IvjKw+o=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZkcQEO6GFW9GRN/4Kw4xg1e0YUowyNi/WW9djvYn6yOyqQXseGQeHhhBdjxR4WKvK
	 fvsPyJtcXHDPkrfc95ceoUg5IBFF10NNXLCg0/GA1GcclSPstZnJdY8pcREUX0S7HP
	 LgBMKxH139G7z3sOBjl0UuTh6bp82nZvA16Ur9F6IZ3Q5X7syJBMrZdHqjFFMqHB2O
	 ZnHA3txY8Is/eYYMdXFsHzMqmqsgx2JLmIl21kk93vUvjw1gmBy1WCJFIcmXlTOXjl
	 37rIYD9ky3DWgv9QZx0NBu53dSUOVvLZvWTVZkUyDezc+zeAYa5CjdSiZfOdBDPZ1+
	 +ZVcujO0Vt3XA==
Date: Thu, 22 Aug 2024 17:06:19 -0700
Subject: [PATCH 16/26] xfs: do not count metadata directory files when doing
 online quotacheck
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437085452.57482.12698083966396269396.stgit@frogsfrogsfrogs>
In-Reply-To: <172437085093.57482.7844640009051679935.stgit@frogsfrogsfrogs>
References: <172437085093.57482.7844640009051679935.stgit@frogsfrogsfrogs>
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

Previously, we stated that files in the metadata directory tree are not
counted in the dquot information.  Fix the online quotacheck code to
reflect this.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/quotacheck.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/scrub/quotacheck.c b/fs/xfs/scrub/quotacheck.c
index c77eb2de8df71..dc4033b91e440 100644
--- a/fs/xfs/scrub/quotacheck.c
+++ b/fs/xfs/scrub/quotacheck.c
@@ -398,10 +398,13 @@ xqcheck_collect_inode(
 	bool			isreg = S_ISREG(VFS_I(ip)->i_mode);
 	int			error = 0;
 
-	if (xfs_is_quota_inode(&tp->t_mountp->m_sb, ip->i_ino)) {
+	if (xfs_is_metadir_inode(ip) ||
+	    xfs_is_quota_inode(&tp->t_mountp->m_sb, ip->i_ino)) {
 		/*
 		 * Quota files are never counted towards quota, so we do not
-		 * need to take the lock.
+		 * need to take the lock.  Files do not switch between the
+		 * metadata and regular directory trees without a reallocation,
+		 * so we do not need to ILOCK them either.
 		 */
 		xchk_iscan_mark_visited(&xqc->iscan, ip);
 		return 0;

