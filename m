Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C4F6C4321A
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Mar 2021 03:19:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 264DF61477
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Mar 2021 03:19:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245664AbhCCDP7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Mar 2021 22:15:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:44964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2360790AbhCBW3q (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 2 Mar 2021 17:29:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F7ED64F2D;
        Tue,  2 Mar 2021 22:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614724139;
        bh=gxJFqmZJEJNZBQcGOetI+GdSq+2KUnqCpSVCCQVquWA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=FJd8cJRxTIka1oOHGwE2CyQVRRk/NJJbRdLviqgBD0LWOKnEphGE+Alkz21J9+2C1
         OWUF893sWuapsinSTGIxE1FdHhkmDELNUIBIZs2n8p5Hlo7eEjankWSm3cFsQ/QOmH
         mJvEx599c+tR80lEN2uNMRMN5IMyYdilt3DYLwhWVDGvbBBhk25Cr71bOVSX5ummbZ
         wZAJRm4qW8t2V1kZNAvkM/iR947DC8ePguIew/kQbVbgfO686L86hn0rc4nd/QZVQ3
         DMSaGprL5c8VGqvBF2qjVGSrfQQSWSnzqs8Yd3uAjcJL++MutjMhdHgNZYxi5y1vxi
         DqjVIvlok7CkQ==
Subject: [PATCH 4/7] xfs: mark a data structure sick if there are
 cross-referencing errors
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 02 Mar 2021 14:28:59 -0800
Message-ID: <161472413910.3421582.5713995044590901701.stgit@magnolia>
In-Reply-To: <161472411627.3421582.2040330025988154363.stgit@magnolia>
References: <161472411627.3421582.2040330025988154363.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If scrub observes cross-referencing errors while scanning a data
structure, mark the data structure sick.  There's /something/
inconsistent, even if we can't really tell what it is.

Fixes: 4860a05d2475 ("xfs: scrub/repair should update filesystem metadata health")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/health.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/health.c b/fs/xfs/scrub/health.c
index 83d27cdf579b..3de59b5c2ce6 100644
--- a/fs/xfs/scrub/health.c
+++ b/fs/xfs/scrub/health.c
@@ -133,7 +133,8 @@ xchk_update_health(
 	if (!sc->sick_mask)
 		return;
 
-	bad = (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT);
+	bad = (sc->sm->sm_flags & (XFS_SCRUB_OFLAG_CORRUPT |
+				   XFS_SCRUB_OFLAG_XCORRUPT));
 	switch (type_to_health_flag[sc->sm->sm_type].group) {
 	case XHG_AG:
 		pag = xfs_perag_get(sc->mp, sc->sm->sm_agno);

