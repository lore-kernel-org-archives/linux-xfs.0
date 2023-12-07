Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75C051FDA
	for <linux-xfs@vger.kernel.org>; Thu,  7 Dec 2023 02:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nQ8pl499"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7345C433C7;
	Thu,  7 Dec 2023 02:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701916840;
	bh=L7MK2sE2kJ63crrIOJA8tbez9des+IP7g5Jmq8pCyIg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=nQ8pl499GHDDe+qe8O+f4SxL6rXczE6B7mIfubfTpqN0vgECyOkzcuvh+0ezjO2r/
	 AhLvbBF/HmPPIs2TqqH5Fdwou40YPf/dGQpC6VcHkEaIX/dPVG0DZKsTVjD3+Kmb66
	 H5Q6k6bjDKT46oE7fo9bncwvZrH85DkgLEXBAbimJNTsmF8/lV3kWFW2fsAJ4rrEJG
	 +6rp26xwwpNjpSfNgS3+spscaGpzgSKTxWY7ATGElQw/c4EfkDdeOLNXlv4zQBGWPq
	 ayMkF9DdNFNHckN1XmTLtmGDSR/I9gnMmILwxH98RcKtomd0OTEp4sQnHpUCDwGy1t
	 1L63T3h0umC5A==
Date: Wed, 06 Dec 2023 18:40:39 -0800
Subject: [PATCH 3/7] xfs: roll the scrub transaction after completing a repair
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <170191665665.1181880.2539799368808502512.stgit@frogsfrogsfrogs>
In-Reply-To: <170191665599.1181880.961660208270950504.stgit@frogsfrogsfrogs>
References: <170191665599.1181880.961660208270950504.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

When we've finished repairing an AG header, roll the scrub transaction.
This ensure that any failures caused by defer ops failing are captured
by the xrep_done tracepoint and that any stacktraces that occur will
point to the repair code that caused it, instead of xchk_teardown.

Going forward, repair functions should commit the transaction if they're
going to return success.  Usually the space reaping functions that run
after a successful atomic commit of the new metadata will take care of
that for us.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/agheader_repair.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index 52956c0b8f79a..26bd1ff68f1be 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -73,7 +73,7 @@ xrep_superblock(
 	/* Write this to disk. */
 	xfs_trans_buf_set_type(sc->tp, bp, XFS_BLFT_SB_BUF);
 	xfs_trans_log_buf(sc->tp, bp, 0, BBTOB(bp->b_length) - 1);
-	return error;
+	return 0;
 }
 
 /* AGF */
@@ -342,7 +342,7 @@ xrep_agf_commit_new(
 	pag->pagf_refcount_level = be32_to_cpu(agf->agf_refcount_level);
 	set_bit(XFS_AGSTATE_AGF_INIT, &pag->pag_opstate);
 
-	return 0;
+	return xrep_roll_ag_trans(sc);
 }
 
 /* Repair the AGF. v5 filesystems only. */
@@ -789,6 +789,9 @@ xrep_agfl(
 	/* Dump any AGFL overflow. */
 	error = xrep_reap_agblocks(sc, &agfl_extents, &XFS_RMAP_OINFO_AG,
 			XFS_AG_RESV_AGFL);
+	if (error)
+		goto err;
+
 err:
 	xagb_bitmap_destroy(&agfl_extents);
 	return error;
@@ -962,7 +965,7 @@ xrep_agi_commit_new(
 	pag->pagi_freecount = be32_to_cpu(agi->agi_freecount);
 	set_bit(XFS_AGSTATE_AGI_INIT, &pag->pag_opstate);
 
-	return 0;
+	return xrep_roll_ag_trans(sc);
 }
 
 /* Repair the AGI. */

