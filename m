Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C85F3C3DA7D
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:37:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235581AbiL3XhQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:37:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235690AbiL3XhO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:37:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9C8E1DDF0
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:37:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97900B81D97
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:37:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AE8DC433D2;
        Fri, 30 Dec 2022 23:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672443431;
        bh=H3PLoBUntV/X5IMVJoAMZWNc5nO9Cx/c1Lvfo3sDSvw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=R0s5K0AHAwzYSmdUI40q6UY6hjNzE59Y9A8H+Evgx+naCT6YMMng1j7wgyOeavVLF
         PH6Csd/UCDp6InW/ZvpKZvO/HfkZm3vokwmhQGRH7I3HdvX8na7R7ViSFBYV7nQlvo
         sQX+MNQmW5AZq1GFqJrJl+D2snuivUAfSq0+rAtjC7wVAPfUqOliTm55bTP381qh53
         MoTQim7Zb+eX9WxABSLZijfwUVrF/nqPRb8UfPSDQyzNPi+pPQ68PX3wM9j2iXzHa2
         r7PzIBJ70PkINR8Ol1wjn50iiYGWTP/cqtE53lvEZdovOvu9+NVIVMT+BpRjjFXasF
         0p5US5Zj74cdQ==
Subject: [PATCH 02/11] xfs: report fs corruption errors to the health tracking
 system
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:13:14 -0800
Message-ID: <167243839488.695999.10074082285996417033.stgit@magnolia>
In-Reply-To: <167243839445.695999.12861421643354894719.stgit@magnolia>
References: <167243839445.695999.12861421643354894719.stgit@magnolia>
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
index 8b1bb228cba6..a30eab622266 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -164,6 +164,7 @@ xfs_initialize_perag_data(
 	 */
 	if (fdblocks > sbp->sb_dblocks || ifree > ialloc) {
 		xfs_alert(mp, "AGF corruption. Please run xfs_repair.");
+		xfs_fs_mark_sick(mp, XFS_SICK_FS_COUNTERS);
 		error = -EFSCORRUPTED;
 		goto out;
 	}

