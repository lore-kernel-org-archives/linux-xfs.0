Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1BE23D5673;
	Tue, 28 Apr 2026 08:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777365286; cv=none; b=XeBTBuejOQ0hVPnLrFsKaoMOA6wamowsXzaFDJaGk8ds4RFdiy1u1H9s4sJmDPEPvZT8B+opKmYktXvvW7Gpq3vVblwqK3HB4rPtCZTOHveyS96E9YEECY4bzKikRFbuXTgFoO/ZMmTr00YpYRXps3wbuvh6arqDtN688cZru48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777365286; c=relaxed/simple;
	bh=nvo+/jQmBzOVT1hZLKQjDFN1ozBMwJTC50yAygolAgM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kymk/pETabNyHBX82hWwK33VWHteOVrnG7+Rylv9r1Wj9YPpTo931ogpYKBbKCxbTw4GfY3XImE2NCcLDYNd0vcXWJZFY4cJ2j+aZmMoQH3+oqn0Cd2gZaQPNxSw2Te8iAd1JRR3i38JdYhIBQz812BHvIMjFGqoBnsfedbSh20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=urZDGhzM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="urZDGhzM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CC35C2BCB5;
	Tue, 28 Apr 2026 08:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777365285;
	bh=nvo+/jQmBzOVT1hZLKQjDFN1ozBMwJTC50yAygolAgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=urZDGhzMGfrG/uwUDUfeM6fs/a/QVNk3dYPXSRTIym6aApsOZVDAhiCclP0WYtZb6
	 yL6ZuPAnVELexTtm7a32Nj7Dnih6griNw/PIbW7i+iX+GN+pLXkdfC1MSHLh3/ye3U
	 YYNydvLMD0JhlbO8kevfxUIKLzte0tjvjWVj4//9TlTfCHr1XYcwIUZ7LAr8C5l6uz
	 fcCkrU9iU8zcRAnqgSOg3JpweObLv77SO4bGAoqdZ5ncpkGK69sj42anPCKDL/xzij
	 njeMW68d5pbCOjIqhwyxYrHlDuY6pIfLu7pTMJdQOaGrcuNp3wtGKfnR934+41kHGn
	 wybtS+p9xMp/w==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org,
	fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	ebiggers@kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	hch@lst.de,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	djwong@kernel.org
Subject: [PATCH v9 17/22] xfs: remove unwritten extents after preallocations in fsverity metadata
Date: Tue, 28 Apr 2026 10:33:23 +0200
Message-ID: <20260428083332.768693-18-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260428083332.768693-1-aalbersh@kernel.org>
References: <20260428083332.768693-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

XFS preallocates spaces during writes. In normal I/O this space, if
unused, is removed by truncate. For files with fsverity XFS does not use
truncate as fsverity metadata is stored past EOF.

After we're done with writing fsverity metadata iterate over extents in
that region and remove any unwritten ones. These would be left overs in
the holes in the merkle tree and past fsverity descriptor.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/xfs_fsverity.c | 69 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 69 insertions(+)

diff --git a/fs/xfs/xfs_fsverity.c b/fs/xfs/xfs_fsverity.c
index a06885291412..298d712b5ba2 100644
--- a/fs/xfs/xfs_fsverity.c
+++ b/fs/xfs/xfs_fsverity.c
@@ -21,6 +21,8 @@
 #include "xfs_iomap.h"
 #include "xfs_error.h"
 #include "xfs_health.h"
+#include "xfs_bmap.h"
+#include "xfs_bmap_util.h"
 #include <linux/fsverity.h>
 #include <linux/iomap.h>
 #include <linux/pagemap.h>
@@ -171,6 +173,65 @@ xfs_fsverity_delete_metadata(
 	return error;
 }
 
+static int
+xfs_fsverity_cancel_unwritten(
+	struct xfs_inode	*ip,
+	loff_t			start,
+	loff_t			end)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_trans	*tp;
+	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSB(mp, start);
+	xfs_fileoff_t		end_fsb = XFS_B_TO_FSB(mp, end);
+	struct xfs_bmbt_irec	imap;
+	int			nimaps;
+	int			error = 0;
+	int			done;
+
+
+	while (offset_fsb < end_fsb) {
+		nimaps = 1;
+
+		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, 0, 0,
+				0, &tp);
+		if (error)
+			return error;
+
+		xfs_ilock(ip, XFS_ILOCK_EXCL);
+		error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb,
+				&imap, &nimaps, 0);
+		if (error)
+			goto out_cancel;
+
+		if (nimaps == 0)
+			goto out_cancel;
+
+		if (imap.br_state == XFS_EXT_UNWRITTEN) {
+			xfs_trans_ijoin(tp, ip, 0);
+
+			error = xfs_bunmapi(tp, ip, imap.br_startoff,
+					imap.br_blockcount, 0, 1, &done);
+			if (error)
+				goto out_cancel;
+
+			error = xfs_trans_commit(tp);
+			if (error)
+				return error;
+		} else {
+			xfs_trans_cancel(tp);
+		}
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+
+		offset_fsb = imap.br_startoff + imap.br_blockcount;
+	}
+
+	return error;
+out_cancel:
+	xfs_trans_cancel(tp);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	return error;
+}
+
 
 /*
  * Prepare to enable fsverity by clearing old metadata.
@@ -248,6 +309,14 @@ xfs_fsverity_end_enable(
 	if (error)
 		goto out;
 
+	/*
+	 * Remove unwritten extents left by COW preallocations and write
+	 * preallocation in the merkle tree holes and past descriptor
+	 */
+	error = xfs_fsverity_cancel_unwritten(ip, range_start, LLONG_MAX);
+	if (error)
+		goto out;
+
 	/*
 	 * Proactively drop any delayed allocations in COW fork, the fsverity
 	 * files are read-only
-- 
2.51.2

