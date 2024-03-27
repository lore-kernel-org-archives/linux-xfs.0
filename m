Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF9831CA89
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 01:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711504292; cv=none; b=lPr06Plvo5lo1NofhqgKpTHzORp7Wg7flp2y6PIA/iPVmKqBMBFjLXAtFrS8NHaQnyGoWwUbFbBFy3jnNGysy9+u9Xto6LGO6OEE0rtDaZ0fTkTEro1mdP5bK7Q1qecz7pC0CLP3lvNE9KoSdlV0ykV+KcKtz/mJV434Q1X3rro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711504292; c=relaxed/simple;
	bh=AQL3lUw6lFnUZYcJHEvzUgA0Z9rGPa4M4W2a1hNo1Nk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uPl87hmhs0Zylar2S+v2L3nhrUsJ1Ay+4Jk7v27wMM34v8Zny7dczl/pFB3AWs4wuuSqtFFQb6DRDLluNet4E+KpHk0TdRoSmYgPZjTsWEDi31zjE6mZ84EdzwSDIdWVzUkxCdO7F6MtZAYDRSlcU/epTL1r4UjYLFA0Zru1QcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KuR8UhvZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KuR8UhvZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46E4DC433B2;
	Wed, 27 Mar 2024 01:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711504292;
	bh=AQL3lUw6lFnUZYcJHEvzUgA0Z9rGPa4M4W2a1hNo1Nk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=KuR8UhvZjwvJo5RrRWnM6NNWq4f/PX/dzXp6rK4gqF8gNUODuknBpUqWwXARSfyfe
	 ZHzzFRR051k5j12likdDMbW7qk5/0kNrAVJyAtZjbzt90RbGDDlG1CvNz/PlLMIzp6
	 Y4pLo97uylxDNriDIl5sVTDqb6M3fLtSFEU22KqDFFDp9sW3KsXUHmg6IkZ3aPOnXH
	 3UjllkFHsnc+lCAL6hOftqlP5nG0hMouWTwSxiP0kM0EcoFZfrhG1BkyV+4OAQuvXx
	 cZX2eEVXfD/o0D0X0loHLCIIZckz1Mngg+5cWsZEIfordvQy1QcNzM74mM6Sw4gohl
	 PGrG8PDzhtxvA==
Date: Tue, 26 Mar 2024 18:51:31 -0700
Subject: [PATCH 2/7] xfs: move xfs_iops.c declarations out of xfs_inode.h
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171150380166.3216450.9163025145750676383.stgit@frogsfrogsfrogs>
In-Reply-To: <171150380117.3216450.660937377362010507.stgit@frogsfrogsfrogs>
References: <171150380117.3216450.660937377362010507.stgit@frogsfrogsfrogs>
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

Similarly, move declarations of public symbols of xfs_iops.c from
xfs_inode.h to xfs_iops.h.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_inode.h |    5 -----
 fs/xfs/xfs_iops.h  |    4 ++++
 2 files changed, 4 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 5164c5d3e549c..b2dde0e0f265a 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -569,11 +569,6 @@ int	xfs_break_dax_layouts(struct inode *inode, bool *retry);
 int	xfs_break_layouts(struct inode *inode, uint *iolock,
 		enum layout_break_reason reason);
 
-/* from xfs_iops.c */
-extern void xfs_setup_inode(struct xfs_inode *ip);
-extern void xfs_setup_iops(struct xfs_inode *ip);
-extern void xfs_diflags_to_iflags(struct xfs_inode *ip, bool init);
-
 static inline void xfs_update_stable_writes(struct xfs_inode *ip)
 {
 	if (bdev_stable_writes(xfs_inode_buftarg(ip)->bt_bdev))
diff --git a/fs/xfs/xfs_iops.h b/fs/xfs/xfs_iops.h
index 7f84a0843b243..8a38c3e2ed0e8 100644
--- a/fs/xfs/xfs_iops.h
+++ b/fs/xfs/xfs_iops.h
@@ -19,4 +19,8 @@ int xfs_vn_setattr_size(struct mnt_idmap *idmap,
 int xfs_inode_init_security(struct inode *inode, struct inode *dir,
 		const struct qstr *qstr);
 
+extern void xfs_setup_inode(struct xfs_inode *ip);
+extern void xfs_setup_iops(struct xfs_inode *ip);
+extern void xfs_diflags_to_iflags(struct xfs_inode *ip, bool init);
+
 #endif /* __XFS_IOPS_H__ */

