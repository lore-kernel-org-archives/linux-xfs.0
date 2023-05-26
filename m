Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEE45C77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 00:49:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234676AbjEZAtd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 20:49:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233106AbjEZAtc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:49:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1097D194
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:49:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A2009615B4
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:49:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D298C433D2;
        Fri, 26 May 2023 00:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685062170;
        bh=fwipppEMpcG0Vya9X0mEQIXP9HYPpmZaalKPhyM78/Q=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=ErPt4Rj4OAfrTxDptst48FNSXXTkkNvyq9vG/j7YSPMIlhfSMwn3m+H6VF+gWK8E+
         ODEkkPPVufViOuiYLY7gRNaI4ErLFwVDbrvRZPaZm54jFBvCGAz0KnS7SBayiE1PCa
         xSRyBkmyW8jN5cmmtoFnH2Y7P+kG7us7aYdO3JSDlGG1zbkSdsn2UM89sxgKKAzXPM
         hiDRPs2NrSUhBQYtqrha5kWzPTKt8/wxGD5ofkHXNlM5/THIydZ81LJcOW9e/pOpHa
         +6eJk07GrTxMhApN9tIMWW6g4KoTuXWhbw/iXNxWU60xCzsiw2JVUsWf3E5qLFLtp5
         XtzK7C043QnAQ==
Date:   Thu, 25 May 2023 17:49:29 -0700
Subject: [PATCH 3/4] xfs: move the realtime summary file scrubber to a
 separate source file
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506056907.3729869.5209842742484993717.stgit@frogsfrogsfrogs>
In-Reply-To: <168506056859.3729869.14765688109434520098.stgit@frogsfrogsfrogs>
References: <168506056859.3729869.14765688109434520098.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Move the realtime summary file checking code to a separate file in
preparation to actually implement it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Makefile          |    6 ++++-
 fs/xfs/scrub/rtbitmap.c  |   37 --------------------------------
 fs/xfs/scrub/rtsummary.c |   54 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 59 insertions(+), 38 deletions(-)
 create mode 100644 fs/xfs/scrub/rtsummary.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 7a5fa47a3093..bea3c0e500d1 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -168,7 +168,11 @@ xfs-y				+= $(addprefix scrub/, \
 				   xfile.o \
 				   )
 
-xfs-$(CONFIG_XFS_RT)		+= scrub/rtbitmap.o
+xfs-$(CONFIG_XFS_RT)		+= $(addprefix scrub/, \
+				   rtbitmap.o \
+				   rtsummary.o \
+				   )
+
 xfs-$(CONFIG_XFS_QUOTA)		+= scrub/quota.o
 
 # online repair
diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
index d42e5fc20ebd..0bf56d92d70a 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -124,43 +124,6 @@ xchk_rtbitmap(
 	return error;
 }
 
-/* Scrub the realtime summary. */
-int
-xchk_rtsummary(
-	struct xfs_scrub	*sc)
-{
-	struct xfs_inode	*rsumip = sc->mp->m_rsumip;
-	struct xfs_inode	*old_ip = sc->ip;
-	uint			old_ilock_flags = sc->ilock_flags;
-	int			error = 0;
-
-	/*
-	 * We ILOCK'd the rt bitmap ip in the setup routine, now lock the
-	 * rt summary ip in compliance with the rt inode locking rules.
-	 *
-	 * Since we switch sc->ip to rsumip we have to save the old ilock
-	 * flags so that we don't mix up the inode state that @sc tracks.
-	 */
-	sc->ip = rsumip;
-	sc->ilock_flags = 0;
-	xchk_ilock(sc, XFS_ILOCK_EXCL | XFS_ILOCK_RTSUM);
-
-	/* Invoke the fork scrubber. */
-	error = xchk_metadata_inode_forks(sc);
-	if (error || (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
-		goto out;
-
-	/* XXX: implement this some day */
-	xchk_set_incomplete(sc);
-out:
-	/* Switch back to the rtbitmap inode and lock flags. */
-	xchk_iunlock(sc, XFS_ILOCK_EXCL | XFS_ILOCK_RTSUM);
-	sc->ilock_flags = old_ilock_flags;
-	sc->ip = old_ip;
-	return error;
-}
-
-
 /* xref check that the extent is not free in the rtbitmap */
 void
 xchk_xref_is_used_rt_space(
diff --git a/fs/xfs/scrub/rtsummary.c b/fs/xfs/scrub/rtsummary.c
new file mode 100644
index 000000000000..f96d0c7c5fe0
--- /dev/null
+++ b/fs/xfs/scrub/rtsummary.c
@@ -0,0 +1,54 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2017-2023 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_btree.h"
+#include "xfs_inode.h"
+#include "xfs_log_format.h"
+#include "xfs_trans.h"
+#include "xfs_rtalloc.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+
+/* Scrub the realtime summary. */
+int
+xchk_rtsummary(
+	struct xfs_scrub	*sc)
+{
+	struct xfs_inode	*rsumip = sc->mp->m_rsumip;
+	struct xfs_inode	*old_ip = sc->ip;
+	uint			old_ilock_flags = sc->ilock_flags;
+	int			error = 0;
+
+	/*
+	 * We ILOCK'd the rt bitmap ip in the setup routine, now lock the
+	 * rt summary ip in compliance with the rt inode locking rules.
+	 *
+	 * Since we switch sc->ip to rsumip we have to save the old ilock
+	 * flags so that we don't mix up the inode state that @sc tracks.
+	 */
+	sc->ip = rsumip;
+	sc->ilock_flags = 0;
+	xchk_ilock(sc, XFS_ILOCK_EXCL | XFS_ILOCK_RTSUM);
+
+	/* Invoke the fork scrubber. */
+	error = xchk_metadata_inode_forks(sc);
+	if (error || (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
+		goto out;
+
+	/* XXX: implement this some day */
+	xchk_set_incomplete(sc);
+out:
+	/* Switch back to the rtbitmap inode and lock flags. */
+	xchk_iunlock(sc, XFS_ILOCK_EXCL | XFS_ILOCK_RTSUM);
+	sc->ilock_flags = old_ilock_flags;
+	sc->ip = old_ip;
+	return error;
+}

