Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D731B44C50C
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 10:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785319622; cv=none; b=ozNxo2Q6KGQ25MvkXkyc83mmqRaaDWWHkdrrQF8Yk9nYTHr7uN2hrryomZoFDiji55bxVGmwlWyCbhLRgp9QdRbkkuYnUiigFH0bU/M9f9bsya/XtYRZ8pcfHq//5ohBVFtKb2UKDbhma1XczdevxUpHej6+Y4r808IvB5mtwfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785319622; c=relaxed/simple;
	bh=b4ZAsTsqqHcCazTjQewTvfJ33FQ12skmaPknD1qca/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L63fDR0wv4vfZJrHohPOGwYPcpHwsdjMzIJFdxcB6ZG4O0IIl/3/4RR0jqio3N6p/Hcg6jlLjoVbDaQTixaUk4FKu4GjVa31pKQ8zDAVhgynHrLanUhDfPwjf3+1qOv1iUCTWFvw+gWif/erGEgFWW1KFOl7csHelPtJewGbhlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FsGZ5Kd4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FsGZ5Kd4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18BF31F00A3A;
	Wed, 29 Jul 2026 10:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785319620;
	bh=Al3lruJ3Bdq78/+Jpa4ZsYpLnaTOuQOkKX70GIe6GE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FsGZ5Kd49Swwk2XwTy4UFokmyETncDZlDW02aU39Q/AEIvmaEWZa5LjBN6rUzhhUL
	 eeqtGXRqXa9l2M6gdS9KgABOs30QgAbakgZifpFhgQf8dPgGobSPNlf9GBpcOeIRMK
	 96U86W68N3ZqtHRnevmD1MOQx1LrJ5B1kkhiDoDIL7WTHGqvp5Gky98SptyzbKalbG
	 AYVk1yK4QwCVUzammqkMbrRczB7vd/lDtCHkJcY0SimqqNZA5d/Y+d1XciukBCpy9f
	 TCwyuP65YSrXeaa1SB29VHZ95ez84sZ+qtgiWYacgcMwx8IWtO1E6+SjCJquTkcS9Q
	 dPEyIvrstvu5Q==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 22/33] xfs: convert xfs_reflink_end_cow to rolling transactions
Date: Wed, 29 Jul 2026 20:02:06 +1000
Message-ID: <20260729100629.1943710-23-dgc@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260729100629.1943710-1-dgc@kernel.org>
References: <20260729100629.1943710-1-dgc@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert xfs_reflink_end_cow() from per-extent transaction allocation
to a single rolling transaction that keeps the ILOCK held across the
entire COW remapping loop.

The rolling transaction keeps the ILOCK held throughout, making the
COW remapping operation atomic with respect to other ILOCK-protected
extent manipulations such as truncate, reflink remapping, and other
concurrent end_cow operations on overlapping regions.

XFS_TRANS_RENEW_BLKRES is set so that the btree split block
reservation is automatically renewed by xfs_defer_finish() after
each iteration's deferred operations are processed.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_reflink.c | 75 ++++++++++++++++++++++----------------------
 1 file changed, 38 insertions(+), 37 deletions(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index b175a549ee55..7e62f05499be 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -925,6 +925,13 @@ xfs_reflink_end_cow_extent(
 
 /*
  * Remap parts of a file's data fork after a successful CoW.
+ *
+ * The rolling transaction keeps the ILOCK held across the entire remapping
+ * loop, making the operation atomic with respect to other ILOCK-protected
+ * extent manipulations such as truncate, reflink remapping, and other
+ * concurrent end_cow operations on overlapping regions.
+ * XFS_TRANS_RENEW_BLKRES ensures the btree split block reservation is
+ * renewed after each xfs_defer_finish() call.
  */
 int
 xfs_reflink_end_cow(
@@ -932,54 +939,48 @@ xfs_reflink_end_cow(
 	xfs_off_t			offset,
 	xfs_off_t			count)
 {
+	struct xfs_mount		*mp = ip->i_mount;
 	xfs_fileoff_t			offset_fsb;
 	xfs_fileoff_t			end_fsb;
-	int				error = 0;
+	struct xfs_trans		*tp;
+	unsigned int			resblks;
+	int				error;
 
 	trace_xfs_reflink_end_cow(ip, offset, count);
 
-	offset_fsb = XFS_B_TO_FSBT(ip->i_mount, offset);
-	end_fsb = XFS_B_TO_FSB(ip->i_mount, offset + count);
+	offset_fsb = XFS_B_TO_FSBT(mp, offset);
+	end_fsb = XFS_B_TO_FSB(mp, offset + count);
 
-	/*
-	 * Walk forwards until we've remapped the I/O range.  The loop function
-	 * repeatedly cycles the ILOCK to allocate one transaction per remapped
-	 * extent.
-	 *
-	 * If we're being called by writeback then the folios will still
-	 * have the writeback flag set, which prevents races with reflink
-	 * remapping and truncate.  Reflink remapping prevents races with
-	 * writeback by taking the iolock and mmaplock before flushing
-	 * the folios and remapping, which means there won't be any further
-	 * writeback or page cache dirtying until the reflink completes.
-	 *
-	 * We should never have two threads issuing writeback for the same file
-	 * region.  There are also have post-eof checks in the writeback
-	 * preparation code so that we don't bother writing out folios that are
-	 * about to be truncated.
-	 *
-	 * If we're being called as part of directio write completion, the dio
-	 * count is still elevated, which reflink and truncate will wait for.
-	 * Reflink remapping takes the iolock and mmaplock and waits for
-	 * pending dio to finish, which should prevent any directio until the
-	 * remap completes.  Multiple concurrent directio writes to the same
-	 * region are handled by end_cow processing only occurring for the
-	 * threads which succeed; the outcome of multiple overlapping direct
-	 * writes is not well defined anyway.
-	 *
-	 * It's possible that a buffered write and a direct write could collide
-	 * here (the buffered write stumbles in after the dio flushes and
-	 * invalidates the page cache and immediately queues writeback), but we
-	 * have never supported this 100%.  If either disk write succeeds the
-	 * blocks will be remapped.
-	 */
-	while (end_fsb > offset_fsb && !error)
-		error = xfs_reflink_end_cow_extent(NULL, ip, &offset_fsb,
+	resblks = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0,
+			XFS_TRANS_RESERVE | XFS_TRANS_RENEW_BLKRES, &tp);
+	if (error)
+		return error;
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, 0);
+
+	while (end_fsb > offset_fsb) {
+		error = xfs_reflink_end_cow_extent(tp, ip, &offset_fsb,
 				end_fsb);
+		if (error)
+			goto out_cancel;
+
+		error = xfs_defer_finish(&tp);
+		if (error)
+			goto out_cancel;
+	}
 
+	error = xfs_trans_commit(tp);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	if (error)
 		trace_xfs_reflink_end_cow_error(ip, error, _RET_IP_);
 	return error;
+
+out_cancel:
+	xfs_trans_cancel(tp);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	trace_xfs_reflink_end_cow_error(ip, error, _RET_IP_);
+	return error;
 }
 
 /*
-- 
2.55.0

