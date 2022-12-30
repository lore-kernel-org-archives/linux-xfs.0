Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 432A3C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:33:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231348AbiL3XdU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:33:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235506AbiL3XdT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:33:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D3C91DDF4
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:33:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9DE5A61B98
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:33:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DCC2C433EF;
        Fri, 30 Dec 2022 23:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672443198;
        bh=vHhY/AvgsiSm7GMkd8ElviT1IVbQVv1hwlHl/dyVfU8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=fSqItiH0ZR2Cpwe/Q0yJhMXM+YbKr5v9APw1c4UKXW3D5PNly8LGXfwN5Y+sNCMlA
         OHzSD5DO9V8XA/ki4iEEMLeh+uCRVcZgcMCwqt+9GnY6sLKc1jWVOOMRJ2sq3mDbyI
         5PLFKlmbnDRT7L1Up45OsA/r1KBDC+TfIfnEVxQFlGh16vXGtBd/bMkBapjNpNXiPz
         C9WbPIAI8O1zTLB7QhUzKB0yz4OCrhlwAthQ5Bs1SvSNNfPFlXx8iYmFlhTqCUBeAb
         CQ00GKQIJ8U4oTVP+MC7fSoNUG8z/z4qhBjA0OdNIeKn9B96R2ttPAOiyzbqOh43Gj
         X/Zkxbg6YGSQA==
Subject: [PATCH 1/4] xfs: speed up xfs_iwalk_adjust_start a little bit
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:13:03 -0800
Message-ID: <167243838349.695519.1875112266874805617.stgit@magnolia>
In-Reply-To: <167243838331.695519.18058154683213474280.stgit@magnolia>
References: <167243838331.695519.18058154683213474280.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Replace the open-coded loop that recomputes freecount with a single call
to a bit weight function.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_iwalk.c |   13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
index 594ccadb729f..54a262b33244 100644
--- a/fs/xfs/xfs_iwalk.c
+++ b/fs/xfs/xfs_iwalk.c
@@ -22,6 +22,7 @@
 #include "xfs_trans.h"
 #include "xfs_pwork.h"
 #include "xfs_ag.h"
+#include "xfs_bit.h"
 
 /*
  * Walking Inodes in the Filesystem
@@ -131,21 +132,11 @@ xfs_iwalk_adjust_start(
 	struct xfs_inobt_rec_incore	*irec)	/* btree record */
 {
 	int				idx;	/* index into inode chunk */
-	int				i;
 
 	idx = agino - irec->ir_startino;
 
-	/*
-	 * We got a right chunk with some left inodes allocated at it.  Grab
-	 * the chunk record.  Mark all the uninteresting inodes free because
-	 * they're before our start point.
-	 */
-	for (i = 0; i < idx; i++) {
-		if (XFS_INOBT_MASK(i) & ~irec->ir_free)
-			irec->ir_freecount++;
-	}
-
 	irec->ir_free |= xfs_inobt_maskn(0, idx);
+	irec->ir_freecount = hweight64(irec->ir_free);
 }
 
 /* Allocate memory for a walk. */

