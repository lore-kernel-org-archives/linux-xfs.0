Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AA544A06
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 00:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728607124; cv=none; b=c8Gclju+W32/Gja3HImKt8MIYDM7eqZvdZIMpjJRJfKeSQeHtmgWxNsBEXafgW9yVrutky8mUd9I6ov0L2FpvC0dotp3S49wi7+n8v1rBBRpfmEz1VdOh9qAqpU1eyYdRJ2IdB61kUdWslfgaI+8sWupTAUFK4RKFh9UzdqXtHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728607124; c=relaxed/simple;
	bh=+5fdu8qdFmVeFNAafbi/xcOTSlv9WIAZG9bIXIFrS9s=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Lajv/xMpy2KEjHX4vcyIsqfg/5ENNWczVL/ij81livdb3YL/A0Hhh+xH7LnV1aRs5clov1FlZbXYqGB+bjoLG0OhlqMpGYAWkIUxd19zWOoHm7RE0QugwvGmkxjKgIgk6ISvH52jzGsAFd3Szdkfhy4xBQDqs4yAR6Ph1xOm1yI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qk/5POlk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qk/5POlk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07F94C4CEC5;
	Fri, 11 Oct 2024 00:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728607124;
	bh=+5fdu8qdFmVeFNAafbi/xcOTSlv9WIAZG9bIXIFrS9s=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Qk/5POlk+gaKZaOoRuhew/5lM8YdbylOboK97UstJ85q9tcVdDx9fgGg33KrckjBI
	 VcBW1QSUZrZXXUOtsKZuJpHnrhly0S88XaLxrPvYT0ATvV+yn1dvrDzYZOeMM1ypJ5
	 gDfVSupi8nIrv6kZu7EPdys5uWTjlzOZy0438sux+fxh2PWW7nAQVs96usM3yY7+8c
	 /B/GhxovO2zV701kwJB7uTJd0ZatM4myYxqGdYDerkwodlX9PyYqT9qCT15FGM1VvK
	 TCdjPxzP6lOhYPLcyVKCYU/Hz1uNZtmtwA4uAFUDmZ20k1rj+F16cb9wJkm7rFQNf/
	 1s7U5MQunyxeQ==
Date: Thu, 10 Oct 2024 17:38:43 -0700
Subject: [PATCH 04/25] xfs: fix superfluous clearing of info->low in
 __xfs_getfsmap_datadev
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860640477.4175438.515806218457501719.stgit@frogsfrogsfrogs>
In-Reply-To: <172860640343.4175438.4901957495273325461.stgit@frogsfrogsfrogs>
References: <172860640343.4175438.4901957495273325461.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

The for_each_perag helpers update the agno passed in for each iteration,
and thus the "if (pag->pag_agno == start_ag)" check will always be true.

Add another variable for the loop iterator so that the field is only
cleared after the first iteration.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_fsmap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index ae18ab86e608b5..67140ef8c3232c 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -471,8 +471,7 @@ __xfs_getfsmap_datadev(
 	struct xfs_btree_cur		*bt_cur = NULL;
 	xfs_fsblock_t			start_fsb;
 	xfs_fsblock_t			end_fsb;
-	xfs_agnumber_t			start_ag;
-	xfs_agnumber_t			end_ag;
+	xfs_agnumber_t			start_ag, end_ag, ag;
 	uint64_t			eofs;
 	int				error = 0;
 
@@ -520,7 +519,8 @@ __xfs_getfsmap_datadev(
 	start_ag = XFS_FSB_TO_AGNO(mp, start_fsb);
 	end_ag = XFS_FSB_TO_AGNO(mp, end_fsb);
 
-	for_each_perag_range(mp, start_ag, end_ag, pag) {
+	ag = start_ag;
+	for_each_perag_range(mp, ag, end_ag, pag) {
 		/*
 		 * Set the AG high key from the fsmap high key if this
 		 * is the last AG that we're querying.

