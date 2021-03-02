Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 947EFC433E6
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Mar 2021 03:19:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4DF75601FF
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Mar 2021 03:19:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245669AbhCCDQA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Mar 2021 22:16:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:44962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2360791AbhCBW3q (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 2 Mar 2021 17:29:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DCD6864F3D;
        Tue,  2 Mar 2021 22:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614724134;
        bh=ckMVRH/f45FhQX6mPzo1G8MhObesegtytNu1Uoq1nDs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=jP0u7eD+j2kZdG5/Jfz00PLz2l2egSz+QOogVA9t6A7oYjP63YmRLlCY2z9kfEWq4
         6N9dxIgBP7jqazjGeFH7Qmq8YB+kKfM47CjsgaMGlQIzHKWvHBgkUzaDTILwXlpsSZ
         NpCvS2TNkj6j3EfrXVt2sS+XMf3Pk75fetMaf0UH3NM/UTbZj3lVtiSW94N0zatm7w
         a2Dch9D+CvUvUZw6PtGM/r9gdriLGYEaZ8NWc/oq/d7peBjSKyt23/85kDLAxCyYfO
         SkCh2ojj8tnY9HZwWyBrxp9cnMqLi/4IxkpalEUtcNGmt39+FMmx3TP4AEAh2hqkbQ
         kllwR9K0LUU3Q==
Subject: [PATCH 3/7] xfs: bail out of scrub immediately if scan incomplete
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 02 Mar 2021 14:28:53 -0800
Message-ID: <161472413358.3421582.1775111400550224556.stgit@magnolia>
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

If a scrubber cannot complete its check and signals an incomplete check,
we must bail out immediately without updating health status, trying a
repair, etc. because our scan is incomplete and we therefore do not know
much more.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/scrub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 8ebf35b115ce..47c68c72bcac 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -517,7 +517,7 @@ xfs_scrub_metadata(
 			goto out;
 		sc.flags |= XCHK_TRY_HARDER;
 		goto retry_op;
-	} else if (error)
+	} else if (error || (sm->sm_flags & XFS_SCRUB_OFLAG_INCOMPLETE))
 		goto out_teardown;
 
 	xchk_update_health(&sc);

