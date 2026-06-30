Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 528A117B418
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2026 01:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782781361; cv=none; b=CB1gUgMUDTNbeoemsxyRae4W6fuxaAl+YW/jDQOzE53vnrxFEu0JwrdsgdGxd+A5iCOHM+LjgTa0Sv/gIlUEcV2PaSDZpXSqndZ3mq9PiY+R26Xl3t3DjoqqHAJxThi6vd9xVa9kfy/wn6zm5KR2jP9vOdVQqrvUWqFjODc19uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782781361; c=relaxed/simple;
	bh=LWgCnXRo+HJN0g9Sff2xggrxNYpxtDvTtg2lTy2494g=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DOs8JJ2AUzz2E46KahxmhN9iJhMMyvNVnnqWztLzA4Brgwb8+HPyVBTleg83HppeRsPqB4/16STOXoGc/08s40eOa1wx/7wJYPHxJqICigWzpyS0zBWytOOsKQciWykNUT4ow2k5wuUP3WLSCeQVZ1NTDsIycftLTNyqG1qRn0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nquhmAeL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nquhmAeL"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 07B291F000E9;
	Tue, 30 Jun 2026 01:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782781360;
	bh=IY48Nr2U0mnk5/4F4JypTlGVSgIlztv3dppgjadLTOs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=nquhmAeLAYCpLJyGT1LjQpuxJ/hE+ZoXVpYJiqB1nxTmAFrC5hbUe4Ul9yRMyWXu9
	 DPhRUFKnUKQTcq2URFtfrBywy1FyVWbm7c2Q8i4oY5zUXcM7/3F5KgSWRweBpaZLqj
	 ShJNZweeKOg9U7uQHI5s/Ok0D1hOV0mKSqJtC68apzf2CjL2y1LCFaCiP/S/wUxFDK
	 bzohWf4FyAeZZZ+df7hQ/ipcF0fpEiVWd8XizB4X44HyLTOi9mC/RMVvgLYnlVeFBU
	 mHPNQzPp3pVAJV1ciywrvvQREll4Hed3dguBmXOPNv0HSA9esn4aLcilWJvS/PHCFZ
	 Tu+prAhJSqCEQ==
Date: Mon, 29 Jun 2026 18:02:39 -0700
Subject: [PATCH 2/2] xfs_scrub: fix estimate of work items for phase 4
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <178278129582.858187.9031774884892983282.stgit@frogsfrogsfrogs>
In-Reply-To: <178278129539.858187.11646178692582297659.stgit@frogsfrogsfrogs>
References: <178278129539.858187.11646178692582297659.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Codex complains that the number of work items computed when estimating
the amount of work for phase 4 doesn't include the FSCOUNTERS and
QUOTACHECK items.  Add them back in.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/phase4.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)


diff --git a/scrub/phase4.c b/scrub/phase4.c
index 6bd16c23939eb4..95fb42f187fc77 100644
--- a/scrub/phase4.c
+++ b/scrub/phase4.c
@@ -254,7 +254,8 @@ phase4_func(
 	 * phase 7, but some of the cross-referencing requires fairly accurate
 	 * summary counters.  Check and try to repair them now to minimize the
 	 * chance that repairs of primary metadata fail due to secondary
-	 * metadata.  If repairs fails, we'll come back during phase 7.
+	 * metadata or ENOSPC on broken counters.  If repairs fails, we'll come
+	 * back during phase 7.
 	 */
 	scrub_item_init_fs(&sri);
 	scrub_item_schedule(&sri, XFS_SCRUB_TYPE_FSCOUNTERS);
@@ -269,6 +270,10 @@ phase4_func(
 	if (ret)
 		return ret;
 
+	/*
+	 * Try to fix the quota usage counts so that online repair doesn't
+	 * fail with EDQUOT (or worse shut down the fs) due to bad counts.
+	 */
 	if (fsgeom.sick & XFS_FSOP_GEOM_SICK_QUOTACHECK)
 		scrub_item_schedule(&sri, XFS_SCRUB_TYPE_QUOTACHECK);
 
@@ -293,10 +298,18 @@ phase4_estimate(
 {
 	unsigned long long	need_fixing;
 
-	/* Everything on the repair lis. */
+	/* Everything on the repair lists. */
 	need_fixing = action_list_length(ctx->fs_repair_list) +
 		      action_list_length(ctx->file_repair_list);
 
+	/*
+	 * fscounters and quotacheck are run directly by phase4_func
+	 * independent of the repair lists, so put that in the item count.
+	 * See phase4_func for why.
+	 */
+	if (need_fixing)
+		need_fixing += 2;
+
 	*items = need_fixing;
 	*nr_threads = scrub_nproc(ctx) + 1;
 	*rshift = 0;

