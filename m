Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70626197
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724371314; cv=none; b=dnlMu6X8/z1fJWWcV8SQ2RNLrIAph7tENwIb9psWp7Y5UpMhAkQGiV6FMJCUugc4QLE+yj7DrlS7EyL3V/InAYcwiBYIK0kxStwUJOz7sak856GKpMqueip7P6jjziQp9AR4r2dYFaJ/tbx9Bdg9yQlUs7/3osa3lgzl+wv7IqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724371314; c=relaxed/simple;
	bh=ogvNcSjC+aDmPHEFl9iYtaA7lVIEXZRLWN2fx8Eo8Xg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mNXQri39UA3uf4uLdrlPtTUzTDsQrR1ey6w1B3YcIPVVUjhnqTbMIrFmXcagElrgUgOAPkxFoDP0c80fiZWr17XNC1+E7AL4FztYA/jOwhVo/ulb5TfXHjFY71xSPowi+36J4pUNHALodYaRF93U1MVYrFI1en6PFMG0krtemQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AY9TTomC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AY9TTomC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E4A8C32782;
	Fri, 23 Aug 2024 00:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724371314;
	bh=ogvNcSjC+aDmPHEFl9iYtaA7lVIEXZRLWN2fx8Eo8Xg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=AY9TTomCUV5IjSqy9xlfwzrWDjL4x55TngiU2yItZMaoqo4enkv+1goIeoi4cad3B
	 lp984VWa2o4U+d6INwzPUrdeBaoVbLC8oaKco4VNgP2/veiutlVIoz2zl5+oioa3/g
	 fQiBBsIHJqfFnCt3kMW9CG7toHYU1Ay8eNo6SrYBoKw7EJYNMvcSd3Q9rE+wOh0AR9
	 ShfUQpWk6rG6n2SGksWA+kOu1Z3H86mfOpX5/kG+y6D7QiZhKP9gMym8dW29gVbpGh
	 khNrvOnPcCv5cpm94sscyTG/sCMO4T+5vYCI+csPXGxDszIK0kz8UxxhTK7iihvqC/
	 LDh08964bCUMg==
Date: Thu, 22 Aug 2024 17:01:53 -0700
Subject: [PATCH 2/3] xfs: match on the global RT inode numbers in
 xfs_is_metadata_inode
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437084673.57308.5311622647268357089.stgit@frogsfrogsfrogs>
In-Reply-To: <172437084629.57308.17035804596151035899.stgit@frogsfrogsfrogs>
References: <172437084629.57308.17035804596151035899.stgit@frogsfrogsfrogs>
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

Match the inode number instead of the inode pointers, as the inode
pointers in the superblock will go away soon.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: port to my tree, make the parameter a const pointer]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_inode.h |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 51defdebef30e..1908409968dba 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -276,12 +276,13 @@ static inline bool xfs_is_reflink_inode(struct xfs_inode *ip)
 	return ip->i_diflags2 & XFS_DIFLAG2_REFLINK;
 }
 
-static inline bool xfs_is_metadata_inode(struct xfs_inode *ip)
+static inline bool xfs_is_metadata_inode(const struct xfs_inode *ip)
 {
 	struct xfs_mount	*mp = ip->i_mount;
 
-	return ip == mp->m_rbmip || ip == mp->m_rsumip ||
-		xfs_is_quota_inode(&mp->m_sb, ip->i_ino);
+	return ip->i_ino == mp->m_sb.sb_rbmino ||
+	       ip->i_ino == mp->m_sb.sb_rsumino ||
+	       xfs_is_quota_inode(&mp->m_sb, ip->i_ino);
 }
 
 bool xfs_is_always_cow_inode(struct xfs_inode *ip);

