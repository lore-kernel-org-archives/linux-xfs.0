Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF05013A271
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724371252; cv=none; b=J5FbY5Ieyqy7LocKdyKxOHJNhm4Pk79hPigF0ZBudzVfz0eQolD1Bi2uX2qIychgjdAiBDSJoYNDQFiZ6E4cWLFEAAfzUsvrjz5b2Wsy0PgVw96Dltfux7czu8J8pf0RR2ML2i1efEEB23KYrqQR8zIesM2ljx2uPh9p40v4XRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724371252; c=relaxed/simple;
	bh=bM0P8wXCQQxXmJaK9G7PVxUIjvmqQj7yirCtaafIK3k=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sxEMtYRr4lcdBggyvMNhVRKo3n9wUnhlO+Oh1JDJiWD3CwnSMHxO9COoGZ7Eh8bsqiP9Cp20PRqnWgygccl1fEjU4y5iCL7hLWBOaVDjH9Y9o8PhtjK8BqhTC72U4SGNk4S/uTyIzKPxiJYOBj7B2nzJ/EjJQT+ZEq6mCBS8fN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sWpbN3bV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sWpbN3bV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD1CBC4AF0E;
	Fri, 23 Aug 2024 00:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724371251;
	bh=bM0P8wXCQQxXmJaK9G7PVxUIjvmqQj7yirCtaafIK3k=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=sWpbN3bVruSCzzgRFkYy68xvwykG9WCJniuixmg5iifhX4WjrcEdbeYbRhyU/ejvc
	 qhC0VdODg7WsXLBiFdUJKoV9F3yeBoY1Rt+J6OWSSWMI0eFFM69fN0gRU2ro5ytiX/
	 9vvSsb3/XStqTgzhId/JLVD6gHfBSH+s2I3a9UAZ8rhxw+u9DJe8Gth7Jlz4z/u9lJ
	 9T4sLmzul8FNnCalRVdrthZbHVOWlIE38f2m/DoA0sWe20MMBGdfYFYFUpdAln5CuC
	 jWElTjoYPqd1T/fUvnrujNDiNHRVyjEDPsQfpq9iw06kqcKW4/oL/+xbnx8dCBNfau
	 HYs3ELIM1ZOMw==
Date: Thu, 22 Aug 2024 17:00:51 -0700
Subject: [PATCH 8/9] xfs: take m_growlock when running growfsrt
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437083888.56860.4421290709549600558.stgit@frogsfrogsfrogs>
In-Reply-To: <172437083728.56860.10056307551249098606.stgit@frogsfrogsfrogs>
References: <172437083728.56860.10056307551249098606.stgit@frogsfrogsfrogs>
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

Take the grow lock when we're expanding the realtime volume, like we do
for the other growfs calls.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_rtalloc.c |   38 +++++++++++++++++++++++++-------------
 1 file changed, 25 insertions(+), 13 deletions(-)


diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 0c3e96c621a67..776d6c401f62f 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -821,34 +821,39 @@ xfs_growfs_rt(
 	/* Needs to have been mounted with an rt device. */
 	if (!XFS_IS_REALTIME_MOUNT(mp))
 		return -EINVAL;
+
+	if (!mutex_trylock(&mp->m_growlock))
+		return -EWOULDBLOCK;
 	/*
 	 * Mount should fail if the rt bitmap/summary files don't load, but
 	 * we'll check anyway.
 	 */
+	error = -EINVAL;
 	if (!mp->m_rbmip || !mp->m_rsumip)
-		return -EINVAL;
+		goto out_unlock;
 
 	/* Shrink not supported. */
 	if (in->newblocks <= sbp->sb_rblocks)
-		return -EINVAL;
+		goto out_unlock;
 
 	/* Can only change rt extent size when adding rt volume. */
 	if (sbp->sb_rblocks > 0 && in->extsize != sbp->sb_rextsize)
-		return -EINVAL;
+		goto out_unlock;
 
 	/* Range check the extent size. */
 	if (XFS_FSB_TO_B(mp, in->extsize) > XFS_MAX_RTEXTSIZE ||
 	    XFS_FSB_TO_B(mp, in->extsize) < XFS_MIN_RTEXTSIZE)
-		return -EINVAL;
+		goto out_unlock;
 
 	/* Unsupported realtime features. */
+	error = -EOPNOTSUPP;
 	if (xfs_has_rmapbt(mp) || xfs_has_reflink(mp) || xfs_has_quota(mp))
-		return -EOPNOTSUPP;
+		goto out_unlock;
 
 	nrblocks = in->newblocks;
 	error = xfs_sb_validate_fsb_count(sbp, nrblocks);
 	if (error)
-		return error;
+		goto out_unlock;
 	/*
 	 * Read in the last block of the device, make sure it exists.
 	 */
@@ -856,7 +861,7 @@ xfs_growfs_rt(
 				XFS_FSB_TO_BB(mp, nrblocks - 1),
 				XFS_FSB_TO_BB(mp, 1), 0, &bp, NULL);
 	if (error)
-		return error;
+		goto out_unlock;
 	xfs_buf_relse(bp);
 
 	/*
@@ -864,8 +869,10 @@ xfs_growfs_rt(
 	 */
 	nrextents = nrblocks;
 	do_div(nrextents, in->extsize);
-	if (!xfs_validate_rtextents(nrextents))
-		return -EINVAL;
+	if (!xfs_validate_rtextents(nrextents)) {
+		error = -EINVAL;
+		goto out_unlock;
+	}
 	nrbmblocks = xfs_rtbitmap_blockcount(mp, nrextents);
 	nrextslog = xfs_compute_rextslog(nrextents);
 	nrsumlevels = nrextslog + 1;
@@ -876,8 +883,11 @@ xfs_growfs_rt(
 	 * the log.  This prevents us from getting a log overflow,
 	 * since we'll log basically the whole summary file at once.
 	 */
-	if (nrsumblocks > (mp->m_sb.sb_logblocks >> 1))
-		return -EINVAL;
+	if (nrsumblocks > (mp->m_sb.sb_logblocks >> 1)) {
+		error = -EINVAL;
+		goto out_unlock;
+	}
+
 	/*
 	 * Get the old block counts for bitmap and summary inodes.
 	 * These can't change since other growfs callers are locked out.
@@ -889,10 +899,10 @@ xfs_growfs_rt(
 	 */
 	error = xfs_growfs_rt_alloc(mp, rbmblocks, nrbmblocks, mp->m_rbmip);
 	if (error)
-		return error;
+		goto out_unlock;
 	error = xfs_growfs_rt_alloc(mp, rsumblocks, nrsumblocks, mp->m_rsumip);
 	if (error)
-		return error;
+		goto out_unlock;
 
 	rsum_cache = mp->m_rsum_cache;
 	if (nrbmblocks != sbp->sb_rbmblocks)
@@ -1059,6 +1069,8 @@ xfs_growfs_rt(
 		}
 	}
 
+out_unlock:
+	mutex_unlock(&mp->m_growlock);
 	return error;
 }
 

