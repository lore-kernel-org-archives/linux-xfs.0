Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB842C127
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wlpv6+sn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E8D8C433C7;
	Sun, 31 Dec 2023 22:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704062937;
	bh=Afe50GMs9/MQc0iJ1IJai2Fzl91majUcxKGbTjeOjzs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Wlpv6+snzmus0kdfuC2drtJNTe7KiNfxtP9JzlHXcjjL0rhhhcLA9Rv5M5FmoEahH
	 OeFOM8rPJBOwnIZHFhCq5ku8mw5PngC11LbFvJs/5DyZeKMnVp+t9q/NIf1hRxS0tP
	 Hbw6MZDsGZkEfrHWn2YAYkngk+SVob5mtBni3begTlc6yGNjurHWD+N+48v4PvoUQl
	 cSQCCDxMEF7FSt4R1QR0bJ5ESIHqpiMj1aLG6h52GS2zfCj2hQKPPLCHyB+Bxdt67g
	 2LYxt4p0j5t47vT5SUDhKodfFvPBrjunuHAev08mzuQl7oN/FvBiEtSHqcxVJQ3Z5Y
	 rA8j2qwGubkTg==
Date: Sun, 31 Dec 2023 14:48:57 -0800
Subject: [PATCH 2/8] xfs_scrub: ignore phase 8 if the user disabled fstrim
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405001076.1798752.12614566262144331017.stgit@frogsfrogsfrogs>
In-Reply-To: <170405001045.1798752.4380751003208751209.stgit@frogsfrogsfrogs>
References: <170405001045.1798752.4380751003208751209.stgit@frogsfrogsfrogs>
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
index aa68c23c62e..23b2e03865b 100644
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

