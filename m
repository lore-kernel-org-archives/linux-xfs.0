Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4399C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:32:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235664AbiLaAco (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:32:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235655AbiLaAco (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:32:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADE3D167CB
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:32:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 49B4E61C63
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:32:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A55B5C433D2;
        Sat, 31 Dec 2022 00:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672446762;
        bh=Xb5uQgHrWx6Iw1dyM5wsgQ5xO9+trsGJjL1onW86LO8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=oQ0dRXaRhMqFzLg3IldWtZCLk7vTR5ZzqLvgoSqSbI+p/OYTY4Nv3p6tToJAupO/N
         JI4x16XnRo/6aQuJKJzkLrwI44aaeD7kXoTjlVkYLtJRhkHxC+efrYO1G34TVw0iSp
         A7De6XB7AUL4uePKKKfmCDx4CiLcV9l2zpjTUmbsgq2XNzBqeJB2v/fcvt1XjW+IKK
         SGifSMCkDEYAAIyf+WlTiPXA5f/v8lPWcKBFv3FJG+27n6s5TIG/QQk0HRv7E+ib2r
         lYZ/q9IbEf5htN1GcKcjwGd1gVr97PbiiOu+pgx6IFlKu6TXvXfip17lAZq4c/8yTb
         o6dAzImIzNreA==
Subject: [PATCH 3/7] xfs_scrub: collapse trim_filesystem
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:27 -0800
Message-ID: <167243870790.716924.7761400432568399907.stgit@magnolia>
In-Reply-To: <167243870748.716924.8460607901853339412.stgit@magnolia>
References: <167243870748.716924.8460607901853339412.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Collapse this two-line helper into the main function since it's trivial.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase8.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)


diff --git a/scrub/phase8.c b/scrub/phase8.c
index e2d712990ab..80f86f9ecd9 100644
--- a/scrub/phase8.c
+++ b/scrub/phase8.c
@@ -21,15 +21,6 @@
 
 /* Phase 8: Trim filesystem. */
 
-/* Trim the unused areas of the filesystem if the caller asked us to. */
-static void
-trim_filesystem(
-	struct scrub_ctx	*ctx)
-{
-	fstrim(ctx);
-	progress_add(1);
-}
-
 /* Trim the filesystem, if desired. */
 int
 phase8_func(
@@ -47,7 +38,8 @@ phase8_func(
 		return 0;
 
 maybe_trim:
-	trim_filesystem(ctx);
+	fstrim(ctx);
+	progress_add(1);
 	return 0;
 }
 

