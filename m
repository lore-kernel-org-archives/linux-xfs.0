Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97AC0D268
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722301783; cv=none; b=NkGTyank6zOfhvG0Z70LQQWbrMmfBkwz7mO6iQKUwhnEbdcox5Yypp9fyyCoAFEMzCIFqeIBnYH2auIclnWLb2rJmJY0RaXEVBysgC/cpHPFHVc/GOcc0jElCk2ZpvZ0UiB8jOW3qlZzhiqtDjzS20gBWSssi63sU7mKixrYiW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722301783; c=relaxed/simple;
	bh=zAC+vqUJufFpa6yVoEPQ4AWn7sLyLMODGoeU2304eBg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PsYOnpiiSTPZbzhXVl5Hst2fhuH0Y6m4LsbaUoZboI14lacWhSJtKaRihHfui5eyRK94zDWCh3UXUfOsNjUWmQqKJB5IkRs34A5b5sQ5BT9hwfR8EaXBQliRwbE24jIUhe5kSMMUbmD9xmaNncQ/duOtxKCCXZfkyaUkVDGxTzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CiRwTxOh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CiRwTxOh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16B47C32786;
	Tue, 30 Jul 2024 01:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722301783;
	bh=zAC+vqUJufFpa6yVoEPQ4AWn7sLyLMODGoeU2304eBg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CiRwTxOhnQahBFvL8GP7zNPCbJ2OB45TQ3+pB7vLLVM+cSa7KALGALaZhJ6DjkVn9
	 SZYGJ8BtTSKIVGCjwGf4KMk1LOT/2yQI+u6tgZOoVowETNH5Zn3EYENeSbhHRXi0II
	 usCgazO2DYoDEHBQ+6zxVzCDwwD1onqUrHdO+2Ib10dzTBi2H4M93wOOFdrYJWVCNC
	 jVlJaB8ABE8irWAdkYP3ccwnRZJiZb3HMF64L6yAFNRQHGkZjEV461dU90Vot+pP9C
	 AIlGv8qCy9X2o2GUSD8uOfC2n91hZE6SMu6UwWFVGMDMIUsibAT9tju5Uv6BnwV+SD
	 JiLl3f0PEivJw==
Date: Mon, 29 Jul 2024 18:09:42 -0700
Subject: [PATCH 2/7] xfs_scrub: ignore phase 8 if the user disabled fstrim
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229848063.1349330.15343951073553604167.stgit@frogsfrogsfrogs>
In-Reply-To: <172229848026.1349330.12889405227098722037.stgit@frogsfrogsfrogs>
References: <172229848026.1349330.12889405227098722037.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/xfs_scrub.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)


diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index e49538ca1..edf58d07b 100644
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

