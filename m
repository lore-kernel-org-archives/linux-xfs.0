Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2087AC147
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KusABDnu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2CD8C433C8;
	Sun, 31 Dec 2023 22:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704062547;
	bh=G99nYKnKxgolGdbJcvfVjtSZBCLd2GfV8FhjfZhjWGk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=KusABDnuewOPGwIbfQkPqkhg/ZAebDpTssJYJZp98gEem5C3iQX3jw/JnmiTfpaju
	 qyL8fI6eL4yco0aSMjVikw15THzS7bP04fs2mXP0Qxx1HWa58mlPMqpj8Ha0F5F8IP
	 ygZZfqerZrclSusW0XCK/U+jAAwT23xJ3MkH/XueVxOqqFdCZGGeg87mOQGAAFYv/m
	 Dee+6CP6VZM0Q83bLJDtm9fdiN7RJsUZ5DfsPt0LZjCBIHro0QD67gG0unS7HfDnCa
	 Euyji7/0yLH9XgiIEEESS9AeAn+lo4Px76ZDg7g3yvfbwVeZRgRqFddDxoeRxlC5Ha
	 w0zukII4fGxcA==
Date: Sun, 31 Dec 2023 14:42:26 -0800
Subject: [PATCH 8/9] xfs_scrub: retry incomplete repairs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404999552.1797790.13157454061191356913.stgit@frogsfrogsfrogs>
In-Reply-To: <170404999439.1797790.8016278650267736019.stgit@frogsfrogsfrogs>
References: <170404999439.1797790.8016278650267736019.stgit@frogsfrogsfrogs>
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

If a repair says it didn't do anything on account of not being able to
complete a scan of the metadata, retry the repair a few times; if even
that doesn't work, we can delay it to phase 4.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/repair.c        |   15 ++++++++++++++-
 scrub/scrub.c         |    3 +--
 scrub/scrub_private.h |   10 ++++++++++
 3 files changed, 25 insertions(+), 3 deletions(-)


diff --git a/scrub/repair.c b/scrub/repair.c
index 9b4b5d01626..2b863bb4195 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -58,6 +58,7 @@ xfs_repair_metadata(
 	struct xfs_scrub_metadata	oldm;
 	DEFINE_DESCR(dsc, ctx, format_scrub_descr);
 	bool				repair_only;
+	unsigned int			tries = 0;
 	int				error;
 
 	/*
@@ -99,6 +100,7 @@ xfs_repair_metadata(
 		str_info(ctx, descr_render(&dsc),
 				_("Attempting optimization."));
 
+retry:
 	error = -xfrog_scrub_metadata(xfdp, &meta);
 	switch (error) {
 	case 0:
@@ -179,9 +181,20 @@ _("Read-only filesystem; cannot make changes."));
 		return CHECK_DONE;
 	}
 
+	/*
+	 * If the kernel says the repair was incomplete or that there was a
+	 * cross-referencing discrepancy but no obvious corruption, we'll try
+	 * the repair again, just in case the fs was busy.  Only retry so many
+	 * times.
+	 */
+	if (want_retry(&meta) && tries < 10) {
+		tries++;
+		goto retry;
+	}
+
 	if (repair_flags & XRM_FINAL_WARNING)
 		scrub_warn_incomplete_scrub(ctx, &dsc, &meta);
-	if (needs_repair(&meta)) {
+	if (needs_repair(&meta) || is_incomplete(&meta)) {
 		/*
 		 * Still broken; if we've been told not to complain then we
 		 * just requeue this and try again later.  Otherwise we
diff --git a/scrub/scrub.c b/scrub/scrub.c
index 5c14ed2092e..5fc549f9728 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -137,8 +137,7 @@ _("Filesystem is shut down, aborting."));
 	 * we'll try the scan again, just in case the fs was busy.
 	 * Only retry so many times.
 	 */
-	if (tries < 10 && (is_incomplete(meta) ||
-			   (xref_disagrees(meta) && !is_corrupt(meta)))) {
+	if (want_retry(meta) && tries < 10) {
 		tries++;
 		goto retry;
 	}
diff --git a/scrub/scrub_private.h b/scrub/scrub_private.h
index 08b9130cbc9..53372e1f322 100644
--- a/scrub/scrub_private.h
+++ b/scrub/scrub_private.h
@@ -49,6 +49,16 @@ static inline bool needs_repair(struct xfs_scrub_metadata *sm)
 	return is_corrupt(sm) || xref_disagrees(sm);
 }
 
+/*
+ * We want to retry an operation if the kernel says it couldn't complete the
+ * scan/repair; or if there were cross-referencing problems but the object was
+ * not obviously corrupt.
+ */
+static inline bool want_retry(struct xfs_scrub_metadata *sm)
+{
+	return is_incomplete(sm) || (xref_disagrees(sm) && !is_corrupt(sm));
+}
+
 void scrub_warn_incomplete_scrub(struct scrub_ctx *ctx, struct descr *dsc,
 		struct xfs_scrub_metadata *meta);
 

