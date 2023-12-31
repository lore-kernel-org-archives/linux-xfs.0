Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E350BA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p4rhPSqF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCD2DC433C7;
	Sun, 31 Dec 2023 21:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704057133;
	bh=ByZth97vGpuCuL0gQKZ31r0lxGDekSXAKqKGrfIDOMg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=p4rhPSqFUUNNCChc2kb1aWiwG8X9NWBRLiuoTmKPJ3cfPDMw85gEmhJ4qry6c3map
	 EaTHluLI3/ZCpI1EZagk2ecEiuEy18+FiJAOIXk2A9UyY2EUkHqxaMiN+0VVfniC1J
	 LjgA/pHBtJRiVThtxWXn6ri2BNWhIn3gb3sZIlgusOXJ2ZYXszhdhMJpFft8RXzMXK
	 1/mzw35nyEI/awLxObkZXv0NfBe+weVQZUfQFvK+wQIMeL2FMhAuqVaBHrgywfNO3z
	 LMEWclvsgbaLGFf4HFD7es3e9TL6948mgg4oMpQsaf1FHSQv2Ru5djs8RuorHJ6E0H
	 kj/QMBR4rm5ng==
Date: Sun, 31 Dec 2023 13:12:13 -0800
Subject: [PATCH 23/32] xfs: do not count metadata directory files when doing
 online quotacheck
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404845236.1760491.1388876690075583588.stgit@frogsfrogsfrogs>
In-Reply-To: <170404844790.1760491.7084433932242910678.stgit@frogsfrogsfrogs>
References: <170404844790.1760491.7084433932242910678.stgit@frogsfrogsfrogs>
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
index a2f728d76fab2..812a0f91458e9 100644
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

