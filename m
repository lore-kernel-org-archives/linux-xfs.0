Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA6BE23FC41;
	Fri, 25 Sep 2026 04:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790309494; cv=none; b=oFkYc1TOfRl0lCxq2H56EmjQ+LK86RIRwL1GwJyaMFNNXgvRg7lgATHsn1srRfc1T3yFyvtcwUT5qEtmdQerP8TBRCfWRiyMLrPxSgCQStAaS0dvWDgn3ldIOJZlbueOFIKsmXESo7oqNUHvHnJpE3trllerDwtsW028EI4HM9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790309494; c=relaxed/simple;
	bh=pbDcJl/eEdDo8fj1RM9TFBGKIUgsBOYpTuI9l4Vs9+s=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KYHv8nNU18P7X9mTdVhPbeu/jn9BhlcDdlOrVEyFTfKi0oZzgxJi49BANfSY50yKdB/uuqc7hLRFK6SilWaPgmAjcAAo2ss4mJ9bMT5Vx4OrzqjZbqcGCVxobYBPAwg9tvHySqlNGynXjjpXuhncFTheCfunJqcMmFzyXbe6G0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KB7z0Li6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KB7z0Li6"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 68CAA1F000FF;
	Fri, 25 Sep 2026 04:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790309493;
	bh=YZEhSM4R+/Sa/38bsUc8n/KXkAHPexmvccnVR4UjA8M=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=KB7z0Li6AYvTclgOVPrS9RmDcDRIaktx8dyrw4hCh2GMKvKlFDEMMXgLpL/khL5cr
	 w0fJ5I+NqyPqvBg9hccQxLGLLIAkybKMIGvkgH+946+QdSJycP5OoDEknMy2JJoLcf
	 9V1Us+pZiJH2gzE8bmPFd2NC6jQYqougyWtIf07jUMad0PlcoDZsb8v7r9lAzlAKVg
	 riy7/LIKyIa/VyVsTwqH0aknyhiMl2gdFneFdbNxCU13FjvrbjZMdaDoslau3/cZFa
	 YyDOgVQEdWdZ6TxkV21jcgbkuBgrYfDVDF7B/toZkpf3HoD0ia1y2jIIkQ4h9ahYu4
	 6c5OKkvyHtAUw==
Date: Thu, 24 Sep 2026 21:11:32 -0700
Subject: [PATCH 04/12] xfs: cross-reference the primary superblock
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179030932134.3344850.5609886284054108098.stgit@frogsfrogsfrogs>
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

Make sure we cross-reference the primary superblock against the rest of
the AG 0 space metadata.  Drop the unused @bp parameter of
xchk_superblock_xref to avoid complaints about uninitialized variables.

Cc: <stable@vger.kernel.org> # v4.16
Fixes: 52dc4b44af7419 ("xfs: cross-reference with the bnobt")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/scrub/agheader.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index fa5d32ec020aec..1dff6cb1b93628 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -35,8 +35,7 @@ xchk_setup_agheader(
 /* Cross-reference with the other btrees. */
 STATIC void
 xchk_superblock_xref(
-	struct xfs_scrub	*sc,
-	struct xfs_buf		*bp)
+	struct xfs_scrub	*sc)
 {
 	struct xfs_mount	*mp = sc->mp;
 	xfs_agnumber_t		agno = sc->sm->sm_agno;
@@ -106,16 +105,12 @@ xchk_superblock(
 	struct xfs_dsb		*sb;
 	struct xfs_perag	*pag;
 	size_t			sblen;
-	xfs_agnumber_t		agno;
+	xfs_agnumber_t		agno = sc->sm->sm_agno;
 	uint32_t		v2_ok;
 	__be32			features_mask;
 	int			error;
 	__be16			vernum_mask;
 
-	agno = sc->sm->sm_agno;
-	if (agno == 0)
-		return 0;
-
 	/*
 	 * Grab an active reference to the perag structure.  If we can't get
 	 * it, we're racing with something that's tearing down the AG, so
@@ -125,6 +120,9 @@ xchk_superblock(
 	if (!pag)
 		return -ENOENT;
 
+	if (agno == 0)
+		goto out_xref;
+
 	error = xfs_sb_read_secondary(mp, sc->tp, agno, &bp);
 	/*
 	 * The superblock verifier can return several different error codes
@@ -430,7 +428,8 @@ xchk_superblock(
 	if (memchr_inv((char *)sb + sblen, 0, BBTOB(bp->b_length) - sblen))
 		xchk_block_set_corrupt(sc, bp);
 
-	xchk_superblock_xref(sc, bp);
+out_xref:
+	xchk_superblock_xref(sc);
 out_pag:
 	xfs_perag_put(pag);
 	return error;

