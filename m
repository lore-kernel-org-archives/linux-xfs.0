Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 589591848
	for <linux-xfs@vger.kernel.org>; Tue, 23 Jan 2024 04:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705983045; cv=none; b=Ij/DPkwrLumhuNm2tVaBRhgIs3DkVNAy7zPIs11suGgetHJRKIE8LZQ+I1bZq3sLW1q7gEzcNFXIQKRrd2/kaxoNtH0gzZlKWjA+gKGi/UErDan4S/8Z42pL2HZJxtCQCUlFVU2akLOcvT3iaYIed/ECbghso82pnVY17R/xycI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705983045; c=relaxed/simple;
	bh=y5WLLCVkX9HncwKSgzTGyBC/ErihhL29/TXOZ+6YBLc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=p+YAJeW49fIbRa/kJLS/6YD10tpXlUB7pek2CJpwqCc8akRIT7JdjJYO0ZaNIb+5oMGqz52t13K7mR2SldZwsgghpuDjKww+0M39O2x/rMDE2dOm3QcYjtidkAFtkW5Wy1yGARcrYnS2EWVrPL5o4IxxpcajDEhxZofuM6OPDSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZCpB5cA3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZCpB5cA3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EA59C433F1;
	Tue, 23 Jan 2024 04:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705983045;
	bh=y5WLLCVkX9HncwKSgzTGyBC/ErihhL29/TXOZ+6YBLc=;
	h=Date:From:To:Cc:Subject:From;
	b=ZCpB5cA3skaSYBURrUl2BsNVxD2PDbUJ1ho6pNjCmstQzerkGrEruDQbBDFstXPJh
	 6baow5iXbcdfTKV3qQmo88Z2ShF+Y7gPXt2Ut69iY5mL5Yu0c4Q7ssiQC6MH7Y8Odl
	 9F/DcewldmGFrmeFqsa1xO4aZMPViwctDfClNN+LfUgR7DVcyzkYVxAokfwaD2kqoN
	 W7sHBFtXvyQLK+EuSJsJzDIeABvU26OCqNsaHdCuFwvBVQfrvyyfs/xqrUVRtU6m7L
	 sUDUWXWDOabOCp+T2OuzjZfqu6DPQkXP8ELomX/y9y39b0Uoy4aThpEpRYk5F9w+mf
	 RqC1rUsjsZthA==
Date: Mon, 22 Jan 2024 20:10:44 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: [PATCH] xfs_db: don't hardcode 'type data' size at 512b
Message-ID: <20240123041044.GD6226@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

On a disk with 4096-byte LBAs, the xfs_db 'type data' subcommand doesn't
work:

# xfs_io -c 'sb' -c 'type data' /dev/sda
xfs_db: read failed: Invalid argument
no current object

The cause of this is the hardcoded initialization of bb_count when we're
setting type data -- it should be the filesystem sector size, not just 1.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/block.c |    7 ++++---
 db/io.c    |    3 ++-
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/db/block.c b/db/block.c
index f234fcb4edcb..c847a91dd22f 100644
--- a/db/block.c
+++ b/db/block.c
@@ -149,6 +149,7 @@ daddr_f(
 	int64_t		d;
 	char		*p;
 	int		c;
+	int		bb_count = BTOBB(mp->m_sb.sb_sectsize);
 	xfs_rfsblock_t	max_daddrs = mp->m_sb.sb_dblocks;
 	enum daddr_target tgt = DT_DATA;
 
@@ -202,13 +203,13 @@ daddr_f(
 	ASSERT(typtab[TYP_DATA].typnm == TYP_DATA);
 	switch (tgt) {
 	case DT_DATA:
-		set_cur(&typtab[TYP_DATA], d, 1, DB_RING_ADD, NULL);
+		set_cur(&typtab[TYP_DATA], d, bb_count, DB_RING_ADD, NULL);
 		break;
 	case DT_RT:
-		set_rt_cur(&typtab[TYP_DATA], d, 1, DB_RING_ADD, NULL);
+		set_rt_cur(&typtab[TYP_DATA], d, bb_count, DB_RING_ADD, NULL);
 		break;
 	case DT_LOG:
-		set_log_cur(&typtab[TYP_DATA], d, 1, DB_RING_ADD, NULL);
+		set_log_cur(&typtab[TYP_DATA], d, bb_count, DB_RING_ADD, NULL);
 		break;
 	}
 	return 0;
diff --git a/db/io.c b/db/io.c
index 580d34015868..3841c0dcb86e 100644
--- a/db/io.c
+++ b/db/io.c
@@ -681,7 +681,8 @@ void
 set_iocur_type(
 	const typ_t	*type)
 {
-	int		bb_count = 1;	/* type's size in basic blocks */
+	/* type's size in basic blocks */
+	int		bb_count = BTOBB(mp->m_sb.sb_sectsize);
 	int		boff = iocur_top->boff;
 
 	/*
