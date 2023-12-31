Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2E3AC129
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dL/rm4hQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 382DAC433C8;
	Sun, 31 Dec 2023 22:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704062406;
	bh=7IYADfGJamKImTGjLXO7Huyg69J0aq2sfINXDk7E250=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dL/rm4hQxVnoEpydbFNReGk5qPsGgaBfUcHG2kRPQS4y1NN7Yo3BKbyOKPPYzVqjs
	 VFl1VOw3QERyN408jIB1VSOohHfob1d5OU8LRkqc36kPh0PZa7YLrL9vKAJ7RviU7Y
	 ohuIjco+UXkc/WgTSE2ckHoFnJRUQthg4Gc0eQFx7sIT2+MJ2gEpSb/tOqElIk4dYM
	 itRLwnoLVx7SLxOiD9gSQuyrlWnjSlWLwa1XfYCVoOgurJ42NUah0Nyc2PhVus1v4V
	 7QHWYmBxxXykG2AdiCJ2QQPb/GMFrW+V65/nsGbL1VGOQ3HprpR3chGLhHeim/16qw
	 Ib/qyVc7kXd3A==
Date: Sun, 31 Dec 2023 14:40:05 -0800
Subject: [PATCH 7/8] xfs_scrub: warn about difficult repairs to rt and quota
 metadata
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404999127.1797544.4265175049929354672.stgit@frogsfrogsfrogs>
In-Reply-To: <170404999029.1797544.5974682335470417611.stgit@frogsfrogsfrogs>
References: <170404999029.1797544.5974682335470417611.stgit@frogsfrogsfrogs>
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

Warn the user if there are problems with the rt or quota metadata that
might make repairs difficult.  For now there aren't any corruption
conditions that would trigger this, but we don't want to leave a gap.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase2.c |   37 +++++++++++++++++++++++++------------
 1 file changed, 25 insertions(+), 12 deletions(-)


diff --git a/scrub/phase2.c b/scrub/phase2.c
index 4c0d20a8e2b..3e88c969b43 100644
--- a/scrub/phase2.c
+++ b/scrub/phase2.c
@@ -31,6 +31,25 @@ struct scan_ctl {
 	bool			aborted;
 };
 
+/* Warn about the types of mutual inconsistencies that may make repairs hard. */
+static inline void
+warn_repair_difficulties(
+	struct scrub_ctx	*ctx,
+	unsigned int		difficulty,
+	const char		*descr)
+{
+	if (!(difficulty & REPAIR_DIFFICULTY_SECONDARY))
+		return;
+	if (debug_tweak_on("XFS_SCRUB_FORCE_REPAIR"))
+		return;
+
+	if (difficulty & REPAIR_DIFFICULTY_PRIMARY)
+		str_info(ctx, descr, _("Corrupt primary and secondary metadata."));
+	else
+		str_info(ctx, descr, _("Corrupt secondary metadata."));
+	str_info(ctx, descr, _("Filesystem might not be repairable."));
+}
+
 /* Scrub each AG's metadata btrees. */
 static void
 scan_ag_metadata(
@@ -80,18 +99,7 @@ scan_ag_metadata(
 	 */
 	difficulty = action_list_difficulty(&alist);
 	action_list_find_mustfix(&alist, &immediate_alist);
-
-	if ((difficulty & REPAIR_DIFFICULTY_SECONDARY) &&
-	    !debug_tweak_on("XFS_SCRUB_FORCE_REPAIR")) {
-		if (difficulty & REPAIR_DIFFICULTY_PRIMARY)
-			str_info(ctx, descr,
-_("Corrupt primary and secondary block mapping metadata."));
-		else
-			str_info(ctx, descr,
-_("Corrupt secondary block mapping metadata."));
-		str_info(ctx, descr,
-_("Filesystem might not be repairable."));
-	}
+	warn_repair_difficulties(ctx, difficulty, descr);
 
 	/* Repair (inode) btree damage. */
 	ret = action_list_process_or_defer(ctx, agno, &immediate_alist);
@@ -115,6 +123,7 @@ scan_fs_metadata(
 	struct action_list	alist;
 	struct scrub_ctx	*ctx = (struct scrub_ctx *)wq->wq_ctx;
 	struct scan_ctl		*sctl = arg;
+	unsigned int		difficulty;
 	int			ret;
 
 	if (sctl->aborted)
@@ -127,6 +136,10 @@ scan_fs_metadata(
 		goto out;
 	}
 
+	/* Complain about metadata corruptions that might not be fixable. */
+	difficulty = action_list_difficulty(&alist);
+	warn_repair_difficulties(ctx, difficulty, xfrog_scrubbers[type].descr);
+
 	action_list_defer(ctx, 0, &alist);
 
 out:

