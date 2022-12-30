Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9060C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:49:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236240AbiLaCtB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:49:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236244AbiLaCtA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:49:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF18F193D7
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:48:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 77A8461BF8
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:48:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9C8DC433EF;
        Sat, 31 Dec 2022 02:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672454938;
        bh=HWlS4zGyqAPQimj89AFp0xqUZ//Q4trTc8wBVoAUGoo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=kABhjptsfRier5kvKMuXts+1/xv68GqXq+cNJ9HtZUjIe7f7dXX5+fVZFdAr7BkYX
         Y4x1eNRkw8WjQm3vwL1rS6Z9I0qQ5fDg0gqea6H6VxIogjET2rAfHogg7vmvIINDf3
         7d8zKR8ssWyXyRzJKUmKjueZNPyWkMjKKaChsSWHaqKDkBXSCrbRZlPpisx+I79eM8
         YsinWiUWlTtJ+51+WOKce4zd3OIi2w2XJoQDFsyNJfnQD+FzhP7fwYNTLksVKkdchj
         /ksDBNdk3+PcL7x9pLZw2t+08H+CV9b8wlUTUiOPg+0zLdc0iCc47+Ipxh5o0ONZyS
         nFXct/iFfCQ2w==
Subject: [PATCH 25/41] libfrog: enable scrubbng of the realtime rmap
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:59 -0800
Message-ID: <167243879926.732820.2779512900277248774.stgit@magnolia>
In-Reply-To: <167243879574.732820.4725863402652761218.stgit@magnolia>
References: <167243879574.732820.4725863402652761218.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add a new entry so that we can scrub the rtrmapbt.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libfrog/scrub.c |    5 +++++
 scrub/repair.c  |    1 +
 2 files changed, 6 insertions(+)


diff --git a/libfrog/scrub.c b/libfrog/scrub.c
index 7efb7ecfbd0..6f12ec72b22 100644
--- a/libfrog/scrub.c
+++ b/libfrog/scrub.c
@@ -159,6 +159,11 @@ const struct xfrog_scrub_descr xfrog_scrubbers[XFS_SCRUB_TYPE_NR] = {
 		.descr	= "realtime group bitmap",
 		.group	= XFROG_SCRUB_GROUP_RTGROUP,
 	},
+	[XFS_SCRUB_TYPE_RTRMAPBT] = {
+		.name	= "rtrmapbt",
+		.descr	= "realtime reverse mapping btree",
+		.group	= XFROG_SCRUB_GROUP_RTGROUP,
+	},
 };
 #undef DEP
 
diff --git a/scrub/repair.c b/scrub/repair.c
index 10db103c87f..79a15f907a1 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -400,6 +400,7 @@ repair_item_difficulty(
 
 		switch (scrub_type) {
 		case XFS_SCRUB_TYPE_RMAPBT:
+		case XFS_SCRUB_TYPE_RTRMAPBT:
 			ret |= REPAIR_DIFFICULTY_SECONDARY;
 			break;
 		case XFS_SCRUB_TYPE_SB:

