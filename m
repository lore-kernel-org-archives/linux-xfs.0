Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 723A8C77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:00:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbjEZBAn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:00:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjEZBAm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:00:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43AC812E
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:00:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D5E02610A2
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:00:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48502C433EF;
        Fri, 26 May 2023 01:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685062841;
        bh=DSUKD+2IfjI9/ymlgsfGlFS+zmong1Oo1glJhw1vVkw=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=rLG9O+ZhDLHp7JbwkoSQsuflWGvXEHZ5KPkki9HauLdJn0arE5cizwBdmrTdidmBt
         N4z4V9/x4Dc/HST9RUti8Ov9VDGdVyVc3AD74kplwPT2MTOqDjY6TVHdU32IAnu5JX
         EmqXcYUbL+wxW1MjQNAifOdUEF2poWOIh/peSz2Mj83ADnoepwwYwHk28cADgR+mOX
         +HeXsqSKst+eKOu97qWNz4c7AMOYzwS9ftDmLe3JbtSSsYb3IZ5IPHow6H7HlRlhtC
         lBFncaux4ix9HZt0rkz7vswQrBSuKLbC6oOoj0Z9oiEqTXOxAMTErbmTy6R+EHzB0+
         wIpLLvLQLCXWA==
Date:   Thu, 25 May 2023 18:00:40 -0700
Subject: [PATCH 02/11] xfs: report fs corruption errors to the health tracking
 system
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506060702.3732173.1577974190864443903.stgit@frogsfrogsfrogs>
In-Reply-To: <168506060658.3732173.4915476844741652700.stgit@frogsfrogsfrogs>
References: <168506060658.3732173.4915476844741652700.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Whenever we encounter corrupt fs metadata, we should report that to the
health monitoring system for later reporting.  A convenient program for
identifying places to insert xfs_*_mark_sick calls is as follows:

#!/bin/bash

# Detect missing calls to xfs_*_mark_sick

filter=cat
tty -s && filter=less

git grep -B3 EFSCORRUPTED fs/xfs/*.[ch] fs/xfs/libxfs/*.[ch] fs/xfs/scrub/*.[ch] | awk '
BEGIN {
	ignore = 0;
	lineno = 0;
	delete lines;
}
{
	if ($0 == "--") {
		if (!ignore) {
			for (i = 0; i < lineno; i++) {
				print(lines[i]);
			}
			printf("--\n");
		}
		delete lines;
		lineno = 0;
		ignore = 0;
	} else if ($0 ~ /mark_sick/) {
		ignore = 1;
	} else if ($0 ~ /if .fa/) {
		ignore = 1;
	} else if ($0 ~ /failaddr/) {
		ignore = 1;
	} else if ($0 ~ /_verifier_error/) {
		ignore = 1;
	} else if ($0 ~ /^ \* .*EFSCORRUPTED/) {
		ignore = 1;
	} else if ($0 ~ /== -EFSCORRUPTED/) {
		ignore = 1;
	} else if ($0 ~ /!= -EFSCORRUPTED/) {
		ignore = 1;
	} else {
		lines[lineno++] = $0;
	}
}
' | $filter

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ag.c |    1 +
 1 file changed, 1 insertion(+)


diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 9b373a0c7aaf..e9235dd78337 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -217,6 +217,7 @@ xfs_initialize_perag_data(
 	 */
 	if (fdblocks > sbp->sb_dblocks || ifree > ialloc) {
 		xfs_alert(mp, "AGF corruption. Please run xfs_repair.");
+		xfs_fs_mark_sick(mp, XFS_SICK_FS_COUNTERS);
 		error = -EFSCORRUPTED;
 		goto out;
 	}

