Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F3221CCB2D
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730846263; cv=none; b=lvzpl8A4lmSpx3hIWlU7y9q9k6oiRBZbnz/13ZenD/+B/OtPf2RU6gv5gpzkQSdp/KHwWsXndL6k2q8XCRH/uNbl0gWws43zsHg4cWDJDND3Sqn/d+qaqC1n1ZpUB5LP3ap87LxF1MUDfJtoJcJcZfHoBlmjs9odIOjTrcNW7cA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730846263; c=relaxed/simple;
	bh=d60rH7fFcqiNEhYSd45F21wjGrMUU5O7FOMl5KZu7JI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jadU5G1Ykb79Cri1cxI31PdeqNxrXQjYRGcbnpFOrxL6IQQdT/HdMhCBkKcC3Sa9K4ET91gcgD09WUX0p9x5uAejeMVxR367ORRv18wUPachCAA6COtGg49AFV42EkLQgpQFoBPaBNpAwe3/IAzu++foMUEF5IfNDAHdy29DW7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KdI7kYYr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KdI7kYYr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 131C8C4CECF;
	Tue,  5 Nov 2024 22:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730846263;
	bh=d60rH7fFcqiNEhYSd45F21wjGrMUU5O7FOMl5KZu7JI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=KdI7kYYrkfok2ZVzFHD+Kfe0Dhjc9VJYAgh/dK/xL+V2m8MqEQbBgZEF9bspaYacd
	 xwN8Y6S2DUkDx/F9co/jd2LSnyNTK+uXKrZZwEu39tvtpU4aDkyjzGb18BwDnrRl+A
	 hmD9sXJtKPoJXrYhM7w+/hhVjiktxHlpklVU4RMKBnPohRZQjny+YkLev9nI7rWK4Y
	 szrsaNCgzGRJIqaXllhR+jhoRfAGC24ihVPF/QOmDl24N5/9veAau25emE7E+uuXKN
	 DcjQ3QZ0hJ+R302/gEDFRZQ8SLRJxgeRkd3eJojZX980muBJHuQ4SBjtNBubN6qEcP
	 iL3YXc4G2ZZAg==
Date: Tue, 05 Nov 2024 14:37:42 -0800
Subject: [PATCH 30/34] xfs: adjust min_block usage in xfs_verify_agbno
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084398697.1871887.15999666602270608478.stgit@frogsfrogsfrogs>
In-Reply-To: <173084398097.1871887.5832278892963229059.stgit@frogsfrogsfrogs>
References: <173084398097.1871887.5832278892963229059.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

There's some weird logic in xfs_verify_agbno -- min_block ought to be
the first agblock number in the AG that can be used by non-static
metadata.  However, we initialize it to the last agblock of the static
metadata, which works due to the <= check, even though this isn't
technically correct.

Change the check to < and set min_block to the next agblock past the
static metadata.  This hasn't been an issue up to now, but we're going
to move these things into the generic group struct, and this will cause
problems with rtgroups, where min_block can be zero for an rtgroup that
doesn't have a rt superblock.

Note that there's no user-visible impact with the old logic, so this
isn't a bug fix.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_ag.c |    2 +-
 fs/xfs/libxfs/xfs_ag.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 47e90dbb852bba..8fe96a9e047205 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -242,7 +242,7 @@ xfs_perag_alloc(
 	 * Pre-calculated geometry
 	 */
 	pag->block_count = __xfs_ag_block_count(mp, index, agcount, dblocks);
-	pag->min_block = XFS_AGFL_BLOCK(mp);
+	pag->min_block = XFS_AGFL_BLOCK(mp) + 1;
 	__xfs_agino_range(mp, pag->block_count, &pag->agino_min,
 			&pag->agino_max);
 
diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index 7290148fa6e6aa..9c22a76d58cfc2 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -222,7 +222,7 @@ xfs_verify_agbno(struct xfs_perag *pag, xfs_agblock_t agbno)
 {
 	if (agbno >= pag->block_count)
 		return false;
-	if (agbno <= pag->min_block)
+	if (agbno < pag->min_block)
 		return false;
 	return true;
 }

