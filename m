Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D95AE6FCB
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 01:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719882078; cv=none; b=sicWN8fyKUu+HAYGVhAXiItAvnBn/ExC/iKtyac0Nw3XOpbrtF1sWp6Pfy2bZmp3Wc/z50zWko+TQLIlQqljlO2wHnHoZLN4Xnj/axe1K7qTm8NiJlwVIGtnHktwDcIpGe2lyU4O88PccWUr0JgUXqUFKXxdgGebWYozwcFANvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719882078; c=relaxed/simple;
	bh=HA2KUZaGZn7GFSRg6DeoN0KrghPDL0zaGve03FwuEvw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nOhSKSoboWfWb41LPmqVrtSnq/v+ul03hNGQVVFeLK6eP/fzTDOlsW34ijfL55pzPV4UGi2DHrwFkEfMPVrj8lQHsLuaSJopgHeh2VJdjdFKdAcIldgEO7HmCXjBzFcYZU51dgcliK6556wdbf49wGVHV9JNojYpFZDOizUbFRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K9/zX6D1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K9/zX6D1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B575AC116B1;
	Tue,  2 Jul 2024 01:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719882078;
	bh=HA2KUZaGZn7GFSRg6DeoN0KrghPDL0zaGve03FwuEvw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=K9/zX6D1CRyX5TK2MdLPLCvbm42nigD/GC4QLtaUy/uJHuUf/Z9HgW7L//bV6+Hhn
	 CRR1ets7OphWRAcvlE7JxAKaA222d/d666Ka58oNEQ1dfksjRtonFZ7pUP2p8l8L33
	 f0sLuA1WqwrAg+KxVxckSIEezb1xoi9iQTd9xCHYV9EEgmR10HSEJNr3JbEeDJQuPO
	 3djw2QbR3wNYu0h5j3MfWkuge15giygYOaIaEwmywI63gwChueOe6AgKTDSRdjJC4G
	 BqNHY/K/87Uy+669ejPHCRY8c2KQtbGwo5jFOkCHyUMDTYSuYg8rNzpNhTuAWZQylx
	 /MX/ANV739k6g==
Date: Mon, 01 Jul 2024 18:01:18 -0700
Subject: [PATCH 2/8] xfs_scrub: ignore phase 8 if the user disabled fstrim
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171988118160.2007602.9433733356692574496.stgit@frogsfrogsfrogs>
In-Reply-To: <171988118118.2007602.12196117098152792537.stgit@frogsfrogsfrogs>
References: <171988118118.2007602.12196117098152792537.stgit@frogsfrogsfrogs>
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

If the user told us to skip trimming the filesystem, don't run the phase
at all.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/xfs_scrub.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)


diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index e49538ca1cdd..edf58d07bde2 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -249,6 +249,7 @@ struct phase_rusage {
 /* Operations for each phase. */
 #define DATASCAN_DUMMY_FN	((void *)1)
 #define REPAIR_DUMMY_FN		((void *)2)
+#define FSTRIM_DUMMY_FN		((void *)3)
 struct phase_ops {
 	char		*descr;
 	int		(*fn)(struct scrub_ctx *ctx);
@@ -429,6 +430,11 @@ run_scrub_phases(
 			.fn = phase7_func,
 			.must_run = true,
 		},
+		{
+			.descr = _("Trim filesystem storage."),
+			.fn = FSTRIM_DUMMY_FN,
+			.estimate_work = phase8_estimate,
+		},
 		{
 			NULL
 		},
@@ -449,6 +455,8 @@ run_scrub_phases(
 		/* Turn on certain phases if user said to. */
 		if (sp->fn == DATASCAN_DUMMY_FN && scrub_data) {
 			sp->fn = phase6_func;
+		} else if (sp->fn == FSTRIM_DUMMY_FN && want_fstrim) {
+			sp->fn = phase8_func;
 		} else if (sp->fn == REPAIR_DUMMY_FN &&
 			   ctx->mode == SCRUB_MODE_REPAIR) {
 			sp->descr = _("Repair filesystem.");
@@ -458,7 +466,8 @@ run_scrub_phases(
 
 		/* Skip certain phases unless they're turned on. */
 		if (sp->fn == REPAIR_DUMMY_FN ||
-		    sp->fn == DATASCAN_DUMMY_FN)
+		    sp->fn == DATASCAN_DUMMY_FN ||
+		    sp->fn == FSTRIM_DUMMY_FN)
 			continue;
 
 		/* Allow debug users to force a particular phase. */

