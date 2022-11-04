Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34E88C4321E
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Nov 2022 22:52:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230527AbiKDWvt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Nov 2022 18:51:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230391AbiKDWvh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2022 18:51:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 454F1554E7;
        Fri,  4 Nov 2022 15:46:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C323DB8301A;
        Fri,  4 Nov 2022 22:46:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6E8EDC433D6;
        Fri,  4 Nov 2022 22:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667601997;
        bh=Csg/A9ePetjQy+OlGVzEMDWqrw/nwczmMvKWyt0dLSM=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=Guhxk6/aQlkOLAJqC1KIwJmd54IMLAGbJwPfttT90tC635Cs8+KMq2788YUJxn5zP
         0YlRANVkLRato8cadZ+ADLqAnX5OB8sKH4TDiJvgVXzmfcwJPSK6+1ZxetUNCX31e/
         I0bPAYzEfx82ED02vvSgF5cHm4WcxUvC8h/1HTAHZjJPsV5cI+2vZU/fk/LxWPGLJ0
         HHqXQr+YZWQkcZSjBBCXFeaJVY1C1LUaAILMiz2QEKeXhG/0BKpbaj0/cYSkREGAqe
         p1JocutOpOsnAy88UOAD2qKkN7RThSxhzJt73qS/CNv07A7Jk/LLDmZGdlpORMxCoF
         gyMfSu9ce/B6w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5C2EBE29F4C;
        Fri,  4 Nov 2022 22:46:37 +0000 (UTC)
Subject: Re: [GIT PULL] xfs: fixes for 6.1-rc4
From:   pr-tracker-bot@kernel.org
In-Reply-To: <Y2WBh0NveQU+Wo25@magnolia>
References: <Y2WBh0NveQU+Wo25@magnolia>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <Y2WBh0NveQU+Wo25@magnolia>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-6.1-fixes-4
X-PR-Tracked-Commit-Id: 4eb559dd15671cca355a61a4164e8f19e3952637
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 64c3dd0b98f586a5b7c8f5f4759ebb41cfd03861
Message-Id: <166760199737.25569.16381273890601517898.pr-tracker-bot@kernel.org>
Date:   Fri, 04 Nov 2022 22:46:37 +0000
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>, djwong@kernel.org,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        allison.henderson@oracle.com, colin.i.king@gmail.com,
        guoxuenan@huawei.com, lizetao1@huawei.com, zengheng4@huawei.com
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The pull request you sent on Fri, 4 Nov 2022 14:17:59 -0700:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-6.1-fixes-4

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/64c3dd0b98f586a5b7c8f5f4759ebb41cfd03861

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
