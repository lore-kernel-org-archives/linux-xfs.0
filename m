Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A7C4421244;
	Fri,  4 Sep 2026 06:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788503226; cv=none; b=nWRazfuhXIQZR5Nn24fO2KxecY3FIBqCVI66Qj9fST8BUll5Ax+HOQgVjIm8QfFyX7IAZ1JQMhl+7CU/+iAMTSm//or1BWAW6hCFvnia4G+4KAH9CWAvsARK30GqpRUXasKlMjMHaqez6x2elRhslTbUzEgh1hac47sGG2NtXhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788503226; c=relaxed/simple;
	bh=1sxKkgEVJoCNs35LGNPqKGuSoLWpc0XkJ2LzTpvT96Y=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oVwNMBCUk4EDs0N2zw5Y98ZLj3eS+WLFiMJYT5Z3/G89NFND7P1i+kY6FwHWVUA8K/x4tjG9JStPecPRhZk6YciqpukuIashWGnso66iE9CrPnJYS0WiXuGx2JgowZ4mpS6HEE1Ef6xL0SUW/lqk53vnB5A25qfcpvwe5gGXLi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jfZbvev0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jfZbvev0"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id AB8B91F00ADE;
	Fri,  4 Sep 2026 06:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788503224;
	bh=8gwrZ/5XsVgdkU1OBDraoUUB4P8sICTHbBov3DjTBdk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=jfZbvev0D73rfIbiWqoNl1zetiNqnBv79H8VtH4roCcGgk/sLyH6+RWonideuYHUA
	 vGC8c7qSg4/eyTxo8cVEc9v/1MUH3s+e2FhAr+RdtxGFZJarQzJpgxXOGa2imEcCXT
	 DakLSM90VzXsKiWf7/qfib/bL14Lnxq2xISkeWYJg/OBr6YlDDxeVTOo1msvBAY1yH
	 zkoJcaU9JN187g61Y9LqCbfRZ7i1Cb03ULWi0ayyPE1FzW+EuoSo83g4Xje0/l4ffg
	 jcU0gA7Pxs39oTSTPk/joGLZX2FMJYulC3SJiIrn856zqsV5FPaHXABglkdAZfbt3q
	 hisayM/A/nw2w==
Date: Thu, 03 Sep 2026 23:27:04 -0700
Subject: [PATCH 5/6] xfs: snapshot old AGFL before rewriting it
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, hch@lst.de, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178850312604.1198660.10155894539984458686.stgit@frogsfrogsfrogs>
In-Reply-To: <178850312462.1198660.3332635535003842521.stgit@frogsfrogsfrogs>
References: <178850312462.1198660.3332635535003842521.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM complains that we can't undo an attempt at fixing the AGFL if
anything goes wrong during the rewrite, so take a snapshot of the whole
buffer so that we can restore it.  Move the xrep_agfl_update_agf call so
that we only update the AGF if the AGFL update is 100% successful.

Cc: <stable@vger.kernel.org> # v4.19
Fixes: 0e93d3f43ec7d3 ("xfs: repair the AGFL")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/agheader_repair.c |   37 ++++++++++++++++++++++++++-----------
 1 file changed, 26 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index 2104512f1ee19a..46c95354ca6438 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -668,14 +668,16 @@ xrep_agfl_init_header(
 	struct xfs_scrub	*sc,
 	struct xfs_buf		*agfl_bp,
 	struct xagb_bitmap	*agfl_extents,
-	xfs_agblock_t		flcount)
+	xfs_agblock_t		flcount,
+	struct xfs_agfl		*old_agfl)
 {
 	struct xrep_agfl_fill	af = {
 		.sc		= sc,
 		.flcount	= flcount,
 	};
 	struct xfs_mount	*mp = sc->mp;
-	struct xfs_agfl		*agfl;
+	struct xfs_agfl		*agfl = XFS_BUF_TO_AGFL(agfl_bp);
+	const size_t		agfl_sz = BBTOB(agfl_bp->b_length);
 	int			error;
 
 	ASSERT(flcount <= xfs_agfl_size(mp));
@@ -684,8 +686,8 @@ xrep_agfl_init_header(
 	 * Start rewriting the header by setting the bno[] array to
 	 * NULLAGBLOCK, then setting AGFL header fields.
 	 */
-	agfl = XFS_BUF_TO_AGFL(agfl_bp);
-	memset(agfl, 0xFF, BBTOB(agfl_bp->b_length));
+	memcpy(old_agfl, agfl, agfl_sz);
+	memset(agfl, 0xFF, agfl_sz);
 	agfl->agfl_magicnum = cpu_to_be32(XFS_AGFL_MAGIC);
 	agfl->agfl_seqno = cpu_to_be32(pag_agno(sc->sa.pag));
 	uuid_copy(&agfl->agfl_uuid, &mp->m_sb.sb_meta_uuid);
@@ -700,13 +702,18 @@ xrep_agfl_init_header(
 	xagb_bitmap_walk(agfl_extents, xrep_agfl_fill, &af);
 	error = xagb_bitmap_disunion(agfl_extents, &af.used_extents);
 	if (error)
-		return error;
+		goto err_undo;
 
 	/* Write new AGFL to disk. */
 	xfs_trans_buf_set_type(sc->tp, agfl_bp, XFS_BLFT_AGFL_BUF);
-	xfs_trans_log_buf(sc->tp, agfl_bp, 0, BBTOB(agfl_bp->b_length) - 1);
+	xfs_trans_log_buf(sc->tp, agfl_bp, 0, agfl_sz - 1);
 	xagb_bitmap_destroy(&af.used_extents);
 	return 0;
+
+err_undo:
+	xagb_bitmap_destroy(&af.used_extents);
+	memcpy(agfl, old_agfl, agfl_sz);
+	return error;
 }
 
 /* Repair the AGFL. */
@@ -718,6 +725,7 @@ xrep_agfl(
 	struct xfs_mount	*mp = sc->mp;
 	struct xfs_buf		*agf_bp;
 	struct xfs_buf		*agfl_bp;
+	struct xfs_agfl		*old_agfl;
 	xfs_agblock_t		flcount;
 	int			error;
 
@@ -725,6 +733,10 @@ xrep_agfl(
 	if (!xfs_has_rmapbt(mp))
 		return -EOPNOTSUPP;
 
+	old_agfl = kzalloc(BBTOB(XFS_FSS_TO_BB(mp, 1)), XCHK_GFP_FLAGS);
+	if (!old_agfl)
+		return -ENOMEM;
+
 	xagb_bitmap_init(&agfl_extents);
 
 	/*
@@ -734,7 +746,7 @@ xrep_agfl(
 	 */
 	error = xfs_alloc_read_agf(sc->sa.pag, sc->tp, 0, &agf_bp);
 	if (error)
-		return error;
+		goto err_old_agfl;
 
 	/*
 	 * Make sure we have the AGFL buffer, as scrub might have decided it
@@ -745,7 +757,7 @@ xrep_agfl(
 						XFS_AGFL_DADDR(mp)),
 			XFS_FSS_TO_BB(mp, 1), 0, &agfl_bp, NULL);
 	if (error)
-		return error;
+		goto err_old_agfl;
 	agfl_bp->b_ops = &xfs_agfl_buf_ops;
 
 	/* Gather all the extents we're going to put on the new AGFL. */
@@ -762,10 +774,11 @@ xrep_agfl(
 	 * we adjust the AGF flcount (which can fail) so avoid updating any
 	 * buffers until we know that part works.
 	 */
+	error = xrep_agfl_init_header(sc, agfl_bp, &agfl_extents, flcount,
+			old_agfl);
+	if (error)
+		goto err;
 	xrep_agfl_update_agf(sc, agf_bp, flcount);
-	error = xrep_agfl_init_header(sc, agfl_bp, &agfl_extents, flcount);
-	if (error)
-		goto err;
 
 	/*
 	 * Ok, the AGFL should be ready to go now.  Roll the transaction to
@@ -785,6 +798,8 @@ xrep_agfl(
 
 err:
 	xagb_bitmap_destroy(&agfl_extents);
+err_old_agfl:
+	kfree(old_agfl);
 	return error;
 }
 

