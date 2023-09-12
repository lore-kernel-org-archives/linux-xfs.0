Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EA08EE3F10
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Sep 2023 19:39:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231186AbjILTjx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Sep 2023 15:39:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237709AbjILTjw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Sep 2023 15:39:52 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39673E50
        for <linux-xfs@vger.kernel.org>; Tue, 12 Sep 2023 12:39:48 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C643EC433C7;
        Tue, 12 Sep 2023 19:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694547587;
        bh=NgTXVhHDbII91+hd4h/YMS2HmE5ZppFNHgqnOG4Kb2A=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=HsZWrCUAnhuciPlVYUxpuccYYEptGi8rCeTXaXaXj/TKTiDdElfedCz47Z7qy943t
         u9gMcsxJmuwQlyti0qUc5k9o0HXgNZgFBMFuEx41tgjoj6Sv/JEh6MBjAtJMNt1u0w
         9HQ4HuFB+3NHwc0bC3nRxYGBYUwhuDH7EHpRjMJY1eweR284mthqp5EU5tVVONZDI0
         c1lxfs7/eJu7vdCtwYbjtkgzV2phPc3ORBBXx9Cc5DFxQG6RzitbUaJOGI9+sglJZ3
         Fj9d1KQE9yUi8vToBCrO/K/1y3PMXkwlSzcLQWQS//eLPojOlEAyPJWPCR3+Qx0vhM
         RND9GK1yq+e7Q==
Subject: [PATCH 2/6] libfrog: don't fail on XFS_FSOP_GEOM_FLAGS_NREXT64 in
 xfrog_bulkstat_single5
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 12 Sep 2023 12:39:47 -0700
Message-ID: <169454758720.3539425.12997334128444146623.stgit@frogsfrogsfrogs>
In-Reply-To: <169454757570.3539425.3597048437340386509.stgit@frogsfrogsfrogs>
References: <169454757570.3539425.3597048437340386509.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

This flag is perfectly acceptable for bulkstatting a single file;
there's no reason not to allow it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libfrog/bulkstat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/libfrog/bulkstat.c b/libfrog/bulkstat.c
index 0a90947fb29..c863bcb6bf8 100644
--- a/libfrog/bulkstat.c
+++ b/libfrog/bulkstat.c
@@ -53,7 +53,7 @@ xfrog_bulkstat_single5(
 	struct xfs_bulkstat_req		*req;
 	int				ret;
 
-	if (flags & ~(XFS_BULK_IREQ_SPECIAL))
+	if (flags & ~(XFS_BULK_IREQ_SPECIAL | XFS_BULK_IREQ_NREXT64))
 		return -EINVAL;
 
 	if (xfd->fsgeom.flags & XFS_FSOP_GEOM_FLAGS_NREXT64)

