Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AB933F58D9;
	Fri, 10 Jul 2026 08:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783673650; cv=none; b=XwrkrBcyFtWWQggg9Y5RjLfiPDq1imBnmwMLGrAQvSoam7zCFwimbYSNrP4opaonedFmMeQtApPSddXwvOANArXf07Fx+wDBOrZrAkaSCxDRolsmXlTNeidmCquaAeFWEyWJSA6jin0n9DWZkT9e8rev/SpvM+WFJVPByIaASWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783673650; c=relaxed/simple;
	bh=So7cmx0/wmaP0ZRLCPb4BrOTlGU2rQYcdbLUQcCOJY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K9nNZIlzaYSqktBJwn+dA3B8XfbM2gLpkPBJLzl66miMBvmWCGbYQiENfmvolfdILE8V8DHWGgs6i8lPMyi5VnVtX3QNPlISgok1PJuozz0seACvIJDwXluJJyvmiZXVScQc6D7GJjMyUThd3R86kdDs2gkI7fn1VjV+5KXHyRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fNNPXJPi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fNNPXJPi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 960861F00A3A;
	Fri, 10 Jul 2026 08:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783673649;
	bh=ASLFdtCWbZc+ZiVS48Mmt9QrM1DUk49jYLtfcIB387s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fNNPXJPiwnPhojzMBMj002PHS6XewNIO0DOJjDN5oDUc9H3CHGNPRzyn+wTx66a6Q
	 KmVLcIKFtFHnoI+S7gc1lTLPZd5HGnX4oYIYatgFz7sgt6zt4g88sqH6zNCV6a0D6V
	 yu6XHQPsBMbQdxGlHhM1giRslYTgcJjFNg0v68KmxfKUAR4X5yYDO9jZc3duO0Wpka
	 BiXkPoGSgcAyCiiNIm1WFft4rSFnwaXLHjW0bKKeMr5ChNOHqFnLnF1/3dQkjguvCx
	 Npn/khc3ITMeBYKfS+8qNOHfpdr07rSQmfDQk65aaRXPHZFTHnAks209xreuZRAJOW
	 357MIPOVzZLIg==
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
Subject: [PATCH v11 15/20] xfs: remove unwritten extents after preallocations in fsverity metadata
Date: Fri, 10 Jul 2026 10:52:43 +0200
Message-ID: <20260710085256.3464201-16-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260710085256.3464201-1-aalbersh@kernel.org>
References: <20260710085256.3464201-1-aalbersh@kernel.org>
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

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/xfs_fsverity.c | 69 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 69 insertions(+)

diff --git a/fs/xfs/xfs_fsverity.c b/fs/xfs/xfs_fsverity.c
index 0d66aec43383..31faa95c396d 100644
--- a/fs/xfs/xfs_fsverity.c
+++ b/fs/xfs/xfs_fsverity.c
@@ -19,6 +19,8 @@
 #include "xfs_iomap.h"
 #include "xfs_error.h"
 #include "xfs_health.h"
+#include "xfs_bmap.h"
+#include "xfs_bmap_util.h"
 #include <linux/fsverity.h>
 #include <linux/iomap.h>
 #include <linux/pagemap.h>
@@ -178,6 +180,65 @@ xfs_fsverity_delete_metadata(
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
+			xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
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
+			xfs_iunlock(ip, XFS_ILOCK_EXCL);
+		}
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
@@ -261,6 +322,14 @@ xfs_fsverity_end_enable(
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
2.54.0

