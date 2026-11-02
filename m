Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793630550;
	b=QY7dunupICsD9BNBCiMz8062cVZac/Zs2dXWUrS+oxpbft2pTUY9vuGOvASnRdWDky2n
	 pPphaxetv+01UXCGk1BDTaaT0Wgw0GngtHrQcryVJGgulZL26LoMAaZJOSUdGF0lY5+IM
	 RXpzqV7asYg+Y5eP/96NcUEPTGda9fv4o/obGwnYrbFoVWXbnGaXnpc6e982/ZOWws7x9
	 eZVYBMaSBEXD3X3LRR7LDusoFxsJHoofzYhLpZUSC2qOVf47Zl9f05uASfSas7KK6Oz+E
	 SVJPETiuYrzqyBAQH6H3UFUiKDupqi0NXTpInpb8yK0op30Vn2HjyOb5e0AtpDs+Ylw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793630550;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=Ub5Mc7c3KTkaOQNxHiDTq3x3/nZWPIMH1nsb+P4eYc8=;
	b=WH5WJwg9qyguVi4i7rQne3H31goSySrP93479/TUL0r3maks3+ItOhD2QHfmKS3csVfR
	 6VuLw0SED6hsavau6rn+zC4xvyTnsco6oixknvAV/DzslR9UIsjTcjPaw+jHreokv4TJD
	 2Q4R0wtZXirHioPobEedBiyxYikdc/GRnQIU74oOpaYkvL7AXGuAL07RefwiRNzcc8JBj
	 67iROqc+4X01XrJ23QdgFq5mlUla30diCBfar+033lqd2CljzfIdxoxpcz5tnwbR+eD7A
	 WpGvnAesjS7Y+sl84zjld2y8Cl+Ou8xgq7+Q77qJ/ELw8MYDZde/ZzHcZZRMr991tDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="JAYZh/uP";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AC2A607E0E9;
	Mon,  2 Nov 2026 14:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JAYZh/uP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E47E11F00A17;
	Mon,  2 Nov 2026 14:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793630550;
	bh=Ub5Mc7c3KTkaOQNxHiDTq3x3/nZWPIMH1nsb+P4eYc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JAYZh/uPGdsSDJ2lUowKBnBRaqoMh7EPQhBtrY+M9ugz/cMLllFXDyO/QnAt3JTY1
	 8NrWP+40PyK/KDX1K3IpfAsdFNPp6QGaM5ssDhpNrRnEm8dCz0j9Bcqt2yapEo3gDS
	 VsbbFm/W8CYAMFzBY+GPLaKwV9GcX9Wa+Y9rRRqU/oe9eJPxAmJBcoe4GgPkL2ZXbx
	 CHILjnhRWbQD7cqJrQxbSn+RTG5cyG5cwF8UUeQrgZBMieAunxNeD8hVDA+IdfWsJ1
	 SFZDbzu4Kp2RAJb6iWYzbnEymq3B4z/Gd3/kyKAMCBy3HDzxAsN+1RBYq/ctqJYuN/
	 A/E10JyrIBE8w==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: ebiggers@kernel.org,
	hch@lst.de,
	Carlos Maiolino <cem@kernel.org>,
	fsverity@lists.linux.dev,
	linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	linux-fsdevel@vger.kernel.org,
	david@fromorbit.com,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH v18 08/15] xfs: don't remove written extents past EOF on fsverity inodes
Date: Mon,  2 Nov 2026 15:41:38 +0100
Message-ID: <20261102144147.2393369-9-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261102144147.2393369-1-aalbersh@kernel.org>
References: <20261102144147.2393369-1-aalbersh@kernel.org>
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
 fs/xfs/xfs_bmap_util.c | 31 ++++++++++++++++++++++++++++---
 1 file changed, 28 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 865aec3ae5ab..32cec523fd52 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -31,6 +31,7 @@
 #include "xfs_rtbitmap.h"
 #include "xfs_rtgroup.h"
 #include "xfs_zone_alloc.h"
+#include <linux/fsverity.h>
 
 /* Kernel only BMAP related definitions and functions */
 
@@ -553,6 +554,15 @@ xfs_can_free_eofblocks(
 	if (last_fsb <= end_fsb)
 		return false;
 
+	/*
+	 * Don't clean fsverity inodes as they already have been cleaned up and
+	 * are read-only. Skip inodes which have merkle tree being built, the
+	 * merkle tree is written beyond EOF
+	 */
+	if (fsverity_active(VFS_IC(ip)) ||
+	    xfs_iflags_test(ip, XFS_VERITY_CONSTRUCTION))
+		return false;
+
 	/*
 	 * Check if there is an post-EOF extent to free.  If there are any
 	 * delalloc blocks attached to the inode (data fork delalloc
@@ -579,6 +589,9 @@ xfs_free_eofblocks(
 	struct xfs_trans	*tp;
 	struct xfs_mount	*mp = ip->i_mount;
 	int			error;
+	int			bmapi_flags = XFS_BMAPI_NODISCARD;
+	bool			has_verity =
+			ip->i_diflags2 & XFS_DIFLAG2_VERITY;
 
 	/* Attach the dquots to the inode up front. */
 	error = xfs_qm_dqattach(ip);
@@ -593,15 +606,20 @@ xfs_free_eofblocks(
 	 *
 	 * Note that this means we also leave speculative preallocations in
 	 * place for preallocated files.
+	 *
+	 * Clean up delalloc reservations for fsverity too as those won't be
+	 * used
 	 */
-	if (ip->i_diflags & (XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND)) {
+	if (ip->i_diflags & (XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND) ||
+			has_verity) {
 		if (ip->i_delayed_blks) {
 			xfs_bmap_punch_delalloc_range(ip, XFS_DATA_FORK,
 				round_up(XFS_ISIZE(ip), mp->m_sb.sb_blocksize),
 				LLONG_MAX, NULL);
 		}
 		xfs_inode_clear_eofblocks_tag(ip);
-		return 0;
+		if (!has_verity)
+			return 0;
 	}
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, &tp);
@@ -613,6 +631,13 @@ xfs_free_eofblocks(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
 
+	/*
+	 * While fs-verity writes metadata after EOF, it can leave unwritten
+	 * preallocations.  Clear all that out.
+	 */
+	if (has_verity)
+		bmapi_flags |= XFS_BMAPI_UNWRITTEN;
+
 	/*
 	 * Do not update the on-disk file size.  If we update the on-disk file
 	 * size and then the system crashes before the contents of the file are
@@ -620,7 +645,7 @@ xfs_free_eofblocks(
 	 * bug).
 	 */
 	error = xfs_itruncate_extents_flags(&tp, ip, XFS_DATA_FORK,
-				XFS_ISIZE(ip), XFS_BMAPI_NODISCARD);
+				XFS_ISIZE(ip), bmapi_flags);
 	if (error)
 		goto err_cancel;
 
-- 
2.54.0

