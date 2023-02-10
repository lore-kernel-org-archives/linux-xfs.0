Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5575C05027
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Feb 2023 17:14:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232516AbjBJROL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Feb 2023 12:14:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232604AbjBJROJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Feb 2023 12:14:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6038F27994
        for <linux-xfs@vger.kernel.org>; Fri, 10 Feb 2023 09:13:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E504DB8256F
        for <linux-xfs@vger.kernel.org>; Fri, 10 Feb 2023 17:13:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83D05C433D2
        for <linux-xfs@vger.kernel.org>; Fri, 10 Feb 2023 17:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676049229;
        bh=HLMQkC9NWI+bIgJJsRIWdGXhwUieaIEElfaSvUy7I2k=;
        h=Date:From:To:Subject:From;
        b=WFRVRMG5PREhyVW1DQ3hJupLW7TAVddtNqX+PvzVLawF4N7LyI0k5+v1xpQvHNaba
         Y3ktar4Z9ngoNEEUyfsb630kVzAth6Ovm1LDD1w3jRGwWOeE0K+vaAiIOy/gwAaYAi
         o4MWQtlUfq+0m/jD6bomW9wACAvbssbpDPMsMt/5rSjkMYX/oxNaR7XuyOoWopQ3Pn
         tgR5FLVSW1drfoIzI5eob+c3yRSW7l7qShtvSI0KUzr0kG84eZCJCasksN5KiHeaUw
         VZxIkTOobTgnyfvpp3vcxxpsS1ghwuMpVAxcbVfHcxdgsS6byZ6Xtwdb1276VcZ4Gj
         CMiz0RSRi/SfA==
Date:   Fri, 10 Feb 2023 09:13:49 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: fix uninitialized variable access
Message-ID: <Y+Z7TZ9o+KgXLcV8@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If the end position of a GETFSMAP query overlaps an allocated space and
we're using the free space info to generate fsmap info, the akeys
information gets fed into the fsmap formatter with bad results.
Zero-init the space.

Reported-by: syzbot+090ae72d552e6bd93cfe@syzkaller.appspotmail.com
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_fsmap.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 88a88506ffff..92ca2017eded 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -761,6 +761,7 @@ xfs_getfsmap_datadev_bnobt(
 {
 	struct xfs_alloc_rec_incore	akeys[2];
 
+	memset(akeys, 0, sizeof(akeys));
 	info->missing_owner = XFS_FMR_OWN_UNKNOWN;
 	return __xfs_getfsmap_datadev(tp, keys, info,
 			xfs_getfsmap_datadev_bnobt_query, &akeys[0]);
