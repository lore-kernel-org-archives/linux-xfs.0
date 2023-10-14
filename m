Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28950CDB465
	for <linux-xfs@archiver.kernel.org>; Sat, 14 Oct 2023 16:15:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233237AbjJNQPA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 14 Oct 2023 12:15:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233227AbjJNQO7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 14 Oct 2023 12:14:59 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBBD7A9
        for <linux-xfs@vger.kernel.org>; Sat, 14 Oct 2023 09:14:57 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5A869C433C8;
        Sat, 14 Oct 2023 16:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697300097;
        bh=OKeSvqj54PhQyIp2lsQinU0daZ802sieG/BNv/pYqRk=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=JjvDhyXDbuEXy+8bSqaeQ/jdilArumXKnHv0FK+PplDaNGro8klvauARvtOq/Rk4N
         xcM7cqbXYxdUkOyM48+ZkBGajpcGH0DEuxPDU0e5uihtrszIAYfnAWYTk0aH2vqiMK
         wmf+2DrOoAuTUB0PK5w4TOyHyF1EDrWFOWgTGSaRNMTAJFdVacpbyG4jNKRf3mlQHG
         ncrc22csZ8pgJVpvvoP6b0UMDEgiXjoWPY0mupeOOi7wjwcoJUTsXZHavwuIje0zZC
         PnZOyJ1M8E3ur6kA/vrrEsmSAAhIZEzbxd6Eod2vWiSfMtGrCpOjOe9HiWPuulCs7z
         0QpCulqk7u74w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 48587C1614E;
        Sat, 14 Oct 2023 16:14:57 +0000 (UTC)
Subject: Re: [GIT PULL] xfs: bug fixes for 6.6
From:   pr-tracker-bot@kernel.org
In-Reply-To: <87o7h1eb12.fsf@debian-BULLSEYE-live-builder-AMD64>
References: <87o7h1eb12.fsf@debian-BULLSEYE-live-builder-AMD64>
X-PR-Tracked-List-Id: <linux-fsdevel.vger.kernel.org>
X-PR-Tracked-Message-Id: <87o7h1eb12.fsf@debian-BULLSEYE-live-builder-AMD64>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git xfs-6.6-fixes-5
X-PR-Tracked-Commit-Id: cbc06310c36f73a5f3b0c6f0d974d60cf66d816b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 70f8c6f8f8800d970b10676cceae42bba51a4899
Message-Id: <169730009728.8595.8665112790994175339.pr-tracker-bot@kernel.org>
Date:   Sat, 14 Oct 2023 16:14:57 +0000
To:     Chandan Babu R <chandanbabu@kernel.org>
Cc:     torvalds@linux-foundation.org, abaci@linux.alibaba.com,
        djwong@kernel.org, jiapeng.chong@linux.alibaba.com,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        ruansy.fnst@fujitsu.com
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The pull request you sent on Sat, 14 Oct 2023 16:14:27 +0530:

> https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git xfs-6.6-fixes-5

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/70f8c6f8f8800d970b10676cceae42bba51a4899

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
