Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D12183EDAA6;
	Mon,  9 Mar 2026 19:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773084310; cv=none; b=eYGfXV8k4SZQeqkHLGsR7cNmXAdno0iQV/ExfaPje23bra8BbMhObdid1/Y/S4Q5pz1rAuEdby86gvREV9Xb7pOokpx/3Mpo3qObV9t0v5phsR6A3QsNrtVmDtbcBOF2t1pjyWXITEgSHuGTIacwyoOieCpYVgmpTulVvYe36O8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773084310; c=relaxed/simple;
	bh=w3fjf18ZoDlPXKJ28b6MR0iStdNztPG0sro78fgsISM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EGAvfAoKIT+J823rzDBRcs4TqKwKvY4nVP+QPNa4CSLNfR10jMD0q/dS8PTjcDRkT6EbV0ufb1+DEKY+34gOvtF75fxejTfyIvHT0DncAd8acjlcn+F+WWEFO/DiB03b2Q8gGZlgG9vxSg2wNA5CXGIHUjSNNBehY3XfxK5IKtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EI3JFxZa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EI3JFxZa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75947C2BC87;
	Mon,  9 Mar 2026 19:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773084310;
	bh=w3fjf18ZoDlPXKJ28b6MR0iStdNztPG0sro78fgsISM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EI3JFxZaqCOYDI0BG5k5wGiM77hQlk5N5np3QrFpqNjIdM4dmRjoroAQf6Pdz+bh0
	 oHgxVeZwHXsE3Dq6GT6LKruSn3C/7vPSvbBPfUjylEz/EORP5FXmzsaXIm4ricH+sK
	 V2ioBZFBSj7JGEP+Y9s9uA9JkDqtRWtH+FSdDSF2/ZsMIX31KVi/v3aCuFWkdQ/K0H
	 TbTcRtkxCk10WsuhP2yG4pQ94GMGLGa3raeAAyed1mhWdpF1Ihb015bVPqvUaKhJOd
	 +YpcDDpW1VUeIKgvUQ4FLk56SbYp3Bb6GlabWSTaGDzzoo2OtDX9Rc2YRystY1K4tL
	 pgYhUPCf+AXhA==
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
	djwong@kernel.org
Subject: [PATCH v4 19/25] xfs: remove unwritten extents after preallocations in fsverity metadata
Date: Mon,  9 Mar 2026 20:23:34 +0100
Message-ID: <20260309192355.176980-20-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260309192355.176980-1-aalbersh@kernel.org>
References: <20260309192355.176980-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

XFS preallocates spaces during writes. In normal I/O this space, if
unused, is removed by truncate. For files with fsverity, XFS does not
use truncate as fsverity metadata is stored past EOF.

After we're done with writing fsverity metadata iterate over extents in
that region and remove any unwritten ones. These would be preallocation
leftovers in the merkle tree holes and past fsverity descriptor.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/xfs_fsverity.c | 62 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)

diff --git a/fs/xfs/xfs_fsverity.c b/fs/xfs/xfs_fsverity.c
index e5cd17ec15b6..f78e5f0c2fd0 100644
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
@@ -189,6 +191,58 @@ xfs_fsverity_delete_metadata(
 	return error;
 }
 
+static int
+xfs_fsverity_cancel_unwritten(
+	struct xfs_inode	*ip,
+	xfs_fileoff_t		start,
+	xfs_fileoff_t		end)
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
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, 0, 0, 0, &tp);
+	if (error)
+		return error;
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, 0);
+
+	while (offset_fsb < end_fsb) {
+		nimaps = 1;
+
+		error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb,
+							  &imap, &nimaps, 0);
+		if (error)
+			goto out_cancel;
+
+		if (nimaps == 0)
+			break;
+
+		if (imap.br_state == XFS_EXT_UNWRITTEN) {
+			error = xfs_bunmapi(tp, ip, imap.br_startoff,
+					    imap.br_blockcount, 0, 1, &done);
+			if (error)
+				goto out_cancel;
+		}
+
+		offset_fsb = imap.br_startoff + imap.br_blockcount;
+	}
+
+	error = xfs_trans_commit(tp);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	return error;
+out_cancel:
+	xfs_trans_cancel(tp);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	return error;
+}
+
 
 /*
  * Prepare to enable fsverity by clearing old metadata.
@@ -264,6 +318,14 @@ xfs_fsverity_end_enable(
 	if (error)
 		goto out;
 
+	/*
+	 * Remove unwritten extents left by preallocations in the merkle tree
+	 * holes and past descriptor
+	 */
+	error = xfs_fsverity_cancel_unwritten(ip, range_start, LLONG_MAX);
+	if (error)
+		goto out;
+
 	/*
 	 * Set fsverity inode flag
 	 */
-- 
2.51.2

