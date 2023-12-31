Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B0CFC13B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oLsnZMN4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40A81C433C7;
	Sun, 31 Dec 2023 22:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704062359;
	bh=WreobNVSv7kVyKAkovU7uLutbDKOSJ/C5RerrEm1eUk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=oLsnZMN4/Ha2g+0PZXDWtmAU+aIlfRBCz64gJRW1m+m2gG7kJxb8TGanEGCgW7M6i
	 BDzkKD00ye+ztcmkbBvsKGjLcAYiJeO1NL+lUCrrmqEc7hu487m/3YcBD+Pc9KO7lz
	 xVDTE44nqNwWIck0sg/xn71lP0tq2ITn+pC+53RkZacOjRDMSyDtrzLBH2H7opPQck
	 i3CVbju9dTf0e8tztIzOR4cyndEIFLXpeJwUDbRZmNj8iXvg8p6YL+iJm9+kyhrrF8
	 RMtRbfCnYuaSKg34idUYBs0RnTv8cbOOdTttekwqsgbR0xpOKu5vDcFMtI4DGoyG1f
	 4uQXxZ/5ygTGg==
Date: Sun, 31 Dec 2023 14:39:18 -0800
Subject: [PATCH 4/8] xfs_scrub: split up the mustfix repairs and difficulty
 assessment functions
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404999088.1797544.11934780065637381281.stgit@frogsfrogsfrogs>
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

Currently, action_list_find_mustfix does two things -- it figures out
which repairs must be tried during phase 2 to enable the inode scan in
phase 3; and it figures out if xfs_scrub should warn about secondary and
primary metadata corruption that might make repair difficult.

Split these into separate functions to make each more coherent.  A long
time from now we'll need this to enable warnings about difficult rt
repairs, but for now this is merely a code cleanup.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase2.c |   15 +++++++--------
 scrub/repair.c |   38 +++++++++++++++++++++++++++-----------
 scrub/repair.h |   10 +++++++---
 3 files changed, 41 insertions(+), 22 deletions(-)


diff --git a/scrub/phase2.c b/scrub/phase2.c
index ec72bb5b71a..4c0d20a8e2b 100644
--- a/scrub/phase2.c
+++ b/scrub/phase2.c
@@ -42,9 +42,8 @@ scan_ag_metadata(
 	struct scan_ctl			*sctl = arg;
 	struct action_list		alist;
 	struct action_list		immediate_alist;
-	unsigned long long		broken_primaries;
-	unsigned long long		broken_secondaries;
 	char				descr[DESCR_BUFSZ];
+	unsigned int			difficulty;
 	int				ret;
 
 	if (sctl->aborted)
@@ -79,12 +78,12 @@ scan_ag_metadata(
 	 * the inobt from rmapbt data, but if the rmapbt is broken even
 	 * at this early phase then we are sunk.
 	 */
-	broken_secondaries = 0;
-	broken_primaries = 0;
-	action_list_find_mustfix(&alist, &immediate_alist,
-			&broken_primaries, &broken_secondaries);
-	if (broken_secondaries && !debug_tweak_on("XFS_SCRUB_FORCE_REPAIR")) {
-		if (broken_primaries)
+	difficulty = action_list_difficulty(&alist);
+	action_list_find_mustfix(&alist, &immediate_alist);
+
+	if ((difficulty & REPAIR_DIFFICULTY_SECONDARY) &&
+	    !debug_tweak_on("XFS_SCRUB_FORCE_REPAIR")) {
+		if (difficulty & REPAIR_DIFFICULTY_PRIMARY)
 			str_info(ctx, descr,
 _("Corrupt primary and secondary block mapping metadata."));
 		else
diff --git a/scrub/repair.c b/scrub/repair.c
index 50f168d24fe..8ee9102ab58 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -290,9 +290,7 @@ xfs_action_item_compare(
 void
 action_list_find_mustfix(
 	struct action_list		*alist,
-	struct action_list		*immediate_alist,
-	unsigned long long		*broken_primaries,
-	unsigned long long		*broken_secondaries)
+	struct action_list		*immediate_alist)
 {
 	struct action_item		*n;
 	struct action_item		*aitem;
@@ -301,25 +299,43 @@ action_list_find_mustfix(
 		if (!(aitem->flags & XFS_SCRUB_OFLAG_CORRUPT))
 			continue;
 		switch (aitem->type) {
-		case XFS_SCRUB_TYPE_RMAPBT:
-			(*broken_secondaries)++;
-			break;
 		case XFS_SCRUB_TYPE_FINOBT:
 		case XFS_SCRUB_TYPE_INOBT:
 			alist->nr--;
 			list_move_tail(&aitem->list, &immediate_alist->list);
 			immediate_alist->nr++;
-			fallthrough;
+			break;
+		}
+	}
+}
+
+/* Determine if primary or secondary metadata are inconsistent. */
+unsigned int
+action_list_difficulty(
+	const struct action_list	*alist)
+{
+	struct action_item		*aitem, *n;
+	unsigned int			ret = 0;
+
+	list_for_each_entry_safe(aitem, n, &alist->list, list) {
+		if (!(aitem->flags & XFS_SCRUB_OFLAG_CORRUPT))
+			continue;
+
+		switch (aitem->type) {
+		case XFS_SCRUB_TYPE_RMAPBT:
+			ret |= REPAIR_DIFFICULTY_SECONDARY;
+			break;
+		case XFS_SCRUB_TYPE_FINOBT:
+		case XFS_SCRUB_TYPE_INOBT:
 		case XFS_SCRUB_TYPE_BNOBT:
 		case XFS_SCRUB_TYPE_CNTBT:
 		case XFS_SCRUB_TYPE_REFCNTBT:
-			(*broken_primaries)++;
-			break;
-		default:
-			abort();
+			ret |= REPAIR_DIFFICULTY_PRIMARY;
 			break;
 		}
 	}
+
+	return ret;
 }
 
 /*
diff --git a/scrub/repair.h b/scrub/repair.h
index 6b6f64691a3..b61bd29c860 100644
--- a/scrub/repair.h
+++ b/scrub/repair.h
@@ -28,9 +28,13 @@ void action_list_discard(struct action_list *alist);
 void action_list_splice(struct action_list *dest, struct action_list *src);
 
 void action_list_find_mustfix(struct action_list *actions,
-		struct action_list *immediate_alist,
-		unsigned long long *broken_primaries,
-		unsigned long long *broken_secondaries);
+		struct action_list *immediate_alist);
+
+/* Primary metadata is corrupt */
+#define REPAIR_DIFFICULTY_PRIMARY	(1U << 0)
+/* Secondary metadata is corrupt */
+#define REPAIR_DIFFICULTY_SECONDARY	(1U << 1)
+unsigned int action_list_difficulty(const struct action_list *actions);
 
 /*
  * Only ask the kernel to repair this object if the kernel directly told us it

