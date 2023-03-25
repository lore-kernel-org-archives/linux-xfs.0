Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BB5BC6FD1F
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Mar 2023 20:20:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230399AbjCYUUW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 25 Mar 2023 16:20:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjCYUUV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Mar 2023 16:20:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E698FD31D
        for <linux-xfs@vger.kernel.org>; Sat, 25 Mar 2023 13:20:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B8B960C69
        for <linux-xfs@vger.kernel.org>; Sat, 25 Mar 2023 20:20:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E08EDC433EF;
        Sat, 25 Mar 2023 20:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679775619;
        bh=3dEEfpJGlW59Q3J9NHcZ76CD1ET8fvbiXErwOzcJYV8=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=O2CcH+TETUS7Zj5BrDeRLG7xA0DCMaJAO+0J5NLZ367HH6lU+4fB8hFFw19cQiF6Q
         bQQ8Mb3RkO0POd8MymyysPC9wikna8mryGZCUxfWv1QAD4qTnMf1KGIVbriP6xPiXN
         bVkHhBA86FNz8UWplaMuOaf9h2Ziu4QSSHeO2cRnUcLCBvzaTRYYVAmGsrvoUAOVx0
         p65MTBhFQgC4cxvRuYnO2sZ6ZxRCqCC7Os2/oUsVUGnzEX9iPyd/W7ahB5qoxRap/0
         G2mQoGu7syXQA7MAdB6HAZOCe/M4Mg+NK5LurD1fdfLhvbV0o458Z81ctfJJgK+l66
         izvRzODqppFUQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CCD60E4F0DA;
        Sat, 25 Mar 2023 20:20:19 +0000 (UTC)
Subject: Re: [GIT PULL 1/3] xfs: bug fixes for 6.3-rc2
From:   pr-tracker-bot@kernel.org
In-Reply-To: <167976583114.986322.11327553276111503462.stg-ugh@frogsfrogsfrogs>
References: <167976583114.986322.11327553276111503462.stg-ugh@frogsfrogsfrogs>
X-PR-Tracked-List-Id: <linux-xfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <167976583114.986322.11327553276111503462.stg-ugh@frogsfrogsfrogs>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-6.3-fixes-3
X-PR-Tracked-Commit-Id: 3cfb9290da3d87a5877b03bda96c3d5d3ed9fcb0
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 1470afefc3c42df5d1662f87d079b46651bdc95b
Message-Id: <167977561982.2542.350631907515805505.pr-tracker-bot@kernel.org>
Date:   Sat, 25 Mar 2023 20:20:19 +0000
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     djwong@kernel.org, torvalds@linux-foundation.org,
        david@fromorbit.com, dchinner@redhat.com, linux-xfs@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The pull request you sent on Sat, 25 Mar 2023 11:20:47 -0700:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-6.3-fixes-3

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/1470afefc3c42df5d1662f87d079b46651bdc95b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
