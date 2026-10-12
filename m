Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22B883AEF46;
	Mon, 12 Oct 2026 05:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791784796; cv=none; b=EMS7hk7mNpxPQhDBjyJoOfa4Kmg0Eb2ONjkYm4oG5tCmGXZVFrrBO17q9WZVvIJCSomINGCAvssFNGDZ6v8upqOnXdG3Q1bm4hOkkGyyzifTLaqwMPEXqDlTBfD9gfwLDvexqbkkDJz2p8iVpVuJmxv0d5RNFh4BjJmdfPyATOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791784796; c=relaxed/simple;
	bh=tmWAoFfxcPXPxLAiFo9/0BbNdvNPtVOOSr8TT8ZlnWI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rim4GEyiQE7tAYcEgJfpHwPwAbFABoOV6bF5Xg1XgTWRVv/gQAOhJqsuVJOWgASXIDyoV+fJYYdypv4kNgWaYQPNTHPe5va00+ej02WQ5C2ka57y7/f3mhEKc1o+gicWE5rqNo24og/WtftTLR1CyK338wZW+ceb5wsdgrtEhsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HoWSfKoU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HoWSfKoU"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A82851F0089B;
	Mon, 12 Oct 2026 05:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791784794;
	bh=vsgmzw728au1F+sxzdD+N9O7OhPB4gpcIph3giPUeO8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=HoWSfKoU8feBrAnFpgBu9o34XaRQbICoc0XVZWLK9Ln01CM4QKOAHVCY7FarspzLp
	 aS+WjvR7fXSN3110g8+hW/ofxxugfVCE8Y9zTt+wuQd/Ft9sMlBPYSoFiGgJBDfTme
	 fUmpqiv2PFcoJ0OPV3yDHAKoP6mQvkxX60RtHtq/RJZDot6i6nte6MuzUFqAmWglGl
	 9KV7CeNhgz8IdYVPTGjvc8yD7EX+iSjmYngDRG49yiJZiXKKeX23yNr6miKSXCV1dk
	 WntSiIFQ2mu9wSF670Os9awdU/tZCrz5Qa3Jy1SsF5PfG1xdU6ywcQQ3W3Y9Sq0rLF
	 bcL3pVYnL5Z4A==
Date: Sun, 11 Oct 2026 22:59:54 -0700
Subject: [PATCH 04/12] xfs: don't try to repair rtsummary if the summary file
 isn't computed
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179178065880.1058822.7169477353675130912.stgit@frogsfrogsfrogs>
In-Reply-To: <179178065713.1058822.6886680430162106741.stgit@frogsfrogsfrogs>
References: <179178065713.1058822.6886680430162106741.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM observed that we can erroneously try to repair the rtsummary file
if we've not yet computed its contents.  That results in a corrupt
summary file, so let's add a flag to track whether or not the incore
data is complete.

Cc: <stable@vger.kernel.org> # v6.10
Fixes: abf039e2e4afde ("xfs: online repair of realtime summaries")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/rtsummary.h        |    1 +
 fs/xfs/scrub/rtsummary.c        |    9 ++++++++-
 fs/xfs/scrub/rtsummary_repair.c |    2 +-
 3 files changed, 10 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/scrub/rtsummary.h b/fs/xfs/scrub/rtsummary.h
index e44b04cb6e2d5e..af1ab64c3f2125 100644
--- a/fs/xfs/scrub/rtsummary.h
+++ b/fs/xfs/scrub/rtsummary.h
@@ -17,6 +17,7 @@ struct xchk_rtsummary {
 	xfs_filblks_t		rsumblocks;
 	unsigned int		rsumlevels;
 	unsigned int		resblks;
+	bool			summary_computed;
 
 	/* suminfo position of xfile as we write buffers to disk. */
 	xfs_rtsumoff_t		prep_wordoff;
diff --git a/fs/xfs/scrub/rtsummary.c b/fs/xfs/scrub/rtsummary.c
index 546b335ade1354..fa358746beaf5c 100644
--- a/fs/xfs/scrub/rtsummary.c
+++ b/fs/xfs/scrub/rtsummary.c
@@ -212,13 +212,20 @@ xchk_rtsum_compute(
 {
 	struct xfs_mount	*mp = sc->mp;
 	struct xfs_rtgroup	*rtg = sc->sr.rtg;
+	struct xchk_rtsummary	*rts = sc->buf;
+	int			error;
 
 	/* If the bitmap size doesn't match the computed size, bail. */
 	if (XFS_FSB_TO_B(mp, xfs_rtbitmap_blockcount(mp)) !=
 	    rtg_bitmap(rtg)->i_disk_size)
 		return -EFSCORRUPTED;
 
-	return xfs_rtalloc_query_all(rtg, sc->tp, xchk_rtsum_record_free, sc);
+	error = xfs_rtalloc_query_all(rtg, sc->tp, xchk_rtsum_record_free, sc);
+	if (error)
+		return error;
+
+	rts->summary_computed = true;
+	return 0;
 }
 
 /* Compare the rtsummary file against the one we computed. */
diff --git a/fs/xfs/scrub/rtsummary_repair.c b/fs/xfs/scrub/rtsummary_repair.c
index ed763290aec1e5..45bdefaeab013e 100644
--- a/fs/xfs/scrub/rtsummary_repair.c
+++ b/fs/xfs/scrub/rtsummary_repair.c
@@ -122,7 +122,7 @@ xrep_rtsummary(
 		return -EOPNOTSUPP;
 
 	/* Walk away if we disagree on the size of the rt bitmap. */
-	if (rts->rbmblocks != mp->m_sb.sb_rbmblocks)
+	if (rts->rbmblocks != mp->m_sb.sb_rbmblocks || !rts->summary_computed)
 		return 0;
 
 	/* Make sure any problems with the fork are fixed. */

