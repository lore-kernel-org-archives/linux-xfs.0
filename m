Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 214BD8F4E
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 01:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719883299; cv=none; b=ePCsRvGXxxDYgF06nk3HHmmUc/8ITLXoISvGXVFLj5WkQbeLVQNfhCOjllGBhBryzO2e8+PQojyn7XW9xHiYT2ZSwYnQymlYWDw5WK5IErya7gDSq60TTpqYhRpb+m0FPEjaoikWD8pXkQm18/QN8y6eq5XeUPF+mSjW+o7N9AY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719883299; c=relaxed/simple;
	bh=GEWQc9LmccJ/ZKCqwV2bd7rpOLXXdioFC8pBNdHivJk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mhkVcAHomVrrIiANLOffIDuMRRlYyeBKjYobNAQzR8Sm5hpLRJXxSMtlZtye1wuY7zWqg4v7xWdkbcNKks9JJ334L5cexBUJ/9hZWuDLEiUgqo9IRWSBSDSOBy0FM/vH+fmCoE1HX6B7mnx7jz72uNS8ijhWrSdF/ece8r/htP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p7XG1/J9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p7XG1/J9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00CB6C116B1;
	Tue,  2 Jul 2024 01:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719883299;
	bh=GEWQc9LmccJ/ZKCqwV2bd7rpOLXXdioFC8pBNdHivJk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=p7XG1/J9+xNGEksmVVY0HOTV6nUxyb78mba+M2gRouh7h+3UT3nwmYtQiQ52VphHN
	 dKil8WMI5g1SspG9uZyhQOzAnrkgYmpKtEKtYjnvHsfZ9IxL+WBh48Z1a/r6pGi33P
	 gXhsNv/KdQPZuV7W6mJMKT3KosTPAvNYLS94K7bRvjnRvN64YWRpshDEBoXYgALknc
	 MQ92AKJWuepwVnH+9VVl0o3/6WOSsylgsV54iCairwjK4e+Q91ZZKRouuvIcmPKyKW
	 wr2AmSgdCQ8M52aqNmSv+XiRctl3KdjFPXcO5NG5Oq5LW6040IfTvTdPKfKhnuBK3R
	 JO7YKFem8uG1Q==
Date: Mon, 01 Jul 2024 18:21:38 -0700
Subject: [PATCH 4/5] xfs_scrub: detect and repair directory tree corruptions
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171988122757.2012320.11258096209141176786.stgit@frogsfrogsfrogs>
In-Reply-To: <171988122691.2012320.13207835630113271818.stgit@frogsfrogsfrogs>
References: <171988122691.2012320.13207835630113271818.stgit@frogsfrogsfrogs>
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

Now that we have online fsck for directory tree structure problems, we
need to find a place to call it.  The scanner requires that parent
pointers are enabled, that directory link counts are correct, and that
every directory entry has a corresponding parent pointer.  Therefore, we
can only run it after phase 4 fixes every file, and phase 5 resets the
link counts.

In other words, we call it as part of the phase 5 file scan that we do
to warn about weird looking file names.  This has the added benefit that
opening the directory by handle is less likely to fail if there are
loops in the directory structure.  For now, only plumb in enough to try
to fix directory tree problems right away; the next patch will make
phase 5 retry the dirloop scanner until the problems are fixed or we
stop making forward progress.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase5.c |   56 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)


diff --git a/scrub/phase5.c b/scrub/phase5.c
index b37196277554..6c8dee66e6e2 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -252,6 +252,47 @@ render_ino_from_handle(
 			bstat->bs_gen, NULL);
 }
 
+/*
+ * Check the directory structure for problems that could cause open_by_handle
+ * not to work.  Returns 0 for no problems; EADDRNOTAVAIL if the there are
+ * problems that would prevent name checking.
+ */
+static int
+check_dir_connection(
+	struct scrub_ctx		*ctx,
+	struct descr			*dsc,
+	const struct xfs_bulkstat	*bstat)
+{
+	struct scrub_item		sri = { };
+	int				error;
+
+	/* The dirtree scrubber only works when parent pointers are enabled */
+	if (!(ctx->mnt.fsgeom.flags & XFS_FSOP_GEOM_FLAGS_PARENT))
+		return 0;
+
+	scrub_item_init_file(&sri, bstat);
+	scrub_item_schedule(&sri, XFS_SCRUB_TYPE_DIRTREE);
+
+	error = scrub_item_check_file(ctx, &sri, -1);
+	if (error) {
+		str_liberror(ctx, error, _("checking directory loops"));
+		return error;
+	}
+
+	error = repair_file_corruption(ctx, &sri, -1);
+	if (error) {
+		str_liberror(ctx, error, _("repairing directory loops"));
+		return error;
+	}
+
+	/* No directory tree problems?  Clear this inode if it was deferred. */
+	if (repair_item_count_needsrepair(&sri) == 0)
+		return 0;
+
+	str_corrupt(ctx, descr_render(dsc), _("directory loop uncorrected!"));
+	return EADDRNOTAVAIL;
+}
+
 /*
  * Verify the connectivity of the directory tree.
  * We know that the kernel's open-by-handle function will try to reconnect
@@ -275,6 +316,20 @@ check_inode_names(
 	descr_set(&dsc, bstat);
 	background_sleep();
 
+	/*
+	 * Try to fix directory loops before we have problems opening files by
+	 * handle.
+	 */
+	if (S_ISDIR(bstat->bs_mode)) {
+		error = check_dir_connection(ctx, &dsc, bstat);
+		if (error == EADDRNOTAVAIL) {
+			error = 0;
+			goto out;
+		}
+		if (error)
+			goto err;
+	}
+
 	/* Warn about naming problems in xattrs. */
 	if (bstat->bs_xflags & FS_XFLAG_HASATTR) {
 		error = check_xattr_names(ctx, &dsc, handle, bstat);
@@ -315,6 +370,7 @@ check_inode_names(
 err:
 	if (error)
 		*aborted = true;
+out:
 	if (!error && *aborted)
 		error = ECANCELED;
 

