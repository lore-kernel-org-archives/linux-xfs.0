Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 498CDC2BB3F
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Nov 2023 18:31:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbjKTSbh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Nov 2023 13:31:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbjKTSbh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Nov 2023 13:31:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27DE0C4
        for <linux-xfs@vger.kernel.org>; Mon, 20 Nov 2023 10:31:34 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7730C433C8;
        Mon, 20 Nov 2023 18:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1700505093;
        bh=CduehlGGcqOta7QkxTndPzSst5waCJrcbQQtjEIazYU=;
        h=Subject:From:To:Cc:Date:From;
        b=A9z0GFc34OeS4W4BLibyQoc899Lh6LJ1Wjr+j5wMQSDQ/VY7yRRI5JnmhysNBvkqG
         qdljvMS9l3AXaDhBwLfKELWNyMMATcdNMStJwsJQ598zrcNpZApLLnGBbX/tLnUL1Q
         wdy4IEYwYnbVQRdGoep6IZ2kKlVQNtmk4dAPJe7CFFojoIFcXZCeSqQb6GSpLeHeSX
         jxPcgIkXSMq1xsX8XjdhArIlrayhhlvbAKrAld2gLXq5t/nWHSbZMuiw3Zie23V0nL
         IsuhJADv8ofOw+RmUBmKMW9wZSqZ0I6fnFFE8cdpMR+ucQEGdkGFdZCljReqC3Skuq
         xN1oY5ILdZLEw==
Subject: [PATCHSET 0/2] xfs: dquot recovery validation strengthening
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     david@fromorbit.com, djwong@kernel.org, chandanbabu@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 20 Nov 2023 10:31:33 -0800
Message-ID: <170050509316.475996.582959032103929936.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

During my review of Dave's patches that fixed an inode recovery issue
with nrext64 enabled on s390x, it occurred to me that recovery doesn't
actually validate the ondisk dquot record after a replay.  In the past
we didn't do that for inodes or buffers either, but now we do.

This series adds the missing validation for dquots, and cleans up some
open coded pointer handling to avoid leaving logic bombs.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been lightly tested with fstests.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=dquot-recovery-checking-6.7
---
 fs/xfs/xfs_dquot.c              |    5 +++--
 fs/xfs/xfs_dquot_item_recover.c |   21 ++++++++++++++++++---
 2 files changed, 21 insertions(+), 5 deletions(-)

