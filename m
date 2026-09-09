Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9494D18DB35;
	Wed,  9 Sep 2026 06:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788933845; cv=none; b=OvP2iDk5nQmEk6kN4yZn0S6MV+j1UDKc6D026SzkQWlkXkUdKNYz9dR8mh7NrTOX308YC84IDoUPd//BNkMU+kpkaBYiMibzgHrJP6uqmjMXZoWtYXnqjCrMnq5SaiQCrG5LQG7dVF4ZnbUhtO2+X9W8j0Gqlumw8PUa1kQdLP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788933845; c=relaxed/simple;
	bh=NS5lNie7vm+eydHt8acgPtaXc0SLFSVhVxrqJ8OLnJs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DDq34zrzj4+HrnAhT5yvTvMH9zjLcrWzLQ/tIT5/sCP48pt97RCaHlzc4CuAYmuN8n5M7w/a36ugxl1/4T+xu2NhR4KJuYmf18In75cVQq2Iq5eIM+PONafvbFSjhAuP1Du1yz8DRFCHI0U1RQ9p91s5C5/JlIkqoZQ2gSxeKQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EnXXDIqN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EnXXDIqN"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 6D0A61F00A3D;
	Wed,  9 Sep 2026 06:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788933844;
	bh=s7y/Ju72UCv03GlqEqoW/XiK+TlVChw8QbzaipZ2HLQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=EnXXDIqNqLgYQ+4RYJ2Wl5VPra6Zc39uUHkq2TXhWTuO6VkUVxexMRrxC96rkLsso
	 fNdUbt4Ha4NXnKXH4p1CmczjEw11CcAufB1sy5piBnW6F+4xJduID2f4mTjOjOo7W1
	 Jsz1KKbDUzJUuAEhNS6gfq9E2AUk+nC19iKdZSHyVeiL0W18RP7rn1EUpqWF/chgYw
	 stPW3A2j9ybKtJs0QBn3gFnikmHmIlK0g95cxmplZh2mkLhnS+9uHy3fcfF47pZLtK
	 X4KWjeFjY9PNKJpgswV+OoQxZbP9OgW0NvBwa85LjQUO7bTTXcQKnHdfnzKktbNASy
	 k3/oD3e+qe3HQ==
Date: Tue, 08 Sep 2026 23:04:04 -0700
Subject: [PATCH 5/6] xfs: snapshot old AGFL before rewriting it
From: "Darrick J. Wong" <djwong@kernel.org>
To: hch@lst.de, cem@kernel.org, djwong@kernel.org
Cc: cmaiolino@redhat.com, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178892936292.4057682.2046087476879197640.stgit@frogsfrogsfrogs>
In-Reply-To: <178892936145.4057682.2272084577851638021.stgit@frogsfrogsfrogs>
References: <178892936145.4057682.2272084577851638021.stgit@frogsfrogsfrogs>
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

While we're at it, fix leaking the used_extents bitmap if the disunion
operation fails.

Cc: <stable@vger.kernel.org> # v4.19
Fixes: 0e93d3f43ec7d3 ("xfs: repair the AGFL")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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
 

