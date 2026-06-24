Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D53301A9FB0
	for <linux-xfs@vger.kernel.org>; Wed, 24 Jun 2026 18:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782325043; cv=none; b=DsExfi7HMsP+Si/49J8MRDKpg9tqncqMEnKpstqdaQOjoh7oNUq3g+Sv7Q911h6OcvD1Pp1qF9JyspvOCTZNaQ69ii1XrkyRF8lZkfKdlCFkf5SNs+o++f7JT+oW6i0V5bC4juiy6W3zZIwjewhH87ZWdjmaXWRY+vf7C5TDadc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782325043; c=relaxed/simple;
	bh=K4e0/qZtdmEa/fcndh1FdinpQKLDa5Nj/7UVEl6Ke28=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iywdSm02B3yu13dukb6/zT2lz1pkipOsfVs1oaLBZV7LzXhALFxSP2/CqPCIhgFWaw4huqD/OkekNUo4pz4meVw/Fwm9tLcSPZpTotdboi9V95puRJH2qklMSnFNui3Ts36P6aeSWdt5d/Tn5lntc1sAcb2vx6jDfidF9GZuSc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Tj7v2yrd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tj7v2yrd"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 5FE111F000E9;
	Wed, 24 Jun 2026 18:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782325042;
	bh=eGe526O8AdRi7mI67Fevluu06FVertDIG0WTKBEN28c=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=Tj7v2yrdwmQzYZJ5N1Uo+9Ku79p9C3/E12AHAFrupsWQ/9muUJJHJHQGevEJUalgN
	 sLKP2rSAvGcKyusToQnatyXM+AYop9B1nl34kzDBfv0/z2/yho9YywgUU4+WUvLup3
	 EHNztMw7+TGCNT/1gu/z22xGt0iZvZpy5J9yyM+dlOFdMGnmtQTE+RQ2z9puecT8eb
	 RXj7RjZnG3PZizA0pNABAmJ8DhpDl3osGiqIOeyBcuqIkqcbJ6f8E7ypspVf51VfEi
	 WkFuV+et6LAkMhqqdu9nr7/lF+aCDMApK3eb7CgxE5o9ha1B+66dr411EyKfkHOm86
	 jGANSJgG+oLvA==
Date: Wed, 24 Jun 2026 11:17:22 -0700
Subject: [PATCH 11/11] xfs_scrub: warn about difficult rtgroup repairs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <178232484642.915780.8781362549550547648.stgit@frogsfrogsfrogs>
In-Reply-To: <178232484383.915780.8675173410074139317.stgit@frogsfrogsfrogs>
References: <178232484383.915780.8675173410074139317.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Codex noticed that rtgroup metadata repairs can be difficult (e.g.
rtrmap) but we don't ever warn the user about that.  Scrub does that for
per-AG and fs metadata, so do that here too.

Cc: <linux-xfs@vger.kernel.org> # v6.13.0
Fixes: 241d915d69d4ae ("xfs_scrub: scrub realtime allocation group metadata")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/phase2.c |    8 ++++++++
 1 file changed, 8 insertions(+)


diff --git a/scrub/phase2.c b/scrub/phase2.c
index 8de77429f05d60..f382c1367be474 100644
--- a/scrub/phase2.c
+++ b/scrub/phase2.c
@@ -251,6 +251,7 @@ scan_rtgroup_metadata(
 	struct scrub_ctx	*ctx = (struct scrub_ctx *)wq->wq_ctx;
 	struct scan_ctl		*sctl = arg;
 	char			descr[DESCR_BUFSZ];
+	unsigned int		difficulty;
 	bool			defer_repairs;
 	int			ret;
 
@@ -281,7 +282,14 @@ scan_rtgroup_metadata(
 		sctl->aborted = true;
 		return;
 	}
+	if (defer_repairs)
+		goto defer;
 
+	/* Complain about metadata corruptions that might not be fixable. */
+	difficulty = repair_item_difficulty(&sri);
+	warn_repair_difficulties(ctx, difficulty, descr);
+
+defer:
 	/* Everything else gets fixed during phase 4. */
 	ret = defer_fs_repair(ctx, &sri);
 	if (ret) {

