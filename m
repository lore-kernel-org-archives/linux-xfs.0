Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85D773AEF46;
	Mon, 12 Oct 2026 05:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791784780; cv=none; b=HwT97UghsAX8LEjcqsGq56Pol89wy1/HkCWQ8sjvtiVq/XxdAnO03SjUeHleMoZ+O/RH2gYq8DiOnLIQTJPIdw+DQvxCfKnPUpklRtOVuDhCPMCNUz82JI28ORCD26W9n4nk3JafXCu/UuwsNqi+9x8XmWzoFxcM6mFcRQ75m5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791784780; c=relaxed/simple;
	bh=2A8xdjCZ0goiDsnvZp/BbXfxDa0QESNl6ATP39RbiHA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u+BfUsm9/SoKQ9iLdRiwDQ0kMF0VRFUlC6r+y5SpFD971C2CtAz91GWx/TkEKltUPRPDgYOjYZJk4h4F67W6WAoeWDn7043+3k+Amj+sT+wVqHHQggqOk9Ypul7B2ss9UG0ALMFq9OCaezrbqxV8q+gRcbAc4gHevEEa19/g/64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Tc4Iasu+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tc4Iasu+"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 120DC1F0089B;
	Mon, 12 Oct 2026 05:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791784779;
	bh=wRdvJ/NJOKYroB+2cc1qvDj41fEndTbTkG01n5LtzWY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=Tc4Iasu+P89u1tMota9Nqao7azWsjOgb4pCtuZIn0CssX6s8bl5MILOQiPL6i7hIz
	 2cmLPbNw7/vEya1gnp33LzUrYvFMFQtRwP2O/TkPEPkODrd6BA37wxV+CXaM0GEY5g
	 siKjDbVM3l9mKcFPStzPvF3r509UiINRKUeJJn6gdKHXBwJIaehxfi6y4wYuBhz1Jk
	 PFy188Ln0lFTQWXDC6L0ralF41PTEPTQ0/vR8Mg+TPYAgIJXptSMgUTsfjcfa4Sc2G
	 3cBW33+aPuvFTI3UkqtohTKm0dMN+hgt9vlNvOOIrqTBjRuJOUG1iMIov3o03V/Jti
	 tEIULO/1hevag==
Date: Sun, 11 Oct 2026 22:59:38 -0700
Subject: [PATCH 03/12] xfs: rescan the AGs if incore delalloc counter is
 negative
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179178065859.1058822.2001240285823845729.stgit@frogsfrogsfrogs>
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

LOLLM complains that percpu_counter_sum can return a negative number but
we instead misinterpret that into a huge unsigned value and do bad
things to fdblocks.  It shouldn't do that, so let's add a retry loop and
an attempt to freeze the filesystem to (hopefully) zero out the incore
delalloc counter.  It probably won't work, but at least failing the
repair beats doing the wrong thing.

Cc: <stable@vger.kernel.org> # v5.2
Fixes: 75efa57d0bf5fc ("xfs: add online scrub for superblock counters")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/fscounters.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
index 5984fe13a973b8..c055b73d268058 100644
--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -297,7 +297,7 @@ xchk_fscount_aggregate_agcounts(
 {
 	struct xfs_mount	*mp = sc->mp;
 	struct xfs_perag	*pag = NULL;
-	uint64_t		delayed;
+	int64_t			delayed;
 	int			tries = 8;
 	int			error = 0;
 
@@ -359,6 +359,16 @@ xchk_fscount_aggregate_agcounts(
 	 * of the computation.
 	 */
 	delayed = percpu_counter_sum(&mp->m_delalloc_blks);
+	if (delayed < 0) {
+		if (fsc->frozen) {
+			xchk_set_incomplete(sc);
+			return -EFSCORRUPTED;
+		}
+
+		if (tries--)
+			goto retry;
+		return -EDEADLOCK;
+	}
 	fsc->fdblocks -= delayed;
 
 	trace_xchk_fscounters_calc(mp, fsc->icount, fsc->ifree, fsc->fdblocks,

