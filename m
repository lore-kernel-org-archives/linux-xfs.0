Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEFF5C77B60
	for <linux-xfs@archiver.kernel.org>; Sat, 29 Apr 2023 18:20:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230266AbjD2SUI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 29 Apr 2023 14:20:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230268AbjD2SUG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 29 Apr 2023 14:20:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 875C6210E
        for <linux-xfs@vger.kernel.org>; Sat, 29 Apr 2023 11:19:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2291D60C00
        for <linux-xfs@vger.kernel.org>; Sat, 29 Apr 2023 18:19:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8B65AC433D2;
        Sat, 29 Apr 2023 18:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682792398;
        bh=UGT9zW9OQ0pqXADae7BW7cgD3EpvMH4ro0CRfClzft4=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=In20XaVEawoU4rJJmm7LqdRDEnYVgAin74u1PMOT6QOTrLCEGw0QrVRd5mDrA9SVF
         UQ8JHOdjYi3sZtA8LvbKEH54uk2KJ1wNBaM70ytCvEN2kbvb+1f3xaryFKt2Px+qxq
         lvq1NtpogwSGSp+z6Nli3LCFsDsm/GOBnD6/94g1/3PACpclU0iRS9Ykp7vcP9Ddjt
         QO8I0IC+pOm39+JvpWrUb1E6GnOathab/IPMDIdC8dDtPevDvTjfZjo1bD4Xvdhlx1
         cT7qDg99RUmuz6YbfMSnuQKUx7+sDzCOqIa5JfZc3WwAMKkgAGUSdwlQi90B8INlu7
         NPkR9+OmaqtxQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 79259E5FFC8;
        Sat, 29 Apr 2023 18:19:58 +0000 (UTC)
Subject: Re: [GIT PULL] xfs: new code for 6.4
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20230428231655.GW3223426@dread.disaster.area>
References: <20230428231655.GW3223426@dread.disaster.area>
X-PR-Tracked-List-Id: <linux-xfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <20230428231655.GW3223426@dread.disaster.area>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-6.4-merge-1
X-PR-Tracked-Commit-Id: 9419092fb2630c30e4ffeb9ef61007ef0c61827a
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 56c455b38dba47ae9cb48d71b2a106d769d1a694
Message-Id: <168279239849.22076.1142373983357443474.pr-tracker-bot@kernel.org>
Date:   Sat, 29 Apr 2023 18:19:58 +0000
To:     Dave Chinner <david@fromorbit.com>
Cc:     torvalds@linux-foundation.org, djwong@kernel.org,
        linux-xfs@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The pull request you sent on Sat, 29 Apr 2023 09:16:55 +1000:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-6.4-merge-1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/56c455b38dba47ae9cb48d71b2a106d769d1a694

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
