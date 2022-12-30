Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8BB9C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:25:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235752AbiLaAZa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:25:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230117AbiLaAZ3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:25:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AFADBE0E
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:25:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D8F8061D2D
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:25:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45F3DC433D2;
        Sat, 31 Dec 2022 00:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672446327;
        bh=utxjeNFy7rhL2WiHW7q/SCavJRYi0FthXPWv/9Pzy+o=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=KEt40TUwP8vOoEz0d7gHUHoglJzYTZ3FyttX0/cCO/kLO4Co8qRCh3vjZ2/p+hd2v
         o5Ri8JBY8XZZ7vDd5xgPE7rHb29wsS3uZvhH+EahAz1qZaxjgkEBbzBNTvuRTS3Fd1
         NuVMl5oPkwgtZqvFNt9QlTjLvygIWfPX9sc+Wb47+aZjvI2smW7W+OcYucHZ0NCfa5
         w7oDAXNQZTh7uhaSxBZRs51l6lrlTGfG8tdtwCoIDxI08hUM2QMfa5ObALoPXVGNY6
         GVJq7tGy4Puy2NFcJiMI/gDEomiaH18J+6SRZr1Y7Y3O13slfxSClKC1PFSVg1q+Y1
         JzPWadzVxQMVA==
Subject: [PATCH 5/6] xfs_scrub: require primary superblock repairs to complete
 before proceeding
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:10 -0800
Message-ID: <167243869090.714771.7317421889032363042.stgit@magnolia>
In-Reply-To: <167243869023.714771.3955258526251265287.stgit@magnolia>
References: <167243869023.714771.3955258526251265287.stgit@magnolia>
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
index 75c302af075..774f3a17e9e 100644
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
 

