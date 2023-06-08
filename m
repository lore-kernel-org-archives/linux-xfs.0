Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B609C7EE2E
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Jun 2023 17:27:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236392AbjFHR1U (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 8 Jun 2023 13:27:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237262AbjFHR1Q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Jun 2023 13:27:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E1731FDE
        for <linux-xfs@vger.kernel.org>; Thu,  8 Jun 2023 10:27:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F160064FCC
        for <linux-xfs@vger.kernel.org>; Thu,  8 Jun 2023 17:27:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 61B54C433D2;
        Thu,  8 Jun 2023 17:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686245231;
        bh=V7zsbWNSUv9JSIAUq60HiK4d2sfzsUKsBn8Bq5XFfv4=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=l/YS7Khs6nyDSjW5ZXJYAPXOVB1J7hwDHo+YUEg0gNe/V1UR4rDs10AtvaGW6uKrk
         v0LURncuBy7ah3TwSXBgvyGS+ZjPYXMvSm1FZ0o4FDfXz0+Aqe/pm2uxRh+PA5P223
         W6Bi8SeHBLc4nfh3PrJds5N2u4n14hWvgM8MUzZ7bJKhPYd0n7bEReRdNP3xnPwL/2
         fikbsEjTczz4Q1YoqkanTc5VJQ1lBxJ70+bUjIgn9L5sm2FKPV/Z4OKg3/twywFqmv
         OoMMLFF1/ymAuSRpGuIxCdCvRci8LrRskR36cUP2bzsF1eC3QAa8uuvTFaJomnL/Vk
         /4WvjSwM2Mo5w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4E198E87232;
        Thu,  8 Jun 2023 17:27:11 +0000 (UTC)
Subject: Re: [GIT PULL] xfs: fixes for 6.4-rc5
From:   pr-tracker-bot@kernel.org
In-Reply-To: <ZIF0vl9b+x8gejIf@dread.disaster.area>
References: <ZIF0vl9b+x8gejIf@dread.disaster.area>
X-PR-Tracked-List-Id: <linux-xfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <ZIF0vl9b+x8gejIf@dread.disaster.area>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-6.4-rc5-fixes
X-PR-Tracked-Commit-Id: d4d12c02bf5f768f1b423c7ae2909c5afdfe0d5f
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 79b6fad54683c28cc7e40d806e409abd65ed241a
Message-Id: <168624523130.6402.10823393446647556835.pr-tracker-bot@kernel.org>
Date:   Thu, 08 Jun 2023 17:27:11 +0000
To:     Dave Chinner <david@fromorbit.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>, djwong@kernel.org,
        linux-xfs@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The pull request you sent on Thu, 8 Jun 2023 16:27:10 +1000:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-6.4-rc5-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/79b6fad54683c28cc7e40d806e409abd65ed241a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
