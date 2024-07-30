Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54DF410E9
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722299637; cv=none; b=R4ga+hHIb6MWT8hPiFDVNEQLmSsbS1Hl/qfaukUoy5hcrB3H2W1ZOpQBGS+HmJLVYckaQHAKY+0ztl958d0hzIatcOcQCBc0LpVFkS4S5BqnUWsfWctgxNYjQTDcSDX7RgRM1HmLJdi1mXnXG6Vh4l+uD42GK0Xe7Z0iN2gOLyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722299637; c=relaxed/simple;
	bh=WrHvGRxKeLIpn8O8OsOfhqco3mbu06Xa6B6/Xz1+Pjs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MIs0cR2mlmOO4hVR6BNOfSA/JITDXeYtq/IKxxJz2tB6fly4gQiM34kKdFgYqorMYbswhRrjFCH9f9vuw7tbMfIKXRnOhEm9+7+jDrixq08kKK3ucNgQRrEn4pGGB8mnXgc3q2mVsd3UKWKsZtUmbLHq1Jn+/9Xudc3mAkWLa04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Exz0teri; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Exz0teri"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F6AAC32786;
	Tue, 30 Jul 2024 00:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722299637;
	bh=WrHvGRxKeLIpn8O8OsOfhqco3mbu06Xa6B6/Xz1+Pjs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Exz0teriCvNReQ8HmkeG416HWILBGENpCDW4hFY9VpA3MhvTpEfdfc9lml1HXx/Sj
	 7kGZ8kU9tGycopkAMmsTtex3sh+LLvjkUhYbw5ewps7BrNqLB5y0pRrlzc6jpjMvLw
	 L/j2zVHHpT9beOugTcOEq6SlgOo18ea9CcWh2XF8wq7MjUNH/yg6zilGX3uZm5Uwth
	 I6l92kWwRu+2rSVNTNzMCcTD1ffZfAssvPcVb3R4ZjLA1Ta18uRpSh5CphodavfIb7
	 RHpG7WpQyt1HzB0Y3tPur4dwDm7qGUYOLcFhBKrRRQLqVU/iw5Ujtvu9plbYwvYtbK
	 274bLvx5yITcg==
Date: Mon, 29 Jul 2024 17:33:56 -0700
Subject: [PATCH 039/115] xfs: rework splitting of indirect block reservations
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>,
 Chandan Babu R <chandanbabu@kernel.org>, linux-xfs@vger.kernel.org
Message-ID: <172229842991.1338752.2749856648086015843.stgit@frogsfrogsfrogs>
In-Reply-To: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
References: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
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

Source kernel commit: da2b9c3a8d2cbdeec3f13cebf4c6c86c13e1077e

Move the check if we have enough indirect blocks and the stealing of
the deleted extent blocks out of xfs_bmap_split_indlen and into the
caller to prepare for handling delayed allocation of RT extents that
can't easily be stolen.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 libxfs/xfs_bmap.c |   38 ++++++++++++++++----------------------
 1 file changed, 16 insertions(+), 22 deletions(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 79cde87d0..7b18477e0 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -4825,31 +4825,17 @@ xfs_bmapi_remap(
  * ores == 1). The number of stolen blocks is returned. The availability and
  * subsequent accounting of stolen blocks is the responsibility of the caller.
  */
-static xfs_filblks_t
+static void
 xfs_bmap_split_indlen(
 	xfs_filblks_t			ores,		/* original res. */
 	xfs_filblks_t			*indlen1,	/* ext1 worst indlen */
-	xfs_filblks_t			*indlen2,	/* ext2 worst indlen */
-	xfs_filblks_t			avail)		/* stealable blocks */
+	xfs_filblks_t			*indlen2)	/* ext2 worst indlen */
 {
 	xfs_filblks_t			len1 = *indlen1;
 	xfs_filblks_t			len2 = *indlen2;
 	xfs_filblks_t			nres = len1 + len2; /* new total res. */
-	xfs_filblks_t			stolen = 0;
 	xfs_filblks_t			resfactor;
 
-	/*
-	 * Steal as many blocks as we can to try and satisfy the worst case
-	 * indlen for both new extents.
-	 */
-	if (ores < nres && avail)
-		stolen = XFS_FILBLKS_MIN(nres - ores, avail);
-	ores += stolen;
-
-	 /* nothing else to do if we've satisfied the new reservation */
-	if (ores >= nres)
-		return stolen;
-
 	/*
 	 * We can't meet the total required reservation for the two extents.
 	 * Calculate the percent of the overall shortage between both extents
@@ -4894,8 +4880,6 @@ xfs_bmap_split_indlen(
 
 	*indlen1 = len1;
 	*indlen2 = len2;
-
-	return stolen;
 }
 
 int
@@ -4911,7 +4895,7 @@ xfs_bmap_del_extent_delay(
 	struct xfs_bmbt_irec	new;
 	int64_t			da_old, da_new, da_diff = 0;
 	xfs_fileoff_t		del_endoff, got_endoff;
-	xfs_filblks_t		got_indlen, new_indlen, stolen;
+	xfs_filblks_t		got_indlen, new_indlen, stolen = 0;
 	uint32_t		state = xfs_bmap_fork_to_state(whichfork);
 	uint64_t		fdblocks;
 	int			error = 0;
@@ -4990,8 +4974,19 @@ xfs_bmap_del_extent_delay(
 		new_indlen = xfs_bmap_worst_indlen(ip, new.br_blockcount);
 
 		WARN_ON_ONCE(!got_indlen || !new_indlen);
-		stolen = xfs_bmap_split_indlen(da_old, &got_indlen, &new_indlen,
-						       del->br_blockcount);
+		/*
+		 * Steal as many blocks as we can to try and satisfy the worst
+		 * case indlen for both new extents.
+		 */
+		da_new = got_indlen + new_indlen;
+		if (da_new > da_old) {
+			stolen = XFS_FILBLKS_MIN(da_new - da_old,
+						 del->br_blockcount);
+			da_old += stolen;
+		}
+		if (da_new > da_old)
+			xfs_bmap_split_indlen(da_old, &got_indlen, &new_indlen);
+		da_new = got_indlen + new_indlen;
 
 		got->br_startblock = nullstartblock((int)got_indlen);
 
@@ -5003,7 +4998,6 @@ xfs_bmap_del_extent_delay(
 		xfs_iext_next(ifp, icur);
 		xfs_iext_insert(ip, icur, &new, state);
 
-		da_new = got_indlen + new_indlen - stolen;
 		del->br_blockcount -= stolen;
 		break;
 	}

