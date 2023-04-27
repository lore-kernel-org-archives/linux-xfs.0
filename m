Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93BE6C77B61
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Apr 2023 19:02:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244429AbjD0TCz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Apr 2023 15:02:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244173AbjD0TCz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Apr 2023 15:02:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11FBE40FB
        for <linux-xfs@vger.kernel.org>; Thu, 27 Apr 2023 12:02:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A64960C02
        for <linux-xfs@vger.kernel.org>; Thu, 27 Apr 2023 19:02:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0628CC433D2;
        Thu, 27 Apr 2023 19:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682622154;
        bh=saEUbW23xZkewQWAu6FonfbqkHgytbYtDkZ2pd+Qm9g=;
        h=Date:From:To:Cc:Subject:From;
        b=eKjVbLHSpIEUux0Xt9ha5aB108CjsGENaZhxZ1TL421VkXiOIrzIlGv6sGP6cEwr4
         5WF1YmXUKsGZjsIBvdAJihbpC9BLhYqKoBS828k458aaaj0X3hVVRdp+3XzdhgwkVD
         ppvkc9u735LE+RSpp+1mqPYCWe+oFAv1Na/yHFzRHUIgVF0p9vBS72XTHlyIzG78Q7
         PYfiMkMKE/K1tp6HU3M1nhGZW1Rmsvr3C9fkv9F1rxUxZ7KlVVsJQ24o2C2bVD+BPx
         g99HcAHt8bLmaJkQWggKssLfzclaN1NKzOUuOgYQkD8vDRGrRMwUiYeoPgAQym3s32
         XsVZQH6ZDSChg==
Date:   Thu, 27 Apr 2023 12:02:33 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Carlos Maiolino <cem@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs_db: fix broken logic in error path
Message-ID: <20230427190233.GC59213@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

smatch complains proceeding into the if body if leaf is a null pointer:

check.c:3614 process_leaf_node_dir_v2_int() warn: variable dereferenced before check 'leaf' (see line 3518)

However, the logic here is misleading and broken -- what we're trying to
do is switch between the v4 and v5 variants of the directory check.
We're using @leaf3 being a null pointer (or not) to determine v4 vs. v5,
so the "!" part of the comparison is correct, but the variable used
(leaf) is not.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/check.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/db/check.c b/db/check.c
index 964756d0..fdf1f6a1 100644
--- a/db/check.c
+++ b/db/check.c
@@ -3452,7 +3452,7 @@ process_leaf_node_dir_v2_int(
 				 id->ino, dabno, stale,
 				 be16_to_cpu(leaf3->hdr.stale));
 		error++;
-	} else if (!leaf && stale != be16_to_cpu(leaf->hdr.stale)) {
+	} else if (!leaf3 && stale != be16_to_cpu(leaf->hdr.stale)) {
 		if (!sflag || v)
 			dbprintf(_("dir %lld block %d stale mismatch "
 				 "%d/%d\n"),
