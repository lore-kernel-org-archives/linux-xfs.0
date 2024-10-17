Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE64321BB06
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 19:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729192148; cv=none; b=l54X4eUgaandZRYi45cbWCPD+KS8Sj2hvYHTGiV9vvDApX0Bm3PWlh63SK83exxTLkvpDJljJ8T92z/ooGK9hfRwAWoxybUfXfxKfOL+ERi2dVFlrObCXXSwCIc7/U1/jbqZdF/Nuxdn6H16JA9tqr7Rg6iq4EZS/wn9GXmqhTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729192148; c=relaxed/simple;
	bh=d60rH7fFcqiNEhYSd45F21wjGrMUU5O7FOMl5KZu7JI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oxD3FpGspmjo7nqU4C6paH6GNgUb83j4LdN3pgrwl0KNiOpc05dXQSOt6cBAPpgCiOvCivOKWJS5Lu9bdnm95pl5CO3BD9GKmNVjFHNzaYY95Cv0UsOG4TurGyEQ67X0rwfv7Bxlql/GAycsp3DV7eDFb54M6eB9wnrBPQ922OQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hr2l89mo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hr2l89mo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6CD7C4CEC3;
	Thu, 17 Oct 2024 19:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729192148;
	bh=d60rH7fFcqiNEhYSd45F21wjGrMUU5O7FOMl5KZu7JI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hr2l89mo6QIr+UW/T4cMJWgGW5LKrSkU67a/oAZ7KPsy69+hIAKxurvmYMH1Af2GP
	 gsaX4FQ5T6gcNv9n5OHaF1hfHAMLqZEdokdCKAoRwk2M0NrbJSmYP0lAKqHpC3doom
	 jl/4bHNrQ+nIB2dVNHfJ8/XVSJhvE3izL8r4Z+fWRTmfjhJW2fd7ZFsQqB0LzO1Dni
	 yajlbYAsPg0C2LuE7bOWyb/dnP5dX23svqZj6x9CgI+iZZ9eCW2vRSM5g8o8qVwyTN
	 GUDm7hZ9/5HR6JlXw/BcdVCOQ3fc+OIE77gVJk6fQS5HjJAiHLUkmHgG0+4BBq+EPr
	 qIOWZbxkuflqw==
Date: Thu, 17 Oct 2024 12:09:08 -0700
Subject: [PATCH 30/34] xfs: adjust min_block usage in xfs_verify_agbno
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919072188.3453179.15405009921166966765.stgit@frogsfrogsfrogs>
In-Reply-To: <172919071571.3453179.15753475627202483418.stgit@frogsfrogsfrogs>
References: <172919071571.3453179.15753475627202483418.stgit@frogsfrogsfrogs>
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

