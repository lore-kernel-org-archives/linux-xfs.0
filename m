Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67AF3C3DA7D
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:27:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235657AbiL3X1E (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:27:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235752AbiL3X0t (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:26:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5F9D13D4C
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:26:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 69F91B81DAD
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:26:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B408C433D2;
        Fri, 30 Dec 2022 23:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672442793;
        bh=oMhzYpXYu283wccJ5dHoT9HdF0ES7FI9GvMbSLk4F80=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=PEPf+untiXjUJhxGq2Yv8MXgqZM5UQWvbRD8srEGFozPEA/jEgWDLtTQdaZAMhtMP
         edvxAYoW/eHXtDyhvJ6RIGR00jvkXWF9uOkeI9Y+/Z71qhHoLxawsEig+I2pEaXvlz
         aTguLfEEw0J4iv8PXIruCVrlA41f2YZcZiIU39TXvVITWpZAhgH8J+C3WM+XoWc890
         dEhjA2FfY2X1OQSHAXWUvVTn3MdSRFayLkfYIE1VJezLbNup0bo3VTyW0q1Kq9D1LN
         MES+VLRovG52Vv1qpPvfgJEBLGbytdEvYsrr1lNWh1guixz58PJMZYhfH3BYf/zxFZ
         RwyTnb0k7ZTvA==
Subject: [PATCH 3/4] xfs: move the realtime summary file scrubber to a
 separate source file
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:12:39 -0800
Message-ID: <167243835920.692714.3235206721802974207.stgit@magnolia>
In-Reply-To: <167243835873.692714.18058284706535171995.stgit@magnolia>
References: <167243835873.692714.18058284706535171995.stgit@magnolia>
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
index 90cbba7dc550..e82d937a4513 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -166,7 +166,11 @@ xfs-y				+= $(addprefix scrub/, \
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
index c58c86fa1b03..0ac7e7c2fbf9 100644
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
index 000000000000..e12554e7f6f9
--- /dev/null
+++ b/fs/xfs/scrub/rtsummary.c
@@ -0,0 +1,54 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2017-2022 Oracle.  All Rights Reserved.
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

