Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E693021353
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711424661; cv=none; b=rJdDi4NlCCfFqLmF8FNXYCueR/oF2BQljPtIYsnej4C1izsAbM3wrEAD1gHTrX76wfYtGIytLgqf923K4hb4YAxI0uLlH9DYOUGmdx5bmntQIZ7QFpfk4j0BXyO/HrSC4XtFl/gAT3AXh68t9wDX+0qmT4lG85yHZ0ZctcB85/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711424661; c=relaxed/simple;
	bh=3AiVI+qxcC1h/DYES7/fWAFdzhkD8tL4W/8db6dJ/+g=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HUyHgQtWlhWkw5pFGNyUXibrzSflJNARekNT8dBjz2y7EzKbQPOjZD7reERyFOh3OfZtUkgsyJvQWBy75r1lhTnB7Ed2MET40TwaKgDOJpj+lIuptjrey3KZ3hTaiMW7yVR4427Tr71/7mJeVpoSXSfyatoGvR6BfsNadKl446g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z3CdAOe3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z3CdAOe3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC1BFC433F1;
	Tue, 26 Mar 2024 03:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711424660;
	bh=3AiVI+qxcC1h/DYES7/fWAFdzhkD8tL4W/8db6dJ/+g=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Z3CdAOe3YPxSM8drAuz4/y1/6hxKEZj6Ipflea1sVquLn0OwKlXUiaTyUMkHnrBLu
	 rBv3hpweEAONDXuCtYIspOUsq2tmUsNhIoBQwAykqu4G3Uk6QKVuTX7fvHL2d0Xp4c
	 1oHkhdfCxSI8hhQZ/oOj8r1SQvMD9nSzDm0Ny8JefOA13s/WIBiusAXk15RIhtiOeQ
	 u6PNj6E/jWJ284NkFhQ90o17oJXu9R+jKVqh791oJcE2jf3rwvt3tYXii5ZahSiEgD
	 IdjOitHBj2u4Bpm487uXo8Pr2NpCSwIEoCuDeWOnNzDTK8wFn/ygzxJD4W/4U6Xfw0
	 e3OhotzgVCmqA==
Date: Mon, 25 Mar 2024 20:44:20 -0700
Subject: [PATCH 061/110] xfs: make full use of xfs_btree_stage_ifakeroot in
 xfs_bmbt_stage_cursor
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142132257.2215168.15905320920162278350.stgit@frogsfrogsfrogs>
In-Reply-To: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
References: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
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

Source kernel commit: 579d7022d1afea8f4475d1750224ec0b652febee

Remove the duplicate cur->bc_nlevels assignment in xfs_bmbt_stage_cursor,
and move the cur->bc_ino.forksize assignment into
xfs_btree_stage_ifakeroot as it is part of setting up the fake btree
root.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_bmap_btree.c    |    2 --
 libxfs/xfs_btree_staging.c |    1 +
 2 files changed, 1 insertion(+), 2 deletions(-)


diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index 611f5ed962bd..dedc33dc5049 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -611,8 +611,6 @@ xfs_bmbt_stage_cursor(
 
 	/* data fork always has larger maxheight */
 	cur = xfs_bmbt_init_common(mp, NULL, ip, XFS_DATA_FORK);
-	cur->bc_nlevels = ifake->if_levels;
-	cur->bc_ino.forksize = ifake->if_fork_size;
 
 	/* Don't let anyone think we're attached to the real fork yet. */
 	cur->bc_ino.whichfork = -1;
diff --git a/libxfs/xfs_btree_staging.c b/libxfs/xfs_btree_staging.c
index 5a988a8bfdd2..52410fe4f2e4 100644
--- a/libxfs/xfs_btree_staging.c
+++ b/libxfs/xfs_btree_staging.c
@@ -133,6 +133,7 @@ xfs_btree_stage_ifakeroot(
 
 	cur->bc_ino.ifake = ifake;
 	cur->bc_nlevels = ifake->if_levels;
+	cur->bc_ino.forksize = ifake->if_fork_size;
 	cur->bc_flags |= XFS_BTREE_STAGING;
 }
 

