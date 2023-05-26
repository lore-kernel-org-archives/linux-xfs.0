Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20ACEC77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:42:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234215AbjEZBmG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:42:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234230AbjEZBmF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:42:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B241A18D
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:42:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 498AD61276
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:42:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8AFDC433D2;
        Fri, 26 May 2023 01:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685065323;
        bh=P4K2B1XWLjO2mEIx7SPbd7bsMxZ09Rd8lhB4fK0HkOE=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=jYQhdXWsdR8MeGzj9g4hLeHCrKmEM5CM8h9OOKzw+8LMH/96hVEsrwDTioW3dxPGt
         RXumH1zM1gefoxrIa7tJewKpjUjQXm8YHwaqTlJU+BJE1IdaGxl/8UCK7CepjlVxsK
         qMEYe69dmdBNuQliSQ9ReA7iRwPhj+fVEzscF5QWGAEfMb6ijuoz31bPsWh+asLdpV
         BRWaHD3REb9Gk2dwFQ9a7QZHPjJ0TOn5SFe0ppQ26KsLeHrYHBbGQTtIP+gpcgkCHP
         0u/99Ve42jbhJ57b5hUw4eYHnlTM2GPZktPHSxgBGmyy/jynxO5nFIZ1vFC/3euN52
         rvfIcDxXfTqQw==
Date:   Thu, 25 May 2023 18:42:03 -0700
Subject: [PATCH 6/7] xfs_scrub: require primary superblock repairs to complete
 before proceeding
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506071387.3742205.16375008015048188595.stgit@frogsfrogsfrogs>
In-Reply-To: <168506071314.3742205.8114181660121831202.stgit@frogsfrogsfrogs>
References: <168506071314.3742205.8114181660121831202.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Phase 2 of the xfs_scrub program calls the kernel to check the primary
superblock before scanning the rest of the filesystem.  Though doing so
is a no-op now (since the primary super must pass all checks as a
prerequisite for mounting), the goal of this code is to enable future
kernel code to intercept an xfs_scrub run before it actually does
anything.  If this some day involves fixing the primary superblock, it
seems reasonable to require that /all/ repairs complete successfully
before moving on to the rest of the filesystem.

Unfortunately, that's not what xfs_scrub does now -- primary super
repairs that fail are theoretically deferred to phase 4!  So make this
mandatory.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase2.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/scrub/phase2.c b/scrub/phase2.c
index 18fad65c6c6..d6618dac509 100644
--- a/scrub/phase2.c
+++ b/scrub/phase2.c
@@ -174,7 +174,8 @@ phase2_func(
 	ret = scrub_primary_super(ctx, &alist);
 	if (ret)
 		goto out_wq;
-	ret = action_list_process_or_defer(ctx, 0, &alist);
+	ret = action_list_process(ctx, -1, &alist,
+			XRM_FINAL_WARNING | XRM_NOPROGRESS);
 	if (ret)
 		goto out_wq;
 

