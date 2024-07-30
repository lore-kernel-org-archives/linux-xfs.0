Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A2784A21
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722300044; cv=none; b=NMNYuWZ0OKQMS0zei9L3UHaI3J7jKx0zQlQRfR8BzcEmdLW04Fs2V6dtLrlUgZsBv0UQF1jqKC7cJKB8GCdxXrtV9RUZPlTTNMKqiBjXDPGUZ8E8YLdUo+uY4uGYx43EaTOW0Jxztx+ISs1Ado5joih3WbElPBZgoTX6LlZRsis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722300044; c=relaxed/simple;
	bh=CAR/KcwKlrFRbbODw5+0kfheWLR3DpxZPuqd+wk/G6Q=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=flaf8FrqdPApY/MjUjM9+KbR5E1zUa9e5kEqIgkTfkSYmIdLUQFRCfFpCTdEE6+SYahGsV/Q1sE702oChMvPCFQGaKTbfVj1YP06PBIU3l8nKgMqnK2xXBDLwOVWqvUKYFBzndR6EmS7bcY0gos4scF18uyxD/OgHKeteKz05t0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q3baNh9X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q3baNh9X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 509CAC32786;
	Tue, 30 Jul 2024 00:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722300044;
	bh=CAR/KcwKlrFRbbODw5+0kfheWLR3DpxZPuqd+wk/G6Q=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Q3baNh9X1sv8vPlyZmGZxu+GsxADME1PLUkNeRT3tZ5nn+xLQ1f1WUEP37eaJ6jR9
	 rGjESZ3SrQYddOJyBpgZ0Hh0iWWQfhsBkDbAtj/N0W0xLceX0NN9AfKAJhGc9HE5N/
	 urdVCdw9fjnxkPNgfFkptHshSnWaWv3aJ6bmx/iK3ItRbh6gprZHAEfouGEX8aQiA3
	 p6gdHrZJDJW2vwDuO0I27uDvMSn5KzYVTQE7sxjqzzpeA3GIlYcHfeb11GU15tg3G2
	 nmTH158k786SS3XmMp6Rm/gyvsC0GxHlBOhSO1CXEhCoDB9ZkFRhEYBLZG1ziRQHbI
	 +ISUNmv10b1fg==
Date: Mon, 29 Jul 2024 17:40:43 -0700
Subject: [PATCH 065/115] xfs: add parent attributes to symlink
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229843358.1338752.10591416095036311151.stgit@frogsfrogsfrogs>
In-Reply-To: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
References: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Allison Henderson <allison.henderson@oracle.com>

Source kernel commit: 5d31a85dcc1fa4c5d4a925c6da67751653a700ba

This patch modifies xfs_symlink to add a parent pointer to the inode.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: minor rebase fixups]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_trans_space.c |   17 +++++++++++++++++
 libxfs/xfs_trans_space.h |    4 ++--
 2 files changed, 19 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_trans_space.c b/libxfs/xfs_trans_space.c
index 039bbd91e..bf4a41492 100644
--- a/libxfs/xfs_trans_space.c
+++ b/libxfs/xfs_trans_space.c
@@ -64,3 +64,20 @@ xfs_link_space_res(
 
 	return ret;
 }
+
+unsigned int
+xfs_symlink_space_res(
+	struct xfs_mount	*mp,
+	unsigned int		namelen,
+	unsigned int		fsblocks)
+{
+	unsigned int		ret;
+
+	ret = XFS_IALLOC_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp, namelen) +
+			fsblocks;
+
+	if (xfs_has_parent(mp))
+		ret += xfs_parent_calc_space_res(mp, namelen);
+
+	return ret;
+}
diff --git a/libxfs/xfs_trans_space.h b/libxfs/xfs_trans_space.h
index 553963400..354ad1d6e 100644
--- a/libxfs/xfs_trans_space.h
+++ b/libxfs/xfs_trans_space.h
@@ -95,8 +95,6 @@
 	XFS_DIRREMOVE_SPACE_RES(mp)
 #define	XFS_RENAME_SPACE_RES(mp,nl)	\
 	(XFS_DIRREMOVE_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp,nl))
-#define	XFS_SYMLINK_SPACE_RES(mp,nl,b)	\
-	(XFS_IALLOC_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp,nl) + (b))
 #define XFS_IFREE_SPACE_RES(mp)		\
 	(xfs_has_finobt(mp) ? M_IGEO(mp)->inobt_maxlevels : 0)
 
@@ -106,5 +104,7 @@ unsigned int xfs_parent_calc_space_res(struct xfs_mount *mp,
 unsigned int xfs_create_space_res(struct xfs_mount *mp, unsigned int namelen);
 unsigned int xfs_mkdir_space_res(struct xfs_mount *mp, unsigned int namelen);
 unsigned int xfs_link_space_res(struct xfs_mount *mp, unsigned int namelen);
+unsigned int xfs_symlink_space_res(struct xfs_mount *mp, unsigned int namelen,
+		unsigned int fsblocks);
 
 #endif	/* __XFS_TRANS_SPACE_H__ */

