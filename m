Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7C06C77B7A
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Jun 2023 13:37:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237466AbjFFNhQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Jun 2023 09:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232547AbjFFNhP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Jun 2023 09:37:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A761E6B
        for <linux-xfs@vger.kernel.org>; Tue,  6 Jun 2023 06:37:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB86062B3F
        for <linux-xfs@vger.kernel.org>; Tue,  6 Jun 2023 13:37:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A54E9C433D2
        for <linux-xfs@vger.kernel.org>; Tue,  6 Jun 2023 13:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686058634;
        bh=3dbs3fkLdRFimRns2cK/jgPisG3K2bB+RwjQO8AZ3WY=;
        h=From:To:Subject:Date:From;
        b=nGn5DJ1cNt0acaywWGxgIaDNhGmGe1zJ1K6w52TnKxUKNb/5blAAT5PFrOedrkRWZ
         4UbLscHNoS7Uow9ulsXBMeSb3Re4oXcuIPe+NlhdRjSeMsGY6aEnYAbDVYc9qEjdXQ
         db39JaLnEyrJeCo4AlkIEq9wsWIse2lAk2nmGko3RkUGHwKb6/FzY1g91Q02ujn2mp
         UPeOSEJY+A8I1GX7zyHLrWfOMdFo4xp2bbS3FdJr+GI8KtE2b0FNs+GeAedRJxDno5
         L66e+p2Q4XmXWnxCWy+arxgpAKYHML2mqCa4zzyLYstqIjGOWCWaLtrUpVjpNo+kV7
         BN4RC3mUOMItA==
From:   cem@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: Comment out unreachable code within xchk_fscounters()
Date:   Tue,  6 Jun 2023 15:37:10 +0200
Message-Id: <20230606133710.674706-1-cem@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Carlos Maiolino <cem@kernel.org>

Comment the code out so kernel test robot stop complaining about it
every single test build.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 fs/xfs/scrub/fscounters.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
index e382a35e98d88..b1148bea7fabc 100644
--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -452,6 +452,7 @@ xchk_fscounters(
 	 */
 	return 0;
 
+#if 0
 	/*
 	 * If ifree exceeds icount by more than the minimum variance then
 	 * something's probably wrong with the counters.
@@ -489,4 +490,5 @@ xchk_fscounters(
 		xchk_set_corrupt(sc);
 
 	return 0;
+#endif
 }
-- 
2.30.2

