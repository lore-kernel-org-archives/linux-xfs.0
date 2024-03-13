Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0773312E4E
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 02:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710296034; cv=none; b=FvJd5912RDcguLtYlwEsgN0HlMqGoLSc12N5USGc7T1qCCmUny5WrbKycYEywrXoM41mYLiZXZuc8TdWqIB4FVAzRKaAHAnhS47qZ398HQEITqRE48i3OuXcKOspnJObgI3EsiP0j8dOUPRnFXop75d3fBMuiiw/RYKdvhu0j6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710296034; c=relaxed/simple;
	bh=0rprHEFYdoqkhxGu1SYntRrga80jHJVbO26xs8AjeOI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Fvqz6qg8ybhdaVxj+qVFR3StGA+ofWdymc4h0M0g/xCVTMo2dpRne9Bn4Okks7hvvW79O5MC6v9YfPtH3AWbT3GoOTIAEKYbq2wd1y6gBCdjx1vV9MG1dcWgYoKFClx4EL3DmdlMtH0kpxAVpyDQcNunS3BonLvn727dVBqibso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UD3RLfFJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UD3RLfFJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5ECEC433F1;
	Wed, 13 Mar 2024 02:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710296033;
	bh=0rprHEFYdoqkhxGu1SYntRrga80jHJVbO26xs8AjeOI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=UD3RLfFJK4zlKVnWpJiLi0t3oGmLoiTy22roD/jSmrUtkXfIIvOHTyycIFY9mBpGq
	 UHNfdwWViqzE5P7lM9Dz/wcWpCuzLBTlmka5JwN/3ZTcJK2K2WgEmfqT3NHgSscOhB
	 tjEFTosfu+g51twEwuW0s/hRrhzHK4ryfcTtJPjkx0sNpJ4cJomkhOS0RGnIe7H/JQ
	 6zI4SF4ZUISrOHoSzGx1cVOgCMBBze5fVL0Qxntalo4EAUTKlOL6pwoWFQ+/ZDrjGW
	 jiNc8ScgckX4xVPUHJyOzPfjw5nV1Ieykp08tgSMGLxXCnfCP8djp00+/mz3+rhF1i
	 LWsXDK2AYppmA==
Date: Tue, 12 Mar 2024 19:13:53 -0700
Subject: [PATCH 3/3] xfs_scrub: scan whole-fs metadata files in parallel
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171029433992.2065570.7930588015670807806.stgit@frogsfrogsfrogs>
In-Reply-To: <171029433946.2065570.16411233810474878821.stgit@frogsfrogsfrogs>
References: <171029433946.2065570.16411233810474878821.stgit@frogsfrogsfrogs>
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

The realtime bitmap and the three quota files are completely independent
of each other, which means that we ought to be able to scan them in
parallel.  Rework the phase2 code so that we can do this.  Note,
however, that the realtime summary file summarizes the contents of the
realtime bitmap, so we must coordinate the workqueue threads.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/phase2.c |  135 +++++++++++++++++++++++++++++++++++++++++++-------------
 scrub/scrub.c  |    7 ++-
 scrub/scrub.h  |    3 +
 3 files changed, 110 insertions(+), 35 deletions(-)


diff --git a/scrub/phase2.c b/scrub/phase2.c
index 6b88384171f8..80c77b2876ff 100644
--- a/scrub/phase2.c
+++ b/scrub/phase2.c
@@ -10,6 +10,8 @@
 #include "list.h"
 #include "libfrog/paths.h"
 #include "libfrog/workqueue.h"
+#include "libfrog/fsgeom.h"
+#include "libfrog/scrub.h"
 #include "xfs_scrub.h"
 #include "common.h"
 #include "scrub.h"
@@ -17,6 +19,18 @@
 
 /* Phase 2: Check internal metadata. */
 
+struct scan_ctl {
+	/*
+	 * Control mechanism to signal that the rt bitmap file scan is done and
+	 * wake up any waiters.
+	 */
+	pthread_cond_t		rbm_wait;
+	pthread_mutex_t		rbm_waitlock;
+	bool			rbm_done;
+
+	bool			aborted;
+};
+
 /* Scrub each AG's metadata btrees. */
 static void
 scan_ag_metadata(
@@ -25,7 +39,7 @@ scan_ag_metadata(
 	void				*arg)
 {
 	struct scrub_ctx		*ctx = (struct scrub_ctx *)wq->wq_ctx;
-	bool				*aborted = arg;
+	struct scan_ctl			*sctl = arg;
 	struct action_list		alist;
 	struct action_list		immediate_alist;
 	unsigned long long		broken_primaries;
@@ -33,7 +47,7 @@ scan_ag_metadata(
 	char				descr[DESCR_BUFSZ];
 	int				ret;
 
-	if (*aborted)
+	if (sctl->aborted)
 		return;
 
 	action_list_init(&alist);
@@ -89,32 +103,40 @@ _("Filesystem might not be repairable."));
 	action_list_defer(ctx, agno, &alist);
 	return;
 err:
-	*aborted = true;
+	sctl->aborted = true;
 }
 
-/* Scrub whole-FS metadata btrees. */
+/* Scan whole-fs metadata. */
 static void
 scan_fs_metadata(
-	struct workqueue		*wq,
-	xfs_agnumber_t			agno,
-	void				*arg)
+	struct workqueue	*wq,
+	xfs_agnumber_t		type,
+	void			*arg)
 {
-	struct scrub_ctx		*ctx = (struct scrub_ctx *)wq->wq_ctx;
-	bool				*aborted = arg;
-	struct action_list		alist;
-	int				ret;
+	struct action_list	alist;
+	struct scrub_ctx	*ctx = (struct scrub_ctx *)wq->wq_ctx;
+	struct scan_ctl		*sctl = arg;
+	int			ret;
 
-	if (*aborted)
-		return;
+	if (sctl->aborted)
+		goto out;
 
 	action_list_init(&alist);
-	ret = scrub_fs_metadata(ctx, &alist);
+	ret = scrub_fs_metadata(ctx, type, &alist);
 	if (ret) {
-		*aborted = true;
-		return;
+		sctl->aborted = true;
+		goto out;
 	}
 
-	action_list_defer(ctx, agno, &alist);
+	action_list_defer(ctx, 0, &alist);
+
+out:
+	if (type == XFS_SCRUB_TYPE_RTBITMAP) {
+		pthread_mutex_lock(&sctl->rbm_waitlock);
+		sctl->rbm_done = true;
+		pthread_cond_broadcast(&sctl->rbm_wait);
+		pthread_mutex_unlock(&sctl->rbm_waitlock);
+	}
 }
 
 /* Scan all filesystem metadata. */
@@ -122,17 +144,25 @@ int
 phase2_func(
 	struct scrub_ctx	*ctx)
 {
-	struct action_list	alist;
 	struct workqueue	wq;
+	struct scan_ctl		sctl = {
+		.aborted	= false,
+		.rbm_done	= false,
+	};
+	struct action_list	alist;
+	const struct xfrog_scrub_descr *sc = xfrog_scrubbers;
 	xfs_agnumber_t		agno;
-	bool			aborted = false;
+	unsigned int		type;
 	int			ret, ret2;
 
+	pthread_mutex_init(&sctl.rbm_waitlock, NULL);
+	pthread_cond_init(&sctl.rbm_wait, NULL);
+
 	ret = -workqueue_create(&wq, (struct xfs_mount *)ctx,
 			scrub_nproc_workqueue(ctx));
 	if (ret) {
 		str_liberror(ctx, ret, _("creating scrub workqueue"));
-		return ret;
+		goto out_wait;
 	}
 
 	/*
@@ -143,29 +173,67 @@ phase2_func(
 	action_list_init(&alist);
 	ret = scrub_primary_super(ctx, &alist);
 	if (ret)
-		goto out;
+		goto out_wq;
 	ret = action_list_process_or_defer(ctx, 0, &alist);
 	if (ret)
-		goto out;
+		goto out_wq;
 
-	for (agno = 0; !aborted && agno < ctx->mnt.fsgeom.agcount; agno++) {
-		ret = -workqueue_add(&wq, scan_ag_metadata, agno, &aborted);
+	/* Scan each AG in parallel. */
+	for (agno = 0;
+	     agno < ctx->mnt.fsgeom.agcount && !sctl.aborted;
+	     agno++) {
+		ret = -workqueue_add(&wq, scan_ag_metadata, agno, &sctl);
 		if (ret) {
 			str_liberror(ctx, ret, _("queueing per-AG scrub work"));
-			goto out;
+			goto out_wq;
 		}
 	}
 
-	if (aborted)
-		goto out;
+	if (sctl.aborted)
+		goto out_wq;
 
-	ret = -workqueue_add(&wq, scan_fs_metadata, 0, &aborted);
+	/*
+	 * Scan all of the whole-fs metadata objects: realtime bitmap, realtime
+	 * summary, and the three quota files.  Each of the metadata files can
+	 * be scanned in parallel except for the realtime summary file, which
+	 * must run after the realtime bitmap has been scanned.
+	 */
+	for (type = 0; type < XFS_SCRUB_TYPE_NR; type++, sc++) {
+		if (sc->group != XFROG_SCRUB_GROUP_FS)
+			continue;
+		if (type == XFS_SCRUB_TYPE_RTSUM)
+			continue;
+
+		ret = -workqueue_add(&wq, scan_fs_metadata, type, &sctl);
+		if (ret) {
+			str_liberror(ctx, ret,
+	_("queueing whole-fs scrub work"));
+			goto out_wq;
+		}
+	}
+
+	if (sctl.aborted)
+		goto out_wq;
+
+	/*
+	 * Wait for the rt bitmap to finish scanning, then scan the rt summary
+	 * since the summary can be regenerated completely from the bitmap.
+	 */
+	pthread_mutex_lock(&sctl.rbm_waitlock);
+	while (!sctl.rbm_done)
+		pthread_cond_wait(&sctl.rbm_wait, &sctl.rbm_waitlock);
+	pthread_mutex_unlock(&sctl.rbm_waitlock);
+
+	if (sctl.aborted)
+		goto out_wq;
+
+	ret = -workqueue_add(&wq, scan_fs_metadata, XFS_SCRUB_TYPE_RTSUM, &sctl);
 	if (ret) {
-		str_liberror(ctx, ret, _("queueing per-FS scrub work"));
-		goto out;
+		str_liberror(ctx, ret, _("queueing rtsummary scrub work"));
+		goto out_wq;
 	}
 
-out:
+out_wq:
 	ret2 = -workqueue_terminate(&wq);
 	if (ret2) {
 		str_liberror(ctx, ret2, _("finishing scrub work"));
@@ -173,8 +241,11 @@ phase2_func(
 			ret = ret2;
 	}
 	workqueue_destroy(&wq);
+out_wait:
+	pthread_cond_destroy(&sctl.rbm_wait);
+	pthread_mutex_destroy(&sctl.rbm_waitlock);
 
-	if (!ret && aborted)
+	if (!ret && sctl.aborted)
 		ret = ECANCELED;
 	return ret;
 }
diff --git a/scrub/scrub.c b/scrub/scrub.c
index c7ee074fd36c..1c53260cc26c 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -400,13 +400,16 @@ scrub_ag_metadata(
 	return scrub_group(ctx, XFROG_SCRUB_GROUP_PERAG, agno, alist);
 }
 
-/* Scrub whole-FS metadata btrees. */
+/* Scrub whole-filesystem metadata. */
 int
 scrub_fs_metadata(
 	struct scrub_ctx		*ctx,
+	unsigned int			type,
 	struct action_list		*alist)
 {
-	return scrub_group(ctx, XFROG_SCRUB_GROUP_FS, 0, alist);
+	ASSERT(xfrog_scrubbers[type].group == XFROG_SCRUB_GROUP_FS);
+
+	return scrub_meta_type(ctx, type, 0, alist);
 }
 
 /* Scrub all FS summary metadata. */
diff --git a/scrub/scrub.h b/scrub/scrub.h
index 35d609f283a4..8a999da6a965 100644
--- a/scrub/scrub.h
+++ b/scrub/scrub.h
@@ -22,7 +22,8 @@ int scrub_ag_headers(struct scrub_ctx *ctx, xfs_agnumber_t agno,
 		struct action_list *alist);
 int scrub_ag_metadata(struct scrub_ctx *ctx, xfs_agnumber_t agno,
 		struct action_list *alist);
-int scrub_fs_metadata(struct scrub_ctx *ctx, struct action_list *alist);
+int scrub_fs_metadata(struct scrub_ctx *ctx, unsigned int scrub_type,
+		struct action_list *alist);
 int scrub_summary_metadata(struct scrub_ctx *ctx, struct action_list *alist);
 int scrub_fs_counters(struct scrub_ctx *ctx, struct action_list *alist);
 

