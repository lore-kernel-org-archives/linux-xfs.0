Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CEADB653
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZZGJ1kXj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 837B4C433C7;
	Sun, 31 Dec 2023 20:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704054317;
	bh=s1JVBqffl3F4XMLlAjzqo8SIlfUvF0o+fzFknAhntGU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZZGJ1kXj4X13UotHCZQahSUJO3g3fVaMqocUiy11zXgRrrU15tTc2CoKeMyR1VGMD
	 Ui+Ld5PIj6h2h79ARKVFNtZV0y4aJuC8bCagCSc0KhxwsjL+apjAtPFOqhL2yu0v0/
	 DuihkhOOxKTYFiRiwMfu9NdOP0rR9AgGn57JHrw6mBqK0SpsB+uYSkDHY8EzOhqcN3
	 zRbpKpLfpbpAVVcmmfTL+YVxwSSoZksR7tUou7uIUkof+GJTF3yCYC29sVTb4KqhzF
	 xhsRJ3EDymnVzEYmxHdVnBCWzro3Akj2oawUcLnN2IhXVGvr6229gLtTY06zrXACbr
	 wb6CWipmuPTzw==
Date: Sun, 31 Dec 2023 12:25:17 -0800
Subject: [PATCH 04/25] xfs: move xfs_iops.c declarations out of xfs_inode.h
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404833203.1750288.15112697177753675130.stgit@frogsfrogsfrogs>
In-Reply-To: <170404833081.1750288.16964477956002067164.stgit@frogsfrogsfrogs>
References: <170404833081.1750288.16964477956002067164.stgit@frogsfrogsfrogs>
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
index 3611597343658..5e2f163fd7445 100644
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

