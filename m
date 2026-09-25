Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5B6418D62A
	for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 04:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790309541; cv=none; b=LFxXLS38RtByUf1RbYJJhOtZSMyeGPAsj+SRGeZ8NrytYBcYra/n5AkQB6/jgsPMf3z2Gnct2ARyvMhaV/V18MBcEoog2RdkiZAhUtt9XWw0y9THGYzkOCKT7ivA258YFLtVKV2cmf+PFdwa0Iu+UX2YXHWlfUS3g4/m+wxutNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790309541; c=relaxed/simple;
	bh=gWYKACqcH7LOlZt+R7pyvDHCAHdMdFai8PD54A7vdvU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n5xd4x9es0VJ7RF7ysiFqQtcaRwfwA69+V8xwyUpkcC9t51YXmtxUOu4cfYx4zDoJFVS7i8bKSYDklCHbjsSnZKU3+vJ3R+EzsaPZJta1gZvdaSAwZ+jSfoGilCIzG63W0sZ3Ohl6rtx1duX/dCUnHpuDM5hcV18xhSMJVrl8fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ba/kT3i0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ba/kT3i0"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 5D2691F000FF;
	Fri, 25 Sep 2026 04:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790309540;
	bh=LBdJ87v/30RTybx/MyNrjFZt9BadvQUY7xOGy7aQ3E4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=ba/kT3i0WLad2BfOeD2ruL+e+Z4xwCuKLxlo7/TI2Fyrq+DlHmAQHoLzWPdO1dfOC
	 EnIlbN0+XY0kNGrAWykj0OC1ixx5vOJA0aoSRFJ6NZRGQixKLyMWI+FeaZTUVlsdls
	 Hc/nsP2VgmxCPYXiZ14xPeDAN5a1DFiZE3GNcion8z8469iVycG1jXRu0s3YyBOrIb
	 en8LAR9bACdmcCpxm3uenAG1GppZIy/4bcHiYp6fABhuaCCi3d1O51Oitnvj5Hhsak
	 gKPBTpSQPUcj5lZUYW2R7pVhnuX/Yj4tV712R4q5gbdcNoTA/o58iRzwP/mcTTgnsa
	 ZLjGHXLXJpc4A==
Date: Thu, 24 Sep 2026 21:12:19 -0700
Subject: [PATCH 07/12] xfs: write the primary super immediately during repair
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <179030932197.3344850.10179874390293040672.stgit@frogsfrogsfrogs>
In-Reply-To: <179030931976.3344850.17488605741516845262.stgit@frogsfrogsfrogs>
References: <179030931976.3344850.17488605741516845262.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

xrep_superblock has an unfortunate flaw -- it won't even try to repair
the primary super block, even though we have a live copy in memory that
we could log and write to disk right now.  We should do this, because a
crash will render the filesystem unmountable on recovery.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/scrub/agheader.c        |    3 +--
 fs/xfs/scrub/agheader_repair.c |   31 +++++++++++++++++++++++++++----
 2 files changed, 28 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index 1dff6cb1b93628..43f3c3a5060b51 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -56,8 +56,7 @@ xchk_superblock_xref(
 	xchk_xref_is_only_owned_by(sc, agbno, 1, &XFS_RMAP_OINFO_FS);
 	xchk_xref_is_not_shared(sc, agbno, 1);
 	xchk_xref_is_not_cow_staging(sc, agbno, 1);
-
-	/* scrub teardown will take care of sc->sa for us */
+	xchk_ag_free(sc, &sc->sa);
 }
 
 /*
diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index a66b611588c47f..3c1947326d4448 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -44,12 +44,35 @@ xrep_superblock(
 	struct xfs_mount	*mp = sc->mp;
 	struct xfs_buf		*bp;
 	xfs_agnumber_t		agno;
-	int			error;
+	int			error = 0;
 
-	/* Don't try to repair AG 0's sb; let xfs_repair deal with it. */
 	agno = sc->sm->sm_agno;
-	if (agno == 0)
-		return -EOPNOTSUPP;
+	if (agno == 0) {
+		/* Last chance to abort before we start committing fixes. */
+		if (xchk_should_terminate(sc, &error))
+			return error;
+
+		bp = xfs_trans_getsb(sc->tp);
+
+		/* Format the incore superblock into the primary sb buffer */
+		xfs_buf_zero(bp, 0, BBTOB(bp->b_length));
+		xfs_sb_to_disk(bp->b_addr, &mp->m_sb);
+
+		xfs_log_sb(sc->tp);
+
+		/* synchronous transaction to flush/release the buffer log item */
+		xfs_trans_set_sync(sc->tp);
+		error = xrep_trans_commit(sc);
+		if (error)
+			return error;
+
+		/* write the super out immediately */
+		xfs_buf_lock(bp);
+		xfs_buf_hold(bp);
+		error = xfs_bwrite(bp);
+		xfs_buf_relse(bp);
+		return error;
+	}
 
 	error = xfs_sb_get_secondary(mp, sc->tp, agno, &bp);
 	if (error)

