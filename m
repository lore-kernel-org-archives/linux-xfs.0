Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A26CEB64DD
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jul 2023 18:01:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbjGTSB0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Jul 2023 14:01:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230308AbjGTSBY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Jul 2023 14:01:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7CC4270A;
        Thu, 20 Jul 2023 11:01:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E88C61931;
        Thu, 20 Jul 2023 18:01:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A070EC433C8;
        Thu, 20 Jul 2023 18:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689876082;
        bh=/de/vAtSyneXupxygQP8xvgE1IbhsGi6epuhOZ1wt+g=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=hYWDhS0+N9ivnXj47aWmKGt7diusflLlGaR7IWLbHBav4Muyiv1bStrKwe1T645YU
         3JFazYOG/cYgyROqeUrfPHapE3Em3wsz9v0mOjYAGwnwwN40P/PiSvxX4/9YSl8V1d
         pDEsu1wOGmamKGyhbGKladeJ9Dbqyq0OW2z+j87Bqe1zeNjhiL/NrNEAjngHQ0XUnG
         5all8mK37LBmomS6V7gn2quFrqBeEaWeq5wReve5vmAazV2bSTI6Bvac3JQ+NSpaTE
         ErIop8aXrHv2jhxoQTYJGZumdvhjJVRzbXaqiuFlsDItKLoRnzsJf8mPRw0ujww7l9
         Js3gegZgFdCLw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 86A5DE21EF5;
        Thu, 20 Jul 2023 18:01:22 +0000 (UTC)
Subject: Re: [GIT PULL] iomap: bug fixes for 6.5
From:   pr-tracker-bot@kernel.org
In-Reply-To: <168987161500.3212821.11938475539735933401.stg-ugh@frogsfrogsfrogs>
References: <168987161500.3212821.11938475539735933401.stg-ugh@frogsfrogsfrogs>
X-PR-Tracked-List-Id: <linux-xfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <168987161500.3212821.11938475539735933401.stg-ugh@frogsfrogsfrogs>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/iomap-6.5-fixes-1
X-PR-Tracked-Commit-Id: efa96cc99793bafe96bdbff6abab94d81472a32d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e599e16c16a16be9907fb00608212df56d08d57b
Message-Id: <168987608254.6871.13990112803761388175.pr-tracker-bot@kernel.org>
Date:   Thu, 20 Jul 2023 18:01:22 +0000
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     david@fromorbit.com, djwong@kernel.org,
        torvalds@linux-foundation.org, chrubis@suse.cz, hch@lst.de,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        oliver.sang@intel.com, ritesh.harjani@gmail.com
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The pull request you sent on Thu, 20 Jul 2023 09:48:58 -0700:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/iomap-6.5-fixes-1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e599e16c16a16be9907fb00608212df56d08d57b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
