Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5A74947E
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713929091; cv=none; b=CgXU5ObvsirX6VR59807dPNKvokGV1jXpRgbUiDxaC/mLFDr3gNFuDzvkfF1W6rr5kjKS6afouUQ9S/0LF/093YPZqdLMXDqemHyYauw0Nz6kN66XBYHcFoLmzOnE1ZInB6bpbC+5TRPTaBsGoQUA5RnG5vf+oeY5b4qhD8GMlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713929091; c=relaxed/simple;
	bh=TIyniQhNT+/WGzhVnKiCKH7n+A7M7vLAZLaRKDjlUsM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HkinRk96ieZLrUzv89scn3Xk/j/IUKL3fnBM2fcl9J2EUhTZiUxumDQXxX3sw7dMpSTULE5NZzpH/op1bE2IIccN/PWaRO2IsKAdTimmAkGBKSfIAmnU0bx9LszUCSOqtygxNW/Hgr8/0oJdOgHFDyvZjaOf1zfOEe8yxV4G1Vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qfdVxTzL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qfdVxTzL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AEBBC116B1;
	Wed, 24 Apr 2024 03:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713929091;
	bh=TIyniQhNT+/WGzhVnKiCKH7n+A7M7vLAZLaRKDjlUsM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qfdVxTzL9da/Y4nXAEpFDMAyZZod1uFL6KUmQOpzL5fhEFEw5CvJhIH8mmA+nPZtH
	 RLV9DqdJKEj7wdZecXK36zz/VFimUYxDDxgRBc1h7eYxeSDFGyDvzjFmXRD39/Dnvy
	 cBKqIkqnH2/sR6hBZdOFqcHqmAG6LATFcnvcaLz1HtbOephO3YLuizq1ItNxSVue54
	 hRD6l2WHRArEyQ+UToVThuRttLJWgIOIXup2M9UXVsP8o2Qp2BFFD0+7145EIBZ2kN
	 Ex+s5Bv/S5WJMHl9oLaVatMMtRFeCRyTbN3ZplF8ZumovqmPMYhkqGJULikNln7jP1
	 8ErjVsaBjig3w==
Date: Tue, 23 Apr 2024 20:24:51 -0700
Subject: [PATCH 10/16] xfs: remove pointless unlocked assertion
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, catherine.hoang@oracle.com,
 allison.henderson@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171392784821.1906420.461835538115696808.stgit@frogsfrogsfrogs>
In-Reply-To: <171392784611.1906420.2159865382920841289.stgit@frogsfrogsfrogs>
References: <171392784611.1906420.2159865382920841289.stgit@frogsfrogsfrogs>
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

Remove this assertion about the inode not having an attr fork from
xfs_bmap_add_attrfork because the function handles that case just fine.
Weirder still, the function actually /requires/ the caller not to hold
the ILOCK, which means that its accesses are not stabilized.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c |    2 --
 1 file changed, 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 8a1446e025e0..1f528cf2d906 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1041,8 +1041,6 @@ xfs_bmap_add_attrfork(
 	int			logflags;	/* logging flags */
 	int			error;		/* error return value */
 
-	ASSERT(xfs_inode_has_attr_fork(ip) == 0);
-
 	mp = ip->i_mount;
 	ASSERT(!XFS_NOT_DQATTACHED(mp, ip));
 

