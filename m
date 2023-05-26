Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDCF2C77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:51:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233533AbjEZBvm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:51:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbjEZBvm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:51:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76D4A189
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:51:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1DA6364C3E
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:51:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 779AFC433EF;
        Fri, 26 May 2023 01:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685065900;
        bh=O1HZRM1sF7vpjikCvNtQlHI5+noMrzUOouoYC1QnqRc=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=o+bPo+VjZoG3R1siGSrrMf/qqfic4I5SGh6et1djTVuxKN9EIqlRac2dwTelFXqVW
         z/hu2b0ODBwXiV3CjmfgdfDQCm18HijhjqsiT4rbho2P9dZ7wjpznKo9wWl6ZZQkcS
         YuCj1vZE2rU5DOn0bloRjFpPwJztjhNDdkMQhGgkc/V5kc4AIb2lWEvgPhjxjaeGyf
         /ITLJcmYKf5L/XzQ2Tv+BBYMde/x6IHfAm7IqWXy/uvoiPGh1Ply7JzvYQErBz5SSS
         RGwoDVbh9MHNamVYnmREA1XnXdVVKpCxxvuDeH9MhiAp0zQLp4W8960hkNuZtCb3LL
         kT04gO3MQRGCA==
Date:   Thu, 25 May 2023 18:51:40 -0700
Subject: [PATCH 4/7] xfs_scrub: don't close stdout when closing the progress
 bar
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506073520.3745433.11580917963734545850.stgit@frogsfrogsfrogs>
In-Reply-To: <168506073466.3745433.1072164718437572976.stgit@frogsfrogsfrogs>
References: <168506073466.3745433.1072164718437572976.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

When we're tearing down the progress bar file stream, check that it's
not an alias of stdout before closing it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/xfs_scrub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index 73f82ef0c8d..f07a1960e57 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -835,7 +835,7 @@ main(
 	if (ctx.runtime_errors)
 		ret |= SCRUB_RET_OPERROR;
 	phase_end(&all_pi, 0);
-	if (progress_fp)
+	if (progress_fp && fileno(progress_fp) != 1)
 		fclose(progress_fp);
 	unicrash_unload();
 

