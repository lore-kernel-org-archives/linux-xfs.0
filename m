Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D2B08F6E
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722302989; cv=none; b=W7TLtRK5GPdi4KZvELk/cuAhkJm/n1ZbcuGpStEQK6fvufoMQa5Cw8I9hI1DReYIqZceKGMtOsZElreLU51uVpnYW/kBiiRiXsVf4xANLb9zXnJh8uGbeIHsf53UWuN9q1kli+AzOeiB+f0IHs5fB/WhufNy6wRDTTUHE+EylpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722302989; c=relaxed/simple;
	bh=moPgZOvPmvwTH8GacKEGAXy6zuIXn/NuEEksUqmSgsA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aOaIlUbwVy5hOcg2dD69mcQT6DjMmLfVlYtqMy7Job2JoUYccWx9f1cwYAa/CMgr0hpnnV5p6Xq68lGuG/DOxGplwcapYk5i1h6XEe4ePzpNKTMNdx3RyOtl1vR5FHqhV1Wumkg73KLsGtSV9gT5C6D0d+vxGbGTsQfTmVaxR08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OOR+Ctb+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OOR+Ctb+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1187C32786;
	Tue, 30 Jul 2024 01:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722302988;
	bh=moPgZOvPmvwTH8GacKEGAXy6zuIXn/NuEEksUqmSgsA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OOR+Ctb+8J48FQrfb5l5GR0j5REGJmxooK5ADf1Tfwbg+0mc0WiyzDPqihfdYZv+t
	 Kp5zDPUMc8iMNgYoi8dnzwDSoGTNRSNMnuqw3OnLwvRSxTyC9fkddGCWrbS6hu10Rx
	 U+hddvmH6BvYrb2xEoLRt4ul9lqFp2MSKdKbukrfI7mvUiL/dd1XGweRGE122o9XWX
	 WPZQQykdtgluW4Kqc3G+lUsCGtH+dx1vpzXcbKXgqtOeFYJv9GPduPPwLahe/BWMIn
	 eozj2noBioW8YG/qU4FrmpHu7UKxNdLFyHEda7JVmh6RyC9fcym2bc2yd+MdvHYWNE
	 shfFDLMYm6hBw==
Date: Mon, 29 Jul 2024 18:29:48 -0700
Subject: [PATCH 4/5] xfs_scrub: detect and repair directory tree corruptions
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229852019.1353015.18181634285134412250.stgit@frogsfrogsfrogs>
In-Reply-To: <172229851966.1353015.1969020594980513131.stgit@frogsfrogsfrogs>
References: <172229851966.1353015.1969020594980513131.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/phase5.c |   56 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)


diff --git a/scrub/phase5.c b/scrub/phase5.c
index b37196277..6c8dee66e 100644
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
 

