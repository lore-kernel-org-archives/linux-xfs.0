Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49E58EB64DD
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Jul 2023 22:28:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232323AbjG0W2a (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Jul 2023 18:28:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232226AbjG0W23 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jul 2023 18:28:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B98272696
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 15:28:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E88561F3E
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 22:28:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB730C433C9;
        Thu, 27 Jul 2023 22:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690496907;
        bh=NRPrlTagP2WiggK95Xfsg3KELMMLKQyS6fVtJnkf9fY=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=sXx6uSMpeTXCtSRAauc4wDlRnjSmXgMXfbfrD/IDj0qm1SOArX0mo4zclak+oMC3L
         V/EEawCzr1658oFE+qSTUrV8gZzyKxK1+0yltt/49BfP3JRtpb0zQhcUSwKJIk32g2
         y7AyN/0G1FaquLPfMaWYTa/4pC4AtLuQF/iS000NJttU1bbww5AKCl5Dr01T34OWfx
         5ECOP7PUXoflCzKcxoFT8O2XyurFnuK0BXVjI3n587VzxjIF8TUzaRKkDUIwSNdkLW
         34oaaUDdyQC5zc5NZzNBrk01Kt7R90mrcfg5VGIQ0DON8TIbwp5h7mBlbrVY24RG3v
         7L2UjKSucy0Og==
Date:   Thu, 27 Jul 2023 15:28:27 -0700
Subject: [PATCH 3/4] xfs: move the realtime summary file scrubber to a
 separate source file
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <169049624348.921804.7478075036548871809.stgit@frogsfrogsfrogs>
In-Reply-To: <169049624299.921804.11447029742535329810.stgit@frogsfrogsfrogs>
References: <169049624299.921804.11447029742535329810.stgit@frogsfrogsfrogs>
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
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/Makefile          |    7 +++++-
 fs/xfs/scrub/rtbitmap.c  |   37 --------------------------------
 fs/xfs/scrub/rtsummary.c |   54 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 60 insertions(+), 38 deletions(-)
 create mode 100644 fs/xfs/scrub/rtsummary.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 87f2756df3708..1537d66e5ab01 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -169,7 +169,12 @@ xfs-y				+= $(addprefix scrub/, \
 				   )
 
 xfs-$(CONFIG_XFS_ONLINE_SCRUB_STATS) += scrub/stats.o
-xfs-$(CONFIG_XFS_RT)		+= scrub/rtbitmap.o
+
+xfs-$(CONFIG_XFS_RT)		+= $(addprefix scrub/, \
+				   rtbitmap.o \
+				   rtsummary.o \
+				   )
+
 xfs-$(CONFIG_XFS_QUOTA)		+= scrub/quota.o
 
 # online repair
diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
index d42e5fc20ebd0..0bf56d92d70a2 100644
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
index 0000000000000..f96d0c7c5fe03
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

