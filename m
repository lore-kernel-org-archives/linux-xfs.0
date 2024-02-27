Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6115F1096F
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 02:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709000390; cv=none; b=j8doRgcDdEA1tPikIdQsPJW9muK0uMaQL+Ar+zF8/S9JcySBma8P0zE6QkBbOicv6+ssrs21O+9UJHRFkXgeNOcI/j6+Euzb9MDc4f//aka5ej+cnO4Sg4VR9AXGZMCDpKv7Ue6c/F4tZ6VbXV7wN3qeAIjLe5P7eI5+8P5MJDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709000390; c=relaxed/simple;
	bh=FUYuDmBfAmSpQSFQXshGrN3/56VoOeKJhy4Ns/zt5NU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UL3fTK2kRQaUJB0luaIyI+WI2vMWySvDYBt2AnFxcbcL/9pZCfETzjmN8O2Jn96qTCYPwzS/dFdZVAsG829HOgBCxWJo6Kn0UUfaeKwVfbtOQGesLU+ZPkNLBkGzdZXKU21OPTdMef4ZBvwOERaDEMYXqR4Uo/pN+HuGAb7DLbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tMpM7HYY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tMpM7HYY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0DA2C433C7;
	Tue, 27 Feb 2024 02:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709000389;
	bh=FUYuDmBfAmSpQSFQXshGrN3/56VoOeKJhy4Ns/zt5NU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=tMpM7HYYfanmSzX7tkWIoAhe0T+H5Ync4Cuz1dtPksDPNl2S49Tq30gudfRFwEz9K
	 Z8pQA+LXjYIvixplbl8Csjf0w8x4rqV7H5ac4eXQ4XAW/L7AXRnK1uslwwCI6jZTe6
	 3l4EaiXpBOfhuD+qC+MNAEpuFlz8IHrQ53OCmRya+YRAXOEBnkJhVkvvN1rfZ6RdD6
	 YzeTWaBmOhIyK2ZMoohGnwM8BhZMJ/0Y41RXs149bf+wYPQDyvSTe+/qbRP9jBeQcf
	 e0cSO7pg6wqMT/dkrrsdRWHjJfbDySXQ1gfHQlKTNXel99zoy9XKZbbq/KYDyQwRhT
	 riSEpA7L6Wtpw==
Date: Mon, 26 Feb 2024 18:19:49 -0800
Subject: [PATCH 2/6] xfs: move xfs_iops.c declarations out of xfs_inode.h
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <170900011166.938068.15976644595631519866.stgit@frogsfrogsfrogs>
In-Reply-To: <170900011118.938068.16371783443726140795.stgit@frogsfrogsfrogs>
References: <170900011118.938068.16371783443726140795.stgit@frogsfrogsfrogs>
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
---
 fs/xfs/xfs_inode.h |    5 -----
 fs/xfs/xfs_iops.h  |    4 ++++
 2 files changed, 4 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index dfa72cee2b230..361a3d5efb903 100644
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

