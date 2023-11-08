Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E110C4332F
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Nov 2023 21:34:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232135AbjKHVei (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Nov 2023 16:34:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232056AbjKHVei (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Nov 2023 16:34:38 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 162671FCE
        for <linux-xfs@vger.kernel.org>; Wed,  8 Nov 2023 13:34:36 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AA6CAC433C7;
        Wed,  8 Nov 2023 21:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1699479275;
        bh=5EvGUdYLYqyi4ZMwGxn2WzczuJ9GNl7+hCZ37o0W/ds=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=UoMb2fBDF01S3n0hR7EtexgTSf3G3JrxfuNO7B82p7s7/7x7BWqjjt2+giPykBLqe
         KHo50IBfNCQgfH+JWD4hEBq8dzKsQuEzv/QlX1Q++/rnV34VisGP1PPOkQ19xVXkEm
         x8jNUQMO6zRXztmMeI2MB2561XsEE+SEDFAY3pFxmYIQ4nGAM40IXbDx4lKLANSnb0
         bHHM1GRWFky/GpQYix3n87kz0PP28xhtrfuQGiqJrryC43wAMTfIzJo/vhAKwHTTpm
         UAJLt6peNH8/4D1YdzE852WjYnR9qlgdSzJ3bRVbIkbX/a/NyrCFjIvLmXXBqRSl3T
         uaRq342M5usdg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 98FE8E00081;
        Wed,  8 Nov 2023 21:34:35 +0000 (UTC)
Subject: Re: [GIT PULL] xfs: new code for 6.7
From:   pr-tracker-bot@kernel.org
In-Reply-To: <87fs1g1rac.fsf@debian-BULLSEYE-live-builder-AMD64>
References: <87fs1g1rac.fsf@debian-BULLSEYE-live-builder-AMD64>
X-PR-Tracked-List-Id: <linux-xfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <87fs1g1rac.fsf@debian-BULLSEYE-live-builder-AMD64>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-6.7-merge-2
X-PR-Tracked-Commit-Id: 14a537983b228cb050ceca3a5b743d01315dc4aa
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 34f763262743aac0847b15711b0460ac6d6943d5
Message-Id: <169947927562.28494.985381701076184538.pr-tracker-bot@kernel.org>
Date:   Wed, 08 Nov 2023 21:34:35 +0000
To:     Chandan Babu R <chandanbabu@kernel.org>
Cc:     torvalds@linux-foundation.org, chandanbabu@kernel.org,
        catherine.hoang@oracle.com, cheng.lin130@zte.com.cn,
        dchinner@redhat.com, djwong@kernel.org, hch@lst.de,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        osandov@fb.com
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The pull request you sent on Wed, 08 Nov 2023 15:26:29 +0530:

> https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-6.7-merge-2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/34f763262743aac0847b15711b0460ac6d6943d5

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
