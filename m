Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DF1C3C4555;
	Fri,  2 Oct 2026 22:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790980683; cv=none; b=EcanMRiaAL6oTJB54CqkmYpwumQZARNBArSUk1rR0CGf5+NEPIIa5ftGcQ5Tzr7I5Cpeh/vBfiXy5wJOIbFSGgtlzJH/ceFRu+sWD+IT6/yUUXeKLJ3sNoZlTlNvNlFJqZNlsRaoRAiXpL6jFdIbh8m/IEKlD/VQl+4/gv9i4hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790980683; c=relaxed/simple;
	bh=6P2RDTfPU9YsVywTeFthZLxox/53khjwNChUqddXfoc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dRtg6Vet35ccCmURvBvD/DEne5oYj3oy3UR+JtZTzpBOFlr15KPLbG6nV7HQe2ZeFq33kTS2OTLXfNDjlipLlsSm4QNX/6OOdMHzwoeG3H0uWoBbNxDplhlS1Ax4rCNcTgBK5XN5FmvViyhC30xSPbO2U4NHQdMA3I7Sx0TCqPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nrpfpa71; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nrpfpa71"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 094F71F000FF;
	Fri,  2 Oct 2026 22:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790980682;
	bh=xCYk0Gq6TJerMCtpjc/Alie0O8U64/7WPSND7e9qc2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nrpfpa71CSPmqBRx81HpMBjNKeXWnwvFTlU0cnTd0ZMl89Ysvgnw8hio9TsVPYUGC
	 NnK2JUH8qruaOmXIFYHZ8afRmuLLG1wxC2PA+2iK+kc6Mx6+swNA966eDwu2xxfOVw
	 VNK1ed/+qOdxLGHrC2MEGwOpglCMZQ5TL9jnPEFTGg3peZcB+zDSybxWE6YB6fC4oM
	 gNhMBmz464TJKEjCZqjXgDg8RH+W53UX8Z8yH48BZoQrajXDS8osA3/tU2p2FJsxga
	 +rCjavTFEULegNei+FmxslOeVwiRuvIngIoIjYxndJ3L0B1U+1CMRX1sKTe9c8tk4X
	 cMVymZseBBr4A==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: djwong@kernel.org,
	ebiggers@kernel.org,
	hch@lst.de,
	Carlos Maiolino <cem@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org,
	david@fromorbit.com
Subject: [PATCH v17 14/21] xfs: don't remove written extents past EOF on fsverity inodes
Date: Sat,  3 Oct 2026 00:36:55 +0200
Message-ID: <20261002223705.2175542-15-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261002223705.2175542-1-aalbersh@kernel.org>
References: <20261002223705.2175542-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
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
index 268d159339d0..74e99d0bee7a 100644
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

