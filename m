Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EBB42F87B
	for <linux-xfs@vger.kernel.org>; Wed, 24 Jun 2026 18:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782324935; cv=none; b=H/JSY1/zCFxntFsLyBMoaPqmQ4BjPWkeQsom6O4kAZ8vDz1A2yP4lg4acUn4m+TlRUXe6px0ylwdSgeYkvolSZK6eCSk+h1RDQJp/Zrvtwg3aPDf2ZN3RVKRJxE0GVTWIY06U1dbS55leFCSA6cgsFOR5Q47SpJrd79K0e5hI9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782324935; c=relaxed/simple;
	bh=tHb3VpJdiQdK70q6HdSxfF5B7eo98enbzen+wv2Xajo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VdhCGveqwc01KLUhhSr3cNdp6wx2oE/W/8DKgTPrXbyOoU8pj6yMLMjb3/dQpcKn3gqFPU1/gfrFBp+paX3uzAMvMUfDceAK+bQt6XJh03UQz9G6THe+DakxtmO5KF3MoQ2IGw0Z4P/G2SrtAuKMJljye7siaU7MKV3p1L8C9a4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kGg3eANr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kGg3eANr"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id AE2311F000E9;
	Wed, 24 Jun 2026 18:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782324933;
	bh=jcfmn1b8HiJg56pgwlPRQOv0VYnvJHtTviSNQ3gED40=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=kGg3eANr2xriNwIZVMxyX2AS0SK96lZGWVv7IE5pJ3HPUj1ZWLYINtVOkOzZ0XkR7
	 eKLpPwC65Gd/6k9RQReLivV9M4rLaCNJEGBRAOhYlvbjH0YOAjV4BhojDz3Sf51M7Q
	 0MLAwxWM2siDlblgtL1EOS8Lw2hLAu+X/Qbj13VoNO91zT87thtdDKv7TDhSCCd2ti
	 DTYTlakl0PKpFXhAlbaSqmma1xXoaM97FBExLOBcKm8CpHMM4cmuAtRGKTydcW8yfy
	 A+kXKLunqqLSJTZR6B2qV9nCCa+4PvzQ3+zLL3hy2HqW9cnOe2AvJHM6UPio1oHAsW
	 G+iLQkd0YRmLQ==
Date: Wed, 24 Jun 2026 11:15:33 -0700
Subject: [PATCH 04/11] xfs_scrub: track inode scan abort state with an enum
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <178232484512.915780.15261436223285476643.stgit@frogsfrogsfrogs>
In-Reply-To: <178232484383.915780.8675173410074139317.stgit@frogsfrogsfrogs>
References: <178232484383.915780.8675173410074139317.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Change this from a boolean to an enum so that we can handle scan
cancellations correctly in the next patch.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/inodes.c |   44 +++++++++++++++++++++++++++-----------------
 1 file changed, 27 insertions(+), 17 deletions(-)


diff --git a/scrub/inodes.c b/scrub/inodes.c
index ab5cf393327f1a..bf1cbdd6c7698b 100644
--- a/scrub/inodes.c
+++ b/scrub/inodes.c
@@ -357,13 +357,23 @@ bulkstat_for_inumbers(
 	bulkstat_single_step(ctx, inumbers, seen_mask, breq);
 }
 
+enum abort_state {
+	RUNNING = 0,
+	ABORTED,
+};
+
+static inline int abort_state_ret(enum abort_state s)
+{
+	return s == ABORTED ? -1 : 0;
+}
+
 /* BULKSTAT wrapper routines. */
 struct scan_inodes {
 	struct workqueue	wq_bulkstat;
 	scrub_inode_iter_fn	fn;
 	void			*arg;
 	unsigned int		nr_threads;
-	bool			aborted;
+	enum abort_state	aborted;
 };
 
 /*
@@ -530,7 +540,7 @@ scan_ag_bulkstat(
 			}
 			str_info(ctx, descr_render(&dsc_bulkstat),
 _("Changed too many times during scan; giving up."));
-			si->aborted = true;
+			si->aborted = ABORTED;
 			goto out;
 		}
 		case ECANCELED:
@@ -540,7 +550,7 @@ _("Changed too many times during scan; giving up."));
 			goto err;
 		}
 		if (scrub_excessive_errors(ctx)) {
-			si->aborted = true;
+			si->aborted = ABORTED;
 			goto out;
 		}
 		last_ino = scan_ino;
@@ -549,7 +559,7 @@ _("Changed too many times during scan; giving up."));
 err:
 	if (error) {
 		str_liberror(ctx, error, descr_render(&dsc_bulkstat));
-		si->aborted = true;
+		si->aborted = ABORTED;
 	}
 out:
 	free(ichunk);
@@ -594,7 +604,7 @@ scan_ag_inumbers(
 				cvt_ino_to_agino(&ctx->mnt, nextino),
 				cvt_ino_to_agino(&ctx->mnt,
 						ireq->inumbers[0].xi_startino));
-			si->aborted = true;
+			si->aborted = ABORTED;
 			break;
 		}
 		nextino = ireq->hdr.ino;
@@ -611,7 +621,7 @@ scan_ag_inumbers(
 			error = -workqueue_add(&si->wq_bulkstat,
 					scan_ag_bulkstat, agno, ichunk);
 			if (error) {
-				si->aborted = true;
+				si->aborted = ABORTED;
 				str_liberror(ctx, error,
 						_("queueing bulkstat work"));
 				goto out;
@@ -641,7 +651,7 @@ scan_ag_inumbers(
 err:
 	if (error) {
 		str_liberror(ctx, error, descr_render(&dsc));
-		si->aborted = true;
+		si->aborted = ABORTED;
 	}
 out:
 	if (ichunk)
@@ -687,14 +697,14 @@ scrub_scan_all_inodes(
 			si.nr_threads);
 	if (ret) {
 		str_liberror(ctx, ret, _("creating inumbers workqueue"));
-		si.aborted = true;
+		si.aborted = ABORTED;
 		goto kill_bulkstat;
 	}
 
 	for (agno = 0; agno < ctx->mnt.fsgeom.agcount; agno++) {
 		ret = -workqueue_add(&wq_inumbers, scan_ag_inumbers, agno, &si);
 		if (ret) {
-			si.aborted = true;
+			si.aborted = ABORTED;
 			str_liberror(ctx, ret, _("queueing inumbers work"));
 			break;
 		}
@@ -702,7 +712,7 @@ scrub_scan_all_inodes(
 
 	ret = -workqueue_terminate(&wq_inumbers);
 	if (ret) {
-		si.aborted = true;
+		si.aborted = ABORTED;
 		str_liberror(ctx, ret, _("finishing inumbers work"));
 	}
 	workqueue_destroy(&wq_inumbers);
@@ -710,12 +720,12 @@ scrub_scan_all_inodes(
 kill_bulkstat:
 	ret = -workqueue_terminate(&si.wq_bulkstat);
 	if (ret) {
-		si.aborted = true;
+		si.aborted = ABORTED;
 		str_liberror(ctx, ret, _("finishing bulkstat work"));
 	}
 	workqueue_destroy(&si.wq_bulkstat);
 
-	return si.aborted ? -1 : 0;
+	return abort_state_ret(si.aborted);
 }
 
 struct user_bulkstat {
@@ -758,7 +768,7 @@ scan_user_files(
 			goto err;
 		}
 		if (scrub_excessive_errors(ctx)) {
-			si->aborted = true;
+			si->aborted = ABORTED;
 			goto out;
 		}
 	}
@@ -766,7 +776,7 @@ scan_user_files(
 err:
 	if (error) {
 		str_liberror(ctx, error, descr_render(&dsc_bulkstat));
-		si->aborted = true;
+		si->aborted = ABORTED;
 	}
 out:
 	free(ureq);
@@ -824,7 +834,7 @@ scan_user_bulkstat(
 err_ureq:
 	free(ureq);
 err:
-	si->aborted = true;
+	si->aborted = ABORTED;
 	str_liberror(ctx, ret, what);
 	return 0;
 }
@@ -861,12 +871,12 @@ scrub_scan_user_files(
 
 	ret = -workqueue_terminate(&si.wq_bulkstat);
 	if (ret) {
-		si.aborted = true;
+		si.aborted = ABORTED;
 		str_liberror(ctx, ret, _("finishing bulkstat work"));
 	}
 	workqueue_destroy(&si.wq_bulkstat);
 
-	return si.aborted ? -1 : 0;
+	return abort_state_ret(si.aborted);
 }
 
 /* Open a file by handle, returning either the fd or -1 on error. */

