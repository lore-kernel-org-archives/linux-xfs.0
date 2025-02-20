Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA1E320CCCA
	for <linux-xfs@vger.kernel.org>; Thu, 20 Feb 2025 21:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740087362; cv=none; b=DNX/yBmr84u++ErHdlGi0hC3loUQQ/H5GMphNUi25Y2vG4HhIoTiI6++0goz16TW3uzEqDoDV6oB6l1TsfhP3q/5hF9440WxtYaarYP3yKZdzL/di+rDaML8hvLvpUxsaLmgpCh0y4NZ5C6D2d4mJqrtKEGMiwhbI37VNfBsibw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740087362; c=relaxed/simple;
	bh=2+0l2vukGLgXo8309LOsI8SWNQ20RaWstAh8aDuOGmo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cWiFFJP77GKYCe3BP2uftbGutO8iVM1fBg6xiSZKhD9ykivLgC6YSnJgt6KlIA3lTRtxSi5Mek/x7jErLX+lNrK4Z8K7jQJyJrj8+zRhtmcd9nv6xSDorEJ9oYBAgoXknIYkvv4U5hHUDtn4pFN9AXi8e5Pj3vYFYUTDnih14sU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nvUqnJ69; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nvUqnJ69"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A923C4CED1;
	Thu, 20 Feb 2025 21:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740087361;
	bh=2+0l2vukGLgXo8309LOsI8SWNQ20RaWstAh8aDuOGmo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nvUqnJ69fnJDSUZZFcb30TQ5P4a+Xx0h68qPWL27sTWj84gBI21uCEBowISym9r9D
	 9293vF2agyQUNDmVxUsTls1mN2vjOFNimDmabXA3Gsb8LLW/W53JKHbb4TaaYFq/u7
	 Ha2wRmmmg6jmMi9vqvX26luDUqFWMcVd6OI+th4UZC8qyER2uxJG6Bgmq/zUqVAyyS
	 x1MyJiske6xkaP5UQ6cfMPOLECRLgbO3K/1HivcwiTbxIYFHXCP/2cozknnTSxsvnA
	 IYhCv4gSq1bv4MggWZffku3gmOeMVA7kCotMGt5uZDjH40PbzHqH6GykIHOIbSa/nE
	 TfVXAy17SeJ1g==
Date: Thu, 20 Feb 2025 13:36:00 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: [PATCH v1.1] libfrog: wrap handle construction code
Message-ID: <20250220213600.GS21808@frogsfrogsfrogs>
References: <173888086034.2738568.15125078367450007162.stgit@frogsfrogsfrogs>
 <173888086121.2738568.17449625667584946105.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173888086121.2738568.17449625667584946105.stgit@frogsfrogsfrogs>

From: Darrick J. Wong <djwong@kernel.org>

Clean up all the open-coded logic to construct a file handle from a
fshandle and some bulkstat/parent pointer information.  The new
functions are stashed in a private header file to avoid leaking the
details of xfs_handle construction in the public libhandle headers.

I tried moving the code to libhandle, but I don't entirely like the
result.  The libhandle functions pass around handles as arbitrary binary
blobs that come from and are sent to the kernel, meaning that the
interface is full of (void *, size_t) tuples.  Putting these new
functions in libhandle breaks that abstraction because now clients know
that they can deal with a struct xfs_handle.

We could fix that leak by changing it to a (void *, size_t) tuple, but
then we'd have to validate the size_t or returns -1 having set errno,
which then means that all the client code now has to have error handling
for a case that we're fairly sure can't be true.  This is overkill for
xfsprogs code that knows better, because we can trust ourselves to know
the exact layout of a handle.

So this nice compact code:

	memcpy(&handle.ha_fsid, file->fshandle, file->fshandle_len);
	handle.ha_fid.fid_len = sizeof(xfs_fid_t) -
				sizeof(handle.ha_fid.fid_len);

becomes:

	ret = handle_from_fshandle(&handle, file->fshandle,
			file->fshandle_len);
	if (ret) {
		perror("what?");
		return -1;
	}

Which is much more verbose code, and right now it exists to handle an
exceptional condition that is not possible.  If someone outside of
xfsprogs would like this sort of functionality in libhandle I'm all for
adding it, but with zero demand from external users, I prefer to keep
things simple.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
v1.1: explain why this isn't in libhandle for now
---
 libfrog/handle_priv.h |   55 +++++++++++++++++++++++++++++++++++++++++++++++++
 io/parent.c           |    9 +++-----
 libfrog/Makefile      |    1 +
 scrub/common.c        |    9 +++-----
 scrub/inodes.c        |   13 ++++--------
 scrub/phase5.c        |   12 ++++-------
 spaceman/health.c     |    9 +++-----
 7 files changed, 73 insertions(+), 35 deletions(-)
 create mode 100644 libfrog/handle_priv.h

diff --git a/libfrog/handle_priv.h b/libfrog/handle_priv.h
new file mode 100644
index 00000000000000..8c3634c40de1c8
--- /dev/null
+++ b/libfrog/handle_priv.h
@@ -0,0 +1,55 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2025 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __LIBFROG_HANDLE_PRIV_H__
+#define __LIBFROG_HANDLE_PRIV_H__
+
+/*
+ * Private helpers to construct an xfs_handle without publishing those details
+ * in the public libhandle header files.
+ */
+
+/*
+ * Fills out the fsid part of a handle.  This does not initialize the fid part
+ * of the handle; use either of the two functions below.
+ */
+static inline void
+handle_from_fshandle(
+	struct xfs_handle	*handle,
+	const void		*fshandle,
+	size_t			fshandle_len)
+{
+	ASSERT(fshandle_len == sizeof(xfs_fsid_t));
+
+	memcpy(&handle->ha_fsid, fshandle, sizeof(handle->ha_fsid));
+	handle->ha_fid.fid_len = sizeof(xfs_fid_t) -
+			sizeof(handle->ha_fid.fid_len);
+	handle->ha_fid.fid_pad = 0;
+	handle->ha_fid.fid_ino = 0;
+	handle->ha_fid.fid_gen = 0;
+}
+
+/* Fill out the fid part of a handle from raw components. */
+static inline void
+handle_from_inogen(
+	struct xfs_handle	*handle,
+	uint64_t		ino,
+	uint32_t		gen)
+{
+	handle->ha_fid.fid_ino = ino;
+	handle->ha_fid.fid_gen = gen;
+}
+
+/* Fill out the fid part of a handle. */
+static inline void
+handle_from_bulkstat(
+	struct xfs_handle		*handle,
+	const struct xfs_bulkstat	*bstat)
+{
+	handle->ha_fid.fid_ino = bstat->bs_ino;
+	handle->ha_fid.fid_gen = bstat->bs_gen;
+}
+
+#endif /* __LIBFROG_HANDLE_PRIV_H__ */
diff --git a/io/parent.c b/io/parent.c
index 8db93d98755289..3ba3aef48cb9be 100644
--- a/io/parent.c
+++ b/io/parent.c
@@ -11,6 +11,7 @@
 #include "handle.h"
 #include "init.h"
 #include "io.h"
+#include "libfrog/handle_priv.h"
 
 static cmdinfo_t parent_cmd;
 static char *mntpt;
@@ -205,12 +206,8 @@ parent_f(
 			return 0;
 		}
 
-		memcpy(&handle, hanp, sizeof(handle));
-		handle.ha_fid.fid_len = sizeof(xfs_fid_t) -
-				sizeof(handle.ha_fid.fid_len);
-		handle.ha_fid.fid_pad = 0;
-		handle.ha_fid.fid_ino = ino;
-		handle.ha_fid.fid_gen = gen;
+		handle_from_fshandle(&handle, hanp, hlen);
+		handle_from_inogen(&handle, ino, gen);
 	} else if (optind != argc) {
 		return command_usage(&parent_cmd);
 	}
diff --git a/libfrog/Makefile b/libfrog/Makefile
index 4da427789411a6..fc7e506d96bbad 100644
--- a/libfrog/Makefile
+++ b/libfrog/Makefile
@@ -53,6 +53,7 @@ fsgeom.h \
 fsproperties.h \
 fsprops.h \
 getparents.h \
+handle_priv.h \
 histogram.h \
 logging.h \
 paths.h \
diff --git a/scrub/common.c b/scrub/common.c
index f86546556f46dd..6eb3c026dc5ac9 100644
--- a/scrub/common.c
+++ b/scrub/common.c
@@ -10,6 +10,7 @@
 #include "platform_defs.h"
 #include "libfrog/paths.h"
 #include "libfrog/getparents.h"
+#include "libfrog/handle_priv.h"
 #include "xfs_scrub.h"
 #include "common.h"
 #include "progress.h"
@@ -414,12 +415,8 @@ scrub_render_ino_descr(
 	if (ctx->mnt.fsgeom.flags & XFS_FSOP_GEOM_FLAGS_PARENT) {
 		struct xfs_handle handle;
 
-		memcpy(&handle.ha_fsid, ctx->fshandle, sizeof(handle.ha_fsid));
-		handle.ha_fid.fid_len = sizeof(xfs_fid_t) -
-				sizeof(handle.ha_fid.fid_len);
-		handle.ha_fid.fid_pad = 0;
-		handle.ha_fid.fid_ino = ino;
-		handle.ha_fid.fid_gen = gen;
+		handle_from_fshandle(&handle, ctx->fshandle, ctx->fshandle_len);
+		handle_from_inogen(&handle, ino, gen);
 
 		ret = handle_to_path(&handle, sizeof(struct xfs_handle), 4096,
 				buf, buflen);
diff --git a/scrub/inodes.c b/scrub/inodes.c
index 3fe759e8f4867d..2b492a634ea3b2 100644
--- a/scrub/inodes.c
+++ b/scrub/inodes.c
@@ -19,6 +19,7 @@
 #include "descr.h"
 #include "libfrog/fsgeom.h"
 #include "libfrog/bulkstat.h"
+#include "libfrog/handle_priv.h"
 
 /*
  * Iterate a range of inodes.
@@ -209,7 +210,7 @@ scan_ag_bulkstat(
 	xfs_agnumber_t		agno,
 	void			*arg)
 {
-	struct xfs_handle	handle = { };
+	struct xfs_handle	handle;
 	struct scrub_ctx	*ctx = (struct scrub_ctx *)wq->wq_ctx;
 	struct scan_ichunk	*ichunk = arg;
 	struct xfs_inumbers_req	*ireq = ichunk_to_inumbers(ichunk);
@@ -225,12 +226,7 @@ scan_ag_bulkstat(
 	DEFINE_DESCR(dsc_inumbers, ctx, render_inumbers_from_agno);
 
 	descr_set(&dsc_inumbers, &agno);
-
-	memcpy(&handle.ha_fsid, ctx->fshandle, sizeof(handle.ha_fsid));
-	handle.ha_fid.fid_len = sizeof(xfs_fid_t) -
-			sizeof(handle.ha_fid.fid_len);
-	handle.ha_fid.fid_pad = 0;
-
+	handle_from_fshandle(&handle, ctx->fshandle, ctx->fshandle_len);
 retry:
 	bulkstat_for_inumbers(ctx, &dsc_inumbers, inumbers, breq);
 
@@ -244,8 +240,7 @@ scan_ag_bulkstat(
 			continue;
 
 		descr_set(&dsc_bulkstat, bs);
-		handle.ha_fid.fid_ino = scan_ino;
-		handle.ha_fid.fid_gen = bs->bs_gen;
+		handle_from_bulkstat(&handle, bs);
 		error = si->fn(ctx, &handle, bs, si->arg);
 		switch (error) {
 		case 0:
diff --git a/scrub/phase5.c b/scrub/phase5.c
index 22a22915dbc68d..6460d00f30f4bd 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -18,6 +18,7 @@
 #include "libfrog/bitmap.h"
 #include "libfrog/bulkstat.h"
 #include "libfrog/fakelibattr.h"
+#include "libfrog/handle_priv.h"
 #include "xfs_scrub.h"
 #include "common.h"
 #include "inodes.h"
@@ -474,9 +475,7 @@ retry_deferred_inode(
 	if (error)
 		return error;
 
-	handle->ha_fid.fid_ino = bstat.bs_ino;
-	handle->ha_fid.fid_gen = bstat.bs_gen;
-
+	handle_from_bulkstat(handle, &bstat);
 	return check_inode_names(ncs->ctx, handle, &bstat, ncs);
 }
 
@@ -487,16 +486,13 @@ retry_deferred_inode_range(
 	uint64_t		len,
 	void			*arg)
 {
-	struct xfs_handle	handle = { };
+	struct xfs_handle	handle;
 	struct ncheck_state	*ncs = arg;
 	struct scrub_ctx	*ctx = ncs->ctx;
 	uint64_t		i;
 	int			error;
 
-	memcpy(&handle.ha_fsid, ctx->fshandle, sizeof(handle.ha_fsid));
-	handle.ha_fid.fid_len = sizeof(xfs_fid_t) -
-			sizeof(handle.ha_fid.fid_len);
-	handle.ha_fid.fid_pad = 0;
+	handle_from_fshandle(&handle, ctx->fshandle, ctx->fshandle_len);
 
 	for (i = 0; i < len; i++) {
 		error = retry_deferred_inode(ncs, &handle, ino + i);
diff --git a/spaceman/health.c b/spaceman/health.c
index 4281589324cd44..0d2767df424f27 100644
--- a/spaceman/health.c
+++ b/spaceman/health.c
@@ -14,6 +14,7 @@
 #include "libfrog/bulkstat.h"
 #include "space.h"
 #include "libfrog/getparents.h"
+#include "libfrog/handle_priv.h"
 
 static cmdinfo_t health_cmd;
 static unsigned long long reported;
@@ -317,12 +318,8 @@ report_inode(
 	    (file->xfd.fsgeom.flags & XFS_FSOP_GEOM_FLAGS_PARENT)) {
 		struct xfs_handle handle;
 
-		memcpy(&handle.ha_fsid, file->fshandle, sizeof(handle.ha_fsid));
-		handle.ha_fid.fid_len = sizeof(xfs_fid_t) -
-				sizeof(handle.ha_fid.fid_len);
-		handle.ha_fid.fid_pad = 0;
-		handle.ha_fid.fid_ino = bs->bs_ino;
-		handle.ha_fid.fid_gen = bs->bs_gen;
+		handle_from_fshandle(&handle, file->fshandle, file->fshandle_len);
+		handle_from_bulkstat(&handle, bs);
 
 		ret = handle_to_path(&handle, sizeof(struct xfs_handle), 0,
 				descr, sizeof(descr) - 1);
