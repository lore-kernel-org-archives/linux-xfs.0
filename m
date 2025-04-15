Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C22756FC5
	for <linux-xfs@vger.kernel.org>; Tue, 15 Apr 2025 00:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744677226; cv=none; b=VQu0gAngwOsjbGNRxYsArROVJdjKDNxSrGTWmVI69M3YYUdEogrBe5mZlheL6jjixVxhzokZqtuNU0rS1TkIFPjoYUkuMEQrM12tI38E1avBu2PZbYWw0CeM76BLT9ZdcgIa1luOc/Xfnz+jA3XJp2asuGv+PMdIQnmnuz1um6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744677226; c=relaxed/simple;
	bh=Y6UnVqjex4/jNGZnL5/rOWSsltDRHEEjyE7CKXcu99A=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=EYQAx7a2aOU8vEZjGgfo77nPe9+L9cgtHxpMR7xiadjccu669klVZWjZvvW30AeNL/vhw8tBB7HOpyfkogX/nO7SuBupEUNSHBb+wIZMnAsMSsytZG/3JU9URTieF24nH/YoWlT4EHnfuMXZsOVG7F6aI3ciTVTRwWbkpW4B1Bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F/DXsXdu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F/DXsXdu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35BE5C4CEE2;
	Tue, 15 Apr 2025 00:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744677226;
	bh=Y6UnVqjex4/jNGZnL5/rOWSsltDRHEEjyE7CKXcu99A=;
	h=Date:From:To:Cc:Subject:From;
	b=F/DXsXdu3dTBubRA7yFGFGu4dDM0J6C/ALPSsWlXugSMalr+MQ1Ju0CMKYGIVr227
	 ovaYsaraWEAiSBlwgbStv9oWoJQffXWDo6LZJtIeaH5frOJuPzusg/zmR7tv5hlsp/
	 erjdrK+NBom/APyxHPsuxnPQBdsBdtw8v1cqjxaKuvjDaIQre7AjTF9wsDI8DPoBie
	 iGugpqG7TK3hqKLxiEDa/esYMBVVcOQ+TbhxU/WLD4OsuXd6/Bz93J5CfT7BmFw3T/
	 yknZTpkoMTHVjC4WbuYHoS1t988qskICsuoOR1ILsdu7Y1UJXdUMs4EceNpOVzTGlK
	 K1yW9rSJ55Kag==
Date: Mon, 14 Apr 2025 17:33:45 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>, Christoph Hellwig <hch@infradead.org>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: fix fsmap for internal zoned devices
Message-ID: <20250415003345.GF25675@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

Filesystems with an internal zoned rt section use xfs_rtblock_t values
that are relative to the start of the data device.  When fsmap reports
on internal rt sections, it reports the space used by the data section
as "OWN_FS".

Unfortunately, the logic for resuming a query isn't quite right, so
xfs/273 fails because it stress-tests GETFSMAP with a single-record
buffer.  If we enter the "report fake space as OWN_FS" block with a
nonzero key[0].fmr_length, we should add that to key[0].fmr_physical
and recheck if we still need to emit the fake record.  We should /not/
just return 0 from the whole function because that prevents all rmap
record iteration.

If we don't enter that block, the resumption is still wrong.
keys[*].fmr_physical is a reflection of what we copied out to userspace
on a previous query, which means that it already accounts for rgstart.
It is not correct to add rtstart_daddr when computing start_rtb or
end_rtb, so stop that.

While we're at it, add a xfs_has_zoned to make it clear that this is a
zoned filesystem thing.

Fixes: e50ec7fac81aa2 ("xfs: enable fsmap reporting for internal RT devices")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_fsmap.c |   51 +++++++++++++++++++++++++++++++++------------------
 1 file changed, 33 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index a4bc1642fe5615..414b27a8645886 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -876,6 +876,7 @@ xfs_getfsmap_rtdev_rmapbt(
 	const struct xfs_fsmap		*keys,
 	struct xfs_getfsmap_info	*info)
 {
+	struct xfs_fsmap		key0 = *keys; /* struct copy */
 	struct xfs_mount		*mp = tp->t_mountp;
 	struct xfs_rtgroup		*rtg = NULL;
 	struct xfs_btree_cur		*bt_cur = NULL;
@@ -887,32 +888,46 @@ xfs_getfsmap_rtdev_rmapbt(
 	int				error = 0;
 
 	eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_rtstart + mp->m_sb.sb_rblocks);
-	if (keys[0].fmr_physical >= eofs)
+	if (key0.fmr_physical >= eofs)
 		return 0;
 
+	/*
+	 * On zoned filesystems with an internal rt volume, the volume comes
+	 * immediately after the end of the data volume.  However, the
+	 * xfs_rtblock_t address space is relative to the start of the data
+	 * device, which means that the first @rtstart fsblocks do not actually
+	 * point anywhere.  If a fsmap query comes in with the low key starting
+	 * below @rtstart, report it as "owned by filesystem".
+	 */
 	rtstart_daddr = XFS_FSB_TO_BB(mp, mp->m_sb.sb_rtstart);
-	if (keys[0].fmr_physical < rtstart_daddr) {
+	if (xfs_has_zoned(mp) && key0.fmr_physical < rtstart_daddr) {
 		struct xfs_fsmap_irec		frec = {
 			.owner			= XFS_RMAP_OWN_FS,
 			.len_daddr		= rtstart_daddr,
 		};
 
-		/* Adjust the low key if we are continuing from where we left off. */
-		if (keys[0].fmr_length > 0) {
-			info->low_daddr = keys[0].fmr_physical + keys[0].fmr_length;
-			return 0;
+		/*
+		 * Adjust the start of the query range if we're picking up from
+		 * a previous round, and only emit the record if we haven't
+		 * already gone past.
+		 */
+		key0.fmr_physical += key0.fmr_length;
+		if (key0.fmr_physical < rtstart_daddr) {
+			error = xfs_getfsmap_helper(tp, info, &frec);
+			if (error)
+				return error;
+
+			key0.fmr_physical = rtstart_daddr;
 		}
 
-		/* Fabricate an rmap entry for space occupied by the data dev */
-		error = xfs_getfsmap_helper(tp, info, &frec);
-		if (error)
-			return error;
+		/* Zero the other fields to avoid further adjustments. */
+		key0.fmr_owner = 0;
+		key0.fmr_offset = 0;
+		key0.fmr_length = 0;
 	}
 
-	start_rtb = xfs_daddr_to_rtb(mp, rtstart_daddr + keys[0].fmr_physical);
-	end_rtb = xfs_daddr_to_rtb(mp, rtstart_daddr +
-			min(eofs - 1, keys[1].fmr_physical));
-
+	start_rtb = xfs_daddr_to_rtb(mp, key0.fmr_physical);
+	end_rtb = xfs_daddr_to_rtb(mp, min(eofs - 1, keys[1].fmr_physical));
 	info->missing_owner = XFS_FMR_OWN_FREE;
 
 	/*
@@ -920,12 +935,12 @@ xfs_getfsmap_rtdev_rmapbt(
 	 * low to the fsmap low key and max out the high key to the end
 	 * of the rtgroup.
 	 */
-	info->low.rm_offset = XFS_BB_TO_FSBT(mp, keys[0].fmr_offset);
-	error = xfs_fsmap_owner_to_rmap(&info->low, &keys[0]);
+	info->low.rm_offset = XFS_BB_TO_FSBT(mp, key0.fmr_offset);
+	error = xfs_fsmap_owner_to_rmap(&info->low, &key0);
 	if (error)
 		return error;
-	info->low.rm_blockcount = XFS_BB_TO_FSBT(mp, keys[0].fmr_length);
-	xfs_getfsmap_set_irec_flags(&info->low, &keys[0]);
+	info->low.rm_blockcount = XFS_BB_TO_FSBT(mp, key0.fmr_length);
+	xfs_getfsmap_set_irec_flags(&info->low, &key0);
 
 	/* Adjust the low key if we are continuing from where we left off. */
 	if (info->low.rm_blockcount == 0) {
