Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B210A23C380
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738881793; cv=none; b=KqypnyB2Gsms/eOaGu0OqiOB28RZ30SwgXOK+8F0TSyn2MrGk9bZvAg0XSM3c+HL6nLzUeD52MeVzu06/CAnVvt2WUyMcFK+colw9z7bWm5lcLcITLyhAI31Q89pahS9q6qtD0CNDydqKULnVAdnN6MqAUyf9aEYPMzlp4Sh3Ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738881793; c=relaxed/simple;
	bh=QO8ZXQHefm+ajINq/RGR72sTGEZLQrAAQVDHAsj9/8M=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qDXXrGIrNXeyCHSs+vrp+20FNg2v1XkvDmEs1YNLOj5nd02HN3DTcqKqZTa2BoZJbCGkjTtx8tkeTCodMSoof97P/I36ep8K0X+M10o26Vc7ihqDOxReF3fAqDpaSwOUiK0Hihc2dj0CBK6hr0j/PE5SnIjI/EUTLdYJ99Th5Bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B1Q+IPRL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B1Q+IPRL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A1FBC4CEDD;
	Thu,  6 Feb 2025 22:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738881793;
	bh=QO8ZXQHefm+ajINq/RGR72sTGEZLQrAAQVDHAsj9/8M=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=B1Q+IPRLYrDCPbNV/WKCvw3bU9eu1rmEcILm6FH9QJwDUz9mWN3T+b7pFNOupYHVP
	 occsICJum2nf6ozYXb5l6F1MQNeSvtWlSpTHObUVhWeOaFytXpG9sb2Ro0OXXaFoVW
	 S+7SffeEo58a0m81DwUMrg4kJXADVmU4pB135CqB+mSla9db3W00RcDBAB1RIe0M1j
	 D8yipijsJx3J6nWD8kok8XKnjFawP8qvfVpOgWClQiUDWqisK0w9J03SV7O+KYrCMu
	 F+nP2YK+A+Nxrxd33ZicdqCRtmMIiZoqLt6SROUEl60vCKWy1RvbZ6T+wMcPmNosM8
	 rhR4pQjr77AsQ==
Date: Thu, 06 Feb 2025 14:43:13 -0800
Subject: [PATCH 31/56] xfs: namespace the maximum length/refcount symbols
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888087267.2739176.15501403334868259261.stgit@frogsfrogsfrogs>
In-Reply-To: <173888086703.2739176.18069262351115926535.stgit@frogsfrogsfrogs>
References: <173888086703.2739176.18069262351115926535.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 70fcf6866578e69635399e806273376f5e0b8e2b

Actually namespace these variables properly, so that readers can tell
that this is an XFS symbol, and that it's for the refcount
functionality.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_format.h   |    4 ++--
 libxfs/xfs_refcount.c |   18 +++++++++---------
 repair/rmap.c         |    2 +-
 repair/scan.c         |    2 +-
 4 files changed, 13 insertions(+), 13 deletions(-)


diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index fba4e59aded4a0..16696bc3ff9445 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -1790,8 +1790,8 @@ struct xfs_refcount_key {
 	__be32		rc_startblock;	/* starting block number */
 };
 
-#define MAXREFCOUNT	((xfs_nlink_t)~0U)
-#define MAXREFCEXTLEN	((xfs_extlen_t)~0U)
+#define XFS_REFC_REFCOUNT_MAX	((xfs_nlink_t)~0U)
+#define XFS_REFC_LEN_MAX	((xfs_extlen_t)~0U)
 
 /* btree pointer type */
 typedef __be32 xfs_refcount_ptr_t;
diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index fb7c56a5a32921..1aeea0b161849d 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -127,7 +127,7 @@ xfs_refcount_check_irec(
 	struct xfs_perag		*pag,
 	const struct xfs_refcount_irec	*irec)
 {
-	if (irec->rc_blockcount == 0 || irec->rc_blockcount > MAXREFCEXTLEN)
+	if (irec->rc_blockcount == 0 || irec->rc_blockcount > XFS_REFC_LEN_MAX)
 		return __this_address;
 
 	if (!xfs_refcount_check_domain(irec))
@@ -137,7 +137,7 @@ xfs_refcount_check_irec(
 	if (!xfs_verify_agbext(pag, irec->rc_startblock, irec->rc_blockcount))
 		return __this_address;
 
-	if (irec->rc_refcount == 0 || irec->rc_refcount > MAXREFCOUNT)
+	if (irec->rc_refcount == 0 || irec->rc_refcount > XFS_REFC_REFCOUNT_MAX)
 		return __this_address;
 
 	return NULL;
@@ -852,9 +852,9 @@ xfs_refc_merge_refcount(
 	const struct xfs_refcount_irec	*irec,
 	enum xfs_refc_adjust_op		adjust)
 {
-	/* Once a record hits MAXREFCOUNT, it is pinned there forever */
-	if (irec->rc_refcount == MAXREFCOUNT)
-		return MAXREFCOUNT;
+	/* Once a record hits XFS_REFC_REFCOUNT_MAX, it is pinned forever */
+	if (irec->rc_refcount == XFS_REFC_REFCOUNT_MAX)
+		return XFS_REFC_REFCOUNT_MAX;
 	return irec->rc_refcount + adjust;
 }
 
@@ -897,7 +897,7 @@ xfs_refc_want_merge_center(
 	 * hence we need to catch u32 addition overflows here.
 	 */
 	ulen += cleft->rc_blockcount + right->rc_blockcount;
-	if (ulen >= MAXREFCEXTLEN)
+	if (ulen >= XFS_REFC_LEN_MAX)
 		return false;
 
 	*ulenp = ulen;
@@ -932,7 +932,7 @@ xfs_refc_want_merge_left(
 	 * hence we need to catch u32 addition overflows here.
 	 */
 	ulen += cleft->rc_blockcount;
-	if (ulen >= MAXREFCEXTLEN)
+	if (ulen >= XFS_REFC_LEN_MAX)
 		return false;
 
 	return true;
@@ -966,7 +966,7 @@ xfs_refc_want_merge_right(
 	 * hence we need to catch u32 addition overflows here.
 	 */
 	ulen += cright->rc_blockcount;
-	if (ulen >= MAXREFCEXTLEN)
+	if (ulen >= XFS_REFC_LEN_MAX)
 		return false;
 
 	return true;
@@ -1195,7 +1195,7 @@ xfs_refcount_adjust_extents(
 		 * Adjust the reference count and either update the tree
 		 * (incr) or free the blocks (decr).
 		 */
-		if (ext.rc_refcount == MAXREFCOUNT)
+		if (ext.rc_refcount == XFS_REFC_REFCOUNT_MAX)
 			goto skip;
 		ext.rc_refcount += adj;
 		trace_xfs_refcount_modify_extent(cur, &ext);
diff --git a/repair/rmap.c b/repair/rmap.c
index 1c6a8691b8cb2c..bd91c721e20e4e 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -793,7 +793,7 @@ refcount_emit(
 		agno, agbno, len, nr_rmaps);
 	rlrec.rc_startblock = agbno;
 	rlrec.rc_blockcount = len;
-	nr_rmaps = min(nr_rmaps, MAXREFCOUNT);
+	nr_rmaps = min(nr_rmaps, XFS_REFC_REFCOUNT_MAX);
 	rlrec.rc_refcount = nr_rmaps;
 	rlrec.rc_domain = XFS_REFC_DOMAIN_SHARED;
 
diff --git a/repair/scan.c b/repair/scan.c
index 221d660e81fdb4..88fbda6b83f61a 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -1503,7 +1503,7 @@ _("extent (%u/%u) len %u claimed, state is %d\n"),
 						break;
 					}
 				}
-			} else if (nr < 2 || nr > MAXREFCOUNT) {
+			} else if (nr < 2 || nr > XFS_REFC_REFCOUNT_MAX) {
 				do_warn(
 	_("invalid reference count %u in record %u of %s btree block %u/%u\n"),
 					nr, i, name, agno, bno);

