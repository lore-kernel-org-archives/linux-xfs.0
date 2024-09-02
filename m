Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDAC819CC31
	for <linux-xfs@vger.kernel.org>; Mon,  2 Sep 2024 18:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725301857; cv=none; b=USi+oLyt2ktWegtsNhia3HeXoZySUKymjswcBh40o67eTO5wk+e9hDXv36JY9wohK3Pgl55PQ+ShVyIecy3iqRJBh0hy84dHffWDFjHlQkSoHaetBvL3IfbhKxVMWCIehRIht7+UqSwOyfauAuHdmiDjErAtYDFMpCmR4Y020uE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725301857; c=relaxed/simple;
	bh=oCmmToF60RFu8+JN137VcifPP51o1/FMqzC76K6uJbI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n6jN1XI/btGKEcT+BdJwuY9WaZ1bHlOP5hQILlg4jqqsSzFNgnunG9d8xYN/05CyKQoVpY14BkbuibVK7FZP+2GwjnFAWxR5bR9bmqNEWX3y7+TlFa6AnYIH3/kaCXVJQxwqUMp2lU9icfHXcLxoZRDU+8Z/HVwtV0CqjIDDOVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lONVzLlX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lONVzLlX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F8DCC4CEC2;
	Mon,  2 Sep 2024 18:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725301857;
	bh=oCmmToF60RFu8+JN137VcifPP51o1/FMqzC76K6uJbI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lONVzLlX0j+NMlbF/GkYhJSlR8apcV1ZpkbW1ZVD0KBuo5MTtwQ2yrtI3Bq3Tk9Mc
	 IIWE3hUVycDaEVMM5plaY3gnSe1BuHt9Q30e6S2AzVcYf5QltclFBJ8Rt8eTw3D9Qj
	 o5Y1k80A7ILext8MHpagA7P+362ewB67lAoQpuE+X8XjPGEkX4dE0FVL1J8fwxesQa
	 wKfD1JqHTF/V7SVYh2AcYMiIAYSczfoQ3Zi4PpWe/euxajlpvvmmp5FZUJ1Q4ByXgw
	 4qiCSwZ3zP1Ax1+V81WshhnLnZRaLLQbeEL9BYjoOknhybN5XaKGpd7wncB5AsgVTl
	 E63uUxSEPBJ2g==
Date: Mon, 02 Sep 2024 11:30:56 -0700
Subject: [PATCH 05/10] xfs: make the rtalloc start hint a xfs_rtblock_t
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172530106848.3326080.1417046683456610512.stgit@frogsfrogsfrogs>
In-Reply-To: <172530106749.3326080.9105141649726807892.stgit@frogsfrogsfrogs>
References: <172530106749.3326080.9105141649726807892.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

0 is a valid start RT extent, and with pending changes it will become
both more common and non-unique.  Switch to pass a xfs_rtblock_t instead
so that we can use NULLRTBLOCK to determine if a hint was set or not.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_rtalloc.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 61e0c5b7a327..29edb8044b00 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1266,7 +1266,7 @@ xfs_rtalloc_align_minmax(
 static int
 xfs_rtallocate(
 	struct xfs_trans	*tp,
-	xfs_rtxnum_t		start,
+	xfs_rtblock_t		bno_hint,
 	xfs_rtxlen_t		minlen,
 	xfs_rtxlen_t		maxlen,
 	xfs_rtxlen_t		prod,
@@ -1280,6 +1280,7 @@ xfs_rtallocate(
 		.mp		= tp->t_mountp,
 		.tp		= tp,
 	};
+	xfs_rtxnum_t		start = 0;
 	xfs_rtxnum_t		rtx;
 	xfs_rtxlen_t		len = 0;
 	int			error = 0;
@@ -1297,7 +1298,9 @@ xfs_rtallocate(
 	 * For an allocation to an empty file at offset 0, pick an extent that
 	 * will space things out in the rt area.
 	 */
-	if (!start && initial_user_data)
+	if (bno_hint)
+		start = xfs_rtb_to_rtx(args.mp, bno_hint);
+	else if (initial_user_data)
 		start = xfs_rtpick_extent(args.mp, tp, maxlen);
 
 	if (start) {
@@ -1410,15 +1413,16 @@ int
 xfs_bmap_rtalloc(
 	struct xfs_bmalloca	*ap)
 {
-	struct xfs_mount	*mp = ap->ip->i_mount;
 	xfs_fileoff_t		orig_offset = ap->offset;
-	xfs_rtxnum_t		start = 0; /* allocation hint rtextent no */
 	xfs_rtxlen_t		prod = 0;  /* product factor for allocators */
 	xfs_rtxlen_t		ralen = 0; /* realtime allocation length */
+	xfs_rtblock_t		bno_hint = NULLRTBLOCK;
 	xfs_extlen_t		orig_length = ap->length;
 	xfs_rtxlen_t		raminlen;
 	bool			rtlocked = false;
 	bool			noalign = false;
+	bool			initial_user_data =
+		ap->datatype & XFS_ALLOC_INITIAL_USER_DATA;
 	int			error;
 
 retry:
@@ -1427,10 +1431,10 @@ xfs_bmap_rtalloc(
 		return error;
 
 	if (xfs_bmap_adjacent(ap))
-		start = xfs_rtb_to_rtx(mp, ap->blkno);
+		bno_hint = ap->blkno;
 
-	error = xfs_rtallocate(ap->tp, start, raminlen, ralen, prod, ap->wasdel,
-			ap->datatype & XFS_ALLOC_INITIAL_USER_DATA, &rtlocked,
+	error = xfs_rtallocate(ap->tp, bno_hint, raminlen, ralen, prod,
+			ap->wasdel, initial_user_data, &rtlocked,
 			&ap->blkno, &ap->length);
 	if (error == -ENOSPC) {
 		if (!noalign) {

