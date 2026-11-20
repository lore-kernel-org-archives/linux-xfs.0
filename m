Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795190319;
	b=5RlGqUAOA/IsilCAb/LnMxjqpFe4JhItK7pMTJVXSEtn63n8QrpZKBJt8i+dc3EBgTfH
	 5zbDHh24B+n+8zxpr2ITnDMnzQcvHtP5VYp9Mdk3ms0Pej2s8s2sEZkg8Xrlenkshq17L
	 kwTgE/IR77DhlgXSFdiLETSyXLcuHkgDF8cEoBeFURuTRRPdtNv83W/xk2gxg6YWhlt0o
	 /GwQlwW6Nce3ObKR9xw6CFXxEw/ZbakyOqtkUS9QJDQko9sYFAidVezA50Y1Q+AgdIZG5
	 KM2I9pk7dCHymYUbK3MLfvmEKK0L8U/sTXtE7si2shBCrK16iy8I6uWaMkFjasmPHRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795190319;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=kOtsGYzhoL+vZGF+OMqW00T0jt3SpjftMt5O0uMgDkI=;
	b=43+H9KcfODDIlAJSDqofL8RUAqzIL3T6ypnNW+OTTWxQTmV1v2ehtwz/9CF1sbJD0Vqn
	 YJIPgoJ18seh9EIxlH6lTgcF5AmXxNggtDRkpZrmUAQ5K2LdFBiMfLp5iAj9PuxntG6G6
	 wdkBwItto2F2Ygb/kXqPEgtsJhCimQt2+ftpkYA5YFpqO3eDQUMd6Cw/iptfQ0M5KL2Ce
	 /Aqwza6D1+xiEB1EI4PyX2h3FMZx4m5swHrzaf10XVInXeMsFXNbIbr9FDkfDeeB/CQxQ
	 5K96jqzeXExDQJFjMHznRwSLr/0tCm71mdjgyKPgueSMrOYV1DDN+Nge/9lEVwX/WZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lHc+Jzai;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48D3360A2630;
	Fri, 20 Nov 2026 15:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lHc+Jzai
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14AC81F01564;
	Fri, 20 Nov 2026 15:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795190319;
	bh=kOtsGYzhoL+vZGF+OMqW00T0jt3SpjftMt5O0uMgDkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lHc+JzaiGtwovRG9nUoewfVu4mah6gG3WdcWUcraBTn8i23zTyoaHy88bTQCBkPmp
	 m0R+0b+pnARV6RJLdj7T8Qw4sf66Qu75dMY1VXxcR9G5xECfFW09kcutXHwH0H6A6b
	 4aj/Z/6mIYWTgDfPAs0L5WL+K+3sDdSPRlJsApoTbzEtGA+dU04jhB0sxCWdWANuKZ
	 7FpaftPbDWOuidU2JZRbZRVTInOwAyovE/MKFfRzFdjiRL5y0pwikkO8CRF7l6w5yL
	 RPVwsp9yCUPLygvj6GJCAeE9eTnR7Dxwt4dIqYgO0nTExe1NA0EcRLl+WVqA4Io0sp
	 Y2w3c0foNFvrQ==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>,
	"Christoph Hellwig" <hch@lst.de>,
	"Carlos Maiolino" <cem@kernel.org>,
	"fsverity" <fsverity@lists.linux.dev>,
	"linux-xfs" <linux-xfs@vger.kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	"fsdevel" <linux-fsdevel@vger.kernel.org>,
	david@fromorbit.com,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH v19 08/15] xfs: don't remove written extents past EOF on fsverity inodes
Date: Fri, 20 Nov 2026 16:57:42 +0100
Message-ID: <20261120155752.192025-9-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261120155752.192025-1-aalbersh@kernel.org>
References: <20261120155752.192025-1-aalbersh@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

xfs_free_eofblocks() removes all extents past EOF unless the
XFS_DIFLAG_PREALLOC or XFS_DIFLAG_APPEND flags are set. This is
undesired for fsverity as it stores metadata beyond EOF. However, while
merkle tree is being built, delayed preallocation and unwritten extents
are used. After metadata construction is done, fsverity inodes becomes
read-only and won't be changed anymore, none of these unwritten extents
or preallocations in post EOF region will be used.

Let xfs_free_eofblocks() be called on fsverity inode as usual to remove
anything which is not written extent. However, inodes which are
undergoing merkle tree construction need to be skipped in case reclaim
takes place.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_bmap_util.c | 32 +++++++++++++++++++++++++++++---
 fs/xfs/xfs_icache.c    | 11 ++++++++++-
 2 files changed, 39 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 865aec3ae5ab..d6130cfc8246 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -31,6 +31,7 @@
 #include "xfs_rtbitmap.h"
 #include "xfs_rtgroup.h"
 #include "xfs_zone_alloc.h"
+#include <linux/fsverity.h>
 
 /* Kernel only BMAP related definitions and functions */
 
@@ -553,6 +554,17 @@ xfs_can_free_eofblocks(
 	if (last_fsb <= end_fsb)
 		return false;
 
+	/*
+	 * Don't clean fsverity inodes as they already have been cleaned up and
+	 * are read-only. Skip inodes which have merkle tree being built, the
+	 * merkle tree is written beyond EOF. Skip inodes which have
+	 * XFS_DIFLAG2_VERITY in case this kernel has fsverity disabled.
+	 */
+	if (fsverity_active(VFS_IC(ip)) ||
+	    fsverity_is_building(VFS_I(ip)) ||
+	    ip->i_diflags2 & XFS_DIFLAG2_VERITY)
+		return false;
+
 	/*
 	 * Check if there is an post-EOF extent to free.  If there are any
 	 * delalloc blocks attached to the inode (data fork delalloc
@@ -579,6 +591,8 @@ xfs_free_eofblocks(
 	struct xfs_trans	*tp;
 	struct xfs_mount	*mp = ip->i_mount;
 	int			error;
+	int			bmapi_flags = XFS_BMAPI_NODISCARD;
+	bool			verity = fsverity_is_building(VFS_I(ip));
 
 	/* Attach the dquots to the inode up front. */
 	error = xfs_qm_dqattach(ip);
@@ -593,15 +607,20 @@ xfs_free_eofblocks(
 	 *
 	 * Note that this means we also leave speculative preallocations in
 	 * place for preallocated files.
+	 *
+	 * Clean up delalloc reservations for fsverity too as those won't be
+	 * used
 	 */
-	if (ip->i_diflags & (XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND)) {
+	if (ip->i_diflags & (XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND) ||
+			verity) {
 		if (ip->i_delayed_blks) {
 			xfs_bmap_punch_delalloc_range(ip, XFS_DATA_FORK,
 				round_up(XFS_ISIZE(ip), mp->m_sb.sb_blocksize),
 				LLONG_MAX, NULL);
 		}
 		xfs_inode_clear_eofblocks_tag(ip);
-		return 0;
+		if (!verity)
+			return 0;
 	}
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, &tp);
@@ -613,6 +632,13 @@ xfs_free_eofblocks(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
 
+	/*
+	 * While fs-verity writes metadata after EOF, it can leave unwritten
+	 * preallocations.  Clear all that out.
+	 */
+	if (verity)
+		bmapi_flags |= XFS_BMAPI_UNWRITTEN;
+
 	/*
 	 * Do not update the on-disk file size.  If we update the on-disk file
 	 * size and then the system crashes before the contents of the file are
@@ -620,7 +646,7 @@ xfs_free_eofblocks(
 	 * bug).
 	 */
 	error = xfs_itruncate_extents_flags(&tp, ip, XFS_DATA_FORK,
-				XFS_ISIZE(ip), XFS_BMAPI_NODISCARD);
+				XFS_ISIZE(ip), bmapi_flags);
 	if (error)
 		goto err_cancel;
 
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index de8be344e987..ca74c9b4f8d3 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -28,7 +28,7 @@
 #include "xfs_da_format.h"
 #include "xfs_dir2.h"
 #include "xfs_metafile.h"
-
+#include <linux/fsverity.h>
 #include <linux/iversion.h>
 
 /* Radix tree tags for incore inode tree. */
@@ -1260,6 +1260,15 @@ xfs_inode_free_eofblocks(
 	if (xfs_can_free_eofblocks(ip))
 		return xfs_free_eofblocks(ip);
 
+	/*
+	 * The above xfs_free_eofblocks() is skipped for inodes with fsverity
+	 * tree is being built. However, we don't want to clear EOF tag in this
+	 * case. If building the tree fails, inode will have EOF blocks which
+	 * needs removal.
+	 */
+	if (fsverity_is_building(VFS_IC(ip)))
+		return 0;
+
 	/* inode could be preallocated */
 	trace_xfs_inode_free_eofblocks_invalid(ip);
 	xfs_inode_clear_eofblocks_tag(ip);
-- 
2.54.0

