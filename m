Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F6B4392C2E;
	Mon, 28 Sep 2026 06:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790576214; cv=none; b=RbwvgqCCbA8Ww5foGUPuHpO/geGZ1aPVe5t3OHTWYN2PFYPNqMTKijyVHAU/Ks9Q7uXP0pOJ1NslGiEGICRpf5dGtIIDgN4pFfa800Iw/NrUsR8MBwnyyP/VHruwDrVzmpWNl2HTBj1IFIil+v3BrEHVpTcLz2KbQcT0nAwSdXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790576214; c=relaxed/simple;
	bh=TAet5L+W9UCqy3yygHAH3kPWCqE2rtYjplJ0om2zZpU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sVR+ZftQyeXb6sqbeCZvgeo8dBFLxmO15uNNzZaqg6U4APin/GtjRgNvghs3RnH8rerDaPgQP4KLuiY7G2SZDX6PFp1f8gWDOGc8eyt4YI53vZS06mLwJOoaXVzJiwTBxeBd0aJQL+JHS1TkHoQ50EQzaehh5G4jf9qqPCq7SGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dHmfc9ag; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dHmfc9ag"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 3816D1F000FF;
	Mon, 28 Sep 2026 06:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790576212;
	bh=PHrdmOZebvqMndoaMaRr13cRPxXpiSsRC5Nqaj5BKdQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=dHmfc9agRK0N7o9xz22oRocHNexU9cKRa8O9HBhNhiLWGg4Zpto3Or2DyM889gkSR
	 R2dsJl2BmkB+NTHnzaBJrGSKrR9uj2Jgeqw8lKr9YMmWUra+7T1+kmM6oAc38E80Nc
	 +TWgpjjTkQbe6P/j9B48W+skb/pH+0hhC2dEjiNkB36JyAToikRC1Gjn6gVKBD5Wp7
	 31YwlYCaqPCVVr9TJacS+Xglp15HHpXREDYEJhroGB2m/RUx+q8+NakYQdyMYIxO9B
	 lRV9EaKG2/KojA/6H0vR1wA/oW6HGv/gGLv3qQTQCrKXnzw1V0pMerjJCYJ+YVCFnc
	 O1GB0h32kSFjg==
Date: Sun, 27 Sep 2026 23:16:51 -0700
Subject: [PATCH 04/12] xfs: bail out of directory tree repairs on error
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179057612682.479634.10962408939364769676.stgit@frogsfrogsfrogs>
In-Reply-To: <179057612523.479634.11102922479483109602.stgit@frogsfrogsfrogs>
References: <179057612523.479634.11102922479483109602.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM complains that we ignore errors returned by
xrep_dirpath_retain_parent and can set the dotdot entry to random stack
garbage.  Fix that by passing errors all the way out.

Cc: <stable@vger.kernel.org> # v6.10
Fixes: 3f31406aef493b ("xfs: fix corruptions in the directory tree")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/dirtree_repair.c |   57 ++++++++++++++++++++++++++---------------
 1 file changed, 36 insertions(+), 21 deletions(-)


diff --git a/fs/xfs/scrub/dirtree_repair.c b/fs/xfs/scrub/dirtree_repair.c
index 5a5857ee71d82d..b856abb6bbe9e8 100644
--- a/fs/xfs/scrub/dirtree_repair.c
+++ b/fs/xfs/scrub/dirtree_repair.c
@@ -94,7 +94,7 @@ xrep_dirtree_delete_all_paths(
 }
 
 /* Since this is the surviving path, set the dotdot entry to this value. */
-STATIC void
+STATIC int
 xrep_dirpath_retain_parent(
 	struct xchk_dirtree		*dl,
 	struct xchk_dirpath		*path)
@@ -104,18 +104,20 @@ xrep_dirpath_retain_parent(
 
 	error = xfarray_load(dl->path_steps, path->first_step, &step);
 	if (error)
-		return;
+		return error;
 
 	dl->parent_ino = be64_to_cpu(step.pptr_rec.p_ino);
+	return 0;
 }
 
 /* Find the one surviving path so we know how to set dotdot. */
-STATIC void
+STATIC int
 xrep_dirtree_find_surviving_path(
 	struct xchk_dirtree		*dl,
 	struct xchk_dirtree_outcomes	*oc)
 {
 	struct xchk_dirpath		*path;
+	int				error;
 	bool				foundit = false;
 
 	xchk_dirtree_for_each_path(dl, path) {
@@ -124,7 +126,10 @@ xrep_dirtree_find_surviving_path(
 		case XCHK_DIRPATH_LOOP:
 		case XCHK_DIRPATH_OK:
 			if (!foundit) {
-				xrep_dirpath_retain_parent(dl, path);
+				error = xrep_dirpath_retain_parent(dl, path);
+				if (error)
+					return error;
+
 				foundit = true;
 				continue;
 			}
@@ -136,16 +141,19 @@ xrep_dirtree_find_surviving_path(
 	}
 
 	ASSERT(oc->suspect + oc->good == 1);
+
+	return 0;
 }
 
 /* Delete all paths except for the one good one. */
-STATIC void
+STATIC int
 xrep_dirtree_keep_one_good_path(
 	struct xchk_dirtree		*dl,
 	struct xchk_dirtree_outcomes	*oc)
 {
 	struct xchk_dirpath		*path;
 	bool				foundit = false;
+	int				error;
 
 	xchk_dirtree_for_each_path(dl, path) {
 		switch (path->outcome) {
@@ -157,7 +165,10 @@ xrep_dirtree_keep_one_good_path(
 			break;
 		case XCHK_DIRPATH_OK:
 			if (!foundit) {
-				xrep_dirpath_retain_parent(dl, path);
+				error = xrep_dirpath_retain_parent(dl, path);
+				if (error)
+					return error;
+
 				foundit = true;
 				continue;
 			}
@@ -172,23 +183,28 @@ xrep_dirtree_keep_one_good_path(
 
 	ASSERT(oc->suspect == 0);
 	ASSERT(oc->good < 2);
+	return 0;
 }
 
 /* Delete all paths except for one suspect one. */
-STATIC void
+STATIC int
 xrep_dirtree_keep_one_suspect_path(
 	struct xchk_dirtree		*dl,
 	struct xchk_dirtree_outcomes	*oc)
 {
 	struct xchk_dirpath		*path;
 	bool				foundit = false;
+	int				error = 0;
 
 	xchk_dirtree_for_each_path(dl, path) {
 		switch (path->outcome) {
 		case XCHK_DIRPATH_CORRUPT:
 		case XCHK_DIRPATH_LOOP:
 			if (!foundit) {
-				xrep_dirpath_retain_parent(dl, path);
+				error = xrep_dirpath_retain_parent(dl, path);
+				if (error)
+					return error;
+
 				foundit = true;
 				continue;
 			}
@@ -206,13 +222,14 @@ xrep_dirtree_keep_one_suspect_path(
 
 	ASSERT(oc->suspect == 1);
 	ASSERT(oc->good == 0);
+	return error;
 }
 
 /*
  * Figure out what to do with the paths we tried to find.  Returns -EDEADLOCK
  * if the scan results have become stale.
  */
-STATIC void
+STATIC int
 xrep_dirtree_decide_fate(
 	struct xchk_dirtree		*dl,
 	struct xchk_dirtree_outcomes	*oc)
@@ -222,36 +239,32 @@ xrep_dirtree_decide_fate(
 	/* Parentless directories should not have any paths at all. */
 	if (xchk_dirtree_parentless(dl)) {
 		xrep_dirtree_delete_all_paths(dl, oc);
-		return;
+		return 0;
 	}
 
 	/* One path is exactly the number of paths we want. */
-	if (oc->good + oc->suspect == 1) {
-		xrep_dirtree_find_surviving_path(dl, oc);
-		return;
-	}
+	if (oc->good + oc->suspect == 1)
+		return xrep_dirtree_find_surviving_path(dl, oc);
 
 	/* Zero paths means we should reattach the subdir to the orphanage. */
 	if (oc->good + oc->suspect == 0) {
 		if (dl->sc->orphanage)
 			oc->needs_adoption = true;
-		return;
+		return 0;
 	}
 
 	/*
 	 * Otherwise, this subdirectory has too many parents.  If there's at
 	 * least one good path, keep it and delete the others.
 	 */
-	if (oc->good > 0) {
-		xrep_dirtree_keep_one_good_path(dl, oc);
-		return;
-	}
+	if (oc->good > 0)
+		return xrep_dirtree_keep_one_good_path(dl, oc);
 
 	/*
 	 * There are no good paths and there are too many suspect paths.
 	 * Keep the first suspect path and delete the rest.
 	 */
-	xrep_dirtree_keep_one_suspect_path(dl, oc);
+	return xrep_dirtree_keep_one_suspect_path(dl, oc);
 }
 
 /*
@@ -824,7 +837,9 @@ xrep_dirtree(
 		 * to walk again.
 		 */
 		if (!dl->stale) {
-			xrep_dirtree_decide_fate(dl, &oc);
+			error = xrep_dirtree_decide_fate(dl, &oc);
+			if (error)
+				break;
 
 			trace_xrep_dirtree_decided_fate(dl, &oc);
 

