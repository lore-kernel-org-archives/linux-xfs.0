Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8556323C380
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738881135; cv=none; b=Oa/Xq6WbgDZzQlSufruF2yRQH7kgWbfcl3BmecslpWjZnkfLnQTxWwsRnCPnaInhM9WgoKYFUJNhKlIzsWGR8svTIWZDdRRrzaSEFWoJIEVghPp1WScVFHQRerZr//V647SM8zXsgTBfXSLDqjR8mrrdQg3kLzTTv11uukTkdmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738881135; c=relaxed/simple;
	bh=fegis/W4Nriq8N9/cca3cQEQdysBUteoOCMEz5HsjrU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KfCm2tzSXcpPIfd/NnJ62HlYdY7ZPsbq1VPCUk16wkecn1rpLTTEyYboTQ3HA9zDm6w/7KIVXnKgp/hWhgxV5m83/fm2ZbKTxe7Qqm8zXjiLt2anCCoEAnsQ74Z2M5qoMLw1duoZaX2+XQEb9Bm4X9SEN6jTbGk8Ca3sXgy1UlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nmtMXNV2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nmtMXNV2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CF97C4CEDD;
	Thu,  6 Feb 2025 22:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738881135;
	bh=fegis/W4Nriq8N9/cca3cQEQdysBUteoOCMEz5HsjrU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=nmtMXNV2gpFXFXHH841Y+PEu36OQaxSGR91c+1B80t+adeb7Mj6CoE7NKGJ/OjEqr
	 oDctG20JNmOOBHcpW3ttUhogWi1D4CpggvrH4wSSMOpfS2SNkUWlmoYeXYR2eqQxCz
	 mKzjbA615f3xMrIvmUjamBD8aGknoe/w8eI7XyOpaRi8IJDFYu5fFsiCFEcKvqIY1G
	 gPnDsKxgqAHXdo4dDDg36IL3fHlj8zEzmwmoHPUBFhjlnfoOJk3DElWu3rTa3V05cC
	 SItK8pzKgDZbR1B5nTDioMpC2YmaesMjVNgWHKYKfzSYTPTMhaW9pW1dWpO4RzerAI
	 C/nsY1KG/gp4A==
Date: Thu, 06 Feb 2025 14:32:13 -0800
Subject: [PATCH 06/17] xfs_scrub: call bulkstat directly if we're only
 scanning user files
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888086151.2738568.86305255846191106.stgit@frogsfrogsfrogs>
In-Reply-To: <173888086034.2738568.15125078367450007162.stgit@frogsfrogsfrogs>
References: <173888086034.2738568.15125078367450007162.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Christoph observed xfs_scrub phase 5 consuming a lot of CPU time on a
filesystem with a very large number of rtgroups.  He traced this to
bulkstat_for_inumbers spending a lot of time trying to single-step
through inodes that were marked allocated in the inumbers record but
didn't show up in the bulkstat data.  These correspond to files in the
metadata directory tree that are not returned by the regular bulkstat.

This complex machinery isn't necessary for the inode walk that occur
during phase 5 because phase 5 wants to open user files and check the
dirent/xattr names associated with that file.  It's not needed for phase
6 because we're only using it to report data loss in unlinked files when
parent pointers aren't enabled.

Furthermore, we don't need to do this inumbers -> bulkstat dance because
phase 3 and 4 supposedly fixed any inode that was to corrupt to be
igettable and hence reported on by bulkstat.

Fix this by creating a simpler user file iterator that walks bulkstat
across the filesystem without using inumbers.  While we're at it, fix
the obviously incorrect comments in inodes.h.

Cc: <linux-xfs@vger.kernel.org> # v4.15.0
Fixes: 372d4ba99155b2 ("xfs_scrub: add inode iteration functions")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/inodes.c |  151 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 scrub/inodes.h |    6 ++
 scrub/phase5.c |    2 -
 scrub/phase6.c |    2 -
 4 files changed, 158 insertions(+), 3 deletions(-)


diff --git a/scrub/inodes.c b/scrub/inodes.c
index 2b492a634ea3b2..58969131628f8f 100644
--- a/scrub/inodes.c
+++ b/scrub/inodes.c
@@ -445,6 +445,157 @@ scrub_scan_all_inodes(
 	return si.aborted ? -1 : 0;
 }
 
+struct user_bulkstat {
+	struct scan_inodes	*si;
+
+	/* vla, must be last */
+	struct xfs_bulkstat_req	breq;
+};
+
+/* Iterate all the user files returned by a bulkstat. */
+static void
+scan_user_files(
+	struct workqueue	*wq,
+	xfs_agnumber_t		agno,
+	void			*arg)
+{
+	struct xfs_handle	handle;
+	struct scrub_ctx	*ctx = (struct scrub_ctx *)wq->wq_ctx;
+	struct user_bulkstat	*ureq = arg;
+	struct xfs_bulkstat	*bs = &ureq->breq.bulkstat[0];
+	struct scan_inodes	*si = ureq->si;
+	int			i;
+	int			error = 0;
+	DEFINE_DESCR(dsc_bulkstat, ctx, render_ino_from_bulkstat);
+
+	handle_from_fshandle(&handle, ctx->fshandle, ctx->fshandle_len);
+
+	for (i = 0; !si->aborted && i < ureq->breq.hdr.ocount; i++, bs++) {
+		descr_set(&dsc_bulkstat, bs);
+		handle_from_bulkstat(&handle, bs);
+		error = si->fn(ctx, &handle, bs, si->arg);
+		switch (error) {
+		case 0:
+			break;
+		case ESTALE:
+		case ECANCELED:
+			error = 0;
+			fallthrough;
+		default:
+			goto err;
+		}
+		if (scrub_excessive_errors(ctx)) {
+			si->aborted = true;
+			goto out;
+		}
+	}
+
+err:
+	if (error) {
+		str_liberror(ctx, error, descr_render(&dsc_bulkstat));
+		si->aborted = true;
+	}
+out:
+	free(ureq);
+}
+
+/*
+ * Run one step of the user files bulkstat scan and schedule background
+ * processing of the stat data returned.  Returns 1 to keep going, or 0 to
+ * stop.
+ */
+static int
+scan_user_bulkstat(
+	struct scrub_ctx	*ctx,
+	struct scan_inodes	*si,
+	uint64_t		*cursor)
+{
+	struct user_bulkstat	*ureq;
+	const char		*what = NULL;
+	int			ret;
+
+	ureq = calloc(1, sizeof(struct user_bulkstat) +
+			 XFS_BULKSTAT_REQ_SIZE(LIBFROG_BULKSTAT_CHUNKSIZE));
+	if (!ureq) {
+		ret = ENOMEM;
+		what = _("creating bulkstat work item");
+		goto err;
+	}
+	ureq->si = si;
+	ureq->breq.hdr.icount = LIBFROG_BULKSTAT_CHUNKSIZE;
+	ureq->breq.hdr.ino = *cursor;
+
+	ret = -xfrog_bulkstat(&ctx->mnt, &ureq->breq);
+	if (ret) {
+		what = _("user files bulkstat");
+		goto err_ureq;
+	}
+	if (ureq->breq.hdr.ocount == 0) {
+		*cursor = NULLFSINO;
+		free(ureq);
+		return 0;
+	}
+
+	*cursor = ureq->breq.hdr.ino;
+
+	/* scan_user_files frees ureq; do not access it */
+	ret = -workqueue_add(&si->wq_bulkstat, scan_user_files, 0, ureq);
+	if (ret) {
+		what = _("queueing bulkstat work");
+		goto err_ureq;
+	}
+	ureq = NULL;
+
+	return 1;
+
+err_ureq:
+	free(ureq);
+err:
+	si->aborted = true;
+	str_liberror(ctx, ret, what);
+	return 0;
+}
+
+/*
+ * Scan all the user files in a filesystem in inumber order.  On error, this
+ * function will log an error message and return -1.
+ */
+int
+scrub_scan_user_files(
+	struct scrub_ctx	*ctx,
+	scrub_inode_iter_fn	fn,
+	void			*arg)
+{
+	struct scan_inodes	si = {
+		.fn		= fn,
+		.arg		= arg,
+		.nr_threads	= scrub_nproc_workqueue(ctx),
+	};
+	uint64_t		ino = 0;
+	int			ret;
+
+	/* Queue up to four bulkstat result sets per thread. */
+	ret = -workqueue_create_bound(&si.wq_bulkstat, (struct xfs_mount *)ctx,
+			si.nr_threads, si.nr_threads * 4);
+	if (ret) {
+		str_liberror(ctx, ret, _("creating bulkstat workqueue"));
+		return -1;
+	}
+
+	while ((ret = scan_user_bulkstat(ctx, &si, &ino)) == 1) {
+		/* empty */
+	}
+
+	ret = -workqueue_terminate(&si.wq_bulkstat);
+	if (ret) {
+		si.aborted = true;
+		str_liberror(ctx, ret, _("finishing bulkstat work"));
+	}
+	workqueue_destroy(&si.wq_bulkstat);
+
+	return si.aborted ? -1 : 0;
+}
+
 /* Open a file by handle, returning either the fd or -1 on error. */
 int
 scrub_open_handle(
diff --git a/scrub/inodes.h b/scrub/inodes.h
index 7a0b275e575ead..99b78fa1f76515 100644
--- a/scrub/inodes.h
+++ b/scrub/inodes.h
@@ -7,7 +7,7 @@
 #define XFS_SCRUB_INODES_H_
 
 /*
- * Visit each space mapping of an inode fork.  Return 0 to continue iteration
+ * Callback for each inode in a filesystem.  Return 0 to continue iteration
  * or a positive error code to interrupt iteraton.  If ESTALE is returned,
  * iteration will be restarted from the beginning of the inode allocation
  * group.  Any other non zero value will stop iteration.  The special return
@@ -23,6 +23,10 @@ typedef int (*scrub_inode_iter_fn)(struct scrub_ctx *ctx,
 int scrub_scan_all_inodes(struct scrub_ctx *ctx, scrub_inode_iter_fn fn,
 		unsigned int flags, void *arg);
 
+/* Scan all user-created files in the filesystem. */
+int scrub_scan_user_files(struct scrub_ctx *ctx, scrub_inode_iter_fn fn,
+		void *arg);
+
 int scrub_open_handle(struct xfs_handle *handle);
 
 #endif /* XFS_SCRUB_INODES_H_ */
diff --git a/scrub/phase5.c b/scrub/phase5.c
index 6460d00f30f4bd..577dda8064c3a8 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -882,7 +882,7 @@ _("Filesystem has errors, skipping connectivity checks."));
 
 	pthread_mutex_init(&ncs.lock, NULL);
 
-	ret = scrub_scan_all_inodes(ctx, check_inode_names, 0, &ncs);
+	ret = scrub_scan_user_files(ctx, check_inode_names, &ncs);
 	if (ret)
 		goto out_lock;
 	if (ncs.aborted) {
diff --git a/scrub/phase6.c b/scrub/phase6.c
index 2695e645004bf1..9858b932f20de5 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -577,7 +577,7 @@ report_all_media_errors(
 		return ret;
 
 	/* Scan for unlinked files. */
-	return scrub_scan_all_inodes(ctx, report_inode_loss, 0, vs);
+	return scrub_scan_user_files(ctx, report_inode_loss, vs);
 }
 
 /* Schedule a read-verify of a (data block) extent. */

