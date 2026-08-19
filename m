Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD7A52E54D1
	for <linux-xfs@vger.kernel.org>; Wed, 19 Aug 2026 00:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787098525; cv=none; b=fx3bJfhiuTCs63n8OOtPNmwC1Q4+wrAAM/k75C2oWYZmJ0zxWVFvJw+yi66N63lygrWAgPqSuVo3NvFw1+XrzKzjvoy196HHE8cUaz5UpXAYCLXsBaFt4oOvxANO0UpNm57R2eBJZlhdnxYQBch76M/TVsTpGtb+UGSQVc3kKDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787098525; c=relaxed/simple;
	bh=kaS1kl52R/gpOWaTKHMfa0ePRUYC/5c26Qk61z1fuLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KYw2eRP2uOg0nzTgs0x60I1Sv1dc/u5zFIiSZJ/5SXxDFM2MmpRqyYKpbfYRLkIGxM/7tTbPC0m6PCdrZgjIx2s7zaB4BBq4qoP2DfgjZ1BbYPED39NxSVPfnxCv/E3zOv0/rRc13UGUHNs/T215+o6zKGkZ5e5JharULFzjcUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ldYhY6jE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ldYhY6jE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30B3B1F000E9;
	Wed, 19 Aug 2026 00:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787098524;
	bh=hTvCPt/1Dx7zE2lgd/rhRTibh7sugcdZ61L3TpodT6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ldYhY6jE9VmA1H2yZJbATNxv8Z5f3TAlb+gO7nv+700lcMqtabRZs0PFSNfVILXjo
	 LL5Cvlp4RPVufgkMbPA8ZGkcIh+qooWdFR4vlIGon1Bn3R4BrIR6oEg5ojKybq+MmS
	 GK5vS2bP7Ojw/68ZUVSjAkJay7b3ylY/FwaNDeFxzfqmnM8FWDbkVuY3gUlqRt8GrT
	 eEJZN+b3+ul/ypox9pRf3nX3KQLhWjCT3N2WILbnkNX4t3g7R0Giq1skpWQ0NrEhMY
	 NEA+xMm0vSTDeJ6WKLqYwjUZHYNqeHqNRqzXM8uYv3CxTm41i4scukLaS9PClh6fSq
	 KNjbQMvG/4aYQ==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 28/38] xfs: remove xfs_reflink_end_cow_extent wrapper and rename locked variant
Date: Wed, 19 Aug 2026 10:12:31 +1000
Message-ID: <20260819001442.1451892-29-dgc@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260819001442.1451892-1-dgc@kernel.org>
References: <20260819001442.1451892-1-dgc@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that xfs_reflink_end_cow() calls xfs_reflink_end_cow_extent_locked()
directly with its rolling transaction, the xfs_reflink_end_cow_extent()
wrapper function is no longer needed. Remove it entirely and rename
xfs_reflink_end_cow_extent_locked() to xfs_reflink_end_cow_extent()
since there is no longer an unlocked variant.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_reflink.c | 40 ++--------------------------------------
 1 file changed, 2 insertions(+), 38 deletions(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 7e62f05499be..597300f39611 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -775,7 +775,7 @@ xfs_reflink_update_quota(
  * requirements as low as possible.
  */
 STATIC int
-xfs_reflink_end_cow_extent_locked(
+xfs_reflink_end_cow_extent(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*ip,
 	xfs_fileoff_t		*offset_fsb,
@@ -887,42 +887,6 @@ xfs_reflink_end_cow_extent_locked(
  * every remap operation and we'd like to keep the block reservation
  * requirements as low as possible.
  */
-STATIC int
-xfs_reflink_end_cow_extent(
-	struct xfs_trans	*tp,
-	struct xfs_inode	*ip,
-	xfs_fileoff_t		*offset_fsb,
-	xfs_fileoff_t		end_fsb)
-{
-	struct xfs_mount	*mp = ip->i_mount;
-	unsigned int		resblks;
-	bool			local_tp = false;
-	int			error;
-
-	if (tp)
-		goto end_cow;
-
-	resblks = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0,
-			XFS_TRANS_RESERVE, &tp);
-	if (error)
-		return error;
-	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, ip, 0);
-	local_tp = true;
-
-end_cow:
-	error = xfs_reflink_end_cow_extent_locked(tp, ip, offset_fsb, end_fsb);
-	if (!local_tp)
-		return error;
-	if (error)
-		xfs_trans_cancel(tp);
-	else
-		error = xfs_trans_commit(tp);
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-	return error;
-}
-
 /*
  * Remap parts of a file's data fork after a successful CoW.
  *
@@ -1023,7 +987,7 @@ xfs_reflink_end_atomic_cow(
 	xfs_trans_ijoin(tp, ip, 0);
 
 	while (end_fsb > offset_fsb && !error) {
-		error = xfs_reflink_end_cow_extent_locked(tp, ip, &offset_fsb,
+		error = xfs_reflink_end_cow_extent(tp, ip, &offset_fsb,
 				end_fsb);
 	}
 	if (error) {
-- 
2.55.0

