Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D0C1C77B7C
	for <linux-xfs@archiver.kernel.org>; Thu, 11 May 2023 22:04:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239412AbjEKWES (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 May 2023 18:04:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239496AbjEKWEQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 May 2023 18:04:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 133F6559F
        for <linux-xfs@vger.kernel.org>; Thu, 11 May 2023 15:04:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E92B65171
        for <linux-xfs@vger.kernel.org>; Thu, 11 May 2023 22:04:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 016B3C433D2;
        Thu, 11 May 2023 22:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683842655;
        bh=h74Y8Kuop4nYh80iFyJ/2kS6iGEOxawapY0oXJ+qU1A=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=f4eDKbnc107AeylTX1tVC1iQSUBSeV9eI11Hd4+Im2jeraq0eJOFXbAPsI5F0KNeg
         O2RIlFwHN0w6sBP6qB4AQgsdmbf8QzzwrUY8lROMBf9Dl1ZXOtBQV3DT+O6eMiFkfe
         TkiYTxuZNPQhmCM4IjZkinEc9u0zZz3jcSeG3CmIHrYGL4OQTb5PcKi3+j+puhVatJ
         RAMYk3qS57UwxOKERa3pppJoxisv6IHgsBVhp4zt3V/sU5sgvDnhpaGEhC1fnYJ68T
         t8egwlyVQ46gr+nAKLvtepnm/Z1wwrhc0daDO575GKfSBV4T41+6+th4xZjfg9kyOq
         n+9a3cKbFG8mg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E4A41E26D4C;
        Thu, 11 May 2023 22:04:14 +0000 (UTC)
Subject: Re: [GIT PULL] xfs: bug fixes for 6.4-rc2
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20230511020107.GI2651828@dread.disaster.area>
References: <20230511015846.GH2651828@dread.disaster.area> <20230511020107.GI2651828@dread.disaster.area>
X-PR-Tracked-List-Id: <linux-xfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <20230511020107.GI2651828@dread.disaster.area>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-6.4-rc1-fixes
X-PR-Tracked-Commit-Id: 2254a7396a0ca6309854948ee1c0a33fa4268cec
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 849a4f09730ba3c02da01924c7a6e7a000a4d27c
Message-Id: <168384265493.22863.2683852857659893778.pr-tracker-bot@kernel.org>
Date:   Thu, 11 May 2023 22:04:14 +0000
To:     Dave Chinner <david@fromorbit.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>, djwong@kernel.org,
        linux-xfs@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The pull request you sent on Thu, 11 May 2023 12:01:07 +1000:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-6.4-rc1-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/849a4f09730ba3c02da01924c7a6e7a000a4d27c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
