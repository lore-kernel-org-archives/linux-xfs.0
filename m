Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 193718BF0
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722301250; cv=none; b=Vo1mTUQ3e+AxZTl2MuuwnbBXHMRGrGIELmmT44PlOsbQsatEunT7YUfhmVDiBrfmZcq5R5pxHsAm0qtoO1tfOuWy+fEyKmYqR8l8fZmtSOR/fvD5Y/bhELPuNz1QKroZN6KitG/L131lIp2ZbIQEnLy1tdJ72ZEVwx0UQe5imUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722301250; c=relaxed/simple;
	bh=UoRIt5/jpVq/+5A0yezf+kh4w7v+F7c1Wg7aF+bCvvE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PxSxlbk9AECtyNYqlwlvUQ+3+Rb0LcDVyCgQoY3OW4lXS1PwEXpDv33bqrAS7fW/SxTAlAV4X6nG3rFOeOJhVZsTNyZXgt9oHShliDXcOjnwfb+FmnL1A+BsvxfelVC3K3mgiGX/6vzS5kL5ZCZXnov2QoWsoI5zOigpafU9Smk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M6sicKzf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M6sicKzf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D73AC32786;
	Tue, 30 Jul 2024 01:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722301249;
	bh=UoRIt5/jpVq/+5A0yezf+kh4w7v+F7c1Wg7aF+bCvvE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=M6sicKzfyK58PUArAL5IWePeuL3Pcub3wpcE5xzKv+KhF7nlx8IxIdllhYYPYcxun
	 /tcA7cE4lgzme/tHO3q209496G5oijPHQy+zgF66YDFUBbf8c/Jgb0xa0xhIP60eFy
	 oNlX+cI2YfBFs0PThHN1EEG1V2L6VXFOISDwiWGRMAWcYnujW5uDMfPREcn/KFdQQn
	 CTSb8nsdTRa/BxgoxN6hFdpMKfscCEJHvQfZhNgE0Rx0lpBIzUdhqOu1UM99wnw6H7
	 eFu7ATn2DcxlGpkiGIncYo6QmP/7AzKkzkbNLt4W8ReLVFBN5bP8A2bMHnpMaq0RH8
	 WixRoldf8mK8w==
Date: Mon, 29 Jul 2024 18:00:48 -0700
Subject: [PATCH 7/8] xfs_scrub: warn about difficult repairs to rt and quota
 metadata
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229846031.1345965.7945861310392407506.stgit@frogsfrogsfrogs>
In-Reply-To: <172229845921.1345965.6707043699978988202.stgit@frogsfrogsfrogs>
References: <172229845921.1345965.6707043699978988202.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/phase2.c |   37 +++++++++++++++++++++++++------------
 1 file changed, 25 insertions(+), 12 deletions(-)


diff --git a/scrub/phase2.c b/scrub/phase2.c
index 4c0d20a8e..3e88c969b 100644
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

