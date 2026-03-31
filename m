Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BE164657C6;
	Tue, 31 Mar 2026 21:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774992563; cv=none; b=Ji1i5LJiAta7RloRmDWLJUzAVuexSDR9gslqeFs1liE63Jtm07rBuTuM6EG3v5YYbHkm3L3V7j1NSlQGskXmQzjic5n5UrTv6fVryGljB/4pYYJABVQg/xMepEZAdSTnkKaaQG+s7AfGyFXY4eE8OwDRDJJGQwYXwFrabGYZ5o0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774992563; c=relaxed/simple;
	bh=iOgFntkagcHnJzdVdNQ9ZYUIxxE/XWG3vo8zPAmv77U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LeVpVOfV/WPmtUrcENl7aMbHNZPp3v1TwU3SpmQ/lbnUbdVhj3X7/pxSMR51kcpZppPB0xPulyWcmaKI11C2DNR6+pbDTrTiGWY9QIBaBbQFX+XJYE5Xika9InJcMKZhQZ+LVBPVhM2ReARDeMYUM5+tsWpkWrlydKF1Wwl9R7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZDpzJfJj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZDpzJfJj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A58F8C19423;
	Tue, 31 Mar 2026 21:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774992563;
	bh=iOgFntkagcHnJzdVdNQ9ZYUIxxE/XWG3vo8zPAmv77U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZDpzJfJj5OwM7uL6NistKiIgD+erSMLlCyY0qsotS7Q4rvj48xZ3c0JDt0+yL56N8
	 T0s9cF5A7Pfjg+hZXguUXhhu1UFSoUQZkqwjr/YnQNCTeavmQVOh7pt2bio01MM3qr
	 CisQck7Ss3qNKevQFR66K4NFhy+mvPkfB/OT+1PV+Jt293pgoS/b5TG7TYljhj6DS2
	 4vJwBBLJ8UYZEtfIW8OIWUEJqYkKSvdX7FQM1F3WCOWA/cB/gREilPIYIKK4Th46kX
	 grFPUkdopeYDnPgoSovC1o8LxyagBYIKq1vKn8hVZKjmz8SGZVxJnEB/SJ/IGt55gu
	 EjfQ3v2DoZAAQ==
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
Subject: [PATCH v6 16/22] xfs: remove unwritten extents after preallocations in fsverity metadata
Date: Tue, 31 Mar 2026 23:28:17 +0200
Message-ID: <20260331212827.2631020-17-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260331212827.2631020-1-aalbersh@kernel.org>
References: <20260331212827.2631020-1-aalbersh@kernel.org>
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
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/xfs_fsverity.c | 67 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 67 insertions(+)

diff --git a/fs/xfs/xfs_fsverity.c b/fs/xfs/xfs_fsverity.c
index 5a6a48fcf843..b193009a1bdb 100644
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
@@ -173,6 +175,63 @@ xfs_fsverity_delete_metadata(
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
@@ -248,6 +307,14 @@ xfs_fsverity_end_enable(
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

