Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6485846D2CB;
	Tue, 21 Jul 2026 18:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659486; cv=none; b=twSby5NKkotFMOLOD+0rPQfi8IzNIV1aYLy2VNxYi0CRdvqhxMnVVm1oiF3RQHVZ9QgMhbfWHXtgl6+DnCruYe+74tBxSsogpk9gfrtSFtd8ZRyZytihNmGJB/Tx7EQRFx98RWvdYLa/e5+6ejvZ9KHrt09K8HzuXM0xrRM4kV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659486; c=relaxed/simple;
	bh=XpQQVpyKgj9iqggSXf8bwPlc4ttPYGJaxsMHzpMU5n0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qmPcIu5+tqsR5a2wOzXKxs4tOXeZyvT4ZBjzo8ZikAlyVogyNPtmv5seUdFI8LMmdahvrOrAHAJFevGQ2mbH/c5LOJKSzAwo/WXQOeo9y3ofZmV0eYUpPF8ViDNQepjiDRQ5LTx7irpfY5o8VQTh0c0BvqZ6pOocvI6R3eM9luM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m8vZ3bLb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m8vZ3bLb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC1301F00A3A;
	Tue, 21 Jul 2026 18:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784659485;
	bh=IwUo6t+cqdumeWexc/kPGLChnWY3Nr/38ljrnlrlNdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m8vZ3bLb4tuscuGSKKsgbCo32u617Sc+X8UyxZU5RFDnZ8h0X7nmoktV4cQwoQS++
	 2IaqEUtspkkZsy6eGrXSK0+xHUrE/RW75CUCkC5G5iERpML/VLn7yE5qF37vsVzbXs
	 vbem5myY4m3vV4XDz9V21l1CLspvUwxGOHQfAwFnPsqt8xNgYcdJPhl6yRNiIwCBVn
	 Ub0DFFpQzVotOGDOlRtqX3lmP9WAruS90SQTLhBzxlwGR73XSOiAQ0IsiPDZ0vS8CF
	 H2ooBe2H1/FNthtYKzMRZU98zg9XG8GR54DLo1VpEl7rEWXQDj6l0OFHRvx9OIGAJH
	 jyc5NnFHvdmMA==
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
Subject: [PATCH v13 17/23] xfs: remove unwritten extents after preallocations in fsverity metadata
Date: Tue, 21 Jul 2026 20:40:54 +0200
Message-ID: <20260721184346.416657-18-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260721184346.416657-1-aalbersh@kernel.org>
References: <20260721184346.416657-1-aalbersh@kernel.org>
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
 fs/xfs/xfs_fsverity.c | 79 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 79 insertions(+)

diff --git a/fs/xfs/xfs_fsverity.c b/fs/xfs/xfs_fsverity.c
index d3d4ba3edfc1..5dcbdf20e474 100644
--- a/fs/xfs/xfs_fsverity.c
+++ b/fs/xfs/xfs_fsverity.c
@@ -12,12 +12,15 @@
 #include "xfs_inode.h"
 #include "xfs_log_format.h"
 #include "xfs_trans.h"
+#include "xfs_defer.h"
 #include "xfs_trace.h"
 #include "xfs_quota.h"
 #include "xfs_fsverity.h"
 #include "xfs_iomap.h"
 #include "xfs_error.h"
 #include "xfs_health.h"
+#include "xfs_bmap.h"
+#include "xfs_bmap_util.h"
 #include <linux/fsverity.h>
 #include <linux/iomap.h>
 #include <linux/pagemap.h>
@@ -174,6 +177,74 @@ xfs_fsverity_delete_metadata(
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
+	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, start);
+	xfs_fileoff_t		end_fsb = XFS_B_TO_FSB(mp, end);
+	struct xfs_bmbt_irec	imap;
+	int			nimaps;
+	int			error = 0;
+	int			done;
+
+	while (offset_fsb < end_fsb) {
+		nimaps = 1;
+
+		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, 0, 0, 0, &tp);
+		if (error)
+			return error;
+
+		xfs_ilock(ip, XFS_ILOCK_EXCL);
+		error = xfs_bmapi_read(ip, offset_fsb,
+				end_fsb - offset_fsb, &imap, &nimaps,
+				0);
+		if (error)
+			goto out_cancel;
+
+		if (nimaps == 0)
+			goto out_cancel;
+
+		if (imap.br_state == XFS_EXT_UNWRITTEN) {
+			done = 0;
+
+			xfs_trans_ijoin(tp, ip, 0);
+
+			while (!done) {
+				error = xfs_bunmapi(tp, ip, imap.br_startoff,
+						imap.br_blockcount, 0, 1,
+						&done);
+				if (error)
+					goto out_cancel;
+
+				error = xfs_defer_finish(&tp);
+				if (error)
+					goto out_cancel;
+			}
+
+			error = xfs_trans_commit(tp);
+			if (error)
+				goto out_unlock;
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
+out_unlock:
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	return error;
+}
+
 
 /*
  * Prepare to enable fsverity by clearing old metadata.
@@ -257,6 +328,14 @@ xfs_fsverity_end_enable(
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

