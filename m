Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B736AA7
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 00:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728607985; cv=none; b=tPh5gwnvC3xSLxqmheB/psVrLY8PgSapH2C/+tYaVWYiULTSibHAiLtK0dbQJdJzTfNkxmNqr3Z7BQ4gYzuN+yL/SLvReytI9X4pfc98NO/mesFOU5kzFHBQfhkYNNUicUruplBA1jdO92WOcoJn5IImg6hv1Uqwh+52oO3ncJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728607985; c=relaxed/simple;
	bh=rfaEJDW7NCAX9gEtorsZS0hjtrv4YAqTIE+H9l92W+Y=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qCyVTaFthWiMXd8/PY6UKWBVQFTZsOZFzugu8SDoHNddtgHxDaCrj2tDnPKXeVhCe1Z7mZ9KGkTbvlEYZK6ptxQvOnY0mhM2W1/vO7h7X0on+eDgVpHYabUkF0DHMJRelwNBwMD4QtLes8cHgck7HMhB09l0rRvYhsklGhOwCbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=anjZWZJB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="anjZWZJB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 441BFC4CEC5;
	Fri, 11 Oct 2024 00:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728607985;
	bh=rfaEJDW7NCAX9gEtorsZS0hjtrv4YAqTIE+H9l92W+Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=anjZWZJBlB0Es5u7sPwhfgu46CHbqhMVNUhaI7xfXpz2v88KhOcjP3bG+yQeWRnMd
	 r4NVXcqBCg7Cz4361QjSPS3RtsC/V4y3/jP8ieuK9jt9qatyj0RouT7MlxZNep+yXj
	 U0DNQKCM1EaOesya3w1zKWOsSPrBD10ie7cXB+4Hj51eEyjWLoE8+jf/V1R5eb3dnZ
	 lva0/kNjELS5/r33Z8UlBRXavb1xGJZBwSeIVt+nL7vSknN1IYiw+tN0lWjs0gxDrC
	 Y2voxHG+e3HXm5MPEMorLCdMFzSsAOAGTZdHJdeFLxZKa+HnqAN6jPppU2kAfclEqa
	 X0uD3UlA6fv9g==
Date: Thu, 10 Oct 2024 17:53:04 -0700
Subject: [PATCH 18/28] xfs: do not count metadata directory files when doing
 online quotacheck
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860642328.4176876.3553320685574534244.stgit@frogsfrogsfrogs>
In-Reply-To: <172860641935.4176876.5699259080908526243.stgit@frogsfrogsfrogs>
References: <172860641935.4176876.5699259080908526243.stgit@frogsfrogsfrogs>
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

