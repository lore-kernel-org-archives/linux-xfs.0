Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36A9EC6FD20
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Mar 2023 20:20:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbjCYUUX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 25 Mar 2023 16:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbjCYUUV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Mar 2023 16:20:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62AA8D31E
        for <linux-xfs@vger.kernel.org>; Sat, 25 Mar 2023 13:20:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0198560D33
        for <linux-xfs@vger.kernel.org>; Sat, 25 Mar 2023 20:20:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5B370C4339E;
        Sat, 25 Mar 2023 20:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679775620;
        bh=lPclxfd6XHmYNNRdrI16KJiUeMJRPHGEeEobwqqYkXk=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=Dvnyz/P/xeq+S0Kc3/ONP66s1wKothLw2UQOi9Z97WjcNuYBELqSiLI8jk8pFFRDa
         ngu4U28shMIBMAQK2OMI57KSovvOiPQmQsqQv+mq1ikej2A6/sCLfNSz1xLgM6o/lr
         3yAacH+5tyJIjgXz64h+AFL2K731gavYeWQu5EfCPdPviE4EEmLBImlRylVG0GmFKQ
         egEyO+REdfDVNSq882dmBuPtkFL5Klo+4Eelw9zhlAih26J+q8iIa5herGa0Ud9t55
         NqZSIAMb5hZR8Tqnm3onKUG1C3WOAZ+eOujqEy9m6MvO8AflzfeullEmtwlrVPKpOs
         b4ocGrkNYXUDA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3F278E524C0;
        Sat, 25 Mar 2023 20:20:20 +0000 (UTC)
Subject: Re: [GIT PULL 3/3] xfs: more bug fixes for 6.3-rc3
From:   pr-tracker-bot@kernel.org
In-Reply-To: <167976583288.986322.6784084002958308994.stg-ugh@frogsfrogsfrogs>
References: <167976583288.986322.6784084002958308994.stg-ugh@frogsfrogsfrogs>
X-PR-Tracked-List-Id: <linux-xfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <167976583288.986322.6784084002958308994.stg-ugh@frogsfrogsfrogs>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-6.3-fixes-7
X-PR-Tracked-Commit-Id: 4dfb02d5cae80289384c4d3c6ddfbd92d30aced9
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 5b9ff397a26aeb94180e0d459fda9731c3c617ba
Message-Id: <167977562025.2542.166806230032658097.pr-tracker-bot@kernel.org>
Date:   Sat, 25 Mar 2023 20:20:20 +0000
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     djwong@kernel.org, torvalds@linux-foundation.org,
        david@fromorbit.com, linux-xfs@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The pull request you sent on Sat, 25 Mar 2023 11:38:32 -0700:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-6.3-fixes-7

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/5b9ff397a26aeb94180e0d459fda9731c3c617ba

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
