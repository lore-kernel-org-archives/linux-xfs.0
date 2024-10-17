Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FBBF1DED44
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 18:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729191480; cv=none; b=Txchsy2mIRat0NO2+vjkZZ5swaQ6a/ygpLpaxXdG4IZr1hgdJGJXmk229uxcbFsGU8Ln+HKKjXYKQkImkDoPdKy0MCx4I7t3glc4UVOLcKbFsXiqftkAnENQ00o3z1a1DDdr73MAS0YHzqm/x5kjVeEArzS8cSdCR/g8mej3HzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729191480; c=relaxed/simple;
	bh=rfaEJDW7NCAX9gEtorsZS0hjtrv4YAqTIE+H9l92W+Y=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TPSvg7a0bryEemrIl02bBALp7pbiW5FIwkAJiPUeey/oDs1Ojdy7BvV/hHTJNYo/P6S/6zHQFUmCtmsGMibBc9gZ65+RL6jxrafvva/hsr9wQLcwXzcnrf5n4jNdTlPVtIPOZOCxKgT2Nh375uaDpK5OG4uXlB/0/goPRWqW8n4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HVW61RfS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HVW61RfS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8B57C4CECD;
	Thu, 17 Oct 2024 18:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729191479;
	bh=rfaEJDW7NCAX9gEtorsZS0hjtrv4YAqTIE+H9l92W+Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=HVW61RfSGb/QRQH06jalhjykup3fhkNnh8uA4WzDvg8uQlvSclB/xOFyVnfAZW2DM
	 gwOHyPV1gFdVDhgdqRiTcqCz/SgKJCYTnQRmEAMbLhztFdAho/a34cC4XfvcaaqhRy
	 cyNcqYQoh/Z/8/KYWBFdY4LeuuTYSQOgXC+TrAVLmxIqqbEikLpN7weN07J5SyIAgB
	 qF5qWBWis6tbZEqojz1qyai3qyfJlcAR2y506eZd7owL8a1VVb++be1LfUdleHVAZd
	 SQhau4P6Wy+5lZap1kxIpAuuUx7PWr/wfrHKKjMHYzFMUmDsaN95LXBW3X1gNzqGLz
	 yKr9cPlIFUKwA==
Date: Thu, 17 Oct 2024 11:57:59 -0700
Subject: [PATCH 19/29] xfs: do not count metadata directory files when doing
 online quotacheck
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919069779.3451313.11456902405782054592.stgit@frogsfrogsfrogs>
In-Reply-To: <172919069364.3451313.14303329469780278917.stgit@frogsfrogsfrogs>
References: <172919069364.3451313.14303329469780278917.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/quotacheck.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/scrub/quotacheck.c b/fs/xfs/scrub/quotacheck.c
index c77eb2de8df71f..dc4033b91e440b 100644
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

